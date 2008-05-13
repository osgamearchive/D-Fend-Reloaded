unit UninstallFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CheckLst, ExtCtrls, GameDBUnit;

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

Function DeleteSingleFile(const FileName: String; var ContinueNext : Boolean) : Boolean;
Function DeleteDir(const Dir: String; var ContinueNext : Boolean) : Boolean;
Function UsedByOtherGame(const GameDB : TGameDB; const Game : TGame; Dir: String): Boolean;
Function IconUsedByOtherGame(const GameDB : TGameDB; const Game : TGame; Icon: String): Boolean;
Function ExtraFileUsedByOtherGame(const GameDB : TGameDB; const Game : TGame; ExtraFile: String): Boolean;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit, PrgConsts,
     GameDBToolsUnit;

{$R *.dfm}

procedure TUninstallForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

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
    B : Boolean;
begin
  DirList:=TStringList.Create;

  ListBox.Items.Add(LanguageSetup.UninstallFormProfileRecord+': '+Game.Name);
  DirList.Add('');

  If ScummVMMode(Game) then begin
    S:=Trim(Game.ScummVMPath);
    If (S<>'') and (not UsedByOtherGame(GameDB,Game,IncludeTrailingPathDelimiter(S))) then begin
      S:=ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(S),PrgSetup.BaseDir));
      ListBox.Items.Add(LanguageSetup.UninstallFormProgramDir+': '+S);
      DirList.Add(S);
    end;
  end else begin
    S:=Trim(Game.GameExe);
    If ExtUpperCase(Copy(S,1,7))='DOSBOX:' then S:='';
    If S='' then S:=Trim(Game.SetupExe);
    If ExtUpperCase(Copy(S,1,7))='DOSBOX:' then S:='';
    S:=ExtractFilePath(MakeAbsPath(S,PrgSetup.BaseDir));
    If (S<>'') and (not UsedByOtherGame(GameDB,Game,S)) then begin
      ListBox.Items.Add(LanguageSetup.UninstallFormProgramDir+': '+S);
      DirList.Add(S);
    end;

    S:=Trim(Game.CaptureFolder);
    If (S<>'') and (not UsedByOtherGame(GameDB,Game,IncludeTrailingPathDelimiter(S))) then begin
      S:=ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(S),PrgSetup.BaseDir));
      ListBox.Items.Add(LanguageSetup.UninstallFormCaptureFolder+': '+S);
      DirList.Add(S);
    end;
  end;

  S:=MakeAbsIconName(Game.Icon);
  If (S<>'') and FileExists(S) and (not IconUsedByOtherGame(GameDB,Game,S)) then begin
    ListBox.Items.Add(LanguageSetup.UninstallFormIcon+': '+S);
    DirList.AddObject(S,TObject(1));
  end;

  S:=Trim(Game.DataDir);
  If (S<>'') and (not UsedByOtherGame(GameDB,Game,IncludeTrailingPathDelimiter(S))) then begin
    S:=ExtractFilePath(MakeAbsPath(IncludeTrailingPathDelimiter(S),PrgSetup.BaseDir));
    ListBox.Items.Add(LanguageSetup.UninstallFormDataDir+': '+S);
    DirList.Add(S);
  end;

  S:=Trim(Game.ExtraFiles);
  If S<>'' then begin
    St:=ValueToList(S);
    try
      For I:=0 to St.Count-1 do If (Trim(St[I])<>'') and (not ExtraFileUsedByOtherGame(GameDB,Game,St[I])) then begin
        S:=MakeAbsPath(St[I],PrgSetup.BaseDir);
        ListBox.Items.Add(LanguageSetup.UninstallFormExtraFile+': '+S);
        DirList.AddObject(S,TObject(1));
      end;
    finally
      St.Free;
    end;
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
    ContinueNext : Boolean;
begin
  SetCurrentDir(PrgDataDir);

  For I:=1 to ListBox.Count-1 do If ListBox.Checked[I] then begin
    If Integer(DirList.Objects[I])<>0 then begin
      If (not DeleteSingleFile(DirList[I],ContinueNext)) and (not ContinueNext) then exit;

    end else begin
      If (not DeleteDir(DirList[I],ContinueNext)) and (not ContinueNext) then exit;
    end;
  end;

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

Function DeleteSingleFile(const FileName: String; var ContinueNext : Boolean) : Boolean;
begin
  result:=False;
  repeat
    if not DeleteFile(FileName) then begin
      Case MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[FileName])+#13+#13+SysErrorMessage(GetLastError),mtError,[mbAbort,mbRetry,mbIgnore],0) of
        mrIgnore : begin ContinueNext:=True; exit; end;
        mrRetry : ;
        else exit;
      End;
    end else begin
      break;
    end;
  until False;
  result:=True;
end;


Function DeleteDir(const Dir: String; var ContinueNext : Boolean) : Boolean;
Var Rec : TSearchRec;
    I : Integer;
begin
  result:=False;
  ContinueNext:=False;

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
          if not DeleteDir(Dir+Rec.Name+'\',ContinueNext) then exit;
        end;
      end else begin
        if not DeleteSingleFile(Dir+Rec.Name,ContinueNext) then exit;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  repeat
    if not RemoveDir(Dir) then begin
      Case MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteDir,[Dir])+#13+#13+SysErrorMessage(GetLastError),mtError,[mbAbort,mbRetry,mbIgnore],0) of
        mrIgnore : begin ContinueNext:=True; exit; end;
        mrRetry : ;
        else exit;
      End;
    end else begin
      break;
    end;
  until False;

  result:=True;
  ContinueNext:=True;
end;

Function UsedByOtherGame(const GameDB : TGameDB; const Game : TGame; Dir: String): Boolean;
Function SameDir(S : String) : Boolean;
begin
  If Trim(S)='' then begin result:=False; exit; end;
  If ExtUpperCase(Copy(S,1,7))='DOSBOX:' then begin result:=False; exit; end;
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

    If ScummVMMode(GameDB[I]) then begin
      If SameDir(GameDB[I].ScummVMPath) then exit;
    end else begin
      If SameDir(GameDB[I].GameExe) then exit;
      If SameDir(GameDB[I].SetupExe) then exit;
      If SameDir(GameDB[I].CaptureFolder) then exit;
    end;
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

Function IconUsedByOtherGame(const GameDB : TGameDB; const Game : TGame; Icon: String): Boolean;
Var I : Integer;
    S : String;
begin
  result:=False;
  S:=Trim(ExtUpperCase(Icon));
  For I:=0 to GameDB.Count-1 do If GameDB[I]<>Game then
    If Trim(ExtUpperCase(MakeAbsIconName(GameDB[I].Icon)))=S then begin result:=True; exit; end;
end;

Function ExtraFileUsedByOtherGame(const GameDB : TGameDB; const Game : TGame; ExtraFile: String): Boolean;
Function SameFile(S : String) : Boolean;
begin
  result:=(Trim(S)<>'') and (Trim(ExtUpperCase(MakeAbsPath(S,PrgSetup.BaseDir)))=ExtraFile);
end;
Var I,J : Integer;
    St : TStringList;
begin
  result:=True;

  ExtraFile:=Trim(ExtUpperCase(MakeAbsPath(ExtraFile,PrgSetup.BaseDir)));
  For I:=0 to GameDB.Count-1 do begin
    If GameDB[I]=Game then continue;

    St:=ValueToList(GameDB[I].ExtraFiles);
    try
      For J:=0 to St.Count-1 do If SameFile(St[J]) then exit;
    finally
      St.Free;
    end;
  end;

  result:=False;
end;

end.
