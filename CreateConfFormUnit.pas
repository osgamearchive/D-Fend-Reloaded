unit CreateConfFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, CheckLst, Menus, GameDBUnit;

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
    SelectGenreButton: TBitBtn;
    PopupMenu: TPopupMenu;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure SelectFolderButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
    ProfFileMode : Boolean;
  end;

var
  CreateConfForm: TCreateConfForm;

Function ExportConfFiles(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
Function ExportProfFiles(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;

implementation

uses ShlObj, VistaToolsUnit, LanguageSetupUnit, DosBoxUnit, CommonTools,
     PrgSetupUnit, GameDBToolsUnit, ScummVMUnit, HelpConsts;

{$R *.dfm}

procedure TCreateConfForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.CreateConfForm;
  InfoLabel.Caption:=LanguageSetup.CreateConfFormInfo;
  FolderEdit.EditLabel.Caption:=LanguageSetup.CreateConfFormSelectFolder;
  SelectFolderButton.Hint:=LanguageSetup.ChooseFolder;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;
  SelectGenreButton.Caption:=LanguageSetup.GameBy;

  ProfFileMode:=False;
end;

procedure TCreateConfForm.FormShow(Sender: TObject);
begin
  If ProfFileMode then Caption:=LanguageSetup.CreateConfFormProfMode;

  BuildCheckList(ListBox,GameDB,True,False,True);
  BuildSelectPopupMenu(PopupMenu,GameDB,SelectButtonClick,True);

  FolderEdit.Text:=GetSpecialFolder(Handle,CSIDL_DESKTOPDIRECTORY);
end;

procedure TCreateConfForm.SelectButtonClick(Sender: TObject);
Var I : Integer;
    P : TPoint;
begin
  If Sender is TBitBtn then begin
    Case (Sender as TComponent).Tag of
      0,1 : For I:=0 to ListBox.Count-1 do ListBox.Checked[I]:=((Sender as TComponent).Tag=0);
        2 : begin
              P:=ClientToScreen(Point(SelectGenreButton.Left,SelectGenreButton.Top));
              PopupMenu.Popup(P.X+5,P.Y+5);
            end;
    end;
    exit;
  end;

  SelectGamesByPopupMenu(Sender,ListBox);
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
    If ProfFileMode then begin
      G.StoreAllValues;
      If not CopyFile(PChar(G.SetupFile),PChar(Dir+ExtractFileName(G.SetupFile)),True) then begin
        MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[G.SetupFile,Dir+ExtractFileName(G.SetupFile)]),mtError,[mbOK],0);
        ModalResult:=mrNone;
        exit;
      end;
    end else begin
      If ScummVMMode(G) then begin
        S:=Dir+ChangeFileExt(ExtractFileName(G.SetupFile),'.ini');
        St:=BuildScummVMIniFile(G);
      end else begin
        S:=Dir+ChangeFileExt(ExtractFileName(G.SetupFile),'.conf');
        St:=BuildConfFile(G,False,False);
      end;
      try
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
end;

procedure TCreateConfForm.HelpButtonClick(Sender: TObject);
begin
  If ProfFileMode
    then Application.HelpCommand(HELP_CONTEXT,ID_FileExportProf)
    else Application.HelpCommand(HELP_CONTEXT,ID_FileExportConf);
end;

procedure TCreateConfForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
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

Function ExportProfFiles(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
begin
  CreateConfForm:=TCreateConfForm.Create(AOwner);
  try
    CreateConfForm.ProfFileMode:=True;
    CreateConfForm.GameDB:=AGameDB;
    result:=(CreateConfForm.ShowModal=mrOK);
  finally
    CreateConfForm.Free;
  end;
end;

end.
