unit SetupFrameGamesListColumnsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Buttons, StdCtrls, CheckLst, SetupFormUnit;

type
  TSetupFrameGamesListColumns = class(TFrame, ISetupFrame)
    ListViewLabel: TLabel;
    ListViewListBox: TCheckListBox;
    ListViewUpButton: TSpeedButton;
    ListViewDownButton: TSpeedButton;
    procedure ListViewMoveButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Function GetName : String;
    Procedure InitGUIAndLoadSetup(InitData : TInitData);
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvencedMode : Boolean);
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, HelpConsts;

{$R *.dfm}

{ TSetupFrameGamesListColumns }

function TSetupFrameGamesListColumns.GetName: String;
begin
  result:=LanguageSetup.SetupFormListViewSheet1;
end;

Procedure GetColOrderAndVisible(var O,V : String);
begin
  V:=PrgSetup.ColVisible;
  while length(V)<7 do V:=V+'1';
  If Length(V)>7 then V:=Copy(V,1,7);
  PrgSetup.ColVisible:=V;

  O:=PrgSetup.ColOrder;
  while length(O)<7 do O:=O+'1';
  If Length(O)>7 then O:=Copy(O,1,7);
  PrgSetup.ColOrder:=O;
end;

procedure TSetupFrameGamesListColumns.InitGUIAndLoadSetup(InitData: TInitData);
Var ColOrder,ColVisible : String;
    I,J,Nr : Integer;
    B : Boolean;
begin
  NoFlicker(ListViewListBox);

  GetColOrderAndVisible(ColOrder,ColVisible);
  For I:=0 to 6 do begin
    try Nr:=StrToInt(ColOrder[I+1]); except Nr:=-1; end;
    If (Nr<1) or (Nr>7) then continue;
    Case Nr-1 of
      0 : ListViewListBox.Items.AddObject(LanguageSetup.GameSetup,Pointer(Nr-1));
      1 : ListViewListBox.Items.AddObject(LanguageSetup.GameGenre,Pointer(Nr-1));
      2 : ListViewListBox.Items.AddObject(LanguageSetup.GameDeveloper,Pointer(Nr-1));
      3 : ListViewListBox.Items.AddObject(LanguageSetup.GamePublisher,Pointer(Nr-1));
      4 : ListViewListBox.Items.AddObject(LanguageSetup.GameYear,Pointer(Nr-1));
      5 : ListViewListBox.Items.AddObject(LanguageSetup.GameLanguage,Pointer(Nr-1));
      6 : ListViewListBox.Items.AddObject(LanguageSetup.GameNotes,Pointer(Nr-1));
    end;
    ListViewListBox.Checked[ListViewListBox.Items.Count-1]:=(ColVisible[Nr]<>'0');
  end;
  For I:=0 to 6 do begin
    B:=False;
    For J:=0 to ListViewListBox.Items.Count-1 do If Integer(ListViewListBox.Items.Objects[J])=I then begin
      B:=True; break;
    end;
    If B then continue;
    Case I of
      0 : ListViewListBox.Items.AddObject(LanguageSetup.GameSetup,Pointer(I));
      1 : ListViewListBox.Items.AddObject(LanguageSetup.GameGenre,Pointer(I));
      2 : ListViewListBox.Items.AddObject(LanguageSetup.GameDeveloper,Pointer(I));
      3 : ListViewListBox.Items.AddObject(LanguageSetup.GamePublisher,Pointer(I));
      4 : ListViewListBox.Items.AddObject(LanguageSetup.GameYear,Pointer(I));
      5 : ListViewListBox.Items.AddObject(LanguageSetup.GameLanguage,Pointer(I));
      6 : ListViewListBox.Items.AddObject(LanguageSetup.GameNotes,Pointer(I));
    end;
    ListViewListBox.Checked[ListViewListBox.Items.Count-1]:=(ColVisible[I+1]<>'0');
  end;
end;

procedure TSetupFrameGamesListColumns.LoadLanguage;
begin
  ListViewLabel.Caption:=LanguageSetup.SetupFormListViewInfo;

  HelpContext:=ID_FileOptionsColumnsInTheGamesList;
end;

procedure TSetupFrameGamesListColumns.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameGamesListColumns.ShowFrame(const AdvencedMode: Boolean);
begin
end;

procedure TSetupFrameGamesListColumns.RestoreDefaults;
Var InitData : TInitData;
    S1,S2 : String;
begin
  S1:=PrgSetup.ColVisible;
  S2:=PrgSetup.ColOrder;
  try
    PrgSetup.ColVisible:='1111110';
    PrgSetup.ColOrder:='1234567';
    ListViewListBox.Items.Clear;
    InitGUIAndLoadSetup(InitData);
  finally
    PrgSetup.ColVisible:=S1;
    PrgSetup.ColOrder:=S2;
  end;
end;

procedure TSetupFrameGamesListColumns.SaveSetup;
Var S : String;
    I,J : Integer;
    B : Boolean;
begin
  S:='';
  For I:=0 to ListViewListBox.Items.Count-1 do S:=S+IntToStr(Integer(ListViewListBox.Items.Objects[I])+1);
  PrgSetup.ColOrder:=S;

  S:='';
  For I:=0 to 6 do begin
    B:=False;
    for J:=0 to ListViewListBox.Items.Count-1 do If Integer(ListViewListBox.Items.Objects[J])=I then begin
      B:=ListViewListBox.Checked[J]; break;
    end;
    If B then S:=S+'1' else S:=S+'0';
  end;
  PrgSetup.ColVisible:=S;
end;

procedure TSetupFrameGamesListColumns.ListViewMoveButtonClick(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : If ListViewListBox.ItemIndex>0 then begin
          ListViewListBox.Items.Exchange(ListViewListBox.ItemIndex,ListViewListBox.ItemIndex-1);
        end;
    1 : If (ListViewListBox.ItemIndex>=0) and (ListViewListBox.ItemIndex<ListViewListBox.Items.Count-2) then begin
          ListViewListBox.Items.Exchange(ListViewListBox.ItemIndex,ListViewListBox.ItemIndex+1);
        end;
  end;
end;

end.
