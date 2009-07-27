unit ProfileMountEditorZipFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ProfileMountEditorFormUnit, ComCtrls, StdCtrls, ExtCtrls, Buttons;

type
  TProfileMountEditorZipFrame = class(TFrame, TProfileMountEditorFrame)
    ZipFolderButton: TSpeedButton;
    ZipFolderDriveLetterLabel: TLabel;
    ZipFolderFreeSpaceLabel: TLabel;
    ZipFolderDriveLetterWarningLabel: TLabel;
    ZipFileButton: TSpeedButton;
    ZipFolderEdit: TLabeledEdit;
    ZipFolderDriveLetterComboBox: TComboBox;
    ZipFolderFreeSpaceTrackbar: TTrackBar;
    ZipFileEdit: TLabeledEdit;
    OpenDialog: TOpenDialog;
    RepackTypeLabel: TLabel;
    RepackTypeComboBox: TComboBox;
    InfoLabel: TLabel;
    ZipFolderCreateButton: TSpeedButton;
    procedure ZipFolderButtonClick(Sender: TObject);
    procedure ZipFolderDriveLetterComboBoxChange(Sender: TObject);
    procedure ZipFolderFreeSpaceTrackbarChange(Sender: TObject);
    procedure ZipFileButtonClick(Sender: TObject);
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

uses LanguageSetupUnit, CommonTools, PrgSetupUnit, PrgConsts, ZipInfoFormUnit,
     IconLoaderUnit;

{$R *.dfm}

{ TProfileMountEditorZipFrame }

function TProfileMountEditorZipFrame.Init(const AInfoData: TInfoData): Boolean;
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

  RepackTypeLabel.Caption:=LanguageSetup.ProfileMountingZipRepack;
  RepackTypeComboBox.Items[0]:=LanguageSetup.ProfileMountingZipRepackNoDelete;
  RepackTypeComboBox.Items[1]:=LanguageSetup.ProfileMountingZipRepackDeleteFiles;
  RepackTypeComboBox.Items[2]:=LanguageSetup.ProfileMountingZipRepackDeleteFolder;
  RepackTypeComboBox.ItemIndex:=0;  

  InfoLabel.Caption:=LanguageSetup.ProfileMountingZipInfo;

  UserIconLoader.DialogImage(DI_SelectFolder,ZipFolderButton);
  UserIconLoader.DialogImage(DI_Create,ZipFolderCreateButton);
  UserIconLoader.DialogImage(DI_SelectFile,ZipFileButton);

  St:=ValueToList(InfoData.Data);
  try
    S:=Trim(ExtUpperCase(St[1]));
    If S='ZIP' then begin
      {RealFolder$ZipFile;ZIP;Letter;False;;FreeSpace;DeleteMode(no;files;folder)}
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
        If S='NO' then RepackTypeComboBox.ItemIndex:=0;
        If S='FILES' then RepackTypeComboBox.ItemIndex:=1;
        If S='FOLDER' then RepackTypeComboBox.ItemIndex:=2;
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
end;

procedure TProfileMountEditorZipFrame.ShowFrame;
begin
end;

function TProfileMountEditorZipFrame.Done: String;
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

  If (RepackTypeComboBox.ItemIndex>0) and (S=T) then begin
    If MessageDlg(Format(LanguageSetup.ProfileMountingFolderDeleteWarning,[PrgSetup.GameDir]),mtWarning,[mbYes,mbNo],0)<>mrYes then B:=False;
  end;

  {RealFolder$ZipFile;ZIP;Letter;False;;FreeSpace;DeleteMode(no;files;folder)}
  S:=MakeRelPath(ZipFolderEdit.Text,PrgSetup.BaseDir)+'$'+MakeRelPath(ZipFileEdit.Text,PrgSetup.BaseDir)+';ZIP;'+ZipFolderDriveLetterComboBox.Text+';False;';
  S:=S+';'+IntToStr(ZipFolderFreeSpaceTrackBar.Position);
  Case RepackTypeComboBox.ItemIndex of
    0 : S:=S+';no';
    1 : S:=S+';files';
    2 : S:=S+';folder';
  end;

  If B then result:=S else result:='';
end;

function TProfileMountEditorZipFrame.GetName: String;
begin
  result:=LanguageSetup.ProfileMountingZipSheet;
end;

procedure TProfileMountEditorZipFrame.ZipFolderButtonClick(Sender: TObject);
Var S : String;
begin
  If Trim(ZipFolderEdit.Text)='' then S:=InfoData.DefaultInitialDir else S:=ZipFolderEdit.Text;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  if not SelectDirectory(Handle,LanguageSetup.ProfileMountingFolder,S) then exit;
  ZipFolderEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir,True);
end;

procedure TProfileMountEditorZipFrame.ZipFolderDriveLetterComboBoxChange(Sender: TObject);
begin
  ZipFolderDriveLetterWarningLabel.Visible:=(ZipFolderDriveLetterComboBox.ItemIndex>=0) and (Pos(ZipFolderDriveLetterComboBox.Items[ZipFolderDriveLetterComboBox.ItemIndex],InfoData.UsedDriveLetters)>0);
end;

procedure TProfileMountEditorZipFrame.ZipFolderFreeSpaceTrackbarChange(Sender: TObject);
begin
  ZipFolderFreeSpaceLabel.Caption:=Format(LanguageSetup.ProfileMountingFreeSpace,[ZipFolderFreeSpaceTrackbar.Position]);
end;

procedure TProfileMountEditorZipFrame.ZipFileButtonClick(Sender: TObject);
Var S : String;
begin
  If Trim(ZipFileEdit.Text)='' then S:=InfoData.DefaultInitialDir else S:=ZipFileEdit.Text;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  OpenDialog.DefaultExt:='zip';
  OpenDialog.InitialDir:=ExtractFilePath(S);
  OpenDialog.Title:=LanguageSetup.ProfileMountingZipFile;
  OpenDialog.Filter:=ProcessFileNameFilter(LanguageSetup.ProfileMountingZipFileFilter2,LanguageSetup.ProfileMountingZipFileFilter2ArchiveFiles);
  if not OpenDialog.Execute then exit;
  ZipFileEdit.Text:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
end;

procedure TProfileMountEditorZipFrame.ZipFolderCreateButtonClick(Sender: TObject);
const AllowedChars='ABCDEFGHIJKLMNOPQRSTUVWXYZ���abcdefghijklmnopqrstuvwxyz01234567890-_=';
Var S : String;
    I : Integer;
begin
  S:='';
  For I:=1 to length(InfoData.ProfileFileName) do if Pos(InfoData.ProfileFileName[I],AllowedChars)>0 then S:=S+InfoData.ProfileFileName[I];
  If S='' then S:='Game';

  S:=ExtUpperCase(S);
  If length(S)>8 then SetLength(S,8);

  S:=MakeAbsPath('.\'+ZipTempDir+'\'+S,PrgSetup.BaseDir);
  If not ForceDirectories(S) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotCreateDir,[S]),mtError,[mbOK],0);
  end;

  ZipFolderEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir,True);
end;

end.