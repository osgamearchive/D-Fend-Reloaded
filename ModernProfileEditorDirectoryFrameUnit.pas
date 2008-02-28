unit ModernProfileEditorDirectoryFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorDirectoryFrame = class(TFrame, IModernProfileEditorFrame)
    ScreenshotFolderEdit: TLabeledEdit;
    ScreenshotFolderEditButton: TSpeedButton;
    GenerateScreenshotFolderNameButton: TBitBtn;
    DataFolderEdit: TLabeledEdit;
    DataFolderEditButton: TSpeedButton;
    GenerateGameDataFolderNameButton: TBitBtn;
    ExtraDirsLabel: TLabel;
    ExtraDirsListBox: TListBox;
    ExtraDirsAddButton: TSpeedButton;
    ExtraDirsEditButton: TSpeedButton;
    ExtraDirsDelButton: TSpeedButton;
    ExtraDirsInfoLabel: TLabel;
    DataFolderInfoLabel: TLabel;
    Timer: TTimer;
    procedure ExtraDirsListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ExtraDirsListBoxClick(Sender: TObject);
    procedure ExtraDirsListBoxDblClick(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure GenerateScreenshotFolderNameButtonClick(Sender: TObject);
    procedure GenerateGameDataFolderNameButtonClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private-Deklarationen }
    FCurrentProfileName : PString;
    FLastCurrentProfileName : String;
  public
    { Public-Deklarationen }
    Procedure InitGUI(const OnProfileNameChange : TTextEvent; const GameDB: TGameDB; const CurrentProfileName, CurrentProfileExe, CurrentProfileSetup : PString);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Function CheckValue : Boolean;
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses Math, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, CommonTools,
     PrgConsts;

{$R *.dfm}

{ TModernProfileEditorDirectoryFrame }

procedure TModernProfileEditorDirectoryFrame.InitGUI(const OnProfileNameChange: TTextEvent; const GameDB: TGameDB; const CurrentProfileName, CurrentProfileExe, CurrentProfileSetup : PString);
begin
  NoFlicker(ScreenshotFolderEdit);
  NoFlicker(DataFolderEdit);
  NoFlicker(ExtraDirsListBox);

  FCurrentProfileName:=CurrentProfileName;

  ScreenshotFolderEdit.EditLabel.Caption:=LanguageSetup.ProfileEditorCaptureFolder;
  ScreenshotFolderEditButton.Hint:=LanguageSetup.ChooseFile;
  GenerateScreenshotFolderNameButton.Caption:=LanguageSetup.ProfileEditorGenerateScreenshotFolderName;

  DataFolderEdit.EditLabel.Caption:=LanguageSetup.GameDataDir;
  DataFolderEditButton.Hint:=LanguageSetup.ChooseFile;
  DataFolderInfoLabel.Caption:=LanguageSetup.GameDataDirEditInfo;
  GenerateGameDataFolderNameButton.Caption:=LanguageSetup.ProfileEditorGenerateGameDataFolder;

  ExtraDirsLabel.Caption:=LanguageSetup.ProfileEditorExtraDirs;
  ExtraDirsAddButton.Hint:=RemoveUnderline(LanguageSetup.Add);
  ExtraDirsEditButton.Hint:=RemoveUnderline(LanguageSetup.Edit);
  ExtraDirsDelButton.Hint:=RemoveUnderline(LanguageSetup.Del);
  ExtraDirsInfoLabel.Caption:=LanguageSetup.ProfileEditorExtraDirsEditInfo;

  FLastCurrentProfileName:='';
end;

procedure TModernProfileEditorDirectoryFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var St : TStringList;
begin
  If Trim(Game.CaptureFolder)<>''
    then ScreenshotFolderEdit.Text:=Game.CaptureFolder
    else ScreenshotFolderEdit.Text:=MakeRelPath(IncludeTrailingPathDelimiter(PrgDataDir+CaptureSubDir),PrgSetup.BaseDir);

  FLastCurrentProfileName:=FCurrentProfileName^;
  If LoadFromTemplate and PrgSetup.AlwaysSetScreenshotFolderAutomatically then Timer.Enabled:=True;

  DataFolderEdit.Text:=Game.DataDir;

  St:=ValueToList(Game.ExtraDirs); try ExtraDirsListBox.Items.AddStrings(St); finally St.Free; end;
  If ExtraDirsListBox.Items.Count>0 then ExtraDirsListBox.ItemIndex:=0;
  ExtraDirsListBoxClick(nil);
end;

procedure TModernProfileEditorDirectoryFrame.TimerTimer(Sender: TObject);
Var S,DefaultFolder,OldFolder : String;
begin
  If FLastCurrentProfileName=FCurrentProfileName^ then exit;

  S:=Trim(ExtUpperCase(ScreenshotFolderEdit.Text));

  DefaultFolder:=Trim(ExtUpperCase(MakeRelPath(IncludeTrailingPathDelimiter(PrgDataDir+CaptureSubDir),PrgSetup.BaseDir)));
  OldFolder:=Trim(ExtUpperCase('.\'+CaptureSubDir+'\'+MakeFileSysOKFolderName(FLastCurrentProfileName)+'\'));

  If (S=DefaultFolder) or (S=OldFolder) then begin
    ScreenshotFolderEdit.Text:='.\'+CaptureSubDir+'\'+MakeFileSysOKFolderName(FCurrentProfileName^)+'\';
    FLastCurrentProfileName:=FCurrentProfileName^;
  end else begin
    Timer.Enabled:=False;
  end;
end;

function TModernProfileEditorDirectoryFrame.CheckValue: Boolean;
begin
  result:=True;
end;

procedure TModernProfileEditorDirectoryFrame.GetGame(const Game: TGame);
begin
  Game.CaptureFolder:=ScreenshotFolderEdit.Text;
  Game.DataDir:=DataFolderEdit.Text;
  Game.ExtraDirs:=ListToValue(ExtraDirsListBox.Items);
  Timer.Enabled:=False;
end;

procedure TModernProfileEditorDirectoryFrame.ExtraDirsListBoxClick(Sender: TObject);
begin
  ExtraDirsEditButton.Enabled:=(ExtraDirsListBox.ItemIndex>=0);
  ExtraDirsDelButton.Enabled:=(ExtraDirsListBox.ItemIndex>=0);
end;

procedure TModernProfileEditorDirectoryFrame.ExtraDirsListBoxDblClick(Sender: TObject);
begin
  ButtonWork(ExtraDirsEditButton);
end;

procedure TModernProfileEditorDirectoryFrame.ExtraDirsListBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Shift<>[] then exit;
  Case Key of
    VK_INSERT : ButtonWork(ExtraDirsAddButton);
    VK_RETURN : ButtonWork(ExtraDirsEditButton);
    VK_DELETE : ButtonWork(ExtraDirsDelButton);
  end;
end;

procedure TModernProfileEditorDirectoryFrame.ButtonWork(Sender: TObject);
Var S : String;
    I : Integer;
begin
  Case (Sender as TSpeedButton).Tag of
    0 : begin
          S:=PrgSetup.BaseDir;
          If Trim(ScreenshotFolderEdit.Text)=''
            then S:=PrgSetup.BaseDir+CaptureSubDir+'\'
            else S:=MakeAbsPath(IncludeTrailingPathDelimiter(ScreenshotFolderEdit.Text),S);
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          S:=MakeRelPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          ScreenshotFolderEdit.Text:=IncludeTrailingPathDelimiter(S);
        end;
    1 : begin
          If PrgSetup.DataDir='' then S:=PrgSetup.BaseDir else S:=PrgSetup.DataDir;
          If Trim(DataFolderEdit.Text)<>'' then
            S:=MakeAbsPath(DataFolderEdit.Text,S);
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          S:=MakeRelPath(S,PrgSetup.BaseDir);
          If S='' then exit;
          DataFolderEdit.Text:=S;
        end;
    2 : begin
          If Trim(PrgSetup.GameDir)='' then S:=PrgSetup.BaseDir else S:=PrgSetup.GameDir;
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          ExtraDirsListBox.Items.Add(MakeRelPath(S,PrgSetup.BaseDir));
          ExtraDirsListBox.ItemIndex:=ExtraDirsListBox.Items.count-1;
          ExtraDirsListBoxClick(Sender);
        end;
    3 : If ExtraDirsListBox.ItemIndex>=0 then begin
          S:=MakeAbsPath(ExtraDirsListBox.Items[ExtraDirsListBox.ItemIndex],PrgSetup.BaseDir);
          if not SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then exit;
          ExtraDirsListBox.Items[ExtraDirsListBox.ItemIndex]:=MakeRelPath(S,PrgSetup.BaseDir);
        end;
    4 : begin
          I:=ExtraDirsListBox.ItemIndex;
          if I<0 then exit;
          ExtraDirsListBox.Items.Delete(I);
          If ExtraDirsListBox.Items.Count>0 then ExtraDirsListBox.ItemIndex:=Max(0,I-1);
          ExtraDirsListBoxClick(Sender);
        end;
  end;
end;

procedure TModernProfileEditorDirectoryFrame.GenerateScreenshotFolderNameButtonClick(Sender: TObject);
begin
  ScreenshotFolderEdit.Text:='.\'+CaptureSubDir+'\'+MakeFileSysOKFolderName(FCurrentProfileName^)+'\';
end;

procedure TModernProfileEditorDirectoryFrame.GenerateGameDataFolderNameButtonClick(Sender: TObject);
Var S,T : String;
begin
  If PrgSetup.DataDir='' then S:=PrgSetup.BaseDir else S:=PrgSetup.DataDir;
  S:=IncludeTrailingPathDelimiter(S)+FCurrentProfileName^+'\';
  T:=MakeRelPath(S,PrgSetup.BaseDir);
  If T<>'' then DataFolderEdit.Text:=T;
  If DirectoryExists(S) then exit;
  If MessageDlg(Format(LanguageSetup.MessageConfirmationCreateDir,[S]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
  ForceDirectories(S);
end;

end.
