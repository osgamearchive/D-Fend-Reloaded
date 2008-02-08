unit ModernProfileEditorDrivesFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Buttons, ComCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorDrivesFrame = class(TFrame, IModernProfileEditorFrame)
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
    Procedure LoadMountingList;
    function NextFreeDriveLetter: Char;
  public
    { Public-Deklarationen }
    Procedure InitGUI(const OnProfileNameChange : TTextEvent; const GameDB: TGameDB; const CurrentProfileName : PString);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Function CheckValue : Boolean;
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses Math, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit,
     ProfileMountEditorFormUnit;

{$R *.dfm}

{ TModernProfileEditorDrivesFrame }

procedure TModernProfileEditorDrivesFrame.InitGUI(const OnProfileNameChange: TTextEvent; const GameDB: TGameDB; const CurrentProfileName: PString);
Var L : TListColumn;
begin
  NoFlicker(MountingListView);
  NoFlicker(MountingAddButton);
  NoFlicker(MountingEditButton);
  NoFlicker(MountingDelButton);
  NoFlicker(MountingDeleteAllButton);
  NoFlicker(MountingAutoCreateButton);

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
end;

procedure TModernProfileEditorDrivesFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
begin
  Mounting:=TStringList.Create;
  If Game.NrOfMounts>=1 then Mounting.Add(Game.Mount0);
  If Game.NrOfMounts>=2 then Mounting.Add(Game.Mount1);
  If Game.NrOfMounts>=3 then Mounting.Add(Game.Mount2);
  If Game.NrOfMounts>=4 then Mounting.Add(Game.Mount3);
  If Game.NrOfMounts>=5 then Mounting.Add(Game.Mount4);
  If Game.NrOfMounts>=6 then Mounting.Add(Game.Mount5);
  If Game.NrOfMounts>=7 then Mounting.Add(Game.Mount6);
  If Game.NrOfMounts>=8 then Mounting.Add(Game.Mount7);
  If Game.NrOfMounts>=9 then Mounting.Add(Game.Mount8);
  If Game.NrOfMounts>=10 then Mounting.Add(Game.Mount9);
  LoadMountingList;
end;

procedure TModernProfileEditorDrivesFrame.LoadMountingList;
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

procedure TModernProfileEditorDrivesFrame.ButtonWork(Sender: TObject);
Var S : String;
    I : Integer;
    St : TStringList;
begin
  Case (Sender as TComponent).Tag of
    0 : If Mounting.Count<10 then begin
          S:=';Drive;'+NextFreeDriveLetter+';false;;';
          if not ShowProfileMountEditorDialog(self,S) then exit;
          Mounting.Add(S);
          LoadMountingList;
          MountingListView.ItemIndex:=MountingListView.Items.Count-1;
        end;
    1 : begin
          I:=MountingListView.ItemIndex;
          If I<0 then exit;
          S:=Mounting[I];
          if not ShowProfileMountEditorDialog(self,S) then exit;
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
          If Mounting.Count<10 then
            Mounting.Insert(0,MakeRelPath(PrgSetup.GameDir,PrgDataDir)+';Drive;C;false;');
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

  Mounting.Free;
end;

end.
