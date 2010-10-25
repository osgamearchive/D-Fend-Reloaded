unit SetupFrameDataPrivacyUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, SetupFormUnit;

type
  TSetupFrameDataPrivacy = class(TFrame, ISetupFrame)
    StoreHistoryCheckBox: TCheckBox;
    ShowHistoryButton: TBitBtn;
    DeleteHistoryButton: TBitBtn;
    procedure ShowHistoryButtonClick(Sender: TObject);
    procedure DeleteHistoryButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Function GetName : String;
    Procedure InitGUIAndLoadSetup(var InitData : TInitData);
    Procedure BeforeChangeLanguage;
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvencedMode : Boolean);
    procedure HideFrame;
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, HelpConsts,
     IconLoaderUnit, HistoryFormUnit, GameDBToolsUnit;

{$R *.dfm}

{ TSetupFrameDataPrivacy }

function TSetupFrameDataPrivacy.GetName: String;
begin
  result:=LanguageSetup.SetupFormDataPrivacy;
end;

procedure TSetupFrameDataPrivacy.InitGUIAndLoadSetup(var InitData: TInitData);
begin
  UserIconLoader.DirectLoad('Main',26,ShowHistoryButton);
  UserIconLoader.DialogImage(DI_Delete,DeleteHistoryButton);

  StoreHistoryCheckBox.Checked:=PrgSetup.StoreHistory;
end;

procedure TSetupFrameDataPrivacy.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameDataPrivacy.LoadLanguage;
begin
  NoFlicker(StoreHistoryCheckBox);

  StoreHistoryCheckBox.Caption:=LanguageSetup.SetupFormDataPrivacyStoreHistory;
  ShowHistoryButton.Caption:=LanguageSetup.SetupFormDataPrivacyShowHistory;
  DeleteHistoryButton.Caption:=LanguageSetup.SetupFormDataPrivacyDeleteHistory;

  HelpContext:=ID_FileOptionsDataPrivacy;
end;

procedure TSetupFrameDataPrivacy.DeleteHistoryButtonClick(Sender: TObject);
begin
  ClearHistory;
end;

procedure TSetupFrameDataPrivacy.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameDataPrivacy.ShowFrame(const AdvencedMode: Boolean);
begin
end;

procedure TSetupFrameDataPrivacy.ShowHistoryButtonClick(Sender: TObject);
begin
  ShowHistoryDialog(self);
end;

procedure TSetupFrameDataPrivacy.HideFrame;
begin
end;

procedure TSetupFrameDataPrivacy.RestoreDefaults;
begin
  StoreHistoryCheckBox.Checked:=True;
end;

procedure TSetupFrameDataPrivacy.SaveSetup;
begin
  PrgSetup.StoreHistory:=StoreHistoryCheckBox.Checked;
end;

end.