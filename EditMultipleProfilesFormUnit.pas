unit EditMultipleProfilesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, Menus, CheckLst, GameDBUnit;

Type TSettingData=record
  ID : Integer;
  CheckBox : TCheckBox;
  Values : Array of TControl;
end;

type
  TEditMultipleProfilesForm = class(TForm)
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    InfoLabel: TLabel;
    ListBox: TCheckListBox;
    SelectAllButton: TBitBtn;
    SelectNoneButton: TBitBtn;
    SelectGenreButton: TBitBtn;
    PopupMenu: TPopupMenu;
    ScrollBox: TScrollBox;
    ReplaceFolderToButton: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    LastY : Integer;
    Settings : Array of TSettingData;
    Procedure InitSettings;
    procedure CheckBoxClick(Sender: TObject);
    procedure ComboBoxDropDown(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
    Procedure SelectFolderButtonClick(Sender: TObject);
    Procedure AddSetting(const ID : Integer; const Name : String; const Values : TStringList; const Editable : Boolean; const ValueWidth : Integer; const FreeValues : Boolean = False);
    Procedure AddEditSetting(const ID : Integer; const Name, Default : String; const ValueWidth : Integer);
    Procedure AddYesNoSetting(const ID : Integer; const Name : String);
    Procedure AddSettingWithEdit(const ID : Integer; const Name : String; const Values : TStringList; const Editable : Boolean; const ValueWidth : Integer; const FreeValues : Boolean = False);
    Procedure AddSpinSetting(const ID : Integer; const Name : String; const MinVal, MaxVal : Integer; const ValueWidth : Integer; const DefaultVal : Integer =-1);
    Procedure AddReplaceMountingSetting(const ID : Integer; const Name, FromLabel, ToLabel : String);
    Procedure AddCaption(const Name : String);
    Function ValueActive(const ID : Integer) : Integer;
  public
    { Public-Deklarationen }
    TemplateMode : Boolean;
    GameDB : TGameDB;
  end;

var
  EditMultipleProfilesForm: TEditMultipleProfilesForm;

Function ShowEditMultipleProfilesDialog(const AOwner : TComponent; const AGameDB : TGameDB; const TemplateMode : Boolean = False) : Boolean;

implementation

uses Spin, Math, LanguageSetupUnit, VistaToolsUnit, CommonTools, GameDBToolsUnit,
     PrgSetupUnit, HelpConsts, IconLoaderUnit;

{$R *.dfm}

{ Tools }

const CheckboxWidth=315;
      ValueWidth=105;
      EditWidth=200;

Function GetAllUserInfoKeys(const GameDB : TGameDB) : TStringList;
Var I,J,K : Integer;
    St, Upper : TStringList;
    S : String;
begin
  Upper:=TStringList.Create;
  result:=TStringList.Create;
  try
    For I:=0 to GameDB.Count-1 do begin
      St:=StringToStringList(GameDB[I].UserInfo);
      try
        For J:=0 to St.Count-1 do begin
          S:=Trim(St[J]);
          K:=Pos('=',S); If K=0 then continue;
          S:=Trim(Copy(S,1,K-1));
          If S='' then continue;
          If Upper.IndexOf(ExtUpperCase(S))<0 then begin
            result.Add(S);
            Upper.Add(ExtUpperCase(S));
          end;
        end;
      finally
        St.Free;
      end;
    end;
  finally
    Upper.Free;
  end;
end;

Procedure SetUserInfo(const G : TGame; const Key, Value : String);
Var St : TStringList;
    ValueFound : Boolean;
    I,J : Integer;
    KeyUpper, S : String;
begin
  KeyUpper:=Trim(ExtUpperCase(Key));
  St:=StringToStringList(G.UserInfo);
  try
    ValueFound:=False;
    For I:=0 to St.Count-1 do begin
      S:=Trim(St[I]);
      J:=Pos('=',S); If J=0 then continue;
      S:=Trim(Copy(S,1,J-1));
      If ExtUpperCase(S)=KeyUpper then begin St[I]:=Key+'='+Value; ValueFound:=True; break; end;
    end;
    If not ValueFound then St.Add(Key+'='+Value);
    G.UserInfo:=StringListToString(St);
  finally
    St.Free;
  end;
end;

Procedure DelUserInfo(const G : TGame; const Key : String);
Var St : TStringList;
    KeyUpper,S : String;
    I,J : Integer;
begin
  KeyUpper:=Trim(ExtUpperCase(Key));
  St:=StringToStringList(G.UserInfo);
  try
    I:=0;
    while I<St.Count do begin
      S:=Trim(St[I]);
      J:=Pos('=',S); If J=0 then begin inc(I); continue; end;
      S:=Trim(Copy(S,1,J-1));
      If ExtUpperCase(S)=KeyUpper then begin St.Delete(I); continue; end;
      inc(I);
    end;
    G.UserInfo:=StringListToString(St);
  finally
    St.Free;
  end;
end;

Function GetReplaceFolderList(const GameDB : TGameDB) : TStringList;
Var I,J : Integer;
    G : TGame;
    St,St2 : TStringList;
begin
  result:=TStringList.Create;
  St:=TStringList.Create;
  try
    For I:=0 to GameDB.Count-1 do begin
      G:=GameDB[I];
      If ScummVMMode(G) or WindowsExeMode(G) then continue;
      For J:=0 to G.NrOfMounts-1 do begin
        {RealFolder;Type;Letter;IO;Label;FreeSpace; Type=DRIVE}
        St2:=ValueToList(G.Mount[J]);
        try
          If St2.Count<2 then continue;
          If Trim(ExtUpperCase(St2[1]))<>'DRIVE' then continue;
          If St.IndexOf(ExtUpperCase(IncludeTrailingPathDelimiter(St2[0])))>=0 then continue;
          St.Add(ExtUpperCase(IncludeTrailingPathDelimiter(St2[0])));
          result.Add(IncludeTrailingPathDelimiter(St2[0]));
        finally
          St2.Free;
        end;
      end;
    end;
  finally
    St.Free;
  end;
end;

procedure ReplaceFolderWork(const G: TGame; const FromValue, ToValue : String);
Var I : Integer;
    St : TStringList;
    S : String;
begin
  S:=IncludeTrailingPathDelimiter(Trim(ExtUpperCase(FromValue)));

  For I:=0 to G.NrOfMounts-1 do begin
    {RealFolder;Type;Letter;IO;Label;FreeSpace; Type=DRIVE}
    St:=ValueToList(G.Mount[I]);
    try
      If St.Count<2 then continue;
      If Trim(ExtUpperCase(St[1]))<>'DRIVE' then continue;
      If IncludeTrailingPathDelimiter(Trim(ExtUpperCase(St[0])))=S then begin
        St[0]:=ToValue;
        G.Mount[I]:=ListToValue(St);
      end;
    finally
      St.Free;
    end;
  end;
end;

const Priority : Array[0..3] of String = ('lower','normal','higher','highest');

{ TEditMultipleProfilesForm }

procedure TEditMultipleProfilesForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  PageControl.ActivePageIndex:=0;
  TemplateMode:=False;
  LastY:=0;
end;

procedure TEditMultipleProfilesForm.FormShow(Sender: TObject);
begin
  If TemplateMode then begin
    Caption:=LanguageSetup.ChangeProfilesFormCaption2;
    TabSheet1.Caption:=LanguageSetup.ChangeProfilesFormSelectGamesSheet2;
    InfoLabel.Caption:=LanguageSetup.ChangeProfilesFormInfo2;
  end else begin
    Caption:=LanguageSetup.ChangeProfilesFormCaption;
    TabSheet1.Caption:=LanguageSetup.ChangeProfilesFormSelectGamesSheet;
    InfoLabel.Caption:=LanguageSetup.ChangeProfilesFormInfo;
  end;
  TabSheet2.Caption:=LanguageSetup.ChangeProfilesFormEditProfileSheet;

  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;
  SelectGenreButton.Caption:=LanguageSetup.GameBy;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  BuildCheckList(ListBox,GameDB,False,False);
  BuildSelectPopupMenu(PopupMenu,GameDB,SelectButtonClick,False);

  InitSettings;
  CheckBoxClick(Sender);
end;

procedure TEditMultipleProfilesForm.SelectButtonClick(Sender: TObject);
Var I : Integer;
    P : TPoint;
begin
  If Sender is TBitBtn then begin
    Case (Sender as TComponent).Tag of
      0,1 : For I:=0 to ListBox.Count-1 do ListBox.Checked[I]:=((Sender as TComponent).Tag=0);
        2 : begin
              P:=ClientToScreen(Point(SelectGenreButton.Left,SelectGenreButton.Top));
              PopupMenu.Popup(P.X+5,P.Y+5);
            end;
    end;
    exit;
  end;

  SelectGamesByPopupMenu(Sender,ListBox);
end;

procedure TEditMultipleProfilesForm.AddSetting(const ID : Integer; const Name : String; const Values : TStringList; const Editable : Boolean; const ValueWidth : Integer; const FreeValues : Boolean);
Var CheckBox : TCheckBox;
    ComboBox : TComboBox;
    I : Integer;
begin
  try
    inc(LastY,6);

    CheckBox:=TCheckBox.Create(self);
    with CheckBox do begin
      Parent:=ScrollBox;
      Left:=10;
      Top:=LastY+2;
      Width:=CheckboxWidth;
      Checked:=False;
      OnClick:=CheckBoxClick;
    end;
    CheckBox.Caption:=Name;
    NoFlicker(CheckBox);

    ComboBox:=TComboBox.Create(self);
    with ComboBox do begin
      Parent:=ScrollBox;
      Left:=10+CheckboxWidth+2;
      Top:=LastY;
      If ValueWidth<0 then begin
        Width:=ScrollBox.ClientWidth-4-Left;
        Anchors:=[akLeft,akTop,akRight];
      end else begin
        Width:=ValueWidth;
      end;
      If Editable then Style:=csDropDown else Style:=csDropDownList;
      If Values=nil then begin
        Items.Add(RemoveUnderline(LanguageSetup.No));
        Items.Add(RemoveUnderline(LanguageSetup.Yes));
      end else begin
        Items.AddStrings(Values);
      end;
      If (not Editable) and (Items.Count>0) then ItemIndex:=0 else ItemIndex:=-1;
      Enabled:=False;
      OnDropDown:=ComboBoxDropDown;
      OnChange:=ComboBoxChange;
    end;
    NoFlicker(ComboBox);
    SetComboHint(ComboBox);

    inc(LastY,ComboBox.Height);

    I:=length(Settings); SetLength(Settings,I+1);
    Settings[I].CheckBox:=CheckBox;
    SetLength(Settings[I].Values,1); Settings[I].Values[0]:=ComboBox;
    Settings[I].ID:=ID;
  finally
    If FreeValues and Assigned(Values) then Values.Free;
  end;
end;

Procedure TEditMultipleProfilesForm.AddEditSetting(const ID : Integer; const Name, Default : String; const ValueWidth : Integer);
Var CheckBox : TCheckBox;
    Edit : TEdit;
    I : Integer;
begin
  inc(LastY,6);

  CheckBox:=TCheckBox.Create(self);
  with CheckBox do begin
    Parent:=ScrollBox;
    Left:=10;
    Top:=LastY+2;
    Width:=CheckboxWidth;
    Checked:=False;
    OnClick:=CheckBoxClick;
  end;
  CheckBox.Caption:=Name;
  NoFlicker(CheckBox);

  Edit:=TEdit.Create(self);
  with Edit do begin
    Parent:=ScrollBox;
    Left:=10+CheckboxWidth+2;
    Top:=LastY;
    If ValueWidth<0 then begin
      Width:=ScrollBox.ClientWidth-4-Left;
      Anchors:=[akLeft,akTop,akRight];
    end else begin
      Width:=ValueWidth;
    end;
    Text:=Default;
    Enabled:=False;
  end;
  NoFlicker(Edit);

  inc(LastY,Edit.Height);

  I:=length(Settings); SetLength(Settings,I+1);
  Settings[I].CheckBox:=CheckBox;
  SetLength(Settings[I].Values,1); Settings[I].Values[0]:=Edit;
  Settings[I].ID:=ID;
end;

Procedure TEditMultipleProfilesForm.AddYesNoSetting(const ID : Integer; const Name : String);
begin
  AddSetting(ID,Name,nil,False,ValueWidth);
end;

procedure TEditMultipleProfilesForm.AddSettingWithEdit(const ID : Integer; const Name: String; const Values: TStringList; const Editable: Boolean; const ValueWidth: Integer; const FreeValues: Boolean);
Var Edit : TEdit;
    I : Integer;
    C : TControl;
begin
  AddSetting(ID,Name,Values,Editable,ValueWidth,FreeValues);

  I:=length(Settings[length(Settings)-1].Values);
  C:=Settings[length(Settings)-1].Values[I-1];

  Edit:=TEdit.Create(self);
  with Edit do begin
    Parent:=ScrollBox;
    Left:=C.Left+C.Width+4;
    Top:=C.Top;
    Width:=ScrollBox.ClientWidth-4-Left;
    Anchors:=[akLeft,akTop,akRight];
    Enabled:=False;
  end;
  NoFlicker(Edit);

  SetLength(Settings[length(Settings)-1].Values,I+1);
  Settings[length(Settings)-1].Values[I]:=Edit;
end;

Procedure TEditMultipleProfilesForm.AddSpinSetting(const ID : Integer; const Name : String; const MinVal, MaxVal : Integer; const ValueWidth : Integer; const DefaultVal : Integer);
Var CheckBox : TCheckBox;
    SpinEdit : TSpinEdit;
    I : Integer;
begin
  inc(LastY,6);

  CheckBox:=TCheckBox.Create(self);
  with CheckBox do begin
    Parent:=ScrollBox;
    Left:=10;
    Top:=LastY+2;
    Width:=CheckboxWidth;
    Checked:=False;
    OnClick:=CheckBoxClick;
  end;
  CheckBox.Caption:=Name;
  NoFlicker(CheckBox);

  SpinEdit:=TSpinEdit.Create(self);
  with SpinEdit do begin
    Parent:=ScrollBox;
    Left:=10+CheckboxWidth+2;
    Top:=LastY;
    If ValueWidth<0 then begin
      Width:=ScrollBox.ClientWidth-4-Left;
      Anchors:=[akLeft,akTop,akRight];
    end else begin
      Width:=ValueWidth;
    end;
    MinValue:=MinVal;
    MaxValue:=MaxVal;
    If DefaultVal=-1 then Value:=MinVal else Value:=DefaultVal;
    Enabled:=False;
  end;
  NoFlicker(SpinEdit);

  inc(LastY,SpinEdit.Height);

  I:=length(Settings); SetLength(Settings,I+1);
  Settings[I].CheckBox:=CheckBox;
  SetLength(Settings[I].Values,1); Settings[I].Values[0]:=SpinEdit;
  Settings[I].ID:=ID;
end;

Procedure TEditMultipleProfilesForm.AddReplaceMountingSetting(const ID : Integer; const Name, FromLabel, ToLabel : String);
Var CheckBox : TCheckBox;
    Label1, Label2 : TLabel;
    ComboBox : TComboBox;
    Edit : TEdit;
    Button : TSpeedButton;
    I : Integer;
    List : TStringList;
const Indent=20;
begin
  List:=GetReplaceFolderList(GameDB);
  try
    If List.Count=0 then exit;

    inc(LastY,6);

    CheckBox:=TCheckBox.Create(self);
    with CheckBox do begin
      Parent:=ScrollBox;
      Left:=10;
      Top:=LastY+2;
      Width:=CheckboxWidth;
      Checked:=False;
      OnClick:=CheckBoxClick;
    end;
    CheckBox.Caption:=Name;
    NoFlicker(CheckBox);

    inc(LastY,CheckBox.Height+2+4);

    Label1:=TLabel.Create(self);
    with Label1 do begin
      Parent:=ScrollBox;
      Left:=10+Indent;
      Top:=LastY;
      AutoSize:=True;
      Caption:=FromLabel;
    end;

    Label2:=TLabel.Create(self);
    with Label2 do begin
      Parent:=ScrollBox;
      Left:=10+Indent+EditWidth+10;
      Top:=LastY;
      AutoSize:=True;
      Caption:=ToLabel;
    end;

    inc(LastY,Label1.Height+2);

    ComboBox:=TComboBox.Create(self);
    with ComboBox do begin
      Parent:=ScrollBox;
      Left:=10+Indent;
      Top:=LastY;
      Width:=EditWidth;
      Style:=csDropDownList;
      Items.AddStrings(List);
      ItemIndex:=0;
      Enabled:=False;
    end;
    NoFlicker(ComboBox);
    SetComboHint(ComboBox);

    Edit:=TEdit.Create(self);
    with Edit do begin
      Parent:=ScrollBox;
      Left:=10+Indent+EditWidth+10;
      Top:=LastY;
      Anchors:=[akLeft,akTop,akRight];
      Enabled:=False;
    end;
    NoFlicker(Edit);

    Button:=TSpeedButton.Create(self);
    with Button do begin
      Parent:=ScrollBox;
      Left:=ScrollBox.ClientWidth-10-Width;
      Top:=LastY;
      Anchors:=[akTop,akRight];
      Glyph:=ReplaceFolderToButton.Glyph;
      Tag:=ID;
      OnClick:=SelectFolderButtonClick;
      Enabled:=False;
    end;

    Edit.Width:=Button.Left-4-Edit.Left;

    Label1.FocusControl:=ComboBox;
    Label2.FocusControl:=Edit;

    inc(LastY,ComboBox.Height);

    I:=length(Settings); SetLength(Settings,I+1);
    Settings[I].CheckBox:=CheckBox;
    SetLength(Settings[I].Values,3); Settings[I].Values[0]:=ComboBox; Settings[I].Values[1]:=Edit; Settings[I].Values[2]:=Button;
    Settings[I].ID:=ID;
  finally
    List.Free;
  end;
end;


procedure TEditMultipleProfilesForm.AddCaption(const Name: String);
Var L : TLabel;
begin
  If LastY=0 then inc(LastY,4) else inc(LastY,8);

  L:=TLabel.Create(self);
  with L do begin
    L.Parent:=ScrollBox;
    L.Left:=10;
    L.Top:=LastY;
    L.AutoSize:=True;
    L.Font.Size:=L.Font.Size+1;
    L.Font.Style:=[fsBold];
  end;
  L.Caption:=Name;

  inc(LastY,L.Height);
end;

Function TEditMultipleProfilesForm.ValueActive(const ID : Integer) : Integer;
Var I : Integer;
begin
  result:=-1;
  For I:=0 to length(Settings)-1 do If Settings[I].ID=ID then begin
    If Settings[I].CheckBox.Checked then result:=I;
    break;
  end;
end;

procedure TEditMultipleProfilesForm.CheckBoxClick(Sender: TObject);
Var I,J : Integer;
begin
  For I:=0 to length(Settings)-1 do For J:=0 to length(Settings[I].Values)-1 do
    Settings[I].Values[J].Enabled:=Settings[I].CheckBox.Checked;
end;

procedure TEditMultipleProfilesForm.ComboBoxDropDown(Sender: TObject);
begin
  If Sender is TComboBox then SetComboDropDownDropDownWidth(Sender as TComboBox);
end;

procedure TEditMultipleProfilesForm.ComboBoxChange(Sender: TObject);
begin
  If Sender is TComboBox then SetComboHint(Sender as TComboBox);
end;

Procedure TEditMultipleProfilesForm.SelectFolderButtonClick(Sender: TObject);
Var I,Nr : Integer;
    S : String;
begin
  Nr:=-1;
  For I:=0 to length(Settings)-1 do If Settings[I].ID=(Sender as TControl).Tag then begin Nr:=I; break; end;
  If Nr<0 then exit;

  S:=Trim(TEdit(Settings[Nr].Values[1]).Text);
  If S='' then S:=PrgSetup.GameDir;
  If S='' then S:=PrgSetup.BaseDir;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  If not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
  TEdit(Settings[Nr].Values[1]).Text:=MakeRelPath(S,PrgSetup.BaseDir,True);
end;

procedure TEditMultipleProfilesForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ExtrasEditMultipleProfiles);
end;

procedure TEditMultipleProfilesForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

procedure TEditMultipleProfilesForm.InitSettings;
Var St : TStringList;
    I : Integer;
begin
  {Game info}
  AddCaption(LanguageSetup.ProfileEditorGameInfoSheet);
  AddSetting(1001,LanguageSetup.GameGenre,ExtGenreList(GetCustomGenreName(GameDB.GetGenreList)),True,-1,True);
  AddSetting(1002,LanguageSetup.GameDeveloper,GameDB.GetDeveloperList,True,-1,True);
  AddSetting(1003,LanguageSetup.GamePublisher,GameDB.GetPublisherList,True,-1,True);
  AddSetting(1004,LanguageSetup.GameYear,GameDB.GetYearList,True,-1,True);
  AddSetting(1005,LanguageSetup.GameLanguage,ExtLanguageList(GetCustomLanguageName(GameDB.GetLanguageList)),True,-1,True);
  AddSetting(1006,LanguageSetup.GameFavorite,nil,False,ValueWidth);
  AddSetting(1007,LanguageSetup.GameWWW,GameDB.GetWWWList,True,-1,True);
  St:=GetAllUserInfoKeys(GameDB);
  try
    AddSettingWithEdit(1008,LanguageSetup.ChangeProfilesFormSetUserInfo,St,True,ValueWidth);
    If St.Count>0 then AddSetting(1009,LanguageSetup.ChangeProfilesFormDelUserInfo,St,False,ValueWidth);
  finally
    St.Free;
  end;

  {DOSBox}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet);
  St:=TStringList.Create;
  try
    St.Add(LanguageSetup.GamePriorityLower);
    St.Add(LanguageSetup.GamePriorityNormal);
    St.Add(LanguageSetup.GamePriorityHigher);
    St.Add(LanguageSetup.GamePriorityHighest);
    AddSetting(2001,LanguageSetup.GamePriorityForeground,St,False,ValueWidth);
    St.Insert(0,LanguageSetup.GamePriorityPause);
    AddSetting(2002,LanguageSetup.GamePriorityBackground,St,False,ValueWidth);
  finally
    St.Free;
  end;
  AddYesNoSetting(2003,LanguageSetup.GameCloseDosBoxAfterGameExit);
  St:=TStringList.Create;
  try
    For I:=0 to PrgSetup.DOSBoxSettingsCount-1 do St.Add(PrgSetup.DOSBoxSettings[I].Name);
    AddSetting(2004,LanguageSetup.GameDOSBoxVersionDefault,St,False,ValueWidth);
  finally
    St.Free;
  end;
  AddEditSetting(2005,LanguageSetup.GameDOSBoxVersionCustom,'',-1);

  {CPU}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorCPUSheet);
  AddSetting(3001,LanguageSetup.GameCPUType,ValueToList(GameDB.ConfOpt.Core,';,'),False,ValueWidth,True);
  AddSetting(3002,LanguageSetup.GameCycles,ValueToList(GameDB.ConfOpt.Cycles,';,'),False,ValueWidth,True);

  {Memory}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorMemorySheet);
  AddSetting(4001,LanguageSetup.GameMemory,ValueToList(GameDB.ConfOpt.Memory,';,'),False,ValueWidth,True);
  AddYesNoSetting(4002,LanguageSetup.GameXMS);
  AddYesNoSetting(4003,LanguageSetup.GameEMS);
  AddYesNoSetting(4004,LanguageSetup.GameUMB);
  AddYesNoSetting(4005,LanguageSetup.ProfileEditorLoadFix);
  AddSpinSetting(4006,LanguageSetup.ProfileEditorLoadFixMemory,1,512,ValueWidth,64);

  {Graphics}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorGraphicsSheet);
  AddSetting(5001,LanguageSetup.GameWindowResolution,ValueToList(GameDB.ConfOpt.Resolution,';,'),False,ValueWidth,True);
  AddSetting(5002,LanguageSetup.GameFullscreenResolution,ValueToList(GameDB.ConfOpt.Resolution,';,'),False,ValueWidth,True);
  AddYesNoSetting(5003,LanguageSetup.GameStartFullscreen);
  AddYesNoSetting(5004,LanguageSetup.GameUseDoublebuffering);
  AddYesNoSetting(5005,LanguageSetup.GameAspectCorrection);
  AddSetting(5006,LanguageSetup.GameRender,ValueToList(GameDB.ConfOpt.Render,';,'),False,ValueWidth,True);
  AddSetting(5007,LanguageSetup.GameVideoCard,ValueToList(GameDB.ConfOpt.Video,';,'),False,ValueWidth,True);
  AddSetting(5008,LanguageSetup.GameScale,ValueToList(GameDB.ConfOpt.Scale,';,'),False,-1,True);
  AddSpinSetting(5009,LanguageSetup.GameFrameskip,0,10,ValueWidth);
  If PrgSetup.AllowGlideSettings then begin
    AddYesNoSetting(5101,LanguageSetup.GameGlideEmulation);
  end;
  {If PrgSetup.AllowPixelShader then begin
  end;}
  If PrgSetup.AllowVGAChipsetSettings then begin
    AddSetting(5301,LanguageSetup.GameVGAChipset,ValueToList(GameDB.ConfOpt.VGAChipsets,';,'),False,ValueWidth,True);
    AddSetting(5301,LanguageSetup.GameVideoRam,ValueToList(GameDB.ConfOpt.VGAVideoRAM,';,'),False,ValueWidth,True);
  end;
  If PrgSetup.AllowTextModeLineChange then begin
    AddSetting(5401,LanguageSetup.GameTextModeLines,ValueToList('25;28;50',';,'),False,ValueWidth,True);
  end;

  {Keyboard}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorKeyboardSheet);
  AddYesNoSetting(6001,LanguageSetup.GameUseScanCodes);
  AddSetting(6002,LanguageSetup.GameKeyboardLayout,ValueToList(GameDB.ConfOpt.KeyboardLayout,';,'),False,-1,True);
  AddSetting(6003,LanguageSetup.GameKeyboardCodepage,ValueToList(GameDB.ConfOpt.Codepage,';,'),False,ValueWidth,True);
  St:=TStringList.Create;
  try
    St.Add(LanguageSetup.DoNotChange);
    St.Add(LanguageSetup.Off);
    St.Add(LanguageSetup.On);
    AddSetting(6004,LanguageSetup.GameKeyboardNumLock,St,False,ValueWidth);
    AddSetting(6005,LanguageSetup.GameKeyboardCapsLock,St,False,ValueWidth);
    AddSetting(6006,LanguageSetup.GameKeyboardScrollLock,St,False,ValueWidth);
  finally
    St.Free;
  end;

  {Mouse}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorMouseSheet);
  AddYesNoSetting(7001,LanguageSetup.GameAutoLockMouse);
  AddSpinSetting(7002,LanguageSetup.GameMouseSensitivity,1,1000,ValueWidth,100);
  AddYesNoSetting(7003,LanguageSetup.GameForce2ButtonMouseMode);
  AddYesNoSetting(7004,LanguageSetup.GameSwapMouseButtons);

  {Sound}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorSoundSheet);
  AddYesNoSetting(8001,LanguageSetup.ProfileEditorSoundEnableSound);
  AddSetting(8002,LanguageSetup.ProfileEditorSoundSampleRate,ValueToList(GameDB.ConfOpt.Rate,';,'),False,ValueWidth,True);
  AddSetting(8003,LanguageSetup.ProfileEditorSoundBlockSize,ValueToList(GameDB.ConfOpt.Blocksize,';,'),True,ValueWidth,True);
  St:=TStringList.Create;
  try
    with St do begin Add('1'); Add('5'); Add('10'); Add('15'); Add('20'); Add('25'); Add('30'); end;
    AddSetting(8004,LanguageSetup.ProfileEditorSoundPrebuffer,St,True,ValueWidth);
  finally
    St.Free;
  end;
  AddYesNoSetting(8005,LanguageSetup.ProfileEditorSoundMiscEnablePCSpeaker);
  AddSetting(8006,LanguageSetup.ProfileEditorSoundMiscPCSpeakerRate,ValueToList(GameDB.ConfOpt.PCRate,';,'),False,ValueWidth,True);
  St:=TStringList.Create;
  try
    St.Add(LanguageSetup.ProfileEditorSoundMiscEnableTandyAuto);
    St.Add(LanguageSetup.On);
    St.Add(LanguageSetup.Off);
    AddSetting(8007,LanguageSetup.ProfileEditorSoundMiscEnableTandy,St,False,ValueWidth);
  finally
    St.Free;
  end;
  AddSetting(8008,LanguageSetup.ProfileEditorSoundMiscTandyRate,ValueToList(GameDB.ConfOpt.TandyRate,';,'),False,ValueWidth,True);
  AddYesNoSetting(8009,LanguageSetup.ProfileEditorSoundMiscEnableDisneySoundsSource);

  {SoundBlaster}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorSoundSoundBlaster);
  AddSetting(8101,LanguageSetup.ProfileEditorSoundSBType,ValueToList(GameDB.ConfOpt.Sblaster,';,'),False,ValueWidth,True);
  AddSetting(8102,LanguageSetup.ProfileEditorSoundSBAddress,ValueToList(GameDB.ConfOpt.SBBase,';,'),False,ValueWidth,True);
  AddSetting(8103,LanguageSetup.ProfileEditorSoundSBIRQ,ValueToList(GameDB.ConfOpt.IRQ,';,'),False,ValueWidth,True);
  AddSetting(8104,LanguageSetup.ProfileEditorSoundSBDMA,ValueToList(GameDB.ConfOpt.DMA,';,'),False,ValueWidth,True);
  AddSetting(8105,LanguageSetup.ProfileEditorSoundSBHDMA,ValueToList(GameDB.ConfOpt.HDMA,';,'),False,ValueWidth,True);
  AddSetting(8106,LanguageSetup.ProfileEditorSoundSBOplMode,ValueToList(GameDB.ConfOpt.Oplmode,';,'),False,ValueWidth,True);
  AddSetting(8107,LanguageSetup.GameOplemu,ValueToList(GameDB.ConfOpt.OPLEmu,';,'),False,ValueWidth,True);
  AddSetting(8108,LanguageSetup.ProfileEditorSoundSBOplRate,ValueToList(GameDB.ConfOpt.OPLRate,';,'),False,ValueWidth,True);
  AddYesNoSetting(8109,LanguageSetup.ProfileEditorSoundSBUseMixer);

  {GUS}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorSoundGUS);
  AddYesNoSetting(8201,LanguageSetup.ProfileEditorSoundGUSEnabled);
  AddSetting(8202,LanguageSetup.ProfileEditorSoundGUSAddress,ValueToList(GameDB.ConfOpt.GUSBase,';,'),False,ValueWidth,True);
  AddSetting(8203,LanguageSetup.ProfileEditorSoundGUSRate,ValueToList(GameDB.ConfOpt.GUSRate,';,'),False,ValueWidth,True);
  AddSetting(8204,LanguageSetup.ProfileEditorSoundGUSIRQ,ValueToList(GameDB.ConfOpt.GUSIRQ,';,'),False,ValueWidth,True);
  AddSetting(8205,LanguageSetup.ProfileEditorSoundGUSDMA,ValueToList(GameDB.ConfOpt.GUSDma,';,'),False,ValueWidth,True);
  AddEditSetting(8206,LanguageSetup.ProfileEditorSoundGUSPath,'C:\ULTRASND',-1);

  {MIDI}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorSoundMIDI);
  AddSetting(8301,LanguageSetup.ProfileEditorSoundMIDIType,ValueToList(GameDB.ConfOpt.MPU401,';,'),False,ValueWidth,True);
  AddSetting(8302,LanguageSetup.ProfileEditorSoundMIDIDevice,ValueToList(GameDB.ConfOpt.MIDIDevice,';,'),False,ValueWidth,True);
  AddEditSetting(8303,LanguageSetup.ProfileEditorSoundMIDIConfigInfo,'',-1);

  {Joystick}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.GameJoysticks);
  AddSetting(9001,LanguageSetup.ProfileEditorSoundJoystickType,ValueToList(GameDB.ConfOpt.Joysticks,';,'),False,ValueWidth,True);
  AddYesNoSetting(9002,LanguageSetup.ProfileEditorSoundJoystickTimed);
  AddYesNoSetting(9003,LanguageSetup.ProfileEditorSoundJoystickAutoFire);
  AddYesNoSetting(9004,LanguageSetup.ProfileEditorSoundJoystickSwap34);
  AddYesNoSetting(9005,LanguageSetup.ProfileEditorSoundJoystickButtonwrap);

  {Mounting}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorMountingSheet);
  AddReplaceMountingSetting(10000,LanguageSetup.ChangeProfilesReplaceFolder,LanguageSetup.ChangeProfilesReplaceFolderFrom,LanguageSetup.ChangeProfilesReplaceFolderTo);
  AddYesNoSetting(10001,LanguageSetup.ProfileEditorMountingAutoMountCDsShort);
  AddYesNoSetting(10002,LanguageSetup.ProfileEditorMountingSecureModeShort);
  St:=TStringList.Create;
  try
    St.Add(LanguageSetup.ChangeProfilesMountingChangeSettingsGlobal);
    St.Add(LanguageSetup.ChangeProfilesMountingChangeSettingsLocal);
    AddSetting(10003,LanguageSetup.ChangeProfilesMountingChangeSettings,St,False,-1);
  finally
    St.Free;
  end;

  {DOS environment}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorDOSEnvironmentSheet);
  AddSetting(11001,LanguageSetup.GameReportedDOSVersion,ValueToList(GameDB.ConfOpt.ReportedDOSVersion,';,'),True,ValueWidth,True);
  AddYesNoSetting(11002,LanguageSetup.ProfileEditorAutoexecUse4DOS);

  {Starting}
  AddCaption(LanguageSetup.ProfileEditorGeneralSheet+' - '+LanguageSetup.ProfileEditorStartingSheet);
  AddYesNoSetting(12001,LanguageSetup.ProfileEditorAutoexecOverrideGameStart);
  AddYesNoSetting(12002,LanguageSetup.ProfileEditorAutoexecOverrideMounting);

  {ScummVM}
  AddCaption(LanguageSetup.ProfileEditorScummVMSheet);
  AddSetting(13001,LanguageSetup.ProfileEditorScummVMPlatform,ValueToList(GameDB.ConfOpt.ScummVMPlatform,';,'),False,ValueWidth,True);
  AddSetting(13002,LanguageSetup.ProfileEditorScummVMFilter,ValueToList(GameDB.ConfOpt.ScummVMFilter,';,'),False,-1,True);
  AddSetting(13003,LanguageSetup.ProfileEditorScummVMRenderMode,ValueToList(GameDB.ConfOpt.ScummVMRenderMode,';,'),False,ValueWidth,True);
  AddYesNoSetting(13004,LanguageSetup.GameStartFullscreen);
  AddYesNoSetting(13005,LanguageSetup.GameAspectCorrection);

  {ScummVM sound}
  AddCaption(LanguageSetup.ProfileEditorScummVMSheet+' - '+LanguageSetup.ProfileEditorSoundSheet);
  AddSpinSetting(14001,LanguageSetup.ProfileEditorScummVMMusicVolume,0,255,ValueWidth,192);
  AddSpinSetting(14002,LanguageSetup.ProfileEditorScummVMSpeechVolume,0,255,ValueWidth,192);
  AddSpinSetting(14003,LanguageSetup.ProfileEditorScummVMSFXVolume,0,255,ValueWidth,192);
  AddSpinSetting(14004,LanguageSetup.ProfileEditorScummVMMIDIGain,0,1000,ValueWidth,100);
  St:=TStringList.Create;
  try
    with St do begin Add('11025'); Add('22050'); Add('44100'); end;
    AddSetting(14005,LanguageSetup.ProfileEditorSoundSampleRate,St,False,ValueWidth);
  finally
    St.Free;
  end;
  AddYesNoSetting(14006,LanguageSetup.ProfileEditorScummVMSpeechMute);
end;

Procedure ChangeMountSetting(const G : TGame; const SetDefault : Boolean);
Var I : Integer;
    AllGamesDir,GameDir,S : String;
    St : TStringList;
begin
  {Only process if normal start (not booting from image}
  If Trim(G.AutoexecBootImage)<>'' then exit;

  {Exit if mounting not used}
  If G.AutoexecOverrideMount then exit;

  AllGamesDir:=IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir));
  If (Trim(G.GameExe)='') or (Copy(Trim(ExtUpperCase(G.GameExe)),1,7)='DOSBOX:') then GameDir:='' else GameDir:=IncludeTrailingPathDelimiter(MakeAbsPath(ExtractFilePath(G.GameExe),PrgSetup.BaseDir));

  For I:=0 to 9 do begin
    St:=ValueToList(G.Mount[I]);
    try
      {RealFolder;DRIVE;Letter;False;;FreeSpace}
      If (St.Count<3) or (Trim(ExtUpperCase(St[1]))<>'DRIVE') or (Trim(ExtUpperCase(St[2]))<>'C')  then continue;
      S:=IncludeTrailingPathDelimiter(MakeAbsPath(St[0],PrgSetup.BaseDir));
      If SetDefault then begin
        If Trim(ExtUpperCase(GameDir))=Trim(ExtUpperCase(S)) then begin
          St[0]:=MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir);
          G.Mount[I]:=ListToValue(St);
          G.StoreAllValues;
          exit;
        end;
      end else begin
        If (Trim(ExtUpperCase(AllGamesDir))=Trim(ExtUpperCase(S))) and (GameDir<>'') then begin
          St[0]:=MakeRelPath(GameDir,PrgSetup.BaseDir);
          G.Mount[I]:=ListToValue(St);
          G.StoreAllValues;
          exit;
        end;
      end;  
    finally
      St.Free;
    end;
  end;
end;

procedure TEditMultipleProfilesForm.OKButtonClick(Sender: TObject);
Var I,J,Nr : Integer;
    G : TGame;
    ScummVM,WindowsMode : Boolean;
    St : TStringList;
    S : String;
Function GetComboIndex : Integer; begin result:=TComboBox(Settings[Nr].Values[0]).ItemIndex; end;
Function GetComboText : String; begin result:=TComboBox(Settings[Nr].Values[0]).Text; end;
Function GetEditText : String; begin result:=TEdit(Settings[Nr].Values[0]).Text; end;
Function GetYesNo : Boolean; begin result:=(TComboBox(Settings[Nr].Values[0]).ItemIndex=1); end;
Function GetSpinValue : Integer; begin result:=TSpinEdit(Settings[Nr].Values[0]).Value; end;
begin
  For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then begin
    G:=TGame(ListBox.Items.Objects[I]);
    ScummVM:=ScummVMMode(G);
    WindowsMode:=WindowsExeMode(G);

    {Game info}
    Nr:=ValueActive(1001); If Nr>=0 then G.Genre:=GetEnglishGenreName(GetComboText);
    Nr:=ValueActive(1002); If Nr>=0 then G.Developer:=GetComboText;
    Nr:=ValueActive(1003); If Nr>=0 then G.Publisher:=GetComboText;
    Nr:=ValueActive(1004); If Nr>=0 then G.Year:=GetComboText;
    Nr:=ValueActive(1005); If Nr>=0 then G.Language:=GetEnglishLanguageName(GetComboText);
    Nr:=ValueActive(1006); If Nr>=0 then G.Favorite:=GetYesNo;
    Nr:=ValueActive(1007); If Nr>=0 then G.WWW:=GetComboText;
    Nr:=ValueActive(1008); If Nr>=0 then SetUserInfo(G,GetComboText,TEdit(Settings[Nr].Values[1]).Text);
    Nr:=ValueActive(1009); If Nr>=0 then DelUserInfo(G,GetComboText);

    If (not ScummVM) and (not WindowsMode) then begin

      {DOSBox}
      Nr:=ValueActive(2001); If Nr>=0 then begin
        St:=ValueToList(G.Priority,',');
        try While St.Count<2 do St.Add(''); St[0]:=Priority[Max(0,Min(3,GetComboIndex))]; G.Priority:=ListToValue(St,','); finally St.Free; end;
      end;
      Nr:=ValueActive(2002); If Nr>=0 then begin
        St:=ValueToList(G.Priority,',');
        try While St.Count<2 do St.Add(''); St[1]:=Priority[Max(0,Min(3,GetComboIndex))]; G.Priority:=ListToValue(St,','); finally St.Free; end;
      end;
      Nr:=ValueActive(2003); If Nr>=0 then G.CloseDosBoxAfterGameExit:=GetYesNo;
      Nr:=ValueActive(2004); If Nr>=0 then G.CustomDOSBoxDir:=GetComboText;
      Nr:=ValueActive(2005); If Nr>=0 then G.CustomDOSBoxDir:=GetEditText;

      {CPU}
      Nr:=ValueActive(3001); If Nr>=0 then G.Core:=GetComboText;
      Nr:=ValueActive(3002); If Nr>=0 then G.Cycles:=GetComboText;

      {Memory}
      Nr:=ValueActive(4001); If Nr>=0 then begin
        try J:=Min(63,Max(1,StrToInt(GetComboText))); except J:=32; end; G.Memory:=J;
      end;
      Nr:=ValueActive(4002); If Nr>=0 then G.XMS:=GetYesNo;
      Nr:=ValueActive(4003); If Nr>=0 then G.EMS:=GetYesNo;
      Nr:=ValueActive(4004); If Nr>=0 then G.UMB:=GetYesNo;
      Nr:=ValueActive(4005); If Nr>=0 then G.LoadFix:=GetYesNo;
      Nr:=ValueActive(4006); If Nr>=0 then G.LoadFixMemory:=Max(1,Min(512,GetSpinValue));

      {Graphics}
      Nr:=ValueActive(5001); If Nr>=0 then G.WindowResolution:=GetComboText;
      Nr:=ValueActive(5002); If Nr>=0 then G.FullscreenResolution:=GetComboText;
      Nr:=ValueActive(5003); If Nr>=0 then G.StartFullscreen:=GetYesNo;
      Nr:=ValueActive(5004); If Nr>=0 then G.UseDoublebuffering:=GetYesNo;
      Nr:=ValueActive(5005); If Nr>=0 then G.AspectCorrection:=GetYesNo;

      Nr:=ValueActive(5006); If Nr>=0 then G.Render:=GetComboText;
      Nr:=ValueActive(5007); If Nr>=0 then G.VideoCard:=GetComboText;
      Nr:=ValueActive(5008); If Nr>=0 then begin
        S:=GetComboText;
        If Pos('(',S)=0 then G.Scale:='' else begin
          S:=Copy(S,Pos('(',S)+1,MaxInt); If Pos(')',S)=0 then G.Scale:=''  else G.Scale:=Copy(S,1,Pos(')',S)-1);
        end;
      end;
      Nr:=ValueActive(5009); If Nr>=0 then G.FrameSkip:=Max(0,Min(10,GetSpinValue));
      If PrgSetup.AllowGlideSettings then begin
        Nr:=ValueActive(5101); If Nr>=0 then G.GlideEmulation:=GetYesNo;
      end;
      {If PrgSetup.AllowPixelShader then begin
      end;}
      If PrgSetup.AllowVGAChipsetSettings then begin
        Nr:=ValueActive(5301); If Nr>=0 then G.VGAChipset:=GetComboText;
        Nr:=ValueActive(5302); If Nr>=0 then begin try J:=StrToInt(GetComboText); except J:=512; end; G.VideoRam:=J; end;
      end;
      If PrgSetup.AllowTextModeLineChange then begin
        Nr:=ValueActive(5401); If Nr>=0 then begin try J:=StrToInt(GetComboText); except J:=25; end; G.TextModeLines:=J; end;
      end;

      {Keyboard}
      Nr:=ValueActive(6001); If Nr>=0 then G.UseScanCodes:=GetYesNo;
      Nr:=ValueActive(6002); If Nr>=0 then G.KeyboardLayout:=GetComboText;
      Nr:=ValueActive(6003); If Nr>=0 then G.Codepage:=GetComboText;
      Nr:=ValueActive(6004); If Nr>=0 then Case GetComboIndex of
        0 : G.NumLockStatus:='';
        1 : G.NumLockStatus:='off';
        2 : G.NumLockStatus:='on';
      end;
      Nr:=ValueActive(6005); If Nr>=0 then Case GetComboIndex of
        0 : G.CapsLockStatus:='';
        1 : G.CapsLockStatus:='off';
        2 : G.CapsLockStatus:='on';
      end;
      Nr:=ValueActive(6006); If Nr>=0 then Case GetComboIndex of
        0 : G.ScrollLockStatus:='';
        1 : G.ScrollLockStatus:='off';
        2 : G.ScrollLockStatus:='on';
      end;

      {Mouse}
      Nr:=ValueActive(7001); If Nr>=0 then G.AutoLockMouse:=GetYesNo;
      Nr:=ValueActive(7002); If Nr>=0 then G.MouseSensitivity:=Max(1,Min(1000,GetSpinValue));
      Nr:=ValueActive(7003); If Nr>=0 then G.Force2ButtonMouseMode:=GetYesNo;
      Nr:=ValueActive(7004); If Nr>=0 then G.SwapMouseButtons:=GetYesNo;

      {Sound}
      Nr:=ValueActive(8001); If Nr>=0 then G.MixerNosound:=not GetYesNo;

      Nr:=ValueActive(8002); If Nr>=0 then begin try J:=Min(65536,Max(1,StrToInt(GetComboText))); except J:=22050; end; G.MixerRate:=J; end;
      Nr:=ValueActive(8003); If Nr>=0 then begin try J:=Min(65536,Max(1,StrToInt(GetComboText))); except J:=2048; end; G.MixerBlocksize:=J; end;
      Nr:=ValueActive(8004); If Nr>=0 then begin try J:=Min(65536,Max(1,StrToInt(GetComboText))); except J:=10; end; G.MixerPrebuffer:=J; end;
      Nr:=ValueActive(8005); If Nr>=0 then G.SpeakerPC:=GetYesNo;
      Nr:=ValueActive(8006); If Nr>=0 then begin try J:=Min(65536,Max(1,StrToInt(GetComboText))); except J:=10; end; G.SpeakerRate:=J; end;
      Nr:=ValueActive(8007); If Nr>=0 then Case GetComboIndex of
        0 : G.SpeakerTandy:='auto';
        1 : G.SpeakerTandy:='on';
        2 : G.SpeakerTandy:='off';
      end;
      Nr:=ValueActive(8006); If Nr>=0 then begin try J:=Min(65536,Max(1,StrToInt(GetComboText))); except J:=10; end; G.SpeakerTandyRate:=J; end;
      Nr:=ValueActive(8009); If Nr>=0 then G.SpeakerDisney:=GetYesNo;

      {SoundBlaster}
      Nr:=ValueActive(8101); If Nr>=0 then G.SBType:=GetComboText;
      Nr:=ValueActive(8102); If Nr>=0 then begin try J:=StrToInt(GetComboText); except J:=220; end; G.SBBase:=J; end;
      Nr:=ValueActive(8103); If Nr>=0 then begin try J:=StrToInt(GetComboText); except J:=7; end; G.SBIRQ:=J; end;
      Nr:=ValueActive(8104); If Nr>=0 then begin try J:=StrToInt(GetComboText); except J:=1; end; G.SBDMA:=J; end;
      Nr:=ValueActive(8105); If Nr>=0 then begin try J:=StrToInt(GetComboText); except J:=5; end; G.SBHDMA:=J; end;
      Nr:=ValueActive(8106); If Nr>=0 then G.SBOplMode:=GetComboText;
      Nr:=ValueActive(8107); If Nr>=0 then G.SBOplEmu:=GetComboText;
      Nr:=ValueActive(8108); If Nr>=0 then begin try J:=StrToInt(GetComboText); except J:=22050; end; G.SBOplRate:=J; end;
      Nr:=ValueActive(8109); If Nr>=0 then G.SBMixer:=GetYesNo;

      {GUS}
      Nr:=ValueActive(8201); If Nr>=0 then G.GUS:=GetYesNo;
      Nr:=ValueActive(8202); If Nr>=0 then begin try J:=StrToInt(GetComboText); except J:=240; end; G.GUSBase:=J; end;
      Nr:=ValueActive(8203); If Nr>=0 then begin try J:=StrToInt(GetComboText); except J:=22050; end; G.GUSRate:=J; end;
      Nr:=ValueActive(8204); If Nr>=0 then begin try J:=StrToInt(GetComboText); except J:=5; end; G.GUSIRQ:=J; end;
      Nr:=ValueActive(8205); If Nr>=0 then begin try J:=StrToInt(GetComboText); except J:=1; end; G.GUSDMA:=J; end;
      Nr:=ValueActive(8206); If Nr>=0 then G.GUSUltraDir:=GetEditText;

      {MIDI}
      Nr:=ValueActive(8301); If Nr>=0 then G.MIDIType:=GetComboText;
      Nr:=ValueActive(8302); If Nr>=0 then G.MIDIDevice:=GetComboText;
      Nr:=ValueActive(8303); If Nr>=0 then G.MIDIConfig:=GetEditText;

      {Joystick}
      Nr:=ValueActive(9001); If Nr>=0 then G.JoystickType:=GetComboText;
      Nr:=ValueActive(9002); If Nr>=0 then G.JoystickTimed:=GetYesNo;
      Nr:=ValueActive(9003); If Nr>=0 then G.JoystickAutoFire:=GetYesNo;
      Nr:=ValueActive(9004); If Nr>=0 then G.JoystickSwap34:=GetYesNo;
      Nr:=ValueActive(9005); If Nr>=0 then G.JoystickButtonwrap:=GetYesNo;

      {Mounting}
      Nr:=ValueActive(10000); If Nr>=0 then ReplaceFolderWork(G,TComboBox(Settings[Nr].Values[0]).Text,TEdit(Settings[Nr].Values[0]).Text);
      Nr:=ValueActive(10001); If Nr>=0 then G.AutoMountCDs:=GetYesNo;
      Nr:=ValueActive(10002); If Nr>=0 then G.SecureMode:=GetYesNo;
      Nr:=ValueActive(10003); If Nr>=0 then ChangeMountSetting(G,GetComboIndex=0);

      {DOS environment}
      Nr:=ValueActive(11001); If Nr>=0 then G.ReportedDOSVersion:=GetComboText;
      Nr:=ValueActive(11002); If Nr>=0 then G.Use4DOS:=GetYesNo;

      {Starting}
      Nr:=ValueActive(12001); If Nr>=0 then G.AutoexecOverridegamestart:=GetYesNo;
      Nr:=ValueActive(12002); If Nr>=0 then G.AutoexecOverrideMount:=GetYesNo;
    end;

    If ScummVM then begin
      {ScummVM}
      Nr:=ValueActive(13001); If Nr>=0 then G.ScummVMPlatform:=GetComboText;
      Nr:=ValueActive(13002); If Nr>=0 then begin
        S:=GetComboText;
        If Pos('(',S)=0 then G.ScummVMFilter:='' else begin
          S:=Copy(S,Pos('(',S)+1,MaxInt);
          If Pos(')',S)=0 then G.ScummVMFilter:=''  else G.ScummVMFilter:=Copy(S,1,Pos(')',S)-1);
        end;
      end;
      Nr:=ValueActive(13003); If Nr>=0 then begin
        S:=GetComboText;
        If Pos('(',S)=0 then G.ScummVMRenderMode:=S else begin
          S:=Copy(S,Pos('(',S)+1,MaxInt);
          If Pos(')',S)=0 then G.ScummVMRenderMode:=GetComboText else G.ScummVMRenderMode:=Copy(S,1,Pos(')',S)-1);
        end;
      end;
      Nr:=ValueActive(13004); If Nr>=0 then G.StartFullscreen:=GetYesNo;
      Nr:=ValueActive(13005); If Nr>=0 then G.AspectCorrection:=GetYesNo;

      {ScummVM sound}
      Nr:=ValueActive(14001); If Nr>=0 then G.ScummVMMusicVolume:=GetSpinValue;
      Nr:=ValueActive(14002); If Nr>=0 then G.ScummVMSpeechVolume:=GetSpinValue;
      Nr:=ValueActive(14003); If Nr>=0 then G.ScummVMSFXVolume:=GetSpinValue;
      Nr:=ValueActive(14004); If Nr>=0 then G.ScummVMMIDIGain:=GetSpinValue;
      Nr:=ValueActive(14005); If Nr>=0 then G.ScummVMSampleRate:=StrToInt(GetComboText);
      Nr:=ValueActive(14006); If Nr>=0 then G.ScummVMSpeechMute:=GetYesNo;
    end;
  end;

  GameDB.StoreAllValues;
  GameDB.LoadCache;
end;

{ global }

Function ShowEditMultipleProfilesDialog(const AOwner : TComponent; const AGameDB : TGameDB; const TemplateMode : Boolean) : Boolean;
begin
  EditMultipleProfilesForm:=TEditMultipleProfilesForm.Create(AOwner);
  try
    EditMultipleProfilesForm.GameDB:=AGameDB;
    EditMultipleProfilesForm.TemplateMode:=TemplateMode;
    result:=(EditMultipleProfilesForm.ShowModal=mrOK);
  finally
    EditMultipleProfilesForm.Free;
  end;
end;

end.
