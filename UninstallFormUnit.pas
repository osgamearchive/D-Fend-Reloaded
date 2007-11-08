unit UninstallFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CheckLst, GameDBUnit, ExtCtrls;

type
  TUninstallForm = class(TForm)
    ListBox: TCheckListBox;
    Panel1: TPanel;
    InfoLabel: TLabel;
    Panel2: TPanel;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    SelectAllButton: TBitBtn;
    SelectNoneButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    DirList : TStringList;
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
    Game : TGame;
  end;

var
  UninstallForm: TUninstallForm;

Function UninstallGame(const AOwner : TComponent; const AGameDB : TGameDB; const AGame : TGame) : Boolean;

Function DeleteDir(const Dir: String) : Boolean;
Function UsedByOtherGame(const GameDB : TGameDB; const Game : TGame; Dir: String): Boolean;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit;

{$R *.dfm}

procedure TUninstallForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);

  Caption:=LanguageSetup.UninstallForm;
  InfoLabel.Caption:=LanguageSetup.UninstallFormLabel;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;

  DirList:=nil;
end;

procedure TUninstallForm.FormShow(Sender: TObject);
Var S : String;
    St : TStringList;
    I : Integer;
begin
  DirList:=TStringList.Create;

  ListBox.Items.Add(LanguageSetup.UninstallFormProfileRecord+': '+Game.Name);
  DirList.Add('');

  S:=Trim(Game.GameExe);
  If S='' then S:=Trim(Game.SetupExe);
  If (S<>'') and (not UsedByOtherGame(GameDB,Game,S)) then begin
    S:=ExtractFilePath(MakeAbsPath(S,PrgSetup.BaseDir));
    ListBox.Items.Add(LanguageSetup.UninstallFormProgramDir+': '+S);
    DirList.Add(S);
  end;

  S:=Trim(Game.CaptureFolder);
  If (S<>'') and (not UsedByOtherGame(GameDB,Game,IncludeTrailingPathDelimiter(S))) then begin
    S:=ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(S),PrgSetup.BaseDir));
    ListBox.Items.Add(LanguageSetup.UninstallFormCaptureFolder+': '+S);
    DirList.Add(S);
  end;

  S:=Trim(Game.DataDir);
  If (S<>'') and (not UsedByOtherGame(GameDB,Game,IncludeTrailingPathDelimiter(S))) then begin
    S:=ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(S),PrgSetup.BaseDir));
    ListBox.Items.Add(LanguageSetup.UninstallFormDataDir+': '+S);
    DirList.Add(S);
  end;

  S:=Trim(Game.ExtraDirs);
  If S<>'' then begin
    St:=ValueToList(S);
    try
      For I:=0 to St.Count-1 do If (Trim(St[I])<>'') and (not UsedByOtherGame(GameDB,Game,IncludeTrailingPathDelimiter(St[I]))) then begin
        S:=ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(St[I]),PrgSetup.BaseDir));
        ListBox.Items.Add(LanguageSetup.UninstallFormExtraDir+': '+S);
        DirList.Add(S);
      end;
    finally
      St.Free;
    end;
  end;

  For I:=0 to ListBox.Items.Count-1 do ListBox.Checked[I]:=True; 
end;

procedure TUninstallForm.OKButtonClick(Sender: TObject);
Var I : Integer;
begin
  For I:=1 to ListBox.Count-1 do If ListBox.Checked[I] then
    If not DeleteDir(DirList[I]) then exit;

  If ListBox.Checked[0] then GameDB.Delete(Game);
end;

procedure TUninstallForm.SelectButtonClick(Sender: TObject);
Var I : Integer;
begin
  For I:=0 to ListBox.Count-1 do ListBox.Checked[I]:=((Sender as TComponent).Tag=0);
end;

procedure TUninstallForm.FormDestroy(Sender: TObject);
begin
  DirList.Free;
end;

{ global }

Function UninstallGame(const AOwner : TComponent; const AGameDB : TGameDB; const AGame : TGame) : Boolean;
begin
  UninstallForm:=TUninstallForm.Create(AOwner);
  try
    UninstallForm.GameDB:=AGameDB;
    UninstallForm.Game:=AGame;
    result:=(UninstallForm.ShowModal=mrOK);
  finally
    UninstallForm.Free;
  end;
end;

Function DeleteDir(const Dir: String) : Boolean;
Var Rec : TSearchRec;
    I : Integer;
begin
  result:=False;

  If not DirectoryExists(Dir) then begin result:=True; exit; end;

  If PrgSetup.DeleteOnlyInBaseDir and (ExtUpperCase(Copy(Dir,1,length(PrgSetup.BaseDir)))<>ExtUpperCase(PrgSetup.BaseDir)) then begin
    MessageDlg(Format(LanguageSetup.MessageDeleteErrorProtection,[Dir]),mtError,[mbOk],0);
    exit;
  end;

  If Pos('..',Dir)<>0 then begin
    MessageDlg(Format(LanguageSetup.MessageDeleteErrorDotDotInPath,[Dir]),mtError,[mbOk],0);
    exit;
  end;

  I:=FindFirst(Dir+'*.*',faAnyFile,Rec);
  try
    while I=0 do begin
      if (Rec.Attr and faDirectory)=faDirectory then begin
        If Rec.Name[1]<>'.' then begin
          if not DeleteDir(Dir+Rec.Name+'\') then exit;
        end;
      end else begin
        if not DeleteFile(Dir+Rec.Name) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[Dir+Rec.Name]),mtError,[mbOK],0);
          exit;
        end;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  if not RemoveDir(Dir) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteDir,[Dir])+#13+#13+SysErrorMessage(GetLastError),mtError,[mbOK],0);
    exit;
  end;

  result:=True;
end;

Function UsedByOtherGame(const GameDB : TGameDB; const Game : TGame; Dir: String): Boolean;
Function SameDir(S : String) : Boolean;
begin
  If Trim(S)='' then begin result:=False; exit; end;
  S:=Trim(ExtUpperCase(ExtractFilePath(MakeAbsPath(S,PrgSetup.BaseDir))));
  result:=(Copy(S,1,length(Dir))=Dir);
end;
Var I,J : Integer;
    St : TStringList;
begin
  Dir:=Trim(ExtUpperCase(ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(Dir),PrgSetup.BaseDir))));

  result:=True;

  For I:=0 to GameDB.Count-1 do begin
    If GameDB[I]=Game then continue;

    If SameDir(GameDB[I].GameExe) then exit;
    If SameDir(GameDB[I].SetupExe) then exit;
    If SameDir(GameDB[I].CaptureFolder) then exit;
    If SameDir(GameDB[I].DataDir) then exit;

    St:=ValueToList(GameDB[I].ExtraDirs);
    try
      For J:=0 to St.Count-1 do If SameDir(St[J]) then exit;
    finally
      St.Free;
    end;
  end;

  result:=False;
end;

end.
