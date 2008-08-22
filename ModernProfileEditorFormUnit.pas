unit ModernProfileEditorFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, ImgList, GameDBUnit, LinkFileUnit;

Type TTextEvent=Procedure(Sender : TObject; const ProfileName, ProfileExe, ProfileSetup, ProfileScummVMGameName, ProfileScummVMPath : String) of object;

Type TModernProfileEditorInitData=record
  OnProfileNameChange : TTextEvent;
  GameDB: TGameDB;
  CurrentProfileName, CurrentProfileExe, CurrentProfileSetup, CurrentScummVMGameName, CurrentScummVMPath : PString;
  SearchLinkFile : TLinkFile;
end;

Type IModernProfileEditorFrame=interface
  Procedure InitGUI(const InitData : TModernProfileEditorInitData);
  Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
  Function CheckValue : Boolean;
  Procedure GetGame(const Game : TGame);
  Procedure ShowFrame;
end;

Type TFrameRecord=record
  Frame : TFrame;
  IFrame : IModernProfileEditorFrame;
  PageCode : Integer;
  ExtPageCode : Integer;
  TreeNode : TTreeNode;
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
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure FormCreate(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ShowConfButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    ProfileName, ProfileExe, ProfileSetup, ProfileScummVMGameName, ProfileScummVMPath : String;
    FrameList : Array of TFrameRecord;
    BaseFrame, StartFrame : TFrame;
    ScummVM, WindowsMode : Boolean;
    Procedure InitGUI;
    Procedure LoadData;
    Procedure SetProfileNameEvent(Sender : TObject; const AProfileName, AProfileExe, AProfileSetup, AProfileScummVMGameName, AProfileScummVMPath : String);
    Function AddTreeNode(const ParentTreeNode : TTreeNode; const F : TFrame; const I : IModernProfileEditorFrame; const Name : String; const PageCode : Integer; const ImageIndex : Integer) : TTreeNode;
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
  end;

var
  ModernProfileEditorForm: TModernProfileEditorForm;

Function ModernEditGameProfil(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList; const GameList : TList = nil) : Boolean;
Function ModernEditGameTemplate(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList; const GameList : TList = nil) : Boolean;

Function EditGameProfilInt(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList; const PrevButton, NextButton, RestorePos : Boolean; const EditingTemplate : Boolean) : Integer;

implementation

uses VistaToolsUnit, LanguageSetupUnit, ModernProfileEditorBaseFrameUnit,
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
     ModernProfileEditorPrinterFrameUnit, IconLoaderUnit, GameDBToolsUnit,
     PrgSetupUnit, CommonTools, DOSBoxUnit, HelpConsts;

{$R *.dfm}

var LastPage, LastPageExt, LastTop, LastLeft : Integer;

{ TModernProfileEditorForm }

procedure TModernProfileEditorForm.FormCreate(Sender: TObject);
begin
  LastUsedPageCode:=-1;
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
  InitData.GameDB:=GameDB;
  InitData.CurrentProfileName:=@ProfileName;
  InitData.CurrentProfileExe:=@ProfileExe;
  InitData.CurrentProfileSetup:=@ProfileSetup;
  InitData.CurrentScummVMGameName:=@ProfileScummVMGameName;
  InitData.CurrentScummVMPath:=@ProfileScummVMPath;
  InitData.SearchLinkFile:=SearchLinkFile;
  I.InitGUI(InitData);
end;

procedure TModernProfileEditorForm.InitGUI;
Var F : TFrame;
    N,N2,N3 : TTreeNode;
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

  ScummVM:=ScummVMMode(Game) or ScummVMMode(LoadTemplate);
  WindowsMode:=WindowsExeMode(Game) or WindowsExeMode(LoadTemplate);

  If ScummVM then S:=LanguageSetup.MenuProfileViewIniFile else S:=LanguageSetup.MenuProfileViewConfFile;
  while (S<>'') and (S[length(S)]='.') do SetLength(S,length(S)-1);
  ShowConfButton.Visible:=not WindowsMode;
  ShowConfButton.Caption:=Trim(S);

  If ScummVM then begin
    {ScummVM mode}
    F:=TModernProfileEditorBaseFrame.Create(self); N:=AddTreeNode(nil,F,TModernProfileEditorBaseFrame(F),LanguageSetup.ProfileEditorProfileSettingsSheet,0,0);
    BaseFrame:=F;
    F:=TModernProfileEditorGameInfoFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorGameInfoFrame(F),LanguageSetup.ProfileEditorGameInfoSheet,1,1);
    F:=TModernProfileEditorScummVMFrame.Create(self); AddTreeNode(nil,F,TModernProfileEditorScummVMFrame(F),LanguageSetup.ProfileEditorScummVMSheet,2,23);
    F:=TModernProfileEditorDirectoryFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorDirectoryFrame(F),LanguageSetup.ProfileEditorGameDirectorySheet,0,8);
    F:=TModernProfileEditorHardwareFrame.Create(self); N:=AddTreeNode(nil,F,TModernProfileEditorHardwareFrame(F),LanguageSetup.ProfileEditorHardwareSheet,3,3);
    F:=TModernProfileEditorScummVMGraphicsFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorScummVMGraphicsFrame(F),LanguageSetup.ProfileEditorGraphicsSheet,4,11);
    F:=TModernProfileEditorScummVMSoundFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorScummVMSoundFrame(F),LanguageSetup.ProfileEditorSoundSheet,5,5);
  end else begin
    If WindowsMode then begin
      {Windows mode}
      F:=TModernProfileEditorBaseFrame.Create(self); N:=AddTreeNode(nil,F,TModernProfileEditorBaseFrame(F),LanguageSetup.ProfileEditorProfileSettingsSheet,0,0);
      BaseFrame:=F;
      F:=TModernProfileEditorGameInfoFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorGameInfoFrame(F),LanguageSetup.ProfileEditorGameInfoSheet,1,1);
      F:=TModernProfileEditorDirectoryFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorDirectoryFrame(F),LanguageSetup.ProfileEditorGameDirectorySheet,0,8);
    end else begin
      {DOSBox mode}
      F:=TModernProfileEditorBaseFrame.Create(self); N:=AddTreeNode(nil,F,TModernProfileEditorBaseFrame(F),LanguageSetup.ProfileEditorProfileSettingsSheet,0,0);
      BaseFrame:=F;
      F:=TModernProfileEditorGameInfoFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorGameInfoFrame(F),LanguageSetup.ProfileEditorGameInfoSheet,1,1);
      F:=TModernProfileEditorDirectoryFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorDirectoryFrame(F),LanguageSetup.ProfileEditorGameDirectorySheet,0,8);
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
end;

procedure TModernProfileEditorForm.FormShow(Sender: TObject);
Var I : Integer;
begin
  InitGUI;

  LoadUserIcons(ImageList,'ModernProfileEditor');

  If (Game=nil) and (LoadTemplate<>nil) then begin
    Game:=LoadTemplate;
    try LoadData; finally Game:=nil; end;
    ProfileName:='';
    ProfileExe:='';
    ProfileSetup:='';
    ProfileScummVMGameName:='';
    ProfileScummVMPath:='';
  end else begin
    LoadData;
    ProfileEditorOpenCheck(Game);
    ProfileName:=Game.Name;
    ProfileExe:=Game.GameExe;
    ProfileSetup:=Game.SetupExe;
    ProfileScummVMGameName:=Game.ScummVMGame;
    ProfileScummVMPath:=Game.ScummVMSavePath;
  end;
  SetProfileNameEvent(self,ProfileName,ProfileExe,ProfileSetup,ProfileScummVMGameName,ProfileScummVMPath);

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

procedure TModernProfileEditorForm.SetProfileNameEvent(Sender: TObject; const AProfileName, AProfileExe, AProfileSetup, AProfileScummVMGameName, AProfileScummVMPath : String);
Var S : String;
begin
  ProfileName:=AProfileName;
  ProfileExe:=AProfileExe;
  ProfileSetup:=AProfileSetup;
  ProfileScummVMGameName:=AProfileScummVMGameName;
  ProfileScummVMPath:=AProfileScummVMPath;
  If Trim(ProfileName)='' then S:=LanguageSetup.NotSet else S:=ProfileName;
  If (S=LanguageSetup.ProfileEditorNoFilename) or (S=LanguageSetup.NotSet)
    then Caption:=LanguageSetup.ProfileEditor
    else Caption:=LanguageSetup.ProfileEditor+' ['+S+']';
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
    FrameList[Integer(Tree.Selected.Data)].IFrame.ShowFrame;
    TopPanel.Caption:='  '+Tree.Selected.Text;
  end;
end;

procedure TModernProfileEditorForm.OKButtonClick(Sender: TObject);
Var I : Integer;
    S : String;
    St : TStringList;
begin
  For I:=0 to Tree.Items.Count-1 do if not FrameList[Integer(Tree.Items[I].Data)].IFrame.CheckValue then begin
    Tree.Selected:=Tree.Items[I];
    ModalResult:=mrNone;
    exit;
  end;

  If not ScummVM then begin
    If (not EditingTemplate) and (LoadTemplate<>nil) and (Trim(TModernProfileEditorBaseFrame(BaseFrame).GameExeEdit.Text)='') and ((not WindowsMode) or TModernProfileEditorStartFrame(StartFrame).AutoexecBootNormal.Checked) then begin
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

  For I:=0 to Tree.Items.Count-1 do FrameList[Integer(Tree.Items[I].Data)].IFrame.GetGame(Game);

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

  If (not WindowsMode) and (not ScummVM) then begin
    St:=TStringList.Create;
    try
      BuildAutoexec(Game,False,St,True,-1,False);
    finally
      St.Free;
    end;
  end;
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
    DeleteFile(TempProf);
  end;
end;

{ global }

Function EditGameProfilInt(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList; const PrevButton, NextButton, RestorePos : Boolean; const EditingTemplate : Boolean) : Integer;
begin
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

Function ModernEditGameProfil(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList; const GameList : TList = nil) : Boolean;
Var I,J : Integer;
    PrevButton,NextButton,RestorePos : Boolean;
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
    I:=EditGameProfilInt(AOwner,AGameDB,AGame,ADefaultGame,ASearchLinkFile,ADeleteOnExit,PrevButton,NextButton,RestorePos,False);
    RestorePos:=True;
  until (I=0) or (I=-2);
  result:=(I<>-2);
end;

Function ModernEditGameTemplate(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const ASearchLinkFile : TLinkFile; const ADeleteOnExit : TStringList; const GameList : TList = nil) : Boolean;
Var I,J : Integer;
    PrevButton,NextButton,RestorePos : Boolean;
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
    I:=EditGameProfilInt(AOwner,AGameDB,AGame,ADefaultGame,ASearchLinkFile,ADeleteOnExit,PrevButton,NextButton,RestorePos,True);
    RestorePos:=True;
  until (I=0) or (I=-2);
  result:=(I<>-2);
end;

end.
