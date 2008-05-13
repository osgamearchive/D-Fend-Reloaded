unit SetupFrameDefaultValuesUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ComCtrls, Menus, SetupFormUnit, GameDBUnit;

type
  TSetupFrameDefaultValues = class(TFrame, ISetupFrame)
    DefaultValueLabel: TLabel;
    DefaultValueComboBox: TComboBox;
    DefaultValueMemo: TRichEdit;
    DefaultValueSpeedButton: TBitBtn;
    DefaultValuePopupMenu: TPopupMenu;
    PopupThisValue: TMenuItem;
    PopupAllValues: TMenuItem;
    procedure DefaultValueSpeedButtonClick(Sender: TObject);
    procedure DefaultValueComboBoxChange(Sender: TObject);
    procedure PopupMenuWork(Sender: TObject);
    procedure DefaultValueComboBoxDropDown(Sender: TObject);
  private
    { Private-Deklarationen }
    GameDB : TGameDB;
    LastIndex : Integer;
  public
    { Public-Deklarationen }
    Destructor Destroy; override;
    Function GetName : String;
    Procedure InitGUIAndLoadSetup(InitData : TInitData);
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvencedMode : Boolean);
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses Math, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools;

{$R *.dfm}

{ TSetupFrameDefaultValues }

destructor TSetupFrameDefaultValues.Destroy;
Var I : Integer;
begin
  for I:=0 to DefaultValueComboBox.Items.Count-1 do TStringList(DefaultValueComboBox.Items.Objects[I]).Free;
  inherited Destroy;
end;

function TSetupFrameDefaultValues.GetName: String;
begin
  result:=LanguageSetup.SetupFormDefaultValueSheet;
end;

procedure TSetupFrameDefaultValues.InitGUIAndLoadSetup(InitData: TInitData);
begin
  GameDB:=InitData.GameDB;

  NoFlicker(DefaultValueComboBox);
  NoFlicker(DefaultValueComboBox);

  LastIndex:=-1;
end;

procedure TSetupFrameDefaultValues.LoadLanguage;
Var I,J : Integer;
begin
  DefaultValueLabel.Caption:=LanguageSetup.SetupFormDefaultValueLabel;
  DefaultValueSpeedButton.Caption:=LanguageSetup.SetupFormDefaultValueReset;
  DefaultValueMemo.Font.Name:='Courier New';
  PopupThisValue.Caption:=LanguageSetup.SetupFormDefaultValueResetThis;
  PopupAllValues.Caption:=LanguageSetup.SetupFormDefaultValueResetAll;

  I:=DefaultValueComboBox.ItemIndex;
  DefaultValueComboBox.ItemIndex:=-1;
  DefaultValueComboBoxChange(self);

  For J:=0 to DefaultValueComboBox.Items.Count-1 do TStringList(DefaultValueComboBox.Items.Objects[J]).Free;
  DefaultValueComboBox.Items.Clear;

  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameResolution,ValueToList(GameDB.ConfOpt.Resolution,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameJoysticks,ValueToList(GameDB.ConfOpt.Joysticks,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameScale,ValueToList(GameDB.ConfOpt.Scale,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameRender,ValueToList(GameDB.ConfOpt.Render,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameCycles,ValueToList(GameDB.ConfOpt.Cycles,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameVideo,ValueToList(GameDB.ConfOpt.Video,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameMemory,ValueToList(GameDB.ConfOpt.Memory,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameFrameskip,ValueToList(GameDB.ConfOpt.Frameskip,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameCore,ValueToList(GameDB.ConfOpt.Core,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameSblaster,ValueToList(GameDB.ConfOpt.Sblaster,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameOplmode,ValueToList(GameDB.ConfOpt.Oplmode,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameKeyboardLayout,ValueToList(GameDB.ConfOpt.KeyboardLayout,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameKeyboardCodepage,ValueToList(GameDB.ConfOpt.Codepage,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameReportedDOSVersion,ValueToList(GameDB.ConfOpt.ReportedDOSVersion,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundMIDIDevice,ValueToList(GameDB.ConfOpt.MIDIDevice,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundBlockSize,ValueToList(GameDB.ConfOpt.Blocksize,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameCyclesDown,ValueToList(GameDB.ConfOpt.CyclesDown,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameCyclesUp,ValueToList(GameDB.ConfOpt.CyclesUp,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundSBDMA,ValueToList(GameDB.ConfOpt.Dma,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundGUSDMA1,ValueToList(GameDB.ConfOpt.Dma1,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundGUSDMA2,ValueToList(GameDB.ConfOpt.Dma2,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundGUSAddress,ValueToList(GameDB.ConfOpt.GUSBase,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundGUSRate,ValueToList(GameDB.ConfOpt.GUSRate,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundSBHDMA,ValueToList(GameDB.ConfOpt.HDMA,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundSBIRQ,ValueToList(GameDB.ConfOpt.IRQ,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundGUSIRQ1,ValueToList(GameDB.ConfOpt.IRQ1,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundGUSIRQ2,ValueToList(GameDB.ConfOpt.IRQ2,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundMIDIType,ValueToList(GameDB.ConfOpt.MPU401,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundSBOplRate,ValueToList(GameDB.ConfOpt.OPLRate,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundMiscPCSpeakerRate,ValueToList(GameDB.ConfOpt.PCRate,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundSampleRate,ValueToList(GameDB.ConfOpt.Rate,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundSBAddress,ValueToList(GameDB.ConfOpt.SBBase,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameMouseSensitivity,ValueToList(GameDB.ConfOpt.MouseSensitivity,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorSoundMiscTandyRate,ValueToList(GameDB.ConfOpt.TandyRate,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorScummVMFilter,ValueToList(GameDB.ConfOpt.ScummVMFilter,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.ProfileEditorScummVMMusicDriver,ValueToList(GameDB.ConfOpt.ScummVMMusicDriver,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameVGAChipset,ValueToList(GameDB.ConfOpt.VGAChipsets,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameVideoRam,ValueToList(GameDB.ConfOpt.VGAVideoRAM,';,'));

  DefaultValueComboBox.ItemIndex:=Max(0,I);
  DefaultValueComboBoxChange(self);
end;

procedure TSetupFrameDefaultValues.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameDefaultValues.ShowFrame(const AdvencedMode: Boolean);
begin
end;

procedure TSetupFrameDefaultValues.RestoreDefaults;
begin
  PopupMenuWork(PopupAllValues);
end;

procedure TSetupFrameDefaultValues.SaveSetup;
begin
  DefaultValueComboBoxChange(self);

  GameDB.ConfOpt.Resolution:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[0]),',');
  GameDB.ConfOpt.Joysticks:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[1]),',');
  GameDB.ConfOpt.Scale:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[2]),',');
  GameDB.ConfOpt.Render:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[3]),',');
  GameDB.ConfOpt.Cycles:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[4]),',');
  GameDB.ConfOpt.Video:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[5]),',');
  GameDB.ConfOpt.Memory:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[6]),',');
  GameDB.ConfOpt.Frameskip:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[7]),',');
  GameDB.ConfOpt.Core:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[8]),',');
  GameDB.ConfOpt.Sblaster:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[9]),',');
  GameDB.ConfOpt.Oplmode:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[10]),',');
  GameDB.ConfOpt.KeyboardLayout:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[11]),',');
  GameDB.ConfOpt.Codepage:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[12]),',');
  GameDB.ConfOpt.ReportedDOSVersion:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[13]),',');
  GameDB.ConfOpt.MIDIDevice:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[14]),',');
  GameDB.ConfOpt.Blocksize:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[15]),',');
  GameDB.ConfOpt.CyclesDown:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[16]),',');
  GameDB.ConfOpt.CyclesUp:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[17]),',');
  GameDB.ConfOpt.Dma:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[18]),',');
  GameDB.ConfOpt.Dma1:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[19]),',');
  GameDB.ConfOpt.Dma2:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[20]),',');
  GameDB.ConfOpt.GUSBase:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[21]),',');
  GameDB.ConfOpt.GUSRate:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[22]),',');
  GameDB.ConfOpt.HDMA:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[23]),',');
  GameDB.ConfOpt.IRQ:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[24]),',');
  GameDB.ConfOpt.IRQ1:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[25]),',');
  GameDB.ConfOpt.IRQ2:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[26]),',');
  GameDB.ConfOpt.MPU401:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[27]),',');
  GameDB.ConfOpt.OPLRate:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[28]),',');
  GameDB.ConfOpt.PCRate:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[29]),',');
  GameDB.ConfOpt.Rate:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[30]),',');
  GameDB.ConfOpt.SBBase:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[31]),',');
  GameDB.ConfOpt.MouseSensitivity:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[32]),',');
  GameDB.ConfOpt.TandyRate:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[33]),',');
  GameDB.ConfOpt.ScummVMFilter:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[34]),',');
  GameDB.ConfOpt.ScummVMMusicDriver:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[35]),',');
  GameDB.ConfOpt.VGAChipsets:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[36]),',');
  GameDB.ConfOpt.VGAVideoRAM:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[37]),',');
end;

procedure TSetupFrameDefaultValues.DefaultValueComboBoxChange(Sender: TObject);
begin
  If LastIndex>=0 then begin
    TStringList(DefaultValueComboBox.Items.Objects[LastIndex]).Clear;
    TStringList(DefaultValueComboBox.Items.Objects[LastIndex]).Assign(DefaultValueMemo.Lines);
  end;

  LastIndex:=DefaultValueComboBox.ItemIndex;
  DefaultValueMemo.Lines.Clear;
  If LastIndex<0 then exit;
  DefaultValueMemo.Lines.Assign(TStringList(DefaultValueComboBox.Items.Objects[LastIndex]));

  SetComboHint(DefaultValueComboBox);
end;

procedure TSetupFrameDefaultValues.DefaultValueComboBoxDropDown(Sender: TObject);
begin
  SetComboDropDownDropDownWidth(DefaultValueComboBox);
end;

procedure TSetupFrameDefaultValues.DefaultValueSpeedButtonClick(Sender: TObject);
Var P : TPoint;
begin
  P:=ClientToScreen(Point(DefaultValueSpeedButton.Left,DefaultValueSpeedButton.Top));
  DefaultValuePopupMenu.Popup(P.X+5,P.Y+5);
end;

procedure TSetupFrameDefaultValues.PopupMenuWork(Sender: TObject);
Var All : Boolean;
    I : Integer;
Procedure Work(const J : Integer; S : String);
begin
  If (I<>J) and (not All) then exit;
  TStringList(DefaultValueComboBox.Items.Objects[J]).Free;
  DefaultValueComboBox.Items.Objects[J]:=ValueToList(S,';,');
end;
begin
  All:=((Sender as TComponent).Tag=1);

  I:=LastIndex; LastIndex:=-1;

  Work(0,DefaultValuesResolution);
  Work(1,DefaultValuesJoysticks);
  Work(2,DefaultValuesScale);
  Work(3,DefaultValueRender);
  Work(4,DefaultValueCycles);
  Work(5,DefaultValuesVideo);
  Work(6,DefaultValuesMemory);
  Work(7,DefaultValuesFrameSkip);
  Work(8,DefaultValuesCore);
  Work(9,DefaultValueSBlaster);
  Work(10,DefaultValuesOPLModes);
  Work(11,DefaultValuesKeyboardLayout);
  Work(12,DefaultValuesCodepage);
  Work(13,DefaultValuesReportedDOSVersion);
  Work(14,DefaultValuesMIDIDevice);
  Work(15,DefaultValuesBlocksize);
  Work(16,DefaultValuesCyclesDown);
  Work(17,DefaultValuesCyclesUp);
  Work(18,DefaultValuesDMA);
  Work(19,DefaultValuesDMA1);
  Work(20,DefaultValuesDMA2);
  Work(21,DefaultValuesGUSBase);
  Work(22,DefaultValuesGUSRate);
  Work(23,DefaultValuesHDMA);
  Work(24,DefaultValuesIRQ);
  Work(25,DefaultValuesIRQ1);
  Work(26,DefaultValuesIRQ2);
  Work(27,DefaultValuesMPU401);
  Work(28,DefaultValuesOPLRate);
  Work(29,DefaultValuesPCRate);
  Work(30,DefaultValuesRate);
  Work(31,DefaultValuesSBBase);
  Work(32,DefaultValuesMouseSensitivity);
  Work(33,DefaultValuesTandyRate);
  Work(34,DefaultValuesScummVMFilter);
  Work(35,DefaultValuesScummVMMusicDriver);
  Work(36,DefaultValuesVGAChipsets);
  Work(37,DefaultValuesVGAVideoRAM);

  DefaultValueComboBox.ItemIndex:=I; DefaultValueComboBoxChange(Sender);
end;

end.
