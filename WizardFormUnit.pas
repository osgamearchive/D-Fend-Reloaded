unit WizardFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, Grids, ValEdit, ExtCtrls, GameDBUnit,
  WizardBaseUnit, WizardPrgFileUnit, WizardTemplateUnit, WizardGameInfoUnit,
  WizardFinishUnit, WizardScummVMUnit, WizardScummVMSettingsUnit, LinkFileUnit;

type
  TWizardForm = class(TForm)
    BottomPanel: TPanel;
    PreviousButton: TBitBtn;
    NextButton: TBitBtn;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure StepButtonWork(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    ActivePage : Integer;
    WizardBaseFrame : TWizardBaseFrame;
    WizardPrgFileFrame : TWizardPrgFileFrame;
    WizardTemplateFrame : TWizardTemplateFrame;
    WizardGameInfoFrame : TWizardGameInfoFrame;
    WizardFinishFrame : TWizardFinishFrame;
    WizardScummVMFrame : TWizardScummVMFrame;
    WizardScummVMSettingsFrame : TWizardScummVMSettingsFrame;
    UserGameInfo, InsecureTemplate : Boolean;
    ScummVM : Boolean;
    Procedure SetActivePage(NewPage : Integer);
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
    Game : TGame;
    ExeFile : String;
    OpenEditorNow : Boolean;
    LinkFile : TLinkFile;
  end;

var
  WizardForm: TWizardForm;

Function ShowWizardDialog(const AOwner : TComponent; const AGameDB : TGameDB; const AExeFile : String; var AGame : TGame; var OpenEditorNow : Boolean; const ASearchLinkFile : TLinkFile) : Boolean;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit,
     GameDBToolsUnit, DOSBoxUnit, HelpConsts;

{$R *.dfm}

procedure TWizardForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.WizardForm;
  PreviousButton.Caption:=LanguageSetup.WizardFormButtonPrevious;
  NextButton.Caption:=LanguageSetup.WizardFormButtonNext;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  
  ActivePage:=0;
  UserGameInfo:=True;
  InsecureTemplate:=False;
  OpenEditorNow:=False;
end;

procedure TWizardForm.FormShow(Sender: TObject);
begin
  WizardBaseFrame:=TWizardBaseFrame.Create(self); WizardBaseFrame.Parent:=self;
  with WizardBaseFrame do begin Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName); Align:=alClient; Visible:=False; Init(GameDB); end;

  WizardPrgFileFrame:=TWizardPrgFileFrame.Create(self); WizardPrgFileFrame.Parent:=self;
  with WizardPrgFileFrame do begin Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName); Align:=alClient; Visible:=False; Init(GameDB); end;

  WizardTemplateFrame:=TWizardTemplateFrame.Create(self); WizardTemplateFrame.Parent:=self;
  with WizardTemplateFrame do begin Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName); Align:=alClient; Visible:=False; Init(GameDB); end;

  WizardGameInfoFrame:=TWizardGameInfoFrame.Create(self); WizardGameInfoFrame.Parent:=self;
  with WizardGameInfoFrame do begin Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName); Align:=alClient; Visible:=False; Init(GameDB,LinkFile); end;

  WizardFinishFrame:=TWizardFinishFrame.Create(self); WizardFinishFrame.Parent:=self;
  with WizardFinishFrame do begin Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName); Align:=alClient; Visible:=False; Init(GameDB); end;

  WizardScummVMFrame:=TWizardScummVMFrame.Create(self); WizardScummVMFrame.Parent:=self;
  with WizardScummVMFrame do begin Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName); Align:=alClient; Visible:=False; Init(GameDB); end;

  WizardScummVMSettingsFrame:=TWizardScummVMSettingsFrame.Create(self); WizardScummVMSettingsFrame.Parent:=self;
  with WizardScummVMSettingsFrame do begin Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName); Align:=alClient; Visible:=False; Init(GameDB); end;

  WizardBaseFrame.TabOrder:=0;
  WizardPrgFileFrame.TabOrder:=1;
  WizardTemplateFrame.TabOrder:=2;
  WizardGameInfoFrame.TabOrder:=3;
  WizardFinishFrame.TabOrder:=4;
  WizardScummVMFrame.TabOrder:=5;
  WizardScummVMSettingsFrame.TabOrder:=6;
  BottomPanel.TabOrder:=7;

  If Trim(ExeFile)<>'' then
    WizardPrgFileFrame.ProgramEdit.Text:=MakeRelPath(ExeFile,PrgSetup.BaseDir);

  SetActivePage(0);
end;

procedure TWizardForm.FormHide(Sender: TObject);
begin
  WizardTemplateFrame.Done;
  WizardFinishFrame.Done;
end;

procedure TWizardForm.SetActivePage(NewPage: Integer);
Var S : String;
begin
  Case ActivePage of
    0 : begin
          {Start page}
          If (NewPage=1) and (Trim(WizardBaseFrame.BaseName.Text)='') then begin
            MessageDlg(LanguageSetup.MessageNoProfileName,mtError,[mbOK],0);
            exit;
          end;
          ScummVM:=(WizardBaseFrame.EmulationTypeRadioGroup.ItemIndex=1);
          If ScummVM then WizardScummVMFrame.ShowScummVMFrame;
        end;
    1 : If NewPage=2 then begin
          {Progam file page -> next page (template or ScummVM settings)}
          If not ScummVM then begin
            If Trim(WizardPrgFileFrame.ProgramEdit.Text)='' then begin
              If MessageDlg(LanguageSetup.MessageNoGameFileNameWarning,mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
            end;
            If Trim(WizardPrgFileFrame.ProgramEdit.Text)<>'' then begin
              S:=MakeAbsPath(WizardPrgFileFrame.ProgramEdit.Text,PrgSetup.BaseDir);
              If IsWindowsExe(S) then begin
                If MessageDlg(Format(LanguageSetup.MessageWindowsExeEditWarning,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
              end;
            end;
            If Trim(WizardPrgFileFrame.SetupEdit.Text)<>'' then begin
              S:=MakeAbsPath(WizardPrgFileFrame.SetupEdit.Text,PrgSetup.BaseDir);
              If IsWindowsExe(S) then begin
                If MessageDlg(Format(LanguageSetup.MessageWindowsExeEditWarning,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
              end;
            end;
            WizardTemplateFrame.SearchTemplates(WizardPrgFileFrame.ProgramEdit.Text);
          end else begin
            If Trim(WizardScummVMFrame.ProgramEdit.Text)='' then begin
              If MessageDlg(LanguageSetup.MessageNoGameFileNameWarning,mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
            end;
            WizardScummVMSettingsFrame.SetScummVMGameName(WizardScummVMFrame.GetScummVMGameName,WizardScummVMFrame.ProgramEdit.Text);
          end;
        end;
    2 : If NewPage=3 then begin
          If not ScummVM then begin
            {Template page -> game info page (or to mount page if UserGameInfo=False)}
            InsecureTemplate:=not WizardTemplateFrame.SelectedProfileSecure;
            if InsecureTemplate then begin
              If MessageDlg(LanguageSetup.MessageTemplateInsecureWarning,mtWarning,[mbYes,mbNo],0)<>mrYes then exit;
            end;
            UserGameInfo:=WizardTemplateFrame.TemplateType4.Checked or WizardTemplateFrame.TemplateType5.Checked;
          end else begin
            {ScummVM settings page -> game info page}
            UserGameInfo:=True; 
          end;
        end;
    3 : If NewPage=4 then begin
          {Game info page -> mount page}
          WizardFinishFrame.SetInsecureStatus(InsecureTemplate);
          WizardFinishFrame.LoadData(WizardTemplateFrame.GetTemplate,WizardPrgFileFrame.ProgramEdit.Text,WizardPrgFileFrame.SetupEdit.Text,WizardBaseFrame.BaseName.Text);
        end;
  end;

  If (NewPage=3) and (not UserGameInfo) and not ScummVM then begin
    {If auto setup template has been selected, do not show game info page}
    If ActivePage=4 then begin
      {directly go back to select template page}
      NewPage:=2
    end else begin
      {directly go forward to mount page}
      NewPage:=4;
      WizardFinishFrame.SetInsecureStatus(InsecureTemplate);
      WizardFinishFrame.LoadData(WizardTemplateFrame.GetTemplate,WizardPrgFileFrame.ProgramEdit.Text,WizardPrgFileFrame.SetupEdit.Text,WizardBaseFrame.BaseName.Text);
    end;
  end;

  If NewPage=3 then WizardGameInfoFrame.SetGameName(WizardBaseFrame.BaseName.Text);

  WizardBaseFrame.Visible:=(NewPage=0);
  WizardPrgFileFrame.Visible:=(NewPage=1) and (not ScummVM);
  WizardScummVMFrame.Visible:=(NewPage=1) and ScummVM;
  WizardTemplateFrame.Visible:=(NewPage=2) and (not ScummVM);
  WizardScummVMSettingsFrame.Visible:=(NewPage=2) and ScummVM;
  WizardGameInfoFrame.Visible:=(NewPage=3);
  WizardFinishFrame.Visible:=(NewPage=4);

  ActivePage:=NewPage;

  PreviousButton.Enabled:=(ActivePage>0);
  If ScummVM then begin
    NextButton.Enabled:=(ActivePage<3);
    OKButton.Enabled:=(ActivePage=3);
  end else begin
    NextButton.Enabled:=(ActivePage<4);
    OKButton.Enabled:=(ActivePage=4);
  end;
end;


procedure TWizardForm.StepButtonWork(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : SetActivePage(ActivePage-1);
    1 : SetActivePage(ActivePage+1);
  end;
end;

procedure TWizardForm.OKButtonClick(Sender: TObject);
begin
  If ScummVM
    then Game:=WizardScummVMSettingsFrame.CreateGame(WizardBaseFrame.BaseName.Text)
    else Game:=WizardTemplateFrame.CreateGame(WizardBaseFrame.BaseName.Text);
  WizardBaseFrame.WriteDataToGame(Game);
  If ScummVM
    then WizardScummVMFrame.WriteDataToGame(Game)
    else WizardPrgFileFrame.WriteDataToGame(Game);
  If UserGameInfo then WizardGameInfoFrame.WriteDataToGame(Game);
  WizardFinishFrame.WriteDataToGame(Game);
  OpenEditorNow:=WizardFinishFrame.ProfileEditorCheckBox.Checked;
  If not ScummVM then begin
    CreateGameCheckSum(Game,True);
    CreateSetupCheckSum(Game,True);
  end;
  Game.LoadCache;
  Game.StoreAllValues;
end;

procedure TWizardForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ProfileWithWizard);
end;

procedure TWizardForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowWizardDialog(const AOwner : TComponent; const AGameDB : TGameDB; const AExeFile : String; var AGame : TGame; var OpenEditorNow : Boolean; const ASearchLinkFile : TLinkFile) : Boolean;
begin
  WizardForm:=TWizardForm.Create(AOwner);
  try
    WizardForm.GameDB:=AGameDB;
    WizardForm.LinkFile:=ASearchLinkFile;
    WizardForm.ExeFile:=AExeFile;
    result:=(WizardForm.ShowModal=mrOK);
    if result then begin
      AGame:=WizardForm.Game;
      OpenEditorNow:=WizardForm.OpenEditorNow;
    end;
  finally
    WizardForm.Free;
  end;
end;

end.
