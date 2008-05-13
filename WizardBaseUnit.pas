unit WizardBaseUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ComCtrls, Buttons, Grids, ValEdit, ExtCtrls,
  GameDBUnit;

type
  TWizardBaseFrame = class(TFrame)
    BaseName: TLabeledEdit;
    InfoLabel: TLabel;
    Bevel: TBevel;
    EmulationTypeRadioGroup: TRadioGroup;
    ListScummGamesButton: TBitBtn;
    ShowInfoButton: TBitBtn;
    procedure ButtonWork(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Procedure Init(const GameDB : TGameDB);
    Procedure WriteDataToGame(const Game : TGame);
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgConsts, PrgSetupUnit,
     ListScummVMGamesFormUnit, TextViewerFormUnit;

{$R *.dfm}

{ TWizardBaseFrame }

procedure TWizardBaseFrame.Init(const GameDB : TGameDB);
begin
  SetVistaFonts(self);

  InfoLabel.Font.Style:=[fsBold];
  InfoLabel.Caption:=LanguageSetup.WizardFormPage1Info;
  BaseName.EditLabel.Caption:=LanguageSetup.WizardFormBaseName;
  EmulationTypeRadioGroup.Caption:=LanguageSetup.WizardFormEmulationType;
  EmulationTypeRadioGroup.Items[0]:=LanguageSetup.WizardFormEmulationTypeDOSBox;
  EmulationTypeRadioGroup.Items[1]:=LanguageSetup.WizardFormEmulationTypeScummVM;
  ListScummGamesButton.Caption:=LanguageSetup.WizardFormEmulationTypeListScummVMGames;
  ShowInfoButton.Caption:=LanguageSetup.WizardFormMainInfo;
  EmulationTypeRadioGroup.Visible:=(Trim(PrgSetup.ScummVMPath)<>'');
  ListScummGamesButton.Visible:=(Trim(PrgSetup.ScummVMPath)<>'');
  If not ListScummGamesButton.Visible then begin
    ShowInfoButton.Left:=ListScummGamesButton.Left;
    ShowInfoButton.Top:=EmulationTypeRadioGroup.Top;
  end;
end;

procedure TWizardBaseFrame.WriteDataToGame(const Game: TGame);
begin
  Game.Name:=BaseName.Text;
  If EmulationTypeRadioGroup.ItemIndex=0 then begin
    Game.CaptureFolder:='.\'+CaptureSubDir+'\'+MakeFileSysOKFolderName(Game.Name);
    CreateDir(MakeAbsPath(Game.CaptureFolder,PrgSetup.BaseDir));
  end;
end;

procedure TWizardBaseFrame.ButtonWork(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : ShowListScummVMGamesDialog(self);
    1 : ShowTextViewerDialog(
          self,
          LanguageSetup.WizardFormMainInfo,
          LanguageSetup.WizardFormMainInfo1+#13+#13+LanguageSetup.WizardFormMainInfo2+#13+#13+LanguageSetup.WizardFormMainInfo3
        );
  end;
end;

end.
