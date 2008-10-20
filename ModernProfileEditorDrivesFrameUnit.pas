unit ModernProfileEditorDrivesFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ComCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorDrivesFrame = class(TFrame, IModernProfileEditorFrame)
    AutoMountCheckBox: TCheckBox;
    MountingListView: TListView;
    MountingAddButton: TBitBtn;
    MountingEditButton: TBitBtn;
    MountingDelButton: TBitBtn;
    MountingDeleteAllButton: TBitBtn;
    MountingAutoCreateButton: TBitBtn;
    procedure ButtonWork(Sender: TObject);
    procedure MountingListViewDblClick(Sender: TObject);
    procedure MountingListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private-Deklarationen }
    Mounting : TStringList;
    ProfileExe, ProfileSetup, ProfileName : PString;
    Procedure LoadMountingList;
    function NextFreeDriveLetter: Char;
    Function UsedDriveLetters(const AllowedNr : Integer = -1) : String;
    function CanReachFile(const FileName: String): Boolean;
  public
    { Public-Deklarationen }
    Destructor Destroy; override;
    Procedure InitGUI(const InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Function CheckValue : Boolean;
    Procedure GetGame(const Game : TGame);
    Procedure ShowFrame;
  end;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit,
     ProfileMountEditorFormUnit, HelpConsts;

{$R *.dfm}

{ TModernProfileEditorDrivesFrame }

procedure TModernProfileEditorDrivesFrame.InitGUI(const InitData : TModernProfileEditorInitData);
Var L : TListColumn;
begin
  NoFlicker(MountingListView);
  NoFlicker(MountingAddButton);
  NoFlicker(MountingEditButton);
  NoFlicker(MountingDelButton);
  NoFlicker(MountingDeleteAllButton);
  NoFlicker(MountingAutoCreateButton);
  NoFlicker(AutoMountCheckBox);

  MountingAddButton.Caption:=LanguageSetup.ProfileEditorMountingAdd;
  MountingEditButton.Caption:=LanguageSetup.ProfileEditorMountingEdit;
  MountingDelButton.Caption:=LanguageSetup.ProfileEditorMountingDel;
  MountingDeleteAllButton.Caption:=LanguageSetup.ProfileEditorMountingDelAll;
  MountingAutoCreateButton.Caption:=LanguageSetup.ProfileEditorMountingAutoCreate;
  L:=MountingListView.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingFolderImage;
  L:=MountingListView.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingAs;
  L:=MountingListView.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingLetter;
  L:=MountingListView.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingLabel;
  L:=MountingListView.Columns.Add; L.Width:=-2; L.Caption:=LanguageSetup.ProfileEditorMountingIOControl;
  AutoMountCheckBox.Caption:=LanguageSetup.ProfileEditorMountingAutoMountCDs;

  ProfileExe:=InitData.CurrentProfileExe;
  ProfileSetup:=InitData.CurrentProfileSetup;
  ProfileName:=InitData.CurrentProfileName;

  HelpContext:=ID_ProfileEditDrives;
end;

procedure TModernProfileEditorDrivesFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var I : Integer;
begin
  Mounting:=TStringList.Create;
  For I:=0 to 9 do
    If Game.NrOfMounts>=I+1 then Mounting.Add(Game.Mount[I]) else break;
  LoadMountingList;
  AutoMountCheckBox.Checked:=Game.AutoMountCDs;
end;

procedure TModernProfileEditorDrivesFrame.ShowFrame;
begin
end;

procedure TModernProfileEditorDrivesFrame.LoadMountingList;
Var I : Integer;
    St : TStringList;
    L : TListItem;
    S : String;
    B : Boolean;
begin
  MountingListView.Items.BeginUpdate;
  try
    MountingListView.Items.Clear;
    For I:=0 to Mounting.Count-1 do begin
      St:=ValueToList(Mounting[I]);
      try
        L:=MountingListView.Items.Add;
        S:=Trim(St[0]);
        If (St.Count>1) and ((Trim(ExtUpperCase(St[1]))='PHYSFS') or (Trim(ExtUpperCase(St[1]))='ZIP')) then begin
          If Pos('$',S)<>0 then S:=Copy(S,Pos('$',S)+1,MaxInt)+' (+ '+Copy(S,1,Pos('$',S)-1)+')';
        end else begin
          If Pos('$',S)<>0 then S:=Copy(S,1,Pos('$',S)-1)+' (+'+LanguageSetup.More+')';
        end;
        L.Caption:=S;
        If St.Count>1 then begin
          S:=Trim(ExtUpperCase(St[1])); B:=False;
          If (not B) and (S='DRIVE') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeDRIVE); B:=True; end;
          If (not B) and (S='CDROM') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeCDROM); B:=True; end;
          If (not B) and (S='CDROMIMAGE') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeCDROMIMAGE); B:=True; end;
          If (not B) and (S='FLOPPY') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeFLOPPY); B:=True; end;
          If (not B) and (S='FLOPPYIMAGE') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeFLOPPYIMAGE); B:=True; end;
          If (not B) and (S='IMAGE') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeIMAGE); B:=True; end;
          If (not B) and (S='PHYSFS') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypePHYSFS); B:=True; end;
          If (not B) and (S='ZIP') then begin L.SubItems.Add(LanguageSetup.ProfileEditorMountingDriveTypeZIP); B:=True; end;
          If not B then L.SubItems.Add(St[1]);
        end else begin
          L.SubItems.Add('');
        end;
        If St.Count>2 then L.SubItems.Add(St[2]) else L.SubItems.Add('');
        If St.Count>4 then L.SubItems.Add(St[4]) else L.SubItems.Add('');
        If St.Count>3 then begin
          If Trim(ExtUpperCase(St[3]))='TRUE' then L.SubItems.Add(RemoveUnderline(LanguageSetup.Yes)) else L.SubItems.Add(RemoveUnderline(LanguageSetup.No));
        end else L.SubItems.Add(RemoveUnderline(LanguageSetup.No));
      finally
        St.Free;
      end;
    end;
    If MountingListView.Items.Count>0 then MountingListView.ItemIndex:=0;
  finally
    MountingListView.Items.EndUpdate;
  end;
end;

function TModernProfileEditorDrivesFrame.NextFreeDriveLetter: Char;
Var I : Integer;
    B : Boolean;
    St : TStringList;
begin
  result:='C';
  repeat
    B:=True;
    For I:=0 to Mounting.Count-1 do begin
      St:=ValueToList(Mounting[I]);
      try
        If St.Count<3 then continue;
        if UpperCase(St[2])=result then begin inc(result); B:=False; break; end;
      finally
        St.Free;
      end;
    end;
  until B;
end;

function TModernProfileEditorDrivesFrame.UsedDriveLetters(const AllowedNr : Integer): String;
Var I : Integer;
    St : TStringList;
begin
  result:='';
  For I:=0 to Mounting.Count-1 do If I<>AllowedNr then begin
    St:=ValueToList(Mounting[I]);
    try
      If St.Count>=3 then result:=result+UpperCase(St[2]);
    finally
      St.Free;
    end;
  end;
end;

Function ShortName(const LongName : String) : String;
begin
  SetLength(result,MAX_PATH+10);
  if GetShortPathName(PChar(LongName),PChar(result),MAX_PATH)=0
    then result:=LongName
    else SetLength(result,StrLen(PChar(result)));
end;

function TModernProfileEditorDrivesFrame.CanReachFile(const FileName: String): Boolean;
Var S,FilePath : String;
    St : TStringList;
    I : Integer;
begin
  result:=False;
  FilePath:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(MakeAbsPath(ExtractFilePath(FileName),PrgSetup.BaseDir)))));
  For I:=0 to Mounting.Count-1 do begin
    St:=ValueToList(Mounting[I]);
    try
      {Types to check:
       RealFolder;DRIVE;Letter;False;;FreeSpace
       RealFolder;FLOPPY;Letter;False;;
       RealFolder;CDROM;Letter;IO;Label;
       all other are images}
      If St.Count<2 then continue;
      S:=Trim(ExtUpperCase(St[1]));
      If (S<>'DRIVE') and (S<>'FLOPPY') and (S<>'CDROM') then continue;
      S:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(MakeAbsPath(St[0],PrgSetup.BaseDir)))));

      result:=(Copy(FilePath,1,length(S))=S);
      if result then exit;
    finally
      St.Free;
    end;
  end;
end;

procedure TModernProfileEditorDrivesFrame.ButtonWork(Sender: TObject);
Var S,T : String;
    I : Integer;
    St : TStringList;
    B : Boolean;
begin
  Case (Sender as TComponent).Tag of
    0 : If Mounting.Count<10 then begin
          S:='';
          if not ShowProfileMountEditorDialog(self,S,UsedDriveLetters,IncludeTrailingPathDelimiter(ExtractFilePath(ProfileExe^)),ProfileName^,NextFreeDriveLetter) then exit;
          Mounting.Add(S);
          LoadMountingList;
          MountingListView.ItemIndex:=MountingListView.Items.Count-1;
        end;
    1 : begin
          I:=MountingListView.ItemIndex;
          If I<0 then exit;
          S:=Mounting[I];
          if not ShowProfileMountEditorDialog(self,S,UsedDriveLetters(I),IncludeTrailingPathDelimiter(ExtractFilePath(ProfileExe^)),ProfileName^) then exit;
          Mounting[I]:=S;
          LoadMountingList;
          MountingListView.ItemIndex:=I;
        end;
    2 : begin
          I:=MountingListView.ItemIndex;
          If I<0 then exit;
          Mounting.Delete(I);
          LoadMountingList;
          If Mounting.Count>0 then MountingListView.ItemIndex:=Max(0,I-1);
        end;
    3 : If (Mounting.Count>0) and (Messagedlg(LanguageSetup.ProfileEditorMountingDeleteAllMessage,mtConfirmation,[mbYes,mbNo],0)=mrYes) then begin
          Mounting.Clear;
          LoadMountingList;
        end;
    4 : begin
          I:=0;
          while I<Mounting.Count do begin
            St:=ValueToList(Mounting[I]);
            try
              If (St.Count>=3) and (St[2]='C') then begin Mounting.Delete(I); continue; end;
              inc(I);
            finally
              St.Free;
            end;
          end;
          {Add VirtualHD dir}
          If Mounting.Count<10 then Mounting.Insert(0,MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir)+';Drive;C;false;');
          {Add game dir if needed}
          If (Mounting.Count<10) and (Trim(ProfileExe^)<>'') and (not CanReachFile(ProfileExe^)) and (ExtUpperCase(Copy(ProfileExe^,1,7))<>'DOSBOX:') then begin
            S:=IncludeTrailingPathDelimiter(MakeRelPath(ExtractFilePath(ProfileExe^),PrgSetup.BaseDir));
            Mounting.Add(S+';DRIVE;'+NextFreeDriveLetter+';False;;105');
          end;
          {Add setup dir if needed}
          If (Mounting.Count<10) and (Trim(ProfileSetup^)<>'') and (not CanReachFile(ProfileSetup^)) and (ExtUpperCase(Copy(ProfileSetup^,1,7))<>'DOSBOX:') then begin
            S:=IncludeTrailingPathDelimiter(MakeRelPath(ExtractFilePath(ProfileSetup^),PrgSetup.BaseDir));
            Mounting.Add(S+';DRIVE;'+NextFreeDriveLetter+';False;;105');
          end;
          LoadMountingList;
        end;
  end;
end;

procedure TModernProfileEditorDrivesFrame.MountingListViewDblClick(Sender: TObject);
begin
  ButtonWork(MountingEditButton);
end;

procedure TModernProfileEditorDrivesFrame.MountingListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Shift=[ssCtrl]) and (Key=VK_RETURN) then begin ButtonWork(MountingEditButton); exit; end;
  If Shift<>[] then exit;
  Case Key of
    VK_INSERT : ButtonWork(MountingAddButton);
    VK_RETURN : ButtonWork(MountingEditButton);
    VK_DELETE : ButtonWork(MountingDelButton);
  end;
end;

function TModernProfileEditorDrivesFrame.CheckValue: Boolean;
begin
  result:=True;
end;

procedure TModernProfileEditorDrivesFrame.GetGame(const Game: TGame);
Var I : Integer;
begin
  Game.NrOfMounts:=Mounting.Count;
  For I:=0 to 9 do
    If Mounting.Count>I then Game.Mount[I]:=Mounting[I] else Game.Mount[I]:='';
  Game.AutoMountCDs:=AutoMountCheckBox.Checked;
end;

Destructor TModernProfileEditorDrivesFrame.Destroy;
begin
  Mounting.Free;
  inherited Destroy;
end;

end.
