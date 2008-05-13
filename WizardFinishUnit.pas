unit WizardFinishUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, GameDBUnit, ComCtrls, Buttons;

type
  TWizardFinishFrame = class(TFrame)
    InfoLabel: TLabel;
    Bevel: TBevel;
    DriveSetupLabel: TLabel;
    MountingListView: TListView;
    ProfileEditorCheckBox: TCheckBox;
    ProfileEditorLabel: TLabel;
    MountingAddButton: TBitBtn;
    MountingEditButton: TBitBtn;
    MountingDelButton: TBitBtn;
    MountingDeleteAllButton: TBitBtn;
    MountingAutoCreateButton: TBitBtn;
    procedure MountingListViewDblClick(Sender: TObject);
    procedure MountingListViewKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ButtonWork(Sender: TObject);
  private
    { Private-Deklarationen }
    Mounting, MountingSave : TStringList;
    CurrentGameFile : String;
    function NextFreeDriveLetter: Char;
    function UsedDriveLetters(const AllowedNr : Integer = -1): String;
    procedure LoadMountingList;
    Function CanReachFile(const FileName : String) : Boolean;
  public
    { Public-Deklarationen }
    Procedure Init(const GameDB : TGameDB);
    Procedure Done;
    Procedure SetInsecureStatus(const Insecure : Boolean);
    procedure LoadData(const Template: TGame; const GameFile, SetupFile : String);
    Procedure WriteDataToGame(const Game : TGame);
  end;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit,
     ProfileMountEditorFormUnit;

{$R *.dfm}

{ TWizardFinishFrame }

procedure TWizardFinishFrame.Init(const GameDB: TGameDB);
Var L : TListColumn;
begin
  SetVistaFonts(self);

  InfoLabel.Font.Style:=[fsBold];
  ProfileEditorLabel.Font.Style:=[fsBold];
  InfoLabel.Caption:=LanguageSetup.WizardFormPage5Info;
  DriveSetupLabel.Caption:=LanguageSetup.WizardFormDriveSetupLabel;
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
  ProfileEditorCheckBox.Caption:=LanguageSetup.WizardFormOpenProfileEditor;
  ProfileEditorLabel.Caption:=LanguageSetup.WizardFormOpenProfileEditorInfo;

  Mounting:=TStringList.Create;
  MountingSave:=TStringList.Create;
end;

procedure TWizardFinishFrame.Done;
begin
  Mounting.Free;
  MountingSave.Free;
end;

procedure TWizardFinishFrame.SetInsecureStatus(const Insecure: Boolean);
begin
  If Insecure then begin
    ProfileEditorCheckBox.Checked:=True;
    ProfileEditorCheckBox.Enabled:=False;
    ProfileEditorLabel.Visible:=True;
  end else begin
    ProfileEditorCheckBox.Enabled:=True;
    ProfileEditorLabel.Visible:=False;
  end;
end;

Function ShortName(const LongName : String) : String;
begin
  SetLength(result,MAX_PATH+10);
  if GetShortPathName(PChar(LongName),PChar(result),MAX_PATH)=0
    then result:=LongName
    else SetLength(result,StrLen(PChar(result)));
end;

function TWizardFinishFrame.CanReachFile(const FileName: String): Boolean;
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

procedure TWizardFinishFrame.LoadData(const Template: TGame; const GameFile, SetupFile : String);
Var G : TGame;
    S,T : String;
    I : Integer;
    St : TStringList;
    B : Boolean;
begin
  Mounting.Clear;

  {Load from template}
  If Template=nil then G:=TGame.Create(PrgSetup) else G:=Template;
  try
    If G.NrOfMounts>=1 then Mounting.Add(G.Mount0);
    If G.NrOfMounts>=2 then Mounting.Add(G.Mount1);
    If G.NrOfMounts>=3 then Mounting.Add(G.Mount2);
    If G.NrOfMounts>=4 then Mounting.Add(G.Mount3);
    If G.NrOfMounts>=5 then Mounting.Add(G.Mount4);
    If G.NrOfMounts>=6 then Mounting.Add(G.Mount5);
    If G.NrOfMounts>=7 then Mounting.Add(G.Mount6);
    If G.NrOfMounts>=8 then Mounting.Add(G.Mount7);
    If G.NrOfMounts>=9 then Mounting.Add(G.Mount8);
    If G.NrOfMounts>=10 then Mounting.Add(G.Mount9);
  finally
    If Template=nil then G.Free;
  end;

  {Add GameDir}

  B:=False;
  T:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(MakeAbsPath(PrgSetup.GameDir,PrgSetup.BaseDir)))));
  For I:=0 to Mounting.Count-1 do begin
    St:=ValueToList(Mounting[I]);
    try
      If (St.Count<2) or (Trim(ExtUpperCase(St[1]))<>'DRIVE') then continue;
      S:=Trim(ExtUpperCase(IncludeTrailingPathDelimiter(ShortName(MakeAbsPath(St[0],PrgSetup.BaseDir)))));
      B:=(T=S); If B then break;
    finally
      St.Free;
    end;
  end;
  if not B then Mounting.Add(MakeRelPath(PrgSetup.GameDir,PrgSetup.BaseDir)+';DRIVE;'+NextFreeDriveLetter+';False;;105');

  {Load from game}
  If (Trim(GameFile)<>'') and (not CanReachFile(GameFile)) then begin
    S:=IncludeTrailingPathDelimiter(MakeRelPath(ExtractFilePath(GameFile),PrgSetup.BaseDir));
    Mounting.Add(S+';DRIVE;'+NextFreeDriveLetter+';False;;105');
  end;

  If (Trim(SetupFile)<>'') and (not CanReachFile(SetupFile)) then begin
    S:=IncludeTrailingPathDelimiter(MakeRelPath(ExtractFilePath(SetupFile),PrgSetup.BaseDir));
    Mounting.Add(S+';DRIVE;'+NextFreeDriveLetter+';False;;105');
  end;

  CurrentGameFile:=GameFile;

  MountingSave.Assign(Mounting);
  LoadMountingList;
end;

procedure TWizardFinishFrame.LoadMountingList;
Var I : Integer;
    St : TStringList;
    L : TListItem;
    S : String;
begin
  MountingListView.Items.BeginUpdate;
  try
    MountingListView.Items.Clear;
    For I:=0 to Mounting.Count-1 do begin
      St:=ValueToList(Mounting[I]);
      try
        L:=MountingListView.Items.Add;
        S:=Trim(St[0]);
        If (St.Count>1) and (Trim(ExtUpperCase(St[1]))='PHYSFS') then begin
          If Pos('$',S)<>0 then S:=Copy(S,Pos('$',S)+1,MaxInt)+' (+ '+Copy(S,1,Pos('$',S)-1)+')';
        end else begin
          If Pos('$',S)<>0 then S:=Copy(S,1,Pos('$',S)-1)+' (+'+LanguageSetup.More+')';
        end;
        L.Caption:=S;
        If St.Count>1 then L.SubItems.Add(St[1]) else L.SubItems.Add('');
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

function TWizardFinishFrame.NextFreeDriveLetter: Char;
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

function TWizardFinishFrame.UsedDriveLetters(const AllowedNr : Integer): String;
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

procedure TWizardFinishFrame.ButtonWork(Sender: TObject);
Var S : String;
    I : Integer;
begin
  Case (Sender as TComponent).Tag of
    0 : If Mounting.Count<10 then begin
          S:=';Drive;'+NextFreeDriveLetter+';false;;';
          if not ShowProfileMountEditorDialog(self,S,UsedDriveLetters,IncludeTrailingPathDelimiter(ExtractFilePath(CurrentGameFile))) then exit;
          Mounting.Add(S);
          LoadMountingList;
          MountingListView.ItemIndex:=MountingListView.Items.Count-1;
        end;
    1 : begin
          I:=MountingListView.ItemIndex;
          If I<0 then exit;
          S:=Mounting[I];
          if not ShowProfileMountEditorDialog(self,S,UsedDriveLetters(I),IncludeTrailingPathDelimiter(ExtractFilePath(CurrentGameFile))) then exit;
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
          Mounting.Assign(MountingSave);
          LoadMountingList;
        end;
  end;
end;

procedure TWizardFinishFrame.MountingListViewDblClick(Sender: TObject);
begin
  ButtonWork(MountingEditButton);
end;

procedure TWizardFinishFrame.MountingListViewKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If Shift<>[] then exit;
  Case Key of
    VK_INSERT : ButtonWork(MountingAddButton);
    VK_RETURN : ButtonWork(MountingEditButton);
    VK_DELETE : ButtonWork(MountingDelButton);
  end;
end;

procedure TWizardFinishFrame.WriteDataToGame(const Game: TGame);
begin
  Game.NrOfMounts:=Mounting.Count;
  If Mounting.Count>0 then Game.Mount0:=Mounting[0] else Game.Mount0:='';
  If Mounting.Count>1 then Game.Mount1:=Mounting[1] else Game.Mount1:='';
  If Mounting.Count>2 then Game.Mount2:=Mounting[2] else Game.Mount2:='';
  If Mounting.Count>3 then Game.Mount3:=Mounting[3] else Game.Mount3:='';
  If Mounting.Count>4 then Game.Mount4:=Mounting[4] else Game.Mount4:='';
  If Mounting.Count>5 then Game.Mount5:=Mounting[5] else Game.Mount5:='';
  If Mounting.Count>6 then Game.Mount6:=Mounting[6] else Game.Mount6:='';
  If Mounting.Count>7 then Game.Mount7:=Mounting[7] else Game.Mount7:='';
  If Mounting.Count>8 then Game.Mount8:=Mounting[8] else Game.Mount8:='';
  If Mounting.Count>9 then Game.Mount9:=Mounting[9] else Game.Mount9:='';
  Game.AutoMountCDs:=False;
end;

end.
