unit GameDBToolsUnit;
interface

uses Classes, ComCtrls, Controls, Menus, CheckLst, GameDBUnit;

{DEFINE LargeListTest}

{ Load Data to GUI }

Type TSortListBy=(slbName, slbSetup, slbGenre, slbDeveloper, slbPublisher, slbYear, slbLanguage);

Procedure InitTreeViewForGamesList(const ATreeView : TTreeView; const GameDB : TGameDB);
Procedure InitListViewForGamesList(const AListView : TListView; const ShowExtraInfo : Boolean);

Procedure AddGameToList(const AListView : TListView; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const Game : TGame; const ShowExtraInfo : Boolean; const O,V,T : String); overload;
Procedure AddGameToList(const AListView : TListView; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const Game : TGame; const ShowExtraInfo : Boolean); overload;
Procedure AddGamesToList(const AListView : TListView; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const GameDB : TGameDB; const Group, SubGroup, SearchString : String; const ShowExtraInfo : Boolean; const SortBy : TSortListBy; const ReverseOrder : Boolean; const HideScummVMProfiles : Boolean = False); overload;
Procedure AddGamesToList(const AListView : TListView; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const GameDB : TGameDB; const Game : TGame; const Group, SubGroup, SearchString : String; const ShowExtraInfo : Boolean; const SortBy : TSortListBy; const ReverseOrder : Boolean; const HideScummVMProfiles : Boolean = False); overload;

Procedure AddScreenshotsToList(const AListView : TListView; const AImageList : TImageList; Dir : String);
Procedure AddSoundsToList(const AListView : TListView; Dir : String; ImageListIndex : Integer);

Procedure GetColOrderAndVisible(var O,V : String);
Procedure SetSortTypeByListViewCol(const ColumnIndex : Integer; var ListSort : TSortListBy; var ListSortReverse : Boolean);

{ Selection lists }

Procedure BuildCheckList(const CheckListBox : TCheckListBox; const GameDB : TGameDB; const WithDefaultProfile, HideScummVMProfiles : Boolean);
Procedure BuildSelectPopupMenu(const Popup : TPopupMenu; const GameDB : TGameDB; const OnClick : TNotifyEvent; const WithDefaultProfile : Boolean);
Procedure SelectGamesByPopupMenu(const Sender : TObject; const CheckListBox : TCheckListBox);

{ Upgrade from D-Fend / First-run init / Repair }

Procedure DeleteOldFiles;
Procedure ReplaceAbsoluteDirs(const GameDB : TGameDB);
Function BuildDefaultDosProfile(const GameDB : TGameDB; const CopyFiles : Boolean = True) : TGame;
Procedure BuildDefaultProfile;
Procedure ReBuildTemplates;

{ Extras }

Procedure ExportGamesList(const GameDB : TGameDB; const FileName : String);
Procedure EditDefaultProfile(const AOwner : TComponent; const GameDB : TGameDB);

{ History }

Procedure AddToHistory(const GameName : String);
Procedure LoadHistory(const AListView : TListView);
Procedure ClearHistory;

{ Import }

Procedure ImportConfData(const AGame : TGame; const Lines : String); overload;
Procedure ImportConfData(const AGame : TGame; const St : TStringList); overload;
Procedure ImportConfFileData(const AGame : TGame; const AFileName : String);
Function ImportConfFile(const AGameDB : TGameDB; const AFileName : String) : TGame;

{ Checksums }

Procedure CreateGameCheckSum(const AGame : TGame; const OverwriteExistingCheckSum : Boolean);
Procedure CreateSetupCheckSum(const AGame : TGame; const OverwriteExistingCheckSum : Boolean);
Function ChecksumForGameOK(const AGame : TGame) : Boolean;
Function ChecksumForSetupOK(const AGame : TGame) : Boolean;
Procedure ProfileEditorOpenCheck(const AGame : TGame);
Procedure ProfileEditorCloseCheck(const AGame : TGame; const NewGameExe, NewSetupExe : String);
Function RunCheck(const AGame : TGame; const RunSetup : Boolean) : Boolean;
Procedure CreateCheckSumsForAllGames(const AGameDB : TGameDB);

{ Last modification date }

Function GetLastModificationDate(const AGame : TGame) : String;

{ ScummVM }

Function ScummVMMode(const Game : TGame) : Boolean;

{ CheckDB }

Function CheckGameDB(const GameDB : TGameDB) : TStringList;

implementation

uses Windows, SysUtils, Forms, Dialogs, Graphics, Math, IniFiles, PNGImage,
     JPEG, GIFImage, CommonTools, LanguageSetupUnit, PrgConsts, PrgSetupUnit,
     ProfileEditorFormUnit, ModernProfileEditorFormUnit, HashCalc,
     SmallWaitFormUnit, ChecksumFormUnit, ProgressFormUnit;

var TempIcon : TIcon;

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
    UserGroups : TStringList;
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
      UserGroups:=StringToStringList(PrgSetup.UserGroups);
      try
        For I:=0 to UserGroups.Count-1 do
          AddTypeSelector(ATreeView,UserGroups[I],GameDB.GetKeyValueList(UserGroups[I]));
      finally
        UserGroups.Free;
      end;

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

Procedure BuildSelectPopupSubMenu(const Popup : TPopupMenu; const Name : String; const MenuSelect, MenuUnselect : TMenuItem; const Tag : Integer; const OnClick : TNotifyEvent; const Items : TStringList);
Var SubSelect, SubUnselect,M : TMenuItem;
    I : Integer;
begin
  SubSelect:=TMenuItem.Create(Popup);
  SubSelect.Caption:=Name;
  SubSelect.Tag:=Tag;
  MenuSelect.Add(SubSelect);

  SubUnselect:=TMenuItem.Create(Popup);
  SubUnselect.Caption:=Name;
  SubUnselect.Tag:=Tag;
  MenuUnselect.Add(SubUnselect);

  For I:=0 to Items.Count-1 do begin
      M:=TMenuItem.Create(Popup);
      M.Caption:=Items[I];
      M.Tag:=I;
      M.OnClick:=OnClick;
      SubSelect.Add(M);
      M:=TMenuItem.Create(Popup);
      M.Caption:=Items[I];
      M.Tag:=I;
      M.OnClick:=OnClick;
      SubUnselect.Add(M);
  end;
end;

Procedure BuildCheckList(const CheckListBox : TCheckListBox; const GameDB : TGameDB; const WithDefaultProfile, HideScummVMProfiles : Boolean);
Var I : Integer;
    St : TStringList;
begin
  St:=TStringList.Create;
  try
    For I:=0 to GameDB.Count-1 do If WithDefaultProfile or (GameDB[I].Name<>DosBoxDOSProfile) then begin
      If HideScummVMProfiles and ScummVMMode(GameDB[I]) then continue;
      St.AddObject(GameDB[I].Name,GameDB[I]);
    end;
    St.Sort;
    CheckListBox.Items.Assign(St);
    For I:=0 to CheckListBox.Items.Count-1 do CheckListBox.Checked[I]:=True;
  finally
    St.Free;
  end;
end;

Type TUserDataRecord=record
  Name, NameUpper : String;
  Values, ValuesUpper : TStringList;
end;

Procedure BuildSelectPopupMenu(const Popup : TPopupMenu; const GameDB : TGameDB; const OnClick : TNotifyEvent; const WithDefaultProfile : Boolean);
Var MenuSelect, MenuUnselect : TMenuItem;
    St : TStringList;
    I,J,K,Nr : Integer;
    S,T,SUpper : String;
    UserData : Array of TUserDataRecord;
begin
  { Base settings }

  MenuSelect:=TMenuItem.Create(Popup);
  MenuSelect.Caption:=LanguageSetup.Select;
  MenuSelect.Tag:=1;
  Popup.Items.Add(MenuSelect);
  MenuUnselect:=TMenuItem.Create(Popup);
  MenuUnselect.Caption:=LanguageSetup.Unselect;
  MenuUnselect.Tag:=0;
  Popup.Items.Add(MenuUnselect);

  { Add normal meta data submenus }

  St:=GameDB.GetGenreList(WithDefaultProfile);
  try BuildSelectPopupSubMenu(Popup,LanguageSetup.GameGenre,MenuSelect,MenuUnselect,0,OnClick,St); finally St.Free; end;

  St:=GameDB.GetDeveloperList(WithDefaultProfile);
  try BuildSelectPopupSubMenu(Popup,LanguageSetup.GameDeveloper,MenuSelect,MenuUnselect,1,OnClick,St); finally St.Free; end;

  St:=GameDB.GetPublisherList(WithDefaultProfile);
  try BuildSelectPopupSubMenu(Popup,LanguageSetup.GamePublisher,MenuSelect,MenuUnselect,2,OnClick,St); finally St.Free; end;

  St:=GameDB.GetYearList(WithDefaultProfile);
  try BuildSelectPopupSubMenu(Popup,LanguageSetup.GameYear,MenuSelect,MenuUnselect,3,OnClick,St); finally St.Free; end;

  St:=GameDB.GetLanguageList(WithDefaultProfile);
  try BuildSelectPopupSubMenu(Popup,LanguageSetup.GameLanguage,MenuSelect,MenuUnselect,4,OnClick,St); finally St.Free; end;

  { Collect user data }

  SetLength(UserData,0);

  try
    For I:=0 to GameDB.Count-1 do If WithDefaultProfile or (GameDB[I].Name<>DosBoxDOSProfile) then begin
      St:=StringToStringList(GameDB[I].UserInfo);
      try
        For J:=0 to St.Count-1 do begin
          S:=Trim(St[J]);
          If (S='') or (Pos('=',S)=0) then continue;
          T:=Trim(Copy(S,Pos('=',S)+1,MaxInt));
          S:=Trim(Copy(S,1,Pos('=',S)-1));
          If (S='') or (T='') then continue;
          SUpper:=ExtUpperCase(S);
          Nr:=-1;
          For K:=0 to length(UserData)-1 do If UserData[K].NameUpper=SUpper then begin Nr:=K; break; end;
          If Nr<0 then begin
            Nr:=length(UserData); SetLength(UserData,Nr+1);
            UserData[Nr].Name:=S; UserData[Nr].NameUpper:=SUpper;
            UserData[Nr].Values:=TStringList.Create;
            UserData[Nr].ValuesUpper:=TStringList.Create;
          end;
          If UserData[Nr].ValuesUpper.IndexOf(ExtUpperCase(T))<0 then begin
            UserData[Nr].Values.Add(T);
            UserData[Nr].ValuesUpper.Add(ExtUpperCase(T));
          end;
        end;
      finally
        St.Free;
      end;
    end;

    { Build menu from user data }

    For I:=0 to length(UserData)-1 do begin
      BuildSelectPopupSubMenu(Popup,UserData[I].Name,MenuSelect,MenuUnselect,-1,OnClick,UserData[I].Values);
    end;

  finally
    { Free records }

    For I:=0 to length(UserData)-1 do begin
      UserData[I].Values.Free;
      UserData[I].ValuesUpper.Free;
    end;
  end;
end;

Function UserDataContainValue(const UserInfo, Key, Value : String) : Boolean;
Var St : TStringList;
    I,J : Integer;
    S,T : String;
begin
  result:=False;

  St:=StringToStringList(UserInfo);
  try
    For I:=0 to St.Count-1 do begin
      S:=Trim(ExtUpperCase(St[I]));
      J:=Pos('=',S);
      If J=0 then continue;
      T:=Trim(Copy(S,J+1,MaxInt));
      S:=Trim(Copy(S,1,J-1));
      If (S=Key) and (T=Value) then begin result:=True; exit; end;
    end;
  finally
    St.Free;
  end;
end;

Procedure SelectGamesByPopupMenu(const Sender : TObject; const CheckListBox : TCheckListBox);
Var Select : Boolean;
    Category : Integer;
    CategoryValue : String;
    I : Integer;
    M : TMenuItem;
    G : TGame;
    S, CategoryName : String;
begin
  If not (Sender is TMenuItem) then exit;
  M:=Sender as TMenuItem;
  CategoryValue:=RemoveUnderline(Trim(ExtUpperCase(M.Caption)));
  Category:=M.Parent.Tag;
  Select:=(M.Parent.Parent.Tag=1);
  If Category=-1 then CategoryName:=RemoveUnderline(ExtUpperCase(M.Parent.Caption)) else CategoryName:='';

  For I:=0 to CheckListBox.Items.Count-1 do begin
    G:=TGame(CheckListBox.Items.Objects[I]);
    If CategoryName<>'' then begin
      If not UserDataContainValue(G.UserInfo,CategoryName,CategoryValue) then continue;
    end else begin
      Case Category of
        0 : S:=G.CacheGenre;
        1 : S:=G.CacheDeveloper;
        2 : S:=G.CachePublisher;
        3 : S:=G.CacheYear;
        4 : S:=G.CacheLanguage;
      end;
      S:=Trim(S);
      If S='' then continue;
      If ExtUpperCase(S)<>CategoryValue then continue;
    end;
    CheckListBox.Checked[I]:=Select;
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

Procedure AddGameToList(const AListView : TListView; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const Game : TGame; const ShowExtraInfo : Boolean; const O,V,T : String);
Var IconNr,I,Nr : Integer;
    B : Boolean;
    S : String;
    L : TListItem;
begin
  If Trim(Game.Icon)='' then begin
    IconNr:=0;
  end else begin
    S:=MakeAbsIconName(Game.Icon);
    If FileExists(S) then begin
      B:=True; try TempIcon.LoadFromFile(S); except B:=False; end;
    end else begin
      B:=False;
    end;
    If B then begin
      AListViewImageList.AddIcon(TempIcon);
      AListViewIconImageList.AddIcon(TempIcon);
    end;
    If B then IconNr:=AListViewImageList.Count-1 else IconNr:=0;
  end;

  L:=AListView.Items.Add;
  If (Game.CacheName='') and (not Game.OwnINI) then begin
    L.Caption:=LanguageSetup.TemplateFormDefault;
  end else begin
    L.Caption:=Game.CacheName;
  end;

  with L do begin
    Data:=Game;

    SubItems.BeginUpdate;
    try
      If ShowExtraInfo then begin
        For I:=0 to 5 do begin
          try Nr:=StrToInt(O[I+1]); except Nr:=-1; end;
          If (Nr<1) or (Nr>6) then continue;
          If V[Nr]='0' then continue;

          Case Nr-1 of
            0 : If Trim(Game.SetupExe)<>''
                  then SubItems.Add(LanguageSetupFastYes)
                  else SubItems.Add(LanguageSetupFastNo);
            1 : begin S:=Game.CacheGenre; If Trim(S)='' then SubItems.Add(T) else SubItems.Add(S); end;
            2 : begin S:=Game.CacheDeveloper; If Trim(S)='' then SubItems.Add(T) else SubItems.Add(S); end;
            3 : begin S:=Game.CachePublisher; If Trim(S)='' then SubItems.Add(T) else SubItems.Add(S); end;
            4 : begin S:=Game.CacheYear; If Trim(S)='' then SubItems.Add(T) else SubItems.Add(S); end;
            5 : begin S:=Game.CacheLanguage; If Trim(S)='' then SubItems.Add(T) else SubItems.Add(S); end;
          end;
        end;
      end else begin
        If Trim(Game.SetupExe)<>''
          then SubItems.Add(LanguageSetupFastYes)
          else SubItems.Add(LanguageSetupFastNo);
      end;
    finally
      SubItems.EndUpdate;
    end;
    ImageIndex:=IconNr;
  end;
end;

Procedure AddGameToList(const AListView : TListView; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const Game : TGame; const ShowExtraInfo : Boolean);
Var O,V,T : String;
begin
  GetColOrderAndVisible(O,V);
  If Trim(PrgSetup.ValueForNotSet)='' then T:=LanguageSetup.NotSet else T:=Trim(PrgSetup.ValueForNotSet);
  AddGameToList(AListView,AListViewImageList,AListViewIconImageList,AImageList,Game,ShowExtraInfo,O,V,T);
end;

Procedure AddGamesToList(const AListView : TListView; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const GameDB : TGameDB; const Group, SubGroup, SearchString : String; const ShowExtraInfo : Boolean; const SortBy : TSortListBy; const ReverseOrder : Boolean; const HideScummVMProfiles : Boolean);
begin
  AddGamesToList(AListView,AListViewImageList,AListViewIconImageList,AImageList,GameDB,nil,Group,SubGroup,SearchString,ShowExtraInfo,SortBy,ReverseOrder,HideScummVMProfiles);
end;

Procedure AddGamesToList(const AListView : TListView; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const GameDB : TGameDB; const Game : TGame; const Group, SubGroup, SearchString : String; const ShowExtraInfo : Boolean; const SortBy : TSortListBy; const ReverseOrder : Boolean; const HideScummVMProfiles : Boolean); overload;
Var I,J,K,Nr : Integer;
    GroupUpper, SubGroupUpper, SearchStringUpper : String;
    B : Boolean;
    C : Array of Integer;
    List : TList;
    St,St2 : TStringList;
    S,T : String;
    O,V : String;
    {$IFDEF LargeListTest}Ca : Cardinal;{$ENDIF}
begin
  {$IFDEF LargeListTest}Ca:=GetTickCount;{$ENDIF}

  {Prepare ListView}
  AListViewImageList.Clear;
  AListViewImageList.AddImage(AImageList,0);
  AListViewIconImageList.Clear;
  AListViewIconImageList.AddImage(AImageList,0);
  SetLength(C,AListView.Columns.Count);
  AListView.Columns.BeginUpdate;
  try
    For I:=0 to length(C)-1 do begin C[I]:=AListView.Columns[I].Width; AListView.Columns[I].Width:=1; end;
  finally
    AListView.Columns.EndUpdate;
  end;

  List:=TList.Create;
  try
    {Select game to add}
    SearchStringUpper:=ExtUpperCase(Trim(SearchString));
    If SubGroup='' then begin
      B:=(Group=LanguageSetup.GameFavorites);
      for I:=0 to GameDB.Count-1 do begin
        If B and (not GameDB[I].Favorite) then continue;
        If HideScummVMProfiles and ScummVMMode(GameDB[I]) then continue;
        If (SearchStringUpper<>'') and (Pos(SearchStringUpper,GameDB[I].CacheNameUpper)=0) then continue;
        List.Add(GameDB[I]);
      end;
    end else begin
      GroupUpper:=Trim(ExtUpperCase(Group));
      If SubGroup=LanguageSetup.NotSet then SubGroupUpper:='' else SubGroupUpper:=ExtUpperCase(SubGroup);
      Nr:=5;
      If Group=LanguageSetup.GameGenre then Nr:=0;
      If Group=LanguageSetup.GameDeveloper then Nr:=1;
      If Group=LanguageSetup.GamePublisher then Nr:=2;
      If Group=LanguageSetup.GameYear then Nr:=3;
      If Group=LanguageSetup.GameLanguage then Nr:=4;

      For I:=0 to GameDB.Count-1 do begin
        If HideScummVMProfiles and ScummVMMode(GameDB[I]) then continue;
        B:=False;
        Case Nr of
          0 : B:=(GameDB[I].CacheGenreUpper=SubGroupUpper);
          1 : B:=(GameDB[I].CacheDeveloperUpper=SubGroupUpper);
          2 : B:=(GameDB[I].CachePublisherUpper=SubGroupUpper);
          3 : B:=(GameDB[I].CacheYearUpper=SubGroupUpper);
          4 : B:=(GameDB[I].CacheLanguageUpper=SubGroupUpper);
          5 : begin
                B:=(SubGroupUpper='');
                St2:=StringToStringList(GameDB[I].CacheUserInfo);
                try
                  For J:=0 to St2.Count-1 do begin
                    S:=St2[J]; K:=Pos('=',S); If K=0 then T:='' else begin T:=Trim(Copy(S,K+1,MaxInt)); S:=Trim(Copy(S,1,K-1)); end;
                    If Trim(ExtUpperCase(S))=GroupUpper then begin B:=(Trim(ExtUpperCase(T))=SubGroupUpper); break; end;
                  end;
                finally
                  St2.Free;
                end;
              end;
        end;
        If not B then continue;
        If (SearchStringUpper<>'') and (Pos(SearchStringUpper,ExtUpperCase(GameDB[I].CacheName))=0) then continue;
        List.Add(GameDB[I]);
      end;
    end;

    If Game<>nil then List.Add(Game);

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
      GetColOrderAndVisible(O,V);
      If Trim(PrgSetup.ValueForNotSet)='' then T:=LanguageSetup.NotSet else T:=Trim(PrgSetup.ValueForNotSet);
      AListView.Items.BeginUpdate;
      try
        If ReverseOrder then begin
          For I:=St.Count-1 downto 0 do AddGameToList(AListView,AListViewImageList,AListViewIconImageList,AImageList,TGame(St.Objects[I]),ShowExtraInfo,O,V,T);
        end else begin
          For I:=0 to St.Count-1 do AddGameToList(AListView,AListViewImageList,AListViewIconImageList,AImageList,TGame(St.Objects[I]),ShowExtraInfo,O,V,T);
        end;
      finally
        AListView.Items.EndUpdate;
      end;

    finally
      St.Free;
    end;
  finally
    List.Free;
    AListView.Columns.BeginUpdate;
    try
      For I:=0 to length(C)-1 do AListView.Columns[I].Width:=C[I];
    finally
      AListView.Columns.EndUpdate;
    end;
  end;

  {$IFDEF LargeListTest}Application.MainForm.Caption:=IntToStr(GetTickCount-Ca);{$ENDIF}
end;


Procedure AddScreenshotsToList(const AListView : TListView; const AImageList : TImageList; Dir : String);
Var I : Integer;
    Rec : TSearchRec;
    P : TPNGObject;
    J : TJPEGImage;
    G : TGIFImage;
    B,B2 : TBitmap;
    L : TListItem;
    OK : Boolean;
begin
  Dir:=IncludeTrailingPathDelimiter(Dir);

  I:=FindFirst(Dir+'*.png',faAnyFile,Rec);
  try
    while I=0 do begin
      P:=TPNGObject.Create;
      try
        OK:=True; try P.LoadFromFile(Dir+Rec.Name); except OK:=False; end;
        IF OK then begin
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
        end;
      finally
        P.Free;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  I:=FindFirst(Dir+'*.jpg',faAnyFile,Rec);
  try
    while I=0 do begin
      J:=TJPEGImage.Create;
      try
        OK:=True; try J.LoadFromFile(Dir+Rec.Name); except OK:=False; end;
        If OK then begin
          B:=TBitmap.Create;
          try
            B.Assign(J);
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
        end;
      finally
        J.Free;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  I:=FindFirst(Dir+'*.jpeg',faAnyFile,Rec);
  try
    while I=0 do begin
      J:=TJPEGImage.Create;
      try
        OK:=True; try J.LoadFromFile(Dir+Rec.Name); except OK:=False; end;
        If OK then begin
          B:=TBitmap.Create;
          try
            B.Assign(J);
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
        end;
      finally
        J.Free;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  I:=FindFirst(Dir+'*.gif',faAnyFile,Rec);
  try
    while I=0 do begin
      G:=TGifImage.Create;
      try
        OK:=True; try G.LoadFromFile(Dir+Rec.Name); except OK:=False; end;
        If OK then begin
          B:=TBitmap.Create;
          try
            B.Assign(G);
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
        end;
      finally
        G.Free;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  I:=FindFirst(Dir+'*.bmp',faAnyFile,Rec);
  try
    while I=0 do begin
      B:=TBitmap.Create;
      try
        OK:=True; try B.LoadFromFile(Dir+Rec.Name); except OK:=False; end;
        If OK then begin
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
        end;
      finally
        B.Free;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Procedure AddSoundsToList(const AListView : TListView; Dir : String; ImageListIndex : Integer);
Var I : Integer;
    Rec : TSearchRec;
    L : TListItem;
begin
  Dir:=IncludeTrailingPathDelimiter(Dir);

  I:=FindFirst(Dir+'*.wav',faAnyFile,Rec);
  try
    while I=0 do begin
      L:=AListView.Items.Add;
      L.Caption:=Rec.Name;
      L.ImageIndex:=ImageListIndex;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  I:=FindFirst(Dir+'*.mp3',faAnyFile,Rec);
  try
    while I=0 do begin
      L:=AListView.Items.Add;
      L.Caption:=Rec.Name;
      L.ImageIndex:=ImageListIndex;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  I:=FindFirst(Dir+'*.ogg',faAnyFile,Rec);
  try
    while I=0 do begin
      L:=AListView.Items.Add;
      L.Caption:=Rec.Name;
      L.ImageIndex:=ImageListIndex;
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
Var I,J,K : Integer;
    G : TGame;
    St : TStringList;
    S,T : String;
begin
  For I:=0 to GameDB.Count-1 do begin
    G:=GameDB[I];

    G.GameExe:=RemoveBackslash(MakeRelPath(G.GameExe,PrgSetup.BaseDir));
    G.SetupExe:=RemoveBackslash(MakeRelPath(G.SetupExe,PrgSetup.BaseDir));
    G.CaptureFolder:=RemoveBackslash(MakeRelPath(G.CaptureFolder,PrgSetup.BaseDir));
    G.DataDir:=RemoveBackslash(MakeRelPath(G.DataDir,PrgSetup.BaseDir));

    St:=ValueToList(G.ExtraFiles);
    try
      For J:=0 to St.Count-1 do G.ExtraFiles:=RemoveBackslash(MakeRelPath(St[J],PrgSetup.BaseDir));
      G.ExtraFiles:=StringListToString(St);
    finally
      St.Free;
    end;

    St:=ValueToList(G.ExtraDirs);
    try
      For J:=0 to St.Count-1 do G.ExtraDirs:=RemoveBackslash(MakeRelPath(St[J],PrgSetup.BaseDir));
      G.ExtraDirs:=StringListToString(St);
    finally
      St.Free;
    end;

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
        S:=Trim(St[0]); T:='';
        K:=Pos('$',S);
        while K>0 do begin
          T:=T+RemoveBackslash(MakeRelPath(Trim(Copy(S,1,K-1)),PrgSetup.BaseDir))+'$';
          S:=Trim(Copy(S,K+1,MaxInt));
          K:=Pos('$',S);
        end;
        T:=T+RemoveBackslash(MakeRelPath(Trim(S),PrgSetup.BaseDir));
        St[0]:=T;
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

    G.StoreAllValues;
    G.LoadCache;
  end;
end;

Function CopyFiles(Source, Dest : String) : Boolean;
Var I : Integer;
    Rec : TSearchRec;
begin
  result:=False;

  Source:=IncludeTrailingPathDelimiter(Source);
  Dest:=IncludeTrailingPathDelimiter(Dest);
  if not ForceDirectories(Dest) then exit;

  I:=FindFirst(Source+'*.*',faAnyFile,Rec);
  try
    while I=0 do begin
      If (Rec.Attr and faDirectory)<>0 then begin
        If (Rec.Name<>'.') and (Rec.Name<>'..') then begin
          If not CopyFiles(Source+Rec.Name,Dest+Rec.Name) then exit;
        end;
      end else begin
        Application.ProcessMessages;
        if not CopyFile(PChar(Source+Rec.Name),PChar(Dest+Rec.Name),False) then exit;
      end;

      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  result:=True;
end;

Function RestoreFREEDOSFolder : Boolean;
Var Source1, Source2, Dest1, Dest2 : String;
    B1, B2 : Boolean;
begin
  result:=True;

  Source1:=PrgDir+NewUserDataSubDir+'\FREEDOS';
  Source2:=PrgDir+NewUserDataSubDir+'\DOSZIP';
  Dest1:=IncludeTrailingPathDelimiter(PrgSetup.GameDir)+'FREEDOS';
  Dest2:=IncludeTrailingPathDelimiter(PrgSetup.GameDir)+'DOSZIP';
  B1:=DirectoryExists(Source1) and not DirectoryExists(Dest1);
  B2:=DirectoryExists(Source2) and not DirectoryExists(Dest2);

  If B1 or B2 then begin
    LoadAndShowSmallWaitForm(LanguageSetup.SetupFormService3WaitInfo);
    try
      If B1 then result:=CopyFiles(Source1,Dest1);
      If B2 then result:=CopyFiles(Source2,Dest2);
    finally
      FreeSmallWaitForm;
    end;
  end;
end;

Function BuildDefaultDosProfile(const GameDB : TGameDB; const CopyFiles : Boolean) : TGame;
Var I : Integer;
    St : TStringList;
begin
  I:=GameDB.IndexOf(DosBoxDOSProfile);
  If I>=0 then result:=GameDB[I] else result:=GameDB[GameDB.Add(DosBoxDOSProfile)];

  St:=TStringList.Create;
  try
    St.Add('C:');
    St.Add('');
    St.Add('If exist C:\FREEDOS\COMMAND.COM goto AddFreeDos');
    St.Add('Goto Next1');
    St.Add(':AddFreeDos');
    St.Add('set path=%PATH%;C:\FREEDOS');
    St.Add(':Next1');
    St.Add('');
    St.Add('If exist C:\NC55\NC.EXE goto AddNC55');
    St.Add('Goto Next2');
    St.Add(':AddNC55');
    St.Add('set path=%PATH%;C:\NC55');
    St.Add('echo You can start Norton Commander (file manager) by typing "NC".');
    St.Add('Goto Next3');
    St.Add(':Next2');
    St.Add('');
    St.Add('If exist C:\NC551\NC.EXE goto AddNC551');
    St.Add('Goto Next3');
    St.Add(':AddNC551');
    St.Add('set path=%PATH%;C:\NC551');
    St.Add('echo You can start Norton Commander (file manager) by typing "NC".');
    St.Add(':Next3');
    St.Add('');
    St.Add('If exist C:\NDN\NDN.COM goto AddNDN');
    St.Add('Goto Next4');
    St.Add(':AddNDN');
    St.Add('set path=%PATH%;C:\NDN');
    St.Add('echo You can start Necromancer''s Dos Navigator (file manager) by typing "NDN".');
    St.Add(':Next4');
    St.Add('');
    St.Add('If exist C:\DOSZIP\DZ.EXE goto AddDZ');
    St.Add('Goto Next5');
    St.Add(':AddDZ');
    St.Add('set path=%PATH%;C:\DOSZIP');
    St.Add('echo You can start Doszip Commander (file manager) by typing "DZ".');
    St.Add(':Next5');
    result.Autoexec:=StringListToString(St);
  finally
    St.Free;
  end;
  result.NrOfMounts:=1;
  result.Mount0:=MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir)+';Drive;C;false;';
  result.CloseDosBoxAfterGameExit:=False;
  result.Environment:='PATH[61]Z:\[13]';
  result.StartFullscreen:=False;
  result.CaptureFolder:='.\'+CaptureSubDir+'\'+DosBoxDOSProfile;
  result.Genre:='Program';
  result.WWW:='http:/'+'/www.dosbox.com';
  result.Name:=DosBoxDOSProfile;
  result.Favorite:=True;
  result.Developer:='DOSBox Team';
  result.Publisher:='DOSBox Team';
  result.Year:='2007';
  result.Language:='multilingual';
  result.UserInfo:='License=GPL[13]';
  result.Icon:='DOSBox.ico';

  result.StoreAllValues;
  result.LoadCache;

  If (PrgDir<>PrgDataDir) and DirectoryExists(PrgDir+NewUserDataSubDir) then begin
    If FileExists(PrgDir+NewUserDataSubDir+'\'+IconsSubDir+'\DOSBox.ico') then begin
      ForceDirectories(PrgDataDir+IconsSubDir);
      CopyFile(PChar(PrgDir+NewUserDataSubDir+'\'+IconsSubDir+'\'+'DOSBox.ico'),PChar(PrgDataDir+IconsSubDir+'\DOSBox.ico'),False);
    end;
    If FileExists(PrgDir+NewUserDataSubDir+'\'+CaptureSubDir+'\DOSBox DOS\dosbox_000.png') then begin
      ForceDirectories(PrgDataDir+CaptureSubDir+'\DOSBox DOS');
      CopyFile(PChar(PrgDir+NewUserDataSubDir+'\'+CaptureSubDir+'\DOSBox DOS\dosbox_000.png'),PChar(PrgDataDir+CaptureSubDir+'\DOSBox DOS\dosbox_000.png'),False);
    end;
  end;

  If CopyFiles then RestoreFREEDOSFolder;
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

Procedure CopyTemplates(Dir1, Dir2 : String);
Var Rec : TSearchRec;
    I : Integer;
begin
  Dir1:=IncludeTrailingPathDelimiter(Dir1);
  Dir2:=IncludeTrailingPathDelimiter(Dir2);
  I:=FindFirst(Dir1+'*.prof',faAnyFile,Rec);
  try
    While I=0 do begin
      CopyFile(PChar(Dir1+Rec.Name),PChar(Dir2+Rec.Name),False);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Procedure ReBuildTemplates;
begin
  If PrgDir=PrgDataDir then exit;

  ForceDirectories(PrgDataDir+TemplateSubDir);
  If DirectoryExists(PrgDir+NewUserDataSubDir+'\'+TemplateSubDir) then
    CopyTemplates(PrgDir+NewUserDataSubDir+'\'+TemplateSubDir,PrgDataDir+TemplateSubDir);

  ForceDirectories(PrgDataDir+AutoSetupSubDir);
  If DirectoryExists(PrgDir+NewUserDataSubDir+'\'+AutoSetupSubDir) then
    CopyTemplates(PrgDir+NewUserDataSubDir+'\'+AutoSetupSubDir,PrgDataDir+AutoSetupSubDir);
end;

Procedure ExportGamesListTextFile(const GameDB : TGameDB; const St : TStringList);
Var St2 : TStringList;
    I,J,Len : Integer;
    S1,S2,S3,S4,S5,S6,S7 : String;
    L : TList;
begin
  S1:=LanguageSetup.GameGenre;
  S2:=LanguageSetup.GameDeveloper;
  S3:=LanguageSetup.GamePublisher;
  S4:=LanguageSetup.GameYear;
  S5:=LanguageSetup.GameLanguage;
  S6:=LanguageSetup.GameWWW;
  S7:=LanguageSetup.GameNotes;

  Len:=Max(Max(Max(Max(Max(length(S1),length(S2)),length(S3)),length(S4)),length(S5)),length(S6));

  For I:=0 to GameDB.Count-1 do begin
    St2:=StringToStringList(GameDB[I].UserInfo);
    try
      For J:=0 to St2.Count-1 do If Pos('=',St2[J])>0 then Len:=Max(Len,length(Trim(Copy(St2[J],1,Pos('=',St2[J])-1))));
    finally
      St2.Free;
    end;
  end;

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
      If UserInfo<>'' then begin
        St2:=StringToStringList(UserInfo);
        try
          For J:=0 to St2.Count-1 do If Pos('=',St2[J])>0 then begin
            S7:=Trim(Copy(St2[J],1,Pos('=',St2[J])-1));
            while length(S7)<Len do S7:=S7+' ';
            St.Add(S7+' : '+Copy(St2[J],Pos('=',St2[J])+1,MaxInt));
          end;
        finally
          St2.Free;
        end;
      end;
      If Notes<>'' then begin
        St.Add(LanguageSetup.GameNotes+':');
        St2:=StringToStringList(Notes); try St.AddStrings(St2); finally St2.Free; end;
      end;
    end;
  finally
    L.Free;
  end;
end;

Procedure ExportGamesListTableFile(const GameDB : TGameDB; const St : TStringList);
Var I,J,K : Integer;
    L : TList;
    UserList, UserListUpper, St2 : TStringList;
    S,T : String;
begin
  UserList:=TStringList.Create;
  UserListUpper:=TStringList.Create;
  try

    For I:=0 to GameDB.Count-1 do begin
      St2:=StringToStringList(GameDB[I].UserInfo);
      try
        For J:=0 to St2.Count-1 do If Pos('=',St2[J])>0 then begin
          S:=Trim(Copy(St2[J],1,Pos('=',St2[J])-1));
          If UserListUpper.IndexOf(ExtUpperCase(S))<0 then begin UserList.Add(S); UserListUpper.Add(ExtUpperCase(S)); end;
        end;
      finally
        St2.Free;
      end;
    end;

    S:=Format('"%s";"%s";"%s";"%s";"%s";"%s";"%s"',[LanguageSetup.GameName,LanguageSetup.GameGenre,LanguageSetup.GameDeveloper,LanguageSetup.GamePublisher,LanguageSetup.GameYear,LanguageSetup.GameLanguage,LanguageSetup.GameWWW]);
    For I:=0 to UserList.Count-1 do S:=S+';"'+UserList[I]+'"';
    St.Add(S);
    L:=GameDB.GetSortedGamesList;
    try
      For I:=0 to L.Count-1 do with TGame(L[I]) do begin
        S:=Format('"%s";"%s";"%s";"%s";"%s";"%s";"%s"',[Name,Genre,Developer,Publisher,Year,Language,WWW]);
        St2:=StringToStringList(UserInfo);
        try
          For J:=0 to UserList.Count-1 do begin
            T:='';
            For K:=0 to St2.Count-1 do If Pos('=',St2[K])>0 then begin
              If Trim(ExtUpperCase(Copy(St2[K],1,Pos('=',St2[K])-1)))=UserListUpper[J] then begin
                T:=Trim(Copy(St2[K],Pos('=',St2[K])+1,MaxInt)); break;
              end;
            end;
            S:=S+';"'+T+'"';
          end;
        finally
          St2.Free;
        end;
        St.Add(S);
      end;
    finally
      L.Free;
    end;
  finally
    UserList.Free;
    UserListUpper.Free;
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
Var I,J,K : Integer;
    L : TList;
    UserList, UserListUpper, St2 : TStringList;
    S : String;
begin
  UserList:=TStringList.Create;
  UserListUpper:=TStringList.Create;
  try

    For I:=0 to GameDB.Count-1 do begin
      St2:=StringToStringList(GameDB[I].UserInfo);
      try
        For J:=0 to St2.Count-1 do If Pos('=',St2[J])>0 then begin
          S:=Trim(Copy(St2[J],1,Pos('=',St2[J])-1));
          If UserListUpper.IndexOf(ExtUpperCase(S))<0 then begin UserList.Add(S); UserListUpper.Add(ExtUpperCase(S)); end;
        end;
      finally
        St2.Free;
      end;
    end;

    St.Add('<!DOCTYPE HTML PUBLIC "-/'+'/W3C/'+'/DTD HTML 4.01 Transitional/'+'/EN">');
    St.Add('<html>');
    St.Add('  <head>');
    St.Add('    <title>D-Fend Reloaded</title>');
    St.Add('    <meta http-equiv="content-type" content="text/html; charset=iso-8859-1">');
    St.Add('    <meta name="description" content="D-Fend Reloaded games list">');
    St.Add('    <meta name="DC.creator" content="D-Fend Reloaded '+GetNormalFileVersionAsString+'">');
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
    For I:=0 to UserList.Count-1 do St.Add(Format('        <th>%s</th>',[UserList[I]]));
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
        St2:=StringToStringList(UserInfo);
        try
          For J:=0 to UserList.Count-1 do begin
            S:='';
            For K:=0 to St2.Count-1 do If Pos('=',St2[K])>0 then begin
              If Trim(ExtUpperCase(Copy(St2[K],1,Pos('=',St2[K])-1)))=UserListUpper[J] then begin
                S:=Trim(Copy(St2[K],Pos('=',St2[K])+1,MaxInt)); break;
              end;
            end;
            St.Add(Format('        <td>%s</td>',[EncodeHTMLSymbols(S)]));
          end;
        finally
          St2.Free;
        end;
        St.Add('      </tr>');
      end;
    finally
      L.Free;
    end;
    St.Add('    </table>');
    St.Add('  </body>');
    St.Add('</html>');
  finally
    UserList.Free;
    UserListUpper.Free;
  end;
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
    If PrgSetup.DFendStyleProfileEditor then begin
      EditGameTemplate(AOwner,GameDB,DefaultGame,nil);
    end else begin
      ModernEditGameTemplate(AOwner,GameDB,DefaultGame,nil);
    end;
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

Procedure AddDrive(const Game : TGame; const RealFolder, Letter, FreeSpace : String);
Var S : String;
begin
  {RealFolder;DRIVE;Letter;False;;FreeSpace}
  S:=MakeRelPath(RealFolder,PrgSetup.BaseDir)+';Drive;'+Letter+';;'+FreeSpace;

  Case Game.NrOfMounts of
    0 : Game.Mount0:=S;
    1 : Game.Mount1:=S;
    2 : Game.Mount2:=S;
    3 : Game.Mount3:=S;
    4 : Game.Mount4:=S;
    5 : Game.Mount5:=S;
    6 : Game.Mount6:=S;
    7 : Game.Mount7:=S;
    8 : Game.Mount8:=S;
    9 : Game.Mount9:=S;
  end;
  Game.NrOfMounts:=Game.NrOfMounts+1;
end;

Procedure MakeMountsFromAutoexec(const Game : TGame; const Autoexec : TStringList);
Var I,J,K : Integer;
    S,SUpper,T,U : String;

begin
  I:=0;
  while I<Autoexec.Count do begin
    If Game.NrOfMounts=10 then exit;

    S:=Trim(Autoexec[I]);
    If (S<>'') and (S[1]='@') then S:=Trim(Copy(S,2,MaxInt));
    SUpper:=ExtUpperCase(S);
    If (S='') or (Copy(SUpper,1,4)='ECHO') or (Copy(SUpper,1,3)='REM') or (Copy(SUpper,1,4)='SET ') or (Copy(SUpper,1,5)='KEYB ') then begin inc(I); continue; end;
    If Copy(SUpper,1,6)<>'MOUNT ' then exit;
    S:=Trim(Copy(S,7,MaxInt));

    J:=Pos(' ',S); If J=0 then begin inc(I); continue; end;
    T:=Trim(Copy(S,1,J-1)); S:=Trim(Copy(S,J+1,MaxInt));

    If length(T)=3 then begin If (T[2]<>':') or (T[3]<>'\') then exit; T:=T[1]; end;
    If length(T)=2 then begin If T[2]<>':' then exit; T:=T[1]; end;
    T:=ExtUpperCase(T);
    If (T<'A') or (T>'Z') then begin inc(I); continue; end;

    If S[1]='"' then begin
      S:=Trim(Copy(S,2,MaxInt));
      K:=-1;
      For J:=1 to length(S) do If S[J]='"' then begin K:=J; break; end;
      If K=-1 then begin U:=S; S:=''; end else begin U:=Trim(Copy(S,1,K-1)); S:=Trim(Copy(S,K+1,MaxInt)); end;
    end else begin
      J:=Pos(' ',S); If J>0 then begin U:=Trim(Copy(S,1,J-1)); S:=Trim(Copy(S,J+1,MaxInt)); end else begin U:=S; S:=''; end;
    end;

    If Trim(ExtUpperCase(Copy(U,1,9)))='-FREESIZE' then U:=Trim(Copy(U,10,MaxInt));

    AddDrive(Game,U,T,S);
    Autoexec.Delete(I);
  end;

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

    MakeMountsFromAutoexec(Game,Autoexec);
    Game.Autoexec:=StringListToString(Autoexec);
  finally
    St.Free;
    Autoexec.Free;
  end;
end;

Procedure ImportConfData(const AGame : TGame; const Lines : String);
Var St : TStringList;
begin
  St:=TStringList.Create;
  try
    St.Text:=Lines;
    ImportConfData(AGame,St);
  finally
    St.Free;
  end;
end;

Procedure ImportConfData(const AGame : TGame; const St : TStringList);
Var FileName : String;
begin
  FileName:=TempDir+'DFRTempConfFile.conf';
  St.SaveToFile(FileName);
  try
    ImportConfFileData(AGame,FileName);
  finally
    DeleteFile(FileName);
  end;
end;

Procedure ImportConfFileData(const AGame : TGame; const AFileName : String);
Var INI : TINIFile;
begin
  INI:=TIniFile.Create(AFileName);
  try
    AGame.StartFullscreen:=StrToBool(INI.ReadString('sdl','fullscreen','false'));
    AGame.UseDoublebuffering:=StrToBool(INI.ReadString('sdl','fulldouble','false'));
    AGame.Render:=Ini.ReadString('sdl','output','surface');
    AGame.FullscreenResolution:=Ini.ReadString('sdl','fullresolution','original');
    AGame.WindowResolution:=Ini.ReadString('sdl','windowresolution','original');
    AGame.AutoLockMouse:=StrToBool(INI.ReadString('sdl','autolock','true'));
    AGame.MouseSensitivity:=INI.ReadInteger('sdl','sensitivity',100);
    AGame.Priority:=Ini.ReadString('sdl','priority','higher,normal');
    AGame.UseScanCodes:=StrToBool(INI.ReadString('sdl','usescancodes','true'));
    AGame.CustomKeyMappingFile:=INI.ReadString('sdl','mapperfile','');
    If Trim(AGame.CustomKeyMappingFile)<>'' then AGame.CustomKeyMappingFile:=MakeRelPath(AGame.CustomKeyMappingFile,PrgSetup.BaseDir);

    AGame.VideoCard:=Ini.ReadString('dosbox','machine','vga');
    AGame.Memory:=INI.ReadInteger('dosbox','memsize',16);
    AGame.CaptureFolder:=MakeRelPath(INI.ReadString('dosbox','captures','.\'+CaptureSubDir+'\'),PrgSetup.BaseDir);

    AGame.FrameSkip:=INI.ReadInteger('render','frameskip',0);
    AGame.AspectCorrection:=StrToBool(INI.ReadString('render','aspect','false'));
    AGame.Scale:=INI.ReadString('render','scaler','normal2x');

    AGame.Core:=INI.ReadString('cpu','core','auto');
    AGame.Cycles:=INI.ReadString('cpu','cycles','auto');
    AGame.CyclesUp:=INI.ReadInteger('cpu','cycleup',500);
    AGame.CyclesDown:=INI.ReadInteger('cpu','cycledown',20);

    AGame.EMS:=StrToBool(INI.ReadString('dos','ems','true'));
    AGame.XMS:=StrToBool(INI.ReadString('dos','xms','true'));
    AGame.UMB:=StrToBool(INI.ReadString('dos','umb','true'));
    AGame.KeyboardLayout:=INI.ReadString('dos','keyboardlayout','none');

    AGame.MixerNosound:=StrToBool(INI.ReadString('mixer','nosound','false'));
    AGame.MixerRate:=Ini.ReadInteger('mixer','rate',22050);
    AGame.MixerBlocksize:=Ini.ReadInteger('mixer','blocksize',2048);
    AGame.MixerPrebuffer:=Ini.ReadInteger('mixer','prebuffer',10);

    AGame.SBType:=Ini.ReadString('sblaster','sbtype','sb16');
    AGame.SBBase:=Ini.ReadInteger('sblaster','sbbase',220);
    AGame.SBIRQ:=Ini.ReadInteger('sblaster','irq',7);
    AGame.SBDMA:=Ini.ReadInteger('sblaster','dma',1);
    AGame.SBHDMA:=Ini.ReadInteger('sblaster','hdma',5);
    AGame.SBMixer:=StrToBool(INI.ReadString('mixer','mixer','true'));
    AGame.SBOplMode:=Ini.ReadString('sblaster','oplmode','auto');
    AGame.SBOplRate:=Ini.ReadInteger('sblaster','oplrate',22050);

    AGame.GUS:=StrToBool(INI.ReadString('gus','gus','true'));
    AGame.GUSRate:=Ini.ReadInteger('gus','gusrate',22050);
    AGame.GUSBase:=Ini.ReadInteger('gus','gusbase',240);
    AGame.GUSIRQ1:=Ini.ReadInteger('gus','irg1',5);
    AGame.GUSIRQ2:=Ini.ReadInteger('gus','irq2',5);
    AGame.GUSDMA1:=Ini.ReadInteger('gus','dma1',3);
    AGame.GUSDMA2:=Ini.ReadInteger('gus','dma2',3);
    AGame.GUSUltraDir:=Ini.ReadString('gus','ultradir','C:\ULTRASND');

    AGame.MIDIType:=Ini.ReadString('midi','mpu401','intelligent');
    AGame.MIDIDevice:=Ini.ReadString('midi','device','default');
    AGame.MIDIConfig:=Ini.ReadString('midi','config','');

    AGame.SpeakerPC:=StrToBool(INI.ReadString('speaker','pcspeaker','true'));
    AGame.SpeakerRate:=Ini.ReadInteger('speaker','pcrate',22050);
    AGame.SpeakerTandy:=Ini.ReadString('speaker','tandy','auto');
    AGame.SpeakerRate:=Ini.ReadInteger('speaker','tandyrate',22050);
    AGame.SpeakerDisney:=StrToBool(INI.ReadString('speaker','disney','true'));

    AGame.JoystickType:=Ini.ReadString('joystick','joysticktype','auto');
    AGame.JoystickTimed:=StrToBool(INI.ReadString('joystick','timed','true'));
    AGame.JoystickAutoFire:=StrToBool(INI.ReadString('joystick','autofire','false'));
    AGame.JoystickSwap34:=StrToBool(INI.ReadString('joystick','swap34','false'));
    AGame.JoystickButtonwrap:=StrToBool(INI.ReadString('joystick','buttonwrap','true'));

    AGame.Serial1:=INI.ReadString('serial','serial1','dummy');
    AGame.Serial2:=INI.ReadString('serial','serial2','dummy');
    AGame.Serial3:=INI.ReadString('serial','serial3','disabled');
    AGame.Serial4:=INI.ReadString('serial','serial4','disabled');

    AGame.IPX:=StrToBool(INI.ReadString('ipx','ipx','false'));
  finally
    Ini.Free;
  end;
  LoadSpecialData(AGame,AFileName);
end;

Function ImportConfFile(const AGameDB : TGameDB; const AFileName : String) : TGame;
begin
  result:=AGameDB[AGameDB.Add(ChangeFileExt(ExtractFileName(AGameDB.ProfFileName(ExtractFileName(AFileName))),''))];
  ImportConfFileData(result,AFileName);
end;

Function GameCheckSumOK(const AGame : TGame) : Boolean;
Var S,T : String;
begin
  result:=True;
  If (AGame.GameExeMD5='') or (Trim(ExtUpperCase(AGame.GameExeMD5))='OFF') then exit;
  If AGame.GameExe='' then exit;
  T:=MakeAbsPath(AGame.GameExe,PrgSetup.BaseDir);
  If not FileExists(T) then exit;
  S:=GetMD5Sum(T); If S='' then exit;
  result:=(S=AGame.GameExeMD5);
end;

Function SetupCheckSumOK(const AGame : TGame) : Boolean;
Var S,T : String;
begin
  result:=True;
  If (AGame.SetupExeMD5='') or (Trim(ExtUpperCase(AGame.SetupExeMD5))='OFF') then exit;
  If AGame.SetupExe='' then exit;
  T:=MakeAbsPath(AGame.SetupExe,PrgSetup.BaseDir);
  If not FileExists(T) then exit;
  S:=GetMD5Sum(T); If S='' then exit;
  result:=(S=AGame.SetupExeMD5);
end;

Procedure CreateGameCheckSum(const AGame : TGame; const OverwriteExistingCheckSum : Boolean);
Var S : String;
begin
  If (AGame.GameExeMD5<>'') and (not OverwriteExistingCheckSum) then exit;
  If Trim(ExtUpperCase(AGame.GameExeMD5))='OFF' then exit;
  If AGame.GameExe='' then exit;
  S:=MakeAbsPath(AGame.GameExe,PrgSetup.BaseDir);
  if not FileExists(S) then exit;
  AGame.GameExeMD5:=GetMD5Sum(S);
end;

Procedure CreateSetupCheckSum(const AGame : TGame; const OverwriteExistingCheckSum : Boolean);
Var S : String;
begin
  If (AGame.SetupExeMD5<>'') and (not OverwriteExistingCheckSum) then exit;
  If Trim(ExtUpperCase(AGame.SetupExeMD5))='OFF' then exit;
  If AGame.SetupExe='' then exit;
  S:=MakeAbsPath(AGame.SetupExe,PrgSetup.BaseDir);
  if not FileExists(S) then exit;
  AGame.SetupExeMD5:=GetMD5Sum(S);
end;

Function ChecksumForGameOK(const AGame : TGame) : Boolean;
begin
  result:=True;
  If not PrgSetup.UseCheckSumsForProfiles then exit;
  result:=GameCheckSumOK(AGame);
end;

Function ChecksumForSetupOK(const AGame : TGame) : Boolean;
begin
  result:=True;
  If not PrgSetup.UseCheckSumsForProfiles then exit;
  result:=SetupCheckSumOK(AGame);
end;

Procedure ProfileEditorOpenCheck(const AGame : TGame);
Var St : TStringList;
    S : String;
begin
  If (AGame=nil) or (not PrgSetup.UseCheckSumsForProfiles) then exit;

  If not GameCheckSumOK(AGame) then begin
    St:=StringToStringList(LanguageSetup.CheckSumProfileEditorMismatch); try S:=St.Text; finally St.Free; end;
    S:=Format(S,[AGame.GameExe]);
    Case ShowCheckSumWarningDialog(Application.MainForm,S) of
      cdYes : CreateGameCheckSum(AGame,True);
      cdNo : ;
      cdTurnOff : begin AGame.GameExeMD5:='Off'; AGame.SetupExeMD5:='Off'; end;
    end;
  end;
  If not SetupCheckSumOK(AGame) then begin
    St:=StringToStringList(LanguageSetup.CheckSumProfileEditorMismatch); try S:=St.Text; finally St.Free; end;
    S:=Format(S,[AGame.SetupExe]);
    Case ShowCheckSumWarningDialog(Application.MainForm,S) of
      cdYes : CreateSetupCheckSum(AGame,True);
      cdNo : ;
      cdTurnOff : begin AGame.GameExeMD5:='Off'; AGame.SetupExeMD5:='Off'; end;
    end;
  end;
end;

Procedure ProfileEditorCloseCheck(const AGame : TGame; const NewGameExe, NewSetupExe : String);
Var NewGameFileName, NewSetupFileName : String;
    B1, B2 : Boolean;
begin
  NewGameFileName:=Trim(ExtUpperCase(ExtractFileName(NewGameExe)));
  NewSetupFileName:=Trim(ExtUpperCase(ExtractFileName(NewSetupExe)));
  B1:=Trim(ExtUpperCase(ExtractFileName(AGame.GameExe)))<>NewGameFileName;
  B2:=Trim(ExtUpperCase(ExtractFileName(AGame.SetupExe)))<>NewSetupFileName;
  AGame.GameExe:=NewGameExe;
  AGame.SetupExe:=NewSetupFileName;
  CreateGameCheckSum(AGame,B1);
  CreateSetupCheckSum(AGame,B2);
end;

Function RunCheck(const AGame : TGame; const RunSetup : Boolean) : Boolean;
Var S,T : String;
    St : TStringList;
begin
  result:=True;
  If not PrgSetup.UseCheckSumsForProfiles then exit;

  If RunSetup then begin
    If SetupCheckSumOK(AGame) then exit;
    S:=MakeAbsPath(AGame.SetupExe,PrgSetup.BaseDir);
  end else begin
    If GameCheckSumOK(AGame) then exit;
    S:=MakeAbsPath(AGame.GameExe,PrgSetup.BaseDir);
  end;

  St:=StringToStringList(LanguageSetup.CheckSumRunMismatch); try T:=St.Text; finally St.Free; end;
  S:=Format(T,[S]);
  Case ShowCheckSumWarningDialog(Application.MainForm,S) of
    cdYes     : begin
                  result:=True;
                  If RunSetup then CreateSetupCheckSum(AGame,True) else CreateGameCheckSum(AGame,True);
                end;
    cdNo      : result:=False;
    cdTurnOff : begin
                  result:=True;
                  AGame.GameExeMD5:='Off'; AGame.SetupExeMD5:='Off';
                end;
  end;
end;

Procedure CreateCheckSumsForAllGames(const AGameDB : TGameDB);
Var I : Integer;
begin
  InitProgressWindow(Application.MainForm,AGameDB.Count);
  try
    For I:=0 to AGameDB.Count-1 do begin
      CreateGameCheckSum(AGameDB[I],False);
      CreateSetupCheckSum(AGameDB[I],False);
      StepProgressWindow;
    end;
  finally
    DoneProgressWindow;
  end;
end;

Function GetLastModificationDate(const AGame : TGame) : String;
Var I : Integer;
    S,T : String;
begin
  result:='';
  I:=Pos('-',AGame.LastModification); If I=0 then exit;
  S:=''; try S:=DateToStr(StrToInt(Copy(AGame.LastModification,1,I-1))); except exit; end;
  T:=''; try T:=TimeToStr(StrToInt(Copy(AGame.LastModification,I+1,MaxInt))/86400); except exit; end;
  result:=S+' '+T;
end;

Function ScummVMMode(const Game : TGame) : Boolean;
begin
  result:=False;
  If Game=nil then exit;
  result:=(Trim(ExtUpperCase(Game.ProfileMode))='SCUMMVM');
end;

Function CheckGameDB(const GameDB : TGameDB) : TStringList;
Var I{,J} : Integer;
    Game : TGame;
    {S : String;}
    FirstError : Boolean;
    {St : TStringList;}
Procedure Error(const S : String); begin if FirstError then begin FirstError:=False; If result.Count>0 then result.Add(''); result.Add(Game.Name); end; result.Add('  '+S); end;
begin
  result:=TStringList.Create;

  InitProgressWindow(Application.MainForm,GameDB.Count);

  try
    For I:=0 to GameDB.Count-1 do begin
      Game:=GameDB[I];
      FirstError:=True;

      {If ScummVMMode(Game) then begin
        S:=IncludeTrailingPathDelimiter(MakeAbsPath(Trim(Game.ScummVMPath),PrgSetup.BaseDir));
        If not DirectoryExists(S) then Error(Format(LanguageSetup.MissingFilesGameDirectory,[S]));
      end else begin
        S:=Trim(Game.GameExe);
        If (S<>'') and (ExtUpperCase(Copy(S,1,7))<>'DOSBOX:') then begin
          S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If not FileExists(S) then Error(Format(LanguageSetup.MissingFilesGameFile,[S])) else begin
            If not ChecksumForGameOK(Game) then Error(Format(LanguageSetup.MissingFilesGameChecksum,[S]));
          end;
        end;
        S:=Trim(Game.SetupExe);
        If (S<>'') and (ExtUpperCase(Copy(S,1,7))='DOSBOX:') then begin
          S:=MakeAbsPath(S,PrgSetup.BaseDir);
          If not FileExists(S) then Error(Format(LanguageSetup.MissingFilesSetupFile,[S])) else begin
            If not ChecksumForSetupOK(Game) then Error(Format(LanguageSetup.MissingFilesSetupChecksum,[S]));
          end;
        end;
      end;

      S:=Trim(Game.CaptureFolder);
      If S<>'' then begin
        S:=IncludeTrailingPathDelimiter(MakeAbsPath(S,PrgSetup.BaseDir));
        If not DirectoryExists(S) then Error(Format(LanguageSetup.MissingFilesCaptureFolder,[S]));
      end;

      S:=MakeAbsIconName(Game.Icon);
      If S<>'' then begin
        If not FileExists(S) then Error(Format(LanguageSetup.MissingFilesIconFile,[S]));
      end;

      S:=Trim(Game.DataDir);
      If S<>'' then begin
        S:=IncludeTrailingPathDelimiter(MakeAbsPath(S,PrgSetup.BaseDir));
        If not DirectoryExists(S) then Error(Format(LanguageSetup.MissingFilesDataDirectory,[S]));
      end;

      S:=Trim(Game.ExtraFiles);
      If S<>'' then begin
        St:=ValueToList(S);
        try
          For J:=0 to St.Count-1 do If Trim(St[J])<>'' then begin
            S:=MakeAbsPath(St[J],PrgSetup.BaseDir);
            If not FileExists(S) then Error(Format(LanguageSetup.MissingFilesExtraFile,[S]));
          end;
        finally
          St.Free;
        end;
      end;

      S:=Trim(Game.ExtraDirs);
      If S<>'' then begin
        St:=ValueToList(S);
        try
          For J:=0 to St.Count-1 do If Trim(St[J])<>'' then begin
            S:=IncludeTrailingPathDelimiter(MakeAbsPath(IncludeTrailingPathDelimiter(St[J]),PrgSetup.BaseDir));
            If not DirectoryExists(S) then Error(Format(LanguageSetup.MissingFilesExtraDirectory,[S]));
          end;
        finally
          St.Free;
        end;
      end;}

      StepProgressWindow;
    end;
  finally
    DoneProgressWindow;
  end;
end;

initialization
  TempIcon:=TIcon.Create;
finalization
  TempIcon.Free;
end.
