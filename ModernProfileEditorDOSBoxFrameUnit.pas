unit ModernProfileEditorDOSBoxFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, GameDBUnit, ModernProfileEditorFormUnit, StdCtrls, ExtCtrls, Buttons,
  ComCtrls;

type
  TModernProfileEditorDOSBoxFrame = class(TFrame, IModernProfileEditorFrame)
    DOSBoxForegroundPriorityRadioGroup: TRadioGroup;
    DOSBoxBackgroundPriorityRadioGroup: TRadioGroup;
    CloseDOSBoxOnExitCheckBox: TCheckBox;
    DefaultDOSBoxInstallationRadioButton: TRadioButton;
    CustomDOSBoxInstallationRadioButton: TRadioButton;
    CustomDOSBoxInstallationEdit: TEdit;
    CustomDOSBoxInstallationButton: TSpeedButton;
    CustomSetsClearButton: TBitBtn;
    CustomSetsLoadButton: TBitBtn;
    CustomSetsSaveButton: TBitBtn;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    CustomSetsMemo: TRichEdit;
    CustomSetsLabel: TLabel;
    procedure CustomDOSBoxInstallationButtonClick(Sender: TObject);
    procedure CustomDOSBoxInstallationEditChange(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Procedure InitGUI(const OnProfileNameChange : TTextEvent; const GameDB: TGameDB; const CurrentProfileName : PString);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Function CheckValue : Boolean;
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit, PrgConsts;

{$R *.dfm}

const Priority : Array[0..3] of String = ('lower','normal','higher','highest');

{ TModernProfileEditorDOSBoxFrame }

procedure TModernProfileEditorDOSBoxFrame.InitGUI(const OnProfileNameChange: TTextEvent; const GameDB: TGameDB; const CurrentProfileName: PString);
Var I : Integer;
begin
  NoFlicker(DOSBoxForegroundPriorityRadioGroup);
  NoFlicker(DOSBoxBackgroundPriorityRadioGroup);
  NoFlicker(CloseDOSBoxOnExitCheckBox);
  NoFlicker(DefaultDOSBoxInstallationRadioButton);
  NoFlicker(CustomDOSBoxInstallationRadioButton);
  NoFlicker(CustomDOSBoxInstallationEdit);
  {NoFlicker(CustomSetsMemo); - will hide text in Memo}
  NoFlicker(CustomSetsClearButton);
  NoFlicker(CustomSetsLoadButton);
  NoFlicker(CustomSetsSaveButton);

  DOSBoxForegroundPriorityRadioGroup.Caption:=LanguageSetup.GamePriorityForeground;
  For I:=0 to length(Priority)-1 do DOSBoxForegroundPriorityRadioGroup.Items.Add(Priority[I]);
  DOSBoxBackgroundPriorityRadioGroup.Caption:=LanguageSetup.GamePriorityBackground;
  For I:=0 to length(Priority)-1 do DOSBoxBackgroundPriorityRadioGroup.Items.Add(Priority[I]);
  CloseDOSBoxOnExitCheckBox.Caption:=LanguageSetup.GameCloseDosBoxAfterGameExit;
  DefaultDOSBoxInstallationRadioButton.Caption:=LanguageSetup.GameDOSBoxVersionDefault;
  CustomDOSBoxInstallationRadioButton.Caption:=LanguageSetup.GameDOSBoxVersionCustom;
  CustomDOSBoxInstallationButton.Hint:=LanguageSetup.ChooseFolder;
  CustomSetsLabel.Caption:=LanguageSetup.ProfileEditorCustomSetsSheet;
  CustomSetsMemo.Font.Name:='Courier New';
  CustomSetsClearButton.Caption:=LanguageSetup.Del;
  CustomSetsLoadButton.Caption:=LanguageSetup.Load;
  CustomSetsSaveButton.Caption:=LanguageSetup.Save;
end;

procedure TModernProfileEditorDOSBoxFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var St : TStringList;
    S,T : String;
    I : Integer;
begin
  St:=ValueToList(Game.Priority,',');
  try
    If (St.Count>=1) and (St[0]<>'') then S:=St[0] else S:=Priority[2];
    If (St.Count>=2) and (St[1]<>'') then T:=St[1] else T:=Priority[1];
  finally
    St.Free;
  end;
  S:=Trim(ExtUpperCase(S));
  DOSBoxForegroundPriorityRadioGroup.ItemIndex:=1;
  For I:=0 to DOSBoxForegroundPriorityRadioGroup.Items.Count-1 do If ExtUpperCase(DOSBoxForegroundPriorityRadioGroup.Items[I])=S then begin
    DOSBoxForegroundPriorityRadioGroup.ItemIndex:=I;
    break;
  end;
  T:=Trim(ExtUpperCase(T));
  DOSBoxBackgroundPriorityRadioGroup.ItemIndex:=2;
  For I:=0 to DOSBoxBackgroundPriorityRadioGroup.Items.Count-1 do If ExtUpperCase(DOSBoxBackgroundPriorityRadioGroup.Items[I])=T then begin
    DOSBoxBackgroundPriorityRadioGroup.ItemIndex:=I;
    break;
  end;

  CloseDOSBoxOnExitCheckBox.Checked:=Game.CloseDosBoxAfterGameExit;

  S:=Trim(ExtUpperCase(Game.CustomDOSBoxDir));
  If (S='') or (S='DEFAULT') then begin
    DefaultDOSBoxInstallationRadioButton.Checked:=True;
  end else begin
    CustomDOSBoxInstallationRadioButton.Checked:=True;
    CustomDOSBoxInstallationEdit.Text:=Game.CustomDOSBoxDir;
  end;

  St:=StringToStringList(Game.CustomSettings);
  try
    CustomSetsMemo.Lines.Assign(St);
  finally
    St.Free;
  end;
end;

function TModernProfileEditorDOSBoxFrame.CheckValue: Boolean;
begin
  result:=True;
end;

procedure TModernProfileEditorDOSBoxFrame.GetGame(const Game: TGame);
begin
  Game.Priority:=Priority[DOSBoxForegroundPriorityRadioGroup.ItemIndex]+','+Priority[DOSBoxBackgroundPriorityRadioGroup.ItemIndex];
  Game.CloseDosBoxAfterGameExit:=CloseDOSBoxOnExitCheckBox.Checked;
  If DefaultDOSBoxInstallationRadioButton.Checked then Game.CustomDOSBoxDir:='default' else Game.CustomDOSBoxDir:=CustomDOSBoxInstallationEdit.Text;
  Game.CustomSettings:=StringListToString(CustomSetsMemo.Lines);
end;

procedure TModernProfileEditorDOSBoxFrame.CustomDOSBoxInstallationButtonClick(Sender: TObject);
Var S : String;
begin
  S:=Trim(CustomDOSBoxInstallationEdit.Text);
  If (S='') or (ExtUpperCase(S)='DEFAULT') then S:=PrgSetup.DosBoxDir;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
  S:=MakeRelPath(S,PrgSetup.BaseDir);
  If S='' then exit;
  CustomDOSBoxInstallationEdit.Text:=IncludeTrailingPathDelimiter(S);
end;

procedure TModernProfileEditorDOSBoxFrame.CustomDOSBoxInstallationEditChange(Sender: TObject);
begin
  CustomDOSBoxInstallationRadioButton.Checked:=True;
end;

procedure TModernProfileEditorDOSBoxFrame.ButtonWork(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : CustomSetsMemo.Lines.Clear;
    1 : begin
          ForceDirectories(PrgDataDir+CustomConfigsSubDir);

          OpenDialog.DefaultExt:='txt';
          OpenDialog.Filter:=LanguageSetup.ProfileEditorCustomSetsFilter;
          OpenDialog.Title:=LanguageSetup.ProfileEditorCustomSetsLoadTitle;
          OpenDialog.InitialDir:=PrgDataDir+CustomConfigsSubDir;
          if not OpenDialog.Execute then exit;
          try
            CustomSetsMemo.Lines.LoadFromFile(OpenDialog.FileName);
          except
            MessageDlg(Format(LanguageSetup.MessageCouldNotOpenFile,[OpenDialog.FileName]),mtError,[mbOK],0);
          end;
        end;
    2 : begin
          ForceDirectories(PrgDataDir+CustomConfigsSubDir);

          SaveDialog.DefaultExt:='txt';
          SaveDialog.Filter:=LanguageSetup.ProfileEditorCustomSetsFilter;
          SaveDialog.Title:=LanguageSetup.ProfileEditorCustomSetsSaveTitle;
          SaveDialog.InitialDir:=PrgDataDir+CustomConfigsSubDir;
          if not SaveDialog.Execute then exit;
          try
            CustomSetsMemo.Lines.SaveToFile(SaveDialog.FileName);
          except
            MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[SaveDialog.FileName]),mtError,[mbOK],0);
          end;
        end;
  end;
end;

end.
