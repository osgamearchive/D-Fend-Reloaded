unit ModernProfileEditorFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, GameDBUnit, ImgList;

Type TTextEvent=Procedure(Sender : TObject; const Text : String) of object;

Type IModernProfileEditorFrame=interface
  Procedure InitGUI(const OnProfileNameChange : TTextEvent; const GameDB: TGameDB; const CurrentProfileName : PString);
  Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
  Function CheckValue : Boolean;
  Procedure GetGame(const Game : TGame);
end;

Type TFrameRecord=record
  Frame : TFrame;
  IFrame : IModernProfileEditorFrame;
  PageCode : Integer;
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
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
  private
    { Private-Deklarationen }
    ProfileName : String;
    FrameList : Array of TFrameRecord;
    Procedure InitGUI;
    Procedure LoadData;
    Procedure SetProfileNameEvent(Sender : TObject; const Text : String);
    Function AddTreeNode(const ParentTreeNode : TTreeNode; const F : TFrame; const I : IModernProfileEditorFrame; const Name : String; const PageCode : Integer; const ImageIndex : Integer) : TTreeNode;
  public
    { Public-Deklarationen }
    LastVisibleFrame : TFrame;
    MoveStatus : Integer;
    LoadTemplate, Game : TGame;
    GameDB : TGameDB;
    RestoreLastPosition : Boolean;
  end;

var
  ModernProfileEditorForm: TModernProfileEditorForm;

Function ModernEditGameProfil(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const GameList : TList = nil) : Boolean;

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
     ModernProfileEditorStartFrameUnit, IconLoaderUnit;

{$R *.dfm}

var LastPage, LastTop, LastLeft : Integer;

{ TModernProfileEditorForm }

Function TModernProfileEditorForm.AddTreeNode(const ParentTreeNode : TTreeNode; const F : TFrame; const I : IModernProfileEditorFrame; const Name : String; const PageCode : Integer; const ImageIndex : Integer) : TTreeNode;
Var C : Integer;
begin
  C:=length(FrameList);
  F.Parent:=RightPanel; F.Align:=alClient; F.Visible:=False;
  result:=Tree.Items.AddChildObject(ParentTreeNode,Name,Pointer(C));
  SetLength(FrameList,C+1);
  FrameList[C].Frame:=F;
  FrameList[C].IFrame:=I;
  FrameList[C].PageCode:=PageCode;
  FrameList[C].TreeNode:=result;
  result.ImageIndex:=ImageIndex;
  result.SelectedIndex:=ImageIndex;
  F.DoubleBuffered:=True;
  I.InitGUI(SetProfileNameEvent,GameDB,@ProfileName);
end;

procedure TModernProfileEditorForm.InitGUI;
Var F : TFrame;
    N,N2,N3 : TTreeNode;
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);
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
  PreviousButton.Caption:=RemoveUnderline(LanguageSetup.OK)+' && '+LanguageSetup.Previous;
  NextButton.Caption:=RemoveUnderline(LanguageSetup.OK)+' && '+LanguageSetup.Next;

  F:=TModernProfileEditorBaseFrame.Create(self); N:=AddTreeNode(nil,F,TModernProfileEditorBaseFrame(F),LanguageSetup.ProfileEditorProfileSettingsSheet,0,0);
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
  F:=TModernProfileEditorVolumeFrame.Create(self); AddTreeNode(N2,F,TModernProfileEditorVolumeFrame(F),LanguageSetup.ProfileEditorSoundVolumeSheet,5,5);
  F:=TModernProfileEditorSoundBlasterFrame.Create(self); AddTreeNode(N2,F,TModernProfileEditorSoundBlasterFrame(F),LanguageSetup.ProfileEditorSoundSoundBlaster,5,5);
  F:=TModernProfileEditorGUSFrame.Create(self); AddTreeNode(N2,F,TModernProfileEditorGUSFrame(F),LanguageSetup.ProfileEditorSoundGUS,5,5);
  F:=TModernProfileEditorMIDIFrame.Create(self); AddTreeNode(N2,F,TModernProfileEditorMIDIFrame(F),LanguageSetup.ProfileEditorSoundMIDI,5,5);
  F:=TModernProfileEditorJoystickFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorJoystickFrame(F),LanguageSetup.ProfileEditorSoundJoystick,5,16);
  F:=TModernProfileEditorDrivesFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorDrivesFrame(F),LanguageSetup.ProfileEditorMountingSheet,4,4);
  F:=TModernProfileEditorSerialPortsFrame.Create(self); N2:=AddTreeNode(N,F,TModernProfileEditorSerialPortsFrame(F),LanguageSetup.ProfileEditorSerialPortsSheet,3,13);
  F:=TModernProfileEditorSerialPortFrame.Create(self); TModernProfileEditorSerialPortFrame(F).PortNr:=1; AddTreeNode(N2,F,TModernProfileEditorSerialPortFrame(F),LanguageSetup.GameSerial+' 1',3,13);
  F:=TModernProfileEditorSerialPortFrame.Create(self); TModernProfileEditorSerialPortFrame(F).PortNr:=2; AddTreeNode(N2,F,TModernProfileEditorSerialPortFrame(F),LanguageSetup.GameSerial+' 2',3,13);
  F:=TModernProfileEditorSerialPortFrame.Create(self); TModernProfileEditorSerialPortFrame(F).PortNr:=3; AddTreeNode(N2,F,TModernProfileEditorSerialPortFrame(F),LanguageSetup.GameSerial+' 3',3,13);
  F:=TModernProfileEditorSerialPortFrame.Create(self); TModernProfileEditorSerialPortFrame(F).PortNr:=4; AddTreeNode(N2,F,TModernProfileEditorSerialPortFrame(F),LanguageSetup.GameSerial+' 4',3,13);
  F:=TModernProfileEditorNetworkFrame.Create(self); AddTreeNode(N,F,TModernProfileEditorNetworkFrame(F),LanguageSetup.ProfileEditorNetworkSheet,3,14);
  F:=TModernProfileEditorDOSEnvironmentFrame.Create(self); AddTreeNode(nil,F,TModernProfileEditorDOSEnvironmentFrame(F),LanguageSetup.ProfileEditorDOSEnvironmentSheet,7,2);
  F:=TModernProfileEditorStartFrame.Create(self); AddTreeNode(nil,F,TModernProfileEditorStartFrame(F),LanguageSetup.ProfileEditorStartingSheet,6,6);

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
  end else begin
    LoadData;
    ProfileName:=Game.Name;
  end;
  SetProfileNameEvent(Sender,ProfileName);

  If RestoreLastPosition then begin
    For I:=0 to length(FrameList)-1 do if FrameList[I].PageCode=LastPage then begin
      Tree.Selected:=FrameList[I].TreeNode;
      break;
    end;
    Top:=LastTop;
    Left:=LastLeft;
  end;
end;

procedure TModernProfileEditorForm.LoadData;
Var I : Integer;
begin
  For I:=0 to Tree.Items.Count-1 do FrameList[Integer(Tree.Items[I].Data)].IFrame.SetGame(Game,LoadTemplate<>nil);
end;

procedure TModernProfileEditorForm.SetProfileNameEvent(Sender: TObject; const Text : String);
Var S : String;
begin
  ProfileName:=Text;
  If Trim(ProfileName)='' then S:=LanguageSetup.NotSet else S:=ProfileName;
  Caption:=LanguageSetup.ProfileEditor+' ['+S+']';
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
    TopPanel.Caption:='  '+Tree.Selected.Text;
  end;
end;

procedure TModernProfileEditorForm.OKButtonClick(Sender: TObject);
Var I : Integer;
begin
  For I:=0 to Tree.Items.Count-1 do if not FrameList[Integer(Tree.Items[I].Data)].IFrame.CheckValue then begin
    Tree.Selected:=Tree.Items[I];
    ModalResult:=mrNone;
    exit;
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
  end else begin
    LastPage:=0;
  end;

  Game.StoreAllValues;
  Game.LoadCache;
end;

{ global }

Function EditGameProfilInt(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const PrevButton, NextButton, RestorePos : Boolean) : Integer;
begin
  ModernProfileEditorForm:=TModernProfileEditorForm.Create(AOwner);

  try
    ModernProfileEditorForm.RestoreLastPosition:=RestorePos;
    If RestorePos then ModernProfileEditorForm.Position:=poDesigned;
    ModernProfileEditorForm.GameDB:=AGameDB;
    ModernProfileEditorForm.Game:=AGame;
    ModernProfileEditorForm.LoadTemplate:=ADefaultGame;
    ModernProfileEditorForm.PreviousButton.Visible:=PrevButton;
    ModernProfileEditorForm.NextButton.Visible:=NextButton;
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

Function ModernEditGameProfil(const AOwner : TComponent; const AGameDB : TGameDB; var AGame : TGame; const ADefaultGame : TGame; const GameList : TList = nil) : Boolean;
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
    I:=EditGameProfilInt(AOwner,AGameDB,AGame,ADefaultGame,PrevButton,NextButton,RestorePos);
    RestorePos:=True;
  until (I=0) or (I=-2);
  result:=(I<>-2);
end;


end.
