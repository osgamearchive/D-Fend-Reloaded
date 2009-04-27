unit ProfileMountEditorDriveFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, ProfileMountEditorFormUnit;

type
  TProfileMountEditorDriveFrame = class(TFrame, TProfileMountEditorFrame)
    FolderEdit: TLabeledEdit;
    FolderButton: TSpeedButton;
    FolderDriveLetterLabel: TLabel;
    FolderDriveLetterComboBox: TComboBox;
    FolderDriveLetterWarningLabel: TLabel;
    FolderFreeSpaceLabel: TLabel;
    FolderFreeSpaceTrackBar: TTrackBar;
    procedure FolderFreeSpaceTrackBarChange(Sender: TObject);
    procedure FolderButtonClick(Sender: TObject);
    procedure FolderDriveLetterComboBoxChange(Sender: TObject);
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

uses LanguageSetupUnit, CommonTools, PrgSetupUnit, IconLoaderUnit;

{$R *.dfm}

{ TProfileMountEditorDriveFrame }

Function TProfileMountEditorDriveFrame.Init(const AInfoData: TInfoData) : Boolean;
Var C : Char;
    St : TStringList;
    S : String;
    I : Integer;
begin
  InfoData:=AInfoData;

  FolderEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingFolder;
  FolderDriveLetterLabel.Caption:=LanguageSetup.ProfileMountingLetter;
  FolderDriveLetterWarningLabel.Caption:=LanguageSetup.ProfileMountingDriveLetterAlreadyInUse;
  FolderButton.Hint:=LanguageSetup.ChooseFolder;

  FolderDriveLetterComboBox.Items.BeginUpdate;
  try
    FolderDriveLetterComboBox.Items.Capacity:=30;
    For C:='A' to 'Y' do FolderDriveLetterComboBox.Items.Add(C);
    FolderDriveLetterComboBox.ItemIndex:=2;
  finally
    FolderDriveLetterComboBox.Items.EndUpdate;
  end;

  UserIconLoader.DialogImage(DI_SelectFolder,FolderButton);

  St:=ValueToList(InfoData.Data);
  try
    S:=Trim(ExtUpperCase(St[1]));
    If S='DRIVE' then begin
      result:=True;
      {RealFolder;DRIVE;Letter;False;;FreeSpace}
      FolderEdit.Text:=St[0];
      If St.Count>=3 then begin
        I:=FolderDriveLetterComboBox.Items.IndexOf(Trim(UpperCase(St[2]))); If I<0 then I:=2;
        FolderDriveLetterComboBox.ItemIndex:=I;
      end;
      If St.Count>=6 then begin
        try I:=StrToInt(St[5]); except I:=0; end;
        If (I>=10) and (I<=4000) then FolderFreeSpaceTrackBar.Position:=I;
      end;
    end else begin
      result:=False;
      For I:=2 to FolderDriveLetterComboBox.Items.Count-1 do begin
        If Pos(FolderDriveLetterComboBox.Items[I],InfoData.UsedDriveLetters)=0 then begin FolderDriveLetterComboBox.ItemIndex:=I; break; end;
      end;
    end;
  finally
    St.Free;
  end;

  FolderDriveLetterComboBoxChange(self);
  FolderFreeSpaceTrackBarChange(self);
end;

procedure TProfileMountEditorDriveFrame.ShowFrame;
begin
end;

Function TProfileMountEditorDriveFrame.Done : String;
Var S : String;
begin
  result:='';

  {RealFolder;DRIVE;Letter;False;;FreeSpace}
  S:=Trim(IncludeTrailingPathDelimiter(FolderEdit.Text));
  If (length(S)=3) and (Copy(S,2,2)=':\') then begin
    If MessageDlg(LanguageSetup.MessageRootDirMountWaring,mtWarning,[mbYes,mbNo],0)<>mrYes then exit;
  end;
  result:=FolderEdit.Text+';Drive;'+FolderDriveLetterComboBox.Text+';False;;';
  If FolderFreeSpaceTrackBar.Position<>105 then result:=result+IntToStr(FolderFreeSpaceTrackBar.Position);
end;

function TProfileMountEditorDriveFrame.GetName: String;
begin
  result:=LanguageSetup.ProfileMountingFolderSheet;
end;

procedure TProfileMountEditorDriveFrame.FolderButtonClick(Sender: TObject);
Var S : String;
begin
  If Trim(FolderEdit.Text)='' then S:=InfoData.DefaultInitialDir else S:=FolderEdit.Text;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  if not SelectDirectory(Handle,LanguageSetup.ProfileMountingFolder,S) then exit;
  FolderEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir,True);
end;

procedure TProfileMountEditorDriveFrame.FolderDriveLetterComboBoxChange(Sender: TObject);
begin
  FolderDriveLetterWarningLabel.Visible:=(FolderDriveLetterComboBox.ItemIndex>=0) and (Pos(FolderDriveLetterComboBox.Items[FolderDriveLetterComboBox.ItemIndex],InfoData.UsedDriveLetters)>0);
end;

procedure TProfileMountEditorDriveFrame.FolderFreeSpaceTrackBarChange(Sender: TObject);
begin
  FolderFreeSpaceLabel.Caption:=Format(LanguageSetup.ProfileMountingFreeSpace,[FolderFreeSpaceTrackbar.Position]);
end;

end.
