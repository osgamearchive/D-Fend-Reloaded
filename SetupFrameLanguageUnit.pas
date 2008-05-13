unit SetupFrameLanguageUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls, SetupFormUnit;

type
  TSetupFrameLanguage = class(TFrame, ISetupFrame)
    LanguageLabel: TLabel;
    DosBoxLangLabel: TLabel;
    LanguageInfoLabel: TLabel;
    InstallerLangLabel: TLabel;
    InstallerLangInfoLabel: TLabel;
    LanguageComboBox: TComboBox;
    DosBoxLangEditComboBox: TComboBox;
    LanguageOpenEditor: TBitBtn;
    LanguageNew: TBitBtn;
    InstallerLangEditComboBox: TComboBox;
    Timer: TTimer;
    procedure LanguageComboBoxChange(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure InstallerLangEditComboBoxChange(Sender: TObject);
  private
    { Private-Deklarationen }
    DosBoxLang : TStringList;
    JustLoading : Boolean;
    PDosBoxDir : PString;
    LanguageChangeNotify : TSimpleEvent;
    OpenLanguageEditor : TOpenLanguageEditorEvent;
    InstallerLang : Integer;
    LangTimerCounter : Integer;
    procedure ReadCurrentInstallerLanguage;
  public
    { Public-Deklarationen }
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    Function GetName : String;
    Procedure InitGUIAndLoadSetup(InitData : TInitData);
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvencedMode : Boolean);
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses Registry, ShellAPI, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit,
     CommonTools, PrgConsts;

{$R *.dfm}

{ TSetupFrameLanguage }

constructor TSetupFrameLanguage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DosBoxLang:=TStringList.Create;
  JustLoading:=False;
end;

destructor TSetupFrameLanguage.Destroy;
begin
  DosBoxLang.Free;
  inherited Destroy;
end;

function TSetupFrameLanguage.GetName: String;
begin
  result:=LanguageSetup.SetupFormLanguageSheet;
end;

procedure TSetupFrameLanguage.InitGUIAndLoadSetup(InitData: TInitData);
Var St : TStringList;
    I : Integer;
begin
  NoFlicker(LanguageComboBox);
  NoFlicker(LanguageOpenEditor);
  NoFlicker(LanguageNew);
  NoFlicker(DosBoxLangEditComboBox);
  NoFlicker(InstallerLangEditComboBox);

  PDosBoxDir:=InitData.PDosBoxDir;
  LanguageChangeNotify:=InitData.LanguageChangeNotify;
  OpenLanguageEditor:=InitData.OpenLanguageEditorEvent;

  JustLoading:=True;
  try
    St:=GetLanguageList;
    try
      LanguageComboBox.Items.AddStrings(St);
      InstallerLangEditComboBox.Items.AddStrings(St);
    finally
      St.Free;
    end;
    I:=FindLanguageInList(ChangeFileExt(PrgSetup.Language,''),LanguageComboBox.Items);
    If I>=0 then LanguageComboBox.ItemIndex:=I else begin
      I:=FindEnglishInList(LanguageComboBox.Items);
      If I>=0 then LanguageComboBox.ItemIndex:=I else begin
        If LanguageComboBox.Items.Count>0 then LanguageComboBox.ItemIndex:=0;
      end;
    end;

    LanguageComboBoxChange(self); {to setup outdated warning}

    DOSBoxDirChanged;
    ReadCurrentInstallerLanguage;
  finally
    JustLoading:=False;
  end;
end;

procedure TSetupFrameLanguage.InstallerLangEditComboBoxChange(Sender: TObject);
Var I : Integer;
begin
  Timer.Enabled:=False;
  If InstallerLangEditComboBox.ItemIndex<0 then exit;
  I:=Integer(InstallerLangEditComboBox.Items.Objects[InstallerLangEditComboBox.ItemIndex]);
  If (I=InstallerLang) or (I=-1) then exit;

  ShellExecute(Handle,'open',PChar(PrgDir+'SetInstallerLanguage.exe'),PChar(IntToStr(I)),nil,SW_SHOW);
  LangTimerCounter:=10;
  Timer.Enabled:=True;
end;

procedure TSetupFrameLanguage.LoadLanguage;
begin
  LanguageLabel.Caption:=LanguageSetup.SetupFormLanguage;
  LanguageOpenEditor.Caption:=LanguageSetup.SetupFormLanguageOpenEditor;
  LanguageNew.Caption:=LanguageSetup.SetupFormLanguageOpenEditorNew;
  DosBoxLangLabel.Caption:=LanguageSetup.SetupFormDosBoxLang;
  InstallerLangLabel.Caption:=LanguageSetup.SetupFormInstallerLang;
  InstallerLangInfoLabel.Caption:=LanguageSetup.SetupFormInstallerLangInfo;
end;

Procedure FindAndAddLngFiles(const Dir : String; const St, St2 : TStrings);
Var Rec : TSearchRec;
    I : Integer;
begin
  I:=FindFirst(Dir+'*.lng',faAnyFile,Rec);
  try
    while I=0 do begin
      St.Add(ChangeFileExt(Rec.Name,''));
      St2.Add(Dir+Rec.Name);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

procedure TSetupFrameLanguage.DOSBoxDirChanged;
Var S : String;
    I : Integer;
begin
  S:=DosBoxLangEditComboBox.Text;
  DosBoxLangEditComboBox.Items.Clear;
  DosBoxLang.Clear;

  DosBoxLangEditComboBox.Items.Add('English');
  DosBoxLang.Add('');

  FindAndAddLngFiles(IncludeTrailingPathDelimiter(PDosBoxDir^),DosBoxLangEditComboBox.Items,DosBoxLang);
  FindAndAddLngFiles(PrgDir+LanguageSubDir+'\',DosBoxLangEditComboBox.Items,DosBoxLang);
  I:=DosBoxLangEditComboBox.Items.IndexOf(S);
  If I>=0 then DosBoxLangEditComboBox.ItemIndex:=I else DosBoxLangEditComboBox.ItemIndex:=0;

  I:=DosBoxLang.IndexOf(PrgSetup.DosBoxLanguage);
  If I>=0 then DosBoxLangEditComboBox.ItemIndex:=I else DosBoxLangEditComboBox.ItemIndex:=0;
end;

procedure TSetupFrameLanguage.ShowFrame(const AdvencedMode: Boolean);
begin
end;

procedure TSetupFrameLanguage.RestoreDefaults;
begin
end;

procedure TSetupFrameLanguage.SaveSetup;
begin
  PrgSetup.Language:=ShortLanguageName(LanguageComboBox.Text)+'.ini';
  PrgSetup.DosBoxLanguage:=DosBoxLang[DosBoxLangEditComboBox.ItemIndex];
end;

Function VersionStringToInt(S : String) : Integer;
Var I : Integer;
    T : String;
begin
  result:=0;
  S:=Trim(S);

  I:=Pos('.',S);
  If I=0 then begin T:=S; S:=''; end else begin T:=Trim(Copy(S,1,I-1)); S:=Trim(Copy(S,I+1,MaxInt)); end;
  try result:=result+StrToInt(T)*256*256; except end;

  I:=Pos('.',S);
  If I=0 then begin T:=S; S:=''; end else begin T:=Trim(Copy(S,1,I-1)); S:=Trim(Copy(S,I+1,MaxInt)); end;
  try result:=result+StrToInt(T)*256; except end;

  try result:=result+StrToInt(S); except end;
end;

procedure TSetupFrameLanguage.LanguageComboBoxChange(Sender: TObject);
Var S : String;
begin
  If not JustLoading then begin
    LanguageSetupUnit.LoadLanguage(ShortLanguageName(LanguageComboBox.Text)+'.ini');
    LanguageChangeNotify;
  end;

  S:=Trim(LanguageSetup.MaxVersion);
  If (S='') or (S='0') then begin
    LanguageInfoLabel.Visible:=True;
    LanguageInfoLabel.Caption:=LanguageSetup.LanguageNoVersion;
  end else begin
    If VersionStringToInt(S)<VersionStringToInt(GetNormalFileVersionAsString) then begin
      LanguageInfoLabel.Visible:=True;
      LanguageInfoLabel.Caption:=Format(LanguageSetup.LanguageOutdated,[LanguageSetup.MaxVersion,GetNormalFileVersionAsString]);
    end else begin
      LanguageInfoLabel.Visible:=False;
    end;
  end;
end;

procedure TSetupFrameLanguage.ButtonWork(Sender: TObject);
begin
  If MessageDlg(LanguageSetup.SetupFormLanguageOpenEditorConfirmation,mtConfirmation,[mbOK,mbCancel],0)=mrOK then
    OpenLanguageEditor((Sender as TComponent).Tag+1);
end;

procedure TSetupFrameLanguage.ReadCurrentInstallerLanguage;
Var Reg : TRegistry;
    I, SelLang : Integer;
begin
  InstallerLang:=-1;
  Reg:=TRegistry.Create;
  try
    Reg.Access:=KEY_READ;
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    If Reg.OpenKey('\Software\D-Fend Reloaded',False) and Reg.ValueExists('Installer Language') then begin
      try InstallerLang:=StrToInt(Reg.ReadString('Installer Language')); except end;
    end;
  finally
    Reg.Free;
  end;

  InstallerLangEditComboBox.OnChange:=nil;

  If InstallerLang>=0 then begin
    SelLang:=-1;
    For I:=0 to InstallerLangEditComboBox.Items.Count-1 do If Integer(InstallerLangEditComboBox.Items.Objects[I])=InstallerLang then begin
      SelLang:=I; break;
    end;
  end else begin
    SelLang:=-1;
  end;

  If (InstallerLangEditComboBox.Items.Count>0) and (Integer(InstallerLangEditComboBox.Items.Objects[InstallerLangEditComboBox.Items.Count-1])=-1) then begin
    InstallerLangEditComboBox.Items.Delete(InstallerLangEditComboBox.Items.Count-1);
  end;

  If SelLang=-1 then begin
    InstallerLangEditComboBox.Items.AddObject('?',TObject(-1));
    InstallerLangEditComboBox.ItemIndex:=InstallerLangEditComboBox.Items.Count-1;
  end else begin
    InstallerLangEditComboBox.ItemIndex:=SelLang;
  end;

  InstallerLangEditComboBox.OnChange:=InstallerLangEditComboBoxChange;
end;

procedure TSetupFrameLanguage.TimerTimer(Sender: TObject);
begin
  dec(LangTimerCounter);
  If LangTimerCounter=0 then Timer.Enabled:=False;
  ReadCurrentInstallerLanguage;
end;


end.
