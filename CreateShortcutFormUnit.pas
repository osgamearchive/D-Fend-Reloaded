unit CreateShortcutFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TCreateShortcutForm = class(TForm)
    DesktopRadioButton: TRadioButton;
    StartmenuRadioButton: TRadioButton;
    StartmenuEdit: TEdit;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure StartmenuEditChange(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    GameName, GameFile : String;
  end;

var
  CreateShortcutForm: TCreateShortcutForm;

Function ShowCreateShortcutDialog(const AOwner : TComponent; const AGameName, AGameFileName : String) : Boolean;

implementation

uses ShlObj, VistaToolsUnit, LanguageSetupUnit, CommonTools;

{$R *.dfm}

procedure TCreateShortcutForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);

  Caption:=LanguageSetup.CreateShortcutForm;
  DesktopRadioButton.Caption:=LanguageSetup.CreateShortcutFormDesktop;
  StartmenuRadioButton.Caption:=LanguageSetup.CreateShortcutFormStartmenu;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
end;

procedure TCreateShortcutForm.OKButtonClick(Sender: TObject);
Var Dir : String;
begin
  If DesktopRadioButton.Checked then begin
    Dir:=IncludeTrailingPathDelimiter(GetSpecialFolder(Handle,CSIDL_DESKTOPDIRECTORY));
    CreateLink(ExpandFileName(Application.ExeName),GameName,Dir+GameFile+'.lnk');
  end else begin
    Dir:=IncludeTrailingPathDelimiter(GetSpecialFolder(Handle,CSIDL_PROGRAMS));
    Dir:=Dir+StartmenuEdit.Text+'\';
    if not ForceDirectories(Dir) then begin
      MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[Dir]),mtError,[mbOK],0);
      exit;
    end;
    CreateLink(ExpandFileName(Application.ExeName),GameName,Dir+GameFile+'.lnk');
  end;
end;

procedure TCreateShortcutForm.StartmenuEditChange(Sender: TObject);
begin
  StartmenuRadioButton.Checked:=True;
end;

{ global }

Function ShowCreateShortcutDialog(const AOwner : TComponent; const AGameName, AGameFileName : String) : Boolean;
begin
  CreateShortcutForm:=TCreateShortcutForm.Create(AOwner);
  try
    CreateShortcutForm.GameName:=AGameName;
    CreateShortcutForm.GameFile:=ChangeFileExt(ExtractFileName(AGameFileName),'');
    result:=(CreateShortcutForm.ShowModal=mrOK);
  finally
    CreateShortcutForm.Free;
  end;
end;

end.
