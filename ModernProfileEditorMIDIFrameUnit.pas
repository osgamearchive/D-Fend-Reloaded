unit ModernProfileEditorMIDIFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorMIDIFrame = class(TFrame, IModernProfileEditorFrame)
    TypeLabel: TLabel;
    TypeComboBox: TComboBox;
    DeviceLabel: TLabel;
    DeviceComboBox: TComboBox;
    AdditionalSettingsEdit: TLabeledEdit;
    MIDISelectButton: TButton;
    MIDISelectListBox: TListBox;
    MIDISelectLabel1: TLabel;
    MIDISelectLabel2: TLabel;
    InfoLabel: TLabel;
    procedure MIDISelectButtonClick(Sender: TObject);
    procedure MIDISelectListBoxClick(Sender: TObject);
  private
    { Private-Deklarationen }
    Procedure ShowFrame(Sender : TObject); 
  public
    { Public-Deklarationen }
    Procedure InitGUI(var InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, HelpConsts, DOSBoxTempUnit,
     DOSBoxUnit, PrgSetupUnit;

{$R *.dfm}

{ TModernProfileEditorMIDIFrame }

procedure TModernProfileEditorMIDIFrame.InitGUI(var InitData : TModernProfileEditorInitData);
Var St : TStringList;
begin
  NoFlicker(TypeComboBox);
  NoFlicker(DeviceComboBox);
  NoFlicker(AdditionalSettingsEdit);

  InfoLabel.Caption:=LanguageSetup.ProfileEditorSoundMIDIInfo;
  TypeLabel.Caption:=LanguageSetup.ProfileEditorSoundMIDIType;
  St:=ValueToList(InitData.GameDB.ConfOpt.MPU401,';,'); try TypeComboBox.Items.AddStrings(St); finally St.Free; end;
  DeviceLabel.Caption:=LanguageSetup.ProfileEditorSoundMIDIDevice;
  St:=ValueToList(InitData.GameDB.ConfOpt.MIDIDevice,';,'); try DeviceComboBox.Items.AddStrings(St); finally St.Free; end;
  AdditionalSettingsEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorSoundMIDIConfigInfo;
  MIDISelectButton.Caption:=LanguageSetup.ProfileEditorSoundMIDIConfigButton;
  MIDISelectLabel1.Caption:=LanguageSetup.ProfileEditorSoundMIDIConfigButtonInfo;
  MIDISelectLabel2.Caption:=LanguageSetup.ProfileEditorSoundMIDIConfigIDInfo;
  AddDefaultValueHint(TypeComboBox);
  AddDefaultValueHint(DeviceComboBox);

  InitData.OnShowFrame:=ShowFrame;

  HelpContext:=ID_ProfileEditSoundMIDI;
end;

procedure TModernProfileEditorMIDIFrame.ShowFrame(Sender: TObject);
begin
end;

Procedure SetComboBox(const ComboBox : TComboBox; const Value : String; const Default : Integer); overload;
Var S : String;
    I : Integer;
begin
  try ComboBox.ItemIndex:=Default; except end;
  S:=Trim(ExtUpperCase(Value));
  For I:=0 to ComboBox.Items.Count-1 do If Trim(ExtUpperCase(ComboBox.Items[I]))=S then begin
    ComboBox.ItemIndex:=I; break;
  end;
end;

Procedure SetComboBox(const ComboBox : TComboBox; const Value : String; const Default : String); overload;
begin
  SetComboBox(ComboBox,Default,0);
  SetComboBox(ComboBox,Value,ComboBox.ItemIndex);
end;

procedure TModernProfileEditorMIDIFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
begin
  SetComboBox(TypeComboBox,Game.MIDIType,'intelligent');
  SetComboBox(DeviceComboBox,Game.MIDIDevice,'default');
  AdditionalSettingsEdit.Text:=Game.MIDIConfig;
end;

procedure TModernProfileEditorMIDIFrame.GetGame(const Game: TGame);
begin
  Game.MIDIType:=TypeComboBox.Text;
  Game.MIDIDevice:=DeviceComboBox.Text;
  Game.MIDIConfig:=AdditionalSettingsEdit.Text;
end;

Procedure ProcessMIDIInfoLine(const Line : String; const List : TStringList);
Var I : Integer;
    S,T : String;
begin
  I:=Pos(' ',Line); If I=0 then exit;
  S:=Trim(Copy(Line,1,I-1)); T:=Trim(Copy(Line,I+1,MaxInt));
  If not TryStrToInt(S,I) then exit;
  If (T<>'') and (T[1]='"') and (T[length(T)]='"') then T:=Trim(Copy(T,2,length(T)-2));
  List.AddObject(T+' ('+LanguageSetup.ProfileEditorSoundMIDIConfigID+'='+IntToStr(I)+')',TObject(I));
end;

Function GetMIDIDevices : TStringList;
const MIDIListFile='DFR-MIDI.TMP';
Var TempGame : TTempGame;
    St : TStringList;
    S : String;
    I : Integer;
begin
  result:=TStringList.Create;
  TempGame:=TTempGame.Create;
  try
    TempGame.Game.Mount0:=TempDir+';DRIVE;C;False;;';
    St:=TStringList.Create;
    try
      St.Add('mixer /LISTMIDI > C:\'+MIDIListFile);
      St.Add('exit');
      TempGame.Game.Autoexec:=StringListToString(St);
    finally
      St.Free;
    end;
    TempGame.Game.StoreAllValues;
    RunCommandAndWait(TempGame.Game,'',True);
    St:=TStringList.Create;
    try
      try St.LoadFromFile(TempDir+MIDIListFile); except end;
      For I:=0 to St.Count-1 do begin
        S:=Trim(St[I]);
        If S='' then continue;
        ProcessMIDIInfoLine(S,result);
      end;
    finally
      St.Free;
    end;
    ExtDeleteFile(TempDir+MIDIListFile,ftTemp);
  finally
    TempGame.Free;
  end;
end;

procedure TModernProfileEditorMIDIFrame.MIDISelectButtonClick(Sender: TObject);
Var St : TStringList;
begin
  St:=GetMIDIDevices;
  try
    MIDISelectListBox.Visible:=(St.Count>0);
    MIDISelectLabel2.Visible:=(St.Count>0);
    MIDISelectListBox.Items.BeginUpdate;
    try
      MIDISelectListBox.Items.Clear;
      MIDISelectListBox.Items.AddStrings(St);
    finally
      MIDISelectListBox.Items.EndUpdate;
    end;
  finally
    St.Free;
  end;
end;

procedure TModernProfileEditorMIDIFrame.MIDISelectListBoxClick(Sender: TObject);
begin
  If MIDISelectListBox.ItemIndex<0 then exit;
  AdditionalSettingsEdit.Text:=IntToStr(Integer(MIDISelectListBox.Items.Objects[MIDISelectListBox.ItemIndex]));
end;

end.
