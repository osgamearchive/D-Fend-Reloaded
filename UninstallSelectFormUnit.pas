unit UninstallSelectFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CheckLst, ExtCtrls, GameDBUnit, Menus;

type
  TUninstallSelectForm = class(TForm)
    ActionsRadioGroup: TRadioGroup;
    InfoLabel: TLabel;
    ListBox: TCheckListBox;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    SelectAllButton: TBitBtn;
    SelectNoneButton: TBitBtn;
    SelectGenreButton: TBitBtn;
    PopupMenu: TPopupMenu;
    MenuSelect: TMenuItem;
    MenuUnselect: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
  end;

var
  UninstallSelectForm: TUninstallSelectForm;

Function UninstallMultipleGames(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;

implementation

uses VistaToolsUnit, LanguageSetupUnit, UninstallFormUnit, CommonTools,
     PrgSetupUnit, PrgConsts;

{$R *.dfm}

procedure TUninstallSelectForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);

  Caption:=LanguageSetup.UninstallSelectForm;
  InfoLabel.Caption:=LanguageSetup.UninstallSelectFormInfo;
  ActionsRadioGroup.Caption:=LanguageSetup.UninstallSelectFormActions;
  ActionsRadioGroup.Items[0]:=LanguageSetup.UninstallSelectFormActionDeleteRecord;
  ActionsRadioGroup.Items[1]:=LanguageSetup.UninstallSelectFormActionDeleteProgramDir;
  ActionsRadioGroup.Items[2]:=LanguageSetup.UninstallSelectFormActionDeleteAllData;
  ActionsRadioGroup.Items[3]:=LanguageSetup.UninstallSelectFormActionAsk;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;
  SelectGenreButton.Caption:=LanguageSetup.GameByGenre;
  MenuSelect.Caption:=LanguageSetup.Select;
  MenuUnselect.Caption:=LanguageSetup.Unselect;
end;

procedure TUninstallSelectForm.FormShow(Sender: TObject);
Var I : Integer;
    St : TStringList;
    M : TMenuItem;
begin
  St:=TStringList.Create;
  try
    For I:=0 to GameDB.Count-1 do If GameDB[I].Name<>DosBoxDOSProfile then St.AddObject(GameDB[I].Name,GameDB[I]);
    St.Sort;
    ListBox.Items.Assign(St);
    For I:=0 to ListBox.Items.Count-1 do ListBox.Checked[I]:=True;
  finally
    St.Free;
  end;

  St:=GameDB.GetGenreList;
  try
    For I:=0 to St.Count-1 do begin
      M:=TMenuItem.Create(self);
      M.Caption:=St[I];
      M.Tag:=3;
      M.OnClick:=SelectButtonClick;
      MenuSelect.Add(M);
      M:=TMenuItem.Create(self);
      M.Caption:=St[I];
      M.Tag:=4;
      M.OnClick:=SelectButtonClick;
      MenuUnselect.Add(M);
    end;
  finally
    St.Free;
  end;
end;

procedure TUninstallSelectForm.SelectButtonClick(Sender: TObject);
Var I : Integer;
    P : TPoint;
begin
  Case (Sender as TComponent).Tag of
    0,1 : For I:=0 to ListBox.Count-1 do ListBox.Checked[I]:=((Sender as TComponent).Tag=0);
      2 : begin
            P:=ClientToScreen(Point(SelectGenreButton.Left,SelectGenreButton.Top));
            PopupMenu.Popup(P.X+5,P.Y+5);
          end;
    3,4 : For I:=0 to ListBox.Items.Count-1 do begin
            If ((RemoveUnderline(TMenuItem(Sender).Caption)=LanguageSetup.NotSet) and (TGame(ListBox.Items.Objects[I]).Genre=''))
            or (RemoveUnderline(TMenuItem(Sender).Caption)=TGame(ListBox.Items.Objects[I]).Genre) then ListBox.Checked[I]:=((Sender as TComponent).Tag=3);
          end;
  end;
end;

procedure TUninstallSelectForm.OKButtonClick(Sender: TObject);
Var I,J : Integer;
    S : String;
    G : TGame;
    St : TStringList;
begin
  For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then begin
    G:=TGame(ListBox.Items.Objects[I]);

    if ActionsRadioGroup.ItemIndex=3 then begin
      if not UninstallGame(self,GameDB,G) then exit;
      continue;
    end;

    If ActionsRadioGroup.ItemIndex>0 then begin
      S:=Trim(G.GameExe);
      If S='' then S:=Trim(G.SetupExe);
      If (S<>'') and (not UsedByOtherGame(GameDB,G,S)) then begin
        S:=ExtractFilePath(MakeAbsPath(S,PrgSetup.BaseDir));
        if not DeleteDir(S) then exit;
      end;
    end;

    If ActionsRadioGroup.ItemIndex>1 then begin
      S:=Trim( G.CaptureFolder);
      If (S<>'') and (not UsedByOtherGame(GameDB,G,IncludeTrailingPathDelimiter(S))) then begin
        S:=ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(S),PrgSetup.BaseDir));
        if not DeleteDir(S) then exit;
      end;

      S:=Trim(G.DataDir);
      If (S<>'') and (not UsedByOtherGame(GameDB,G,IncludeTrailingPathDelimiter(S))) then begin
        S:=ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(S),PrgSetup.BaseDir));
        if not DeleteDir(S) then exit;
      end;

      S:=Trim(G.ExtraDirs);
      If S<>'' then begin
        St:=ValueToList(S);
        try
          For J:=0 to St.Count-1 do If (Trim(St[J])<>'') and (not UsedByOtherGame(GameDB,G,IncludeTrailingPathDelimiter(St[J]))) then begin
            S:=ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(St[J]),PrgSetup.BaseDir));
            if not DeleteDir(S) then exit;
          end;
        finally
          St.Free;
        end;
      end;
    end;

    GameDB.Delete(G);
  end;
end;

{ global }

Function UninstallMultipleGames(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
begin
  UninstallSelectForm:=TUninstallSelectForm.Create(AOwner);
  try
    UninstallSelectForm.GameDB:=AGameDB;
    result:=(UninstallSelectForm.ShowModal=mrOK);
  finally
    UninstallSelectForm.Free;
  end;
end;

end.
