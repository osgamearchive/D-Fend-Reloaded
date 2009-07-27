unit ChecksumScanner;
interface

uses Classes;


Type TChecksumScanner=class
  private
    FDirectory : String;
    FFileNames, FChecksums : TStringList;
    FOwner : TComponent;
    FShowScanDialog  : Boolean;
    Function GetCount: Integer;
  public
    Constructor Create(const ADirectory : String; const AShowScanDialog : Boolean; const AOwner : TComponent);
    Destructor Destroy; override;
    Procedure ReScan;
    Function GetChecksum(const AFileName : String) : String;
    property Directory : String read FDirectory;
    property Count : Integer read GetCount;
end;

implementation

uses SysUtils, CommonTools, HashCalc, WaitFormUnit, PackageDBLanguage;

{ TChecksumScanner }

constructor TChecksumScanner.Create(const ADirectory: String; const AShowScanDialog : Boolean; const AOwner : TComponent);
begin
  inherited Create;
  FDirectory:=IncludeTrailingPathDelimiter(ADirectory);
  FFileNames:=TStringList.Create;
  FChecksums:=TStringList.Create;
  FShowScanDialog:=AShowScanDialog;
  FOwner:=AOwner;
  ReScan;
end;

destructor TChecksumScanner.Destroy;
begin
  FFileNames.Free;
  FChecksums.Free;
  inherited Destroy;
end;

Function TChecksumScanner.GetCount: Integer;
begin
  result:=FFileNames.Count;
end;

procedure TChecksumScanner.ReScan;
Var Rec : TSearchRec;
    I : Integer;
    WaitForm : TWaitForm;
begin
  FFileNames.Clear;
  FChecksums.Clear;

  I:=FindFirst(FDirectory+'*.*',faAnyFile,Rec);
  try
    While I=0 do begin
      If (Rec.Attr and faDirectory)=0 then FFileNames.AddObject(ExtUpperCase(Rec.Name),TObject(FFileNames.Count));
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  If FShowScanDialog then WaitForm:=CreateWaitForm(FOwner,LANG_Scanning,FFileNames.Count) else WaitForm:=nil;
  try
    For I:=0 to FFileNames.Count-1 do begin
      If Assigned(WaitForm) then WaitForm.Step(I);
      FChecksums.Add(GetMD5Sum(FDirectory+FFileNames[I]));
    end;
  finally
    If Assigned(WaitForm) then FreeAndNil(WaitForm);
  end;

  FFileNames.Sort;
end;

Function TChecksumScanner.GetChecksum(const AFileName: String): String;
Var I : integer;
begin
  result:='';
  I:=FFileNames.IndexOf(ExtUpperCase(AFileName)); If I<0 then exit;
  result:=FChecksums[Integer(FFileNames.Objects[I])];
end;

end.
