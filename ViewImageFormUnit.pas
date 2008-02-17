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
    ToolButton1: TToolButton;
    BackgroundButton: TToolButton;
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

uses ClipBrd, VistaToolsUnit, LanguageSetupUnit, PNGImage, CommonTools,
     WallpaperStyleFormUnit;

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
  BackgroundButton.Caption:=LanguageSetup.ViewImageFormBackgroundButton;
end;

procedure TViewImageForm.FormShow(Sender: TObject);
begin
  Image.Picture:=LoadImageFromFile(ImageFile);
end;

procedure TViewImageForm.ButtonWork(Sender: TObject);
Var WPStype : TWallpaperStyle;
begin
  Case (Sender as TComponent).Tag of
    0 : Close;
    1 : Clipboard.Assign(Image.Picture);
    2 : begin
          SaveDialog.Title:=LanguageSetup.ViewImageFormSaveTitle;
          SaveDialog.Filter:=LanguageSetup.ViewImageFormSaveFilter;
          if not SaveDialog.Execute then exit;
          SaveImageToFile(Image.Picture,SaveDialog.FileName);
        end;
    3 : begin
          if not DeleteFile(ImageFile) then begin
            MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[ImageFile]),mtError,[mbOK],0);
            exit;
          end;
          Close;
        end;
    4 : begin
          If not ShowWallpaperStyleDialog(self,WPStype) then exit;
          SetDesktopWallpaper(ImageFile,WPStype);
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
