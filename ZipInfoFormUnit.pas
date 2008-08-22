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
      If not DeleteFile(ZipFile) then begin MessageDlg(Format(LanguageSetup.MessageCouldNotDeleteFile,[ZipFile]),mtError,[mbOK],0); exit; end;
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
    B : Boolean;
begin
  Start:=GetTickCount;
  B:=False;

  SaveDir:=GetCurrentDir;
  try
    SetCurrentDir(ExtractFilePath(ExpandFileName(Application.ExeName)));
    Ext:=Trim(UpperCase(ExtractFileExt(ZipFile)));
    If Ext='.ZIP' then B:=ZipWork;
    If Ext='.7Z' then B:=SevenZipWork;

    If B and ((Mode=zmCreateAndDelete) or (Mode=zmAddAndDelete)) then
      B:=DeleteFiles;
  finally
    SetCurrentDir(SaveDir);
  end;

  If B then ModalResult:=mrOK else ModalResult:=mrCancel;
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
        If not DeleteFile(Folder+Rec.Name) then begin
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
    if not RemoveDirectory(PChar(Folder)) then begin
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

end.
