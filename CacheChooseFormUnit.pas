unit CacheChooseFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CheckLst, GameDBUnit;

type
  TCacheChooseForm = class(TForm)
    InfoLabel: TLabel;
    ProfileListBox: TCheckListBox;
    OKButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    ProfileList : TStringList;
    GameDB : TGameDB;
  end;

var
  CacheChooseForm: TCacheChooseForm;

Procedure ShowCacheChooseDialog(const AOwner : TComponent; const AProfileList : TStringList; const AGameDB : TGameDB);

implementation

uses VistaToolsUnit, LanguageSetupUnit;

{$R *.dfm}

procedure TCacheChooseForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);

  Caption:=LanguageSetup.CacheChooseCaption;
  InfoLabel.Caption:=LanguageSetup.CacheChooseInfo;
  OKButton.Caption:=LanguageSetup.OK;
end;

procedure TCacheChooseForm.FormShow(Sender: TObject);
Var I : Integer;
begin
  ProfileListBox.Items.AddStrings(ProfileList);
  For I:=0 to ProfileListBox.Items.Count-1 do ProfileListBox.Checked[I]:=True;
end;

procedure TCacheChooseForm.OKButtonClick(Sender: TObject);
Var I : Integer;
    G : TGame;
begin
  For I:=0 to ProfileListBox.Items.Count-1 do If ProfileListBox.Checked[I] then begin
    G:=TGame(ProfileListBox.Items.Objects[I]);
    G.ReloadINI;
    G.LoadCache;
  end;
end;

{ global }

Procedure ShowCacheChooseDialog(const AOwner : TComponent; const AProfileList : TStringList; const AGameDB : TGameDB);
begin
  CacheChooseForm:=TCacheChooseForm.Create(AOwner);
  try
    CacheChooseForm.ProfileList:=AProfileList;
    CacheChooseForm.GameDB:=AGameDB;
    CacheChooseForm.ShowModal;
  finally
    CacheChooseForm.Free;
  end;
end;

end.
