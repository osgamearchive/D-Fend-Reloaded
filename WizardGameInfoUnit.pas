unit WizardGameInfoUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, Grids, ValEdit, ImgList,
  Menus, ToolWin, GameDBUnit, LinkFileUnit;

type
  TWizardGameInfoFrame = class(TFrame)
    InfoLabel: TLabel;
    Bevel: TBevel;
    GameInfoValueListEditor: TValueListEditor;
    FavouriteCheckBox: TCheckBox;
    UserDefinedDataLabel: TLabel;
    Tab: TStringGrid;
    NotesLabel: TLabel;
    NotesMemo: TRichEdit;
    AddButton: TSpeedButton;
    DelButton: TSpeedButton;
    Panel1: TPanel;
    ToolBar: TToolBar;
    SearchGameButton: TToolButton;
    SearchPopupMenu: TPopupMenu;
    ImageList: TImageList;
    procedure AddButtonClick(Sender: TObject);
    procedure DelButtonClick(Sender: TObject);
    procedure SearchClick(Sender: TObject);
  private
    { Private-Deklarationen }
    LinkFile : TLinkFile;
    GameName : String;
    Procedure LoadLinks;
  public
    { Public-Deklarationen }
    Procedure Init(const GameDB : TGameDB; const ALinkFile : TLinkFile);
    Procedure SetGameName(const AName : String);
    Procedure WriteDataToGame(const Game : TGame);
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools;

{$R *.dfm}

{ TWizardGameInfoFrame }

procedure TWizardGameInfoFrame.Init(const GameDB: TGameDB; const ALinkFile : TLinkFile);
Var St : TStringList;
begin
  SetVistaFonts(self);

  InfoLabel.Font.Style:=[fsBold];

  InfoLabel.Caption:=LanguageSetup.WizardFormPage4Info;
  GameInfoValueListEditor.TitleCaptions.Clear;
  GameInfoValueListEditor.TitleCaptions.Add(LanguageSetup.Key);
  GameInfoValueListEditor.TitleCaptions.Add(LanguageSetup.Value);
  with GameInfoValueListEditor do begin
    Strings.Delete(0);
    Strings.Add(LanguageSetup.GameGenre+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=GameDB.GetGenreList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameDeveloper+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=GameDB.GetDeveloperList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GamePublisher+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=GameDB.GetPublisherList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameYear+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=GameDB.GetYearList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
    Strings.Add(LanguageSetup.GameLanguage+'=');
    ItemProps[Strings.Count-1].EditStyle:=esPickList;
    St:=GameDB.GetLanguageList; try ItemProps[Strings.Count-1].PickList.Assign(St); finally St.Free; end;
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

  Tab.ColWidths[0]:=GameInfoValueListEditor.ColWidths[0];
  Tab.ColWidths[1]:=Tab.ClientWidth-10-Tab.ColWidths[0];

  LinkFile:=ALinkFile;
  LoadLinks;
end;

procedure TWizardGameInfoFrame.LoadLinks;
begin
  LinkFile.AddLinksToMenu(SearchPopupMenu,0,1,SearchClick,1);
  SearchGameButton.Caption:=LanguageSetup.ProfileEditorLookUpGame+' '+LinkFile.Name[0];
  SearchGameButton.Hint:=LinkFile.Link[0];
end;

procedure TWizardGameInfoFrame.SearchClick(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          LinkFile.MoveToTop((Sender as TMenuItem).Caption);
          LoadLinks;
        end;
    1 : If LinkFile.EditFile(False) then LoadLinks;
    2 : OpenLink(LinkFile.Link[0],'<GAMENAME>',GameName);
  end;
end;

procedure TWizardGameInfoFrame.SetGameName(const AName: String);
begin
  GameName:=AName;
end;

procedure TWizardGameInfoFrame.AddButtonClick(Sender: TObject);
begin
  Tab.RowCount:=Tab.RowCount+1;
  Tab.Row:=Tab.RowCount-1;
  Tab.RowHeights[Tab.RowCount-1]:=GameInfoValueListEditor.RowHeights[0];
end;

procedure TWizardGameInfoFrame.DelButtonClick(Sender: TObject);
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

procedure TWizardGameInfoFrame.WriteDataToGame(const Game: TGame);
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

end.
