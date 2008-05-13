unit ViewImageFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, ExtCtrls, Menus;

type
  TViewImageForm = class(TForm)
    CoolBar: TCoolBar;
    ToolBar: TToolBar;
    ToolButton2: TToolButton;
    CopyButton: TToolButton;
    SaveButton: TToolButton;
    ClearButton: TToolButton;
    ImageList: TImageList;
    Image: TImage;
    SaveDialog: TSaveDialog;
    ToolButton1: TToolButton;
    BackgroundButton: TToolButton;
    PreviousButton: TToolButton;
    NextButton: TToolButton;
    StatusBar: TStatusBar;
    ZoomButton: TToolButton;
    ZoomPopupMenu: TPopupMenu;
    ZoomMenuItem1: TMenuItem;
    ZoomMenuItem2: TMenuItem;
    ZoomMenuItem3: TMenuItem;
    ZoomMenuItem4: TMenuItem;
    ZoomMenuItem5: TMenuItem;
    ZoomMenuItem6: TMenuItem;
    ZoomMenuItem7: TMenuItem;
    ZoomMenuItem8: TMenuItem;
    ZoomMenuItem9: TMenuItem;
    ZoomMenuItem10: TMenuItem;
    ZoomMenuItem11: TMenuItem;
    ZoomMenuItem12: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormResize(Sender: TObject);
  private
    { Private-Deklarationen }
    Procedure CenterWindow;
  public
    { Public-Deklarationen }
    ImageFile : String;
    PrevImages, NextImages : TStringList;
  end;

var
  ViewImageForm: TViewImageForm;

Procedure ShowImageDialog(const AOwner : TComponent; const AImageFile : String; const APrevImages, ANextImages : TStringList);

implementation

uses Math, ClipBrd, VistaToolsUnit, LanguageSetupUnit, PNGImage, CommonTools,
     WallpaperStyleFormUnit, PrgSetupUnit;

{$R *.dfm}

procedure TViewImageForm.CenterWindow;
Var P : TForm;
begin
  P:=(Owner as TForm);

  Left:=(P.Left+P.Width div 2)-Width div 2;
  Top:=(P.Top+P.Height div 2)-Height div 2;
end;

procedure TViewImageForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  DoubleBuffered:=True;

  Caption:=LanguageSetup.ViewImageForm;
  PreviousButton.Caption:=LanguageSetup.Previous;
  NextButton.Caption:=LanguageSetup.Next;
  CopyButton.Caption:=LanguageSetup.Copy;
  SaveButton.Caption:=LanguageSetup.Save;
  ClearButton.Caption:=LanguageSetup.Clear;
  {ZoomButton.Caption:=LanguageSetup.ViewImageFormZoomButton;}
  BackgroundButton.Caption:=LanguageSetup.ViewImageFormBackgroundButton;

  PrevImages:=TStringList.Create;
  NextImages:=TStringList.Create;
end;

procedure TViewImageForm.FormShow(Sender: TObject);
begin
  PreviousButton.Enabled:=(PrevImages.Count>0);
  NextButton.Enabled:=(NextImages.Count>0);

  Image.Picture:=LoadImageFromFile(ImageFile);
  Caption:=LanguageSetup.ViewImageForm+' ['+MakeRelPath(ImageFile,PrgSetup.BaseDir)+']';

  ClientHeight:=Min(Max(100,Image.Picture.Height+(ClientHeight-Image.Height)),Screen.WorkAreaHeight-10);
  ClientWidth:=Min(Max(850,Image.Picture.Width),Screen.WorkAreaWidth-10);
  CenterWindow;
end;

procedure TViewImageForm.ButtonWork(Sender: TObject);
Var WPStype : TWallpaperStyle;
    S : String;
    F : Double;
begin
  Case (Sender as TComponent).Tag of
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
    5 : If PrevImages.Count>0 then begin
          NextImages.Insert(0,ImageFile);
          ImageFile:=PrevImages[PrevImages.Count-1];
          PrevImages.Delete(PrevImages.Count-1);
          FormShow(Sender);
        end;
    6 : if NextImages.Count>0 then begin
          PrevImages.Add(ImageFile);
          ImageFile:=NextImages[0];
          NextImages.Delete(0);
          FormShow(Sender);
        end;
    7 : begin
          If WindowState=wsMaximized then WindowState:=wsNormal;
          S:=RemoveUnderline((Sender as TMenuItem).Caption);
          F:=StrToInt(Copy(S,1,length(S)-1))/100;
          ClientHeight:=Min(Max(100,Round(F*Image.Picture.Height)+(ClientHeight-Image.Height)),Screen.WorkAreaHeight-10);
          ClientWidth:=Min(Max(850,Round(F*Image.Picture.Width)),Screen.WorkAreaWidth-10);
          CenterWindow;
        end;
  end;
end;

procedure TViewImageForm.FormDestroy(Sender: TObject);
begin
  PrevImages.Free;
  NextImages.Free;
end;

procedure TViewImageForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Shift<>[] then exit;
  Case Key of
    VK_LEFT, VK_UP, VK_PRIOR : ButtonWork(PreviousButton);
    VK_RIGHT, VK_DOWN, VK_NEXT : ButtonWork(NextButton);
  end;
end;

procedure TViewImageForm.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  If WheelDelta>0 then ButtonWork(PreviousButton) else ButtonWork(NextButton);
end;

procedure TViewImageForm.FormResize(Sender: TObject);
Var I,J : Integer;
begin
  StatusBar.Panels[0].Text:=IntToStr(Image.Picture.Width)+'x'+IntToStr(Image.Picture.Height);

  I:=Round(Image.ClientWidth/Image.Picture.Width*100);
  J:=Round(Image.ClientHeight/Image.Picture.Height*100);
  I:=Min(I,J);

  StatusBar.Panels[1].Text:=IntToStr(I)+'%';

  StatusBar.Panels[2].Text:=ImageFile;
end;

{ global }

Procedure ShowImageDialog(const AOwner : TComponent; const AImageFile : String; const APrevImages, ANextImages : TStringList);
begin
  ViewImageForm:=TViewImageForm.Create(AOwner);
  try
    ViewImageForm.ImageFile:=AImageFile;
    If APrevImages<>nil then ViewImageForm.PrevImages.Assign(APrevImages);
    If ANextImages<>nil then ViewImageForm.NextImages.Assign(ANextImages);
    ViewImageForm.ShowModal;
  finally
    ViewImageForm.Free;
  end;
end;

end.
