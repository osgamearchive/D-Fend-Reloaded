unit InstallationSupportFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, GameDBUnit;

type
  TInstallationSupportForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    HelpButton: TBitBtn;
    InstallTypeComboBox: TComboBox;
    ListBox: TListBox;
    AddButton: TSpeedButton;
    DelButton: TSpeedButton;
    DropInfoLabel: TLabel;
    AlwaysMountISOCheckBox: TCheckBox;
    OpenDialog: TOpenDialog;
    UpButton: TSpeedButton;
    DownButton: TSpeedButton;
    InsertMediaLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure InstallTypeComboBoxChange(Sender: TObject);
    procedure ListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonWork(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    LastInstallType : Integer;
    Function EntryInList(const S : String) : Boolean;
  public
    { Public-Deklarationen }
  end;

var
  InstallationSupportForm: TInstallationSupportForm;

Function ShowInstallationSupportDialog(const AOwner : TComponent; const AGameDB : TGameDB) : TGame;
Function RunInstallationFromZipFile(const AOwner : TComponent; const AGameDB : TGameDB; const FileName : String; const FilesAlreadyInTempDir : String = '') : TGame;
Function TestInstallationSupportNeeded(const AFolder : String) : Boolean;

implementation

uses LanguageSetupUnit, CommonTools, VistaToolsUnit, IconLoaderUnit, HelpConsts,
     ClassExtensions, ZipInfoFormUnit, InstallationRunFormUnit, ZipPackageUnit,
     PrgConsts;

{$R *.dfm}

Function SystemHasFloppyDiskDrive : Boolean;
Var C : Char;
begin
  result:=False;
  For C:='A' to 'Z' do begin
    If GetDriveType(PChar(C+':\'))=DRIVE_REMOVABLE then begin result:=True; exit; end;
  end;
end;

procedure TInstallationSupportForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.InstallationSupport;
  With InstallTypeComboBox.Items do begin
    Clear;
    If SystemHasFloppyDiskDrive then AddObject(LanguageSetup.InstallationSupportSourceFloppy,TObject(0));
    AddObject(LanguageSetup.InstallationSupportSourceFolder,TObject(1));
    AddObject(LanguageSetup.InstallationSupportSourceArchive,TObject(2));
    AddObject(LanguageSetup.InstallationSupportSourceCD,TObject(3));
    AddObject(LanguageSetup.InstallationSupportSourceISO,TObject(4));
  end;
  AlwaysMountISOCheckBox.Caption:=LanguageSetup.InstallationSupportAlwaysMountISO;

  UpButton.Hint:=LanguageSetup.MoveUp;
  DownButton.Hint:=LanguageSetup.MoveDown;
  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  OpenDialog.Title:=LanguageSetup.ChooseFile;

  UserIconLoader.DialogImage(DI_Add,AddButton);
  UserIconLoader.DialogImage(DI_Delete,DelButton);
  UserIconLoader.DialogImage(DI_Up,UpButton);
  UserIconLoader.DialogImage(DI_Down,DownButton);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  If InstallTypeComboBox.Items.Count=5 then InstallTypeComboBox.ItemIndex:=2 else InstallTypeComboBox.ItemIndex:=1;
  LastInstallType:=-1;
  InstallTypeComboBoxChange(self);
end;

procedure TInstallationSupportForm.FormShow(Sender: TObject);
begin
  ListBox:=TListBox(NewWinControlType(ListBox,TListBoxAcceptingFiles,ctcmDangerousMagic));
  TListBoxAcceptingFiles(ListBox).ActivateAcceptFiles;
end;

procedure TInstallationSupportForm.InstallTypeComboBoxChange(Sender: TObject);
Var I : Integer;
begin
  If (LastInstallType>=0) and (InstallTypeComboBox.ItemIndex<>LastInstallType) and ListBox.Visible and (ListBox.Items.Count>0) then begin
    If MessageDlg(LanguageSetup.InstallationSupportSourceClearList,mtWarning,[mbYes,mbNo],0)<>mrYes then begin
      InstallTypeComboBox.ItemIndex:=LastInstallType; exit;
    end;
    ListBox.Items.Clear;
  end;
  If LastInstallType=InstallTypeComboBox.ItemIndex then exit;
  LastInstallType:=InstallTypeComboBox.ItemIndex;

  If InstallTypeComboBox.ItemIndex<0 then begin
    ListBox.Visible:=False;
    AddButton.Visible:=False;
    DelButton.Visible:=False;
    DropInfoLabel.Visible:=False;
    AlwaysMountISOCheckBox.Visible:=False;
    OKButton.Enabled:=False;
    exit;
  end;

  I:=Integer(InstallTypeComboBox.Items.Objects[InstallTypeComboBox.ItemIndex]);

  ListBox.Visible:=(I<>0) and (I<>3);
  AddButton.Visible:=(I<>0) and (I<>3);
  DelButton.Visible:=(I<>0) and (I<>3);
  UpButton.Visible:=(I<>0) and (I<>3);
  DownButton.Visible:=(I<>0) and (I<>3);
  DropInfoLabel.Visible:=(I<>0) and (I<>3);
  AlwaysMountISOCheckBox.Visible:=(I=4);
  InsertMediaLabel.Visible:=(I=0) or (I=3);

  OKButton.Enabled:=not ListBox.Visible;
  UpButton.Enabled:=False;
  DownButton.Enabled:=False;

  Case I of
    0 : begin {Install from real floppy disks}
          InsertMediaLabel.Caption:=LanguageSetup.InstallationSupportInsertFirstFloppy;
        end;
    1 : begin {Install from folder}
          AddButton.Hint:=LanguageSetup.InstallationSupportAddFolder;
          DelButton.Hint:=LanguageSetup.InstallationSupportDelFolder;
          DropInfoLabel.Caption:=LanguageSetup.InstallationSupportDragDropFolder;
        end;
    2 : begin {Install from archive files}
          AddButton.Hint:=LanguageSetup.InstallationSupportAddArchive;
          DelButton.Hint:=LanguageSetup.InstallationSupportDelArchive;
          DropInfoLabel.Caption:=LanguageSetup.InstallationSupportDragDropArchive;
        end;
    3 : begin
          InsertMediaLabel.Caption:=LanguageSetup.InstallationSupportInsertFirstCD;
        end;
    4 : begin {Install from iso image}
          AddButton.Hint:=LanguageSetup.InstallationSupportAddISO;
          DelButton.Hint:=LanguageSetup.InstallationSupportDelISO;
          DropInfoLabel.Caption:=LanguageSetup.InstallationSupportDragDropISO;
        end;
  end;

  ListBoxClick(Sender);
end;

procedure TInstallationSupportForm.ListBoxClick(Sender: TObject);
begin
  DelButton.Enabled:=(ListBox.ItemIndex>=0);
  UpButton.Enabled:=(ListBox.ItemIndex>=1);
  DownButton.Enabled:=(ListBox.ItemIndex>=0) and (ListBox.ItemIndex<ListBox.Items.Count-1);
end;

procedure TInstallationSupportForm.ListBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Shift=[] then Case Key of
    VK_INSERT : begin ButtonWork(AddButton); Key:=0; end;
    VK_DELETE : begin ButtonWork(DelButton); Key:=0; end;
  end;
end;

procedure TInstallationSupportForm.ButtonWork(Sender: TObject);
Var S : String;
    I : Integer;
begin
  Case (Sender as TComponent).Tag of
    0 : Case Integer(InstallTypeComboBox.Items.Objects[InstallTypeComboBox.ItemIndex]) of
          1 : begin
                If SelectDirectory(Handle,LanguageSetup.ChooseFolder,S) then begin
                  If not EntryInList(S) then begin
                    ListBox.Items.Add(S);
                    ListBox.ItemIndex:=ListBox.Items.Count-1;
                  end;
                end;
              end;
          2 : begin
                OpenDialog.DefaultExt:='zip';
                OpenDialog.Filter:=ProcessFileNameFilter(LanguageSetup.ProfileMountingZipFileFilter2,LanguageSetup.ProfileMountingZipFileFilter2ArchiveFiles);
                If OpenDialog.Execute and not EntryInList(OpenDialog.FileName) then begin
                  ListBox.Items.Add(OpenDialog.FileName);
                  ListBox.ItemIndex:=ListBox.Items.Count-1;
                end;
              end;
          4 : begin
                OpenDialog.DefaultExt:='iso';
                OpenDialog.Filter:=LanguageSetup.ProfileMountingFileFilter;
                If OpenDialog.Execute and not EntryInList(OpenDialog.FileName) then begin
                  ListBox.Items.Add(OpenDialog.FileName);
                  ListBox.ItemIndex:=ListBox.Items.Count-1;
                end;
              end;
        end;
    1 : If ListBox.ItemIndex>=0 then begin ListBox.Items.Delete(ListBox.ItemIndex); ListBoxClick(Sender); end;
    2 : If ListBox.ItemIndex>=1 then begin
          I:=ListBox.ItemIndex;
          S:=ListBox.Items[I-1]; ListBox.Items[I-1]:=ListBox.Items[I]; ListBox.Items[I]:=S;
          ListBox.ItemIndex:=I-1;
        end;
    3 : If (ListBox.ItemIndex>=0) and (ListBox.ItemIndex<ListBox.Items.Count-1) then begin
          I:=ListBox.ItemIndex;
          S:=ListBox.Items[I+1]; ListBox.Items[I+1]:=ListBox.Items[I]; ListBox.Items[I]:=S;
          ListBox.ItemIndex:=I+1;
        end;
  end;
  OKButton.Enabled:=(not ListBox.Visible) or (ListBox.Items.Count>0);
  ListBoxClick(Sender);
end;

procedure TInstallationSupportForm.ListBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
Var I,J : Integer;
    St : TStringList;
begin
  If (Source=nil) or (not (Source is TStringList)) then exit;
  St:=Source as TStringList;
  For I:=0 to St.Count-1 do if not EntryInList(St[I]) then begin
    If InstallTypeComboBox.ItemIndex>=0 then begin
      J:=Integer(InstallTypeComboBox.Items.Objects[InstallTypeComboBox.ItemIndex]);
      If J=1 then begin
        {folder mode}
        If not DirectoryExists(St[I]) then continue;
      end else begin
        {archive file mode}
        If DirectoryExists(St[I]) then continue;
      end;
    end;
    ListBox.Items.Add(St[I]);
  end;
  If ListBox.Items.Count>=0 then ListBox.ItemIndex:=ListBox.Items.Count-1;
  OKButton.Enabled:=(not ListBox.Visible) or (ListBox.Items.Count>0);
  ListBoxClick(Sender);
end;

function TInstallationSupportForm.EntryInList(const S: String): Boolean;
Var I : Integer;
    T : String;
begin
  result:=False;
  T:=ExtUpperCase(S);
  For I:=0 to ListBox.Items.Count-1 do If ExtUpperCase(ListBox.Items[I])=T then begin result:=True; exit; end;
end;

procedure TInstallationSupportForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ProfileInstallationSupport);
end;

procedure TInstallationSupportForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowInstallationSupportDialog(const AOwner : TComponent; const AGameDB : TGameDB) : TGame;
Var I : Integer;
begin
  result:=nil;
  InstallationSupportForm:=TInstallationSupportForm.Create(AOwner);
  try
    If InstallationSupportForm.ShowModal=mrOK then begin
      InstallationRunForm:=TInstallationRunForm.Create(AOwner);
      try
        I:=Integer(InstallationSupportForm.InstallTypeComboBox.Items.Objects[InstallationSupportForm.InstallTypeComboBox.ItemIndex]);
        Case I of
          0 : InstallationRunForm.InstallType:=itFloppy;
          1 : InstallationRunForm.InstallType:=itFolder;
          2 : InstallationRunForm.InstallType:=itArchive;
          3 : InstallationRunForm.InstallType:=itCD;
          4 : InstallationRunForm.InstallType:=itISO;
        end;
        InstallationRunForm.Sources.AddStrings(InstallationSupportForm.ListBox.Items);
        InstallationRunForm.AlwaysMountISO:=InstallationSupportForm.AlwaysMountISOCheckBox.Checked;
        If InstallationRunForm.ShowModal=mrOK then result:=CreateGameFromSimpleFolder(InstallationRunForm.NewGameDir,AGameDB,'',True,True);
      finally
        InstallationRunForm.Free;
      end;
    end;
  finally
    InstallationSupportForm.Free;
  end;
end;

Function RunInstallationFromZipFile(const AOwner : TComponent; const AGameDB : TGameDB; const FileName : String; const FilesAlreadyInTempDir : String) : TGame;
begin
  result:=nil;
  InstallationRunForm:=TInstallationRunForm.Create(AOwner);
  try
    InstallationRunForm.InstallType:=itArchive;
    InstallationRunForm.Sources.Add(FileName);
    InstallationRunForm.FilesAlreadyInTempDir:=FilesAlreadyInTempDir;
    If InstallationRunForm.ShowModal=mrOK then result:=CreateGameFromSimpleFolder(InstallationRunForm.NewGameDir,AGameDB,'',True,True);
  finally
    InstallationRunForm.Free;
  end;
end;

Procedure FindProgramFiles(const Dir : String; const St : TStringList);
Var Rec : TSearchRec;
    I,J : Integer;
begin
  For J:=Low(ProgramExts) to high(ProgramExts) do begin
     I:=FindFirst(Dir+'*.'+ProgramExts[J],faAnyFile,Rec);
     try While I=0 do begin If ((Rec.Attr and faDirectory)=0) then St.Add(ExtUpperCase(ChangeFileExt(Rec.Name,''))); I:=FindNext(Rec); end;
     finally FindClose(Rec); end;
  end;
end;

Function TestInstallationSupportNeeded(const AFolder : String) : Boolean;
Var St : TStringList;
    I,J : Integer;
    B : Boolean;
begin
  St:=TStringList.Create;
  try
    result:=False;
    FindProgramFiles(IncludeTrailingPathDelimiter(AFolder),St);
    I:=0; while I<St.Count do begin
      B:=True; For J:=Low(IgnoreGameExeFilesIgnore) to High(IgnoreGameExeFilesIgnore) do If St[I]=IgnoreGameExeFilesIgnore[J] then begin B:=False; break; end;
      If B then inc(I) else St.Delete(I);
    end;
    if St.Count<>1 then exit;
    For I:=Low(InstallerNames) to High(InstallerNames) do If InstallerNames[I]=St[0] then begin result:=True; exit; end;
  finally
    St.Free;
  end;
end;

end.
