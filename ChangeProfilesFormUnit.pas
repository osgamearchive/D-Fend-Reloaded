unit ChangeProfilesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, Menus, CheckLst, GameDBUnit;

type
  TChangeProfilesForm = class(TForm)
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    SelectAllButton: TBitBtn;
    SelectNoneButton: TBitBtn;
    SelectGenreButton: TBitBtn;
    ListBox: TCheckListBox;
    InfoLabel: TLabel;
    PopupMenu: TPopupMenu;
    GenreCheckBox: TCheckBox;
    GenreComboBox: TComboBox;
    DeveloperCheckBox: TCheckBox;
    DeveloperComboBox: TComboBox;
    PublisherCheckBox: TCheckBox;
    PublisherComboBox: TComboBox;
    YearCheckBox: TCheckBox;
    YearComboBox: TComboBox;
    LanguageCheckBox: TCheckBox;
    LanguageComboBox: TComboBox;
    FavouriteCheckBox: TCheckBox;
    FavouriteComboBox: TComboBox;
    CloseOnExitCheckBox: TCheckBox;
    CloseOnExitComboBox: TComboBox;
    StartFullscreenCheckBox: TCheckBox;
    StartFullscreenComboBox: TComboBox;
    LockMouseCheckBox: TCheckBox;
    LockMouseComboBox: TComboBox;
    UseDoublebufferCheckBox: TCheckBox;
    UseDoublebufferComboBox: TComboBox;
    RenderCheckBox: TCheckBox;
    RenderComboBox: TComboBox;
    MemoryCheckBox: TCheckBox;
    MemoryComboBox: TComboBox;
    CPUCyclesCheckBox: TCheckBox;
    CPUCyclesComboBox: TComboBox;
    EmulationCoreCheckBox: TCheckBox;
    EmulationCoreComboBox: TComboBox;
    WindowResolutionCheckBox: TCheckBox;
    WindowResolutionComboBox: TComboBox;
    FullscreenResolutionComboBox: TComboBox;
    ScaleComboBox: TComboBox;
    FullscreenResolutionCheckBox: TCheckBox;
    ScaleCheckBox: TCheckBox;
    KeyboardLayoutCheckBox: TCheckBox;
    KeyboardLayoutComboBox: TComboBox;
    CodepageCheckBox: TCheckBox;
    CodepageComboBox: TComboBox;
    TabSheet3: TTabSheet;
    SetUserInfoCheckBox: TCheckBox;
    DelUserInfoCheckBox: TCheckBox;
    SetUserInfoComboBox: TComboBox;
    SetUserInfoEdit: TEdit;
    DelUserInfoComboBox: TComboBox;
    HelpButton: TBitBtn;
    AspectCheckBox: TCheckBox;
    AspectComboBox: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure CheckBoxClick(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    Function GetAllUserInfoKeys : TStringList;
    Procedure SetUserInfo(const G : TGame; const Key, Value : String);
    Procedure DelUserInfo(const G : TGame; const Key : String);
  public
    { Public-Deklarationen }
    TemplateMode : Boolean;
    GameDB : TGameDB;
  end;

var
  ChangeProfilesForm: TChangeProfilesForm;

Function ShowChangeProfilesDialog(const AOwner : TComponent; const AGameDB : TGameDB; const TemplateMode : Boolean = False) : Boolean;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, PrgConsts, CommonTools,
     GameDBToolsUnit, HelpConsts;

{$R *.dfm}

procedure TChangeProfilesForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  PageControl.ActivePageIndex:=0;

  TemplateMode:=False;
end;

Function TChangeProfilesForm.GetAllUserInfoKeys : TStringList;
Var I,J,K : Integer;
    St, Upper : TStringList;
    S : String;
begin
  Upper:=TStringList.Create;
  result:=TStringList.Create;
  try
    For I:=0 to GameDB.Count-1 do begin
      St:=StringToStringList(GameDB[I].UserInfo);
      try
        For J:=0 to St.Count-1 do begin
          S:=Trim(St[J]);
          K:=Pos('=',S); If K=0 then continue;
          S:=Trim(Copy(S,1,K-1));
          If S='' then continue;
          If Upper.IndexOf(ExtUpperCase(S))<0 then begin
            result.Add(S);
            Upper.Add(ExtUpperCase(S));
          end;
        end;
      finally
        St.Free;
      end;
    end;
  finally
    Upper.Free;
  end;
end;

procedure TChangeProfilesForm.FormShow(Sender: TObject);
Var St : TStringList;
begin
  If TemplateMode then begin
    Caption:=LanguageSetup.ChangeProfilesFormCaption2;
    TabSheet1.Caption:=LanguageSetup.ChangeProfilesFormSelectGamesSheet2;
    InfoLabel.Caption:=LanguageSetup.ChangeProfilesFormInfo2;
  end else begin
    Caption:=LanguageSetup.ChangeProfilesFormCaption;
    TabSheet1.Caption:=LanguageSetup.ChangeProfilesFormSelectGamesSheet;
    InfoLabel.Caption:=LanguageSetup.ChangeProfilesFormInfo;
  end;

  BuildCheckList(ListBox,GameDB,False,False);
  BuildSelectPopupMenu(PopupMenu,GameDB,SelectButtonClick,False);

  TabSheet2.Caption:=LanguageSetup.ChangeProfilesFormEditProfileSheet+' (1)';
  TabSheet3.Caption:=LanguageSetup.ChangeProfilesFormEditProfileSheet+' (2)';
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;
  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;
  SelectGenreButton.Caption:=LanguageSetup.GameBy;

  { Page 1}

  GenreCheckBox.Caption:=LanguageSetup.GameGenre;
  St:=GameDB.GetGenreList; try GenreComboBox.Items.Assign(St); finally St.Free; end;
  DeveloperCheckBox.Caption:=LanguageSetup.GameDeveloper;
  St:=GameDB.GetDeveloperList; try DeveloperComboBox.Items.Assign(St); finally St.Free; end;
  PublisherCheckBox.Caption:=LanguageSetup.GamePublisher;
  St:=GameDB.GetPublisherList; try PublisherComboBox.Items.Assign(St); finally St.Free; end;
  YearCheckBox.Caption:=LanguageSetup.GameYear;
  St:=GameDB.GetYearList; try YearComboBox.Items.Assign(St); finally St.Free; end;
  LanguageCheckBox.Caption:=LanguageSetup.GameLanguage;
  St:=GameDB.GetLanguageList; try LanguageComboBox.Items.Assign(St); finally St.Free; end;
  FavouriteCheckBox.Caption:=LanguageSetup.GameFavorite;
  with FavouriteComboBox do begin Items.Add(RemoveUnderline(LanguageSetup.No)); Items.Add(RemoveUnderline(LanguageSetup.Yes)); ItemIndex:=0; end;

  SetUserInfoCheckBox.Caption:=LanguageSetup.ChangeProfilesFormSetUserInfo;
  DelUserInfoCheckBox.Caption:=LanguageSetup.ChangeProfilesFormDelUserInfo;
  St:=GetAllUserInfoKeys; try SetUserInfoComboBox.Items.Assign(St); DelUserInfoComboBox.Items.Assign(St); finally St.Free; end;
  If SetUserInfoComboBox.Items.Count>0 then SetUserInfoComboBox.ItemIndex:=0;
  If DelUserInfoComboBox.Items.Count>0 then DelUserInfoComboBox.ItemIndex:=0 else DelUserInfoCheckBox.Enabled:=False;

  { Page 2 }

  CloseOnExitCheckBox.Caption:=LanguageSetup.GameCloseDosBoxAfterGameExit;
  with CloseOnExitComboBox do begin Items.Add(RemoveUnderline(LanguageSetup.No)); Items.Add(RemoveUnderline(LanguageSetup.Yes)); ItemIndex:=0; end;
  StartFullscreenCheckBox.Caption:=LanguageSetup.GameStartFullscreen;
  with StartFullscreenComboBox do begin Items.Add(RemoveUnderline(LanguageSetup.No)); Items.Add(RemoveUnderline(LanguageSetup.Yes)); ItemIndex:=0; end;
  LockMouseCheckBox.Caption:=LanguageSetup.GameAutoLockMouse;
  with LockMouseComboBox do begin Items.Add(RemoveUnderline(LanguageSetup.No)); Items.Add(RemoveUnderline(LanguageSetup.Yes)); ItemIndex:=0; end;
  UseDoublebufferCheckBox.Caption:=LanguageSetup.GameUseDoublebuffering;
  with UseDoublebufferComboBox do begin Items.Add(RemoveUnderline(LanguageSetup.No)); Items.Add(RemoveUnderline(LanguageSetup.Yes)); ItemIndex:=0; end;
  RenderCheckBox.Caption:=LanguageSetup.GameRender;
  St:=ValueToList(GameDB.ConfOpt.Render,';,'); try RenderComboBox.Items.Assign(St); finally St.Free; end; RenderComboBox.ItemIndex:=0;
  WindowResolutionCheckBox.Caption:=LanguageSetup.GameWindowResolution;
  St:=ValueToList(GameDB.ConfOpt.Resolution,';,'); try WindowResolutionComboBox.Items.Assign(St); finally St.Free; end; WindowResolutionComboBox.ItemIndex:=0;
  FullscreenResolutionCheckBox.Caption:=LanguageSetup.GameFullscreenResolution;
  St:=ValueToList(GameDB.ConfOpt.Resolution,';,'); try FullscreenResolutionComboBox.Items.Assign(St); finally St.Free; end; FullscreenResolutionComboBox.ItemIndex:=0;
  ScaleCheckBox.Caption:=LanguageSetup.GameScale;
  St:=ValueToList(GameDB.ConfOpt.Scale,';,'); try ScaleComboBox.Items.Assign(St); finally St.Free; end; ScaleComboBox.ItemIndex:=1;
  with AspectComboBox do begin Items.Add(RemoveUnderline(LanguageSetup.No)); Items.Add(RemoveUnderline(LanguageSetup.Yes)); ItemIndex:=0; end;
  AspectCheckBox.Caption:=LanguageSetup.GameAspectCorrection;
  MemoryCheckBox.Caption:=LanguageSetup.GameMemory;
  St:=ValueToList(GameDB.ConfOpt.Memory,';,'); try MemoryComboBox.Items.Assign(St); finally St.Free; end; MemoryComboBox.Text:='32';
  CPUCyclesCheckBox.Caption:=LanguageSetup.GameCycles;
  St:=ValueToList(GameDB.ConfOpt.Cycles,';,'); try CPUCyclesComboBox.Items.Assign(St); finally St.Free; end; CPUCyclesComboBox.Text:='3000';
  EmulationCoreCheckBox.Caption:=LanguageSetup.GameCore;
  St:=ValueToList(GameDB.ConfOpt.Core,';,'); try EmulationCoreComboBox.Items.Assign(St); finally St.Free; end; EmulationCoreComboBox.Text:='auto';
  KeyboardLayoutCheckBox.Caption:=LanguageSetup.GameKeyboardLayout;
  St:=ValueToList(GameDB.ConfOpt.KeyboardLayout,';,'); try KeyboardLayoutComboBox.Items.Assign(St); finally St.Free; end; KeyboardLayoutComboBox.Text:='default';
  CodepageCheckBox.Caption:=LanguageSetup.GameKeyboardCodepage;
  St:=ValueToList(GameDB.ConfOpt.Codepage,';,'); try CodepageComboBox.Items.Assign(St); finally St.Free; end; CodepageComboBox.Text:='default';

  CheckBoxClick(Sender);
end;

procedure TChangeProfilesForm.SelectButtonClick(Sender: TObject);
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

procedure TChangeProfilesForm.CheckBoxClick(Sender: TObject);
begin
  { Page 1 }

  GenreComboBox.Enabled:=GenreCheckBox.Checked;
  DeveloperComboBox.Enabled:=DeveloperCheckBox.Checked;
  PublisherComboBox.Enabled:=PublisherCheckBox.Checked;
  YearComboBox.Enabled:=YearCheckBox.Checked;
  LanguageComboBox.Enabled:=LanguageCheckBox.Checked;
  FavouriteComboBox.Enabled:=FavouriteCheckBox.Checked;
  SetUserInfoComboBox.Enabled:=SetUserInfoCheckBox.Checked;
  SetUserInfoEdit.Enabled:=SetUserInfoCheckBox.Checked;
  DelUserInfoComboBox.Enabled:=DelUserInfoCheckBox.Checked;

  { Page 2 }

  CloseOnExitComboBox.Enabled:=CloseOnExitCheckBox.Checked;
  StartFullscreenComboBox.Enabled:=StartFullscreenCheckBox.Checked;
  LockMouseComboBox.Enabled:=LockMouseCheckBox.Checked;
  UseDoublebufferComboBox.Enabled:=UseDoublebufferCheckBox.Checked;
  RenderComboBox.Enabled:=RenderCheckBox.Checked;
  WindowResolutionComboBox.Enabled:=WindowResolutionCheckBox.Checked;
  FullscreenResolutionComboBox.Enabled:=FullscreenResolutionCheckBox.Checked;
  ScaleComboBox.Enabled:=ScaleCheckBox.Checked;
  AspectComboBox.Enabled:=AspectCheckBox.Checked;
  MemoryComboBox.Enabled:=MemoryCheckBox.Checked;
  CPUCyclesComboBox.Enabled:=CPUCyclesCheckBox.Checked;
  EmulationCoreComboBox.Enabled:=EmulationCoreCheckBox.Checked;
  KeyboardLayoutComboBox.Enabled:=KeyboardLayoutCheckBox.Checked;
  CodepageComboBox.Enabled:=CodepageCheckBox.Checked;
end;

Procedure TChangeProfilesForm.SetUserInfo(const G : TGame; const Key, Value : String);
Var St : TStringList;
    ValueFound : Boolean;
    I,J : Integer;
    KeyUpper, S : String;
begin
  KeyUpper:=Trim(ExtUpperCase(Key));
  St:=StringToStringList(G.UserInfo);
  try
    ValueFound:=False;
    For I:=0 to St.Count-1 do begin
      S:=Trim(St[I]);
      J:=Pos('=',S); If J=0 then continue;
      S:=Trim(Copy(S,1,J-1));
      If ExtUpperCase(S)=KeyUpper then begin St[I]:=Key+'='+Value; ValueFound:=True; break; end;
    end;
    If not ValueFound then St.Add(Key+'='+Value);
    G.UserInfo:=StringListToString(St);
  finally
    St.Free;
  end;
end;

Procedure TChangeProfilesForm.DelUserInfo(const G : TGame; const Key : String);
Var St : TStringList;
    KeyUpper,S : String;
    I,J : Integer;
begin
  KeyUpper:=Trim(ExtUpperCase(Key));
  St:=StringToStringList(G.UserInfo);
  try
    I:=0;
    while I<St.Count do begin
      S:=Trim(St[I]);
      J:=Pos('=',S); If J=0 then begin inc(I); continue; end;
      S:=Trim(Copy(S,1,J-1));
      If ExtUpperCase(S)=KeyUpper then begin St.Delete(I); continue; end;
      inc(I);
    end;
    G.UserInfo:=StringListToString(St);
  finally
    St.Free;
  end;
end;

procedure TChangeProfilesForm.OKButtonClick(Sender: TObject);
Var I,J : Integer;
    G : TGame;
    S : String;
    ScummVM,WindowsMode : Boolean;
begin
  For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then begin
    G:=TGame(ListBox.Items.Objects[I]);
    ScummVM:=ScummVMMode(G);
    WindowsMode:=WindowsExeMode(G);

    { Page 1 }

    If GenreCheckBox.Checked then G.Genre:=GenreComboBox.Text;
    If DeveloperCheckBox.Checked then G.Developer:=DeveloperComboBox.Text;
    If PublisherCheckBox.Checked then G.Publisher:=PublisherComboBox.Text;
    If YearCheckBox.Checked then G.Year:=YearComboBox.Text;
    If LanguageCheckBox.Checked then G.Language:=LanguageComboBox.Text;
    If FavouriteCheckBox.Checked then G.Favorite:=(FavouriteComboBox.ItemIndex=1);
    If SetUserInfoCheckBox.Checked then SetUserInfo(G,SetUserInfoComboBox.Text,SetUserInfoEdit.Text);
    If DelUserInfoCheckBox.Checked then DelUserInfo(G,DelUserInfoComboBox.Text);

    { Page 2 }

    If (not ScummVM) and (not WindowsMode) then begin
      If CloseOnExitCheckBox.Checked then G.CloseDosBoxAfterGameExit:=(CloseOnExitComboBox.ItemIndex=1);
    end;
    If not WindowsMode then begin
      If StartFullscreenCheckBox.Checked then G.StartFullscreen:=(StartFullscreenComboBox.ItemIndex=1);
      If AspectCheckBox.Checked then G.AspectCorrection:=(AspectComboBox.ItemIndex=1);
    end;
    If (not ScummVM) and (not WindowsMode) then begin
      If LockMouseCheckBox.Checked then G.AutoLockMouse:=(LockMouseComboBox.ItemIndex=1);
      If UseDoublebufferCheckBox.Checked then G.UseDoublebuffering:=(UseDoublebufferComboBox.ItemIndex=1);
      If RenderCheckBox.Checked then G.Render:=RenderComboBox.Text;
      If WindowResolutionCheckBox.Checked then G.WindowResolution:=WindowResolutionComboBox.Text;
      If FullscreenResolutionCheckBox.Checked then G.FullscreenResolution:=FullscreenResolutionComboBox.Text;
      If ScaleCheckBox.Checked then begin
        S:=ScaleComboBox.Text;
        If Pos('(',S)=0 then G.Scale:='' else begin
          S:=Copy(S,Pos('(',S)+1,MaxInt); If Pos(')',S)=0 then G.Scale:=''  else G.Scale:=Copy(S,1,Pos(')',S)-1);
        end;
      end;
      If MemoryCheckBox.Checked then begin try J:=Min(63,Max(1,StrToInt(MemoryComboBox.Text))); except J:=32; end; G.Memory:=J; end;
      If CPUCyclesCheckBox.Checked then G.Cycles:=CPUCyclesComboBox.Text;
      If EmulationCoreCheckBox.Checked then G.Core:=EmulationCoreComboBox.Text;
      If KeyboardLayoutCheckBox.Checked then G.KeyboardLayout:=KeyboardLayoutComboBox.Text;
      If CodepageCheckBox.Checked then G.Codepage:=CodepageComboBox.Text;
    end;
  end;

  GameDB.StoreAllValues;
  GameDB.LoadCache;
end;

procedure TChangeProfilesForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ExtrasEditMultipleProfiles);
end;

procedure TChangeProfilesForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowChangeProfilesDialog(const AOwner : TComponent; const AGameDB : TGameDB; const TemplateMode : Boolean) : Boolean;
begin
  ChangeProfilesForm:=TChangeProfilesForm.Create(AOwner);
  try
    ChangeProfilesForm.GameDB:=AGameDB;
    ChangeProfilesForm.TemplateMode:=TemplateMode;
    result:=(ChangeProfilesForm.ShowModal=mrOK);
  finally
    ChangeProfilesForm.Free;
  end;
end;

end.
