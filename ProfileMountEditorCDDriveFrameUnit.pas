unit ProfileMountEditorCDDriveFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ExtCtrls, ProfileMountEditorFormUnit;

type
  TProfileMountEditorCDDriveFrame = class(TFrame, TProfileMountEditorFrame)
    CDROMEdit: TLabeledEdit;
    CDROMLabelEdit: TLabeledEdit;
    CDROMButton: TSpeedButton;
    CDROMDriveAccessComboBox: TComboBox;
    CDROMDriveAccessLabel: TLabel;
    CDROMDriveLetterLabel: TLabel;
    CDROMDriveLetterComboBox: TComboBox;
    CDROMDriveLetterWarningLabel: TLabel;
    procedure CDROMButtonClick(Sender: TObject);
    procedure CDROMDriveLetterComboBoxChange(Sender: TObject);
  private
    { Private-Deklarationen }
    InfoData : TInfoData;
  public
    { Public-Deklarationen }
    Function Init(const AInfoData : TInfoData) : Boolean;
    Function Done : String;
    Function GetName : String;
  end;

implementation

uses LanguageSetupUnit, CommonTools, PrgSetupUnit;

{$R *.dfm}

{ TProfileMountEditorCDDriveFrame }

function TProfileMountEditorCDDriveFrame.Init(const AInfoData: TInfoData): Boolean;
Var C : Char;
    St : TStringList;
    S : String;
    I : Integer;
begin
  InfoData:=AInfoData;

  CDROMEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingFolder;
  CDROMLabelEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingLabel;

  CDROMDriveAccessLabel.Caption:=LanguageSetup.ProfileMountingCDROMAccess;
  CDROMDriveAccessComboBox.Items[0]:=LanguageSetup.ProfileMountingCDROMAccessNormal;
  CDROMDriveAccessComboBox.Items[1]:=LanguageSetup.ProfileMountingCDROMAccessIOCTL;
  CDROMDriveAccessComboBox.Items[2]:=LanguageSetup.ProfileMountingCDROMAccessNOIOCTL;
  CDROMDriveAccessComboBox.ItemIndex:=0;

  CDROMDriveLetterLabel.Caption:=LanguageSetup.ProfileMountingLetter;
  CDROMDriveLetterWarningLabel.Caption:=LanguageSetup.ProfileMountingDriveLetterAlreadyInUse;
  CDROMButton.Hint:=LanguageSetup.ChooseFolder;

  CDROMDriveLetterComboBox.Items.BeginUpdate;
  try
    CDROMDriveLetterComboBox.Items.Capacity:=30;
    For C:='A' to 'Y' do CDROMDriveLetterComboBox.Items.Add(C);
    CDROMDriveLetterComboBox.ItemIndex:=3;
  finally
    CDROMDriveLetterComboBox.Items.EndUpdate;
  end;

  St:=ValueToList(InfoData.Data);
  try
    S:=Trim(ExtUpperCase(St[1]));
    If S='CDROM' then begin
      result:=True;
      {RealFolder;CDROM;Letter;IO;Label;}
      CDROMEdit.Text:=St[0];
      If St.Count>=3 then begin
        I:=CDROMDriveLetterComboBox.Items.IndexOf(Trim(UpperCase(St[2]))); If I<0 then I:=2;
        CDROMDriveLetterComboBox.ItemIndex:=I;
      end;
      If St.Count>=4 then begin
        S:=Trim(ExtUpperCase(St[3]));
        CDROMDriveAccessComboBox.ItemIndex:=0;
        If S='TRUE' then CDROMDriveAccessComboBox.ItemIndex:=1;
        If S='NOIOCTL' then CDROMDriveAccessComboBox.ItemIndex:=2;
      end;
      If St.Count>=5 then begin
        CDROMLabelEdit.Text:=St[4];
      end;
    end else begin
      result:=False;
      For I:=2 to CDROMDriveLetterComboBox.Items.Count-1 do begin
        If Pos(CDROMDriveLetterComboBox.Items[I],InfoData.UsedDriveLetters)=0 then begin CDROMDriveLetterComboBox.ItemIndex:=I; break; end;
      end;
    end;
  finally
    St.Free;
  end;

  CDROMDriveLetterComboBoxChange(self);
end;

function TProfileMountEditorCDDriveFrame.Done: String;
Var S : String;
begin
  {RealFolder;CDROM;Letter;IO;Label;}
  Case CDROMDriveAccessComboBox.ItemIndex of
    1 : S:='true';
    2 : S:='NoIOCTL';
    else S:='false';
  end;
  result:=CDROMEdit.Text+';CDROM;'+CDROMDriveLetterComboBox.Text+';'+S+';'+CDROMLabelEdit.Text+';';
end;

function TProfileMountEditorCDDriveFrame.GetName: String;
begin
  result:=LanguageSetup.ProfileMountingCDROMSheet;
end;

procedure TProfileMountEditorCDDriveFrame.CDROMButtonClick(Sender: TObject);
Var S : String;
begin
  If Trim(CDROMEdit.Text)='' then S:=InfoData.DefaultInitialDir else S:=CDROMEdit.Text;
  S:=MakeAbsPath(S,PrgSetup.BaseDir);
  if not SelectDirectory(Handle,LanguageSetup.ProfileMountingFolder,S) then exit;
  CDROMEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir);
end;

procedure TProfileMountEditorCDDriveFrame.CDROMDriveLetterComboBoxChange(Sender: TObject);
begin
  CDROMDriveLetterWarningLabel.Visible:=(CDROMDriveLetterComboBox.ItemIndex>=0) and (Pos(CDROMDriveLetterComboBox.Items[CDROMDriveLetterComboBox.ItemIndex],InfoData.UsedDriveLetters)>0);
end;

end.
