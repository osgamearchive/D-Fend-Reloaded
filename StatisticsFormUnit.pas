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
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  StatisticsForm: TStatisticsForm;

Procedure ShowInfoTextDialog(const AOwner : TComponent; const ACaption : String; const AText : TStringList);
Procedure ShowStatisticsDialog(const AOwner : TComponent; const AGameDB : TGameDB);

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit, PrgConsts;

{$R *.dfm}

procedure TStatisticsForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  OKButton.Caption:=LanguageSetup.OK;
end;

{ global }

Function GetNumberOfIcons: Integer;
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

Procedure BuildStatistics(const GameDB : TGameDB; const St : TStringList);
Var TemplateDB : TGameDB;
    St2 : TStringList;
    I,J,C : Integer;
    S : String;
begin
  St.Add('D-Fend Reloaded '+GetFileVersionAsString);
  St.Add('');

  St.Add(LanguageSetup.StatisticsNumberProfiles+': '+IntToStr(GameDB.Count));

  TemplateDB:=TGameDB.Create(PrgDataDir+TemplateSubDir);
  try
    St.Add(LanguageSetup.StatisticsNumberTemplates+': '+IntToStr(TemplateDB.Count));
  finally
    TemplateDB.Free;
  end;

  TemplateDB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir);
  try
    St.Add(LanguageSetup.StatisticsNumberAutoSetupTemplates+': '+IntToStr(TemplateDB.Count));
  finally
    TemplateDB.Free;
  end;

  St.Add(LanguageSetup.StatisticsNumberIcons+': '+IntToStr(GetNumberOfIcons));

  St.Add('');
  St.Add(LanguageSetup.StatisticsNumberProfilesByGenres+':');

  St2:=GameDB.GetGenreList(True);
  try
    For I:=0 to St2.Count-1 do begin
      C:=0; S:=ExtUpperCase(St2[I]);
      For J:=0 to GameDB.Count-1 do If ExtUpperCase(GameDB[J].CacheGenre)=S then inc(C);
      St.Add('  '
      +St2[I]+': '+IntToStr(C));
    end;
  finally
    St2.Free;
  end;
end;

Procedure ShowStatisticsDialog(const AOwner : TComponent; const AGameDB : TGameDB);
Var St : TStringList;
begin
  St:=TStringList.Create;
  try
    BuildStatistics(AGameDB,St);
    ShowInfoTextDialog(AOwner,LanguageSetup.StatisticsCaption,St);
  finally
    St.Free;
  end;
end;

Procedure ShowInfoTextDialog(const AOwner : TComponent; const ACaption : String; const AText : TStringList);
begin
  StatisticsForm:=TStatisticsForm.Create(AOwner);
  try
    StatisticsForm.Caption:=ACaption;
    StatisticsForm.Memo.Lines.AddStrings(AText);
    StatisticsForm.ShowModal;
  finally
    StatisticsForm.Free;
  end;
end;

end.
