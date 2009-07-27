unit WizardBaseUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ComCtrls, Buttons, Grids, ValEdit, ExtCtrls,
  GameDBUnit;

type
  TWizardBaseFrame = class(TFrame)
    InfoLabel: TLabel;
    Bevel: TBevel;
    EmulationTypeRadioGroup: TRadioGroup;
    ListScummGamesButton: TBitBtn;
    ShowInfoButton: TBitBtn;
    WizardModeRadioGroup: TRadioGroup;
    procedure ButtonWork(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Destructor Destroy; override;
    Procedure Init(const GameDB : TGameDB);
    Procedure WriteDataToGame(const Game : TGame);
  end;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgConsts,
     PrgSetupUnit, ListScummVMGamesFormUnit, TextViewerFormUnit, IconLoaderUnit;

{$R *.dfm}

{ TWizardBaseFrame }

Destructor TWizardBaseFrame.Destroy;
begin
  PrgSetup.LastWizardMode:=WizardModeRadioGroup.ItemIndex;
  inherited Destroy;
end;

procedure TWizardBaseFrame.Init(const GameDB : TGameDB);
begin
  SetVistaFonts(self);

  InfoLabel.Font.Style:=[fsBold];
  InfoLabel.Caption:=LanguageSetup.WizardFormPage1Info;
  EmulationTypeRadioGroup.Caption:=LanguageSetup.WizardFormEmulationType;
  EmulationTypeRadioGroup.Items[0]:=LanguageSetup.WizardFormEmulationTypeDOSBox;
  EmulationTypeRadioGroup.Items[1]:=LanguageSetup.WizardFormEmulationTypeScummVM;
  EmulationTypeRadioGroup.Items[2]:=LanguageSetup.WizardFormEmulationTypeWindows;
  ListScummGamesButton.Caption:=LanguageSetup.WizardFormEmulationTypeListScummVMGames;
  ShowInfoButton.Caption:=LanguageSetup.WizardFormMainInfo;
  WizardModeRadioGroup.Caption:=LanguageSetup.WizardFormWizardMode;
  WizardModeRadioGroup.Items[0]:=LanguageSetup.WizardFormWizardModeAlwaysAutomatically;
  WizardModeRadioGroup.Items[1]:=LanguageSetup.WizardFormWizardModeAutomaticallyIfAutoSetupTemplateExists;
  WizardModeRadioGroup.Items[2]:=LanguageSetup.WizardFormWizardModeAlwaysAllPages;

  If Trim(PrgSetup.ScummVMPath)='' then EmulationTypeRadioGroup.Items.Delete(1);
  ListScummGamesButton.Visible:=(Trim(PrgSetup.ScummVMPath)<>'');
  If not ListScummGamesButton.Visible then begin
    ShowInfoButton.Top:=ListScummGamesButton.Top;
  end;

  WizardModeRadioGroup.ItemIndex:=Max(0,Min(2,PrgSetup.LastWizardMode));

  UserIconLoader.DialogImage(DI_Table,ListScummGamesButton);
  UserIconLoader.DialogImage(DI_Help,ShowInfoButton);
end;

procedure TWizardBaseFrame.WriteDataToGame(const Game: TGame);
Var S : String;
    I : Integer;
begin
  If EmulationTypeRadioGroup.ItemIndex=0 then begin
    S:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(Game.Name)+'\';
    I:=0;
    While (not PrgSetup.IgnoreDirectoryCollisions) and DirectoryExists(MakeAbsPath(S,PrgSetup.BaseDir)) do begin
      Inc(I);
      S:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(Game.Name)+IntToStr(I)+'\';
    end;
    Game.CaptureFolder:=MakeRelPath(S,PrgSetup.BaseDir);
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
