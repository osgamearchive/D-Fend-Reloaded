unit ScanGamesFolderFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, GameDBUnit, ExtCtrls;

type
  TScanGamesFolderForm = class(TForm)
    Step1Label: TLabel;
    OpenFolderButton: TBitBtn;
    Step2Label: TLabel;
    ScanButton: TBitBtn;
    CloseButton: TBitBtn;
    ProgressBar: TProgressBar;
    DetectionTypeRadioGroupBox: TRadioGroup;
    HelpButton: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure OpenFolderButtonClick(Sender: TObject);
    procedure ScanButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private-Deklarationen }
    Function GetSubFolderList : TStringList;
    Function CheckFolder(const AutoSetupDB : TGameDB; const Folder : String; const AddAll : Boolean) : String;
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
    GamesAdded : Boolean;
  end;

var
  ScanGamesFolderForm: TScanGamesFolderForm;

Function ShowScanGamesFolderDialog(const AOwner : TComponent; const GameDB : TGameDB) : Boolean;

implementation

uses ShellAPI, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit,
     TextViewerFormUnit, PrgConsts, ZipPackageUnit, HelpConsts, IconLoaderUnit;

{$R *.dfm}

procedure TScanGamesFolderForm.FormShow(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.AutoDetectGames;
  Step1Label.Caption:=LanguageSetup.AutoDetectGameStep1;
  OpenFolderButton.Caption:=LanguageSetup.AutoDetectGamesOpenFolderButton;
  Step2Label.Caption:=LanguageSetup.AutoDetectGamesStep2;
  ScanButton.Caption:=LanguageSetup.AutoDetectGamesScanButton;
  DetectionTypeRadioGroupBox.Caption:=LanguageSetup.AutoDetectGamesDetectionType;
  DetectionTypeRadioGroupBox.Items[0]:=LanguageSetup.AutoDetectGamesDetectionTypeAutoSetupTemplatesOnly;
  DetectionTypeRadioGroupBox.Items[1]:=LanguageSetup.AutoDetectGamesDetectionTypeAll;
  CloseButton.Caption:=LanguageSetup.Close;
  HelpButton.Caption:=LanguageSetup.Help;

  UserIconLoader.DialogImage(DI_SelectFolder,OpenFolderButton);
  UserIconLoader.DialogImage(DI_Wizard,ScanButton);

  If PrgSetup.ScanFolderAllGames
    then DetectionTypeRadioGroupBox.ItemIndex:=1
    else DetectionTypeRadioGroupBox.ItemIndex:=0;

  GamesAdded:=False;
end;

procedure TScanGamesFolderForm.OpenFolderButtonClick(Sender: TObject);
Var S : String;
begin
  If PrgSetup.GameDir='' then S:=PrgSetup.BaseDir else S:=PrgSetup.GameDir;
  ShellExecute(Handle,'explore',PChar(S),nil,PChar(S),SW_SHOW);
end;

function TScanGamesFolderForm.GetSubFolderList: TStringList;
Var Rec : TSearchRec;
    I : Integer;
    S,T : String;
begin
  result:=TStringList.Create;

  T:=ExtUpperCase(ExcludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.PathToFREEDOS,PrgSetup.BaseDir)));

  If PrgSetup.GameDir='' then S:=PrgSetup.BaseDir else S:=PrgSetup.GameDir;
  S:=IncludeTrailingPathDelimiter(S);

  I:=FindFirst(S+'*.*',faDirectory,Rec);
  try
    While I=0 do begin
      If ((Rec.Attr and faDirectory)=faDirectory) and (Rec.Name<>'.') and (Rec.Name<>'..') and (ExtUpperCase(S+Rec.Name)<>T) then result.Add(S+Rec.Name);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

function TScanGamesFolderForm.CheckFolder(const AutoSetupDB : TGameDB; const Folder: String; const AddAll : Boolean): String;
Var I,J,TemplateNr : Integer;
    S,T,FileToStart : String;
    G : TGame;
    Rec : TSearchRec;
begin
  result:='';

  {Already known ?}
  T:=ExtUpperCase(Folder);
  For I:=0 to GameDB.Count-1 do begin
    S:=GameDB[I].GameExe;
    If (S<>'') and (ExtUpperCase(Copy(S,1,7))<>'DOSBOX:') then begin
      S:=ExtUpperCase(MakeAbsPath(S,PrgSetup.BaseDir));
      If Copy(S,1,length(T))=T then exit;
    end;
    S:=GameDB[I].SetupExe;
    If (S<>'') and (ExtUpperCase(Copy(S,1,7))<>'DOSBOX:') then begin
      S:=ExtUpperCase(MakeAbsPath(S,PrgSetup.BaseDir));
      If Copy(S,1,length(T))=T then exit;
    end;
  end;

  TemplateNr:=GetTemplateFromFolder(True,Folder,AutoSetupDB,FileToStart);
  If FileToStart='' then exit;

  If TemplateNr<0 then begin
    if not AddAll then exit;
    I:=GameDB.Add(ChangeFileExt(FileToStart,''));
    G:=TGame.Create(PrgSetup);
    try GameDB[I].AssignFrom(G); finally G.Free; end;
    GameDB[I].Name:=ChangeFileExt(FileToStart,'');
    result:=LanguageSetup.TemplateFormDefault+' ('+Folder+FileToStart+')';
  end else begin
    I:=GameDB.Add(AutoSetupDB[TemplateNr].CacheName);
    GameDB[I].AssignFrom(AutoSetupDB[TemplateNr]);
    result:=AutoSetupDB[TemplateNr].CacheName+' ('+Folder+FileToStart+')';
  end;

  GameDB[I].GameExe:=MakeRelPath(Folder+FileToStart,PrgSetup.BaseDir);

  GameDB[I].CaptureFolder:=IncludeTrailingPathDelimiter(PrgSetup.CaptureDir)+MakeFileSysOKFolderName(GameDB[I].Name)+'\';
  ForceDirectories(MakeAbsPath(GameDB[I].CaptureFolder,PrgSetup.BaseDir));

  {Look for Icons in game folder}
  J:=FindFirst(Folder+'*.ico',faAnyFile,Rec);
  try
    If J=0 then GameDB[I].Icon:=MakeRelPath(Folder+Rec.Name,PrgSetup.BaseDir);
  finally
    FindClose(Rec);
  end;

  GameDB[I].ProfileMode:='DOSBox';
  GameDB[I].StoreAllValues;
  GameDB[I].LoadCache;
end;

procedure TScanGamesFolderForm.ScanButtonClick(Sender: TObject);
Var Dirs,Games : TStringList;
    I : Integer;
    S : String;
    AutoSetupDB : TGameDB;
begin
  Enabled:=False;
  OpenFolderButton.Enabled:=False;
  ScanButton.Enabled:=False;
  DetectionTypeRadioGroupBox.Enabled:=False;
  CloseButton.Enabled:=False;
  with ProgressBar do begin Max:=100; Position:=0; Visible:=True; end;
  try
    Dirs:=GetSubFolderList;
    Games:=TStringList.Create;
    AutoSetupDB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir);
    try
      ProgressBar.Max:=Dirs.Count+1;
      ProgressBar.Position:=1;
      For I:=0 to Dirs.Count-1 do begin
        Application.ProcessMessages;
        S:=CheckFolder(AutoSetupDB,IncludeTrailingPathDelimiter(Dirs[I]),DetectionTypeRadioGroupBox.ItemIndex=1);
        If S<>'' then Games.Add(S);
        ProgressBar.StepIt;
      end;
      If Games.Count=0 then begin
        MessageDlg(LanguageSetup.AutoDetectGamesResultNoGames,mtInformation,[mbOK],0);
      end else begin
        S:=LanguageSetup.AutoDetectGamesResultGamesAdded+#13#13+Games.Text+#13+LanguageSetup.AutoDetectGamesResultGamesAddedTotal+' '+IntToStr(Games.Count);
        ShowTextViewerDialog(self,Caption,S);
        GamesAdded:=True;
      end;
    finally
      AutoSetupDB.Free;
      Dirs.Free;
      Games.Free;
    end;
  finally
    Enabled:=True;
    OpenFolderButton.Enabled:=True;
    ScanButton.Enabled:=True;
    DetectionTypeRadioGroupBox.Enabled:=True;
    CloseButton.Enabled:=True;
    ProgressBar.Visible:=False;
  end;
end;

procedure TScanGamesFolderForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ExtrasScanGamesFolder);
end;

procedure TScanGamesFolderForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PrgSetup.ScanFolderAllGames:=(DetectionTypeRadioGroupBox.ItemIndex=1);
end;

procedure TScanGamesFolderForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowScanGamesFolderDialog(const AOwner : TComponent; const GameDB : TGameDB) : Boolean;
begin
  ScanGamesFolderForm:=TScanGamesFolderForm.Create(AOwner);
  try
    ScanGamesFolderForm.GameDB:=GameDB;
    ScanGamesFolderForm.ShowModal;
    result:=ScanGamesFolderForm.GamesAdded;
  finally
    ScanGamesFolderForm.Free;
  end;
end;

end.
