unit ExtraExeEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, ValEdit;

type
  TExtraExeEditForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    List: TValueListEditor;
    InfoLabel: TLabel;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure ListEditButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    ExeFiles : TStringList;
    WindowsMode : Boolean;
    GameExe, SetupExe : String;
  end;

var
  ExtraExeEditForm: TExtraExeEditForm;

Function ShowExtraExeEditDialog(const AOwner : TComponent; const AExeFiles : TStringList; const AWindowsMode : Boolean; const AGameExe, AGameSetup : String) : Boolean;

implementation

uses Math, LanguageSetupUnit, CommonTools, VistaToolsUnit, PrgSetupUnit,
     HelpConsts, IconLoaderUnit, GameDBToolsUnit;

{$R *.dfm}

{ TExtraExeEditForm }

procedure TExtraExeEditForm.FormCreate(Sender: TObject);
Var I : Integer;
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.ExtraExeEditCaption;
  List.TitleCaptions[0]:=LanguageSetup.ExtraExeEditDescription;
  List.TitleCaptions[1]:=LanguageSetup.ExtraExeEditFileName;
  For I:=0 to 9 do begin
    List.Strings.Add(' =');
    List.ItemProps[List.Strings.Count-1].EditStyle:=esEllipsis;
  end;
  InfoLabel.Caption:=LanguageSetup.ExtraExeEditInfo;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  WindowsMode:=False;
  GameExe:='';
  SetupExe:='';
end;

procedure TExtraExeEditForm.FormShow(Sender: TObject);
Var I,J,K : Integer;
    S : String;
begin
  J:=0;
  For I:=0 to Min(9,ExeFiles.Count-1) do begin
    S:=Trim(ExeFiles[I]);
    If S<>'' then begin
      K:=Pos(';',S);
      If K>0 then List.Strings[J]:=Copy(S,1,K-1)+'='+Copy(S,K+1,MaxInt); inc(J); end;
  end;
end;

procedure TExtraExeEditForm.ListEditButtonClick(Sender: TObject);
Var S : String;
begin
  S:=MakeAbsPath(List.Strings.ValueFromIndex[List.Row-1],PrgSetup.BaseDir);
  If SelectProgramFile(S,GameExe,SetupExe,WindowsMode,self) then List.Strings.ValueFromIndex[List.Row-1]:=S;
end;

procedure TExtraExeEditForm.OKButtonClick(Sender: TObject);
Var I,J : Integer;
    S : String;
begin
  ExeFiles.Clear;
  For I:=0 to List.Strings.Count-1 do begin
    S:=Trim(List.Strings[I]);
    If (S<>'') and (S<>'=') then begin
      J:=Pos('=',S);
      If J>0 then ExeFiles.Add(Copy(S,1,J-1)+';'+Copy(S,J+1,MaxInt));
    end;
  end;
end;

procedure TExtraExeEditForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ProfileEditProfile);
end;

procedure TExtraExeEditForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowExtraExeEditDialog(const AOwner : TComponent; const AExeFiles : TStringList; const AWindowsMode : Boolean; const AGameExe, AGameSetup : String) : Boolean;
begin
  ExtraExeEditForm:=TExtraExeEditForm.Create(AOwner);
  try
    ExtraExeEditForm.ExeFiles:=AExeFiles;
    ExtraExeEditForm.WindowsMode:=AWindowsMode;
    ExtraExeEditForm.GameExe:=AGameExe;
    ExtraExeEditForm.SetupExe:=AGameSetup;
    result:=(ExtraExeEditForm.ShowModal=mrOK);
  finally
    ExtraExeEditForm.Free;
  end;
end;

end.
