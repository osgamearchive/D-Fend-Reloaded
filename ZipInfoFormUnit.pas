unit ZipInfoFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ZipMstr, SevenZipVCL;

Type TZipMode=(zmExtract, zmCreate, zmAdd, zmCreateAndDelete, zmAddAndDelete);

Type TDeleteMode=(dmNo, dmFiles, dmFolder, dmNoNoWarning, dmFilesNoWarning, dmFolderNoWarning); {Warning = Overwrite zip files warining}

type
  TZipInfoForm = class(TForm)
    ProgressBar: TProgressBar;
    InfoLabel: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    Zip : TZipMaster;
    SevenZip : TSevenZip;

    Start : Cardinal;
    ZipFile, Folder : String;
    Mode : TZipMode;
    FCompressStrength : TCompressStrength;
    FDeleteMode : TDeleteMode;

    SevenZipLastError : Integer;
    SevenZipMaxProgress : Int64;

    Procedure PostShow(var Msg : TMessage); message WM_USER+1;
    Function ZipWork : Boolean;
    Procedure ZipExtract;
    Procedure ZipCreate;
    Procedure ZipAdd;
    Procedure ZipPassword(Sender: TObject; IsZipAction: Boolean; var NewPassword: String; ForFile: String; var RepeatCount: LongWord; var Action: TPasswordButton);
    Procedure ZipProgress(Sender: TObject; Details: TProgressDetails);
    Function SevenZipWork : Boolean;
    Procedure SevenZipExtract;
    Procedure SevenZipCreate;
    Procedure SevenZipPreProgress(Sender: TObject; MaxProgress: Int64);
    Procedure SevenZipProgress(Sender: TObject; Filename: WideString; FilePosArc, FilePosFile: Int64);
    Procedure SevenZipExtractOverwrite(Sender: TObject; FileName: WideString; var DoOverwrite: Boolean);
    Procedure SevenZipMessage( Sender: TObject; ErrCode: Integer; Message: string;Filename:Widestring );
    Function ExternalWork(const Nr : Integer) : Boolean;
    Function DeleteFolder(Folder : String; const ThisIsMainFolder : Boolean) : Boolean;
    Function DeleteFiles : Boolean;
  public
    { Public-Deklarationen }
    Function Init(const AMode : TZipMode; const AZipFile, AFolder : String) : Boolean;
    property CompressStrength : TCompressStrength read FCompressStrength write FCompressStrength;
    property DeleteMode : TDeleteMode read FDeleteMode write FDeleteMode;
  end;

var
  ZipInfoForm: TZipInfoForm;

Function ExtractZipFile(const AOwner : TComponent; const AZipFile, ADestFolder : String) : Boolean;
Function CreateZipFile(const AOwner : TComponent; const AZipFile, ADestFolder : String; const DeleteMode : TDeleteMode = dmNo; const CompressStrength : TCompressStrength = MAXIMUM) : Boolean;
Function AddToZipFile(const AOwner : TComponent; const AZipFile, ADestFolder : String; const DeleteMode : TDeleteMode = dmNo; const CompressStrength : TCompressStrength = MAXIMUM) : Boolean;

Function CheckExtensionsList(Extensions : String) : String;
Function ExtensionInList(Extension, List : String) : Boolean;

implementation

uses Math, LanguageSetupUnit, PrgSetupUnit, CommonTools, DOSBoxUnit;

{$R *.dfm}

procedure TZipInfoForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered:=True;
  FCompressStrength:=MAXIMUM;
end;

function TZipInfoForm.Init(const AMode: TZipMode; const AZipFile, AFolder: String): Boolean;
begin
  result:=False;

  Mode:=AMode;
  ZipFile:=AZipFile;
  Folder:=IncludeTrailingPathDelimiter(AFolder);

  If (Mode=zmExtract) or (Mode=zmAdd) or (Mode=zmAddAndDelete) then begin
    If not FileExists(ZipFile) then begin MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[ZipFile]),mtError,[mbOK],0); exit; end;
  end;

  If (Mode=zmCreate) or (Mode=zmCreateAndDelete) then begin
    If FileExists(ZipFile) then begin
      If (FDeleteMode<>dmNoNoWarning) and (FDeleteMode<>dmFilesNoWarning) and (FDeleteMode<>dmFolderNoWarning) then begin
        If MessageDlg(Format(LanguageSetup.ZipFormOverwriteWarning,[ZipFile]),mtWarning,[mbYes,mbNo],0)<>mrYes then exit;
      end;
      If not ExtDeleteFile(ZipFile,ftZipOperation) then begin MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[ZipFile]),mtError,[mbOK],0); exit; end;
    end;
  end;

  If Mode=zmExtract then begin
    If not ForceDirectories(Folder) then begin MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[Folder]),mtError,[mbOK],0); exit; end;
  end;

  If (Mode=zmCreate) or (Mode=zmAdd) or (Mode=zmCreateAndDelete) or (Mode=zmAddAndDelete) then begin
    If not DirectoryExists(Folder) then begin MessageDlg(Format(LanguageSetup.MessageDirectoryNotFound,[Folder]),mtError,[mbOK],0); exit; end;
  end;

  result:=True;

  Case Mode of
    zmExtract                   : Caption:=LanguageSetup.ZipFormCaptionExtract;
    zmCreate, zmCreateAndDelete : Caption:=LanguageSetup.ZipFormCaptionCreate;
    zmAdd, zmAddAndDelete       : Caption:=LanguageSetup.ZipFormCaptionAdd;
  end;
end;

procedure TZipInfoForm.FormShow(Sender: TObject);
begin
  PostMessage(Handle,WM_USER+1,0,0);
end;

procedure TZipInfoForm.PostShow(var Msg: TMessage);
Var Ext,SaveDir : String;
    Ok, Handled : Boolean;
    I : Integer;
begin
  Start:=GetTickCount;

  SaveDir:=GetCurrentDir;
  try
    SetCurrentDir(ExtractFilePath(ExpandFileName(Application.ExeName)));
    Ext:=Trim(UpperCase(ExtractFileExt(ZipFile)));

    If (Mode in [zmCreate, zmAdd, zmCreateAndDelete, zmAddAndDelete]) and (not DirectoryExists(Folder)) then begin
      MessageDlg(Format(LanguageSetup.MessageDirectoryNotFound,[Folder]),mtError,[mbOk],0);
      ModalResult:=mrCancel;
      PostMessage(Handle,WM_CLOSE,0,0);
      exit;
    end;


    Handled:=False; Ok:=False;
    For I:=0 to PrgSetup.PackerSettingsCount-1 do If ExtensionInList(Ext,PrgSetup.PackerSettings[I].FileExtensions) then begin
      Handled:=True;
      Ok:=ExternalWork(I);
    end;

    If not Handled then begin
      If Ext='.ZIP' then begin Handled:=True; Ok:=ZipWork; end;
      If Ext='.7Z' then begin Handled:=True; Ok:=SevenZipWork; end;
    end;

    If not Handled then begin
      MessageDlg(Format(LanguageSetup.ZipFormUnknownExtension,[Ext]),mtError,[mbOK],0);
    end;

    If Ok and ((Mode=zmCreateAndDelete) or (Mode=zmAddAndDelete)) then Ok:=DeleteFiles;
  finally
    SetCurrentDir(SaveDir);
  end;

  If Ok then ModalResult:=mrOK else ModalResult:=mrCancel;
  PostMessage(Handle,WM_CLOSE,0,0);
end;

Function TZipInfoForm.ZipWork : Boolean;
begin
  result:=True;

  Zip:=TZipMaster.Create(self);
  try
    Zip.OnPasswordError:=ZipPassword;
    Zip.OnProgressDetails:=ZipProgress;
    Zip.ZipFileName:=ZipFile;
    Zip.RootDir:=Folder;

    Case Mode of
      zmExtract                   : ZipExtract;
      zmCreate, zmCreateAndDelete : ZipCreate;
      zmAdd, zmAddAndDelete       : ZipAdd;
    end;

    while Zip.Busy do begin
      Sleep(500);
      Application.ProcessMessages;
    end;

    If Zip.ErrCode<>0 then begin
      result:=False;
      If Mode=zmExtract
        then MessageDlg(LanguageSetup.ZipFormErrorExtract,mtError,[mbOK],0)
        else MessageDlg(LanguageSetup.ZipFormErrorCompress,mtError,[mbOK],0);
    end;
  finally
    Zip.Free;
  end;
end;

procedure TZipInfoForm.ZipExtract;
begin
  Zip.ExtrOptions:=[ExtrDirNames,ExtrOverWrite];
  Zip.ExtrBaseDir:=Folder;

  Zip.Extract;
end;

procedure TZipInfoForm.ZipCreate;
begin
  Case FCompressStrength of
    SAVE    : Zip.AddCompLevel:=0;
    FAST    : Zip.AddCompLevel:=3;
    NORMAL  : Zip.AddCompLevel:=7;
    MAXIMUM : Zip.AddCompLevel:=8;
    ULTRA   : Zip.AddCompLevel:=9;
  end;

  Zip.AddOptions:=[AddHiddenFiles,AddDirNames,AddSeparateDirs];
  Zip.FSpecArgs.Add('>*.*');

  Zip.Add;
end;

procedure TZipInfoForm.ZipAdd;
Var Rec : TSearchRec;
    I : Integer;
    B : Boolean;
begin
  Case FCompressStrength of
    SAVE    : Zip.AddCompLevel:=0;
    FAST    : Zip.AddCompLevel:=3;
    NORMAL  : Zip.AddCompLevel:=7;
    MAXIMUM : Zip.AddCompLevel:=8;
    ULTRA   : Zip.AddCompLevel:=9;
  end;

  Zip.AddOptions:=[AddHiddenFiles,AddDirNames,AddSeparateDirs,AddUpdate];
  Zip.FSpecArgs.Add('>*.*');

  B:=False;
  I:=FindFirst(IncludeTrailingPathDelimiter(Folder)+'*.*',faAnyFile,Rec);
  try
    While I=0 do begin
      If (Rec.Name<>'.') and (Rec.Name<>'..') then begin B:=True; break; end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  If B then Zip.Add;
end;

procedure TZipInfoForm.ZipPassword(Sender: TObject; IsZipAction: Boolean; var NewPassword: String; ForFile: String; var RepeatCount: LongWord; var Action: TPasswordButton);
begin
  If InputQuery(LanguageSetup.ZipFormCaptionExtract,LanguageSetup.ZipFormPasswordPrompt,NewPassword) then Action:=pwbOk else Action:=pwbAbort;
end;

procedure TZipInfoForm.ZipProgress(Sender: TObject; Details: TProgressDetails);
Var S : String;
begin
  ProgressBar.Position:=Details.TotalPerCent;

  Case Mode of
    zmExtract                   : S:=LanguageSetup.ZipFormProgressExtract;
    zmCreate, zmCreateAndDelete : S:=LanguageSetup.ZipFormProgressCreate;
    zmAdd, zmAddAndDelete       : S:=LanguageSetup.ZipFormProgressAdd;
  end;

  InfoLabel.Caption:=
    Format(S,[ExtractFileName(ZipFile)])+#13+#13+Folder+#13+#13+
    Format(LanguageSetup.ZipFormProgress,[Details.TotalPerCent,Details.TotalPosition div 1024 div 1024,1000*Details.TotalPosition div 1024 div 1024 div Max(1,(GetTickCount-Start))]);
end;

function TZipInfoForm.SevenZipWork: Boolean;
begin
  result:=True;
  SevenZipLastError:=0;

  SevenZip:=TSevenZip.Create(self);
  try
    SevenZip.SZFileName:=ZipFile;
    SevenZip.OnPreProgress:=SevenZipPreProgress;
    SevenZip.OnProgress:=SevenZipProgress;
    SevenZip.OnExtractOverwrite:=SevenZipExtractOverwrite;
    SevenZip.OnMessage:=SevenZipMessage;
    SevenZip.AddRootDir:=Folder;
    SevenZip.ExtrBaseDir:=Folder;

    Case Mode of
      zmExtract                   : SevenZipExtract;
      zmCreate, zmCreateAndDelete : SevenZipCreate;
      zmAdd, zmAddAndDelete       : begin
                                      MessageDlg(LanguageSetup.ZipFormErrorNoRepack7ZipSupport,mtError,[mbOK],0);
                                      result:=False;
                                      exit;
                                    end;
    end;

    If (SevenZip.ErrCode<>0) or (SevenZipLastError<>0) then begin
      result:=False;
      If Mode=zmExtract
        then MessageDlg(LanguageSetup.ZipFormErrorExtract,mtError,[mbOK],0)
        else MessageDlg(LanguageSetup.ZipFormErrorCompress,mtError,[mbOK],0);
    end;
  finally
    SevenZip.Free;
  end;
end;

Procedure TZipInfoForm.SevenZipExtract;
begin
  SevenZip.ExtractOptions:=SevenZip.ExtractOptions+[ExtractOverwrite];
  SevenZip.Files.Clear;

  SevenZip.Extract;
end;

Procedure TZipInfoForm.SevenZipCreate;
begin
  SevenZip.LZMACompressStrength:=FCompressStrength;
  SevenZip.AddOptions:=[AddRecurseDirs];
  SevenZip.Files.Clear;
  SevenZip.Files.AddString(Folder+'*.*');

  SevenZip.Add;
end;

procedure TZipInfoForm.SevenZipPreProgress(Sender: TObject; MaxProgress: Int64);
begin
  SevenZipMaxProgress:=MaxProgress;
end;

procedure TZipInfoForm.SevenZipProgress(Sender: TObject; Filename: WideString; FilePosArc, FilePosFile: Int64);
Var S : String;
begin
  ProgressBar.Position:=100*FilePosArc div SevenZipMaxProgress;

  Case Mode of
    zmExtract                   : S:=LanguageSetup.ZipFormProgressExtract;
    zmCreate, zmCreateAndDelete : S:=LanguageSetup.ZipFormProgressCreate;
    zmAdd, zmAddAndDelete       : S:=LanguageSetup.ZipFormProgressAdd;
  end;

  InfoLabel.Caption:=
    Format(S,[ExtractFileName(ZipFile)])+#13+#13+Folder+#13+#13+
    Format(LanguageSetup.ZipFormProgress,[100*FilePosArc div SevenZipMaxProgress,FilePosArc div 1024 div 1024,1000*FilePosArc div 1024 div 1024 div Max(1,(GetTickCount-Start))]);

  Application.ProcessMessages;
end;

procedure TZipInfoForm.SevenZipExtractOverwrite(Sender: TObject; FileName: WideString; var DoOverwrite: Boolean);
begin
  DoOverwrite:=True;
end;

procedure TZipInfoForm.SevenZipMessage(Sender: TObject; ErrCode: Integer; Message: string; Filename: Widestring);
begin
  If ErrCode=FDataError then begin
    MessageDlg(LanguageSetup.ZipFormErrorNoPassword7ZipSupport,mtError,[mbOK],0);
    SevenZipLastError:=ErrCode;
    SevenZip.Cancel;
    exit;
  end;

  If ErrCode in [FFileNotFound, FDataError, FCRCError, FUnsupportedMethod, FIndexOutOfRange, FSFXModuleError] then begin
    SevenZipLastError:=ErrCode;
    SevenZip.Cancel;
    exit;
  end;
end;

Function TZipInfoForm.ExternalWork(const Nr : Integer) : Boolean;
Var PrgName,Parameters,ParametersOrig : String;
    StartupInfo : TStartupInfo;
    ProcessInformation : TProcessInformation;
    I : Integer;
begin
  result:=True;

  PrgName:=PrgSetup.PackerSettings[Nr].ZipFileName;
  If not FileExists(PrgName) then begin
    MessageDlg(Format(LanguageSetup.MessageFileNotFound,[PrgName]),mtError,[mbOK],0);
    result:=False;
    exit;
  end;

  Case Mode of
    zmExtract : Parameters:=PrgSetup.PackerSettings[Nr].ExtractFile;
    zmCreate, zmCreateAndDelete : Parameters:=PrgSetup.PackerSettings[Nr].CreateFile;
    zmAdd, zmAddAndDelete : Parameters:=PrgSetup.PackerSettings[Nr].UpdateFile;
  end;
  ParametersOrig:=Parameters;

  I:=Pos('%1',Parameters);
  If I=0 then begin
    MessageDlg(Format(LanguageSetup.ZipFormInvalidParameters,[ParametersOrig]),mtError,[mbOK],0);
    result:=False;
    exit;
  end;
  Parameters:=Copy(Parameters,1,I-1)+ZipFile+Copy(Parameters,I+2,MaxInt);

  I:=Pos('%2',Parameters);
  If I=0 then begin
    MessageDlg(Format(LanguageSetup.ZipFormInvalidParameters,[ParametersOrig]),mtError,[mbOK],0);
    result:=False;
    exit;
  end;
  Parameters:=Copy(Parameters,1,I-1)+Folder+Copy(Parameters,I+2,MaxInt);

  StartupInfo.cb:=SizeOf(StartupInfo);
  with StartupInfo do begin lpReserved:=nil; lpDesktop:=nil; lpTitle:=nil; dwFlags:=0; cbReserved2:=0; lpReserved2:=nil; end;

  If not CreateProcess(PChar(PrgName),PChar('"'+PrgName+'" '+Parameters),nil,nil,False,0,nil,nil,StartupInfo,ProcessInformation) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotStartProgram,[PrgName]),mtError,[mbOK],0);
    exit;
  end;

  try
    While not (WaitForSingleObject(ProcessInformation.hProcess,0)=WAIT_OBJECT_0) do begin
      Sleep(100);
      Application.ProcessMessages;
    end;
  finally
    CloseHandle(ProcessInformation.hThread);
    CloseHandle(ProcessInformation.hProcess);
  end;
end;

Function TZipInfoForm.DeleteFolder(Folder : String; const ThisIsMainFolder : Boolean) : Boolean;
Var Rec : TSearchRec;
    I : Integer;
    S : String;
begin
  result:=False;
  Folder:=IncludeTrailingPathDelimiter(Folder);
  If length(Folder)=3 then exit;

  If not DirectoryExists(Folder) then begin result:=True; exit; end;

  S:=ShortName(PrgSetup.BaseDir);
  If PrgSetup.DeleteOnlyInBaseDir and (ExtUpperCase(Copy(ShortName(Folder),1,length(S)))<>ExtUpperCase(S)) then begin
    MessageDlg(Format(LanguageSetup.MessageDeleteErrorProtection,[Folder]),mtError,[mbOk],0);
    exit;
  end;

  I:=FindFirst(Folder+'*.*',faAnyFile,Rec);
  try
    while I=0 do begin
      If (Rec.Attr and faDirectory)<>0 then begin
        If (Rec.Name<>'.') and (Rec.Name<>'..') then begin
          if not DeleteFolder(Folder+Rec.Name,False) then exit;
        end;
      end else begin
        If not ExtDeleteFile(Folder+Rec.Name,ftZipOperation) then begin
          MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[Folder+Rec.Name]),mtError,[mbOK],0);
          exit;
        end;
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  If (not ThisIsMainFolder) or (FDeleteMode=dmFolder) or (FDeleteMode=dmFolderNoWarning) then begin
    if not ExtDeleteFolder(Folder,ftZipOperation) then begin
      MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteDir,[Folder]),mtError,[mbOK],0);
      exit;
    end;
  end;

  result:=True;
end;

function TZipInfoForm.DeleteFiles: Boolean;
begin
  DeleteFolder(Folder,True);
  result:=True;
end;

{ global }

Function ZipDialogWork(const AOwner : TComponent; const AZipFile, ADestFolder : String; const AZipMode : TZipMode; const ACompressStrength : TCompressStrength; const ADeleteMode : TDeleteMode) : Boolean;
begin
  result:=False;
  ZipInfoForm:=TZipInfoForm.Create(AOwner);
  try
    ZipInfoForm.CompressStrength:=ACompressStrength;
    ZipInfoForm.DeleteMode:=ADeleteMode;
    if not ZipInfoForm.Init(AZipMode,AZipFile,ADestFolder) then exit;
    result:=(ZipInfoForm.ShowModal=mrOK);
  finally
    ZipInfoForm.Free;
  end;
end;

Function ExtractZipFile(const AOwner : TComponent; const AZipFile, ADestFolder : String) : Boolean;
begin
  result:=ZipDialogWork(AOwner,AZipFile,ADestFolder,zmExtract,MAXIMUM,dmNo);
end;

Function CreateZipFile(const AOwner : TComponent; const AZipFile, ADestFolder : String; const DeleteMode : TDeleteMode; const CompressStrength : TCompressStrength) : Boolean;
begin
  If (DeleteMode<>dmNo) and (DeleteMode<>dmNoNoWarning)
    then result:=ZipDialogWork(AOwner,AZipFile,ADestFolder,zmCreateAndDelete,CompressStrength,DeleteMode)
    else result:=ZipDialogWork(AOwner,AZipFile,ADestFolder,zmCreate,CompressStrength,DeleteMode);
end;

Function AddToZipFile(const AOwner : TComponent; const AZipFile, ADestFolder : String; const DeleteMode : TDeleteMode; const CompressStrength : TCompressStrength) : Boolean;
begin
  If (DeleteMode<>dmNo) and (DeleteMode<>dmNoNoWarning)
    then result:=ZipDialogWork(AOwner,AZipFile,ADestFolder,zmAddAndDelete,CompressStrength,DeleteMode)
    else result:=ZipDialogWork(AOwner,AZipFile,ADestFolder,zmAdd,CompressStrength,DeleteMode);
end;

Function CheckExtension(Extension : String) : String;
begin
  result:='';

  If Extension='' then exit;
  If Extension[1]='*' then Delete(Extension,1,1);

  If Extension='' then exit;
  If Extension[1]='.' then Delete(Extension,1,1);

  result:=Extension;
end;

Function CheckExtensionsList(Extensions : String) : String;
Var I : Integer;
    S : String;
begin
  result:='';
  Extensions:=Trim(Extensions);

  repeat
    I:=Pos(';',Extensions);
    If I>0 then begin
      S:=CheckExtension(Trim(Copy(Extensions,1,I-1)));
      Extensions:=Trim(Copy(Extensions,I+1,MaxInt));
    end else begin
      S:=CheckExtension(Extensions);
      Extensions:='';
    end;
    If S<>'' then begin
      If result<>'' then result:=result+';';
      result:=result+S;
    end;
  until I=0;
end;

Function ExtensionInList(Extension, List : String) : Boolean;
Var I : Integer;
    S : String;
begin
  result:=False;
  Extension:=Trim(ExtUpperCase(CheckExtension(Extension)));

  List:=Trim(List);
  repeat
    I:=Pos(';',List);
    If I>0 then begin
      S:=CheckExtension(Trim(Copy(List,1,I-1)));
      List:=Trim(Copy(List,I+1,MaxInt));
    end else begin
      S:=CheckExtension(List);
      List:='';
    end;
    If Trim(ExtUpperCase(S))=Extension then begin result:=True; exit; end;
  until I=0;
end;

end.
