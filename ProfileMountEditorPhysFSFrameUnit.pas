unit ProfileMountEditorPhysFSFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, ProfileMountEditorFormUnit;

type
  TProfileMountEditorPhysFSFrame = class(TFrame, TProfileMountEditorFrame)
    ZipFolderEdit: TLabeledEdit;
    ZipFolderButton: TSpeedButton;
    ZipFolderDriveLetterComboBox: TComboBox;
    ZipFolderDriveLetterLabel: TLabel;
    ZipFolderFreeSpaceTrackbar: TTrackBar;
    ZipFolderFreeSpaceLabel: TLabel;
    ZipFolderDriveLetterWarningLabel: TLabel;
    ZipFileEdit: TLabeledEdit;
    ZipFileButton: TSpeedButton;
    OpenDialog: TOpenDialog;
    RepackCheckBox: TCheckBox;
    RepackTypeLabel: TLabel;
    RepackTypeComboBox: TComboBox;
    ZipFolderCreateButton: TSpeedButton;
    procedure ZipFolderButtonClick(Sender: TObject);
    procedure ZipFolderFreeSpaceTrackbarChange(Sender: TObject);
    procedure ZipFolderDriveLetterComboBoxChange(Sender: TObject);
    procedure ZipFileButtonClick(Sender: TObject);
    procedure RepackCheckBoxClick(Sender: TObject);
    procedure ZipFolderCreateButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    InfoData : TInfoData;
  public
    { Public-Deklarationen }
    Function Init(const AInfoData : TInfoData) : Boolean;
    Function Done : String;
    Function GetName : String;
    Procedure ShowFrame;
  end;

implementation

uses LanguageSetupUnit, CommonTools, PrgSetupUnit, PrgConsts, IconLoaderUnit;

{$R *.dfm}

{ TProfileMountEditorPhysFSFrame }

function TProfileMountEditorPhysFSFrame.Init(const AInfoData: TInfoData): Boolean;
Var C : Char;
    St : TStringList;
    S,T : String;
    I : Integer;
begin
  InfoData:=AInfoData;

  ZipFolderEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingFolder;
  ZipFolderDriveLetterLabel.Caption:=LanguageSetup.ProfileMountingLetter;
  ZipFolderDriveLetterWarningLabel.Caption:=LanguageSetup.ProfileMountingDriveLetterAlreadyInUse;
  ZipFileEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingZipFile;

  ZipFolderButton.Hint:=LanguageSetup.ChooseFolder;
  ZipFolderCreateButton.Hint:=LanguageSetup.ProfileMountingZipFileAutoSetupFolder;
  ZipFileButton.Hint:=LanguageSetup.ChooseFile;

  ZipFolderDriveLetterComboBox.Items.BeginUpdate;
  try
    ZipFolderDriveLetterComboBox.Items.Capacity:=30;
    For C:='A' to 'Y' do ZipFolderDriveLetterComboBox.Items.Add(C);
    ZipFolderDriveLetterComboBox.ItemIndex:=2;
  finally
    ZipFolderDriveLetterComboBox.Items.EndUpdate;
  end;

  RepackCheckBox.Caption:=LanguageSetup.ProfileMountingZipRepackPhysFS;
  RepackTypeLabel.Caption:=LanguageSetup.ProfileMountingZipRepack;
  RepackTypeComboBox.Items[0]:=LanguageSetup.ProfileMountingZipRepackNoDelete;
  RepackTypeComboBox.Items[1]:=LanguageSetup.ProfileMountingZipRepackDeleteFiles;
  RepackTypeComboBox.Items[2]:=LanguageSetup.ProfileMountingZipRepackDeleteFolder;

  UserIconLoader.DialogImage(DI_SelectFolder,ZipFolderButton);
  UserIconLoader.DialogImage(DI_Create,ZipFolderCreateButton);
  UserIconLoader.DialogImage(DI_SelectFile,ZipFileButton);

  St:=ValueToList(InfoData.Data);
  try
    S:=Trim(ExtUpperCase(St[1]));
    If S='PHYSFS' then begin
      {RealFolder$ZipFile;PHYSFS;Letter;False;;FreeSpace;DeleteMode(no;files;folder)}
      result:=True;
      S:=Trim(St[0]); I:=Pos('$',S); If I=0 then T:='' else begin T:=Trim(Copy(S,I+1,MaxInt)); S:=Trim(Copy(S,1,I-1)); end;
      ZipFolderEdit.Text:=S; ZipFileEdit.Text:=T;
      If St.Count>=3 then begin
        I:=ZipFolderDriveLetterComboBox.Items.IndexOf(Trim(UpperCase(St[2]))); If I<0 then I:=2;
        ZipFolderDriveLetterComboBox.ItemIndex:=I;
      end;
      If St.Count>=6 then begin
        try I:=StrToInt(St[5]); except I:=0; end;
        If (I>=10) and (I<=4000) then ZipFolderFreeSpaceTrackBar.Position:=I;
      end;
      If St.Count>=7 then begin
        S:=Trim(ExtUpperCase(St[6]));
        If S='NO' then begin RepackCheckBox.Checked:=True; RepackCheckBox.Enabled:=True; RepackTypeComboBox.ItemIndex:=0; end;
        If S='FILES' then begin RepackCheckBox.Checked:=True; RepackCheckBox.Enabled:=True; RepackTypeComboBox.ItemIndex:=1; end;
        If S='FOLDER' then begin RepackCheckBox.Checked:=True; RepackCheckBox.Enabled:=True; RepackTypeComboBox.ItemIndex:=2; end;
      end;
    end else begin
      result:=False;
      For I:=2 to ZipFolderDriveLetterComboBox.Items.Count-1 do begin
        If Pos(ZipFolderDriveLetterComboBox.Items[I],InfoData.UsedDriveLetters)=0 then begin ZipFolderDriveLetterComboBox.ItemIndex:=I; break; end;
      end;
    end;
  finally
    St.Free;
  end;

  ZipFolderDriveLetterComboBoxChange(self);
  ZipFolderFreeSpaceTrackBarChange(self);
  RepackCheckBoxClick(self);
end;

function TProfileMountEditorPhysFSFrame.Done: String;
Var S,T : String;
    B : Boolean;
begin
  If Trim(ZipFolderEdit.Text)='' then begin
    MessageDlg(LanguageSetup.MessageNoFolderNameForMounting,mtError,[mbOK],0);
    result:='';
    exit;
  end;

  B:=True;

  S:=IncludeTrailingPathDelimiter(Trim(ExtUpperCase(MakeRelPath(ZipFolderEdit.Text,PrgSetup.BaseDir,True))));
  T:=IncludeTrailingPathDelimiter(Trim(ExtUpperCase(MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir,True))));
  If Copy(S,1,2)='.\' then S:=Trim(Copy(S,3,MaxInt));
  If Copy(T,1,2)='.\' then T:=Trim(Copy(T,3,MaxInt));

  If RepackCheckBox.Checked and (RepackTypeComboBox.ItemIndex>0) and (S=T) then begin
    If MessageDlg(Format(LanguageSetup.ProfileMountingFolderDeleteWarning,[PrgSetup.GameDir]),mtWarning,[mbYes,mbNo],0)<>mrYes then B:=False;
  end;

  {RealFolder$ZipFile;PHYSFS;Letter;False;;FreeSpace;DeleteMode(no;files;folder)}
  S:=MakeRelPath(ZipFolderEdit.Text,PrgSetup.BaseDir)+'$'+MakeRelPath(ZipFileEdit.Text,PrgSetup.BaseDir)+';PhysFS;'+ZipFolderDriveLetterComboBox.Text+';False;';
  S:=S+';'+IntToStr(ZipFolderFreeSpaceTrackBar.Position);
  If RepackCheckBox.Checked then Case RepackTypeComboBox.ItemIndex of
    0 : S:=S+';no';
    1 : S:=S+';files';
    2 : S:=S+';folder';
  end;

  If B then result:=S else result:='';
end;

function TProfileMountEditorPhysFSFrame.GetName: String;
begin
  result:=LanguageSetup.ProfileMountingPhysFSSheet
end;

procedure TProfileMountEditorPhysFSFrame.ZipFolderButtonClick(Sender: TObject);
Var S : String;
begin
  If Trim(ZipFolderEdit.Text)='' then S:=InfoData.DefaultInitialDir else S:=ZipFolderEdit.Text;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  if not SelectDirectory(Handle,LanguageSetup.ProfileMountingFolder,S) then exit;
  ZipFolderEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir,True);
end;

procedure TProfileMountEditorPhysFSFrame.ZipFolderDriveLetterComboBoxChange(Sender: TObject);
begin
  ZipFolderDriveLetterWarningLabel.Visible:=(ZipFolderDriveLetterComboBox.ItemIndex>=0) and (Pos(ZipFolderDriveLetterComboBox.Items[ZipFolderDriveLetterComboBox.ItemIndex],InfoData.UsedDriveLetters)>0);
end;

procedure TProfileMountEditorPhysFSFrame.ZipFolderFreeSpaceTrackbarChange(Sender: TObject);
begin
  ZipFolderFreeSpaceLabel.Caption:=Format(LanguageSetup.ProfileMountingFreeSpace,[ZipFolderFreeSpaceTrackbar.Position]);
end;

procedure TProfileMountEditorPhysFSFrame.ZipFileButtonClick(Sender: TObject);
Var S : String;
begin
  If Trim(ZipFileEdit.Text)='' then S:=InfoData.DefaultInitialDir else S:=ZipFileEdit.Text;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  OpenDialog.DefaultExt:='zip';
  OpenDialog.InitialDir:=ExtractFilePath(S);
  OpenDialog.Title:=LanguageSetup.ProfileMountingZipFile;
  OpenDialog.Filter:=LanguageSetup.ProfileMountingZipFileFilter;
  if not OpenDialog.Execute then exit;
  ZipFileEdit.Text:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
end;

procedure TProfileMountEditorPhysFSFrame.RepackCheckBoxClick(Sender: TObject);
begin
  If (not RepackTypeComboBox.Enabled) and RepackCheckBox.Checked then begin
    RepackTypeComboBox.Enabled:=RepackCheckBox.Checked;
    RepackTypeComboBox.ItemIndex:=1;
  end else begin
    RepackTypeComboBox.Enabled:=RepackCheckBox.Checked;
  end;
end;

procedure TProfileMountEditorPhysFSFrame.ShowFrame;
begin
end;

procedure TProfileMountEditorPhysFSFrame.ZipFolderCreateButtonClick(Sender: TObject);
const AllowedChars='ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜabcdefghijklmnopqrstuvwxyz01234567890-_=';
Var S : String;
    I : Integer;
begin
  S:='';
  For I:=1 to length(InfoData.ProfileFileName) do if Pos(InfoData.ProfileFileName[I],AllowedChars)>0 then S:=S+InfoData.ProfileFileName[I];
  If S='' then S:='Game';

  S:=ExtUpperCase(S);
  If length(S)>8 then SetLength(S,8);

  S:=MakeAbsPath('.\'+PhysFSDefaultWriteDir+'\'+S,PrgSetup.BaseDir);
  If not ForceDirectories(S) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[S]),mtError,[mbOK],0);
  end;

  ZipFolderEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir,True);
end;

end.
