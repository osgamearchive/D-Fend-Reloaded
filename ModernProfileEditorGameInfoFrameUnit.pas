unit ModernProfileEditorGameInfoFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Grids, ValEdit, StdCtrls, ComCtrls, Buttons, ImgList, ToolWin,
  ExtCtrls, Menus, GameDBUnit, ModernProfileEditorFormUnit, LinkFileUnit;

type
  TModernProfileEditorGameInfoFrame = class(TFrame, IModernProfileEditorFrame)
    GameInfoValueListEditor: TValueListEditor;
    FavouriteCheckBox: TCheckBox;
    NotesLabel: TLabel;
    NotesMemo: TRichEdit;
    Tab: TStringGrid;
    UserDefinedDataLabel: TLabel;
    DelButton: TSpeedButton;
    AddButton: TSpeedButton;
    Panel1: TPanel;
    ToolBar: TToolBar;
    SearchGameButton: TToolButton;
    ImageList: TImageList;
    SearchPopupMenu: TPopupMenu;
    procedure FrameResize(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    Procedure SearchClick(Sender : TObject);
  private
    { Private-Deklarationen }
    LinkFile : TLinkFile;
    PProfileName : PString;
    Procedure LoadLinks;
  public
    { Public-Deklarationen }
    Procedure InitGUI(const InitData : TModernProfileEditorInitData);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Function CheckValue : Boolean;
    Procedure GetGame(const Game : TGame);
    Procedure ShowFrame;
  end;

implementation

uses LanguageSetupUnit, VistaToolsUnit, CommonTools, HelpConsts;

{$R *.dfm}

{ TModernProfileEditorGameInfoFrame }

procedure TModernProfileEditorGameInfoFrame.InitGUI(const InitData : TModernProfileEditorInitData);
Var St : TStringList;
begin
  NoFlicker(GameInfoValueListEditor);
  NoFlicker(FavouriteCheckBox);
  NoFlicker(Tab);
  {NoFlicker(NotesMemo); - will hide text in Memo}

  GameInfoValueListEditor.TitleCaptions.Clear;
  GameInfoValueListEditor.TitleCaptions.Add(LanguageSetup.Key);
  GameInfoValueListEditor.TitleCaptions.Add(LanguageSetup.Value);
  with GameInfoValueListEditor do begin
    Strings.Delete(0);
    Strings.Add(LanguageSetup.GameGenre+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=InitData.GameDB.GetGenreList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameDeveloper+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=InitData.GameDB.GetDeveloperList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GamePublisher+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=InitData.GameDB.GetPublisherList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameYear+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=InitData.GameDB.GetYearList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameLanguage+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=InitData.GameDB.GetLanguageList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameWWW+'=');
  end;
  FavouriteCheckBox.Caption:=LanguageSetup.GameFavorite;

  UserDefinedDataLabel.Caption:=LanguageSetup.ProfileEditorUserdefinedInfo+':';
  Tab.Cells[0,0]:=LanguageSetup.Key;
  Tab.Cells[1,0]:=LanguageSetup.Value;
  Tab.RowHeights[0]:=GameInfoValueListEditor.RowHeights[0];
  Tab.RowHeights[1]:=GameInfoValueListEditor.RowHeights[0];
  AddButton.Hint:=RemoveUnderline(LanguageSetup.Add);
  DelButton.Hint:=RemoveUnderline(LanguageSetup.Del);

  NotesLabel.Caption:=LanguageSetup.GameNotes+':';

  PProfileName:=InitData.CurrentProfileName;
  LinkFile:=InitData.SearchLinkFile;

  LoadLinks;

  HelpContext:=ID_ProfileEditProgramInformation;
end;

procedure TModernProfileEditorGameInfoFrame.LoadLinks;
begin
  LinkFile.AddLinksToMenu(SearchPopupMenu,0,1,SearchClick,1);
  SearchGameButton.Caption:=LanguageSetup.ProfileEditorLookUpGame+' '+LinkFile.Name[0];
  SearchGameButton.Hint:=LinkFile.Link[0];
end;

procedure TModernProfileEditorGameInfoFrame.SearchClick(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          LinkFile.MoveToTop((Sender as TMenuItem).Caption);
          LoadLinks;
        end;
    1 : If LinkFile.EditFile(False) then LoadLinks;
    2 : OpenLink(LinkFile.Link[0],'<GAMENAME>',PProfileName^);
  end;
end;

procedure TModernProfileEditorGameInfoFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var St : TStringList;
    I,J : Integer;
    S,T : String;
begin
  If Game=nil then begin
    GameInfoValueListEditor.Strings.ValueFromIndex[6]:=RemoveUnderline(LanguageSetup.No);
    exit;
  end;

  with GameInfoValueListEditor.Strings do begin
    If Game.Genre<>'' then ValueFromIndex[0]:=Game.Genre;
    If Game.Developer<>'' then ValueFromIndex[1]:=Game.Developer;
    If Game.Publisher<>'' then ValueFromIndex[2]:=Game.Publisher;
    If Game.Year<>'' then ValueFromIndex[3]:=Game.Year;
    If Game.Language<>'' then ValueFromIndex[4]:=Game.Language;
    If Game.WWW<>'' then ValueFromIndex[5]:=Game.WWW;
  end;
  FavouriteCheckBox.Checked:=Game.Favorite;

  St:=StringToStringList(Game.UserInfo);
  try
    If St.Count>0 then begin
      Tab.RowCount:=St.Count+1;
      For I:=0 to St.Count-1 do begin
        S:=St[I];
        J:=Pos('=',S);
        If J=0 then T:='' else begin T:=Trim(Copy(S,J+1,MaxInt)); S:=Trim(Copy(S,1,J-1)); end;
        Tab.Cells[0,I+1]:=S;
        Tab.Cells[1,I+1]:=T;
      end;
    end;
  finally
    St.Free;
  end;

  St:=StringToStringList(Game.Notes);
  try NotesMemo.Lines.Assign(St); finally St.Free; end;

  FrameResize(self);
end;

procedure TModernProfileEditorGameInfoFrame.ShowFrame;
begin
end;

function TModernProfileEditorGameInfoFrame.CheckValue: Boolean;
begin
  result:=True;
end;

procedure TModernProfileEditorGameInfoFrame.GetGame(const Game: TGame);
Var St : TStringList;
    I : Integer;
    S,T : String;
begin
  with GameInfoValueListEditor.Strings do begin
    Game.Genre:=ValueFromIndex[0];
    Game.Developer:=ValueFromIndex[1];
    Game.Publisher:=ValueFromIndex[2];
    Game.Year:=ValueFromIndex[3];
    Game.Language:=ValueFromIndex[4];
    Game.WWW:=ValueFromIndex[5];
  end;
  Game.Favorite:=FavouriteCheckBox.Checked;

  St:=TStringList.Create;
  try
    For I:=1 to Tab.RowCount-1 do begin
      S:=Trim(Tab.Cells[0,I]); T:=Trim(Tab.Cells[1,I]);
      If (S<>'') or (T<>'') then St.Add(S+'='+T);
    end;
    If St.Count=0 then Game.UserInfo:='' else Game.UserInfo:=StringListToString(St);
  finally
    St.Free;
  end;

  Game.Notes:=StringListToString(NotesMemo.Lines);
end;

procedure TModernProfileEditorGameInfoFrame.FrameResize(Sender: TObject);
begin
  Tab.ColWidths[0]:=GameInfoValueListEditor.ColWidths[0];
  Tab.ColWidths[1]:=Tab.ClientWidth-10-Tab.ColWidths[0];
end;

procedure TModernProfileEditorGameInfoFrame.AddButtonClick(Sender: TObject);
begin
  Tab.RowCount:=Tab.RowCount+1;
  Tab.Row:=Tab.RowCount-1;
  Tab.RowHeights[Tab.RowCount-1]:=GameInfoValueListEditor.RowHeights[0];
end;

procedure TModernProfileEditorGameInfoFrame.DelButtonClick(Sender: TObject);
Var I : Integer;
begin
  If Tab.RowCount=2 then begin
    Tab.Cells[0,1]:='';
    Tab.Cells[1,1]:='';
    exit;
  end;

  If Tab.Row<0 then begin
    MessageDlg(LanguageSetup.MessageNoRecordSelected,mtError,[mbOK],0);
    exit;
  end;

  For I:=Tab.Row+1 to Tab.RowCount-1 do begin
    Tab.Cells[0,I-1]:=Tab.Cells[0,I];
    Tab.Cells[1,I-1]:=Tab.Cells[1,I];
  end;
  Tab.RowCount:=Tab.RowCount-1;
end;

end.
