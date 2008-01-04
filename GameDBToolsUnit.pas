unit GameDBToolsUnit;
interface

uses Classes, ComCtrls, Controls, GameDBUnit;

{ Load Data to GUI }

Type TSortListBy=(slbName, slbSetup, slbGenre, slbDeveloper, slbPublisher, slbYear, slbLanguage);

Procedure InitTreeViewForGamesList(const ATreeView : TTreeView; const GameDB : TGameDB);
Procedure InitListViewForGamesList(const AListView : TListView; const ShowExtraInfo : Boolean);

Procedure AddGameToList(const AListView : TListView; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const Game : TGame; const ShowExtraInfo : Boolean);
Procedure AddGamesToList(const AListView : TListView; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const GameDB : TGameDB; const Group, SubGroup, SearchString : String; const ShowExtraInfo : Boolean; const SortBy : TSortListBy; const ReverseOrder : Boolean);

Procedure AddScreenshotsToList(const AListView : TListView; const AImageList : TImageList; Dir : String);

Procedure GetColOrderAndVisible(var O,V : String);
Procedure SetSortTypeByListViewCol(const ColumnIndex : Integer; var ListSort : TSortListBy; var ListSortReverse : Boolean);

{ Upgrade from D-Fend }

Procedure DeleteOldFiles;
Procedure ReplaceAbsoluteDirs(const GameDB : TGameDB);
Function BuildDefaultDosProfile(const GameDB : TGameDB) : TGame;
Procedure BuildDefaultProfile;

{ Extras }

Procedure ExportGamesList(const GameDB : TGameDB; const FileName : String);
Procedure EditDefaultProfile(const AOwner : TComponent; const GameDB : TGameDB);

{ History }

Procedure AddToHistory(const GameName : String);
Procedure LoadHistory(const AListView : TListView);
Procedure ClearHistory;

{ Import }

Function ImportConfFile(const AGameDB : TGameDB; const AFileName : String) : TGame;

implementation

uses Windows, SysUtils, Dialogs, Graphics, Math, IniFiles, PNGImage, CommonTools,
     LanguageSetupUnit, PrgConsts, PrgSetupUnit, ProfileEditorFormUnit;

Procedure AddTypeSelector(const ATreeView : TTreeView; const Name : String; const St : TStringList);
Var N,N2 : TTreeNode;
    I : Integer;
    S : String;
begin
  try
    N:=ATreeView.Items.AddChild(nil,Name);
    N.ImageIndex:=12;
    N.SelectedIndex:=12;
    For I:=0 to St.Count-1 do begin
      S:=St[I];
      If S='' then S:=LanguageSetup.NotSet;
      N2:=ATreeView.Items.AddChild(N,S);
      N2.ImageIndex:=10;
      N2.SelectedIndex:=10;
    end
  finally
    St.Free;
  end;
end;

Procedure InitTreeViewForGamesList(const ATreeView : TTreeView; const GameDB : TGameDB);
Var N : TTreeNode;
    Group, SubGroup : String;
    I : Integer;
    OnChange : TTVChangedEvent;
begin
  OnChange:=ATreeView.OnChange;
  ATreeView.OnChange:=nil;
  try
    ATreeView.ReadOnly:=True;

    If ATreeView.Selected=nil then begin Group:=''; SubGroup:=''; end else begin
      If ATreeView.Selected.Parent=nil then begin
        Group:=ATreeView.Selected.Text; SubGroup:='';
      end else begin
        Group:=ATreeView.Selected.Parent.Text;
        SubGroup:=ATreeView.Selected.Text;
      end;
    end;

    ATreeView.Items.BeginUpdate;
    try
      ATreeView.Items.Clear;

      N:=ATreeView.Items.AddChild(nil,RemoveUnderline(LanguageSetup.All));
      N.ImageIndex:=8;
      N.SelectedIndex:=8;

      N:=ATreeView.Items.AddChild(nil,LanguageSetup.GameFavorites);
      N.ImageIndex:=9;
      N.SelectedIndex:=9;

      AddTypeSelector(ATreeView,LanguageSetup.GameGenre,GameDB.GetGenreList);
      AddTypeSelector(ATreeView,LanguageSetup.GameDeveloper,GameDB.GetDeveloperList);
      AddTypeSelector(ATreeView,LanguageSetup.GamePublisher,GameDB.GetPublisherList);
      AddTypeSelector(ATreeView,LanguageSetup.GameYear,GameDB.GetYearList);
      AddTypeSelector(ATreeView,LanguageSetup.GameLanguage,GameDB.GetLanguageList);

      If Group='' then exit;

      For I:=0 to ATreeview.Items.Count-1 do begin
        If SubGroup='' then begin
          If (ATreeView.Items[I].Parent=nil) and (ATreeView.Items[I].Text=Group) then begin ATreeView.Selected:=ATreeView.Items[I]; exit; end;
        end else begin
          If (ATreeView.Items[I].Parent<>nil) and (ATreeView.Items[I].Text=SubGroup) and (ATreeView.Items[I].Parent.Text=Group) then begin ATreeView.Selected:=ATreeView.Items[I]; exit; end;
        end;
      end;

    finally
      ATreeView.Items.EndUpdate;
    end;
  finally
    ATreeView.OnChange:=OnChange;
  end;
end;

Procedure GetColOrderAndVisible(var O,V : String);
begin
  V:=PrgSetup.ColVisible;
  while length(V)<6 do V:=V+'1';
  If Length(V)>6 then V:=Copy(V,1,6);
  PrgSetup.ColVisible:=V;

  O:=PrgSetup.ColOrder;
  while length(O)<6 do O:=O+'1';
  If Length(O)>6 then O:=Copy(O,1,6);
  PrgSetup.ColOrder:=O;
end;

Procedure SetSortTypeByListViewCol(const ColumnIndex : Integer; var ListSort : TSortListBy; var ListSortReverse : Boolean);
Procedure SetListSort(const L : TSortListBy);
begin
  If ListSort=L then ListSortReverse:=not ListSortReverse else begin ListSort:=L; ListSortReverse:=False; end;
end;
Var O,V : String;
    I,Nr,C : Integer;
begin
  GetColOrderAndVisible(O,V);

  If ColumnIndex=0 then SetListSort(slbName) else begin
    If not PrgSetup.ShowExtraInfo then SetListSort(slbSetup) else begin
      C:=0;
      For I:=0 to 5 do begin
        try Nr:=StrToInt(O[I+1]); except Nr:=-1; end;
        If (Nr<1) or (Nr>6) then continue;
        If V[Nr]='0' then continue;
        inc(C);
        If C=ColumnIndex then begin
          Case Nr-1 of
            0 : SetListSort(slbSetup);
            1 : SetListSort(slbGenre);
            2 : SetListSort(slbDeveloper);
            3 : SetListSort(slbPublisher);
            4 : SetListSort(slbYear);
            5 : SetListSort(slbLanguage);
          end;
          break;
        end;
      end;
    end;
  end;
end;


Procedure InitListViewForGamesList(const AListView : TListView; const ShowExtraInfo : Boolean);
Var C : TListColumn;
    I,Nr : Integer;
    V,O : String;
begin
  AListView.ReadOnly:=True;

  GetColOrderAndVisible(O,V);

  AListView.Columns.BeginUpdate;
  AListView.Items.BeginUpdate;
  try
    AListView.Items.Clear;
    AListView.Columns.Clear;

    C:=AListView.Columns.Add;
    C.Caption:=LanguageSetup.GameName;
    C.Width:=-1;

    If not ShowExtraInfo then begin
      C:=AListView.Columns.Add;
      C.Caption:=LanguageSetup.GameSetup;
      C.Width:=-2;
      exit;
    end;

    For I:=0 to 5 do begin
      try Nr:=StrToInt(O[I+1]); except Nr:=-1; end;
      If (Nr<1) or (Nr>6) then continue;
      If V[Nr]='0' then continue;

      C:=AListView.Columns.Add;
      Case Nr-1 of
        0 : C.Caption:=LanguageSetup.GameSetup;
        1 : C.Caption:=LanguageSetup.GameGenre;
        2 : C.Caption:=LanguageSetup.GameDeveloper;
        3 : C.Caption:=LanguageSetup.GamePublisher;
        4 : C.Caption:=LanguageSetup.GameYear;
        5 : C.Caption:=LanguageSetup.GameLanguage;
      end;
      If Nr-1=0 then C.Width:=-2 else C.Width:=-1;
    end;
  finally
    AListView.Columns.EndUpdate;
    AListView.Items.EndUpdate;
  end;
end;

Procedure AddGameToList(const AListView : TListView; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const Game : TGame; const ShowExtraInfo : Boolean);
Var IconNr,I,Nr : Integer;
    Icon : TIcon;
    B : Boolean;
    V,O : String;
    S,T : String;
begin
  GetColOrderAndVisible(O,V);

  If Trim(Game.Icon)='' then begin
    IconNr:=0;
  end else begin
    Icon:=TIcon.Create;
    try
      B:=True; try Icon.LoadFromFile(IncludeTrailingPathDelimiter(PrgDataDir+IconsSubDir)+Game.Icon); except B:=False; end;
      If B then begin
        AListViewImageList.AddIcon(Icon);
        AListViewIconImageList.AddIcon(Icon);
      end;
    finally
      Icon.Free;
    end;
    If B then IconNr:=AListViewImageList.Count-1 else IconNr:=0;
  end;

  AListView.AddItem(Game.CacheName,Game);

  with AListView.Items[AListView.Items.Count-1] do begin
    Data:=Game;

    If ShowExtraInfo then begin
      T:=LanguageSetup.NotSet;
      For I:=0 to 5 do begin
        try Nr:=StrToInt(O[I+1]); except Nr:=-1; end;
        If (Nr<1) or (Nr>6) then continue;
        If V[Nr]='0' then continue;

        Case Nr-1 of
          0 : If Trim(Game.SetupExe)<>''
                then SubItems.Add(RemoveUnderline(LanguageSetup.Yes))
                else SubItems.Add(RemoveUnderline(LanguageSetup.No));
          1 : begin S:=Game.CacheGenre; If Trim(S)='' then SubItems.Add(T) else SubItems.Add(S); end;
          2 : begin S:=Game.CacheDeveloper; If Trim(S)='' then SubItems.Add(T) else SubItems.Add(S); end;
          3 : begin S:=Game.CachePublisher; If Trim(S)='' then SubItems.Add(T) else SubItems.Add(S); end;
          4 : begin S:=Game.CacheYear; If Trim(S)='' then SubItems.Add(T) else SubItems.Add(S); end;
          5 : begin S:=Game.CacheLanguage; If Trim(S)='' then SubItems.Add(T) else SubItems.Add(S); end;
        end;
      end;
    end else begin
      If Trim(Game.SetupExe)<>''
        then SubItems.Add(RemoveUnderline(LanguageSetup.Yes))
        else SubItems.Add(RemoveUnderline(LanguageSetup.No));
    end;
    ImageIndex:=IconNr;
  end;
end;

Procedure AddGamesToList(const AListView : TListView; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const GameDB : TGameDB; const Group, SubGroup, SearchString : String; const ShowExtraInfo : Boolean; const SortBy : TSortListBy; const ReverseOrder : Boolean);
Var I,Nr : Integer;
    SubGroupUpper, SearchStringUpper : String;
    B : Boolean;
    C : Array of Integer;
    List : TList;
    St : TStringList;
begin
  {Prepare ListView}
  AListViewImageList.Clear;
  AListViewImageList.AddImage(AImageList,0);
  AListViewIconImageList.Clear;
  AListViewIconImageList.AddImage(AImageList,0);
  SetLength(C,AListView.Columns.Count);
  For I:=0 to length(C)-1 do begin C[I]:=AListView.Columns[I].Width; AListView.Columns[I].Width:=1; end;

  List:=TList.Create;
  try
    {Select game to add}
    SearchStringUpper:=ExtUpperCase(Trim(SearchString));
    If SubGroup='' then begin
      B:=(Group=LanguageSetup.GameFavorites);
      for I:=0 to GameDB.Count-1 do begin
        If B and (not GameDB[I].Favorite) then continue;
        If (SearchStringUpper<>'') and (Pos(SearchStringUpper,ExtUpperCase(GameDB[I].Name))=0) then continue;
        List.Add(GameDB[I]);
      end;
    end else begin
      If SubGroup=LanguageSetup.NotSet then SubGroupUpper:='' else SubGroupUpper:=ExtUpperCase(SubGroup);
      Nr:=0;
      If Group=LanguageSetup.GameGenre then Nr:=0;
      If Group=LanguageSetup.GameDeveloper then Nr:=1;
      If Group=LanguageSetup.GamePublisher then Nr:=2;
      If Group=LanguageSetup.GameYear then Nr:=3;
      If Group=LanguageSetup.GameLanguage then Nr:=4;

      For I:=0 to GameDB.Count-1 do begin
        B:=False;
        Case Nr of
          0 : B:=(ExtUpperCase(GameDB[I].CacheGenre)=SubGroupUpper);
          1 : B:=(ExtUpperCase(GameDB[I].CacheDeveloper)=SubGroupUpper);
          2 : B:=(ExtUpperCase(GameDB[I].CachePublisher)=SubGroupUpper);
          3 : B:=(ExtUpperCase(GameDB[I].CacheYear)=SubGroupUpper);
          4 : B:=(ExtUpperCase(GameDB[I].CacheLanguage)=SubGroupUpper);
        end;
        If not B then continue;
        If (SearchStringUpper<>'') and (Pos(SearchStringUpper,ExtUpperCase(GameDB[I].CacheName))=0) then continue;
        List.Add(GameDB[I]);
      end;
    end;

    {Sort games}
    St:=TStringList.Create;
    try
      For I:=0 to List.Count-1 do Case SortBy of
        slbName : St.AddObject(TGame(List[I]).Name,TGame(List[I]));
        slbSetup : If Trim(TGame(List[I]).SetupExe)<>''
                     then St.AddObject(RemoveUnderline(LanguageSetup.Yes),TGame(List[I]))
                     else St.AddObject(RemoveUnderline(LanguageSetup.No),TGame(List[I]));
        slbGenre : St.AddObject(TGame(List[I]).Genre,TGame(List[I]));
        slbDeveloper : St.AddObject(TGame(List[I]).Developer,TGame(List[I]));
        slbPublisher : St.AddObject(TGame(List[I]).Publisher,TGame(List[I]));
        slbYear : St.AddObject(TGame(List[I]).Year,TGame(List[I]));
        slbLanguage : St.AddObject(TGame(List[I]).Language,TGame(List[I]));
      End;
      St.Sort;

      {Add games to List}
      If ReverseOrder then begin
        For I:=St.Count-1 downto 0 do AddGameToList(AListView,AListViewImageList,AListViewIconImageList,AImageList,TGame(St.Objects[I]),ShowExtraInfo);
      end else begin
        For I:=0 to St.Count-1 do AddGameToList(AListView,AListViewImageList,AListViewIconImageList,AImageList,TGame(St.Objects[I]),ShowExtraInfo);
      end;
    finally
      St.Free;
    end;
  finally
    List.Free;
    For I:=0 to length(C)-1 do AListView.Columns[I].Width:=C[I];
  end;
end;

Procedure AddScreenshotsToList(const AListView : TListView; const AImageList : TImageList; Dir : String);
Var I : Integer;
    Rec : TSearchRec;
    P : TPNGObject;
    B,B2 : TBitmap;
    L : TListItem;
begin
  Dir:=IncludeTrailingPathDelimiter(Dir);
  I:=FindFirst(Dir+'*.png',faAnyFile,Rec);
  try
    while I=0 do begin
      P:=TPNGObject.Create;
      try
        P.LoadFromFile(Dir+Rec.Name);
        B:=TBitmap.Create;
        try
          B.Assign(P);
          B2:=TBitmap.Create;
          try
            B2.SetSize(AImageList.Width,AImageList.Height);
            B2.Canvas.StretchDraw(Rect(0,0,AImageList.Width-1,AImageList.Height-1),B);
            AImageList.AddMasked(B2,clNone);
          finally
            B2.Free;
          end;
          L:=AListView.Items.Add;
          L.Caption:=Rec.Name;
          L.ImageIndex:=AImageList.Count-1;
        finally
          B.Free;
        end;
      finally
        P.Free;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Procedure DeleteFiles(const ADir, AMask : String);
Var I : Integer;
    Rec : TSearchRec;
    Dir : String;
begin
  Dir:=IncludeTrailingPathDelimiter(ADir);
  I:=FindFirst(Dir+AMask,faAnyFile,Rec);
  try
    while I=0 do begin
      DeleteFile(Dir+Rec.Name);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Procedure DeleteOldFiles;
begin
  DeleteFiles(PrgDataDir+GameListSubDir,'*.conf');
  DeleteFiles(PrgDataDir+GameListSubDir,'tempprof.*');
  DeleteFile(PrgDataDir+'Developers.dat');
  DeleteFile(PrgDataDir+'dfend.ini');
  DeleteFile(PrgDataDir+'Genres.dat');
  DeleteFile(PrgDataDir+'Profiles.dat');
  DeleteFile(PrgDataDir+'Publisher.dat');
  DeleteFile(PrgDataDir+'stderr.txt');
  DeleteFile(PrgDataDir+'stdout.txt');
  DeleteFiles(PrgDataDir,'temp.*');
  DeleteFile(PrgDataDir+'Templates.dat');
  DeleteFile(PrgDataDir+'Years.dat');
end;

Function RemoveBackslash(const S : String) : String;
begin
  If S='\' then result:='' else result:=S;
end;

Procedure ReplaceAbsoluteDirs(const GameDB : TGameDB);
Var I,J : Integer;
    G : TGame;
    St : TStringList;
begin
  For I:=0 to GameDB.Count-1 do begin
    G:=GameDB[I];

    G.GameExe:=RemoveBackslash(MakeRelPath(G.GameExe,PrgSetup.BaseDir));
    G.SetupExe:=RemoveBackslash(MakeRelPath(G.SetupExe,PrgSetup.BaseDir));
    G.CaptureFolder:=RemoveBackslash(MakeRelPath(G.CaptureFolder,PrgSetup.BaseDir));
    G.ExtraDirs:=RemoveBackslash(MakeRelPath(G.ExtraDirs,PrgSetup.BaseDir));
    G.DataDir:=RemoveBackslash(MakeRelPath(G.DataDir,PrgSetup.BaseDir));

    For J:=0 to G.NrOfMounts-1 do begin
      Case J of
        0 : St:=ValueToList(G.Mount0);
        1 : St:=ValueToList(G.Mount1);
        2 : St:=ValueToList(G.Mount2);
        3 : St:=ValueToList(G.Mount3);
        4 : St:=ValueToList(G.Mount4);
        5 : St:=ValueToList(G.Mount5);
        6 : St:=ValueToList(G.Mount6);
        7 : St:=ValueToList(G.Mount7);
        8 : St:=ValueToList(G.Mount8);
        9 : St:=ValueToList(G.Mount9);
        else St:=nil;
      end;
      try
        St[0]:=RemoveBackslash(MakeRelPath(St[0],PrgSetup.BaseDir));
        Case J of
          0 : G.Mount0:=ListToValue(St);
          1 : G.Mount1:=ListToValue(St);
          2 : G.Mount2:=ListToValue(St);
          3 : G.Mount3:=ListToValue(St);
          4 : G.Mount4:=ListToValue(St);
          5 : G.Mount5:=ListToValue(St);
          6 : G.Mount6:=ListToValue(St);
          7 : G.Mount7:=ListToValue(St);
          8 : G.Mount8:=ListToValue(St);
          9 : G.Mount9:=ListToValue(St);
        end;
      finally
        St.Free;
      end;
    end;
  end;
end;

Function BuildDefaultDosProfile(const GameDB : TGameDB) : TGame;
begin
  result:=GameDB[GameDB.Add(DosBoxDOSProfile)];

  result.Autoexec:=
    'C:[13][10][13][10]If exist C:\FREEDOS\COMMAND.COM goto AddFreeDos[13][10]Goto Next1[13][10]:AddFreeDos[13][10]set path=%PATH%;C:\FREEDOS[13][10]:Next1[13][10][13][10]'+
    'If exist C:\NC55\NC.EXE goto AddNC55[13][10]Goto Next2[13][10]:AddNC55[13][10]set path=%PATH%;C:\NC55[13][10]Goto Next3[13][10]:Next2[13][10][13][10]'+
    'If exist C:\NC551\NC.EXE goto AddNC551[13][10]Goto Next3[13][10]:AddNC551[13][10]set path=%PATH%;C:\NC551[13][10]:Next3[13][10][13][10]'+
    'If exist C:\NDN\NDN.COM goto AddNDN[13][10]Goto Next 4[13][10]:AddNDN[13][10]set path=%PATH%;C:\NDN[13][10]:Next[13]';
  result.NrOfMounts:=1;
  result.Mount0:=MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir)+';Drive;C;false;';
  result.CloseDosBoxAfterGameExit:=False;
  result.Environment:='PATH[61]Z:\[13]';
  result.StartFullscreen:=False;
  result.CaptureFolder:='.\'+CaptureSubDir+'\'+DosBoxDOSProfile;
  result.Genre:='Program';
  result.WWW:='http://dosbox.sourceforge.net/';
  result.Name:=DosBoxDOSProfile;
  result.Favorite:=True;
  result.Developer:='DosBox Team';
  result.Publisher:='DosBox Team';
  result.Year:='2007';
  result.Language:='multilingual';

  result.LoadCache;
end;

Procedure BuildDefaultProfile;
Var DefaultGame : TGame;
begin
  DefaultGame:=TGame.Create(PrgSetup);
  try
    DefaultGame.ResetToDefault;
    DefaultGame.NrOfMounts:=1;
    DefaultGame.Mount0:=MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir)+';Drive;C;false;';
    DefaultGame.Environment:='PATH[61]Z:\[13]';
  finally
    DefaultGame.Free;
  end;
end;

Procedure ExportGamesListTextFile(const GameDB : TGameDB; const St : TStringList);
Var St2 : TStringList;
    I,Len : Integer;
    S1,S2,S3,S4,S5,S6 : String;
    L : TList;
begin
  S1:=LanguageSetup.GameGenre;
  S2:=LanguageSetup.GameDeveloper;
  S3:=LanguageSetup.GamePublisher;
  S4:=LanguageSetup.GameYear;
  S5:=LanguageSetup.GameLanguage;
  S6:=LanguageSetup.GameWWW;

  Len:=Max(Max(Max(Max(Max(length(S1),length(S2)),length(S3)),length(S4)),length(S5)),length(S6));

  while length(S1)<Len do S1:=S1+' ';
  while length(S2)<Len do S2:=S2+' ';
  while length(S3)<Len do S3:=S3+' ';
  while length(S4)<Len do S4:=S4+' ';
  while length(S5)<Len do S5:=S5+' ';
  while length(S6)<Len do S6:=S6+' ';

  L:=GameDB.GetSortedGamesList;
  try
    For I:=0 to L.Count-1 do with TGame(L[I]) do begin
      If I<>0 then St.Add('');

      St.Add(Name);
      St.Add(S1+' : '+Genre);
      St.Add(S2+' : '+Developer);
      St.Add(S3+' : '+Publisher);
      St.Add(S4+' : '+Year);
      St.Add(S5+' : '+Language);
      St.Add(S6+' : '+WWW);
      If Notes<>'' then begin
        St.Add(LanguageSetup.GameNotes+':');
        St2:=StringToStringList(Notes);
        try
          St.AddStrings(St2);
        finally
          St2.Free;
        end;
      end;
    end;
  finally
    L.Free;
  end;
end;

Procedure ExportGamesListTableFile(const GameDB : TGameDB; const St : TStringList);
Var I : Integer;
    L : TList;
begin
  St.Add(Format('"%s";"%s";"%s";"%s";"%s";"%s";"%s"',[LanguageSetup.GameName,LanguageSetup.GameGenre,LanguageSetup.GameDeveloper,LanguageSetup.GamePublisher,LanguageSetup.GameYear,LanguageSetup.GameLanguage,LanguageSetup.GameWWW]));
  L:=GameDB.GetSortedGamesList;
  try
    For I:=0 to L.Count-1 do with TGame(L[I]) do
      St.Add(Format('"%s";"%s";"%s";"%s";"%s";"%s";"%s"',[Name,Genre,Developer,Publisher,Year,Language,WWW]));
  finally
    L.Free;
  end;
end;

Function EncodeHTMLSymbols(const S : String) : String;
Var B : Boolean;
    I : Integer;
Procedure Replace(const C : Char; const T : String); begin I:=Pos(C,result); If I=0 then exit; result:=Copy(result,1,I-1)+T+Copy(result,I+1,MaxInt); B:=False; end;
begin
  result:=S;
  repeat
    B:=True;
    I:=Pos('&',result);
    If I<>0 then begin
      B:=False;
      B:=B or (Copy(result,I,5)='&amp;');
      B:=B or (Copy(result,I,6)='&Auml;');
      B:=B or (Copy(result,I,6)='&Ouml;');
      B:=B or (Copy(result,I,6)='&Uuml;');
      B:=B or (Copy(result,I,6)='&auml;');
      B:=B or (Copy(result,I,6)='&ouml;');
      B:=B or (Copy(result,I,6)='&uuml;');
      B:=B or (Copy(result,I,7)='&szlig;');
      If not B then result:=Copy(result,1,I-1)+'&amp;'+Copy(result,I+1,MaxInt);
    end;

    Replace('Ä','&Auml;');
    Replace('Ö','&Ouml;');
    Replace('Ü','&Uuml;');
    Replace('ä','&auml;');
    Replace('ö','&ouml;');
    Replace('ü','&uuml;');
    Replace('ß','&szlig;');
  until B;
end;

Procedure ExportGamesListHTMLFile(const GameDB : TGameDB; const St : TStringList);
Var I : Integer;
    L : TList;
begin
  St.Add('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">');
  St.Add('<html>');
  St.Add('  <head>');
  St.Add('    <title>D-Fend Reloaded</title>');
  St.Add('    <meta http-equiv="content-type" content="text/html; charset=iso-8859-1">');
  St.Add('  </head>');
  St.Add('  <body>');
  St.Add('    <table>');
  St.Add('      <tr>');
  St.Add(Format('        <th>%s</th>',[LanguageSetup.GameName]));
  St.Add(Format('        <th>%s</th>',[LanguageSetup.GameGenre]));
  St.Add(Format('        <th>%s</th>',[LanguageSetup.GameDeveloper]));
  St.Add(Format('        <th>%s</th>',[LanguageSetup.GamePublisher]));
  St.Add(Format('        <th>%s</th>',[LanguageSetup.GameYear]));
  St.Add(Format('        <th>%s</th>',[LanguageSetup.GameLanguage]));
  St.Add(Format('        <th>%s</th>',[LanguageSetup.GameWWW]));
  St.Add('      </tr>');
  L:=GameDB.GetSortedGamesList;
  try
    For I:=0 to L.Count-1 do with TGame(L[I]) do begin
      St.Add('      <tr>');
      St.Add(Format('        <td>%s</td>',[EncodeHTMLSymbols(Name)]));
      St.Add(Format('        <td>%s</td>',[EncodeHTMLSymbols(Genre)]));
      St.Add(Format('        <td>%s</td>',[EncodeHTMLSymbols(Developer)]));
      St.Add(Format('        <td>%s</td>',[EncodeHTMLSymbols(Publisher)]));
      St.Add(Format('        <td>%s</td>',[EncodeHTMLSymbols(Year)]));
      St.Add(Format('        <td>%s</td>',[EncodeHTMLSymbols(Language)]));
      If Trim(WWW)<>''
        then St.Add(Format('        <td><a href="%s">%s</a></td>',[WWW,WWW]))
        else St.Add('        <td></td>');
    end;
  finally
    L.Free;
  end;
  St.Add('      </tr>');
  St.Add('    </table>');
  St.Add('  </body>');
  St.Add('</html>');
end;

Procedure ExportGamesList(const GameDB : TGameDB; const FileName : String);
Var S : String;
    St : TStringList;
begin
  St:=TStringList.Create;
  try
    S:=ExtUpperCase(Trim(ExtractFileExt(FileName)));

    If S='.CSV' then ExportGamesListTableFile(GameDB,St);
    If (S='.HTML') or (S='.HTM') then ExportGamesListHTMLFile(GameDB,St);
    If St.Count=0 then ExportGamesListTextFile(GameDB,St);
    
    try
      St.SaveToFile(FileName);
    except
      MessageDlg(LanguageSetup.MessageCouldNotSaveFile,mtError,[mbOK],0);
    end;
  finally
    St.Free;
  end;
end;

Procedure EditDefaultProfile(const AOwner : TComponent; const GameDB : TGameDB);
Var DefaultGame : TGame;
begin
  DefaultGame:=TGame.Create(PrgSetup);
  try
    EditGameProfil(AOwner,GameDB,DefaultGame,nil);
  finally
    DefaultGame.Free;
  end;
end;

Procedure AddToHistory(const GameName : String);
Var F : TextFile;
begin
  try
    AssignFile(F,PrgDataDir+HistoryFileName);
    If FileExists(PrgDataDir+HistoryFileName) then Append(F) else Rewrite(F);
    try
      writeln(F,GameName+';'+DateToStr(Now)+';'+TimeToStr(Now));
    finally
      CloseFile(F);
    end;
  except
    MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[PrgDataDir+HistoryFileName]),mtError,[mbOK],0);
  end;
end;

Procedure LoadHistory(const AListView : TListView);
Var C : TListColumn;
    St,St2 : TStringList;
    I : Integer;
    S : String;
    L : TListItem;
begin
  C:=AListView.Columns.Add;
  C.Caption:=LanguageSetup.HistoryGame;
  C.Width:=-2;
  C:=AListView.Columns.Add;
  C.Caption:=LanguageSetup.HistoryDate;
  C.Width:=-2;
  C:=AListView.Columns.Add;
  C.Caption:=LanguageSetup.HistoryTime;
  C.Width:=-2;

  if not FileExists(PrgDataDir+HistoryFileName) then exit;

  St:=TStringList.Create;
  try
    try
      St.LoadFromFile(PrgDataDir+HistoryFileName);
    except
      MessageDlg(Format(LanguageSetup.MessageCouldNotOpenFile,[PrgDataDir+HistoryFileName]),mtError,[mbOK],0);
      exit;
    end;
    For I:=0 to St.Count-1 do begin
      S:=Trim(St[I]);
      If S='' then continue;
      St2:=ValueToList(S);
      try
        If St2.Count<1 then continue;
        L:=AListView.Items.Add;
        L.Caption:=St2[0];
        If St2.Count<2 then continue;
        L.SubItems.Add(St2[1]);
        If St2.Count<3 then continue;
        L.SubItems.Add(St2[2]);
      finally
        St2.Free;
      end;
    end;
  finally
    St.Free;
  end;
end;

Procedure ClearHistory;
begin
  if not FileExists(PrgDataDir+HistoryFileName) then exit;
  if not DeleteFile(PrgDataDir+HistoryFileName) then
    MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[PrgDataDir+HistoryFileName]),mtError,[mbOK],0);
end;

Function StrToBool(S : String) : Boolean;
begin
  S:=Trim(ExtUpperCase(S));
  result:=(S='TRUE') or (S='T') or (S='1');
end;

Procedure LoadSpecialData(const Game : TGame; const FileName : String);
Var St,Autoexec : TStringList;
    I : Integer;
    Sec : Integer;
    S,T,U : String;
begin
  St:=TStringList.Create;
  Autoexec:=TStringList.Create;
  try
    St.LoadFromFile(FileName);
    Sec:=-1;
    For I:=0 to St.Count-1 do begin
      S:=Trim(ExtUpperCase(St[I]));
      If (S<>'') and (S[1]='[') and (Pos(']',S)>0) then begin
        S:=Trim(Copy(S,2,Pos(']',S)-2));
        If S='GENERAL' then Sec:=0 else begin
          If S='AUTOEXEC' then Sec:=1 else Sec:=-1;
        end;
        continue;
      end;

      If Sec=0 then begin
        S:=Trim(ExtUpperCase(St[I]));
        If (S='') or (S[1]<>'#') or (Pos('=',S)=0) then continue;
        S:=Trim(Copy(Trim(St[I]),2,MaxInt));
        T:=Trim(ExtUpperCase(Copy(S,1,Pos('=',S)-1)));
        U:=Trim(Copy(S,Pos('=',S)+1,MaxInt));

        If T='SNAPSHOTIMAGE' then Game.CaptureFolder:=U;
        If T='EXIT' then Game.CloseDosBoxAfterGameExit:=StrToBool(U);
        If T='MANUALFILE' then Game.DataDir:=ExtractFilePath(U);
        If T='WWWSITE' then Game.WWW:=U;
      end;

      If Sec=1 then Autoexec.Add(St[I]);
    end;

    Game.Autoexec:=StringListToString(Autoexec);
  finally
    St.Free;
    Autoexec.Free;
  end;
end;

Function ImportConfFile(const AGameDB : TGameDB; const AFileName : String) : TGame;
Var INI : TINIFile;
begin
  INI:=TIniFile.Create(AFileName);
  try
    result:=AGameDB[AGameDB.Add(ChangeFileExt(ExtractFileName(AFileName),''))];

    result.StartFullscreen:=StrToBool(INI.ReadString('sdl','fullscreen','false'));
    result.UseDoublebuffering:=StrToBool(INI.ReadString('sdl','fulldouble','false'));
    result.Render:=Ini.ReadString('sdl','output','surface');
    result.FullscreenResolution:=Ini.ReadString('sdl','fullresolution','original');
    result.WindowResolution:=Ini.ReadString('sdl','windowresolution','original');
    result.AutoLockMouse:=StrToBool(INI.ReadString('sdl','autolock','true'));
    result.MouseSensitivity:=INI.ReadInteger('sdl','sensitivity',100);
    result.Priority:=Ini.ReadString('sdl','priority','higher,normal');
    result.UseScanCodes:=StrToBool(INI.ReadString('sdl','usescancodes','true'));

    result.VideoCard:=Ini.ReadString('dosbox','machine','vga');
    result.Memory:=INI.ReadInteger('dosbox','memsize',16);

    result.FrameSkip:=INI.ReadInteger('render','frameskip',0);
    result.AspectCorrection:=StrToBool(INI.ReadString('render','aspect','false'));
    result.Scale:=INI.ReadString('render','scaler','normal2x');

    result.Core:=INI.ReadString('cpu','core','auto');
    result.Cycles:=INI.ReadString('cpu','cycles','auto');
    result.CyclesUp:=INI.ReadInteger('cpu','cycleup',500);
    result.CyclesDown:=INI.ReadInteger('cpu','cycledown',20);

    result.EMS:=StrToBool(INI.ReadString('dos','ems','true'));
    result.XMS:=StrToBool(INI.ReadString('dos','xms','true'));
    result.UMB:=StrToBool(INI.ReadString('dos','umb','true'));
    result.KeyboardLayout:=INI.ReadString('dos','keyboardlayout','none');

    result.MixerNosound:=StrToBool(INI.ReadString('mixer','nosound','false'));
    result.MixerRate:=Ini.ReadInteger('mixer','rate',22050);
    result.MixerBlocksize:=Ini.ReadInteger('mixer','blocksize',2048);
    result.MixerPrebuffer:=Ini.ReadInteger('mixer','prebuffer',10);

    result.SBType:=Ini.ReadString('sblaster','sbtype','sb16');
    result.SBBase:=Ini.ReadInteger('sblaster','sbbase',220);
    result.SBIRQ:=Ini.ReadInteger('sblaster','irq',7);
    result.SBDMA:=Ini.ReadInteger('sblaster','dma',1);
    result.SBHDMA:=Ini.ReadInteger('sblaster','hdma',5);
    result.SBMixer:=StrToBool(INI.ReadString('mixer','mixer','true'));
    result.SBOplMode:=Ini.ReadString('sblaster','oplmode','auto');
    result.SBOplRate:=Ini.ReadInteger('sblaster','oplrate',22050);

    result.GUS:=StrToBool(INI.ReadString('gus','gus','true'));
    result.GUSRate:=Ini.ReadInteger('gus','gusrate',22050);
    result.GUSBase:=Ini.ReadInteger('gus','gusbase',240);
    result.GUSIRQ1:=Ini.ReadInteger('gus','irg1',5);
    result.GUSIRQ2:=Ini.ReadInteger('gus','irq2',5);
    result.GUSDMA1:=Ini.ReadInteger('gus','dma1',3);
    result.GUSDMA2:=Ini.ReadInteger('gus','dma2',3);
    result.GUSUltraDir:=Ini.ReadString('gus','ultradir','C:\ULTRASND');

    result.MIDIType:=Ini.ReadString('midi','mpu401','intelligent');
    result.MIDIDevice:=Ini.ReadString('midi','device','default');
    result.MIDIConfig:=Ini.ReadString('midi','config','');

    result.SpeakerPC:=StrToBool(INI.ReadString('speaker','pcspeaker','true'));
    result.SpeakerRate:=Ini.ReadInteger('speaker','pcrate',22050);
    result.SpeakerTandy:=Ini.ReadString('speaker','tandy','auto');
    result.SpeakerRate:=Ini.ReadInteger('speaker','tandyrate',22050);
    result.SpeakerDisney:=StrToBool(INI.ReadString('speaker','disney','true'));

    result.JoystickType:=Ini.ReadString('joystick','joysticktype','auto');
    result.JoystickTimed:=StrToBool(INI.ReadString('joystick','timed','true'));
    result.JoystickAutoFire:=StrToBool(INI.ReadString('joystick','autofire','false'));
    result.JoystickSwap34:=StrToBool(INI.ReadString('joystick','swap34','false'));
    result.JoystickButtonwrap:=StrToBool(INI.ReadString('joystick','buttonwrap','true'));

    result.Serial1:=INI.ReadString('serial','serial1','dummy');
    result.Serial2:=INI.ReadString('serial','serial2','dummy');
    result.Serial3:=INI.ReadString('serial','serial3','disabled');
    result.Serial4:=INI.ReadString('serial','serial4','disabled');

    result.IPX:=StrToBool(INI.ReadString('ipx','ipx','false'));
  finally
    Ini.Free;
  end;

  LoadSpecialData(result,AFileName);
end;

end.
