unit StatisticsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GameDBUnit, StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
  TStatisticsForm = class(TForm)
    Panel1: TPanel;
    Memo: TRichEdit;
    OKButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
    Function GetNumberOfIcons : Integer;
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
  end;

var
  StatisticsForm: TStatisticsForm;

Procedure ShowStatisticsDialog(const AOwner : TComponent; const AGameDB : TGameDB);

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit, PrgConsts;

{$R *.dfm}

procedure TStatisticsForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);

  Caption:=LanguageSetup.StatisticsCaption;
  OKButton.Caption:=LanguageSetup.OK;
end;

procedure TStatisticsForm.FormShow(Sender: TObject);
Var TemplateDB : TGameDB;
    St : TStringList;
    I,J,C : Integer;
    S : String;
begin
  Memo.Lines.Add('D-Fend Reloaded '+GetFileVersionAsString);
  Memo.Lines.Add('');

  Memo.Lines.Add(LanguageSetup.StatisticsNumberProfiles+': '+IntToStr(GameDB.Count));

  TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir);
  try
    Memo.Lines.Add(LanguageSetup.StatisticsNumberTemplates+': '+IntToStr(TemplateDB.Count));
  finally
    TemplateDB.Free;
  end;

  Memo.Lines.Add(LanguageSetup.StatisticsNumberIcons+': '+IntToStr(GetNumberOfIcons));

  Memo.Lines.Add('');
  Memo.Lines.Add(LanguageSetup.StatisticsNumberProfilesByGenres+':');

  St:=GameDB.GetGenreList(True);
  try
    For I:=0 to St.Count-1 do begin
      C:=0; S:=ExtUpperCase(St[I]);
      For J:=0 to GameDB.Count-1 do If ExtUpperCase(GameDB[J].CacheGenre)=S then inc(C);
      Memo.Lines.Add('  '
      +St[I]+': '+IntToStr(C));
    end;
  finally
    St.Free;
  end;
end;

function TStatisticsForm.GetNumberOfIcons: Integer;
Var Dir : String;
    I : Integer;
    Rec : TSearchRec;
begin
  result:=0;

  Dir:=IncludeTrailingPathDelimiter(PrgDataDir+IconsSubDir);
  if not DirectoryExists(Dir) then exit;

  I:=FindFirst(Dir+'*.ico',faAnyFile,Rec);
  try
    while I=0 do begin inc(result); I:=FindNext(Rec); end;
  finally
    FindClose(Rec);
  end;
end;

{ global }

Procedure ShowStatisticsDialog(const AOwner : TComponent; const AGameDB : TGameDB);
Var StatisticsForm : TStatisticsForm;
begin
  StatisticsForm:=TStatisticsForm.Create(AOwner);
  try
    StatisticsForm.GameDB:=AGameDB;
    StatisticsForm.ShowModal;
  finally
    StatisticsForm.Free;
  end;
end;

end.
