unit LinkFileEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids;

type
  TLinkFileEditForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    Tab: TStringGrid;
    InfoLabel: TLabel;
    AddButton: TBitBtn;
    DeleteButton: TBitBtn;
    MoveUpButton: TBitBtn;
    MoveDownButton: TBitBtn;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure TabClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Links : TStringList;
    AllowLines : Boolean;
  end;

var
  LinkFileEditForm: TLinkFileEditForm;

Function ShowLinkFileEditDialog(const AOwner : TComponent; const ALinks : TStringList; const AAllowLines : Boolean) : Boolean;

implementation

uses Math, LanguageSetupUnit, VistaToolsUnit, CommonTools, HelpConsts;

{$R *.dfm}

{ TLinkFileEditForm }

procedure TLinkFileEditForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.EditLinkCaption;
  AddButton.Caption:=LanguageSetup.Add;
  DeleteButton.Caption:=LanguageSetup.Del;
  MoveUpButton.Caption:=LanguageSetup.MoveUp;
  MoveDownButton.Caption:=LanguageSetup.MoveDown;
  Tab.Cells[0,0]:=LanguageSetup.EditLinkName;
  Tab.Cells[1,0]:=LanguageSetup.EditLinkLink;
  InfoLabel.Caption:=LanguageSetup.EditLinkInfo;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  Tab.ColWidths[0]:=(Tab.ClientWidth-5)*2 div 5;
  Tab.ColWidths[1]:=(Tab.ClientWidth-5)*3 div 5;
end;

procedure TLinkFileEditForm.FormShow(Sender: TObject);
Var I : Integer;
    S : String;
begin
  If not AllowLines then begin
    InfoLabel.Visible:=False;
    Tab.Height:=OKButton.Top-Tab.Top-8;
  end;

  Tab.RowCount:=Max(2,Links.Count+1);
  If Links.Count=0 then exit;
  For I:=0 to Links.Count-1 do begin
    S:=Trim(Links[I]);
    If (S<>'') and (Pos(';',S)>0) then begin
      Tab.Cells[0,I+1]:=Trim(Copy(S,1,Pos(';',S)-1));;
      Tab.Cells[1,I+1]:=Trim(Copy(S,Pos(';',S)+1,MaxInt));;
    end;
  end;
  TabClick(Sender);
end;

procedure TLinkFileEditForm.TabClick(Sender: TObject);
begin
  DeleteButton.Enabled:=(Tab.RowCount>2);
  MoveUpButton.Enabled:=(Tab.Row>1);
  MoveDownButton.Enabled:=(Tab.Row<Tab.RowCount-1);
end;

procedure TLinkFileEditForm.ButtonWork(Sender: TObject);
Var I,J : Integer;
    S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          Tab.RowCount:=Tab.RowCount+1;
          Tab.Col:=0;
          Tab.Row:=Tab.RowCount-1;
          TabClick(Sender);
        end;
    1 : begin
          For I:=Tab.Row+1 to Tab.RowCount-1 do begin
            Tab.Cells[0,I-1]:=Tab.Cells[0,I];
            Tab.Cells[1,I-1]:=Tab.Cells[1,I];
          end;
          I:=Tab.Row; J:=Tab.Col;
          Tab.RowCount:=Tab.RowCount-1;
          Tab.Row:=Max(1,I-1);
          Tab.Col:=J;
          TabClick(Sender);
        end;
    2 : begin
          I:=Tab.Row; J:=Tab.Col;
          S:=Tab.Cells[0,I]; Tab.Cells[0,I]:=Tab.Cells[0,I-1]; Tab.Cells[0,I-1]:=S;
          S:=Tab.Cells[1,I]; Tab.Cells[1,I]:=Tab.Cells[1,I-1]; Tab.Cells[1,I-1]:=S;
          Tab.Row:=I-1;
          Tab.Col:=J;
          TabClick(Sender);
        end;
    3 : begin
          I:=Tab.Row; J:=Tab.Col;
          S:=Tab.Cells[0,I]; Tab.Cells[0,I]:=Tab.Cells[0,I+1]; Tab.Cells[0,I+1]:=S;
          S:=Tab.Cells[1,I]; Tab.Cells[1,I]:=Tab.Cells[1,I+1]; Tab.Cells[1,I+1]:=S;
          Tab.Row:=I+1;
          Tab.Col:=J;
          TabClick(Sender);
        end;    
  end;
  Tab.SetFocus;
end;

procedure TLinkFileEditForm.OKButtonClick(Sender: TObject);
Var I : Integer;
begin
  Links.Clear;
  For I:=1 to Tab.RowCount-1 do If (Trim(Tab.Cells[0,I])='') and (Trim(Tab.Cells[1,I])='')
    then Links.Add('')
    else Links.Add(Trim(Tab.Cells[0,I])+';'+Trim(Tab.Cells[1,I]));
end;

procedure TLinkFileEditForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ProfileSearchGame);
end;

procedure TLinkFileEditForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowLinkFileEditDialog(const AOwner : TComponent; const ALinks : TStringList; const AAllowLines : Boolean) : Boolean;
begin
  LinkFileEditForm:=TLinkFileEditForm.Create(AOwner);
  try
    LinkFileEditForm.Links:=ALinks;
    LinkFileEditForm.AllowLines:=AAllowLines;
    result:=(LinkFileEditForm.ShowModal=mrOK);
  finally
    LinkFileEditForm.Free;
  end;

end;

end.
