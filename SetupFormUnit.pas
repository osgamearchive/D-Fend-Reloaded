unit SetupFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, Menus, GameDBUnit, CheckLst,
  Spin;

type
  TSetupForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    PageControl: TPageControl;
    GeneralSheet: TTabSheet;
    DefaultValueSheet: TTabSheet;
    ServiceSheet: TTabSheet;
    BaseDirButton: TSpeedButton;
    BaseDirEdit: TLabeledEdit;
    DefaultValueLabel: TLabel;
    DefaultValueComboBox: TComboBox;
    DefaultValueSpeedButton: TSpeedButton;
    DefaultValuePopupMenu: TPopupMenu;
    PopupThisValue: TMenuItem;
    PopupAllValues: TMenuItem;
    Service1Button: TBitBtn;
    Service2Button: TBitBtn;
    ReopenLastActiveProfileSheetCheckBox: TCheckBox;
    DefaultValueMemo: TRichEdit;
    DosBoxSheet: TTabSheet;
    DosBoxDirEdit: TLabeledEdit;
    DosBoxButton: TSpeedButton;
    FindDosBoxButton: TSpeedButton;
    DosBoxLngOpenDialog: TOpenDialog;
    HideDosBoxConsoleCheckBox: TCheckBox;
    MinimizeDFendCheckBox: TCheckBox;
    RestoreWindowSizeCheckBox: TCheckBox;
    MinimizeToTrayCheckBox: TCheckBox;
    LanguageSheet: TTabSheet;
    LanguageLabel: TLabel;
    LanguageComboBox: TComboBox;
    DosBoxLangLabel: TLabel;
    GameDirEdit: TLabeledEdit;
    GameDirButton: TSpeedButton;
    SecuritySheet: TTabSheet;
    AskBeforeDeleteCheckBox: TCheckBox;
    DeleteProectionCheckBox: TCheckBox;
    DeleteProectionLabel: TLabel;
    ListViewSheet: TTabSheet;
    ListViewLabel: TLabel;
    ListViewListBox: TCheckListBox;
    ListViewUpButton: TSpeedButton;
    ListViewDownButton: TSpeedButton;
    ColDefaultValueSpeedButton: TSpeedButton;
    DataDirEdit: TLabeledEdit;
    DataDirButton: TSpeedButton;
    DosBoxLangEditComboBox: TComboBox;
    ScreenshotPreviewLabel: TLabel;
    ScreenshotPreviewEdit: TSpinEdit;
    Service3Button: TBitBtn;
    Service4Button: TBitBtn;
    DosBoxMapperEdit: TLabeledEdit;
    DosBoxMapperButton: TSpeedButton;
    DosBoxTxtOpenDialog: TOpenDialog;
    SDLVideodriverLabel: TLabel;
    SDLVideoDriverComboBox: TComboBox;
    SDLVideodriverInfoLabel: TLabel;
    AddButtonFunctionLabel: TLabel;
    AddButtonFunctionComboBox: TComboBox;
    StartWithWindowsCheckBox: TCheckBox;
    StartMinimizedCheckBox: TCheckBox;
    procedure OKButtonClick(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DefaultValueComboBoxChange(Sender: TObject);
    procedure DefaultValueSpeedButtonClick(Sender: TObject);
    procedure PopupMenuWork(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UpgradeButtonClick(Sender: TObject);
    procedure DosBoxDirEditChange(Sender: TObject);
    procedure ListViewMoveButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LanguageComboBoxChange(Sender: TObject);
  private
    { Private-Deklarationen }
    JustLoading : Boolean;
    DosBoxLang : TStringList;
    LastIndex : Integer;
    Procedure InitGUI;
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
  end;

var
  SetupForm: TSetupForm;

Function ShowSetupDialog(const AOwner : TComponent; const AGameDB : TGameDB; const OpenLanguageTag : Boolean = False) : Boolean;

implementation

uses Math, LanguageSetupUnit, PrgSetupUnit, VistaToolsUnit, CommonTools,
     SetupDosBoxFormUnit, GameDBToolsUnit, PrgConsts;

{$R *.dfm}

procedure TSetupForm.FormCreate(Sender: TObject);
begin
  DosBoxLang:=TStringList.Create;
  JustLoading:=False;
end;

procedure TSetupForm.FormDestroy(Sender: TObject);
Var I : Integer;
begin
  for I:=0 to DefaultValueComboBox.Items.Count-1 do TStringList(DefaultValueComboBox.Items.Objects[I]).Free;
  DosBoxLang.Free;
end;

Procedure GetColOrderAndVisible(var O,V : String);
begin
  V:=PrgSetup.ColVisible;
  while length(V)<6 do V:=V+'1';
  If Length(V)>6 then V:=Copy(V,1,6);
  PrgSetup.ColVisible:=V;

  O:=PrgSetup.ColOrder;
  while length(O)<6 do O:=O+'1';
  If Length(O)>6 then O:=Copy(O,1,6);
  PrgSetup.ColOrder:=O;
end;

procedure TSetupForm.InitGUI;
Var I : Integer;
begin
  Caption:=LanguageSetup.SetupForm;
  GeneralSheet.Caption:=LanguageSetup.SetupFormGeneralSheet;
  LanguageSheet.Caption:=LanguageSetup.SetupFormLanguageSheet;
  ListViewSheet.Caption:=LanguageSetup.SetupFormListViewSheet;
  DosBoxSheet.Caption:=LanguageSetup.SetupFormDosBoxSheet;
  SecuritySheet.Caption:=LanguageSetup.SetupFormSecuritySheet;
  DefaultValueSheet.Caption:=LanguageSetup.SetupFormDefaultValueSheet;
  ServiceSheet.Caption:=LanguageSetup.SetupFormServiceSheet;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;

  BaseDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormBaseDir;
  BaseDirButton.Hint:=LanguageSetup.ChooseFolder;
  GameDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormGameDir;
  GameDirButton.Hint:=LanguageSetup.ChooseFolder;
  DataDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormDataDir;
  DataDirButton.Hint:=LanguageSetup.ChooseFolder;
  ReopenLastActiveProfileSheetCheckBox.Caption:=LanguageSetup.SetupFormReopenLastActiveProfileSheet;
  RestoreWindowSizeCheckBox.Caption:=LanguageSetup.SetupFormRestoreWindowSize;
  MinimizeToTrayCheckBox.Caption:=LanguageSetup.SetupFormMinimizeToTray;
  StartWithWindowsCheckBox.Caption:=LanguageSetup.SetupFormStartWithWindows;
  StartMinimizedCheckBox.Caption:=LanguageSetup.SetupFormStartMinimized;

  AddButtonFunctionLabel.Caption:=LanguageSetup.SetupFormAddButtonFunctionLabel;
  I:=AddButtonFunctionComboBox.ItemIndex;
  AddButtonFunctionComboBox.Items[0]:=LanguageSetup.SetupFormAddButtonFunctionAdd;
  AddButtonFunctionComboBox.Items[1]:=LanguageSetup.SetupFormAddButtonFunctionWizard;
  AddButtonFunctionComboBox.Items[2]:=LanguageSetup.SetupFormAddButtonFunctionMenu;
  AddButtonFunctionComboBox.ItemIndex:=I;

  LanguageLabel.Caption:=LanguageSetup.SetupFormLanguage;
  DosBoxLangLabel.Caption:=LanguageSetup.SetupFormDosBoxLang;

  ListViewLabel.Caption:=LanguageSetup.SetupFormListViewInfo;
  ColDefaultValueSpeedButton.Hint:=LanguageSetup.SetupFormDefaultValueReset;
  ScreenshotPreviewLabel.Caption:=LanguageSetup.SetupFormScreenshotPreviewSize;

  DosBoxDirEdit.EditLabel.Caption:=LanguageSetup.SetupFormDosBoxDir;
  DosBoxButton.Hint:=LanguageSetup.ChooseFolder;

  DosBoxMapperEdit.EditLabel.Caption:=LanguageSetup.SetupFormDosBoxMapperFile;
  DosBoxMapperButton.Hint:=LanguageSetup.ChooseFile;

  FindDosBoxButton.Hint:=LanguageSetup.SetupFormSearchDosBox;
  HideDosBoxConsoleCheckBox.Caption:=LanguageSetup.SetupFormHideDosBoxConsole;
  MinimizeDFendCheckBox.Caption:=LanguageSetup.SetupFormMinimizeDFend;
  SDLVideodriverLabel.Caption:=LanguageSetup.SetupFormDosBoxSDLVideodriver;
  SDLVideodriverInfoLabel.Caption:=LanguageSetup.SetupFormDosBoxSDLVideodriverInfo;

  AskBeforeDeleteCheckBox.Caption:=LanguageSetup.SetupFormAskBeforeDelete;
  DeleteProectionCheckBox.Caption:=LanguageSetup.SetupFormDeleteOnlyInBaseDir;
  DeleteProectionLabel.Caption:=LanguageSetup.SetupFormDeleteOnlyInBaseDirLabel;

  DefaultValueLabel.Caption:=LanguageSetup.SetupFormDefaultValueLabel;
  DefaultValueSpeedButton.Hint:=LanguageSetup.SetupFormDefaultValueReset;
  PopupThisValue.Caption:=LanguageSetup.SetupFormDefaultValueResetThis;
  PopupAllValues.Caption:=LanguageSetup.SetupFormDefaultValueResetAll;
  I:=DefaultValueComboBox.ItemIndex;
  DefaultValueComboBox.Items.Clear;
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameResolution,ValueToList(GameDB.ConfOpt.Resolution,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameJoysticks,ValueToList(GameDB.ConfOpt.Joysticks,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameScale,ValueToList(GameDB.ConfOpt.Scale,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameRender,ValueToList(GameDB.ConfOpt.Render,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameCycles,ValueToList(GameDB.ConfOpt.Cycles,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameVideo,ValueToList(GameDB.ConfOpt.Video,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameMemory,ValueToList(GameDB.ConfOpt.Memory,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameFrameskip,ValueToList(GameDB.ConfOpt.Frameskip,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameCore,ValueToList(GameDB.ConfOpt.Core,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameSblaster,ValueToList(GameDB.ConfOpt.Sblaster,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameOplmode,ValueToList(GameDB.ConfOpt.Oplmode,';,'));
  DefaultValueComboBox.Items.AddObject(LanguageSetup.GameKeyboardLayout,ValueToList(GameDB.ConfOpt.KeyboardLayout,';,'));
  DefaultValueComboBox.ItemIndex:=I;

  Service1Button.Caption:=LanguageSetup.SetupFormService1;
  Service2Button.Caption:=LanguageSetup.SetupFormService2;
  Service3Button.Caption:=LanguageSetup.SetupFormService3;
  Service4Button.Caption:=LanguageSetup.SetupFormService4;
end;


procedure TSetupForm.FormShow(Sender: TObject);
Var S,T : String;
    I,J,Nr : Integer;
    Rec : TSearchRec;
    B : Boolean;
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);

  InitGUI;

  JustLoading:=True;
  try
    BaseDirEdit.Text:=PrgSetup.BaseDir;
    GameDirEdit.Text:=PrgSetup.GameDir;
    DataDirEdit.Text:=PrgSetup.DataDir;
    ReopenLastActiveProfileSheetCheckBox.Checked:=PrgSetup.ReopenLastProfileEditorTab;
    RestoreWindowSizeCheckBox.Checked:=PrgSetup.RestoreWindowSize;
    MinimizeToTrayCheckBox.Checked:=PrgSetup.MinimizeToTray;
    StartWithWindowsCheckBox.Checked:=PrgSetup.StartWithWindows;
    StartMinimizedCheckBox.Checked:=PrgSetup.StartMinimized;
    AddButtonFunctionComboBox.ItemIndex:=Min(2,Max(0,PrgSetup.AddButtonFunction));

    GetColOrderAndVisible(S,T);
    For I:=0 to 5 do begin
      try Nr:=StrToInt(S[I+1]); except Nr:=-1; end;
      If (Nr<1) or (Nr>6) then continue;

      Case Nr-1 of
        0 : ListViewListBox.Items.AddObject(LanguageSetup.GameSetup,Pointer(Nr-1));
        1 : ListViewListBox.Items.AddObject(LanguageSetup.GameGenre,Pointer(Nr-1));
        2 : ListViewListBox.Items.AddObject(LanguageSetup.GameDeveloper,Pointer(Nr-1));
        3 : ListViewListBox.Items.AddObject(LanguageSetup.GamePublisher,Pointer(Nr-1));
        4 : ListViewListBox.Items.AddObject(LanguageSetup.GameYear,Pointer(Nr-1));
        5 : ListViewListBox.Items.AddObject(LanguageSetup.GameLanguage,Pointer(Nr-1));
      end;
      ListViewListBox.Checked[ListViewListBox.Items.Count-1]:=(T[Nr]<>'0');
    end;
    For I:=0 to 5 do begin
      B:=False;
      For J:=0 to ListViewListBox.Items.Count-1 do If Integer(ListViewListBox.Items.Objects[J])=I then begin
        B:=True; break;
      end;
      If not B then Case I of
        0 : ListViewListBox.Items.AddObject(LanguageSetup.GameSetup,Pointer(I));
        1 : ListViewListBox.Items.AddObject(LanguageSetup.GameGenre,Pointer(I));
        2 : ListViewListBox.Items.AddObject(LanguageSetup.GameDeveloper,Pointer(I));
        3 : ListViewListBox.Items.AddObject(LanguageSetup.GamePublisher,Pointer(I));
        4 : ListViewListBox.Items.AddObject(LanguageSetup.GameYear,Pointer(I));
        5 : ListViewListBox.Items.AddObject(LanguageSetup.GameLanguage,Pointer(I));
      end;
    end;
    ScreenshotPreviewEdit.Value:=Max(ScreenshotPreviewEdit.MinValue,Min(ScreenshotPreviewEdit.MaxValue,PrgSetup.ScreenshotPreviewSize));

    DosBoxDirEdit.Text:=PrgSetup.DosBoxDir;
    DosBoxDirEditChange(Sender);
    DosBoxMapperEdit.Text:=PrgSetup.DosBoxMapperFile;
    HideDosBoxConsoleCheckBox.Checked:=PrgSetup.HideDosBoxConsole;
    MinimizeDFendCheckBox.Checked:=PrgSetup.MinimizeOnDosBoxStart;
    If Trim(ExtUpperCase(PrgSetup.SDLVideodriver))='WINDIB' then SDLVideoDriverComboBox.ItemIndex:=1 else SDLVideoDriverComboBox.ItemIndex:=0;

    AskBeforeDeleteCheckBox.Checked:=PrgSetup.AskBeforeDelete;
    DeleteProectionCheckBox.Checked:=PrgSetup.DeleteOnlyInBaseDir;

    DefaultValueComboBox.ItemIndex:=0; LastIndex:=-1;
    DefaultValueComboBoxChange(Sender);

    I:=FindFirst(PrgDir+LanguageSubDir+'\*.ini',faAnyFile,Rec);
    try
      while I=0 do begin
        LanguageComboBox.Items.Add(Copy(Rec.Name,1,length(Rec.Name)-4));
        I:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;
    S:=Trim(PrgSetup.Language);
    If (length(S)>4) and (ExtUpperCase(Copy(S,length(S)-3,4))='.INI') then begin
      S:=Trim(Copy(S,1,length(S)-4));
      LanguageComboBox.ItemIndex:=-1;
      For I:=0 to LanguageComboBox.Items.Count-1 do If ExtUpperCase(LanguageComboBox.Items[I])=ExtUpperCase(S) then begin
        LanguageComboBox.ItemIndex:=I; break;
      end;
    end;
    If (LanguageComboBox.Items.Count>0) and (LanguageComboBox.ItemIndex<0) then LanguageComboBox.ItemIndex:=0;

    I:=DosBoxLang.IndexOf(PrgSetup.DosBoxLanguage);
    If I>=0 then DosBoxLangEditComboBox.ItemIndex:=I else DosBoxLangEditComboBox.ItemIndex:=0;
  finally
    JustLoading:=False;
  end;
end;

procedure TSetupForm.OKButtonClick(Sender: TObject);
Var I : Integer;
    S : String;
begin
  SetStartWithWindows(PrgSetup.StartWithWindows);

  PrgSetup.BaseDir:=IncludeTrailingPathDelimiter(BaseDirEdit.Text);
  PrgSetup.GameDir:=IncludeTrailingPathDelimiter(GameDirEdit.Text);
  PrgSetup.DataDir:=IncludeTrailingPathDelimiter(DataDirEdit.Text);
  PrgSetup.ReopenLastProfileEditorTab:=ReopenLastActiveProfileSheetCheckBox.Checked;
  PrgSetup.RestoreWindowSize:=RestoreWindowSizeCheckBox.Checked;
  PrgSetup.MinimizeToTray:=MinimizeToTrayCheckBox.Checked;
  PrgSetup.StartWithWindows:=StartWithWindowsCheckBox.Checked;
  PrgSetup.StartMinimized:=StartMinimizedCheckBox.Checked;
  PrgSetup.AddButtonFunction:=AddButtonFunctionComboBox.ItemIndex;

  PrgSetup.Language:=LanguageComboBox.Text+'.ini';

  PrgSetup.DosBoxLanguage:=DosBoxLang[DosBoxLangEditComboBox.ItemIndex];

  S:='';
  For I:=0 to ListViewListBox.Items.Count-1 do S:=S+IntToStr(Integer(ListViewListBox.Items.Objects[I])+1);
  PrgSetup.ColOrder:=S;

  S:='';
  For I:=0 to ListViewListBox.Items.Count-1 do If Integer(ListViewListBox.Items.Objects[I])=I then begin
    If ListViewListBox.Checked[I] then S:=S+'1' else S:=S+'0';
  end;
  PrgSetup.ColVisible:=S;
  PrgSetup.ScreenshotPreviewSize:=ScreenshotPreviewEdit.Value;

  PrgSetup.DosBoxDir:=IncludeTrailingPathDelimiter(DosBoxDirEdit.Text);
  PrgSetup.DosBoxMapperFile:=DosBoxMapperEdit.Text;
  PrgSetup.HideDosBoxConsole:=HideDosBoxConsoleCheckBox.Checked;
  PrgSetup.MinimizeOnDosBoxStart:=MinimizeDFendCheckBox.Checked;
  If SDLVideoDriverComboBox.ItemIndex=1 then PrgSetup.SDLVideodriver:='WinDIB' else PrgSetup.SDLVideodriver:='DirectX';

  PrgSetup.AskBeforeDelete:=AskBeforeDeleteCheckBox.Checked;  
  PrgSetup.DeleteOnlyInBaseDir:=DeleteProectionCheckBox.Checked;

  GameDB.ConfOpt.Resolution:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[0]),',');
  GameDB.ConfOpt.Joysticks:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[1]),',');
  GameDB.ConfOpt.Scale:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[2]),',');
  GameDB.ConfOpt.Render:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[3]),',');
  GameDB.ConfOpt.Cycles:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[4]),',');
  GameDB.ConfOpt.Video:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[5]),',');
  GameDB.ConfOpt.Memory:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[6]),',');
  GameDB.ConfOpt.Frameskip:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[7]),',');
  GameDB.ConfOpt.Core:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[8]),',');
  GameDB.ConfOpt.Sblaster:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[9]),',');
  GameDB.ConfOpt.Oplmode:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[10]),',');
  GameDB.ConfOpt.KeyboardLayout:=ListToValue(TStringList(DefaultValueComboBox.Items.Objects[11]),',');
end;

procedure TSetupForm.ButtonWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          S:=BaseDirEdit.Text; If S='' then S:=PrgDataDir;
          if SelectDirectory(Handle,LanguageSetup.SetupFormBaseDir,S) then BaseDirEdit.Text:=S;
        end;
    1 : begin
          S:=GameDirEdit.Text; If S='' then S:=BaseDirEdit.Text;
          if SelectDirectory(Handle,LanguageSetup.SetupFormGameDir,S) then GameDirEdit.Text:=S;
        end;
    2 : begin
          S:=DataDirEdit.Text; If S='' then S:=BaseDirEdit.Text;
          if SelectDirectory(Handle,LanguageSetup.SetupFormDataDir,S) then DataDirEdit.Text:=S;
        end;
    3 : begin
          S:=DosBoxDirEdit.Text;
          if SelectDirectory(Handle,LanguageSetup.SetupFormBaseDir,S) then begin
            DosBoxDirEdit.Text:=S;
            DosBoxDirEditChange(Sender);
          end;
        end;
    4 : if SearchDosBox(self) then begin
          DosBoxDirEdit.Text:=PrgSetup.DosBoxDir;
          DosBoxDirEditChange(Sender);
        end;
    5 : begin
          DosBoxTxtOpenDialog.Title:=LanguageSetup.SetupFormDosBoxMapperFileTitle;
          DosBoxTxtOpenDialog.Filter:=LanguageSetup.SetupFormDosBoxMapperFileFilter;
          If Trim(DosBoxMapperEdit.Text)=''
            then DosBoxTxtOpenDialog.InitialDir:=PrgDataDir
            else DosBoxTxtOpenDialog.InitialDir:=ExtractFilePath(MakeAbsPath(DosBoxMapperEdit.Text,PrgDataDir));
          if not DosBoxTxtOpenDialog.Execute then exit;
          DosBoxMapperEdit.Text:=MakeRelPath(DosBoxTxtOpenDialog.FileName,PrgDataDir);
        end;
  end;
end;

procedure TSetupForm.DefaultValueComboBoxChange(Sender: TObject);
begin
  If LastIndex>=0 then begin
    TStringList(DefaultValueComboBox.Items.Objects[LastIndex]).Clear;
    TStringList(DefaultValueComboBox.Items.Objects[LastIndex]).Assign(DefaultValueMemo.Lines);
  end;

  LastIndex:=DefaultValueComboBox.ItemIndex;
  DefaultValueMemo.Lines.Clear;
  If LastIndex<0 then exit;
  DefaultValueMemo.Lines.Assign(TStringList(DefaultValueComboBox.Items.Objects[LastIndex]));
end;

procedure TSetupForm.DefaultValueSpeedButtonClick(Sender: TObject);
Var P : TPoint;
begin
  P:=DefaultValueSheet.ClientToScreen(Point(DefaultValueSpeedButton.Left,DefaultValueSpeedButton.Top));
  DefaultValuePopupMenu.Popup(P.X+5,P.Y+5);
end;

procedure TSetupForm.PopupMenuWork(Sender: TObject);
Var All : Boolean;
    I : Integer;
begin
  All:=((Sender as TComponent).Tag=1);

  I:=LastIndex; LastIndex:=-1;

  If (I=0) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[0]).Free;
    DefaultValueComboBox.Items.Objects[0]:=ValueToList('original,320x200,640x480,800x600,1024x768,1280x768,1280x960,1280x1024',';,');
  end;

  If (I=1) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[1]).Free;
    DefaultValueComboBox.Items.Objects[1]:=ValueToList('none,2axis,4axis,fcs,ch',';,');
  end;

  If (I=2) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[2]).Free;
    DefaultValueComboBox.Items.Objects[2]:=ValueToList('none,normal2x,advmame2x,advmame3x,advinterp2x,interp2x,tv2x',';,');
  end;

  If (I=3) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[3]).Free;
    DefaultValueComboBox.Items.Objects[3]:=ValueToList('surface,overlay,opengl,openglnb,ddraw',';,');
  end;

  If (I=4) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[4]).Free;
    DefaultValueComboBox.Items.Objects[4]:=ValueToList('500,1000,1500,2000,2500,3000,3500,4000,4500,5000,6000,7000,8000,9000,10000,11000,12000,12000,13000,14000,15000,16000,17000,18000,19000,20000',';,');
  end;

  If (I=5) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[5]).Free;
    DefaultValueComboBox.Items.Objects[5]:=ValueToList('hercules,cga,tandy,vga',';,');
  end;

  If (I=6) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[6]).Free;
    DefaultValueComboBox.Items.Objects[6]:=ValueToList('0,1,2,4,8,16,32,63',';,');
  end;

  If (I=7) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[7]).Free;
    DefaultValueComboBox.Items.Objects[7]:=ValueToList('0,1,2,3,4,5,6,7,8,9,10',';,');
  end;

  If (I=8) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[8]).Free;
    DefaultValueComboBox.Items.Objects[8]:=ValueToList('normal,full,dynamic,simple',';,');
  end;

  If (I=9) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[9]).Free;
    DefaultValueComboBox.Items.Objects[9]:=ValueToList('none,sb1,sb2,sbpro1,sbpro2,sb16',';,');
  end;

  If (I=10) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[10]).Free;
    DefaultValueComboBox.Items.Objects[10]:=ValueToList('auto,cms,opl2,dualopl2,opl3',';,');
  end;

  If (I=11) or All then begin
    TStringList(DefaultValueComboBox.Items.Objects[11]).Free;
    DefaultValueComboBox.Items.Objects[11]:=ValueToList('Default (none),Bulgaria (BG),Czech Republic (CZ243),France (FR),Greece (GK),Germany (GR),Croatia (HR),Hungary (HU),Italy (IT),Netherlands (NL),Norway (NO),Poland (PL),Russian Federation (RU),Slovakia (SK),Spain (SP),SU (Finland),Sweden (SV)',';,');
  end;

  DefaultValueComboBox.ItemIndex:=I; DefaultValueComboBoxChange(Sender);
end;

procedure TSetupForm.UpgradeButtonClick(Sender: TObject);
Var I : Integer;
begin
  Case (Sender as TComponent).Tag of
    0 : DeleteOldFiles;
    1 : ReplaceAbsoluteDirs(GameDB);
    2 : begin
          I:=GameDB.IndexOf(DosBoxDOSProfile);
          If I>=0 then begin
            If MessageDlg(LanguageSetup.SetupFormService3Confirmation,mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
            GameDB.Delete(I);
          end;
          BuildDefaultDosProfile(GameDB);
        end;
    3 : BuildDefaultProfile;
  end;
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

procedure TSetupForm.DosBoxDirEditChange(Sender: TObject);
Var S : String;
    I : Integer;
begin
  S:=DosBoxLangEditComboBox.Text;
  DosBoxLangEditComboBox.Items.Clear;
  DosBoxLang.Clear;

  DosBoxLangEditComboBox.Items.Add('Englisch');
  DosBoxLang.Add('');

  FindAndAddLngFiles(IncludeTrailingPathDelimiter(DosBoxDirEdit.Text),DosBoxLangEditComboBox.Items,DosBoxLang);
  FindAndAddLngFiles(PrgDir+LanguageSubDir+'\',DosBoxLangEditComboBox.Items,DosBoxLang);
  I:=DosBoxLangEditComboBox.Items.IndexOf(S);
  If I>=0 then DosBoxLangEditComboBox.ItemIndex:=I else DosBoxLangEditComboBox.ItemIndex:=0;
end;

procedure TSetupForm.LanguageComboBoxChange(Sender: TObject);
begin
  If JustLoading then exit;
  LoadLanguage(LanguageComboBox.Text+'.ini');
  InitGUI;
end;

procedure TSetupForm.ListViewMoveButtonClick(Sender: TObject);
Var I : Integer;
begin
  Case (Sender as TComponent).Tag of
    0 : If ListViewListBox.ItemIndex>0 then begin
          ListViewListBox.Items.Exchange(ListViewListBox.ItemIndex,ListViewListBox.ItemIndex-1);
        end;
    1 : If (ListViewListBox.ItemIndex>=0) and (ListViewListBox.ItemIndex<ListViewListBox.Items.Count-2) then begin
          ListViewListBox.Items.Exchange(ListViewListBox.ItemIndex,ListViewListBox.ItemIndex+1);
        end;
    2 : begin
          ListViewListBox.Clear;
          For I:=0 to 5 do begin
            Case I of
              0 : ListViewListBox.Items.AddObject(LanguageSetup.GameSetup,Pointer(I));
              1 : ListViewListBox.Items.AddObject(LanguageSetup.GameGenre,Pointer(I));
              2 : ListViewListBox.Items.AddObject(LanguageSetup.GameDeveloper,Pointer(I));
              3 : ListViewListBox.Items.AddObject(LanguageSetup.GamePublisher,Pointer(I));
              4 : ListViewListBox.Items.AddObject(LanguageSetup.GameYear,Pointer(I));
              5 : ListViewListBox.Items.AddObject(LanguageSetup.GameLanguage,Pointer(I));
            end;
            ListViewListBox.Checked[ListViewListBox.Items.Count-1]:=True;
        end;
    end;
  end;
end;

{ global }

Function ShowSetupDialog(const AOwner : TComponent; const AGameDB : TGameDB; const OpenLanguageTag : Boolean) : Boolean;
begin
  SetupForm:=TSetupForm.Create(AOwner);
  try
    SetupForm.GameDB:=AGameDB;
    if OpenLanguageTag then SetupForm.PageControl.ActivePageIndex:=SetupForm.LanguageSheet.PageIndex;
    result:=(SetupForm.ShowModal=mrOK);
  finally
    SetupForm.Free;
  end;
end;

end.
