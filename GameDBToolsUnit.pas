unit GameDBToolsUnit;
interface

uses Classes, ComCtrls, Controls, Menus, CheckLst, GameDBUnit, LinkFileUnit;

{DEFINE SpeedTest}

{ Load Data to GUI }

Type TSortListBy=(slbName=1, slbSetup=2, slbGenre=3, slbDeveloper=4, slbPublisher=5, slbYear=6, slbLanguage=7, slbComment=8);

Procedure InitTreeViewForGamesList(const ATreeView : TTreeView; const GameDB : TGameDB);
Procedure InitListViewForGamesList(const AListView : TListView; const ShowExtraInfo : Boolean);

Procedure AddGameToList(const AListView : TListView; var ItemsUsed : Integer; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const Game : TGame; const ShowExtraInfo : Boolean; const O,V : String; const VUserSt : TStringList; const T : String; const ScreenshotViewMode, ScummVMTemplate : Boolean); overload;
Procedure AddGameToList(const AListView : TListView; var ItemsUsed : Integer; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const Game : TGame; const ShowExtraInfo, ScreenshotViewMode, ScummVMTemplate : Boolean); overload;
Procedure AddGamesToList(const AListView : TListView; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const GameDB : TGameDB; const Group, SubGroup, SearchString : String; const ShowExtraInfo : Boolean; const SortBy : TSortListBy; const ReverseOrder, HideScummVMProfiles, HideWindowsProfiles, HideDefaultProfile, ScreenshotViewMode : Boolean); overload;
Procedure AddGamesToList(const AListView : TListView; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const GameDB : TGameDB; const Game : TGame; const Group, SubGroup, SearchString : String; const ShowExtraInfo : Boolean; const SortBy : TSortListBy; const ReverseOrder, HideScummVMProfiles, HideWindowsProfiles, HideDefaultProfile, ScreenshotViewMode : Boolean); overload;
Procedure GamesListSaveColWidths(const AListView : TListView);
Procedure GamesListLoadColWidths(const AListView : TListView);
Function GamesListSaveColWidthsToString(const AListView : TListView) : String;
Procedure GamesListLoadColWidthsFromString(const AListView : TListView; const Data : String);

Procedure AddScreenshotsToList(const AListView : TListView; const AImageList : TImageList; Dir : String);
Procedure AddSoundsToList(const AListView : TListView; Dir : String; ImageListIndex : Integer);
Procedure AddVideosToList(const AListView : TListView; Dir : String; ImageListIndex : Integer);

Procedure GetColOrderAndVisible(var O,V,VUser : String);
Function GetUserCols : String;
Procedure SetSortTypeByListViewCol(const ColumnIndex : Integer; var ListSort : TSortListBy; var ListSortReverse : Boolean);

Procedure InitMountingListView(const MountingListView : TListView);
Procedure LoadMountingListView(const MountingListView : TListView; const Mounting : TStringList);

{ Selection lists }

Procedure BuildCheckList(const CheckListBox : TCheckListBox; const GameDB : TGameDB; const WithDefaultProfile, HideScummVMAndWindowsProfiles : Boolean; const HideWindowsProfiles : Boolean = False);
Procedure BuildSelectPopupMenu(const Popup : TPopupMenu; const GameDB : TGameDB; const OnClick : TNotifyEvent; const WithDefaultProfile : Boolean; const HideWindowsProfiles : Boolean = False);
Procedure SelectGamesByPopupMenu(const Sender : TObject; const CheckListBox : TCheckListBox); overload;
Procedure SelectGamesByPopupMenu(const Sender : TObject; const ListView : TListView); overload;

Function GetUserDataList(const GameDB : TGameDB) : TStringList;

{ Upgrade from D-Fend / First-run init / Repair }

Procedure DeleteOldFiles;
Procedure ReplaceAbsoluteDirs(const GameDB : TGameDB);
Function BuildDefaultDosProfile(const GameDB : TGameDB; const CopyFiles : Boolean = True) : TGame;
Procedure BuildDefaultProfile;
Procedure ReBuildTemplates;
Function CopyFiles(Source, Dest : String; const OverwriteExistingFiles, ProcessMessages : Boolean) : Boolean;
Procedure UpdateUserDataFolderAndSettingsAfterUpgrade(const GameDB : TGameDB);
Procedure UpdateSettingsFilesLocation;

Var FreeDOSInitThreadRunning : Boolean = False;

{ Extras }

Procedure ExportGamesList(const GameDB : TGameDB; const FileName : String);
Procedure EditDefaultProfile(const AOwner : TComponent; const GameDB : TGameDB; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList);
Procedure CreateConfFilesForProfiles(const GameDB : TGameDB; const Dir : String);

Function EncodeUserHTMLSymbolsOnly(const S : String) : String;
Function EncodeHTMLSymbols(const S : String) : String;
Function DecodeHTMLSymbols(const S : String) : String;

{ History }

Procedure AddToHistory(const GameName : String);
Procedure LoadHistory(const AListView : TListView);
Procedure LoadHistoryStatistics(const AListView : TListView);
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
Function RunCheck(const AGame : TGame; const RunSetup : Boolean; const RunExtraFile : Integer = -1) : Boolean;
Procedure CreateCheckSumsForAllGames(const AGameDB : TGameDB);

Type T5StringArray=Array[0..4] of String;
Function GetAdditionalChecksumData(const AGame : TGame; Path : String; DataNeeded : Integer; var Files, Checksums : T5StringArray) : Integer;
Procedure AddAdditionalChecksumDataToAutoSetupTemplate(const AGame : TGame);

{ Last modification date }

Function GetLastModificationDate(const AGame : TGame) : String;

{ ScummVM and Windows files}

Function DOSBoxMode(const Game : TGame) : Boolean;
Function ScummVMMode(const Game : TGame) : Boolean;
Function WindowsExeMode(const Game : TGame) : Boolean;

{ CheckDB }

Function CheckGameDB(const GameDB : TGameDB) : TStringList;
Function CheckDoubleChecksums(const AutoSetupDB : TGameDB) : TStringList;

{ DOSBox versions }

Function GetDOSBoxNr(const Game : TGame) : Integer;

{ Viewing configuration files }

Procedure OpenConfigurationFile(const Game : TGame; const DeleteOnExit : TStringList);

{ Program file selection }

Function SelectProgramFile(var FileName : String; const HintFirstFile, HintSecondFile : String; const WindowsMode : Boolean; const OtherEmulator : Integer; const Owner : TComponent) : Boolean;

{ Change mounting settings in templates }

Function BuildGameDirMountData(const Template : TGame; const ProgrammFileDir, SetupFileDir : String) : TStringList; overload;
Procedure BuildGameDirMountData(const Mounting : TStringList; const ProgrammFileDir, SetupFileDir : String); overload;

implementation

uses Windows, SysUtils, Forms, Dialogs, Graphics, ShellAPI, ShlObj, IniFiles,
     Math, PNGImage, JPEG, GIFImage, CommonTools, LanguageSetupUnit, PrgConsts,
     PrgSetupUnit, ProfileEditorFormUnit, ModernProfileEditorFormUnit, HashCalc,
     SmallWaitFormUnit, ChecksumFormUnit, WaitFormUnit, ImageCacheUnit,
     DosBoxUnit, ScummVMUnit, ImageStretch, MainUnit;

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

Function RemoveDoubleEntrys(const St : TStringList) : TStringList; {return value = St}
Var I : Integer;
    Upper : TStringList;
    S : String;
begin
  result:=St;

  Upper:=TStringList.Create;
  try
    I:=0;
    While I<St.Count do begin
      If Trim(St[I])='' then begin St.Delete(I); continue; end;
      S:=ExtUpperCase(St[I]);
      If Upper.IndexOf(S)>=0 then begin St.Delete(I); continue; end;
      Upper.Add(S); inc(I);
    end;
  finally
    Upper.Free;
  end;
end;

Procedure InitTreeViewForGamesList(const ATreeView : TTreeView; const GameDB : TGameDB);
Var N,N2 : TTreeNode;
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

      AddTypeSelector(ATreeView,LanguageSetup.GameGenre,GetCustomGenreName(GameDB.GetGenreList));
      AddTypeSelector(ATreeView,LanguageSetup.GameDeveloper,GameDB.GetDeveloperList);
      AddTypeSelector(ATreeView,LanguageSetup.GamePublisher,GameDB.GetPublisherList);
      AddTypeSelector(ATreeView,LanguageSetup.GameYear,GameDB.GetYearList);
      AddTypeSelector(ATreeView,LanguageSetup.GameLanguage,GetCustomLanguageName(GameDB.GetLanguageList));
      UserGroups:=RemoveDoubleEntrys(StringToStringList(PrgSetup.UserGroups));
      try
        For I:=0 to UserGroups.Count-1 do
          AddTypeSelector(ATreeView,UserGroups[I],GameDB.GetKeyValueList(UserGroups[I]));
      finally
        UserGroups.Free;
      end;

      N:=ATreeView.Items.AddChild(nil,LanguageSetup.GameEmulationType);
      N.ImageIndex:=12; N.SelectedIndex:=12;
      N2:=ATreeView.Items.AddChild(N,LanguageSetup.GameEmulationTypeDOSBox); N2.ImageIndex:=16; N2.SelectedIndex:=16;
      N2:=ATreeView.Items.AddChild(N,LanguageSetup.GameEmulationTypeScummVM); N2.ImageIndex:=37; N2.SelectedIndex:=37;
      N2:=ATreeView.Items.AddChild(N,LanguageSetup.GameEmulationTypeWindows); N2.ImageIndex:=40; N2.SelectedIndex:=40;

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

Procedure GetColOrderAndVisible(var O,V,VUser : String);
Var I,UserCount : Integer;
    S : String;
begin
  V:=PrgSetup.ColVisible;

  I:=Pos(';',V);
  If I>0 then begin VUser:=Trim(Copy(V,I+1,MaxInt)); V:=Trim(Copy(V,1,I-1)); end else VUser:='';
  while length(V)<7 do V:=V+'1';
  If Length(V)>7 then V:=Copy(V,1,7);
  If VUser<>'' then PrgSetup.ColVisible:=V+';'+VUser else PrgSetup.ColVisible:=V;

  O:=PrgSetup.ColOrder;
  UserCount:=0; S:=VUser;
  While S<>'' do begin
    inc(UserCount);
    I:=Pos(';',S); If I=0 then break;
    S:=Trim(Copy(S,I+1,MaxInt));
  end;
  while length(O)<7+UserCount do If length(O)<9
    then O:=O+chr(length(O)+Ord('1'))
    else O:=O+chr(length(O)-9+Ord('A'));
  If Length(O)>7+UserCount then O:=Copy(O,1,7+UserCount);
  PrgSetup.ColOrder:=O;
end;

Function GetUserCols : String;
Var O,V : String;
begin
  GetColOrderAndVisible(O,V,result);
end;

Procedure SetSortTypeByListViewCol(const ColumnIndex : Integer; var ListSort : TSortListBy; var ListSortReverse : Boolean);
Procedure SetListSort(const L : TSortListBy);
begin
  If ListSort=L then ListSortReverse:=not ListSortReverse else begin ListSort:=L; ListSortReverse:=False; end;
end;
Var O,V,VUser : String;
    I,Nr,C : Integer;
    VUserSt : TStringList;
begin
  GetColOrderAndVisible(O,V,VUser);
  VUserSt:=ValueToList(VUser);
  try
    If ColumnIndex=0 then SetListSort(slbName) else begin
      If not PrgSetup.ShowExtraInfo then SetListSort(slbSetup) else begin
        C:=0;
        For I:=0 to length(O)-1 do begin
          Nr:=-1;
          Case O[I+1] of
            '1'..'9' : Nr:=StrToInt(O[I+1]);
            'A'..'Z' : Nr:=Ord(O[I+1])-Ord('A')+10;
            'a'..'z' : Nr:=Ord(O[I+1])-Ord('a')+10;
          end;
          If Nr<1 then continue;
          If Nr<=7 then begin
            If V[Nr]='0' then continue;
          end else begin
            If Nr-7>VUserSt.Count then continue;
          end;
          inc(C);
          If C=ColumnIndex then begin
            Case Nr-1 of
              0 : SetListSort(slbSetup);
              1 : SetListSort(slbGenre);
              2 : SetListSort(slbDeveloper);
              3 : SetListSort(slbPublisher);
              4 : SetListSort(slbYear);
              5 : SetListSort(slbLanguage);
              6 : SetListSort(slbComment);
              else SetListSort(TSortListBy((Nr-8+10)));
            end;
            break;
          end;
        end;
      end;
    end;
  finally
    VUserSt.Free;
  end;
end;

Procedure InitMountingListView(const MountingListView : TListView);
Var L : TListColumn;
begin
  L:=MountingListView.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingFolderImage;
  L:=MountingListView.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingAs;
  L:=MountingListView.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingLetter;
  L:=MountingListView.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingLabel;
  L:=MountingListView.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingIOControl;
end;

Procedure LoadMountingListView(const MountingListView : TListView; const Mounting : TStringList);
Var I : Integer;
    St : TStringList;
    L : TListItem;
    S,T,U : String;
    B : Boolean;
begin
  MountingListView.Items.BeginUpdate;
  try
    MountingListView.Items.Clear;
    For I:=0 to Mounting.Count-1 do begin
      St:=ValueToList(Mounting[I]);
      try
        L:=MountingListView.Items.Add;

        S:=Trim(St[0]);
        If St.Count>1 then begin
          T:=Trim(ExtUpperCase(St[1]));
          If Pos('$',S)<>0 then begin
            If (T='PHYSFS') or (T='ZIP')
              then S:=Copy(S,Pos('$',S)+1,MaxInt)+' (+ '+Copy(S,1,Pos('$',S)-1)+')'
              else S:=Copy(S,1,Pos('$',S)-1)+' (+'+LanguageSetup.More+')';
          end;
          If (T='CDROM') and (S='ASK') then S:=LanguageSetup.ProfileMountingCDDriveTypeAskShort;
          If (T='CDROM') and (Pos(':',S)<>0) then begin
            U:=Trim(Copy(S,1,Pos(':',S)-1));
            If U='NUMBER' then S:=Format(LanguageSetup.ProfileMountingCDDriveTypeNumberShort,[Copy(S,Pos(':',S)+1,MaxInt)]);
            If U='LABEL' then S:=Format(LanguageSetup.ProfileMountingCDDriveTypeLabelShort,[Copy(S,Pos(':',S)+1,MaxInt)]);
            If U='FILE' then S:=Format(LanguageSetup.ProfileMountingCDDriveTypeFileShort,[Copy(S,Pos(':',S)+1,MaxInt)]);
            If U='FOLDER' then S:=Format(LanguageSetup.ProfileMountingCDDriveTypeFolderShort,[Copy(S,Pos(':',S)+1,MaxInt)]);
          end;
        end;
        L.Caption:=S;

        If St.Count>1 then begin
          S:=Trim(ExtUpperCase(St[1])); B:=False;
          If (not B) and (S='DRIVE') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeDRIVE); B:=True; end;
          If (not B) and (S='CDROM') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeCDROM); B:=True; end;
          If (not B) and (S='CDROMIMAGE') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeCDROMIMAGE); B:=True; end;
          If (not B) and (S='FLOPPY') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeFLOPPY); B:=True; end;
          If (not B) and (S='FLOPPYIMAGE') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeFLOPPYIMAGE); B:=True; end;
          If (not B) and (S='IMAGE') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeIMAGE); B:=True; end;
          If (not B) and (S='PHYSFS') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypePHYSFS); B:=True; end;
          If (not B) and (S='ZIP') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeZIP); B:=True; end;
          If not B then L.SubItems.Add(St[1]);
        end else begin
          L.SubItems.Add('');
        end;

        If St.Count>2 then L.SubItems.Add(St[2]) else L.SubItems.Add('');
        If St.Count>4 then L.SubItems.Add(St[4]) else L.SubItems.Add('');
        If St.Count>3 then begin
          If Trim(ExtUpperCase(St[3]))='TRUE' then L.SubItems.Add(RemoveUnderline(LanguageSetup.Yes)) else L.SubItems.Add(RemoveUnderline(LanguageSetup.No));
        end else L.SubItems.Add(RemoveUnderline(LanguageSetup.No));

      finally
        St.Free;
      end;
    end;
    If MountingListView.Items.Count>0 then MountingListView.ItemIndex:=0;
  finally
    MountingListView.Items.EndUpdate;
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

Procedure BuildCheckList(const CheckListBox : TCheckListBox; const GameDB : TGameDB; const WithDefaultProfile, HideScummVMAndWindowsProfiles : Boolean; const HideWindowsProfiles : Boolean);
Var I : Integer;
    St : TStringList;
begin
  St:=TStringList.Create;
  try
    For I:=0 to GameDB.Count-1 do If WithDefaultProfile or (GameDB[I].Name<>DosBoxDOSProfile) then begin
      If HideScummVMAndWindowsProfiles and (ScummVMMode(GameDB[I]) or WindowsExeMode(GameDB[I])) then continue;
      If HideWindowsProfiles and WindowsExeMode(GameDB[I]) then continue;
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

Procedure BuildSelectPopupMenu(const Popup : TPopupMenu; const GameDB : TGameDB; const OnClick : TNotifyEvent; const WithDefaultProfile : Boolean; const HideWindowsProfiles : Boolean);
Var MenuSelect, MenuUnselect : TMenuItem;
    St : TStringList;
    I,J,K,Nr : Integer;
    S,T,U,SUpper : String;
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

  St:=GetCustomGenreName(GameDB.GetGenreList(WithDefaultProfile,HideWindowsProfiles));
  try BuildSelectPopupSubMenu(Popup,LanguageSetup.GameGenre,MenuSelect,MenuUnselect,0,OnClick,St); finally St.Free; end;

  St:=GameDB.GetDeveloperList(WithDefaultProfile,HideWindowsProfiles);
  try BuildSelectPopupSubMenu(Popup,LanguageSetup.GameDeveloper,MenuSelect,MenuUnselect,1,OnClick,St); finally St.Free; end;

  St:=GameDB.GetPublisherList(WithDefaultProfile,HideWindowsProfiles);
  try BuildSelectPopupSubMenu(Popup,LanguageSetup.GamePublisher,MenuSelect,MenuUnselect,2,OnClick,St); finally St.Free; end;

  St:=GameDB.GetYearList(WithDefaultProfile,HideWindowsProfiles);
  try BuildSelectPopupSubMenu(Popup,LanguageSetup.GameYear,MenuSelect,MenuUnselect,3,OnClick,St); finally St.Free; end;

  St:=GetCustomLanguageName(GameDB.GetLanguageList(WithDefaultProfile,HideWindowsProfiles));
  try BuildSelectPopupSubMenu(Popup,LanguageSetup.GameLanguage,MenuSelect,MenuUnselect,4,OnClick,St); finally St.Free; end;

  St:=TStringList.Create;
  try
    St.Add(LanguageSetup.GameEmulationTypeDOSBox);
    St.Add(LanguageSetup.GameEmulationTypeScummVM);
    If not HideWindowsProfiles then St.Add(LanguageSetup.GameEmulationTypeWindows);
    BuildSelectPopupSubMenu(Popup,LanguageSetup.GameEmulationType,MenuSelect,MenuUnselect,5,OnClick,St);
  finally
    St.Free;
  end;

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
          K:=Pos(';',T);
          While T<>'' do begin
            If K>0 then begin
              U:=Trim(Copy(T,1,K-1));
              T:=Trim(Copy(T,K+1,MaxInt));
            end else begin
              U:=T; T:='';
            end;
            If UserData[Nr].ValuesUpper.IndexOf(ExtUpperCase(U))<0 then begin
              UserData[Nr].Values.Add(U);
              UserData[Nr].ValuesUpper.Add(ExtUpperCase(U));
            end;
            K:=Pos(';',T);
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
  If CategoryValue=Trim(ExtUpperCase(LanguageSetup.NotSet)) then CategoryValue:='';
  Category:=M.Parent.Tag;
  Select:=(M.Parent.Parent.Tag=1);
  If Category=-1 then CategoryName:=RemoveUnderline(ExtUpperCase(M.Parent.Caption)) else CategoryName:='';

  For I:=0 to CheckListBox.Items.Count-1 do begin
    G:=TGame(CheckListBox.Items.Objects[I]);
    If CategoryName<>'' then begin
      If not UserDataContainValue(G.UserInfo,CategoryName,CategoryValue) then continue;
    end else begin
      Case Category of
        0 : S:=GetCustomGenreName(G.CacheGenre);
        1 : S:=G.CacheDeveloper;
        2 : S:=G.CachePublisher;
        3 : S:=G.CacheYear;
        4 : S:=GetCustomLanguageName(G.CacheLanguage);
        5 : begin
              S:='DOSBox';
              If ScummVMMode(G) then S:='ScummVM';
              If WindowsExeMode(G) then S:='Windows';
            end;
      end;
      S:=Trim(S);
      If ExtUpperCase(S)<>CategoryValue then continue;
    end;
    CheckListBox.Checked[I]:=Select;
  end;
end;

Procedure SelectGamesByPopupMenu(const Sender : TObject; const ListView : TListView);
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
  If CategoryValue=Trim(ExtUpperCase(LanguageSetup.NotSet)) then CategoryValue:='';
  Category:=M.Parent.Tag;
  Select:=(M.Parent.Parent.Tag=1);
  If Category=-1 then CategoryName:=RemoveUnderline(ExtUpperCase(M.Parent.Caption)) else CategoryName:='';

  For I:=0 to ListView.Items.Count-1 do begin
    G:=TGame(ListView.Items[I].Data);
    If CategoryName<>'' then begin
      If not UserDataContainValue(G.UserInfo,CategoryName,CategoryValue) then continue;
    end else begin
      Case Category of
        0 : S:=GetCustomGenreName(G.CacheGenre);
        1 : S:=G.CacheDeveloper;
        2 : S:=G.CachePublisher;
        3 : S:=G.CacheYear;
        4 : S:=GetCustomLanguageName(G.CacheLanguage);
        5 : begin
              S:='DOSBox';
              If ScummVMMode(G) then S:='ScummVM';
              If WindowsExeMode(G) then S:='Windows';
            end;
      end;
      S:=Trim(S);
      If ExtUpperCase(S)<>CategoryValue then continue;
    end;
    ListView.Items[I].Checked:=Select;
  end;
end;

Function GetUserDataList(const GameDB : TGameDB) : TStringList;
Var UserData : Array of TUserDataRecord;
    I,J,K,Nr : Integer;
    St : TStringList;
    S,T,SUpper : String;
begin
  SetLength(UserData,0);
  For I:=0 to GameDB.Count-1 do begin
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
        end;
      end;
    finally
      St.Free;
    end;
  end;
  result:=TStringList.Create;
  For I:=0 to length(UserData)-1 do result.Add(UserData[I].Name);
end;

Procedure InitListViewForGamesList(const AListView : TListView; const ShowExtraInfo : Boolean);
Var C : TListColumn;
    I,Nr : Integer;
    V,O,VUser : String;
    VUserSt : TStringList;
begin
  AListView.ReadOnly:=True;

  GetColOrderAndVisible(O,V,VUser);
  VUserSt:=ValueToList(VUser);
  try
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

      For I:=0 to length(O)-1 do begin
        Nr:=-1;
        Case O[I+1] of
          '1'..'9' : Nr:=StrToInt(O[I+1]);
          'A'..'Z' : Nr:=Ord(O[I+1])-Ord('A')+10;
          'a'..'z' : Nr:=Ord(O[I+1])-Ord('a')+10;
        end;
        If Nr<1 then continue;
        If Nr<=7 then begin
          If V[Nr]='0' then continue;
        end else begin
          If Nr-7>VUserSt.Count then continue;
        end;

        C:=AListView.Columns.Add;
        Case Nr-1 of
          0 : C.Caption:=GetCustomGenreName(LanguageSetup.GameSetup);
          1 : C.Caption:=LanguageSetup.GameGenre;
          2 : C.Caption:=LanguageSetup.GameDeveloper;
          3 : C.Caption:=LanguageSetup.GamePublisher;
          4 : C.Caption:=LanguageSetup.GameYear;
          5 : C.Caption:=GetCustomLanguageName(LanguageSetup.GameLanguage);
          6 : C.Caption:=LanguageSetup.GameNotes;
          else C.Caption:=VUserSt[Nr-8];
        end;
        If Nr-1=0 then C.Width:=-2 else C.Width:=-1;
      end;
    finally
      AListView.Columns.EndUpdate;
      AListView.Items.EndUpdate;
    end;
  finally
    VUserSt.Free;
  end;
end;

Procedure ScaleGraphicToImageList(const Graphic : TGraphic; const ImageList : TImageList; const UseFiltering : Boolean);
Var B,B2 : TBitmap;
    D1,D2 : Double;
    W,H : Integer;
begin
  B:=TBitmap.Create;
  try
    SetStretchBltMode(B.Canvas.Handle,STRETCH_HALFTONE);
    SetBrushOrgEx(B.Canvas.Handle,0,0,nil);
    B.Transparent:=True;

    B2:=nil;
    try
      B2:=TBitmap.Create;
      B2.Width:=Graphic.Width;
      B2.Height:=Graphic.Height;
      B2.Canvas.Draw(0,0,Graphic);

      B.Width:=ImageList.Width; B.Height:=ImageList.Height;
      D1:=B2.Width/B2.Height; D2:=B.Width/B.Height;
      If D1>=D2 then begin W:=B.Width; H:=Round(W/D1); end else begin H:=B.Height; W:=Round(H*D1); end;
      ScaleImage(B2,B,W,H,UseFiltering);
      ImageList.Add(B,nil);
    finally
      If B2<>nil then B2.Free;
    end;
  finally
    B.Free;
  end;
end;

Function LoadScreenshotToImageLists(const Game : TGame; ImageList2 : TImageList) : Boolean;
Var S,T,U : String;
    Rec : TSearchRec;
    I : Integer;
    P : TPicture;
    B : Boolean;
    St : TStringList;
begin
  result:=False;
  S:=Trim(Game.CaptureFolder);
  If S='' then exit;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  If not DirectoryExists(S) then exit;

  B:=False;
  If Trim(Game.ScreenshotListScreenshot)<>'' then begin
    If Pos('\',Game.ScreenshotListScreenshot)<>0 then begin
      T:=MakeAbsPath(Game.ScreenshotListScreenshot,PrgSetup.BaseDir);
    end else begin
      T:=IncludeTrailingPathDelimiter(S)+Trim(Game.ScreenshotListScreenshot);
    end;
    B:=FileExists(T);
  end;

  If (not B) and PrgSetup.ScreenshotListUseFirstScreenshot then begin
    T:='';
    St:=TStringList.Create;
    try
      I:=FindFirst(IncludeTrailingPathDelimiter(S)+'*.*',faAnyFile,Rec);
      try
        While I=0 do begin
          If (Rec.Attr and faDirectory)=0 then begin
            U:=ExtUpperCase(ExtractFileExt(Rec.Name));
            If (U='.BMP') or (U='.GIF') or (U='.PNG') or (U='.JPG') or (U='.JPEG') then St.Add(Rec.Name);
          end;
          I:=FindNext(Rec);
        end;
      finally
       FindClose(Rec);
      end;
      St.Sort;

      If St.Count>0 then T:=IncludeTrailingPathDelimiter(S)+St[Min(St.Count-1,Max(0,PrgSetup.ScreenshotListUseFirstScreenshotNr-1))];
    finally
      St.Free;
    end;
  end;
  
  If T='' then exit;

  P:=PictureCache.GetPicture(T);
  result:=(P<>nil);
  If result then ScaleGraphicToImageList(P.Graphic,ImageList2,True);
end;

Function UserInfoGetValue(const UserInfo, Key : String) : String;
Var I,J : Integer;
    St : TStringList;
    S,KeyUpper : String;
begin
 result:='';
 KeyUpper:=ExtUpperCase(Key);

  St:=StringToStringList(UserInfo);
  try
    For I:=0 to St.Count-1 do begin
      S:=Trim(ExtUpperCase(St[I]));
      J:=Pos('=',S);
      If J=0 then continue;
      If Trim(Copy(S,1,J-1))=KeyUpper then begin
        result:=Trim(Copy(Trim(St[I]),J+1,MaxInt));
        exit;
      end;
    end;
  finally
    St.Free;
  end;
end;

Procedure AddGameToList(const AListView : TListView; var ItemsUsed : Integer; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const Game : TGame; const ShowExtraInfo : Boolean; const O,V : String; const VUserSt : TStringList; const T : String; const ScreenshotViewMode, ScummVMTemplate : Boolean);
Var IconNr,I,J,Nr : Integer;
    B : Boolean;
    S : String;
    L : TListItem;
    SubUsed,SubCount : Integer;
    Icon : TIcon;
    St : TStringList;
begin
  {Set IconNr to the corrosponding icon in imagelist}
  B:=False; IconNr:=0;
  If ScreenshotViewMode then begin
    B:=LoadScreenshotToImageLists(Game,AListViewIconImageList);
    If B then IconNr:=AListViewIconImageList.Count-1;
  end;
  If not B then begin
    If Trim(Game.Icon)<>'' then S:=MakeAbsIconName(Game.Icon) else S:='';
    If (S='') and WindowsExeMode(Game) and PrgSetup.UseWindowsExeIcons then
      S:=MakeAbsIconName(MakeAbsPath(Game.GameExe,PrgSetup.BaseDir));
    If S<>'' then Icon:=IconCache.GetIcon(S) else Icon:=nil;
    B:=(Icon<>nil);
    If B then begin
      AListViewImageList.AddIcon(Icon);
      If ScreenshotViewMode then begin
        ScaleGraphicToImageList(Icon,AListViewIconImageList,True);
      end else begin
        If Icon.Width>=AListViewIconImageList.Width then begin
          I:=AListViewIconImageList.Count;
          AListViewIconImageList.AddIcon(Icon);
          If AListViewIconImageList.Count=I then ScaleGraphicToImageList(Icon,AListViewIconImageList,False);
        end else begin
          ScaleGraphicToImageList(Icon,AListViewIconImageList,False);
        end;
      end;
    end;
    If B then IconNr:=AListViewIconImageList.Count-1;
  end;

  {Set L to TListItem to use}
  If ItemsUsed=AListView.Items.Count
    then L:=AListView.Items.Add
    else L:=AListView.Items[ItemsUsed];
  inc(ItemsUsed);

  {Set caption}
  If (Game.CacheName='') and (not Game.OwnINI) then begin
    If ScummVMTemplate
      then L.Caption:=LanguageSetup.TemplateFormDefaultScummVM
      else L.Caption:=LanguageSetup.TemplateFormDefault;
  end else begin
    If L.Caption<>Game.CacheName then L.Caption:=Game.CacheName;
  end;

  {Set additional cols}
  with L do begin
    Data:=Game;

    SubUsed:=0; SubCount:=SubItems.Count;
    SubItems.BeginUpdate;
    try
      SubItems.Capacity:=Max(SubItems.Capacity,10);
      If ShowExtraInfo then begin
        For I:=0 to length(O)-1 do begin
          Nr:=-1;
          Case O[I+1] of
            '1'..'9' : Nr:=StrToInt(O[I+1]);
            'A'..'Z' : Nr:=Ord(O[I+1])-Ord('A')+10;
            'a'..'z' : Nr:=Ord(O[I+1])-Ord('a')+10;
          end;
          If Nr<1 then continue;
          If Nr<=7 then begin
            If V[Nr]='0' then continue;
          end else begin
            If Nr-7>VUserSt.Count then continue;
          end;
          Case Nr-1 of
            0 : If Trim(Game.SetupExe)<>'' then S:=LanguageSetupFastYes else S:=LanguageSetupFastNo;
            1 : begin S:=GetCustomGenreName(Game.CacheGenre); If Trim(S)='' then S:=T; end;
            2 : begin S:=Game.CacheDeveloper; If Trim(S)='' then S:=T; end;
            3 : begin S:=Game.CachePublisher; If Trim(S)='' then S:=T; end;
            4 : begin S:=Game.CacheYear; If Trim(S)='' then S:=T; end;
            5 : begin S:=GetCustomLanguageName(Game.CacheLanguage); If Trim(S)='' then S:=T; end;
            6 : begin
                  St:=StringToStringList(Game.Notes); S:=St.Text; St.Free;
                  For J:=1 to length(S) do if (S[J]=#10) or (S[J]=#13) then S[J]:=' ';
                  If length(S)>100 then S:=Copy(S,1,100)+'...';
                  If Trim(S)='' then S:=T;
                end;
            else S:=UserInfoGetValue(Game.UserInfo,VUserSt[Nr-8]);
          end;
          If SubUsed<SubCount then SubItems[SubUsed]:=S else SubItems.Add(S);
          inc(SubUsed);
        end;
      end else begin
        If Trim(Game.SetupExe)<>'' then S:=LanguageSetupFastYes else S:=LanguageSetupFastNo;
        If SubUsed<SubCount then begin
          If SubItems[SubUsed]<>S then SubItems[SubUsed]:=S;
        end else begin
          SubItems.Add(S);
        end;
        inc(SubUsed);
      end;
      While SubCount>SubUsed do begin SubItems.Delete(SubCount-1); dec(SubCount); end;
    finally
      SubItems.EndUpdate;
    end;
    ImageIndex:=IconNr;
  end;
end;

Procedure AddGameToList(const AListView : TListView; var ItemsUsed : Integer; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const Game : TGame; const ShowExtraInfo, ScreenshotViewMode, ScummVMTemplate : Boolean);
Var O,V,VUser,T : String;
    VUserSt : TStringList;
begin
  GetColOrderAndVisible(O,V,VUser);
  VUserSt:=ValueToList(VUser);
  try
    If Trim(PrgSetup.ValueForNotSet)='' then T:=LanguageSetup.NotSet else T:=Trim(PrgSetup.ValueForNotSet);
    AddGameToList(AListView,ItemsUsed,AListViewImageList,AListViewIconImageList,AImageList,Game,ShowExtraInfo,O,V,VUserSt,T,ScreenshotViewMode,ScummVMTemplate);
  finally
    VUserSt.Free;
  end;
end;

Procedure AddGamesToList(const AListView : TListView; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const GameDB : TGameDB; const Group, SubGroup, SearchString : String; const ShowExtraInfo : Boolean; const SortBy : TSortListBy; const ReverseOrder, HideScummVMProfiles, HideWindowsProfiles, HideDefaultProfile, ScreenshotViewMode : Boolean);
begin
  AddGamesToList(AListView,AListViewImageList,AListViewIconImageList,AImageList,GameDB,nil,Group,SubGroup,SearchString,ShowExtraInfo,SortBy,ReverseOrder,HideScummVMProfiles,HideWindowsProfiles,HideDefaultProfile,ScreenshotViewMode);
end;

Function GroupMatch(const GameGroupUpper, SelectedGroupUpper : String) : Boolean;
Var I : Integer;
    S : String;
begin
  result:=True;
  If GameGroupUpper=SelectedGroupUpper then exit;

  S:=GameGroupUpper;
  I:=Pos(';',S);
  If I<>0 then While S<>'' do begin
    If I>0 then begin
      If Trim(Copy(S,1,I-1))=SelectedGroupUpper then exit;
      S:=Trim(Copy(S,I+1,MaxInt));
    end else begin
      If Trim(S)=SelectedGroupUpper then exit;
      break;
    end;
    I:=Pos(';',S);
  end;

  result:=False;
end;

Procedure AddGamesToList(const AListView : TListView; const AListViewImageList, AListViewIconImageList, AImageList : TImageList; const GameDB : TGameDB; const Game : TGame; const Group, SubGroup, SearchString : String; const ShowExtraInfo : Boolean; const SortBy : TSortListBy; const ReverseOrder, HideScummVMProfiles, HideWindowsProfiles, HideDefaultProfile,  ScreenshotViewMode : Boolean); overload;
Var I,J,K,Nr,ItemsUsed : Integer;
    GroupUpper, SubGroupUpper, SearchStringUpper : String;
    B, FirstDefaultTemplate : Boolean;
    C : Array of Integer;
    List : TList;
    St,St2 : TStringList;
    S,T : String;
    O,V,VUser : String;
    EmType1,EmType2, EmType3 : String;
    Bitmap : TBitmap;
    VUserSt : TStringList;
    W : TWinControl;
    F : TForm;
    {$IFDEF SpeedTest}Ca : Cardinal;{$ENDIF}
begin
  {$IFDEF SpeedTest}Ca:=GetTickCount;{$ENDIF}

  {Prepare ListView}
  AListViewImageList.Clear;

  Bitmap:=TBitmap.Create;
  try
    AImageList.GetBitmap(0,Bitmap);
    ScaleGraphicToImageList(Bitmap,AListViewImageList,False);
  finally
    Bitmap.Free;
  end;

  AListViewIconImageList.Clear;
  If ScreenshotViewMode then begin
    Bitmap:=TBitmap.Create;
    try
      AImageList.GetBitmap(0,Bitmap);
      ScaleGraphicToImageList(Bitmap,AListViewIconImageList,False);
    finally
      Bitmap.Free;
    end;
  end else begin
    Bitmap:=TBitmap.Create;
    try
      AImageList.GetBitmap(0,Bitmap);
      ScaleGraphicToImageList(Bitmap,AListViewIconImageList,False);
    finally
      Bitmap.Free;
    end;
  end;
  SetLength(C,AListView.Columns.Count);
  AListView.Columns.BeginUpdate;
  try
    For I:=0 to length(C)-1 do begin C[I]:=AListView.Columns[I].Width; AListView.Columns[I].Width:=1; end;
  finally
    AListView.Columns.EndUpdate;
  end;

  List:=TList.Create;
  try
    {Select games to add}
    SearchStringUpper:=ExtUpperCase(Trim(SearchString));
    If SubGroup='' then begin
      B:=(Group=LanguageSetup.GameFavorites);
      for I:=0 to GameDB.Count-1 do begin
        If B and (not GameDB[I].Favorite) then continue;
        If HideDefaultProfile and (GameDB[I].Name=DosBoxDOSProfile) then continue;
        If HideScummVMProfiles and (ScummVMMode(GameDB[I]) or WindowsExeMode(GameDB[I])) then continue;
        If HideWindowsProfiles and WindowsExeMode(GameDB[I]) then continue;
        If (SearchStringUpper<>'') and (Pos(SearchStringUpper,GameDB[I].CacheNameUpper)=0) then continue;
        List.Add(GameDB[I]);
      end;
    end else begin
      GroupUpper:=Trim(ExtUpperCase(Group));
      If SubGroup=LanguageSetup.NotSet then SubGroupUpper:='' else SubGroupUpper:=ExtUpperCase(SubGroup);
      Nr:=6;
      If Group=LanguageSetup.GameGenre then Nr:=0;
      If Group=LanguageSetup.GameDeveloper then Nr:=1;
      If Group=LanguageSetup.GamePublisher then Nr:=2;
      If Group=LanguageSetup.GameYear then Nr:=3;
      If Group=LanguageSetup.GameLanguage then Nr:=4;
      If Group=LanguageSetup.GameEmulationType then Nr:=5;

      EmType1:=ExtUpperCase(LanguageSetup.GameEmulationTypeDOSBox);
      EmType2:=ExtUpperCase(LanguageSetup.GameEmulationTypeScummVM);
      EmType3:=ExtUpperCase(LanguageSetup.GameEmulationTypeWindows);

      For I:=0 to GameDB.Count-1 do begin
        If HideScummVMProfiles and (ScummVMMode(GameDB[I]) or WindowsExeMode(GameDB[I])) then continue;
        If HideDefaultProfile and (GameDB[I].Name=DosBoxDOSProfile) then continue;
        B:=False;
        Case Nr of
          0 : B:=GroupMatch(ExtUpperCase(GetCustomGenreName(GameDB[I].CacheGenre)),SubGroupUpper);
          1 : B:=GroupMatch(GameDB[I].CacheDeveloperUpper,SubGroupUpper);
          2 : B:=GroupMatch(GameDB[I].CachePublisherUpper,SubGroupUpper);
          3 : B:=GroupMatch(GameDB[I].CacheYearUpper,SubGroupUpper);
          4 : B:=GroupMatch(ExtUpperCase(GetCustomLanguageName(GameDB[I].CacheLanguage)),SubGroupUpper);
          5 : begin
                If (SubGroupUpper=EmType1) then B:=DOSBoxMode(GameDB[I]);
                If (SubGroupUpper=EmType2) then B:=ScummVMMode(GameDB[I]);
                If (SubGroupUpper=EmType3) then B:=WindowsExeMode(GameDB[I]);
              end;
          6 : begin
                B:=(SubGroupUpper='');
                St2:=StringToStringList(GameDB[I].CacheUserInfo);
                try
                  For J:=0 to St2.Count-1 do begin
                    S:=St2[J]; K:=Pos('=',S); If K=0 then T:='' else begin T:=Trim(Copy(S,K+1,MaxInt)); S:=Trim(Copy(S,1,K-1)); end;
                    If Trim(ExtUpperCase(S))=GroupUpper then begin B:=GroupMatch(Trim(ExtUpperCase(T)),SubGroupUpper); break; end;
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

    If Game<>nil then begin
      List.Add(Game); {DOSBox default template}
      List.Add(Game); {ScummVM default template}
    end;

    St:=TStringList.Create;
    try
      {Sort games}
      GetColOrderAndVisible(O,V,VUser);
      VUserSt:=ValueToList(VUser);
      try
        For I:=0 to List.Count-1 do begin
          Case SortBy of
            slbName : St.AddObject(TGame(List[I]).CacheName,TGame(List[I]));
            slbSetup : If Trim(TGame(List[I]).SetupExe)<>''
                         then St.AddObject(RemoveUnderline(LanguageSetup.Yes),TGame(List[I]))
                         else St.AddObject(RemoveUnderline(LanguageSetup.No),TGame(List[I]));
            slbGenre : St.AddObject(GetCustomGenreName(TGame(List[I]).CacheGenre),TGame(List[I]));
            slbDeveloper : St.AddObject(TGame(List[I]).CacheDeveloper,TGame(List[I]));
            slbPublisher : St.AddObject(TGame(List[I]).CachePublisher,TGame(List[I]));
            slbYear : St.AddObject(TGame(List[I]).CacheYear,TGame(List[I]));
            slbLanguage : St.AddObject(GetCustomLanguageName(TGame(List[I]).CacheLanguage),TGame(List[I]));
            slbComment : St.AddObject(TGame(List[I]).Notes,TGame(List[I]));
          End;
          If Integer(SortBy)>=10 then begin
            St.AddObject(UserInfoGetValue(TGame(List[I]).UserInfo,VUserSt[Min(VUserSt.Count-1,Integer(SortBy)-10)]),TGame(List[I]));
          end;
        end;
        St.Sort;

        {Add games to list}
        ItemsUsed:=0;
        If Trim(PrgSetup.ValueForNotSet)='' then T:=LanguageSetup.NotSet else T:=Trim(PrgSetup.ValueForNotSet);
        AListView.Items.BeginUpdate;
        try
          FirstDefaultTemplate:=True;

          F:=nil;
          If St.Count>50 then begin
            W:=AListView.Parent;
            While (W<>nil) and (not (W is TForm)) do W:=W.Parent;
            If W is TForm then F:=W as TForm;
            If Assigned(F) then F.Enabled:=False;
          end;

          try
            If ReverseOrder then begin
              For I:=St.Count-1 downto 0 do begin
                If (I mod 25=0) and Assigned(F) then Application.ProcessMessages;
                AddGameToList(AListView,ItemsUsed,AListViewImageList,AListViewIconImageList,AImageList,TGame(St.Objects[I]),ShowExtraInfo,O,V,VUserSt,T,ScreenshotViewMode,FirstDefaultTemplate);
                If (TGame(St.Objects[I]).CacheName='') and (not TGame(St.Objects[I]).OwnINI) then FirstDefaultTemplate:=False;
              end;
            end else begin
              For I:=0 to St.Count-1 do begin
                If (I mod 25=0) and Assigned(F) then Application.ProcessMessages;
                AddGameToList(AListView,ItemsUsed,AListViewImageList,AListViewIconImageList,AImageList,TGame(St.Objects[I]),ShowExtraInfo,O,V,VUserSt,T,ScreenshotViewMode, not FirstDefaultTemplate);
                If (TGame(St.Objects[I]).CacheName='') and (not TGame(St.Objects[I]).OwnINI) then FirstDefaultTemplate:=False;
              end;
            end;
          finally
            If Assigned(F) then F.Enabled:=True;
          end;
        finally
          AListView.Items.EndUpdate;
        end;
      finally
        VUserSt.Free;
      end;

      while ItemsUsed<AListView.Items.Count do AListView.Items.Delete(AListView.Items.Count-1);

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

  {$IFDEF SpeedTest}Application.MainForm.Caption:=IntToStr(GetTickCount-Ca);{$ENDIF}
end;

Function GamesListSaveColWidthsToString(const AListView : TListView) : String;
Var O,V,VUser : String;
    St,VUserSt : TStringList;
    I,Nr,C : Integer;
begin
  GetColOrderAndVisible(O,V,VUser);
  VUserSt:=ValueToList(VUser);
  try
    If PrgSetup.ShowExtraInfo then begin
      St:=ValueToList(PrgSetup.ColumnWidths);
      try
        while St.Count<8 do St.Add('-1');
        For I:=7 to St.Count-1 do St[I]:='-1';
        St[0]:=IntToStr(AListView.Column[0].Width);
        C:=0;
        For I:=0 to length(O)-1 do begin
          Nr:=-1;
          Case O[I+1] of
            '1'..'9' : Nr:=StrToInt(O[I+1]);
            'A'..'Z' : Nr:=Ord(O[I+1])-Ord('A')+10;
            'a'..'z' : Nr:=Ord(O[I+1])-Ord('a')+10;
          end;
          If Nr<1 then continue;
          If Nr<=7 then begin
            If V[Nr]='0' then continue;
          end else begin
            If Nr-7>VUserSt.Count then continue;
          end;
          inc(C);
          If AListView.Columns.Count>C then begin
            While St.Count<Nr+1 do St.Add('-1');
            St[Nr]:=IntToStr(AListView.Column[C].Width);
          end;
        end;
        result:=ListToValue(St);
      finally
        St.Free;
      end;
    end else begin
      St:=TStringList.Create;
      try
        St.Add(IntToStr(AListView.Column[0].Width));
        St.Add(IntToStr(AListView.Column[1].Width));
        result:=ListToValue(St);
      finally
        St.Free;
      end;
    end;
  finally
    VUserSt.Free;
  end;
end;

Procedure GamesListLoadColWidthsFromString(const AListView : TListView; const Data : String);
Var O,V,VUser : String;
    St,VUserSt : TStringList;
    I,Nr,C,W : Integer;
begin
  GetColOrderAndVisible(O,V,VUser);
  VUserSt:=ValueToList(VUser);
  try
    If PrgSetup.ShowExtraInfo then begin
      St:=ValueToList(Data);
      try
        while St.Count<8+VUserSt.Count do St.Add('');
        If TryStrToInt(St[0],W) and (W>=-2) and (W<1000) then AListView.Column[0].Width:=W;
        C:=0;
        For I:=0 to length(O)-1 do begin
          Nr:=-1;
          Case O[I+1] of
            '1'..'9' : Nr:=StrToInt(O[I+1]);
            'A'..'Z' : Nr:=Ord(O[I+1])-Ord('A')+10;
            'a'..'z' : Nr:=Ord(O[I+1])-Ord('a')+10;
          end;
          If Nr<1 then continue;
          If Nr<=7 then begin
            If V[Nr]='0' then continue;
          end else begin
            If Nr-7>VUserSt.Count then continue;
          end;
          inc(C);
          If Nr<St.Count then begin
            If TryStrToInt(St[Nr],W) and (W>=-2) and (W<1000) then AListView.Column[C].Width:=W;
          end;
        end;
      finally
        St.Free;
      end;
    end else begin
      St:=ValueToList(Data);
      try
        while St.Count<2 do St.Add('');
        If TryStrToInt(St[0],W) and (W>=-2) and (W<1000) then AListView.Column[0].Width:=W;
        If TryStrToInt(St[1],W) and (W>=-2) and (W<1000) then AListView.Column[1].Width:=W;
      finally
        St.Free;
      end;
    end;
  finally
    VUserSt.Free;
  end;
end;

Procedure GamesListSaveColWidths(const AListView : TListView);
begin
  If PrgSetup.ShowExtraInfo
    then PrgSetup.ColumnWidths:=GamesListSaveColWidthsToString(AListView)
    else PrgSetup.ColumnWidthsNoExtraInfoMode:=GamesListSaveColWidthsToString(AListView);
end;

Procedure GamesListLoadColWidths(const AListView : TListView);
begin
  If PrgSetup.ShowExtraInfo
    then GamesListLoadColWidthsFromString(AListView,PrgSetup.ColumnWidths)
    else GamesListLoadColWidthsFromString(AListView,PrgSetup.ColumnWidthsNoExtraInfoMode)
end;

Procedure AddScreenshotsToList(const AListView : TListView; const AImageList : TImageList; Dir : String);
Procedure CalcWH(const OldW, OldH, MaxW, MaxH : Integer; var NewW, NewH : Integer);
Var F : Double;
begin
  F:=OldW/OldH;

  If (OldW<=MaxW) and (OldH<=MaxH) then begin
    {too small scale up}
    If MaxH*F>MaxW then begin NewW:=MaxW; NewH:=Round(NewW/F); end else begin NewH:=MaxH; NewW:=Round(NewH*F); end;
    exit;
  end;

  {scale down}
  If OldW>MaxW then begin
    {too wide}
    NewW:=MaxW; NewH:=Round(NewW/F);
    {also to high ?}
    If NewH>MaxH then begin NewH:=MaxH; NewW:=Round(NewH*F); end;
    exit;
  end;

  {too high}
  NewH:=MaxH; NewW:=Round(NewH*F);
  {also too wide ?}
  If NewW>MaxW then begin NewW:=MaxW; NewH:=Round(NewW/F); end;
end;
Var I : Integer;
    Rec : TSearchRec;
    P : TPNGObject;
    J : TJPEGImage;
    G : TGIFImage;
    B,B2 : TBitmap;
    L : TListItem;
    OK : Boolean;
    NewW, NewH : Integer;
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
            try
              {not working well: B.Assign(P);}
              B.Width:=P.Width;
              B.Height:=P.Height;
              P.Draw(B.Canvas,Rect(0,0,B.Width-1,B.Height-1));

              B2:=TBitmap.Create;
              try
                B2.SetSize(AImageList.Width,AImageList.Height);
                CalcWH(B.Width,B.Height,AImageList.Width,AImageList.Height,NewW,NewH);
                ScaleImage(B,B2,NewW,NewH);
                AImageList.AddMasked(B2,clNone);
              finally
                B2.Free;
              end;
            except OK:=True; end;
            If OK then begin
              L:=AListView.Items.Add;
              L.Caption:=Rec.Name;
              L.ImageIndex:=AImageList.Count-1;
            end;
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
            try
              B.Assign(J);
              B2:=TBitmap.Create;
              try
                B2.SetSize(AImageList.Width,AImageList.Height);
                CalcWH(B.Width,B.Height,AImageList.Width,AImageList.Height,NewW,NewH);
                ScaleImage(B,B2,NewW,NewH);
                AImageList.AddMasked(B2,clNone);
              finally
                B2.Free;
              end;
            except OK:=False; end;
            If OK then begin
              L:=AListView.Items.Add;
              L.Caption:=Rec.Name;
              L.ImageIndex:=AImageList.Count-1;
            end;
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
            try
              B.Assign(J);
              B2:=TBitmap.Create;
              try
                B2.SetSize(AImageList.Width,AImageList.Height);
                CalcWH(B.Width,B.Height,AImageList.Width,AImageList.Height,NewW,NewH);
                ScaleImage(B,B2,NewW,NewH);
                AImageList.AddMasked(B2,clNone);
              finally
                B2.Free;
              end;
            except OK:=False end;
            If OK then begin
              L:=AListView.Items.Add;
              L.Caption:=Rec.Name;
              L.ImageIndex:=AImageList.Count-1;
            end;
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
            try
              B.Assign(G);
              B2:=TBitmap.Create;
              try
                B2.SetSize(AImageList.Width,AImageList.Height);
                CalcWH(B.Width,B.Height,AImageList.Width,AImageList.Height,NewW,NewH);
                ScaleImage(B,B2,NewW,NewH);
                AImageList.AddMasked(B2,clNone);
              finally
                B2.Free;
              end;
            except OK:=False; end;
            If OK then begin
              L:=AListView.Items.Add;
              L.Caption:=Rec.Name;
              L.ImageIndex:=AImageList.Count-1;
            end;
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
            try
              B2.SetSize(AImageList.Width,AImageList.Height);
                CalcWH(B.Width,B.Height,AImageList.Width,AImageList.Height,NewW,NewH);
                ScaleImage(B,B2,NewW,NewH);
              AImageList.AddMasked(B2,clNone);
            except OK:=False; end;
          finally
            B2.Free;
          end;
          If Ok then begin
            L:=AListView.Items.Add;
            L.Caption:=Rec.Name;
            L.ImageIndex:=AImageList.Count-1;
          end;
        end;
      finally
        B.Free;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  AListView.SortType:=stNone;
  AListView.SortType:=stText;
end;

Procedure AddSoundsToList(const AListView : TListView; Dir : String; ImageListIndex : Integer);
Procedure FindAndAddFiles(const Ext : String);
Var I : Integer;
    Rec : TSearchRec;
    L : TListItem;
begin
  I:=FindFirst(Dir+'*.'+Ext,faAnyFile,Rec);
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
begin
  Dir:=IncludeTrailingPathDelimiter(Dir);

  FindAndAddFiles('wav');
  FindAndAddFiles('mp3');
  FindAndAddFiles('ogg');
  FindAndAddFiles('mid');
  FindAndAddFiles('midi');

  AListView.SortType:=stNone;
  AListView.SortType:=stText;
end;

Procedure AddVideosToList(const AListView : TListView; Dir : String; ImageListIndex : Integer);
Var I : Integer;
    Rec : TSearchRec;
    L : TListItem;
begin
  Dir:=IncludeTrailingPathDelimiter(Dir);

  I:=FindFirst(Dir+'*.avi',faAnyFile,Rec);
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

  I:=FindFirst(Dir+'*.mpg',faAnyFile,Rec);
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

  I:=FindFirst(Dir+'*.mpeg',faAnyFile,Rec);
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

  I:=FindFirst(Dir+'*.wmv',faAnyFile,Rec);
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

  AListView.SortType:=stNone;
  AListView.SortType:=stText;
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
      ExtDeleteFile(Dir+Rec.Name,ftProfile);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Procedure DeleteOldFiles;
begin
  If not PrgSetup.CreateConfFilesForProfiles or (OperationMode=omPortable) then begin
    DeleteFiles(PrgDataDir+GameListSubDir,'*.conf');
  end;
  DeleteFiles(PrgDataDir+GameListSubDir,'tempprof.*');
  ExtDeleteFile(PrgDataDir+'Developers.dat',ftProfile);
  ExtDeleteFile(PrgDataDir+'Genres.dat',ftProfile);
  ExtDeleteFile(PrgDataDir+'Profiles.dat',ftProfile);
  ExtDeleteFile(PrgDataDir+'Publisher.dat',ftProfile);
  ExtDeleteFile(PrgDataDir+'stderr.txt',ftProfile);
  ExtDeleteFile(PrgDataDir+'stdout.txt',ftProfile);
  DeleteFiles(PrgDataDir,'temp.*');
  ExtDeleteFile(PrgDataDir+'Templates.dat',ftProfile);
  ExtDeleteFile(PrgDataDir+'Years.dat',ftProfile);
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
    G.CaptureFolder:=RemoveBackslash(MakeRelPath(G.CaptureFolder,PrgSetup.BaseDir,True));
    G.DataDir:=RemoveBackslash(MakeRelPath(G.DataDir,PrgSetup.BaseDir,True));

    St:=ValueToList(G.ExtraFiles);
    try
      For J:=0 to St.Count-1 do St[J]:=RemoveBackslash(MakeRelPath(St[J],PrgSetup.BaseDir));
      J:=0; while J<St.Count do If Trim(St[J])='' then St.Delete(J) else inc(J);
      G.ExtraFiles:=ListToValue(St);
    finally
      St.Free;
    end;

    St:=ValueToList(G.ExtraDirs);
    try
      For J:=0 to St.Count-1 do St[J]:=RemoveBackslash(MakeRelPath(St[J],PrgSetup.BaseDir,True));
      J:=0; while J<St.Count do If Trim(St[J])='' then St.Delete(J) else inc(J);
      G.ExtraDirs:=ListToValue(St);
    finally
      St.Free;
    end;

    For J:=0 to G.NrOfMounts-1 do begin
      St:=ValueToList(G.Mount[J]);
      try
        S:=Trim(St[0]); T:='';
        K:=Pos('$',S);
        while K>0 do begin
          T:=T+RemoveBackslash(MakeRelPath(Trim(Copy(S,1,K-1)),PrgSetup.BaseDir,True))+'$';
          S:=Trim(Copy(S,K+1,MaxInt));
          K:=Pos('$',S);
        end;
        T:=T+RemoveBackslash(MakeRelPath(Trim(S),PrgSetup.BaseDir,True));
        St[0]:=T;
        G.Mount[J]:=ListToValue(St);
      finally
        St.Free;
      end;
    end;

    G.StoreAllValues;
    G.LoadCache;
  end;
end;

Function CopyFiles(Source, Dest : String; const OverwriteExistingFiles, ProcessMessages : Boolean) : Boolean;
Var I : Integer;
    Rec : TSearchRec;
    Files, Folders : TStringList;
begin
  result:=False;

  Source:=IncludeTrailingPathDelimiter(Source);
  Dest:=IncludeTrailingPathDelimiter(Dest);
  if not ForceDirectories(Dest) then exit;

  Files:=TStringList.Create;
  Folders:=TStringList.Create;
  try
    I:=FindFirst(Source+'*.*',faAnyFile,Rec);
    try
      while I=0 do begin
        If (Rec.Attr and faDirectory)<>0 then begin
          If (Rec.Name<>'.') and (Rec.Name<>'..') then Folders.Add(Rec.Name);
        end else begin
          If ProcessMessages and (Files.Count mod 20 =0) then Application.ProcessMessages;
          Files.Add(Rec.Name);
        end;
        I:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;

    For I:=0 to Files.Count-1 do begin
      If ProcessMessages then Application.ProcessMessages;
      If OverwriteExistingFiles then begin
        if not CopyFile(PChar(Source+Files[I]),PChar(Dest+Files[I]),False) then exit;
      end else begin
        If not FileExists(Dest+Files[I]) then begin
          if not CopyFile(PChar(Source+Files[I]),PChar(Dest+Files[I]),False) then exit;
        end;
      end;
    end;

    For I:=0 to Folders.Count-1 do If not CopyFiles(Source+Folders[I],Dest+Folders[I],OverwriteExistingFiles,ProcessMessages) then exit;
  finally
    Files.Free;
    Folders.Free;
  end;

  result:=True;
end;

Procedure UpdateUserDataFolderAndSettingsAfterUpgrade(const GameDB : TGameDB);
Var Source : String;
    I : Integer;
    DB : TGameDB;
    B : Boolean;
begin
  {Copy new and changed NewUserData files to DataDir}
  If PrgDataDir<>PrgDir then begin

    {Update installer package base script}
    If FileExists(PrgDir+NSIInstallerHelpFile) then begin
      CopyFile(PChar(PrgDir+NSIInstallerHelpFile),PChar(PrgDataDir+SettingsFolder+'\'+NSIInstallerHelpFile),False); {False = overwrite existing file}
    end else begin
      If FileExists(PrgDir+BinFolder+'\'+NSIInstallerHelpFile) then begin
        CopyFile(PChar(PrgDir+BinFolder+'\'+NSIInstallerHelpFile),PChar(PrgDataDir+SettingsFolder+'\'+NSIInstallerHelpFile),False); {False = overwrite existing file}
      end;
    end;

    {Copy Icons.ini to settings folder}
    If FileExists(PrgDir+NewUserDataSubDir+'\'+IconsConfFile) then begin
      If FileExists(PrgDataDir+SettingsFolder+'\'+IconsConfFile) then begin
        If FileExists(PrgDataDir+SettingsFolder+'\'+ChangeFileExt(IconsConfFile,'.old')) then DeleteFile(PrgDataDir+SettingsFolder+'\'+ChangeFileExt(IconsConfFile,'.old'));
        RenameFile(PrgDataDir+SettingsFolder+'\'+IconsConfFile,PrgDataDir+SettingsFolder+'\'+ChangeFileExt(IconsConfFile,'.old'));
      end;
      CopyFile(PChar(PrgDir+NewUserDataSubDir+'\'+IconsConfFile),PChar(PrgDataDir+SettingsFolder+'\'+IconsConfFile),True);
    end;

    {Add new auto setup templates}
    CopyFiles(PrgDir+NewUserDataSubDir+'\'+AutoSetupSubDir,PrgDataDir+AutoSetupSubDir,False,True); {False = do not overwrite existing file}

    {Update DozZip}
    Source:=PrgDir+NewUserDataSubDir+'\DOSZIP\';
    If DirectoryExists(Source) then CopyFiles(Source,IncludeTrailingPathDelimiter(PrgSetup.GameDir)+'DOSZIP\',True,True);
  end;

  {Update video card default values}
  GameDB.ConfOpt.Video:=DefaultValuesVideo;
  GameDB.ConfOpt.StoreAllValues;

  {Update game DB: Max->max, Auto->auto}
  For I:=0 to GameDB.Count-1 do begin
    B:=False;
    If GameDB[I].Cycles='Max' then begin GameDB[I].Cycles:='max'; B:=True; end;
    If GameDB[I].Cycles='Auto' then begin GameDB[I].Cycles:='auto'; B:=True; end;
    If B then GameDB[I].StoreAllValues;
  end;

  {Update templates and auto setup template: vga->svga_s3}
  DB:=TGameDB.Create(PrgDataDir+TemplateSubDir,False);
  try
    For I:=0 to DB.Count-1 do begin
      B:=False;
      If Trim(ExtUpperCase(DB[I].VideoCard))='VGA' then begin DB[I].VideoCard:='vga_s3'; B:=True; end;
      If DB[I].Cycles='Max' then DB[I].Cycles:='max';
      If DB[I].Cycles='Auto' then DB[I].Cycles:='auto';
      If B then DB[I].StoreAllValues;
    end;
  finally
    DB.Free;
  end;
  DB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir,False);
  try
    For I:=0 to DB.Count-1 do begin
      B:=False;
      If Trim(ExtUpperCase(DB[I].VideoCard))='VGA' then begin DB[I].VideoCard:='vga_s3'; B:=True; end;
      If DB[I].Cycles='Max' then DB[I].Cycles:='max';
      If DB[I].Cycles='Auto' then DB[I].Cycles:='auto';
      If B then DB[I].StoreAllValues;
    end;
  finally
    DB.Free;
  end;

  {Change year from 2007 to 2009 and "multilingual" to "Multilingual" in "DOSBox DOS" profile}
  I:=GameDB.IndexOf(DosBoxDOSProfile);
  If (I>0) and (GameDB[I].CacheYear='2007') then begin
    GameDB[I].Year:='2009'; GameDB[I].StoreAllValues; GameDB[I].LoadCache;
  end;
  If (I>0) and (GameDB[I].CacheLanguage='multilingual') then begin
    GameDB[I].Language:='Multilingual'; GameDB[I].StoreAllValues; GameDB[I].LoadCache;
  end;

  {Update settings in ConfOpt.dat}
  If VersionToInt(PrgSetup.DFendVersion)<800 then begin
    GameDB.ConfOpt.Resolution:=DefaultValuesResolution;
    GameDB.ConfOpt.Scale:=DefaultValuesScale;
    GameDB.ConfOpt.Video:=DefaultValuesVideo;
  end;
  If VersionToInt(PrgSetup.DFendVersion)<801 then begin
    GameDB.ConfOpt.Joysticks:=DefaultValuesJoysticks;
    GameDB.ConfOpt.GUSRate:=DefaultValuesGUSRate;
    GameDB.ConfOpt.OPLRate:=DefaultValuesOPLRate;
    GameDB.ConfOpt.PCRate:=DefaultValuesPCRate;
    GameDB.ConfOpt.Rate:=DefaultValuesRate;
    GameDB.ConfOpt.Oplmode:=DefaultValuesOPLModes;
    GameDB.ConfOpt.SBBase:=DefaultValuesSBBase;
    GameDB.ConfOpt.GUSBase:=DefaultValuesGUSBase;
    GameDB.ConfOpt.Dma:=DefaultValuesDMA;
    GameDB.ConfOpt.GUSDma:=DefaultValuesDMA1;
    GameDB.ConfOpt.HDMA:=DefaultValuesHDMA;
    GameDB.ConfOpt.Memory:=DefaultValuesMemory;
  end;

  GameDB.ConfOpt.StoreAllValues;
end;

Procedure MoveDataFile(const FileName : String);
begin
  If not FileExists(PrgDataDir+FileName) then exit;

  If FileExists(PrgDataDir+SettingsFolder+'\'+FileName) then begin
    {File in new position already exists -> new version of DFR has already used -> delete old file}
    {Ext}DeleteFile(PrgDataDir+FileName{,ftProfile}); {Can't use ExtDelete because ExtDelete querys string from PrgSetup which is not loaded by this time}
  end else begin
    {Move data  file to new position}
    If CopyFile(PChar(PrgDataDir+FileName),PChar(PrgDataDir+SettingsFolder+'\'+FileName),True) then
      {Ext}DeleteFile(PrgDataDir+FileName{,ftProfile}); {Can't use ExtDelete because ExtDelete querys string from PrgSetup which is not loaded by this time}
  end;
end;

Procedure UpdateSettingsFilesLocation;
begin
  {Move configuration files to SettingsFolder}
  ForceDirectories(PrgDataDir+SettingsFolder);

  MoveDataFile(ConfOptFile);
  MoveDataFile(ScummVMConfOptFile);
  MoveDataFile(HistoryFileName);
  MoveDataFile(IconsConfFile);
  MoveDataFile(MainSetupFile);
  MoveDataFile('Links.txt');
  MoveDataFile('SearchLinks.txt');
  MoveDataFile(NSIInstallerHelpFile);
end;

Function RestoreFREEDOSFolder(const ShowWaitForm : Boolean) : Boolean;
Var Source1, Source2, Dest1, Dest2 : String;
    B1, B2 : Boolean;
begin
  result:=True;

  Source1:=PrgDir+NewUserDataSubDir+'\DOSZIP';
  Source2:=PrgDir+NewUserDataSubDir+'\FREEDOS';
  Dest1:=IncludeTrailingPathDelimiter(PrgSetup.GameDir)+'DOSZIP';
  Dest2:=IncludeTrailingPathDelimiter(PrgSetup.GameDir)+'FREEDOS';
  B1:=DirectoryExists(Source1);
  B2:=DirectoryExists(Source2);

  If B1 or B2 then begin
    If ShowWaitForm then LoadAndShowSmallWaitForm(LanguageSetup.SetupFormService3WaitInfo);
    try
      If B1 then result:=CopyFiles(Source1,Dest1,True,ShowWaitForm);
      If B2 then result:=CopyFiles(Source2,Dest2,True,ShowWaitForm);
    finally
      If ShowWaitForm then FreeSmallWaitForm;
    end;
  end;
end;

Type TRestoreFreeDOSFolderThread=class(TThread)
  protected
    Procedure Execute; override;
  public
    Constructor Create;
end;

Constructor TRestoreFreeDOSFolderThread.Create;
begin
  inherited Create(True);
  FreeOnTerminate:=True;
  Resume;
end;

Procedure TRestoreFreeDOSFolderThread.Execute;
begin
  FreeDOSInitThreadRunning:=True;
  try
    SetThreadPriority(GetCurrentThread,THREAD_PRIORITY_BELOW_NORMAL);
    While not MainWindowShowComplete do Sleep(100);
    RestoreFREEDOSFolder(False);
  finally
    FreeDOSInitThreadRunning:=False;
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
  result.Mount0:=MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir,True)+';Drive;C;false;';
  result.CloseDosBoxAfterGameExit:=False;
  result.Environment:='PATH[61]Z:\[13]';
  result.StartFullscreen:=False;
  result.CaptureFolder:=MakeRelPath(IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+DosBoxDOSProfile,PrgSetup.BaseDir);
  result.Genre:='Program';
  result.WWW:='http:/'+'/www.dosbox.com';
  result.Name:=DosBoxDOSProfile;
  result.Favorite:=True;
  result.Developer:='DOSBox Team';
  result.Publisher:='DOSBox Team';
  result.Year:='2009';
  result.Language:='Multilingual';
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
      ForceDirectories(MakeAbsPath(PrgSetup.CaptureDir,PrgSetup.BaseDir)+'DOSBox DOS');
      CopyFile(PChar(PrgDir+NewUserDataSubDir+'\'+CaptureSubDir+'\DOSBox DOS\dosbox_000.png'),PChar(MakeAbsPath(PrgSetup.CaptureDir,PrgSetup.BaseDir)+'DOSBox DOS\dosbox_000.png'),False);
    end;
  end;

  If FileExists(PrgDir+NSIInstallerHelpFile) then begin
    CopyFile(PChar(PrgDir+NSIInstallerHelpFile),PChar(PrgDataDir+SettingsFolder+'\'+NSIInstallerHelpFile),False);
  end else begin
    If FileExists(PrgDir+BinFolder+'\'+NSIInstallerHelpFile) then begin
      CopyFile(PChar(PrgDir+BinFolder+'\'+NSIInstallerHelpFile),PChar(PrgDataDir+SettingsFolder+'\'+NSIInstallerHelpFile),False);
    end;
  end;

  If FileExists(PrgDir+NewUserDataSubDir+'\'+IconsConfFile) then begin
    If FileExists(PrgDataDir+SettingsFolder+'\'+IconsConfFile) then begin
      If FileExists(PrgDataDir+SettingsFolder+'\'+ChangeFileExt(IconsConfFile,'.old')) then DeleteFile(PrgDataDir+SettingsFolder+'\'+ChangeFileExt(IconsConfFile,'.old'));
      RenameFile(PrgDataDir+SettingsFolder+'\'+IconsConfFile,PrgDataDir+SettingsFolder+'\'+ChangeFileExt(IconsConfFile,'.old'));
    end;
    CopyFile(PChar(PrgDir+NewUserDataSubDir+'\'+IconsConfFile),PChar(PrgDataDir+SettingsFolder+'\'+IconsConfFile),True);
  end;

  If CopyFiles then TRestoreFreeDOSFolderThread.Create;
end;

Procedure BuildDefaultProfile;
Var DefaultGame : TGame;
begin
  DefaultGame:=TGame.Create(PrgSetup);
  try
    DefaultGame.ResetToDefault;
    DefaultGame.NrOfMounts:=1;
    DefaultGame.Mount0:=MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir,True)+';Drive;C;false;';
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
      St.Add(S1+' : '+GetCustomGenreName(Genre));
      St.Add(S2+' : '+Developer);
      St.Add(S3+' : '+Publisher);
      St.Add(S4+' : '+Year);
      St.Add(S5+' : '+GetCustomLanguageName(Language));
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
        S:=Format('"%s";"%s";"%s";"%s";"%s";"%s";"%s"',[Name,GetCustomGenreName(Genre),Developer,Publisher,Year,GetCustomLanguageName(Language),WWW]);
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

Function EncodeUserHTMLSymbolsOnly(const S : String) : String;
Var I : Integer;
    St : TStringList;
    A,B : String;
begin
  result:=S;

  St:=ValueToList(LanguageSetup.CharsetHTMLTranslate,',');
  try
    If St.Count mod 2=1 then St.Add(St[St.Count-1]);
    For I:=0 to (St.Count div 2)-1 do begin
      A:=St[2*I]; If length(A)=0 then continue;
      B:=St[2*I+1]; If (B<>'') and (B[length(B)]<>';') then B:=B+';';
      If (A[1]='&') or (ExtUpperCase(B)='&AMP;') then continue;
      result:=Replace(result,A[1],B);
    end;
  finally
    St.Free;
  end;
end;

Function EncodeHTMLSymbols(const S : String) : String;
{Var I : Integer;
    A : String;}
begin
  result:=S;
  result:=Replace(result,'&','&amp;'); {must be the first, otherweise "ä" -> "&auml;" -> "&amp;auml;" will happen}
  result:=Replace(result,'<','&lt;');
  result:=Replace(result,'>','&gt;');
  result:=Replace(result,'"','&quot;');
  result:=Replace(result,'''','&apos;');
  result:=EncodeUserHTMLSymbolsOnly(result);

  {I:=1;
  While I<=length(result) do begin
    If (ord(result[I])>=32) and (ord(result[I])<=127) then begin inc(I); continue; end;
    A:='&#'+IntToStr(ord(result[I]))+';';
    result:=copy(result,1,I-1)+A+copy(result,I+1,MaxInt);
    inc(I,length(A));
  end;}
end;

Function TryStrToHex(const S : String; var Hex : Integer) : Boolean;
Var I : Integer;
begin
  result:=False;
  Hex:=0;
  For I:=1 to length(S) do begin
    Hex:=Hex*16;
    Case UpCase(S[I]) of
      '0'..'9' : Hex:=Hex+(ord(S[I])-ord('0'));
      'A'..'F' : Hex:=Hex+(ord(UpCase(S[I]))-ord('A')+10);
      else exit;
    End;
  end;
  result:=True;
end;

Function DecodeHTMLSymbols(const S : String) : String;
Var I,J,K : Integer;
    St : TStringList;
    A,B : String;
begin
  result:=S;
  result:=Replace(result,'&amp;','&');
  result:=Replace(result,'&lt;','<');
  result:=Replace(result,'&gt;','>');
  result:=Replace(result,'&quot;','"');
  result:=Replace(result,'&apos;','''');

  I:=1;
  While I<length(result)-1 do begin
    If (result[I]='&') and (result[I+1]='#') then begin
      If (I<length(result)-2) and (result[I+2]='x') then begin
        {Hex number}
        J:=0; while (I+3+J<length(result)) and (result[I+3+J]<>';') do inc(J);
        If (J>=1) and (J<=3) and TryStrToHex(Copy(result,I+3,J),K) then result:=copy(result,1,I-1)+chr(K)+copy(result,I+3+J);
      end else begin
        {Decimal number}
        J:=0; while (I+2+J<length(result)) and (result[I+2+J]<>';') do inc(J);
        If (J>=1) and (J<=2) and TryStrToInt(Copy(result,I+3,J),K) then result:=copy(result,1,I-1)+chr(K)+copy(result,I+2+J);
      end;
    end;
    inc(I);
  end;

  St:=ValueToList(LanguageSetup.CharsetHTMLTranslate,',');
  try
    If St.Count mod 2=1 then St.Add(St[St.Count-1]);
    For I:=0 to (St.Count div 2)-1 do begin
      A:=St[2*I]; If length(A)=0 then continue;
      B:=St[2*I+1]; If (B<>'') and (B[length(B)]<>';') then B:=B+';';
      If (A[1]='&') or (ExtUpperCase(B)='&AMP;') then continue;
      result:=Replace(result,B,A[1]);
    end;
  finally
    St.Free;
  end;
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
    St.Add('    <meta http-equiv="content-type" content="text/html; charset='+LanguageSetup.CharsetHTMLCharset+'">');
    St.Add('    <meta name="description" content="D-Fend Reloaded games list">');
    St.Add('    <meta name="DC.creator" content="D-Fend Reloaded '+GetNormalFileVersionAsString+'">');
    St.Add('    <style type="text/css">');
    St.Add('    <!--');
    St.Add('      body {font-family: Arial, Helvetica, sans-serif;}');
    St.Add('      table {border-collapse: collapse;}');
    St.Add('      td,th {border: solid 1px black; padding: 2px 4px 2px 4px;}');
    St.Add('    -->');
    St.Add('    </style>');
    St.Add('  </head>');
    St.Add('  <body>');
    St.Add('    <h1>'+EncodeHTMLSymbols(LanguageSetup.MenuFileExportGamesListHTMLTitle)+'</h1>');
    St.Add('    <table>');
    St.Add('      <tr>');
    St.Add(Format('        <th>%s</th>',[EncodeHTMLSymbols(LanguageSetup.GameName)]));
    St.Add(Format('        <th>%s</th>',[EncodeHTMLSymbols(LanguageSetup.GameGenre)]));
    St.Add(Format('        <th>%s</th>',[EncodeHTMLSymbols(LanguageSetup.GameDeveloper)]));
    St.Add(Format('        <th>%s</th>',[EncodeHTMLSymbols(LanguageSetup.GamePublisher)]));
    St.Add(Format('        <th>%s</th>',[EncodeHTMLSymbols(LanguageSetup.GameYear)]));
    St.Add(Format('        <th>%s</th>',[EncodeHTMLSymbols(LanguageSetup.GameLanguage)]));
    St.Add(Format('        <th>%s</th>',[EncodeHTMLSymbols(LanguageSetup.GameWWW)]));
    For I:=0 to UserList.Count-1 do St.Add(Format('        <th>%s</th>',[EncodeHTMLSymbols(UserList[I])]));
    St.Add('      </tr>');
    L:=GameDB.GetSortedGamesList;
    try
      For I:=0 to L.Count-1 do with TGame(L[I]) do begin
        St.Add('      <tr>');
        St.Add(Format('        <td>%s</td>',[EncodeHTMLSymbols(Name)]));
        St.Add(Format('        <td>%s</td>',[EncodeHTMLSymbols(GetCustomGenreName(Genre))]));
        St.Add(Format('        <td>%s</td>',[EncodeHTMLSymbols(Developer)]));
        St.Add(Format('        <td>%s</td>',[EncodeHTMLSymbols(Publisher)]));
        St.Add(Format('        <td>%s</td>',[EncodeHTMLSymbols(Year)]));
        St.Add(Format('        <td>%s</td>',[EncodeHTMLSymbols(GetCustomLanguageName(Language))]));
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

Procedure EditDefaultProfile(const AOwner : TComponent; const GameDB : TGameDB; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList);
Var DefaultGame : TGame;
    L,L2 : TList;
begin
  DefaultGame:=TGame.Create(PrgSetup);
  L:=TList.Create;
  L2:=TList.Create;
  try
    L.Add(DefaultGame);
    L2.Add(Pointer(1));
    If PrgSetup.DFendStyleProfileEditor then begin
      EditGameTemplate(AOwner,GameDB,DefaultGame,nil,ASearchLinkFile,ADeleteOnExit,L,L2);
    end else begin
      ModernEditGameTemplate(AOwner,GameDB,DefaultGame,nil,ASearchLinkFile,ADeleteOnExit,L,L2);
    end;
  finally
    DefaultGame.Free;
    L.Free;
    L2.Free;
  end;
end;

Function GetAllConfFiles(const Dir : String) : TStringList;
Var Rec : TSearchRec;
    I : Integer;
begin
  result:=TStringList.Create;

  I:=FindFirst(IncludeTrailingPathDelimiter(Dir)+'*.conf',faAnyFile,Rec);
  try
    While I=0 do begin
      If (Rec.Attr and faDirectory)=0 then result.Add(ExtUpperCase(Rec.Name));
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Function NeedUpdate(const ProfFile, ConfFile : String) : Boolean;
Var D1,D2 : TDateTime;
begin
  If not FileExists(ConfFile) then begin result:=True; exit; end;
  D1:=GetFileDate(ProfFile); D2:=GetFileDate(ConfFile);
  result:=(D1<0.001) or (D2<0.001) or (D2<D1-5/86400);
end;

Procedure CreateConfFilesForProfiles(const GameDB : TGameDB; const Dir : String);
Var St,St2 : TStringList;
    S,T : String;
    I,J : Integer;
begin
  St:=GetAllConfFiles(Dir);
  try
    For I:=0 to GameDB.Count-1 do begin
      If not DOSBoxMode(GameDB[I]) then continue;
      S:=GameDB[I].SetupFile; T:=ChangeFileExt(S,'.conf');
      If NeedUpdate(S,T) then begin
        St2:=BuildConfFile(GameDB[I],False,False,-1);
        try St2.SaveToFile(T); finally St2.Free; end;
      end;
      J:=St.IndexOf(ExtUpperCase(ExtractFileName(T))); If J>=0 then St.Delete(J);
    end;

    S:=IncludeTrailingPathDelimiter(Dir);
    For I:=0 to St.Count-1 do DeleteFile(S+St[I]);
  finally
    St.Free;
  end;
end;

Procedure AddToHistory(const GameName : String);
Var F : TextFile;
begin
  If Trim(GameName)='' then exit;

  try
    AssignFile(F,PrgDataDir+SettingsFolder+'\'+HistoryFileName);
    If FileExists(PrgDataDir+SettingsFolder+'\'+HistoryFileName) then Append(F) else Rewrite(F);
    try
      writeln(F,GameName+';'+DateToStr(Now)+';'+TimeToStr(Now));
    finally
      CloseFile(F);
    end;
  except
    MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[PrgDataDir+SettingsFolder+'\'+HistoryFileName]),mtError,[mbOK],0);
  end;
end;

Type TInfoRec=record
  Count : Integer;
  First, Last : TDateTime;
end;

Var StatisticData : Array of TInfoRec;

Function LoadStatisticData(var RawList, Games : TStringList) : Boolean;
Var I,J : Integer;
    S : String;
    D : TDateTime;
    Line : TStringList;
begin
  RawList:=nil;
  Games:=nil;
  SetLength(StatisticData,0);
  result:=False;

  if not FileExists(PrgDataDir+SettingsFolder+'\'+HistoryFileName) then exit;

  RawList:=TStringList.Create;
  Games:=TStringList.Create;

  try
    RawList.LoadFromFile(PrgDataDir+SettingsFolder+'\'+HistoryFileName);
  except
    MessageDlg(Format(LanguageSetup.MessageCouldNotOpenFile,[PrgDataDir+SettingsFolder+'\'+HistoryFileName]),mtError,[mbOK],0);
    FreeAndNil(RawList);
    FreeAndNil(Games);
    SetLength(StatisticData,0);
    exit;
  end;

  try
    For I:=0 to RawList.Count-1 do begin
      S:=Trim(RawList[I]);
      If S='' then continue;
      Line:=ValueToList(S);
      try
        If Line.Count<0 then continue;
        J:=Games.IndexOf(Line[0]);
        If J<0 then begin
          J:=Games.Add(Line[0]);
          SetLength(StatisticData,J+1);
          with StatisticData[J] do begin Count:=0; First:=0; Last:=0; end;
        end;
        inc(StatisticData[J].Count);
        If Line.Count<3 then continue;
        try
          D:=StrToDate(Line[1])+StrToTime(Line[2]);
          If (StatisticData[J].First=0) or (StatisticData[J].First>D) then StatisticData[J].First:=D;
          If StatisticData[J].Last<D then StatisticData[J].Last:=D;
         except end;
      finally
        Line.Free;
      end;
    end;
  except
    FreeAndNil(RawList);
    FreeAndNil(Games);
    SetLength(StatisticData,0);
    exit;
  end;

  result:=True;
end;

Procedure LoadHistory(const AListView : TListView);
Var C : TListColumn;
    RawList, Games, Line : TStringList;
    I,J : Integer;
    S : String;
    L : TListItem;
begin
  AListView.Items.BeginUpdate;
  try
    C:=AListView.Columns.Add;
    C.Caption:=LanguageSetup.HistoryGame;
    C.Width:=-2;
    C:=AListView.Columns.Add;
    C.Caption:=LanguageSetup.HistoryDate;
    C.Width:=-2;
    C:=AListView.Columns.Add;
    C.Caption:=LanguageSetup.HistoryTime;
    C.Width:=-2;
    C:=AListView.Columns.Add;
    C.Caption:=LanguageSetup.HistoryStarts;
    C.Width:=-2;

    if not LoadStatisticData(RawList,Games) then exit;
    try
      For I:=0 to RawList.Count-1 do begin
        S:=Trim(RawList[I]);
        If S='' then continue;
        Line:=ValueToList(S);
        try
          If Line.Count<1 then continue;
          L:=AListView.Items.Add;
          L.Caption:=Line[0];
          If Line.Count<2 then continue;
          L.SubItems.Add(Line[1]);
          If Line.Count<3 then continue;
          L.SubItems.Add(Line[2]);
          J:=Games.IndexOf(Line[0]);
          If J>=0 then L.SubItems.Add(IntToStr(StatisticData[J].Count)) else L.SubItems.Add('-');
        finally
          Line.Free;
        end;
      end;
    finally
      RawList.Free;
      Games.Free;
      SetLength(StatisticData,0);
    end;
  finally
    AListView.Items.EndUpdate;
  end;
end;

Procedure LoadHistoryStatistics(const AListView : TListView);
Var C : TListColumn;
    RawList,Games : TStringList;
    I : Integer;
    L : TListItem;
begin
  AListView.Items.BeginUpdate;
  try
    C:=AListView.Columns.Add;
    C.Caption:=LanguageSetup.HistoryGame;
    C.Width:=-2;
    C:=AListView.Columns.Add;
    C.Caption:=LanguageSetup.HistoryStarts;
    C.Width:=-2;
    C:=AListView.Columns.Add;
    C.Caption:=LanguageSetup.HistoryFirst;
    C.Width:=-2;
    C:=AListView.Columns.Add;
    C.Caption:=LanguageSetup.HistoryLast;
    C.Width:=-2;

    if not LoadStatisticData(RawList,Games) then exit;
    try
      For I:=0 to Games.Count-1 do begin
        L:=AListView.Items.Add;
        L.Caption:=Games[I];
        L.SubItems.Add(IntToStr(StatisticData[I].Count));
        If StatisticData[I].First>0 then L.SubItems.Add(DateToStr(StatisticData[I].First)+' '+TimeToStr(StatisticData[I].First)) else L.SubItems.Add('-');
        If StatisticData[I].Last>0 then L.SubItems.Add(DateToStr(StatisticData[I].Last)+' '+TimeToStr(StatisticData[I].Last)) else L.SubItems.Add('-');
      end;
    finally
      RawList.Free;
      Games.Free;
      SetLength(StatisticData,0);
    end;
  finally
    AListView.Items.EndUpdate;
  end;
end;

Procedure ClearHistory;
begin
  if not FileExists(PrgDataDir+SettingsFolder+'\'+HistoryFileName) then exit;
  if not ExtDeleteFile(PrgDataDir+SettingsFolder+'\'+HistoryFileName,ftProfile) then
    MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[PrgDataDir+SettingsFolder+'\'+HistoryFileName]),mtError,[mbOK],0);
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
  S:=MakeRelPath(RealFolder,PrgSetup.BaseDir,True)+';Drive;'+Letter+';;'+FreeSpace;

  Game.Mount[Game.NrOfMounts]:=S;
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
    ExtDeleteFile(FileName,ftProfile);
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
    AGame.CaptureFolder:=MakeRelPath(INI.ReadString('dosbox','captures',IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)),PrgSetup.BaseDir,True);

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
    AGame.SBBase:=Ini.ReadString('sblaster','sbbase','220');
    AGame.SBIRQ:=Ini.ReadInteger('sblaster','irq',7);
    AGame.SBDMA:=Ini.ReadInteger('sblaster','dma',1);
    AGame.SBHDMA:=Ini.ReadInteger('sblaster','hdma',5);
    AGame.SBMixer:=StrToBool(INI.ReadString('mixer','mixer','true'));
    AGame.SBOplMode:=Ini.ReadString('sblaster','oplmode','auto');
    AGame.SBOplRate:=Ini.ReadInteger('sblaster','oplrate',22050);

    AGame.GUS:=StrToBool(INI.ReadString('gus','gus','true'));
    AGame.GUSRate:=Ini.ReadInteger('gus','gusrate',22050);
    AGame.GUSBase:=Ini.ReadString('gus','gusbase','240');
    AGame.GUSIRQ:=Ini.ReadInteger('gus','irg1',5);
    AGame.GUSDMA:=Ini.ReadInteger('gus','dma1',3);
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
  result:=AGameDB[AGameDB.Add(ChangeFileExt(ExtractFileName(AGameDB.ProfFileName(ExtractFileName(AFileName),True)),''))];
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

Function RunCheck(const AGame : TGame; const RunSetup : Boolean; const RunExtraFile : Integer) : Boolean;
Var S,T : String;
    St : TStringList;
begin
  result:=True;
  If not PrgSetup.UseCheckSumsForProfiles then exit;

  If RunExtraFile>=0 then begin
    exit;
  end else begin
    If RunSetup then begin
      If SetupCheckSumOK(AGame) then exit;
      S:=MakeAbsPath(AGame.SetupExe,PrgSetup.BaseDir);
    end else begin
      If GameCheckSumOK(AGame) then exit;
      S:=MakeAbsPath(AGame.GameExe,PrgSetup.BaseDir);
    end;
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

Function GetAdditionalChecksumData(const AGame : TGame; Path : String; DataNeeded : Integer; var Files, Checksums : T5StringArray) : Integer;
const GoodFileExt : Array[0..11] of String = ('EXE','COM','DAT','ICO','HLP','DRV','DLL','PAK','PIC','LFL','BIN','OVL');
Var I,J : Integer;
    Exe1,Exe2,S : String;
    Rec : TSearchRec;
    OK : Boolean;
begin
  result:=0;
  Path:=IncludeTrailingPathDelimiter(Path);

  If Trim(AGame.GameExe)<>'' then Exe1:=Trim(ExtUpperCase(ExtractFileName(MakeAbsPath(AGame.GameExe,PrgSetup.BaseDir)))) else Exe1:='';
  If Trim(AGame.SetupExe)<>'' then Exe2:=Trim(ExtUpperCase(ExtractFileName(MakeAbsPath(AGame.SetupExe,PrgSetup.BaseDir)))) else Exe2:='';

  I:=FindFirst(Path+'*.*',faAnyFile,Rec);
  try
    While (I=0) and (DataNeeded>0) do begin
      If (Rec.Attr and faDirectory)=0 then begin
        S:=ExtUpperCase(Rec.Name);
        If (S<>Exe1) and (S<>Exe2) then begin
          S:=ExtractFileExt(Rec.Name); If (S<>'') and (S[1]='.') then S:=Copy(S,2,MaxInt);
          OK:=False;
          For J:=Low(GoodFileExt) to High(GoodFileExt) do If GoodFileExt[J]=S then begin OK:=True; break; end;
          If OK then begin
            Files[result]:=Rec.Name;
            Checksums[result]:=GetMD5Sum(Path+Rec.Name);
            inc(result); dec(DataNeeded);
          end;
        end;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Procedure AddAdditionalChecksumDataToAutoSetupTemplate(const AGame : TGame);
Var DataNeeded, DataAvailable,I : Integer;
    Path : String;
    Files, Checksums : T5StringArray;
begin
  If Trim(AGame.GameExe)='' then exit;

  DataNeeded:=0;
  If Trim(AGame.AddtionalChecksumFile1Checksum)='' then inc(DataNeeded);
  If Trim(AGame.AddtionalChecksumFile2Checksum)='' then inc(DataNeeded);
  If Trim(AGame.AddtionalChecksumFile3Checksum)='' then inc(DataNeeded);
  If Trim(AGame.AddtionalChecksumFile4Checksum)='' then inc(DataNeeded);
  If Trim(AGame.AddtionalChecksumFile5Checksum)='' then inc(DataNeeded);

  Path:=IncludeTrailingPathDelimiter(ExtractFilePath(MakeAbsPath(AGame.GameExe,PrgSetup.BaseDir)));

  DataAvailable:=GetAdditionalChecksumData(AGame,Path,DataNeeded,Files,Checksums);

  I:=0;
  If (Trim(AGame.AddtionalChecksumFile1Checksum)='') and (I<DataAvailable) then begin
    AGame.AddtionalChecksumFile1:=Files[I];
    AGame.AddtionalChecksumFile1Checksum:=Checksums[I];
    inc(I);
  end;
  If (Trim(AGame.AddtionalChecksumFile2Checksum)='') and (I<DataAvailable) then begin
    AGame.AddtionalChecksumFile2:=Files[I];
    AGame.AddtionalChecksumFile2Checksum:=Checksums[I];
    inc(I);
  end;
  If (Trim(AGame.AddtionalChecksumFile3Checksum)='') and (I<DataAvailable) then begin
    AGame.AddtionalChecksumFile3:=Files[I];
    AGame.AddtionalChecksumFile3Checksum:=Checksums[I];
    inc(I);
  end;
  If (Trim(AGame.AddtionalChecksumFile4Checksum)='') and (I<DataAvailable) then begin
    AGame.AddtionalChecksumFile4:=Files[I];
    AGame.AddtionalChecksumFile4Checksum:=Checksums[I];
    inc(I);
  end;
  If (Trim(AGame.AddtionalChecksumFile5Checksum)='') and (I<DataAvailable) then begin
    AGame.AddtionalChecksumFile5:=Files[I];
    AGame.AddtionalChecksumFile5Checksum:=Checksums[I];
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

Function DOSBoxMode(const Game : TGame) : Boolean;
Var S : String;
begin
  result:=False;
  If Game=nil then exit;
  S:=Trim(ExtUpperCase(Game.ProfileMode));
  result:=(S<>'SCUMMVM') and (S<>'WINDOWS');
end;

Function ScummVMMode(const Game : TGame) : Boolean;
begin
  result:=False;
  If Game=nil then exit;
  result:=(Trim(ExtUpperCase(Game.ProfileMode))='SCUMMVM');
end;

Function WindowsExeMode(const Game : TGame) : Boolean;
begin
  result:=False;
  If Game=nil then exit;
  result:=(Trim(ExtUpperCase(Game.ProfileMode))='WINDOWS');
end;

Function CheckGameDB(const GameDB : TGameDB) : TStringList;
Var I,J : Integer;
    Game : TGame;
    S : String;
    FirstError : Boolean;
    St : TStringList;
Procedure Error(const S : String); begin if FirstError then begin FirstError:=False; If result.Count>0 then result.Add(''); result.Add(Game.Name); end; result.Add('  '+S); end;
begin
  result:=TStringList.Create;

  InitProgressWindow(Application.MainForm,GameDB.Count);

  try
    For I:=0 to GameDB.Count-1 do begin
      Game:=GameDB[I];
      FirstError:=True;

      If ScummVMMode(Game) then begin
        S:=IncludeTrailingPathDelimiter(MakeAbsPath(Trim(Game.ScummVMPath),PrgSetup.BaseDir));
        If not DirectoryExists(S) then Error(Format(LanguageSetup.MissingFilesGameDirectory,[S]));
      end else begin
        If WindowsExeMode(Game) then begin
          S:=Trim(Game.GameExe);
          If S<>'' then begin
            S:=MakeAbsPath(S,PrgSetup.BaseDir);
            If not FileExists(S) then Error(Format(LanguageSetup.MissingFilesGameFile,[S])) else begin
              If not ChecksumForGameOK(Game) then Error(Format(LanguageSetup.MissingFilesGameChecksum,[S]));
            end;
          end;
          S:=Trim(Game.SetupExe);
          If S<>'' then begin
            S:=MakeAbsPath(S,PrgSetup.BaseDir);
            If not FileExists(S) then Error(Format(LanguageSetup.MissingFilesSetupFile,[S])) else begin
              If not ChecksumForSetupOK(Game) then Error(Format(LanguageSetup.MissingFilesSetupChecksum,[S]));
            end;
          end;
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
      end;

      StepProgressWindow;
    end;
  finally
    DoneProgressWindow;
  end;
end;

Function ExtendedChecksumCompare(const A1,A2 : TGame) : Boolean;
Var St1, St1c, St2, St2c : TStringList;
    I,J : Integer;
begin
  result:=False;

  St1:=TStringList.Create;
  St1c:=TStringList.Create;
  St2:=TStringList.Create;
  St2c:=TStringList.Create;
  try
    If A1.AddtionalChecksumFile1<>'' then begin St1.Add(ExtUpperCase(A1.AddtionalChecksumFile1)); St1c.Add(A1.AddtionalChecksumFile1Checksum); end;
    If A1.AddtionalChecksumFile2<>'' then begin St1.Add(ExtUpperCase(A1.AddtionalChecksumFile2)); St1c.Add(A1.AddtionalChecksumFile2Checksum); end;
    If A1.AddtionalChecksumFile3<>'' then begin St1.Add(ExtUpperCase(A1.AddtionalChecksumFile3)); St1c.Add(A1.AddtionalChecksumFile3Checksum); end;
    If A1.AddtionalChecksumFile4<>'' then begin St1.Add(ExtUpperCase(A1.AddtionalChecksumFile4)); St1c.Add(A1.AddtionalChecksumFile4Checksum); end;
    If A1.AddtionalChecksumFile5<>'' then begin St1.Add(ExtUpperCase(A1.AddtionalChecksumFile5)); St1c.Add(A1.AddtionalChecksumFile5Checksum); end;
    If A2.AddtionalChecksumFile1<>'' then begin St2.Add(ExtUpperCase(A2.AddtionalChecksumFile1)); St2c.Add(A2.AddtionalChecksumFile1Checksum); end;
    If A2.AddtionalChecksumFile2<>'' then begin St2.Add(ExtUpperCase(A2.AddtionalChecksumFile2)); St2c.Add(A2.AddtionalChecksumFile2Checksum); end;
    If A2.AddtionalChecksumFile3<>'' then begin St2.Add(ExtUpperCase(A2.AddtionalChecksumFile3)); St2c.Add(A2.AddtionalChecksumFile3Checksum); end;
    If A2.AddtionalChecksumFile4<>'' then begin St2.Add(ExtUpperCase(A2.AddtionalChecksumFile4)); St2c.Add(A2.AddtionalChecksumFile4Checksum); end;
    If A2.AddtionalChecksumFile5<>'' then begin St2.Add(ExtUpperCase(A2.AddtionalChecksumFile5)); St2c.Add(A2.AddtionalChecksumFile5Checksum); end;

    For I:=0 to St1.Count-1 do begin
      J:=St2.IndexOf(St1[I]);
      If (J>=0) and (St1c[I]<>St2c[J]) then begin result:=True; exit; end;
    end;

  finally
    St1.Free;
    St1c.Free;
    St2.Free;
    St2c.Free;
  end;
end;

Function CheckDoubleChecksums(const AutoSetupDB : TGameDB) : TStringList;
Var I,J : Integer;
    Names, Sums : TStringList;
    S : String;
begin
  result:=TStringList.Create;

  Names:=TStringList.Create;
  Sums:=TStringList.Create;
  try
    For I:=0 to AutoSetupDB.Count-1 do begin

      S:=Trim(ExtUpperCase(AutoSetupDB[I].GameExe));
      If Trim(S)='' then continue;
      J:=Names.IndexOf(S);
      If J<0 then begin
        Names.AddObject(S,TObject(I));
        Sums.Add(AutoSetupDB[I].GameExeMD5);
      end else begin
        If (Sums[J]=AutoSetupDB[I].GameExeMD5) and (not ExtendedChecksumCompare(AutoSetupDB[Integer(Names.Objects[J])],AutoSetupDB[I])) then
          result.Add(AutoSetupDB[Integer(Names.Objects[J])].CacheName+' <-> '+AutoSetupDB[I].CacheName);
      end;
    end;
  finally
    Names.Free;
    Sums.Free;
  end;
end;

Function GetDOSBoxNr(const Game : TGame) : Integer;
Var I : Integer;
    S : String;
begin
  result:=-1;
  S:=Trim(ExtUpperCase(Game.CustomDOSBoxDir));
  If (S='DEFAULT') or (S='') then begin result:=0; exit; end;

  For I:=1 to PrgSetup.DOSBoxSettingsCount-1 do If Trim(ExtUpperCase(PrgSetup.DOSBoxSettings[I].Name))=S then begin result:=I; break; end;
end;

Procedure OpenConfigurationFile(const Game : TGame; const DeleteOnExit : TStringList);
Var S,T : String;
    St : TStringList;
begin
  If WindowsExeMode(Game) then exit;
  If ScummVMMode(Game) then begin
    S:=TempDir+ChangeFileExt(ExtractFileName(Game.SetupFile),'.ini');
    T:='ScummVM';
    St:=BuildScummVMIniFile(Game);
  end else begin
    S:=TempDir+ChangeFileExt(ExtractFileName(Game.SetupFile),'.conf');
    T:='DOSBox';
    St:=BuildConfFile(Game,False,False,-1);
    If St=nil then exit;
  end;
    try
      St.Insert(0,'# This '+T+' configuration file was automatically created by D-Fend Reloaded.');
      St.Insert(1,'# Changes made to this file will NOT be transfered to D-Rend Reloaded profiles list.');
      St.Insert(2,'# D-Fend Reloaded will delete this file from temp directory on program close.');
      St.Insert(3,'');
      St.Insert(4,'# Config file for profile "'+Game.Name+'"');
      St.Insert(5,'');
      St.SaveToFile(S);
    finally
      St.Free;
    end;
  OpenFileInEditor(S);
  If DeleteOnExit.IndexOf(S)<0 then DeleteOnExit.Add(S);
end;

Function SelectProgramFile(var FileName : String; const HintFirstFile, HintSecondFile : String; const WindowsMode : Boolean; const OtherEmulator : Integer; const Owner : TComponent) : Boolean;
Var S,S1,S2,S3,T,U : String;
    OpenDialog : TOpenDialog;
    St,St2 : TStringList;
    I,J : Integer;
begin
  result:=False;
  OpenDialog:=TOpenDialog.Create(Owner);
  try
    {Filter, DefaultExt and Title}
    If WindowsMode and (OtherEmulator>=0) then begin
      OpenDialog.Title:=LanguageSetup.MenuProfileAddOtherSelectTitle;
      OpenDialog.DefaultExt:='';
      If (PrgSetup.WindowsBasedEmulatorsNames.Count<=OtherEmulator) or (PrgSetup.WindowsBasedEmulatorsPrograms.Count<=OtherEmulator) or (PrgSetup.WindowsBasedEmulatorsParameters.Count<=OtherEmulator) or  (PrgSetup.WindowsBasedEmulatorsExtensions.Count<=OtherEmulator) then exit;
      S:=Trim(PrgSetup.WindowsBasedEmulatorsExtensions[OtherEmulator]);
      While S<>'' do begin
       I:=Pos(';',S);
       If T<>'' then T:=T+', ';
       If U<>'' then U:=U+';';
       If I=0 then begin
         If OpenDialog.DefaultExt='' then OpenDialog.DefaultExt:=Trim(S);
         T:=T+'*.'+Trim(S);
         U:=U+'*.'+Trim(S);
         S:='';
       end else begin
         If OpenDialog.DefaultExt='' then OpenDialog.DefaultExt:=Trim(Copy(S,1,I-1));
         T:=T+'*.'+Trim(Copy(S,1,I-1));
         U:=U+'*.'+Trim(Copy(S,1,I-1));
         S:=Trim(Copy(S,I+1,MaxInt));
       end;
      end;
      OpenDialog.Filter:=Format(LanguageSetup.MenuProfileAddOtherSelectFilter,[PrgSetup.WindowsBasedEmulatorsNames[OtherEmulator],T,U]);
    end else begin
      OpenDialog.DefaultExt:='exe';
      OpenDialog.Title:=LanguageSetup.ProfileEditorEXEDialog;
      If (Trim(PrgSetup.QBasic)<>'') and FileExists(Trim(PrgSetup.QBasic)) and (not WindowsMode) then S:=LanguageSetup.ProfileEditorEXEFilterWithBasic else S:=LanguageSetup.ProfileEditorEXEFilter;
      S1:=''; S2:=''; S3:='';
      If not WindowsMode then begin
        St:=TStringList.Create;
        try
          For I:=0 to Min(PrgSetup.DOSBoxBasedUserInterpretersPrograms.Count,PrgSetup.DOSBoxBasedUserInterpretersExtensions.Count)-1 do begin
            St2:=ValueToList(PrgSetup.DOSBoxBasedUserInterpretersExtensions[I]);
            try
              T:=''; U:='';
              For J:=0 to St2.Count-1 do begin
                If St.IndexOf(ExtUpperCase(St2[J]))<0 then begin
                  St2.Add(ExtUpperCase(St2[J]));
                  S1:=S1+', *.'+ExtLowerCase(St2[J]);
                  S2:=S2+';*.'+ExtLowerCase(St2[J]);
                end;
                If T='' then T:='*.'+ExtLowerCase(St2[J]) else T:=T+', *.'+ExtLowerCase(St2[J]);
                If U='' then U:='*.'+ExtLowerCase(St2[J]) else U:=U+';*.'+ExtLowerCase(St2[J]);
              end;
              S3:=S3+'|'+ChangeFileExt(ExtractFileName(PrgSetup.DOSBoxBasedUserInterpretersPrograms[I]),'')+' ('+T+')|'+U;
            finally
              St2.Free;
            end;
          end;
        finally
          St.Free;
        end;
      end;
      OpenDialog.Filter:=Format(S,[S1,S2,S3]);
    end;

    {InitialDir}
    S:='';
    If FileName<>'' then begin S:=ExtractFilePath(MakeAbsPath(FileName,PrgSetup.BaseDir)); end;
    If (S='') and (Trim(HintFirstFile)<>'') then S:=ExtractFilePath(MakeAbsPath(HintFirstFile,PrgSetup.BaseDir));
    If (S='') and (Trim(HintSecondFile)<>'') then S:=ExtractFilePath(MakeAbsPath(HintSecondFile,PrgSetup.BaseDir));
    If (S='') and WindowsMode then S:=GetSpecialFolder(Application.MainForm.Handle,CSIDL_PROGRAM_FILES);
    If S='' then S:=PrgSetup.GameDir;
    If S='' then S:=PrgSetup.BaseDir;
    OpenDialog.InitialDir:=S;

    {Run}
    if not OpenDialog.Execute then exit;

    S:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
    If S='' then exit;
    FileName:=S;
    result:=True;
  finally
    OpenDialog.Free;
  end;
end;

function NextFreeDriveLetter(const Mounting : TStringList): Char;
Var I : Integer;
    B : Boolean;
    St : TStringList;
begin
  result:='C';
  repeat
    B:=True;
    For I:=0 to Mounting.Count-1 do begin
      St:=ValueToList(Mounting[I]);
      try
        If St.Count<3 then continue;
        if UpperCase(St[2])=result then begin inc(result); B:=False; break; end;
      finally
        St.Free;
      end;
    end;
  until B;
end;

function CanReachFile(const Mounting : TStringList; const FileName: String): Boolean;
Var S,FilePath : String;
    St : TStringList;
    I : Integer;
begin
  result:=False;
  FilePath:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(MakeAbsPath(ExtractFilePath(FileName),PrgSetup.BaseDir)))));
  For I:=0 to Mounting.Count-1 do begin
    St:=ValueToList(Mounting[I]);
    try
      {Types to check:
       RealFolder;DRIVE;Letter;False;;FreeSpace
       RealFolder;FLOPPY;Letter;False;;
       RealFolder;CDROM;Letter;IO;Label;
       all other are images}
      If St.Count<2 then continue;
      S:=Trim(ExtUpperCase(St[1]));
      If (S<>'DRIVE') and (S<>'FLOPPY') and (S<>'CDROM') then continue;
      S:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(MakeAbsPath(St[0],PrgSetup.BaseDir)))));

      result:=(Copy(FilePath,1,length(S))=S);
      if result then exit;
    finally
      St.Free;
    end;
  end;
end;

Procedure AddPrgDir(const Mounting : TStringList; const ProgrammFileDir : String);
begin
  if CanReachFile(Mounting,ProgrammFileDir) then exit;
  If Mounting.Count=10 then Mounting.Delete(9);
  Mounting.Add(MakeRelPath(ProgrammFileDir,PrgSetup.BaseDir)+';Drive;'+NextFreeDriveLetter(Mounting)+';false;');
end;

Function BuildGameDirMountData(const Template : TGame; const ProgrammFileDir, SetupFileDir : String) : TStringList;
Var G : TGame;
    I : Integer;
    St : TStringList;
    S,T : String;
    B : Boolean;
begin
  result:=TStringList.Create;

  {Load from template}
  If Template=nil then G:=TGame.Create(PrgSetup) else G:=Template;
  try
    For I:=0 to 9 do
      If G.NrOfMounts>=I+1 then result.Add(G.Mount[I]) else break;
  finally
    If Template=nil then G.Free;
  end;

  {Add GameDir}
  B:=False;
  T:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir)))));
  For I:=0 to result.Count-1 do begin
    St:=ValueToList(result[I]);
    try
      If (St.Count<2) or (Trim(ExtUpperCase(St[1]))<>'DRIVE') then continue;
      S:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(MakeAbsPath(St[0],PrgSetup.BaseDir)))));
      B:=(T=S); If B then break;
    finally
      St.Free;
    end;
  end;
  if not B then result.Add(MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir,True)+';DRIVE;'+NextFreeDriveLetter(result)+';False;;'+IntToStr(DefaultFreeHDSize));

  {Add program file and setup file dir}
  If ProgrammFileDir<>'' then AddPrgDir(result,ProgrammFileDir);
  If SetupFileDir<>'' then AddPrgDir(result,SetupFileDir);
end;

Procedure BuildGameDirMountData(const Mounting : TStringList; const ProgrammFileDir, SetupFileDir : String);
Var B : Boolean;
    I : Integer;
    S,T : String;
    St : TStringList;
begin
  {Everything already ok ?}
  If ((Trim(ProgrammFileDir)='') or CanReachFile(Mounting,ProgrammFileDir)) and
     ((Trim(SetupFileDir)='') or CanReachFile(Mounting,SetupFileDir)) then exit;

  {Add GameDir}
  B:=False;
  T:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir)))));
  For I:=0 to Mounting.Count-1 do begin
    St:=ValueToList(Mounting[I]);
    try
      If (St.Count<2) or (Trim(ExtUpperCase(St[1]))<>'DRIVE') then continue;
      S:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(MakeAbsPath(St[0],PrgSetup.BaseDir)))));
      B:=(T=S); If B then break;
    finally
      St.Free;
    end;
  end;
  if not B then Mounting.Add(MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir,True)+';DRIVE;'+NextFreeDriveLetter(Mounting)+';False;;'+IntToStr(DefaultFreeHDSize));

  {Add program file and setup file dir}
  If ProgrammFileDir<>'' then AddPrgDir(Mounting,ProgrammFileDir);
  If SetupFileDir<>'' then AddPrgDir(Mounting,SetupFileDir);
end;


end.
