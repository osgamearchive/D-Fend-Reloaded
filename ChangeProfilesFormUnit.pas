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
    KeyboardLayoutCheckBox: TCheckBox;
    KeyboardLayoutComboBox: TComboBox;
    WindowResolutionCheckBox: TCheckBox;
    WindowResolutionComboBox: TComboBox;
    FullscreenResolutionComboBox: TComboBox;
    ScaleComboBox: TComboBox;
    FullscreenResolutionCheckBox: TCheckBox;
    ScaleCheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure CheckBoxClick(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
  end;

var
  ChangeProfilesForm: TChangeProfilesForm;

Function ShowChangeProfilesDialog(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, PrgConsts, CommonTools,
     GameDBToolsUnit;

{$R *.dfm}

procedure TChangeProfilesForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
end;

procedure TChangeProfilesForm.FormShow(Sender: TObject);
Var St : TStringList;
begin
  BuildCheckList(ListBox,GameDB,False);
  BuildSelectPopupMenu(PopupMenu,GameDB,SelectButtonClick,False);

  Caption:=LanguageSetup.ChangeProfilesFormCaption;
  TabSheet1.Caption:=LanguageSetup.ChangeProfilesFormSelectGamesSheet;
  TabSheet2.Caption:=LanguageSetup.ChangeProfilesFormEditProfileSheet;
  InfoLabel.Caption:=LanguageSetup.ChangeProfilesFormInfo;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;
  SelectGenreButton.Caption:=LanguageSetup.GameBy;

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
  MemoryCheckBox.Caption:=LanguageSetup.GameMemory;
  St:=ValueToList(GameDB.ConfOpt.Memory,';,'); try MemoryComboBox.Items.Assign(St); finally St.Free; end; MemoryComboBox.Text:='32';
  CPUCyclesCheckBox.Caption:=LanguageSetup.GameCycles;
  St:=ValueToList(GameDB.ConfOpt.Cycles,';,'); try CPUCyclesComboBox.Items.Assign(St); finally St.Free; end; CPUCyclesComboBox.Text:='3000';
  EmulationCoreCheckBox.Caption:=LanguageSetup.GameCore;
  St:=ValueToList(GameDB.ConfOpt.Core,';,'); try EmulationCoreComboBox.Items.Assign(St); finally St.Free; end; EmulationCoreComboBox.Text:='auto';
  KeyboardLayoutCheckBox.Caption:=LanguageSetup.GameKeyboardLayout;
  St:=ValueToList(GameDB.ConfOpt.KeyboardLayout,';,'); try KeyboardLayoutComboBox.Items.Assign(St); finally St.Free; end; KeyboardLayoutComboBox.Text:='default';

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
  GenreComboBox.Enabled:=GenreCheckBox.Checked;
  DeveloperComboBox.Enabled:=DeveloperCheckBox.Checked;
  PublisherComboBox.Enabled:=PublisherCheckBox.Checked;
  YearComboBox.Enabled:=YearCheckBox.Checked;
  LanguageComboBox.Enabled:=LanguageCheckBox.Checked;
  FavouriteComboBox.Enabled:=FavouriteCheckBox.Checked;
  CloseOnExitComboBox.Enabled:=CloseOnExitCheckBox.Checked;
  StartFullscreenComboBox.Enabled:=StartFullscreenCheckBox.Checked;
  LockMouseComboBox.Enabled:=LockMouseCheckBox.Checked;
  UseDoublebufferComboBox.Enabled:=UseDoublebufferCheckBox.Checked;
  RenderComboBox.Enabled:=RenderCheckBox.Checked;
  WindowResolutionComboBox.Enabled:=WindowResolutionCheckBox.Checked;
  FullscreenResolutionComboBox.Enabled:=FullscreenResolutionCheckBox.Checked;
  ScaleComboBox.Enabled:=ScaleCheckBox.Checked;
  MemoryComboBox.Enabled:=MemoryCheckBox.Checked;
  CPUCyclesComboBox.Enabled:=CPUCyclesCheckBox.Checked;
  EmulationCoreComboBox.Enabled:=EmulationCoreCheckBox.Checked;
  KeyboardLayoutComboBox.Enabled:=KeyboardLayoutCheckBox.Checked;
end;

procedure TChangeProfilesForm.OKButtonClick(Sender: TObject);
Var I,J : Integer;
    G : TGame;
begin
  For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then begin
    G:=TGame(ListBox.Items.Objects[I]);
    If GenreCheckBox.Checked then G.Genre:=GenreComboBox.Text;
    If DeveloperCheckBox.Checked then G.Developer:=DeveloperComboBox.Text;
    If PublisherCheckBox.Checked then G.Publisher:=PublisherComboBox.Text;
    If YearCheckBox.Checked then G.Year:=YearComboBox.Text;
    If LanguageCheckBox.Checked then G.Language:=LanguageComboBox.Text;
    If FavouriteCheckBox.Checked then G.Favorite:=(FavouriteComboBox.ItemIndex=1);
    If CloseOnExitCheckBox.Checked then G.CloseDosBoxAfterGameExit:=(CloseOnExitComboBox.ItemIndex=1);
    If StartFullscreenCheckBox.Checked then G.StartFullscreen:=(StartFullscreenComboBox.ItemIndex=1);
    If LockMouseCheckBox.Checked then G.AutoLockMouse:=(LockMouseComboBox.ItemIndex=1);
    If UseDoublebufferCheckBox.Checked then G.UseDoublebuffering:=(UseDoublebufferComboBox.ItemIndex=1);
    If RenderCheckBox.Checked then G.Render:=RenderComboBox.Text;
    If MemoryCheckBox.Checked then begin try J:=Min(63,Max(1,StrToInt(MemoryComboBox.Text))); except J:=32; end; G.Memory:=J; end;
    If CPUCyclesCheckBox.Checked then G.Cycles:=CPUCyclesComboBox.Text;
    If EmulationCoreCheckBox.Checked then G.Core:=EmulationCoreComboBox.Text;
    If KeyboardLayoutCheckBox.Checked then G.KeyboardLayout:=KeyboardLayoutComboBox.Text;
  end;

  GameDB.StoreAllValues;
  GameDB.LoadCache;
end;

{ global }

Function ShowChangeProfilesDialog(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
begin
  ChangeProfilesForm:=TChangeProfilesForm.Create(AOwner);
  try
    ChangeProfilesForm.GameDB:=AGameDB;
    result:=(ChangeProfilesForm.ShowModal=mrOK);
  finally
    ChangeProfilesForm.Free;
  end;
end;

end.
