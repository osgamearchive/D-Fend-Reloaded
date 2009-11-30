unit DOSBoxTempUnit;
interface

uses GameDBUnit;

Type TTempGame=class
  private
    FNormalMinimizeState : Array[0..2] of Boolean;
    FGame : TGame;
    FTempProf : String;
  public
    Constructor Create(const InitTempGame : Boolean = True);
    Destructor Destroy; override;
    Procedure SetSimpleDefaults; 
    property Game : TGame read FGame;
end;

implementation

uses PrgSetupUnit, CommonTools;

{ TTempGame }

constructor TTempGame.Create(const InitTempGame : Boolean);
Var DefaultGame : TGame;
begin
  inherited Create;

  FNormalMinimizeState[0]:=PrgSetup.MinimizeOnDosBoxStart;
  FNormalMinimizeState[1]:=PrgSetup.MinimizeOnScummVMStart;
  FNormalMinimizeState[2]:=PrgSetup.MinimizeOnWindowsGameStart;
  PrgSetup.MinimizeOnDosBoxStart:=False;
  PrgSetup.MinimizeOnScummVMStart:=False;
  PrgSetup.MinimizeOnWindowsGameStart:=False;

  If InitTempGame then begin
    FTempProf:=TempDir+'TempDOSBox.prof';
    FGame:=TGame.Create(FTempProf);
    DefaultGame:=TGame.Create(PrgSetup);
    try FGame.AssignFrom(DefaultGame); finally DefaultGame.Free; end;
  end else begin
    FGame:=nil;
  end;
end;

destructor TTempGame.Destroy;
begin
  PrgSetup.MinimizeOnDosBoxStart:=FNormalMinimizeState[0];
  PrgSetup.MinimizeOnScummVMStart:=FNormalMinimizeState[1];
  PrgSetup.MinimizeOnWindowsGameStart:=FNormalMinimizeState[2];

  If Assigned(FGame) then begin
    FGame.Free;
    ExtDeleteFile(FTempProf,ftTemp);
  end;

  inherited Destroy;
end;

procedure TTempGame.SetSimpleDefaults;
begin
  if not Assigned(FGame) then exit;
  FGame.ProfileMode:='DOSBox';
  FGame.Autoexec:='';
  FGame.AutoexecOverridegamestart:=True;
  FGame.AutoexecOverrideMount:=False;
  FGame.AutoexecBootImage:='';
  FGame.StartFullscreen:=False;
  FGame.CustomDOSBoxDir:='';
  FGame.CloseDosBoxAfterGameExit:=True;
end;

end.
