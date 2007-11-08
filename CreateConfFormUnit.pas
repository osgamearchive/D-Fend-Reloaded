unit CreateConfFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, CheckLst, GameDBUnit;

type
  TCreateConfForm = class(TForm)
    InfoLabel: TLabel;
    ListBox: TCheckListBox;
    FolderEdit: TLabeledEdit;
    SelectFolderButton: TSpeedButton;
    SelectAllButton: TBitBtn;
    SelectNoneButton: TBitBtn;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure SelectFolderButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
  end;

var
  CreateConfForm: TCreateConfForm;

Function ExportConfFiles(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;

implementation

uses ShlObj, VistaToolsUnit, LanguageSetupUnit, DosBoxUnit, CommonTools,
     PrgSetupUnit;

{$R *.dfm}

procedure TCreateConfForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);

  Caption:=LanguageSetup.CreateConfForm;
  InfoLabel.Caption:=LanguageSetup.CreateConfFormInfo;
  FolderEdit.EditLabel.Caption:=LanguageSetup.CreateConfFormSelectFolder;
  SelectFolderButton.Hint:=LanguageSetup.ChooseFolder;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;

end;

procedure TCreateConfForm.FormShow(Sender: TObject);
Var I : Integer;
begin
  For I:=0 to GameDB.Count-1 do begin
    ListBox.Items.AddObject(GameDB[I].Name,GameDB[I]);
    ListBox.Checked[I]:=True;
  end;

  FolderEdit.Text:=GetSpecialFolder(Handle,CSIDL_DESKTOPDIRECTORY);
end;

procedure TCreateConfForm.SelectButtonClick(Sender: TObject);
Var I : Integer;
begin
  For I:=0 to ListBox.Count-1 do ListBox.Checked[I]:=((Sender as TComponent).Tag=0);
end;

procedure TCreateConfForm.SelectFolderButtonClick(Sender: TObject);
Var S : String;
begin
  S:=FolderEdit.Text; If S='' then S:=PrgDataDir;
  if SelectDirectory(Handle,LanguageSetup.SetupFormBaseDir,S) then FolderEdit.Text:=S;
end;

procedure TCreateConfForm.OKButtonClick(Sender: TObject);
Var I : Integer;
    G : TGame;
    Dir,S : String;
    St : TStringList;
begin
  Dir:=IncludeTrailingPathDelimiter(FolderEdit.Text);

  if not ForceDirectories(Dir) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[Dir]),mtError,[mbOK],0);
    ModalResult:=mrNone;
    exit;
  end;

  For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then begin
    G:=TGame(ListBox.Items.Objects[I]);
    St:=BuildConfFile(G,False);
    try
      S:=Dir+ChangeFileExt(ExtractFileName(G.SetupFile),'.conf');
      try St.SaveToFile(S); except
        MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[S]),mtError,[mbOK],0);
        ModalResult:=mrNone;
        exit;
      end;
    finally
      St.Free;
    end;
  end;
end;

{ global }

Function ExportConfFiles(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
begin
  CreateConfForm:=TCreateConfForm.Create(AOwner);
  try
    CreateConfForm.GameDB:=AGameDB;
    result:=(CreateConfForm.ShowModal=mrOK);
  finally
    CreateConfForm.Free;
  end;
end;


end.
