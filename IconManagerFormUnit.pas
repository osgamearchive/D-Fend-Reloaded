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
    procedure FormCreate(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure ListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AddButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure ListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
  private
    { Private-Deklarationen }
    Dir, LastIcon : String;
    Procedure LoadIcons;
  public
    { Public-Deklarationen }
    IconName : String;
  end;

var
  IconManagerForm: TIconManagerForm;

Function ShowIconManager(const AOwner : TComponent; var AIcon : String; const NoCancel : Boolean = False) : Boolean;

implementation

uses LanguageSetupUnit, VistaToolsUnit, CommonTools, PrgConsts, PrgSetupUnit;

{$R *.dfm}

procedure TIconManagerForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);

  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  AddButton.Caption:=LanguageSetup.Add;
  DelButton.Caption:=LanguageSetup.Del;

  Dir:=IncludeTrailingPathDelimiter(PrgDataDir+IconsSubDir);
  LastIcon:=IconName;
  LoadIcons;
end;

procedure TIconManagerForm.LoadIcons;
Var I : Integer;
    Rec : TSearchRec;
    L : TListItem;
    Icon : TIcon;
    B : Boolean;
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

    For I:=0 to ListView.Items.Count-1 do If ListView.Items[I].Caption=LastIcon then begin
      ListView.ItemIndex:=I; break;
    end;

  finally
    ListView.Items.EndUpdate;
  end;
end;


procedure TIconManagerForm.OKButtonClick(Sender: TObject);
begin
  If ListView.ItemIndex>=0 then begin
    IconName:=ListView.Items[ListView.ItemIndex].Caption;
  end else begin
    IconName:='';
  end;
end;

procedure TIconManagerForm.ListViewChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  DelButton.Enabled:=(ListView.ItemIndex>=0);
end;

procedure TIconManagerForm.ListViewDblClick(Sender: TObject);
begin
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
begin
  OpenDialog.Title:=LanguageSetup.MenuExtrasIconManagerDialog;
  OpenDialog.Filter:=LanguageSetup.MenuExtrasIconManagerFilter;
  if not OpenDialog.Execute then exit;

  if not CopyFile(PChar(OpenDialog.FileName),PChar(Dir+ExtractFileName(OpenDialog.FileName)),True) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[OpenDialog.FileName,Dir+ExtractFileName(OpenDialog.FileName)]),mtError,[mbOK],0);
    exit;
  end;
  LastIcon:=ExtractFileName(OpenDialog.FileName);
  LoadIcons;
end;

procedure TIconManagerForm.DelButtonClick(Sender: TObject);
Var S : String;
begin
  If ListView.ItemIndex<0 then exit;

  S:=Dir+ListView.Items[ListView.ItemIndex].Caption;
  If not DeleteFile(S) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[S]),mtError,[mbOK],0);
    exit;
  end;

  ListView.Items.Delete(ListView.ItemIndex);
end;

{ global }

Function ShowIconManager(const AOwner : TComponent; var AIcon : String; const NoCancel : Boolean) : Boolean;
begin
  IconManagerForm:=TIconManagerForm.Create(AOwner);
  try
    IconManagerForm.IconName:=AIcon;
    If NoCancel then IconManagerForm.CancelButton.Visible:=False;
    result:=(IconManagerForm.ShowModal=mrOK);
    if result then AIcon:=IconManagerForm.IconName;
  finally
    IconManagerForm.Free;
  end;
end;

end.
