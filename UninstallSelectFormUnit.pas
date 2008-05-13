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
     PrgSetupUnit, PrgConsts, ProgressFormUnit, GameDBToolsUnit;

{$R *.dfm}

procedure TUninstallSelectForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

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
  SelectGenreButton.Caption:=LanguageSetup.GameBy;
end;

procedure TUninstallSelectForm.FormShow(Sender: TObject);
begin
  BuildCheckList(ListBox,GameDB,False,False);
  BuildSelectPopupMenu(PopupMenu,GameDB,SelectButtonClick,False);
end;

procedure TUninstallSelectForm.SelectButtonClick(Sender: TObject);
Var I : Integer;
    P : TPoint;
begin
  If Sender is TBitBtn then begin
    Case (Sender as TComponent).Tag of
      0,1 : For I:=0 to ListBox.Count-1 do ListBox.Checked[I]:=((Sender as TComponent).Tag=0);
        2 : begin
              P:=ClientToScreen(Point(SelectGenreButton.Left,SelectGenreButton.Top));
              PopupMenu.Popup(P.X+5,P.Y+5);
            end;
    end;
    exit;
  end;

  SelectGamesByPopupMenu(Sender,ListBox);
end;

procedure TUninstallSelectForm.OKButtonClick(Sender: TObject);
Var I,J : Integer;
    S : String;
    G : TGame;
    St : TStringList;
    ContinueNext : Boolean;
begin
  SetCurrentDir(PrgDataDir);
  
  J:=0; For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then inc(J);
  InitProgressWindow(self,J);
  try
    For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then begin
      G:=TGame(ListBox.Items.Objects[I]);

      StepProgressWindow;

      if ActionsRadioGroup.ItemIndex=3 then begin
        if not UninstallGame(self,GameDB,G) then exit;
        continue;
      end;

      If ActionsRadioGroup.ItemIndex>0 then begin
        If ScummVMMode(G) then begin
          S:=Trim(G.ScummVMPath);
          If (S<>'') and (not UsedByOtherGame(GameDB,G,IncludeTrailingPathDelimiter(S))) then begin
            S:=ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(S),PrgSetup.BaseDir));
            if (not DeleteDir(S,ContinueNext)) and (not ContinueNext) then exit;
          end;
        end else begin
          S:=Trim(G.GameExe);
          If ExtUpperCase(Copy(S,1,7))='DOSBOX:' then S:='';
          If S='' then S:=Trim(G.SetupExe);
          If ExtUpperCase(Copy(S,1,7))='DOSBOX:' then S:='';
          If S<>'' then S:=ExtractFilePath(S);
          If (S<>'') and (not UsedByOtherGame(GameDB,G,IncludeTrailingPathDelimiter(S))) then begin
            S:=ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(S),PrgSetup.BaseDir));
            if (not DeleteDir(S,ContinueNext)) and (not ContinueNext) then exit;
          end;
        end;
      end;

      If ActionsRadioGroup.ItemIndex>1 then begin
        If not ScummVMMode(G) then begin
          S:=Trim(G.CaptureFolder);
          If (S<>'') and (not UsedByOtherGame(GameDB,G,IncludeTrailingPathDelimiter(S))) then begin
            S:=ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(S),PrgSetup.BaseDir));
            if (not DeleteDir(S,ContinueNext)) and (not ContinueNext) then exit;
          end;
        end;

        S:=MakeAbsIconName(G.Icon);
        If (S<>'') and FileExists(S) and (not IconUsedByOtherGame(GameDB,G,S)) then begin
          If (not DeleteSingleFile(S,ContinueNext)) and (not ContinueNext) then exit;
        end;

        S:=Trim(G.DataDir);
        If (S<>'') and (not UsedByOtherGame(GameDB,G,IncludeTrailingPathDelimiter(S))) then begin
          S:=ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(S),PrgSetup.BaseDir));
          if (not DeleteDir(S,ContinueNext)) and (not ContinueNext) then exit;
        end;

        S:=Trim(G.ExtraFiles);
        If S<>'' then begin
          St:=ValueToList(S);
          try
            For J:=0 to St.Count-1 do If (Trim(St[J])<>'') and (not ExtraFileUsedByOtherGame(GameDB,G,St[J])) then begin
              S:=MakeAbsPath(St[J],PrgSetup.BaseDir);
              If not DeleteSingleFile(S,ContinueNext) and (not ContinueNext) then exit;
            end;
          finally
            St.Free;
          end;
        end;

        S:=Trim(G.ExtraDirs);
        If S<>'' then begin
          St:=ValueToList(S);
          try
            For J:=0 to St.Count-1 do If (Trim(St[J])<>'') and (not UsedByOtherGame(GameDB,G,IncludeTrailingPathDelimiter(St[J]))) then begin
              S:=ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(St[J]),PrgSetup.BaseDir));
              if (not DeleteDir(S,ContinueNext)) and (not ContinueNext) then exit;
            end;
          finally
            St.Free;
          end;
        end;
      end;

      GameDB.Delete(G);
    end;
  finally
    DoneProgressWindow;
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
