unit CreateShortcutFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, GameDBUnit, ExtCtrls;

type
  TCreateShortcutForm = class(TForm)
    DesktopRadioButton: TRadioButton;
    StartmenuRadioButton: TRadioButton;
    StartmenuEdit: TEdit;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    UseProfileIconCheckBox: TCheckBox;
    LinkNameEdit: TLabeledEdit;
    LinkCommentEdit: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure StartmenuEditChange(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    GameName, GameFile, GameIcon : String;
    GameScummVM : Boolean;
  end;

var
  CreateShortcutForm: TCreateShortcutForm;

Function ShowCreateShortcutDialog(const AOwner : TComponent; const AGameName, AGameFileName, AGameIconFile : String; const AGameScummVM : Boolean) : Boolean;
Function CreateLinuxShortCut(const AOwner : TComponent; const Game : TGame) : Boolean;

implementation

uses ShlObj, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit,
     PrgConsts, GameDBToolsUnit, DosBoxUnit;

{$R *.dfm}

procedure TCreateShortcutForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.CreateShortcutForm;
  DesktopRadioButton.Caption:=LanguageSetup.CreateShortcutFormDesktop;
  StartmenuRadioButton.Caption:=LanguageSetup.CreateShortcutFormStartmenu;
  UseProfileIconCheckBox.Caption:=LanguageSetup.CreateShortcutFormUseProfileIcon;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
end;

procedure TCreateShortcutForm.FormShow(Sender: TObject);
begin
  UseProfileIconCheckBox.Enabled:=(GameIcon<>'') and FileExists(MakeAbsIconName(GameIcon));
  UseProfileIconCheckBox.Checked:=UseProfileIconCheckBox.Enabled;

  LinkNameEdit.Text:=GameName;
  LinkCommentEdit.Text:=Format('Run %s in DOSBox',[GameName]); {or "ScummVM", see GameScummVM field}
end;

procedure TCreateShortcutForm.OKButtonClick(Sender: TObject);
Var Dir,Icon,FileName : String;
begin
  If UseProfileIconCheckBox.Checked then Icon:=MakeAbsIconName(GameIcon) else Icon:='';

  If DesktopRadioButton.Checked then begin
    Dir:=IncludeTrailingPathDelimiter(GetSpecialFolder(Handle,CSIDL_DESKTOPDIRECTORY));
    FileName:=Dir+MakeFileSysOKFolderName(GameFile)+'.lnk';
    CreateLink(ExpandFileName(Application.ExeName),GameName,FileName,Icon,LinkCommentEdit.Text);
  end else begin
    Dir:=IncludeTrailingPathDelimiter(GetSpecialFolder(Handle,CSIDL_PROGRAMS));
    Dir:=Dir+StartmenuEdit.Text+'\';
    FileName:=Dir+MakeFileSysOKFolderName(GameFile)+'.lnk';
    if not ForceDirectories(Dir) then begin
      MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[Dir]),mtError,[mbOK],0);
      exit;
    end;
    CreateLink(ExpandFileName(Application.ExeName),GameName,FileName,Icon,LinkCommentEdit.Text);
  end;
end;

procedure TCreateShortcutForm.StartmenuEditChange(Sender: TObject);
begin
  StartmenuRadioButton.Checked:=True;
end;

{ global }

Function ShowCreateShortcutDialog(const AOwner : TComponent; const AGameName, AGameFileName, AGameIconFile : String; const AGameScummVM : Boolean) : Boolean;
begin
  CreateShortcutForm:=TCreateShortcutForm.Create(AOwner);
  try
    CreateShortcutForm.GameName:=AGameName;
    CreateShortcutForm.GameFile:=ChangeFileExt(ExtractFileName(AGameFileName),'');
    CreateShortcutForm.GameIcon:=AGameIconFile;
    CreateShortcutForm.GameScummVM:=AGameScummVM;
    result:=(CreateShortcutForm.ShowModal=mrOK);
  finally
    CreateShortcutForm.Free;
  end;
end;

Function CreateLinuxShortCut(const AOwner : TComponent; const Game : TGame) : Boolean;
Var SaveDialog : TSaveDialog;
    St,St2 : TStringList;
    ConfFile,S : String;
begin
  result:=False;

  If ScummVMMode(Game) then begin
    MessageDlg(LanguageSetup.CreateShortcutFormNoLinuxScummVMLinks,mtError,[mbOK],0);
    exit;
  end;

  SaveDialog:=TSaveDialog.Create(AOwner);
  try
    SaveDialog.Filter:=LanguageSetup.CreateShortcutFormFilter;
    SaveDialog.Title:=LanguageSetup.CreateShortcutForm;
    If not SaveDialog.Execute then exit;
    ConfFile:=IncludeTrailingPathDelimiter(ExtractFilePath(SaveDialog.FileName))+ExtractFileName(MakeAbsPath(ChangeFileExt(Game.SetupFile,'.conf'),PrgSetup.BaseDir));
    St:=TStringList.Create;
    try
      St2:=BuildConfFile(Game,False,False);
      try
        try
          St2.SaveToFile(ConfFile);
        except
          MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[ConfFile]),mtError,[mbOK],0); exit;
        end;
      finally
        St2.Free;
      end;
      If Trim(PrgSetup.LinuxShellScriptPreamble)<>'' then St.Add(PrgSetup.LinuxShellScriptPreamble);
      If (Trim(Game.CustomDOSBoxDir)<>'') and (Trim(ExtUpperCase(Game.CustomDOSBoxDir))<>'DEFAULT') then S:=Game.CustomDOSBoxDir else S:=PrgSetup.DosBoxDir;
      St.Add({UnmapDrive(IncludeTrailingPathDelimiter(S)+DosBoxFileName,ptDOSBox)+}'dosbox -conf '+UnmapDrive(ConfFile,ptDOSBox));
      try
        St.SaveToFile(SaveDialog.FileName);
      except
        MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[SaveDialog.FileName]),mtError,[mbOK],0);
      end;
    finally
      St.Free;
    end;
  finally
    SaveDialog.Free;
  end;
end;

end.
