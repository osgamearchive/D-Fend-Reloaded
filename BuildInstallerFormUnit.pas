unit BuildInstallerFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, CheckLst, GameDBUnit, Menus, ComCtrls;

type
  TBuildInstallerForm = class(TForm)
    SaveDialog: TSaveDialog;
    PopupMenu: TPopupMenu;
    PageControl1: TPageControl;
    GamesSheet: TTabSheet;
    AutoSetupSheet: TTabSheet;
    InfoLabel: TLabel;
    DestFileButton: TSpeedButton;
    ListBox: TCheckListBox;
    SelectAllButton: TBitBtn;
    SelectNoneButton: TBitBtn;
    DestFileEdit: TLabeledEdit;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    InstTypeRadioGroup: TRadioGroup;
    GroupGamesCheckBox: TCheckBox;
    SelectGenreButton: TBitBtn;
    OKButton2: TBitBtn;
    CancelButton2: TBitBtn;
    InfoLabel2: TLabel;
    ListBox2: TCheckListBox;
    SelectAllButton2: TBitBtn;
    SelectNoneButton2: TBitBtn;
    SelectGenreButton2: TBitBtn;
    GroupGamesCheckBox2: TCheckBox;
    InstTypeRadioGroup2: TRadioGroup;
    DestFileEdit2: TLabeledEdit;
    DestFileButton2: TSpeedButton;
    PopupMenu2: TPopupMenu;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure DestFileButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SelectButtonClick2(Sender: TObject);
    procedure OKButton2Click(Sender: TObject);
    procedure DestFileButton2Click(Sender: TObject);
  private
    { Private-Deklarationen }
    AutoSetupDB : TGameDB;
    Function GetNSIFileName(var NSIFileName : String; const AutoSetup : Boolean) : Boolean;
    Function BuildNSIScript : Boolean;
    Function BuildNSIScript2 : Boolean;
  public
    { Public-Deklarationen }
    GameDB : TGameDB;
  end;

var
  BuildInstallerForm: TBuildInstallerForm;

Function BuildInstaller(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;

function CheckPath(NSIPath: String): Boolean;
function AddProfileToNSIScript(const NSI: TStringList; const Game: TGame): Boolean;
function AddGameToNSIScript(const NSI: TStringList; const Game: TGame): Boolean;
function BuildEXEInstaller(const Handle : THandle; const FileName : String) : Boolean;

implementation

uses Registry, ShellAPI, VistaToolsUnit, LanguageSetupUnit, PrgSetupUnit,
     CommonTools, PrgConsts, GameDBToolsUnit;

{$R *.dfm}

procedure TBuildInstallerForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);

  Caption:=LanguageSetup.BuildInstaller;

  { Games }

  GamesSheet.Caption:=LanguageSetup.BuildInstallerTypeCompleteGames;
  InfoLabel.Caption:=LanguageSetup.BuildInstallerInfo;
  DestFileEdit.EditLabel.Caption:=LanguageSetup.BuildInstallerDestFile;
  DestFileButton.Hint:=LanguageSetup.ChooseFile;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  SelectAllButton.Caption:=LanguageSetup.All;
  SelectNoneButton.Caption:=LanguageSetup.None;
  SelectGenreButton.Caption:=LanguageSetup.GameBy;
  GroupGamesCheckBox.Caption:=LanguageSetup.BuildInstallerGroupGames;
  InstTypeRadioGroup.Caption:=LanguageSetup.BuildInstallerInstType;
  InstTypeRadioGroup.Items[0]:=LanguageSetup.BuildInstallerInstTypeScriptOnly;
  InstTypeRadioGroup.Items[1]:=LanguageSetup.BuildInstallerInstTypeFullInstaller;

  { AutoSetup templates }

  //AutoSetupSheet.Caption:=LanguageSetup.BuildInstallerTypeAutoSetupProfiles;
  If ExtUpperCase(ExtractFileName(LanguageSetup.SetupFile))='DEUTSCH.INI'
    then AutoSetupSheet.Caption:='Autosetup Vorlagen'
    else AutoSetupSheet.Caption:='Auto setup '+LowerCase(LanguageSetup.TemplateForm);
  AutoSetupSheet.TabVisible:=PrgSetup.ShowAutoSetupTemplateEdit;

  //InfoLabel2.Caption:=LanguageSetup.BuildInstallerInfo;
  InfoLabel2.Caption:='Please select the auto setup templates to include in the installer:';

  DestFileEdit2.EditLabel.Caption:=LanguageSetup.BuildInstallerDestFile;
  DestFileButton2.Hint:=LanguageSetup.ChooseFile;
  OKButton2.Caption:=LanguageSetup.OK;
  CancelButton2.Caption:=LanguageSetup.Cancel;
  SelectAllButton2.Caption:=LanguageSetup.All;
  SelectNoneButton2.Caption:=LanguageSetup.None;
  SelectGenreButton2.Caption:=LanguageSetup.GameBy;
  GroupGamesCheckBox2.Caption:=LanguageSetup.BuildInstallerGroupGames;
  InstTypeRadioGroup2.Caption:=LanguageSetup.BuildInstallerInstType;
  InstTypeRadioGroup2.Items[0]:=LanguageSetup.BuildInstallerInstTypeScriptOnly;
  InstTypeRadioGroup2.Items[1]:=LanguageSetup.BuildInstallerInstTypeFullInstaller;

  { Dialog }

  SaveDialog.Title:=LanguageSetup.BuildInstallerDestFileTitle;
  SaveDialog.Filter:=LanguageSetup.BuildInstallerDestFileFilter;

  AutoSetupDB:=TGameDB.Create(PrgDataDir+AutoSetupSubDir);
end;

procedure TBuildInstallerForm.FormDestroy(Sender: TObject);
begin
  AutoSetupDB.Free;
end;

procedure TBuildInstallerForm.FormShow(Sender: TObject);
begin
  BuildCheckList(ListBox,GameDB,False);
  BuildCheckList(ListBox2,AutoSetupDB,False);
  BuildSelectPopupMenu(PopupMenu,GameDB,SelectButtonClick,False);
  BuildSelectPopupMenu(PopupMenu2,AutoSetupDB,SelectButtonClick2,False);
end;

procedure TBuildInstallerForm.SelectButtonClick(Sender: TObject);
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

procedure TBuildInstallerForm.SelectButtonClick2(Sender: TObject);
Var I : Integer;
    P : TPoint;
begin
  If Sender is TBitBtn then begin
    Case (Sender as TComponent).Tag of
      0,1 : For I:=0 to ListBox2.Count-1 do ListBox2.Checked[I]:=((Sender as TComponent).Tag=0);
        2 : begin
              P:=ClientToScreen(Point(SelectGenreButton2.Left,SelectGenreButton2.Top));
              PopupMenu2.Popup(P.X+5,P.Y+5);
            end;
    end;
    exit;
  end;

  SelectGamesByPopupMenu(Sender,ListBox2);
end;

Function TBuildInstallerForm.GetNSIFileName(var NSIFileName : String; const AutoSetup : Boolean) : Boolean;
Var S : String;
begin
  result:=False;

  If AutoSetup then S:=DestFileEdit2.Text else S:=DestFileEdit.Text;

  NSIFileName:=Trim(S);
  If NSIFileName='' then begin
    MessageDlg(LanguageSetup.MessageNoFileName,mtError,[mbOK],0);
    exit;
  end;
  NSIFileName:=ChangeFileExt(NSIFileName,'.nsi');

  if not CheckPath(ExtractFilePath(NSIFileName)) then exit;

  If FileExists(NSIFileName) then begin
    If MessageDlg(Format(LanguageSetup.MessageConfirmationOverwriteFile,[NSIFileName]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then exit;
  end;

  result:=True;
end;

function TBuildInstallerForm.BuildNSIScript: Boolean;
Var NSIFileName : String;
    St,GenreList : TStringList;
    I,J : Integer;
    S : String;
begin
  result:=False;
  if not GetNSIFileName(NSIFileName,False) then exit;

  St:=TStringList.Create;
  try
    St.Add('OutFile "'+ExtractFileName(DestFileEdit.Text)+'"');
    St.Add('!include "D-Fend Reloaded DataInstaller.nsi"');

    if GroupGamesCheckBox.Checked then begin
      GenreList:=TStringList.Create;
      try
        For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then begin
          S:=Trim(ExtUpperCase(TGame(ListBox.Items.Objects[I]).Genre));
          If GenreList.IndexOf(S)<0 then begin
            GenreList.Add(S);
            St.Add('');
            St.Add('SectionGroup "'+TGame(ListBox.Items.Objects[I]).Genre+'"');
            For J:=I to ListBox.Items.Count-1 do If ListBox.Checked[J] and (Trim(ExtUpperCase(TGame(ListBox.Items.Objects[J]).Genre))=S) then begin
              if not AddGameToNSIScript(St,TGame(ListBox.Items.Objects[J])) then exit;
            end;
            St.Add('SectionGroupEnd');
          end;
        end;
      finally
        GenreList.Free;
      end;
    end else begin
      For I:=0 to ListBox.Items.Count-1 do If ListBox.Checked[I] then begin
        if not AddGameToNSIScript(St,TGame(ListBox.Items.Objects[I])) then exit;
      end;
    end;

    try
      St.SaveToFile(NSIFileName);
    except
      MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[NSIFileName]),mtError,[mbOK],0);
      exit;
    end;

  finally
    St.Free;
  end;
  result:=True;
end;

function TBuildInstallerForm.BuildNSIScript2: Boolean;
Var NSIFileName : String;
    St,GenreList : TStringList;
    I,J : Integer;
    S : String;
begin
  result:=False;
  if not GetNSIFileName(NSIFileName,True) then exit;

  St:=TStringList.Create;
  try
    St.Add('OutFile "'+ExtractFileName(DestFileEdit.Text)+'"');
    St.Add('!include "D-Fend Reloaded DataInstaller.nsi"');

    if GroupGamesCheckBox.Checked then begin
      GenreList:=TStringList.Create;
      try
        For I:=0 to ListBox2.Items.Count-1 do If ListBox2.Checked[I] then begin
          S:=Trim(ExtUpperCase(TGame(ListBox2.Items.Objects[I]).Genre));
          If GenreList.IndexOf(S)<0 then begin
            GenreList.Add(S);
            St.Add('');
            St.Add('SectionGroup "'+TGame(ListBox2.Items.Objects[I]).Genre+'"');
            For J:=I to ListBox2.Items.Count-1 do If ListBox2.Checked[J] and (Trim(ExtUpperCase(TGame(ListBox2.Items.Objects[J]).Genre))=S) then begin
              if not AddProfileToNSIScript(St,TGame(ListBox2.Items.Objects[J])) then exit;
            end;
            St.Add('SectionGroupEnd');
          end;
        end;
      finally
        GenreList.Free;
      end;
    end else begin
      For I:=0 to ListBox2.Items.Count-1 do If ListBox2.Checked[I] then begin
        if not AddProfileToNSIScript(St,TGame(ListBox2.Items.Objects[I])) then exit;
      end;
    end;

    try
      St.SaveToFile(NSIFileName);
    except
      MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[NSIFileName]),mtError,[mbOK],0);
      exit;
    end;

  finally
    St.Free;
  end;
  result:=True;
end;

procedure TBuildInstallerForm.DestFileButtonClick(Sender: TObject);
Var S : String;
begin
  S:=Trim(DestFileEdit.Text);
  If (S='') or (Trim(ExtractFilePath(S))='') then SaveDialog.InitialDir:=PrgDataDir else SaveDialog.InitialDir:=Trim(ExtractFilePath(S));
  If not SaveDialog.Execute then exit;
  DestFileEdit.Text:=SaveDialog.FileName;
end;

procedure TBuildInstallerForm.DestFileButton2Click(Sender: TObject);
Var S : String;
begin
  S:=Trim(DestFileEdit2.Text);
  If (S='') or (Trim(ExtractFilePath(S))='') then SaveDialog.InitialDir:=PrgDataDir else SaveDialog.InitialDir:=Trim(ExtractFilePath(S));
  If not SaveDialog.Execute then exit;
  DestFileEdit2.Text:=SaveDialog.FileName;
end;

procedure TBuildInstallerForm.OKButtonClick(Sender: TObject);
begin
  If (Trim(ExtractFilePath(DestFileEdit.Text))='') and (Trim(DestFileEdit.Text)<>'') then
    DestFileEdit.Text:=PrgDataDir+DestFileEdit.Text;
  If Trim(DestFileEdit.Text)<>'' then DestFileEdit.Text:=ChangeFileExt(DestFileEdit.Text,'.exe');

  If not BuildNSIScript then begin ModalResult:=mrNone; exit; end;
  If InstTypeRadioGroup.ItemIndex=1 then begin
    If not BuildEXEInstaller(Handle,DestFileEdit.Text) then begin ModalResult:=mrNone; exit; end;
  end;
end;

procedure TBuildInstallerForm.OKButton2Click(Sender: TObject);
begin
  If (Trim(ExtractFilePath(DestFileEdit2.Text))='') and (Trim(DestFileEdit2.Text)<>'') then
    DestFileEdit2.Text:=PrgDataDir+DestFileEdit2.Text;
  If Trim(DestFileEdit2.Text)<>'' then DestFileEdit2.Text:=ChangeFileExt(DestFileEdit2.Text,'.exe');

  If not BuildNSIScript2 then begin ModalResult:=mrNone; exit; end;
  If InstTypeRadioGroup2.ItemIndex=1 then begin
    If not BuildEXEInstaller(Handle,DestFileEdit.Text) then begin ModalResult:=mrNone; exit; end;
  end;
end;

{ global }

Function BuildInstaller(const AOwner : TComponent; const AGameDB : TGameDB) : Boolean;
begin
  BuildInstallerForm:=TBuildInstallerForm.Create(AOwner);
  try
    BuildInstallerForm.GameDB:=AGameDB;
    result:=(BuildInstallerForm.ShowModal=mrOK);
  finally
    BuildInstallerForm.Free;
  end;
end;

function CheckPath(NSIPath: String): Boolean;
Var S,T : String;
begin
  S:=Trim(IncludeTrailingPathDelimiter(ExtUpperCase(NSIPath)));
  T:=Trim(IncludeTrailingPathDelimiter(ExtUpperCase(PrgDataDir)));
  If S=T then begin result:=True; exit; end;
  result:=(MessageDlg(Format(LanguageSetup.BuildInstallerPathWarning,[ExcludeTrailingPathDelimiter(PrgDataDir),ExcludeTrailingPathDelimiter(NSIPath)]),mtConfirmation,[mbYes,mbNo],0)=mrYes);
end;

function AddProfileToNSIScript(const NSI: TStringList; const Game: TGame): Boolean;
begin
  Game.StoreAllValues;

  NSI.Add('');
  NSI.Add('Section "AutoSetup: '+Game.Name+'"');
  NSI.Add('  SetOutPath "$DataInstDir\Confs"');
  NSI.Add('  File ".\'+AutoSetupSubDir+'\'+ExtractFileName(Game.SetupFile)+'"');
  NSI.Add('SectionEnd');

  result:=True;
end;

function AddGameToNSIScript(const NSI: TStringList; const Game: TGame): Boolean;
Procedure AddFiles(S : String);
Var T : String;
begin
  S:=MakeRelPath(IncludeTrailingPathDelimiter(S),PrgDataDir); T:=S;
  If Copy(T,1,2)='.\' then T:=Copy(T,3,MaxInt);
  If Copy(T,1,1)='\' then T:=Copy(T,2,MaxInt);
  NSI.Add('  SetOutPath "$DataInstDir\'+T+'"');
  NSI.Add('  File /nonfatal /r "'+IncludeTrailingPathDelimiter(S)+'*.*"');
end;
Var S : String;
    I : Integer;
    St : TStringList;
begin
  Game.StoreAllValues;

  NSI.Add('');
  NSI.Add('Section "'+Game.Name+'"');
  NSI.Add('  SetOutPath "$DataInstDir\Confs"');
  NSI.Add('  File ".\'+GameListSubDir+'\'+ExtractFileName(Game.SetupFile)+'"');


  S:=Trim(Game.GameExe);
  If S='' then S:=Trim(Game.SetupExe);
  If S<>'' then AddFiles(IncludeTrailingPathDelimiter(ExtractFilePath(S)));

  S:=Trim(Game.CaptureFolder);
  If S<>'' then AddFiles(S);

  S:=Trim(Game.Icon);
  If (S<>'') and FileExists(PrgDataDir+IconsSubDir+'\'+S) then begin
    NSI.Add('  SetOutPath "$DataInstDir\'+IconsSubDir+'"');
    NSI.Add('  File /nonfatal "'+PrgDataDir+IconsSubDir+'\'+S+'"');
  end;

  S:=Trim(Game.DataDir);
  If S<>'' then AddFiles(S);

  S:=Trim(Game.ExtraDirs);
  If S<>'' then begin
    St:=ValueToList(S);
    try
      For I:=0 to St.Count-1 do If Trim(St[I])<>'' then begin
        AddFiles(IncludeTrailingPathDelimiter(St[I]));
      end;
    finally
      St.Free;
    end;
  end;

  NSI.Add('SectionEnd');

  result:=True;
end;

function BuildEXEInstaller(const Handle : THandle; const FileName : String) : Boolean;
Var Reg : TRegistry;
    S : String;
begin
  result:=False;

  {Check if NSIS is installed}
  S:='';
  Reg:=TRegistry.Create;
  try
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    Reg.Access:=KEY_QUERY_VALUE;
    if Reg.OpenKey('SOFTWARE\NSIS',False) then S:=Reg.ReadString('');
  finally
    Reg.Free;
  end;

  If (S='') or (not FileExists(IncludeTrailingPathDelimiter(S)+'makensisw.exe')) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,['makensisw.exe'])+#13+LanguageSetup.BuildInstallerNeedNSIS,mtError,[mbOK],0);
    exit;
  end;

  {Copy D-Fend Reloaded DataInstaller.nsi to PrgDataDir if missing}
  If (PrgDir<>PrgDataDir) and (not FileExists(PrgDataDir+NSIInstallerHelpFile)) and FileExists(PrgDir+NSIInstallerHelpFile) then
    CopyFile(PChar(PrgDir+NSIInstallerHelpFile),PChar(PrgDataDir+NSIInstallerHelpFile),False);

  {Execute NSIS}
  ShellExecute(Handle,'open',PChar(IncludeTrailingPathDelimiter(S)+'makensisw.exe'),PChar('"'+ChangeFileExt(Trim(FileName),'.nsi')+'"'),nil,SW_SHOW);

  result:=True;
end;

end.
