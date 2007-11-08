unit ViewImageFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, ExtCtrls;

type
  TViewImageForm = class(TForm)
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    CloseButton: TToolButton;
    ToolButton2: TToolButton;
    CopyButton: TToolButton;
    SaveButton: TToolButton;
    ClearButton: TToolButton;
    ImageList: TImageList;
    Image: TImage;
    SaveDialog: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    ImageFile : String;
  end;

var
  ViewImageForm: TViewImageForm;

Procedure ShowImageDialog(const AOwner : TComponent; const AImageFile : String);

implementation

uses ClipBrd, VistaToolsUnit, LanguageSetupUnit, PNGImage;

{$R *.dfm}

procedure TViewImageForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  DoubleBuffered:=True;

  Caption:=LanguageSetup.ViewImageForm;
  CloseButton.Caption:=LanguageSetup.Close;
  CopyButton.Caption:=LanguageSetup.Copy;
  SaveButton.Caption:=LanguageSetup.Save;
  ClearButton.Caption:=LanguageSetup.Clear;
end;

procedure TViewImageForm.FormShow(Sender: TObject);
begin
  Image.Picture.LoadFromFile(ImageFile);
end;

procedure TViewImageForm.ButtonWork(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : Close;
    1 : Clipboard.Assign(Image.Picture);
    2 : begin
          SaveDialog.Title:=LanguageSetup.ViewImageFormSaveTitle;
          SaveDialog.Filter:=LanguageSetup.ViewImageFormSaveFilter;
          if not SaveDialog.Execute then exit;
          Image.Picture.SaveToFile(SaveDialog.FileName);
        end;
    3 : begin
          if not DeleteFile(ImageFile) then begin
            MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[ImageFile]),mtError,[mbOK],0);
            exit;
          end;
          Close;
        end;
  end;
end;

{ global }

Procedure ShowImageDialog(const AOwner : TComponent; const AImageFile : String);
begin
  ViewImageForm:=TViewImageForm.Create(AOwner);
  try
    ViewImageForm.ImageFile:=AImageFile;
    ViewImageForm.ShowModal;
  finally
    ViewImageForm.Free;
  end;
end;

end.
