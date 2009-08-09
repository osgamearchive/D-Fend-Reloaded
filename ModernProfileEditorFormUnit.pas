unit ModernProfileEditorFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, ImgList, GameDBUnit, LinkFileUnit,
  Menus;

Type TTextEvent=Procedure(Sender : TObject; const ProfileName, ProfileExe, ProfileSetup, ProfileScummVMGameName, ProfileScummVMPath, ProfileDOSBoxInstallation : String) of object;
     TResetEvent=Procedure(Sender : TObject; const Template : TGame) of object;
     TCheckValueEvent=Procedure(Sender : TObject; var OK : Boolean) of object;

Type TModernProfileEditorInitData=record
  OnProfileNameChange : TTextEvent;
  OnResetToDefault : TResetEvent;
  OnCheckValue : TCheckValueEvent;
  OnShowFrame : TNotifyEvent;
  GameDB: TGameDB;
  EditingTemplate : Boolean;
  CurrentProfileName, CurrentProfileExe, CurrentProfileSetup, CurrentScummVMGameName, CurrentScummVMPath, CurrentDOSBoxInstallation : PString;
  SearchLinkFile : TLinkFile;
  AllowDefaultValueReset : Boolean;
end;

Type IModernProfileEditorFrame=interface
  Procedure InitGUI(var InitData : TModernProfileEditorInitData);
  Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
  Procedure GetGame(const Game : TGame);
end;

Type TFrameRecord=record
  Frame : TFrame;
  IFrame : IModernProfileEditorFrame;
  PageCode : Integer;
  ExtPageCode : Integer;
  TreeNode : TTreeNode;
  ResetToDefault : TResetEvent;
  CheckValue : TCheckValueEvent;
  ShowFrame : TNotifyEvent;
  AllowDefaultValueReset : Boolean;
end;

type
  TModernProfileEditorForm = class(TForm)
    BottomPanel: TPanel;
    MainPanel: TPanel;
    CancelButton: TBitBtn;
    PreviousButton: TBitBtn;
    NextButton: TBitBtn;
    OKButton: TBitBtn;
    Tree: TTreeView;
    ImageList: TImageList;
    Splitter1: TSplitter;
    RightPanel: TPanel;
    TopPanel: TPanel;
    HelpButton: TBitBtn;
    ShowConfButton: TBitBtn;
    ToolsButton: TBitBtn;
    ToolsPopupMenu: TPopupMenu;
    ToolsImageList: TImageList;
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure FormCreate(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ShowConfButtonClick(Sender: TObject);
    procedure ToolsButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    ProfileName, ProfileExe, ProfileSetup, ProfileScummVMGameName, ProfileScummVMPath, ProfileDOSBoxInstallation : String;
    FrameList : Array of TFrameRecord;
    BaseFrame, StartFrame : TFrame;
    ScummVM, WindowsMode : Boolean;
    ResetThisPageMenuItems : Array of TMenuItem;
    Procedure InitGUI;
    Procedure LoadData;
    Procedure SetProfileNameEvent(Sender : TObject; const AProfileName, AProfileExe, AProfileSetup, AProfileScummVMGameName, AProfileScummVMPath, AProfileDOSBoxInstallation : String);
    Function AddTreeNode(const ParentTreeNode : TTreeNode; const F : TFrame; const I : IModernProfileEditorFrame; const Name : String; const PageCode : Integer; const ImageIndex : Integer) : TTreeNode;
    Procedure InitToolsMenu;
    Procedure PopupMenuWork(Sender: TObject);
    Procedure OpenTempConfigurationFile;
    Procedure RunGameWithCurrentConfig;
    Procedure ResetTo(const Template : TGame; const AllPages : Boolean);
  public
    { Public-Deklarationen }
    LastUsedPageCode : Integer;
    LastVisibleFrame : TFrame;
    MoveStatus : Integer;
    LoadTemplate, Game : TGame;
    GameDB : TGameDB;
    RestoreLastPosition : Boolean;
    EditingTemplate : Boolean;
    SearchLinkFile : TLinkFile;
    DeleteOnExit : TStringList;
    NewExeFileName : String;
    HideGameInfoPage : Boolean;
  end;

var
  ModernProfileEditorForm: TModernProfileEditorForm;

Function ModernEditGameProfil(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList; const ANewExeFile : String; const GameList : TList = nil) : Boolean;
Function ModernEditGameTemplate(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList; const GameList : TList = nil; const TemplateType : TList = nil) : Boolean;

Function EditGameProfilInt(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList; const PrevButton, NextButton, RestorePos : Boolean; const EditingTemplate : Boolean; const ANewExeFile : String; const HideGameInfoPage : Boolean) : Integer;

Procedure AddDefaultValueHint(const AComboBox : TComboBox);

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, ModernProfileEditorBaseFrameUnit,
     ModernProfileEditorGameInfoFrameUnit, ModernProfileEditorDirectoryFrameUnit,
     ModernProfileEditorDOSBoxFrameUnit, ModernProfileEditorHardwareFrameUnit,
     ModernProfileEditorCPUFrameUnit, ModernProfileEditorMemoryFrameUnit,
     ModernProfileEditorGraphicsFrameUnit, ModernProfileEditorKeyboardFrameUnit,
     ModernProfileEditorMouseFrameUnit, ModernProfileEditorSoundFrameUnit,
     ModernProfileEditorVolumeFrameUnit, ModernProfileEditorSoundBlasterFrameUnit,
     ModernProfileEditorGUSFrameUnit, ModernProfileEditorMIDIFrameUnit,
     ModernProfileEditorJoystickFrameUnit, ModernProfileEditorDrivesFrameUnit,
     ModernProfileEditorSerialPortsFrameUnit, ModernProfileEditorSerialPortFrameUnit,
     ModernProfileEditorNetworkFrameUnit, ModernProfileEditorDOSEnvironmentFrameUnit,
     ModernProfileEditorStartFrameUnit, ModernProfileEditorScummVMGraphicsFrameUnit,
     ModernProfileEditorScummVMFrameUnit, ModernProfileEditorScummVMSoundFrameUnit,
     ModernProfileEditorPrinterFrameUnit, ModernProfileEditorScummVMGameFrameUnit,
     ModernProfileEditorHelperProgramsFrameUnit, ModernProfileEditorScummVMHardwareFrameUnit,
     ModernProfileEditorAddtionalChecksumFrameUnit,
     IconLoaderUnit, GameDBToolsUnit, PrgSetupUnit, CommonTools, DOSBoxUnit,
     PrgConsts, HelpConsts, SelectAutoSetupFormUnit;

{$R *.dfm}

var LastPage, LastPageExt, LastTop, LastLeft : Integer;

{ TModernProfileEditorForm }

procedure TModernProfileEditorForm.FormCreate(Sender: TObject);
begin
  LastUsedPageCode:=-1;
  NewExeFileName:='';
  HideGameInfoPage:=False;
end;

Function TModernProfileEditorForm.AddTreeNode(const ParentTreeNode : TTreeNode; const F : TFrame; const I : IModernProfileEditorFrame; const Name : String; const PageCode : Integer; const ImageIndex : Integer) : TTreeNode;
Var C : Integer;
    InitData : TModernProfileEditorInitData;
begin
  C:=length(FrameList);
  F.Parent:=RightPanel; F.Align:=alClient; F.Visible:=False;
  F.Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  result:=Tree.Items.AddChildObject(ParentTreeNode,Name,Pointer(C));
  SetLength(FrameList,C+1);
  FrameList[C].Frame:=F;
  FrameList[C].IFrame:=I;
  FrameList[C].PageCode:=PageCode;
  FrameList[C].ExtPageCode:=LastUsedPageCode; inc(LastUsedPageCode);
  FrameList[C].TreeNode:=result;
  result.ImageIndex:=ImageIndex;
  result.SelectedIndex:=ImageIndex;
  F.DoubleBuffered:=True;
  F.Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  InitData.OnProfileNameChange:=SetProfileNameEvent;
  InitData.OnResetToDefault:=nil;
  InitData.OnCheckValue:=nil;
  InitData.OnShowFrame:=nil;
  InitData.AllowDefaultValueReset:=True;
  InitData.GameDB:=GameDB;
  InitData.CurrentProfileName:=@ProfileName;
  InitData.CurrentProfileExe:=@ProfileExe;
  InitData.CurrentProfileSetup:=@ProfileSetup;
  InitData.CurrentScummVMGameName:=@ProfileScummVMGameName;
  InitData.CurrentScummVMPath:=@ProfileScummVMPath;
  InitData.CurrentDOSBoxInstallation:=@ProfileDOSBoxInstallation;
  InitData.SearchLinkFile:=SearchLinkFile;
  InitData.EditingTemplate:=EditingTemplate;
  I.InitGUI(InitData);
  FrameList[C].ResetToDefault:=InitData.OnResetToDefault;
  FrameList[C].CheckValue:=InitData.OnCheckValue;
  FrameList[C].ShowFrame:=InitData.OnShowFrame;
  FrameList[C].AllowDefaultValueReset:=InitData.AllowDefaultValueReset;
end;

Procedure TModernProfileEditorForm.InitToolsMenu;
Procedure AddThisPageMenuItem(const M : TMenuItem); var I : Integer; begin I:=length(ResetThisPageMenuItems); SetLength(ResetThisPageMenuItems,I+1); ResetThisPageMenuItems[I]:=M; end;
Var M,M2,M3 : TMenuItem;
    S : String;
    TemplateDB : TGameDB;
    I : Integer;
begin
  UserIconLoader.DialogImage(DI_ViewFile,ToolsImageList,0);
  UserIconLoader.DialogImage(DI_DOSBox,ToolsImageList,1);
  UserIconLoader.DialogImage(DI_ScummVM,ToolsImageList,2);

  If not WindowsMode then begin
    M:=TMenuItem.Create(ToolsPopupMenu);
    If ScummVM then S:=LanguageSetup.MenuProfileViewIniFile else S:=LanguageSetup.MenuProfileViewConfFile;
    while (S<>'') and (S[length(S)]='.') do SetLength(S,length(S)-1);
    M.Caption:=Trim(S);
    M.ImageIndex:=0; M.Tag:=0; M.OnClick:=PopupMenuWork; ToolsPopupMenu.Items.Add(M);
  end;

  M:=TMenuItem.Create(ToolsPopupMenu);
  M.Caption:=LanguageSetup.ProfileEditorToolsRun;
  If WindowsMode then M.ImageIndex:=-1 else begin
    If ScummVM then M.ImageIndex:=2 else M.ImageIndex:=1;
  end;
  M.Tag:=1; M.OnClick:=PopupMenuWork; ToolsPopupMenu.Items.Add(M);

  M:=TMenuItem.Create(ToolsPopupMenu); M.Caption:='-'; ToolsPopupMenu.Items.Add(M);

  M:=TMenuItem.Create(ToolsPopupMenu);
  M.Caption:=LanguageSetup.ProfileEditorToolsResetPage;
  M.Tag:=2; M.OnClick:=PopupMenuWork; ToolsPopupMenu.Items.Add(M); AddThisPageMenuItem(M);
  M:=TMenuItem.Create(ToolsPopupMenu);
  M.Caption:=LanguageSetup.ProfileEditorToolsResetAll;
  M.Tag:=3; M.OnClick:=PopupMenuWork; ToolsPopupMenu.Items.Add(M);
  If ScummVM or WindowsMode then exit;

  TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir);
  try
    If TemplateDB.Count>0 then begin

      M:=TMenuItem.Create(ToolsPopupMenu);
      M.Caption:=LanguageSetup.ProfileEditorToolsResetToTemplate;
      ToolsPopupMenu.Items.Add(M);

      For I:=0 to TemplateDB.Count-1 do begin
        M2:=TMenuItem.Create(ToolsPopupMenu);
        M2.Caption:=TemplateDB[I].Name;
        M.Add(M2);

        M3:=TMenuItem.Create(ToolsPopupMenu);
        M3.Caption:=LanguageSetup.ProfileEditorToolsResetToTemplatePage;
        M3.Tag:=10000+I; M3.OnClick:=PopupMenuWork; M2.Add(M3); AddThisPageMenuItem(M3);

        M3:=TMenuItem.Create(ToolsPopupMenu);
        M3.Caption:=LanguageSetup.ProfileEditorToolsResetToTemplateAll;
        M3.Tag:=20000+I; M3.OnClick:=PopupMenuWork; M2.Add(M3);
      end;
    end;
  finally
    TemplateDB.Free;
  end;

  M:=TMenuItem.Create(ToolsPopupMenu);
  M.Caption:=LanguageSetup.ProfileEditorToolsResetToAutoSetup;
  ToolsPopupMenu.Items.Add(M);

  M2:=TMenuItem.Create(ToolsPopupMenu);
  M2.Caption:=LanguageSetup.ProfileEditorToolsResetToAutoSetupPage;
  M2.Tag:=4; M2.OnClick:=PopupMenuWork; M.Add(M2); AddThisPageMenuItem(M2);

  M2:=TMenuItem.Create(ToolsPopupMenu);
  M2.Caption:=LanguageSetup.ProfileEditorToolsResetToAutoSetupAll;
  M2.Tag:=5; M2.OnClick:=PopupMenuWork; M.Add(M2);
end;

Procedure TModernProfileEditorForm.OpenTempConfigurationFile;
Var G : TGame;
    TempProf : String;
    I : Integer;
begin
  TempProf:=TempDir+MakeFileSysOKFolderName(ProfileName);
  try
    G:=TGame.Create(TempProf);
    try
      For I:=0 to Tree.Items.Count-1 do FrameList[Integer(Tree.Items[I].Data)].IFrame.GetGame(G);
      G.StoreAllValues; G.LoadCache; OpenConfigurationFile(G,DeleteOnExit);
    finally
      G.Free;
    end;
  finally
    ExtDeleteFile(TempProf,ftTemp);
  end;
end;

Procedure TModernProfileEditorForm.RunGameWithCurrentConfig;
Var G : TGame;
    TempProf : String;
    I : Integer;
begin
  TempProf:=TempDir+MakeFileSysOKFolderName(ProfileName);
  try
    G:=TGame.Create(TempProf);
    try
      For I:=0 to Tree.Items.Count-1 do FrameList[Integer(Tree.Items[I].Data)].IFrame.GetGame(G);
      G.StoreAllValues; G.LoadCache;
      RunGame(G);
    finally
      G.Free;
    end;
  finally
    ExtDeleteFile(TempProf,ftTemp);
  end;
end;

Procedure TModernProfileEditorForm.ResetTo(const Template : TGame; const AllPages : Boolean);
Var I : Integer;
begin
  If AllPages then begin
    If MessageDlg(LanguageSetup.ProfileEditorToolsResetAllConfirm,mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
    For I:=0 to length(FrameList)-1 do begin
      If not FrameList[I].AllowDefaultValueReset then continue;
      If Assigned(FrameList[I].ResetToDefault) then FrameList[I].ResetToDefault(self,Template) else FrameList[I].IFrame.SetGame(Template,True);
    end;
  end else begin
    If Tree.Selected=nil then exit;
    I:=Integer(Tree.Selected.Data);
    If FrameList[I].AllowDefaultValueReset then begin
      If Assigned(FrameList[I].ResetToDefault) then FrameList[I].ResetToDefault(self,Template) else FrameList[I].IFrame.SetGame(Template,True);
    end;
  end;
end;

Procedure TModernProfileEditorForm.PopupMenuWork(Sender: TObject);
Var DB : TGameDB;
    Nr : Integer;
    G : TGame;
begin
  Case (Sender as TComponent).Tag of
    0 : OpenTempConfigurationFile;
    1 : RunGameWithCurrentConfig;
    2 : begin
          G:=TGame.Create(PrgSetup);
          try ResetTo(G,False); finally G.Free; end;
        end;
    3 : begin
          G:=TGame.Create(PrgSetup);
          try ResetTo(G,True); finally G.Free; end;
        end;
    4 : begin
          DB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir);
          try
            Nr:=ShowSelectAutoSetupDialog(self,DB);
            If Nr>=0 then ResetTo(DB[Nr],False);
          finally
            DB.Free;
          end;
        end;
    5 : begin
          DB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir);
          try
            Nr:=ShowSelectAutoSetupDialog(self,DB);
            If Nr>=0 then ResetTo(DB[Nr],True);
          finally
            DB.Free;
          end;
        end;
    10000..19999 : begin
                     DB:=TGameDB.Create(PrgDataDir+TemplateSubDir);
                     try ResetTo(DB[(Sender as TComponent).Tag-10000],False); finally DB.Free; end;
                   end;
    20000..29999 : begin
                     DB:=TGameDB.Create(PrgDataDir+TemplateSubDir);
                     try ResetTo(DB[(Sender as TComponent).Tag-20000],True); finally DB.Free; end;
                   end;
  end;
end;

procedure TModernProfileEditorForm.InitGUI;
Var F : TFrame;
    N,N2 : TTreeNode;
    S : String;
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  NoFlicker(MainPanel);
  NoFlicker(BottomPanel);
  NoFlicker(RightPanel);
  NoFlicker(TopPanel);
  TopPanel.ControlStyle:=TopPanel.ControlStyle-[csParentBackground];

  LastVisibleFrame:=nil;
  MoveStatus:=0;

  Caption:=LanguageSetup.ProfileEditor;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  PreviousButton.Caption:=RemoveUnderline(LanguageSetup.OK)+' && '+LanguageSetup.Previous;
  NextButton.Caption:=RemoveUnderline(LanguageSetup.OK)+' && '+LanguageSetup.Next;

  UserIconLoader.DialogImage(DI_Previous,PreviousButton);
  UserIconLoader.DialogImage(DI_Next,NextButton);
  UserIconLoader.DialogImage(DI_ViewFile,ShowConfButton);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);
  UserIconLoader.DialogImage(DI_Tools,ToolsButton);

  ScummVM:=ScummVMMode(Game) or ScummVMMode(LoadTemplate);
  WindowsMode:=WindowsExeMode(Game) or WindowsExeMode(LoadTemplate);

  If ScummVM then S:=LanguageSetup.MenuProfileViewIniFile else S:=LanguageSetup.MenuProfileViewConfFile;
  while (S<>'') and (S[length(S)]='.') do SetLength(S,length(S)-1);
  ShowConfButton.Visible:=not WindowsMode;
  ShowConfButton.Caption:=Trim(S);

  ToolsButton.Caption:=LanguageSetup.ProfileEditorTools;
  ToolsButton.Visible:=PrgSetup.ActivateIncompleteFeatures;
  ShowConfButton.Visible:=ShowConfButton.Visible and (not PrgSetup.ActivateIncompleteFeatures);
  InitToolsMenu;

  If ScummVM then begin
    {ScummVM mode}
    F:=TModernProfileEditorBaseFrame.Create(self); N:=AddTreeNode(nil,F,TModernProfileEditorBaseFrame(F),LanguageSetup.ProfileEditorProfileSettingsSheet,0,0);
    BaseFrame:=F;
    If not HideGameInfoPage then begin F:=TModernProfileEditorGameInfoFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorGameInfoFrame(F),LanguageSetup.ProfileEditorGameInfoSheet,1,1); end;
    F:=TModernProfileEditorDirectoryFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorDirectoryFrame(F),LanguageSetup.ProfileEditorGameDirectorySheet,0,8);

    F:=TModernProfileEditorHelperProgramsFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorHelperProgramsFrame(F),LanguageSetup.ProfileEditorHelperProgramsSheet,0,0);
    F:=TModernProfileEditorScummVMFrame.Create(self); N:=AddTreeNode(nil,F,TModernProfileEditorScummVMFrame(F),LanguageSetup.ProfileEditorScummVMSheet,2,23);

    F:=TModernProfileEditorScummVMGameFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorScummVMGameFrame(F),LanguageSetup.ProfileEditorScummVMGameSheet,6,23);
    F:=TModernProfileEditorScummVMHardwareFrame.Create(self); N:=AddTreeNode(nil,F,TModernProfileEditorScummVMHardwareFrame(F),LanguageSetup.ProfileEditorHardwareSheet,3,3);
    F:=TModernProfileEditorScummVMGraphicsFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorScummVMGraphicsFrame(F),LanguageSetup.ProfileEditorGraphicsSheet,4,11);
    F:=TModernProfileEditorScummVMSoundFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorScummVMSoundFrame(F),LanguageSetup.ProfileEditorSoundSheet,5,5);
  end else begin
    If WindowsMode then begin
      {Windows mode}
      F:=TModernProfileEditorBaseFrame.Create(self); N:=AddTreeNode(nil,F,TModernProfileEditorBaseFrame(F),LanguageSetup.ProfileEditorProfileSettingsSheet,0,0);
      BaseFrame:=F;
      if EditingTemplate then begin F:=TModernProfileEditorAddtionalChecksumFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorAddtionalChecksumFrame(F),LanguageSetup.ProfileEditorAdditionalChecksums,0,0); end;
      If not HideGameInfoPage then begin F:=TModernProfileEditorGameInfoFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorGameInfoFrame(F),LanguageSetup.ProfileEditorGameInfoSheet,1,1); end;
      F:=TModernProfileEditorDirectoryFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorDirectoryFrame(F),LanguageSetup.ProfileEditorGameDirectorySheet,0,8);
      F:=TModernProfileEditorHelperProgramsFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorHelperProgramsFrame(F),LanguageSetup.ProfileEditorHelperProgramsSheet,0,0);
    end else begin
      {DOSBox mode}
      F:=TModernProfileEditorBaseFrame.Create(self); N:=AddTreeNode(nil,F,TModernProfileEditorBaseFrame(F),LanguageSetup.ProfileEditorProfileSettingsSheet,0,0);
      BaseFrame:=F;
      if EditingTemplate then begin F:=TModernProfileEditorAddtionalChecksumFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorAddtionalChecksumFrame(F),LanguageSetup.ProfileEditorAdditionalChecksums,0,0); end;
      If not HideGameInfoPage then begin F:=TModernProfileEditorGameInfoFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorGameInfoFrame(F),LanguageSetup.ProfileEditorGameInfoSheet,1,1); end;
      F:=TModernProfileEditorDirectoryFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorDirectoryFrame(F),LanguageSetup.ProfileEditorGameDirectorySheet,0,8);
      F:=TModernProfileEditorHelperProgramsFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorHelperProgramsFrame(F),LanguageSetup.ProfileEditorHelperProgramsSheet,0,0);
      F:=TModernProfileEditorDOSBoxFrame.Create(self); AddTreeNode(nil,F,TModernProfileEditorDOSBoxFrame(F),LanguageSetup.ProfileEditorGeneralSheet,2,2);
      F:=TModernProfileEditorHardwareFrame.Create(self); N:=AddTreeNode(nil,F,TModernProfileEditorHardwareFrame(F),LanguageSetup.ProfileEditorHardwareSheet,3,3);
      F:=TModernProfileEditorCPUFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorCPUFrame(F),LanguageSetup.ProfileEditorCPUSheet,3,9);
      F:=TModernProfileEditorMemoryFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorMemoryFrame(F),LanguageSetup.ProfileEditorMemorySheet,4,10);
      F:=TModernProfileEditorGraphicsFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorGraphicsFrame(F),LanguageSetup.ProfileEditorGraphicsSheet,4,11);
      F:=TModernProfileEditorKeyboardFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorKeyboardFrame(F),LanguageSetup.ProfileEditorKeyboardSheet,4,15);
      F:=TModernProfileEditorMouseFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorMouseFrame(F),LanguageSetup.ProfileEditorMouseSheet,4,12);
      F:=TModernProfileEditorSoundFrame.Create(self); N2:=AddTreeNode(N,F,TModernProfileEditorSoundFrame(F),LanguageSetup.ProfileEditorSoundSheet,5,5);
      F:=TModernProfileEditorVolumeFrame.Create(self); AddTreeNode(N2,F,TModernProfileEditorVolumeFrame(F),LanguageSetup.ProfileEditorSoundVolumeSheet,5,18);
      F:=TModernProfileEditorSoundBlasterFrame.Create(self); AddTreeNode(N2,F,TModernProfileEditorSoundBlasterFrame(F),LanguageSetup.ProfileEditorSoundSoundBlaster,5,19);
      F:=TModernProfileEditorGUSFrame.Create(self); AddTreeNode(N2,F,TModernProfileEditorGUSFrame(F),LanguageSetup.ProfileEditorSoundGUS,5,20);
      F:=TModernProfileEditorMIDIFrame.Create(self); AddTreeNode(N2,F,TModernProfileEditorMIDIFrame(F),LanguageSetup.ProfileEditorSoundMIDI,5,21);
      F:=TModernProfileEditorJoystickFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorJoystickFrame(F),LanguageSetup.ProfileEditorSoundJoystick,5,16);
      F:=TModernProfileEditorDrivesFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorDrivesFrame(F),LanguageSetup.ProfileEditorMountingSheet,4,4);
      F:=TModernProfileEditorSerialPortsFrame.Create(self); N2:=AddTreeNode(N,F,TModernProfileEditorSerialPortsFrame(F),LanguageSetup.ProfileEditorSerialPortsSheet,3,13);
      F:=TModernProfileEditorSerialPortFrame.Create(self); TModernProfileEditorSerialPortFrame(F).PortNr:=1; AddTreeNode(N2,F,TModernProfileEditorSerialPortFrame(F),LanguageSetup.GameSerial+' 1',3,13);
      F:=TModernProfileEditorSerialPortFrame.Create(self); TModernProfileEditorSerialPortFrame(F).PortNr:=2; AddTreeNode(N2,F,TModernProfileEditorSerialPortFrame(F),LanguageSetup.GameSerial+' 2',3,13);
      F:=TModernProfileEditorSerialPortFrame.Create(self); TModernProfileEditorSerialPortFrame(F).PortNr:=3; AddTreeNode(N2,F,TModernProfileEditorSerialPortFrame(F),LanguageSetup.GameSerial+' 3',3,13);
      F:=TModernProfileEditorSerialPortFrame.Create(self); TModernProfileEditorSerialPortFrame(F).PortNr:=4; AddTreeNode(N2,F,TModernProfileEditorSerialPortFrame(F),LanguageSetup.GameSerial+' 4',3,13);
      F:=TModernProfileEditorNetworkFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorNetworkFrame(F),LanguageSetup.ProfileEditorNetworkSheet,3,14);
      If PrgSetup.AllowPrinterSettings then begin
        F:=TModernProfileEditorPrinterFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorPrinterFrame(F),LanguageSetup.ProfileEditorPrinterSheet,3,17);
      end;
      F:=TModernProfileEditorDOSEnvironmentFrame.Create(self); AddTreeNode(nil,F,TModernProfileEditorDOSEnvironmentFrame(F),LanguageSetup.ProfileEditorDOSEnvironmentSheet,7,22);
      F:=TModernProfileEditorStartFrame.Create(self); AddTreeNode(nil,F,TModernProfileEditorStartFrame(F),LanguageSetup.ProfileEditorStartingSheet,6,6);
      StartFrame:=F;
    end;
  end;

  Tree.FullExpand;

  If Tree.Items.Count>0 then begin
    Tree.Selected:=Tree.Items[0];
    Tree.Selected.MakeVisible;
  end;

  {Fix height for smaller screens}
  Height:=Min(Height,Screen.WorkAreaHeight);
  If Top+Height>Screen.WorkAreaHeight then Top:=Screen.WorkAreaHeight-Height;
end;

procedure TModernProfileEditorForm.FormShow(Sender: TObject);
Var I : Integer;
begin
  InitGUI;

  UserIconLoader.DirectLoad(ImageList,'ModernProfileEditor');

  If (Game=nil) and (LoadTemplate<>nil) then begin
    Game:=LoadTemplate;
    try LoadData; finally Game:=nil; end;
    ProfileName:='';
    ProfileExe:='';
    ProfileSetup:='';
    ProfileScummVMGameName:='';
    ProfileScummVMPath:='';
    ProfileDOSBoxInstallation:='';
  end else begin
    LoadData;
    ProfileEditorOpenCheck(Game);
    If Trim(NewExeFileName)<>'' then ProfileName:=NewExeFileName else ProfileName:=Game.Name;
    ProfileExe:=Game.GameExe;
    ProfileSetup:=Game.SetupExe;
    ProfileScummVMGameName:=Game.ScummVMGame;
    ProfileScummVMPath:=Game.ScummVMSavePath;
    ProfileDOSBoxInstallation:=Game.CustomDOSBoxDir;
  end;

  If Trim(NewExeFileName)<>'' then begin
    TModernProfileEditorBaseFrame(BaseFrame).GameExeEdit.Text:=NewExeFileName;
  end;

  SetProfileNameEvent(self,ProfileName,ProfileExe,ProfileSetup,ProfileScummVMGameName,ProfileScummVMPath,ProfileDOSBoxInstallation);

  If RestoreLastPosition then begin
    If LastPageExt>=0 then begin
      For I:=0 to length(FrameList)-1 do if FrameList[I].ExtPageCode=LastPageExt then begin
        Tree.Selected:=FrameList[I].TreeNode;
        break;
      end;
    end else begin
      For I:=0 to length(FrameList)-1 do if FrameList[I].PageCode=LastPage then begin
        Tree.Selected:=FrameList[I].TreeNode;
        break;
      end;
    end;
    If LastTop>0 then Top:=LastTop;
    If LastLeft>0 then Left:=LastLeft;
  end else begin
    If PrgSetup.ReopenLastProfileEditorTab and (Game<>nil) then begin
      If Game.LastOpenTabModern>=0 then begin
        For I:=0 to length(FrameList)-1 do if FrameList[I].ExtPageCode=Game.LastOpenTabModern then begin
          Tree.Selected:=FrameList[I].TreeNode;
          break;
        end;
      end else begin
        For I:=0 to length(FrameList)-1 do if FrameList[I].PageCode=Game.LastOpenTab then begin
          Tree.Selected:=FrameList[I].TreeNode;
          break;
        end;
      end;
    end;
  end;
  TreeChange(Sender,Tree.Selected);
end;

procedure TModernProfileEditorForm.LoadData;
Var I : Integer;
begin
  For I:=0 to Tree.Items.Count-1 do FrameList[Integer(Tree.Items[I].Data)].IFrame.SetGame(Game,LoadTemplate<>nil);
end;

procedure TModernProfileEditorForm.SetProfileNameEvent(Sender: TObject; const AProfileName, AProfileExe, AProfileSetup, AProfileScummVMGameName, AProfileScummVMPath, AProfileDOSBoxInstallation : String);
Var S : String;
begin
  ProfileName:=AProfileName;
  ProfileExe:=AProfileExe;
  ProfileSetup:=AProfileSetup;
  ProfileScummVMGameName:=AProfileScummVMGameName;
  ProfileScummVMPath:=AProfileScummVMPath;
  ProfileDOSBoxInstallation:=AProfileDOSBoxInstallation;

  If Trim(ProfileName)='' then begin
    If EditingTemplate and HideGameInfoPage then begin
      If ScummVMMode(Game)
        then S:=LanguageSetup.TemplateFormDefaultScummVM
        else S:=LanguageSetup.TemplateFormDefault;
    end else begin
      S:=LanguageSetup.NotSet
    end;
  end else begin
    S:=ProfileName;
  end;
  If (S=LanguageSetup.ProfileEditorNoFilename) or (S=LanguageSetup.NotSet)
    then Caption:=LanguageSetup.ProfileEditor
    else Caption:=LanguageSetup.ProfileEditor+' ['+S+']';
end;

procedure TModernProfileEditorForm.ToolsButtonClick(Sender: TObject);
Var P : TPoint;
    B : Boolean;
    I : Integer;
begin
  If Tree.Selected=nil then B:=False else B:=FrameList[Integer(Tree.Selected.Data)].AllowDefaultValueReset;
  For I:=0 to length(ResetThisPageMenuItems)-1 do ResetThisPageMenuItems[I].Enabled:=B; 

  P:=BottomPanel.ClientToScreen(Point(ToolsButton.Left,ToolsButton.Top));
  ToolsPopupMenu.Popup(P.X+5,P.Y+5);
end;

procedure TModernProfileEditorForm.TreeChange(Sender: TObject; Node: TTreeNode);
begin
  If LastVisibleFrame<>nil then begin
    LastVisibleFrame.Visible:=False;
    LastVisibleFrame:=nil;
  end;

  If Tree.Selected<>nil then begin
    LastVisibleFrame:=FrameList[Integer(Tree.Selected.Data)].Frame;
    LastVisibleFrame.Visible:=True;
    If Assigned(FrameList[Integer(Tree.Selected.Data)].ShowFrame) then FrameList[Integer(Tree.Selected.Data)].ShowFrame(self);
    TopPanel.Caption:='  '+Tree.Selected.Text;
  end;
end;

procedure TModernProfileEditorForm.OKButtonClick(Sender: TObject);
Var I : Integer;
    S : String;
    St : TStringList;
    B : Boolean;
begin
  For I:=0 to Tree.Items.Count-1 do begin
    If not Assigned(FrameList[Integer(Tree.Items[I].Data)].CheckValue) then continue;
    B:=True;
    FrameList[Integer(Tree.Items[I].Data)].CheckValue(self,B);
    If not B then begin Tree.Selected:=Tree.Items[I];  ModalResult:=mrNone; exit; end;
  end;

  If not ScummVM then begin
    If (not EditingTemplate) and (LoadTemplate<>nil) and (Trim(TModernProfileEditorBaseFrame(BaseFrame).GameExeEdit.Text)='') and (WindowsMode or (not TModernProfileEditorStartFrame(StartFrame).AutoexecBootNormal.Checked)) then begin
      If MessageDlg(LanguageSetup.MessageNoGameFileNameWarning,mtConfirmation,[mbYes,mbNo],0)<>mrYes then begin
        Tree.Selected:=Tree.Items[0];
        ModalResult:=mrNone;
        exit;
      end;
    end;

    If WindowsMode then begin
      If (not EditingTemplate) and (Trim(TModernProfileEditorBaseFrame(BaseFrame).GameExeEdit.Text)<>'') then begin
        S:=MakeAbsPath(TModernProfileEditorBaseFrame(BaseFrame).GameExeEdit.Text,PrgSetup.BaseDir);
        If IsDOSExe(S) then begin
          If MessageDlg(Format(LanguageSetup.MessageDOSExeEditWarning,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then begin
            Tree.Selected:=Tree.Items[0];
            ModalResult:=mrNone;
            exit;
          end;
        end;
        If (Trim(TModernProfileEditorBaseFrame(BaseFrame).SetupExeEdit.Text)<>'') then begin
          S:=MakeAbsPath(TModernProfileEditorBaseFrame(BaseFrame).SetupExeEdit.Text,PrgSetup.BaseDir);
          If IsDOSExe(S) then begin
            If MessageDlg(Format(LanguageSetup.MessageDOSExeEditWarning,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then begin
              Tree.Selected:=Tree.Items[0];
              ModalResult:=mrNone;
              exit;
            end;
          end;
        end;
      end;
    end else begin
      If (not EditingTemplate) and TModernProfileEditorStartFrame(StartFrame).AutoexecBootNormal.Checked then begin
        If (not TModernProfileEditorBaseFrame(BaseFrame).GameRelPathCheckBox.Checked) and (Trim(TModernProfileEditorBaseFrame(BaseFrame).GameExeEdit.Text)<>'') then begin
          S:=MakeAbsPath(TModernProfileEditorBaseFrame(BaseFrame).GameExeEdit.Text,PrgSetup.BaseDir);
          If IsWindowsExe(S) then begin
            If MessageDlg(Format(LanguageSetup.MessageWindowsExeEditWarning,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then begin
              Tree.Selected:=Tree.Items[0];
              ModalResult:=mrNone;
              exit;
            end;
          end;
        end;
        If (not TModernProfileEditorBaseFrame(BaseFrame).SetupRelPathCheckBox.Checked) and (Trim(TModernProfileEditorBaseFrame(BaseFrame).SetupExeEdit.Text)<>'') then begin
          S:=MakeAbsPath(TModernProfileEditorBaseFrame(BaseFrame).SetupExeEdit.Text,PrgSetup.BaseDir);
          If IsWindowsExe(S) then begin
            If MessageDlg(Format(LanguageSetup.MessageWindowsExeEditWarning,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then begin
              Tree.Selected:=Tree.Items[0];
              ModalResult:=mrNone;
              exit;
            end;
          end;
        end;
      end;
    end;
  end;

  Case (Sender as TComponent).Tag of
    0 : MoveStatus:=0;
    1 : MoveStatus:=-1;
    2 : MoveStatus:=1;
  End;

  If Game=nil then begin
    I:=GameDB.Add(ProfileName);
    Game:=GameDB[I];
  end;

  For I:=0 to Tree.Items.Count-1 do begin
    FrameList[Integer(Tree.Items[I].Data)].IFrame.GetGame(Game);
    ProfileName:=Game.Name;
  end;

  If Tree.Selected<>nil then begin
    LastPage:=FrameList[Integer(Tree.Selected.Data)].PageCode;
    LastPageExt:=FrameList[Integer(Tree.Selected.Data)].ExtPageCode;
  end else begin
    LastPage:=0;
    LastPageExt:=0;
  end;
  Game.LastOpenTab:=LastPage;
  Game.LastOpenTabModern:=LastPageExt;

  Game.StoreAllValues;
  Game.LoadCache;

  If (not WindowsMode) and (not ScummVM) and (not EditingTemplate) then begin
    St:=TStringList.Create;
    try
      BuildAutoexec(Game,False,St,True,-1,False,False);
    finally
      St.Free;
    end;
  end;

  If Trim(Game.CaptureFolder)<>'' then ForceDirectories(MakeAbsPath(Game.CaptureFolder,PrgSetup.BaseDir));
end;

procedure TModernProfileEditorForm.HelpButtonClick(Sender: TObject);
Var I : Integer;
begin
  I:=0;
  If LastVisibleFrame<>nil then I:=LastVisibleFrame.HelpContext;
  If I=0 then I:=ID_FileEdit;
  Application.HelpCommand(HELP_CONTEXT,I);
end;

procedure TModernProfileEditorForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

procedure TModernProfileEditorForm.ShowConfButtonClick(Sender: TObject);
Var G : TGame;
    TempProf : String;
    I : Integer;
begin
  TempProf:=TempDir+MakeFileSysOKFolderName(ProfileName);
  try
    G:=TGame.Create(TempProf);
    try
      For I:=0 to Tree.Items.Count-1 do FrameList[Integer(Tree.Items[I].Data)].IFrame.GetGame(G);
      G.StoreAllValues;
      G.LoadCache;
      OpenConfigurationFile(G,DeleteOnExit);
    finally
      G.Free;
    end;
  finally
    ExtDeleteFile(TempProf,ftTemp);
  end;
end;

{ global }

Function EditGameProfilInt(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList; const PrevButton, NextButton, RestorePos : Boolean; const EditingTemplate : Boolean; const ANewExeFile : String; const HideGameInfoPage : Boolean) : Integer;
Var D : Double;
    S : String;
    I : Integer;
begin
  If (AGame<>nil) and (Trim(ExtUpperCase(AGame.VideoCard))='VGA') then begin
    S:=CheckDOSBoxVersion(GetDOSBoxNr(AGame)); For I:=1 to length(S) do If (S[I]=',') or (S[I]='.') then S[I]:=DecimalSeparator;
    if not TryStrToFloat(S,D) then D:=0.72;
    If D>0.72 then begin AGame.VideoCard:='svga_s3'; AGame.StoreAllValues; end;
  end;

  ModernProfileEditorForm:=TModernProfileEditorForm.Create(AOwner);

  try
    ModernProfileEditorForm.RestoreLastPosition:=RestorePos;
    If RestorePos and ((LastTop>0) or (LastLeft>0)) then ModernProfileEditorForm.Position:=poDesigned;
    ModernProfileEditorForm.GameDB:=AGameDB;
    ModernProfileEditorForm.Game:=AGame;
    ModernProfileEditorForm.SearchLinkFile:=ASearchLinkFile;
    ModernProfileEditorForm.DeleteOnExit:=ADeleteOnExit;
    ModernProfileEditorForm.LoadTemplate:=ADefaultGame;
    ModernProfileEditorForm.PreviousButton.Visible:=PrevButton;
    ModernProfileEditorForm.NextButton.Visible:=NextButton;
    ModernProfileEditorForm.EditingTemplate:=EditingTemplate;
    If ANewExeFile<>'' then ModernProfileEditorForm.NewExeFileName:=ANewExeFile;
    ModernProfileEditorForm.HideGameInfoPage:=HideGameInfoPage;
    If ModernProfileEditorForm.ShowModal=mrOK then begin
      result:=ModernProfileEditorForm.MoveStatus;
      AGame:=ModernProfileEditorForm.Game;
      {LastPage set via OKButtonClick}
      LastTop:=ModernProfileEditorForm.Top;
      LastLeft:=ModernProfileEditorForm.Left;
    end else begin
      result:=-2;
    end;
  finally
    ModernProfileEditorForm.Free;
  end;
end;

Function ModernEditGameProfil(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList; const ANewExeFile : String; const GameList : TList = nil) : Boolean;
Var I,J : Integer;
    PrevButton,NextButton,RestorePos : Boolean;
    S : String;
begin
  I:=0; RestorePos:=False;
  repeat
    If GameList=nil then begin
      NextButton:=False;
      PrevButton:=False;
    end else begin
      If I=1 then begin
        J:=GameList.IndexOf(AGame);
        If (J>=0) and (J<GameList.Count-1) then AGame:=TGame(GameList[J+1]);
      end;
      If I=-1 then begin
        J:=GameList.IndexOf(AGame);
        If J>0 then AGame:=TGame(GameList[J-1]);
      end;
      J:=GameList.IndexOf(AGame);
      NextButton:=(J>=0) and (J<GameList.Count-1);
      PrevButton:=(J>0);
    end;
    If (GameList=nil) or (GameList.Count=0) then S:=ANewExeFile else S:='';
    I:=EditGameProfilInt(AOwner,AGameDB,AGame,ADefaultGame,ASearchLinkFile,ADeleteOnExit,PrevButton,NextButton,RestorePos,False,S,False);
    RestorePos:=True;
  until (I=0) or (I=-2);
  result:=(I<>-2);
end;

Function ModernEditGameTemplate(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList; const GameList : TList = nil; const TemplateType : TList = nil) : Boolean;
Var I,J : Integer;
    PrevButton,NextButton,RestorePos : Boolean;
    TemplateMode : Integer;
begin
  I:=0; RestorePos:=False;
  repeat
    If GameList=nil then begin
      NextButton:=False;
      PrevButton:=False;
    end else begin
      If I=1 then begin
        J:=GameList.IndexOf(AGame);
        If (J>=0) and (J<GameList.Count-1) then AGame:=TGame(GameList[J+1]);
      end;
      If I=-1 then begin
        J:=GameList.IndexOf(AGame);
        If J>0 then AGame:=TGame(GameList[J-1]);
      end;
      J:=GameList.IndexOf(AGame);
      NextButton:=(J>=0) and (J<GameList.Count-1);
      PrevButton:=(J>0);
    end;

    If (TemplateType<>nil) then begin
      TemplateMode:=Integer(TemplateType[GameList.IndexOf(AGame)]);
    end else begin
      TemplateMode:=0;
    end;
    {TemplateMode: 0=normal template, 1=default template, 2=ScummVM default template}

    If TemplateMode=2 then AGame.ProfileMode:='ScummVM';
    try
      I:=EditGameProfilInt(AOwner,AGameDB,AGame,ADefaultGame,ASearchLinkFile,ADeleteOnExit,PrevButton,NextButton,RestorePos,True,'',TemplateMode<>0);
    finally
      If TemplateMode=2 then AGame.ProfileMode:='DOSBox';
    end;
    RestorePos:=True;
  until (I=0) or (I=-2);
  result:=(I<>-2);
end;

Procedure AddDefaultValueHint(const AComboBox : TComboBox);
Var S : String;
    I : Integer;
begin
  S:=LanguageSetup.ProfileEditorDefaultValueHint;
  If length(S)>80 then For I:=80 downto 1 do If S[I]=#32 then begin S[I]:=#13; break; end;
  AComboBox.Hint:=S;
  AComboBox.ShowHint:=True;
end;

end.
