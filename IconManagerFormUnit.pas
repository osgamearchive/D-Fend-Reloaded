unit IconManagerFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ImgList;

type
  TIconManagerForm = class(TForm)
    ListView: TListView;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    AddButton: TBitBtn;
    DelButton: TBitBtn;
    ImageList: TImageList;
    OpenDialog: TOpenDialog;
    LibraryIconRadioButton: TRadioButton;
    CustomIconRadioButton: TRadioButton;
    CustomIconEdit: TEdit;
    CustomIconButton: TSpeedButton;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AddButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure ListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure CustomIconEditChange(Sender: TObject);
    procedure CustomIconButtonClick(Sender: TObject);
    procedure ListViewClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    Dir, LastIcon : String;
    Procedure LoadIcons;
  public
    { Public-Deklarationen }
    IconName : String;
    DefaultCustomIconFolder : String;
  end;

var
  IconManagerForm: TIconManagerForm;

Function ShowIconManager(const AOwner : TComponent; var AIcon : String; const ADefaultCustomIconFolder : String; const NoCancel : Boolean = False) : Boolean;

implementation

uses LanguageSetupUnit, VistaToolsUnit, CommonTools, PrgConsts, PrgSetupUnit,
     HelpConsts, IconLoaderUnit;

{$R *.dfm}

procedure TIconManagerForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.MenuExtrasIconManagerCaption;
  LibraryIconRadioButton.Caption:=LanguageSetup.MenuExtrasIconManagerIconLibrary;
  CustomIconRadioButton.Caption:=LanguageSetup.MenuExtrasIconManagerIconCustom;
  CustomIconButton.Hint:=LanguageSetup.ChooseFile;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  AddButton.Caption:=LanguageSetup.Add;
  DelButton.Caption:=LanguageSetup.Del;

  OpenDialog.Title:=LanguageSetup.MenuExtrasIconManagerDialog;
  OpenDialog.Filter:=LanguageSetup.MenuExtrasIconManagerFilter;

  Dir:=IncludeTrailingPathDelimiter(PrgDataDir+IconsSubDir);

  UserIconLoader.DialogImage(DI_SelectFile,CustomIconButton);
end;

procedure TIconManagerForm.FormShow(Sender: TObject);
begin
  LastIcon:=IconName;
  LoadIcons;
end;

procedure TIconManagerForm.LoadIcons;
Var I : Integer;
    Rec : TSearchRec;
    L : TListItem;
    Icon : TIcon;
    B : Boolean;
    S : String;
begin
  ForceDirectories(Dir);

  ListView.Items.BeginUpdate;
  try
    ListView.Items.Clear;
    ImageList.Clear;

    I:=FindFirst(Dir+'*.ico',faAnyFile,Rec);
    try
      while I=0 do begin
        Icon:=TIcon.Create;
        try
          B:=True; try Icon.LoadFromFile(Dir+Rec.Name); except B:=False; end;
          If B then ImageList.AddIcon(Icon);
        finally
          Icon.Free;
        end;
        If B then begin
          ListView.AddItem(Rec.Name,nil);
          L:=ListView.Items[ListView.Items.Count-1];
          L.ImageIndex:=ImageList.Count-1;
        end;
        I:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;

    If ExtractFilePath(Trim(LastIcon))='' then begin
      S:=ExtUpperCase(LastIcon);
      LibraryIconRadioButton.Checked:=True;
      For I:=0 to ListView.Items.Count-1 do If ExtUpperCase(ListView.Items[I].Caption)=S then begin
        ListView.ItemIndex:=I; break;
      end;
    end else begin
      CustomIconRadioButton.Checked:=True;
      CustomIconEdit.Text:=LastIcon;
    end;

  finally
    ListView.Items.EndUpdate;
  end;
end;


procedure TIconManagerForm.OKButtonClick(Sender: TObject);
begin
  If LibraryIconRadioButton.Checked then begin
    If ListView.ItemIndex>=0 then begin
      IconName:=ListView.Items[ListView.ItemIndex].Caption;
    end else begin
      IconName:='';
    end;
  end else begin
    IconName:=CustomIconEdit.Text;
  end;
end;

procedure TIconManagerForm.ListViewChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  DelButton.Enabled:=(ListView.ItemIndex>=0);
end;

procedure TIconManagerForm.ListViewDblClick(Sender: TObject);
begin
  LibraryIconRadioButton.Checked:=True;
  OKButton.Click;
end;

procedure TIconManagerForm.ListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Shift<>[] then exit;
  Case Key of
    VK_INSERT : AddButtonClick(Sender);
    VK_RETURN : ListViewDblClick(Sender);
    VK_DELETE : DelButtonClick(Sender);
  end;
end;

procedure TIconManagerForm.AddButtonClick(Sender: TObject);
Var S : String;
begin
  S:=ExtractFilePath(MakeAbsIconName(Trim(CustomIconEdit.Text)));
  If S='' then S:=DefaultCustomIconFolder;
  If S='' then S:=PrgSetup.BaseDir;
  If S<>'' then OpenDialog.InitialDir:=S;
  if not OpenDialog.Execute then exit;

  if not CopyFile(PChar(OpenDialog.FileName),PChar(Dir+ExtractFileName(OpenDialog.FileName)),True) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[OpenDialog.FileName,Dir+ExtractFileName(OpenDialog.FileName)]),mtError,[mbOK],0);
    exit;
  end;
  LastIcon:=ExtractFileName(OpenDialog.FileName);
  LoadIcons;
end;

procedure TIconManagerForm.ListViewClick(Sender: TObject);
begin
  LibraryIconRadioButton.Checked:=True;
end;

procedure TIconManagerForm.CustomIconEditChange(Sender: TObject);
begin
  CustomIconRadioButton.Checked:=True;
end;

procedure TIconManagerForm.CustomIconButtonClick(Sender: TObject);
Var S : String;
begin
  S:=ExtractFilePath(MakeAbsIconName(Trim(CustomIconEdit.Text)));
  If S='' then S:=DefaultCustomIconFolder;
  If S='' then S:=PrgSetup.BaseDir;
  If S<>'' then OpenDialog.InitialDir:=S;
  if not OpenDialog.Execute then exit;
  CustomIconEdit.Text:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
  CustomIconRadioButton.Checked:=True;
end;

procedure TIconManagerForm.DelButtonClick(Sender: TObject);
Var S : String;
begin
  If ListView.ItemIndex<0 then exit;

  S:=Dir+ListView.Items[ListView.ItemIndex].Caption;
  If not ExtDeleteFile(S,ftProfile) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[S]),mtError,[mbOK],0);
    exit;
  end;

  ListView.Items.Delete(ListView.ItemIndex);
end;

procedure TIconManagerForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ExtrasManageIcons);
end;

procedure TIconManagerForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowIconManager(const AOwner : TComponent; var AIcon : String; const ADefaultCustomIconFolder : String; const NoCancel : Boolean) : Boolean;
begin
  IconManagerForm:=TIconManagerForm.Create(AOwner);
  try
    IconManagerForm.IconName:=AIcon;
    IconManagerForm.DefaultCustomIconFolder:=ADefaultCustomIconFolder;
    If NoCancel then begin
      IconManagerForm.CancelButton.Visible:=False;
      IconManagerForm.LibraryIconRadioButton.Visible:=False;
      IconManagerForm.CustomIconRadioButton.Visible:=False;
      IconManagerForm.CustomIconEdit.Visible:=False;
      IconManagerForm.CustomIconButton.Visible:=False;
      IconManagerForm.ListView.Height:=IconManagerForm.OKButton.Top-10;
    end;
    result:=(IconManagerForm.ShowModal=mrOK);
    if result then AIcon:=IconManagerForm.IconName;
  finally
    IconManagerForm.Free;
  end;
end;

end.
