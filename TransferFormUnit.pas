unit TransferFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, CheckLst, ExtCtrls, GameDBUnit, PrgSetupUnit,
  Menus;

type
  TTransferForm = class(TForm)
    InfoLabel: TLabel;
    ListBox: TCheckListBox;
    SelectAllButton: TBitBtn;
    SelectNoneButton: TBitBtn;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    DestPrgDirEdit: TLabeledEdit;
    DestPrgDirButton: TSpeedButton;
    SelectGenreButton: TBitBtn;
    PopupMenu: TPopupMenu;
    CopyDFRCheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure DestPrgDirButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    Function CopyInstallation(const DestPrgDir : String) : Boolean;
    Function GetOperationMode(var OpMode : TOperationMode) : Boolean;
    Function GetDestPrgDataDir(const OpMode : TOperationMode; var DestPrgDataDir : String) : Boolean;
    Function CopyDir(const SourceDir, DestDir : String) : Boolean;
    function CopyFiles(const RelDir, SourceBaseDir, DestBaseDir, GameName: String): Boolean;
    Function TransferGame(const Game : TGame; const DestDataDir : String) : Boolean;
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
  end;

var
  TransferForm: TTransferForm;

Function TransferGames(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;

implementation

uses ShlObj, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgConsts,
     ProgressFormUnit, GameDBToolsUnit, SmallWaitFormUnit;

{$R *.dfm}

procedure TTransferForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.TransferForm;
  InfoLabel.Caption:=LanguageSetup.TransferFormInfo;
  DestPrgDirEdit.EditLabel.Caption:=LanguageSetup.TransferFormDestPrgDir;
  DestPrgDirButton.Hint:=LanguageSetup.ChooseFolder;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;
  SelectGenreButton.Caption:=LanguageSetup.GameBy;
  CopyDFRCheckBox.Caption:=LanguageSetup.TransferFormCopyDFendReloadedPrgFiles;
end;

procedure TTransferForm.FormShow(Sender: TObject);
begin
  BuildCheckList(ListBox,GameDB,False,False);
  BuildSelectPopupMenu(PopupMenu,GameDB,SelectButtonClick,False);
end;

procedure TTransferForm.SelectButtonClick(Sender: TObject);
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

procedure TTransferForm.DestPrgDirButtonClick(Sender: TObject);
Var S : String;
begin
  S:=DestPrgDirEdit.Text;
  if SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then DestPrgDirEdit.Text:=S;
end;

Function TTransferForm.CopyInstallation(const DestPrgDir : String) : Boolean;
Var St : TStringList;
    I : Integer;
    S : String;
    NewSetup : TPrgSetup;
    NewGameDB : TGameDB;
    OperationModeSave : TOperationMode;
begin
  result:=False;

  LoadAndShowSmallWaitForm(LanguageSetup.TransferFormCopyDFendReloadedPrgFilesWait);
  try

    {Create destination folder}

    If not ForceDirectories(DestPrgDir) then begin
      MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[DestPrgDir]),mtError,[mbOK],0);
      exit;
    end;

    {Transfer program files}

    St:=TStringList.Create;
    try
      St.Add(ExtractFileName(Application.ExeName));
      St.Add(MakeDOSFilesystemFileName);
      St.Add(OggEncPrgFile);
      St.Add('License.txt');
      St.Add('LicenseComponents.txt');
      St.Add('Links.txt');
      St.Add('ChangeLog.txt');
      St.Add('FAQs.txt');
      St.Add('Readme_OperationMode.txt');
      St.Add('D-Fend Reloaded DataInstaller.nsi');
      St.Add('UpdateCheck.exe');
      St.Add('SetInstallerLanguage.exe');
      For I:=0 to St.Count-1 do CopyFile(PChar(PrgDir+St[I]),PChar(DestPrgDir+St[I]),False);
    finally
      St.Free;
    end;
    If not CopyDir(IncludeTrailingPathDelimiter(PrgDir+LanguageSubDir),IncludeTrailingPathDelimiter(DestPrgDir+LanguageSubDir)) then exit;

    {Transfer settings}

    St:=TStringList.Create;
    try
      St.Add(ConfOptFile);
      St.Add(MainSetupFile);
      St.Add('Icons.ini');
      St.Add(ScummVMConfOptFile);
      For I:=0 to St.Count-1 do CopyFile(PChar(PrgDataDir+St[I]),PChar(DestPrgDir+St[I]),False);
    finally
      St.Free;
    end;

    St:=TStringList.Create;
    try
      St.Add('PORTABLEMODE');
      try St.SaveToFile(DestPrgDir+OperationModeConfig); except
        MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[DestPrgDir+OperationModeConfig]),mtError,[mbOK],0);
        exit;
      end;
    finally
      St.Free;
    end;

    St:=TStringList.Create;
    try
      St.Add(IconsSubDir);
      St.Add(GameListSubDir);
      St.Add('VirtualHD');
      For I:=0 to St.Count-1 do If not ForceDirectories(DestPrgDir+St[I]) then begin
        MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[DestPrgDir+St[I]]),mtError,[mbOK],0);
        exit;
      end;
    finally
      St.Free;
    end;

    St:=TStringList.Create;
    try
      St.Add(AutoSetupSubDir);
      St.Add(LanguageSubDir);
      St.Add(TemplateSubDir);
      For I:=0 to St.Count-1 do If not CopyDir(IncludeTrailingPathDelimiter(PrgDataDir+St[I]),IncludeTrailingPathDelimiter(DestPrgDir+St[I])) then exit;
    finally
      St.Free;
    end;

    {Transfer tools}

    St:=TStringList.Create;
    try
      St.Add('FREEDOS');
      St.Add('DOSZIP');
      For I:=0 to St.Count-1 do begin
        S:='';
        If DirectoryExists(PrgDir+NewUserDataSubDir+'\'+St[I]) then S:=PrgDir+NewUserDataSubDir+'\'+St[I] else begin
          If DirectoryExists(IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir))+St[I]) then S:=IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir))+St[I];
        end;
        If S<>'' then begin
          If not CopyDir(IncludeTrailingPathDelimiter(S),DestPrgDir+'VirtualHD\'+St[I]+'\') then exit;
        end;
      end;
    finally
      St.Free;
    end;

    {Transfer DOSBox}

    If not CopyDir(IncludeTrailingPathDelimiter(PrgSetup.DosBoxDir),IncludeTrailingPathDelimiter(DestPrgDir+'DOSBox')) then exit;
    If Trim(PrgSetup.DosBoxMapperFile)<>'' then
      CopyFile(PChar(MakeAbsPath(PrgSetup.DosBoxMapperFile,PrgSetup.BaseDir)),PChar(IncludeTrailingPathDelimiter(DestPrgDir+'DOSBox')+ExtractFileName(PrgSetup.DosBoxMapperFile)),False);

    {Change DFend.ini}

    OperationModeSave:=OperationMode;
    try
      NewSetup:=TPrgSetup.Create(DestPrgDir+MainSetupFile);
      try
        NewSetup.BaseDir:=DestPrgDir;
        NewSetup.GameDir:=DestPrgDir+'VirtualHD';
        NewSetup.DataDir:=DestPrgDir+'GameData';
        NewSetup.DosBoxDir:=DestPrgDir+'DOSBox';
        NewSetup.DosBoxLanguage:=DestPrgDir+'DOSBox\'+ExtractFileName(PrgSetup.DosBoxLanguage);
        NewSetup.DosBoxMapperFile:='./'+ExtractFileName(PrgSetup.DosBoxMapperFile);
        NewSetup.PathToFREEDOS:='.\VirtualHD\FREEDOS\';
        If FileExists(DestPrgDir+OggEncPrgFile) then NewSetup.WaveEncOgg:='.\'+OggEncPrgFile;

        S:=MakeRelPath(PrgSetup.QBasic,PrgSetup.BaseDir);
        If Copy(S,1,2)='.\' then NewSetup.QBasic:=MakeAbsPath(S,DestPrgDir);

        TempPrgDir:=DestPrgDir;

        NewSetup.StoreAllValues;
      finally
        NewSetup.Free;
      end;
    finally
      OperationMode:=OperationModeSave;
      TempPrgDir:='';
    end;

    { Build "DOSBox DOS" profile }

    NewGameDB:=TGameDB.Create(DestPrgDir+GameListSubDir);
    try
      BuildDefaultDosProfile(NewGameDB,False);
    finally
      NewGameDB.Free;
    end;

    St:=TStringList.Create;
    try
      St.Add('IconLibrary');
      St.Add('Capture');
      For I:=0 to St.Count-1 do begin
        S:='';
        If DirectoryExists(PrgDir+NewUserDataSubDir+'\'+St[I]) then S:=PrgDir+NewUserDataSubDir+'\'+St[I];
        If S<>'' then begin
          If not CopyDir(IncludeTrailingPathDelimiter(S),DestPrgDir+St[I]+'\') then exit;
        end;
      end;
    finally
      St.Free;
    end;

  finally
    FreeSmallWaitForm;
  end;

  result:=True;
end;

function TTransferForm.GetOperationMode(var OpMode: TOperationMode): Boolean;
Var S : String;
    St : TStringList;
    I : Integer;
begin
  result:=False;

  S:=Trim(DestPrgDirEdit.Text);
  If S='' then begin
    MessageDlg(LanguageSetup.MessageNoInstallationSelected,mtError,[mbOK],0);
    exit;
  end;

  result:=True;
  OpMode:=omPrgDir;

  S:=IncludeTrailingPathDelimiter(S)+ExtractFileName(OperationModeConfig);
  If not FileExists(S) then exit;

  St:=TStringList.Create;
  try
    try St.LoadFromFile(S); except exit; end;
    For I:=0 to St.Count-1 do begin
      S:=Trim(ExtUpperCase(St[I]));
      If S='PRGDIRMODE' then begin OpMode:=omPrgDir; exit; end;
      If S='USERDIRMODE' then begin OpMode:=omUserDir; exit; end;
      If S='PORTABLEMODE' then begin OpMode:=omPortable; exit; end;
    end;
  finally
    St.Free;
  end;
end;

function TTransferForm.GetDestPrgDataDir(const OpMode: TOperationMode; var DestPrgDataDir: String): Boolean;
Var S : String;
    LocalPrgSetup : TPrgSetup;
    SaveOpMode : TOperationMode;
begin
  result:=False;

  If OpMode=omUserDir then begin
    S:=IncludeTrailingPathDelimiter(GetSpecialFolder(0,CSIDL_PROFILE))+'D-Fend Reloaded\';
  end else begin
    S:=IncludeTrailingPathDelimiter(Trim(DestPrgDirEdit.Text));
  end;

  S:=S+ExtractFileName(MainSetupFile);
  if not FileExists(S) then begin
    MessageDlg(Format(LanguageSetup.MessageNoSetupFileFound,[ExtractFilePath(S)]),mtError,[mbOK],0);
    exit;
  end;

  result:=True;

  SaveOpMode:=OperationMode;
  OperationMode:=OpMode;
  TempPrgDir:=IncludeTrailingPathDelimiter(ExtractFilePath(S));
  LocalPrgSetup:=TPrgSetup.Create(S);
  try
    DestPrgDataDir:=LocalPrgSetup.BaseDir;
  finally
    LocalPrgSetup.Free;
    OperationMode:=SaveOpMode;
    TempPrgDir:='';
  end;
end;

function TTransferForm.CopyDir(const SourceDir, DestDir: String): Boolean;
Var Rec : TSearchRec;
    I : Integer;
begin
  result:=False;

  if not ForceDirectories(DestDir) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[DestDir]),mtError,[mbOK],0);
    exit;
  end;

  I:=FindFirst(SourceDir+'*.*',faAnyFile,Rec);
  try
    while I=0 do begin
      If (Rec.Attr and faDirectory)<>0 then begin
        If Rec.Name[1]<>'.' then begin
          if not CopyDir(SourceDir+Rec.Name+'\',DestDir+Rec.Name+'\') then exit;
        end;
      end else begin
        if not CopyFile(PChar(SourceDir+Rec.Name),PChar(DestDir+Rec.Name),False) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[SourceDir+Rec.Name,DestDir+Rec.Name]),mtError,[mbOK],0); exit;
        end;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  result:=True;
end;

function TTransferForm.CopyFiles(const RelDir, SourceBaseDir, DestBaseDir, GameName: String): Boolean;
Var S,T : String;
begin
  S:=IncludeTrailingPathDelimiter(MakeRelPath(RelDir,SourceBaseDir));
  If Copy(S,2,2)=':\' then begin
    MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[RelDir,GameName,S]),mtError,[mbOK],0);
    result:=False; exit;
  end;
  S:=IncludeTrailingPathDelimiter(MakeAbsPath(IncludeTrailingPathDelimiter(RelDir),SourceBaseDir));
  T:=IncludeTrailingPathDelimiter(MakeAbsPath(IncludeTrailingPathDelimiter(RelDir),DestBaseDir));
  result:=CopyDir(S,T);
end;

function TTransferForm.TransferGame(const Game: TGame; const DestDataDir: String): Boolean;
Var S,T : String;
    I : Integer;
    St : TStringList;
begin
  result:=False;
  Game.StoreAllValues;

  S:=DestDataDir+GameListSubDir+'\'+ExtractFileName(Game.SetupFile);
  If FileExists(S) then begin
    I:=0;
    repeat inc(I); until not FileExists(ChangeFileExt(S,IntToStr(I)+'.conf'));
    S:=ChangeFileExt(S,IntToStr(I)+'.conf');
  end;
  if not CopyFile(PChar(Game.SetupFile),PChar(S),True) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[Game.SetupFile,S]),mtError,[mbOK],0); exit;
  end;
  
  If ScummVMMode(Game) then begin
    S:=Trim(Game.ScummVMPath);
    If S<>'' then begin
      S:=IncludeTrailingPathDelimiter(S);
      if not CopyFiles(S,PrgDataDir,DestDataDir,Game.Name) then exit;
    end;
  end else begin
    S:=Trim(Game.GameExe);
    If ExtUpperCase(Copy(S,1,7))='DOSBOX:' then S:='';
    If S='' then S:=Trim(Game.SetupExe);
    If ExtUpperCase(Copy(S,1,7))='DOSBOX:' then S:='';
    If S<>'' then begin
      S:=IncludeTrailingPathDelimiter(ExtractFilePath(S));
      if not CopyFiles(S,PrgDataDir,DestDataDir,Game.Name) then exit;
    end;

    S:=Trim(Game.CaptureFolder);
    If S<>'' then begin
      S:=IncludeTrailingPathDelimiter(S);
      if not CopyFiles(S,PrgDataDir,DestDataDir,Game.Name) then exit;
    end;
  end;

  S:=MakeAbsIconName(Game.Icon);
  If (S<>'') and FileExists(S) then begin
    If ExtractFilePath(Game.Icon)='' then begin
      S:=Trim(Game.Icon);
      if not CopyFile(PChar(PrgDataDir+IconsSubDir+'\'+S),PChar(DestDataDir+IconsSubDir+'\'+S),False) then begin
        MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[PrgDataDir+IconsSubDir+'\'+S,DestDataDir+IconsSubDir+'\'+S]),mtError,[mbOK],0); exit;
        exit;
      end;
    end else begin
      S:=MakeRelPath(S,PrgSetup.BaseDir);
      If Copy(S,2,2)=':\' then begin
        MessageDlg(Format(LanguageSetup.MessagePathNotRelative,[S,Game.Name,PrgSetup.BaseDir]),mtError,[mbOK],0);
        result:=False; exit;
      end;
      T:=ExtractFilePath(S);
      T:=IncludeTrailingPathDelimiter(MakeAbsPath(T,DestDataDir))+ExtractFileName(S);
      S:=MakeAbsPath(S,PrgSetup.BaseDir);
      if not CopyFile(PChar(S),PChar(T),False) then begin
        MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[S,T]),mtError,[mbOK],0); exit;
        exit;
      end;
    end;
  end;

  S:=Trim(Game.DataDir);
  If S<>'' then begin
    S:=IncludeTrailingPathDelimiter(S);
    if not CopyFiles(S,PrgDataDir,DestDataDir,Game.Name) then exit;
  end;

  S:=Trim(Game.ExtraFiles);
  If S<>'' then begin
    St:=ValueToList(S);
    try
      For I:=0 to St.Count-1 do If Trim(St[I])<>'' then begin
        S:=St[I];
        If not ForceDirectories(ExtractFilePath(MakeAbsPath(S,DestDataDir))) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[ExtractFilePath(MakeAbsPath(S,DestDataDir))]),mtError,[mbOK],0); exit;
          exit;
        end;
        if not CopyFile(PChar(MakeAbsPath(S,PrgDataDir)),PChar(MakeAbsPath(S,DestDataDir)),False) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotCopyFile,[MakeAbsPath(S,PrgDataDir),MakeAbsPath(S,DestDataDir)]),mtError,[mbOK],0); exit;
          exit;
        end;
      end;
    finally
      St.Free;
    end;
  end;

  S:=Trim(Game.ExtraDirs);
  If S<>'' then begin
    St:=ValueToList(S);
    try
      For I:=0 to St.Count-1 do If Trim(St[I])<>'' then begin
        S:=IncludeTrailingPathDelimiter(St[I]);
        if not CopyFiles(S,PrgDataDir,DestDataDir,Game.Name) then exit;
      end;
    finally
      St.Free;
    end;
  end;

  result:=True;
end;

procedure TTransferForm.OKButtonClick(Sender: TObject);
Var OpMode : TOperationMode;
    DestPrgDataDir : String;
    I,J : Integer;
begin
  If CopyDFRCheckBox.Checked then begin
    If not CopyInstallation(IncludeTrailingPathDelimiter(DestPrgDirEdit.Text)) then begin ModalResult:=mrNone; exit; end;
  end;

  If not GetOperationMode(OpMode) then begin ModalResult:=mrNone; exit; end;
  if not GetDestPrgDataDir(OpMode,DestPrgDataDir) then begin ModalResult:=mrNone; exit; end;

  J:=0; For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then inc(J);
  InitProgressWindow(self,J);
  try
    For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then begin
      StepProgressWindow;
      if not TransferGame(TGame(ListBox.Items.Objects[I]),DestPrgDataDir) then begin ModalResult:=mrNone; exit; end;
    end;
  finally
    DoneProgressWindow;
  end;
end;

{ global }

Function TransferGames(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
begin
  TransferForm:=TTransferForm.Create(AOwner);
  try
    TransferForm.GameDB:=AGameDB;
    result:=(TransferForm.ShowModal=mrOK);
  finally
    TransferForm.Free;
  end;
end;


end.
