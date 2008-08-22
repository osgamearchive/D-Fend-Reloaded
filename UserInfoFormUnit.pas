unit UserInfoFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, ValEdit, ExtCtrls, GameDBUnit;

type
  TUserInfoForm = class(TForm)
    Panel1: TPanel;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    Tab: TStringGrid;
    DelButton: TSpeedButton;
    AddButton: TSpeedButton;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Game : TGame;
  end;

var
  UserInfoForm: TUserInfoForm;

Function ShowUserInfoDialog(const AOwner : TComponent; const AGame : TGame) : Boolean;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, HelpConsts;

{$R *.dfm}

procedure TUserInfoForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.ProfileEditorUserdefinedInfo;
  Tab.Cells[0,0]:=LanguageSetup.Key;
  Tab.Cells[1,0]:=LanguageSetup.Value;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  AddButton.Hint:=RemoveUnderline(LanguageSetup.Add);
  DelButton.Hint:=RemoveUnderline(LanguageSetup.Del);
end;

procedure TUserInfoForm.FormShow(Sender: TObject);
Var St : TStringList;
    I,J : Integer;
    S,T : String;
begin
  St:=StringToStringList(Game.UserInfo);
  try
    If St.Count=0 then exit;
    Tab.RowCount:=St.Count+1;
    For I:=0 to St.Count-1 do begin
      S:=St[I];
      J:=Pos('=',S);
      If J=0 then T:='' else begin T:=Trim(Copy(S,J+1,MaxInt)); S:=Trim(Copy(S,1,J-1)); end;
      Tab.Cells[0,I+1]:=S;
      Tab.Cells[1,I+1]:=T;
    end;
  finally
    St.Free;
  end;

  FormResize(Sender);
end;

procedure TUserInfoForm.FormResize(Sender: TObject);
begin
  Tab.ColWidths[0]:=(Tab.ClientWidth-10) div 2;
  Tab.ColWidths[1]:=(Tab.ClientWidth-10) div 2;
end;

procedure TUserInfoForm.AddButtonClick(Sender: TObject);
begin
  Tab.RowCount:=Tab.RowCount+1;
  Tab.Row:=Tab.RowCount-1;
end;

procedure TUserInfoForm.DelButtonClick(Sender: TObject);
Var I : Integer;
begin
  If Tab.RowCount=2 then begin
    Tab.Cells[0,1]:='';
    Tab.Cells[1,1]:='';
    exit;
  end;

  If Tab.Row<0 then begin
    MessageDlg(LanguageSetup.MessageNoRecordSelected,mtError,[mbOK],0);
    exit;
  end;

  For I:=Tab.Row+1 to Tab.RowCount-1 do begin
    Tab.Cells[0,I-1]:=Tab.Cells[0,I];
    Tab.Cells[1,I-1]:=Tab.Cells[1,I];
  end;
  Tab.RowCount:=Tab.RowCount-1;
end;

procedure TUserInfoForm.OKButtonClick(Sender: TObject);
Var St : TStringList;
    I : Integer;
    S,T : String;
begin
  St:=TStringList.Create;
  try
    For I:=1 to Tab.RowCount-1 do begin
      S:=Trim(Tab.Cells[0,I]); T:=Trim(Tab.Cells[1,I]);
      If (S<>'') or (T<>'') then St.Add(S+'='+T);
    end;
    If St.Count=0 then Game.UserInfo:='' else Game.UserInfo:=StringListToString(St);
  finally
    St.Free;
  end;
end;

procedure TUserInfoForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ProfileEditProgramInformation);
end;

procedure TUserInfoForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowUserInfoDialog(const AOwner : TComponent; const AGame : TGame) : Boolean;
begin
  UserInfoForm:=TUserInfoForm.Create(AOwner);
  try
    UserInfoForm.Game:=AGame;
    result:=(UserInfoForm.ShowModal=mrOK);
  finally
    UserInfoForm.Free;
  end;
end;

end.
