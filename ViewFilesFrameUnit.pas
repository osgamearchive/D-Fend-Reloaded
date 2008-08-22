unit ViewFilesFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, GameDBUnit, StdCtrls, Buttons, ComCtrls, ImgList, ExtCtrls, ToolWin;

type
  TViewFilesFrame = class(TFrame)
    ToolBar: TToolBar;
    Tree: TTreeView;
    List: TListView;
    Splitter: TSplitter;
    ImageList: TImageList;
    UpdateButton: TToolButton;
    InfoLabel: TLabel;
    SetupDataDirButton: TBitBtn;
    OpenButton: TToolButton;
    OpenFileButton: TToolButton;
    procedure SetupDataDirButtonClick(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure ListInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: string);
    procedure ListDblClick(Sender: TObject);
    procedure ListChange(Sender: TObject; Item: TListItem; Change: TItemChange);
  private
    { Private-Deklarationen }
    Game : TGame;
    Function GetNewDataFolderName : String;
    Procedure ReadTree(const ParentNode : TTreeNode; const Dir : String);
    Function GetCurrentPath(const  TreeNode : TTreeNode = nil) : String;
    Function FileInDir(const Dir : String) : Boolean; 
  public
    { Public-Deklarationen }
    Procedure Init;
    Procedure LoadLanguage;
    Procedure SetGame(const AGame : TGame);
  end;

implementation

uses ShellAPI, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit;

{$R *.dfm}

{ TViewFilesFrame }

procedure TViewFilesFrame.Init;
begin
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  InfoLabel.Top:=16;
  InfoLabel.WordWrap:=True;
  SetupDataDirButton.Top:=16+InfoLabel.Height+8;

  NoFlicker(SetupDataDirButton);
end;

procedure TViewFilesFrame.LoadLanguage;
begin
  SetupDataDirButton.Caption:=LanguageSetup.ViewDataFilesSetup;
  UpdateButton.Caption:=LanguageSetup.ViewDataFilesUpdate;
  UpdateButton.Hint:=LanguageSetup.ViewDataFilesUpdateHint;
  OpenButton.Caption:=LanguageSetup.ViewDataFilesOpen;
  OpenButton.Hint:=LanguageSetup.ViewDataFilesOpenHint;
  OpenFileButton.Caption:=LanguageSetup.ViewDataFilesOpenFile;
  OpenFileButton.Hint:=LanguageSetup.ViewDataFilesOpenFileHint;
end;

function TViewFilesFrame.GetNewDataFolderName: String;
Var S : String;
begin
  result:='';
  If Game=nil then exit;

  If PrgSetup.DataDir='' then S:=PrgSetup.BaseDir else S:=PrgSetup.DataDir;
  S:=IncludeTrailingPathDelimiter(S)+MakeFileSysOKFolderName(Game.Name)+'\';
  result:=MakeRelPath(S,PrgSetup.BaseDir);
end;

procedure TViewFilesFrame.SetGame(const AGame: TGame);
Var B : Boolean;
    N : TTreeNode;
    I : Integer;
begin
  Game:=AGame;
  If Game=nil then exit;

  B:=(Trim(Game.DataDir)<>'');

  if not B then InfoLabel.Caption:=Format(LanguageSetup.ViewDataFilesSetupInfo,[ExcludeTrailingPathDelimiter(MakeAbsPath(GetNewDataFolderName,PrgSetup.BaseDir))]);
  ToolBar.Visible:=B;
  Tree.Visible:=B;
  Splitter.Visible:=B;
  List.Visible:=B;
  InfoLabel.Visible:=not B;
  SetupDataDirButton.Visible:=not B;

  If Splitter.Visible then Splitter.Left:=Tree.Width+Tree.Left;

  Tree.Items.BeginUpdate;
  try
    Tree.Items.Clear;
    If not B then exit;
    N:=Tree.Items.AddChild(nil,LanguageSetup.ViewDataFilesRoot);
    N.ImageIndex:=0;
    N.SelectedIndex:=1;
    ReadTree(N,IncludeTrailingPathDelimiter(MakeAbsPath(Game.DataDir,PrgSetup.BaseDir)));
    Tree.FullExpand;

    Tree.Selected:=N;
    For I:=0 to Tree.Items.Count-1 do If FileInDir(GetCurrentPath(Tree.Items[I])) then begin
      Tree.Selected:=Tree.Items[I]; break;
    end;
    TreeChange(self,Tree.Selected);
  finally
    Tree.Items.EndUpdate;
  end;
end;

procedure TViewFilesFrame.ReadTree(const ParentNode: TTreeNode; const Dir: String);
Var Rec : TSearchRec;
    I : Integer;
    N : TTreeNode;
begin
  I:=FindFirst(Dir+'*.*',faDirectory,Rec);
  try
    While I=0 do begin
      If ((Rec.Attr and faDirectory)=faDirectory) and (Rec.Name<>'.') and (Rec.Name<>'..') then begin
        N:=Tree.Items.AddChild(ParentNode,Rec.Name);
        N.ImageIndex:=0;
        N.SelectedIndex:=1;
        ReadTree(N,IncludeTrailingPathDelimiter(Dir+Rec.Name));
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

procedure TViewFilesFrame.SetupDataDirButtonClick(Sender: TObject);
begin
  Game.DataDir:=GetNewDataFolderName;
  ForceDirectories(MakeAbsPath(Game.DataDir,PrgSetup.BaseDir));
  SetGame(Game);
end;

function TViewFilesFrame.FileInDir(const Dir: String): Boolean;
Var Rec : TSearchRec;
    I : Integer;
begin
  result:=False;
  I:=FindFirst(Dir+'*.*',faAnyFile,Rec);
  try
    While I=0 do begin
      If (Rec.Attr and faDirectory)=0 then begin result:=True; exit; end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

function TViewFilesFrame.GetCurrentPath(const  TreeNode : TTreeNode): String;
Var N : TTreeNode;
begin
  result:='';
  If TreeNode=nil then begin
    If Tree.Selected=nil then exit;
    N:=Tree.Selected;
  end else begin
    N:=TreeNode;
  end;
  while N.Parent<>nil do begin
    If result<>'' then result:='\'+result;
    result:=N.Text+result;
    N:=N.Parent;
  end;
  result:=IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(MakeAbsPath(Game.DataDir,PrgSetup.BaseDir))+result);
end;

procedure TViewFilesFrame.TreeChange(Sender: TObject; Node: TTreeNode);
Var Path : String;
    I : TListItem;
    J : Integer;
    Rec : TSearchRec;
    S : String;
begin
  List.Items.BeginUpdate;
  try
    List.Items.Clear;
    If Tree.Selected=nil then exit;
    Path:=GetCurrentPath;

    J:=FindFirst(Path+'*.*',faAnyFile,Rec);
    try
      While J=0 do begin
        If (Rec.Attr and faDirectory) =0 then begin
          I:=List.Items.Add;
          I.Caption:=Rec.Name;
          I.ImageIndex:=4;
          S:=ExtUpperCase(ExtractFileExt(Rec.Name));
          If (S='.JPG') or (S='.JPEG') or (S='.BMP') or (S='.PNG') or (S='.GIF') or (S='.TIF') or (S='.TIFF') then I.ImageIndex:=5;
          If (S='.WAV') or (S='.MP3') or (S='.OGG') then I.ImageIndex:=6;
          If (S='.AVI') or (S='.MPG') or (S='.MPEG') or (S='.WMV') or (S='.ASF') then I.ImageIndex:=7;
        end;
        J:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;
  finally
    List.Items.EndUpdate;
  end;
end;

procedure TViewFilesFrame.ListInfoTip(Sender: TObject; Item: TListItem; var InfoTip: string);
begin
  InfoTip:=GetCurrentPath+Item.Caption;
end;

procedure TViewFilesFrame.ListChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  OpenFileButton.Enabled:=(List.Selected<>nil);
  If OpenFileButton.Enabled
    then OpenFileButton.ImageIndex:=List.Selected.ImageIndex
    else OpenFileButton.ImageIndex:=4;
end;

procedure TViewFilesFrame.ListDblClick(Sender: TObject);
Var S : String;
begin
  If List.Selected=nil then exit;
  S:=GetCurrentPath;
  ShellExecute(Handle,'open',PChar(GetCurrentPath+List.Selected.Caption),nil,PChar(S),SW_SHOW);
end;

procedure TViewFilesFrame.ButtonWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : SetGame(Game);
    1 : begin
          S:=MakeAbsPath(Game.DataDir,PrgSetup.BaseDir);
          ShellExecute(Handle,'open',PChar(S),nil,PChar(S),SW_SHOW);
        end;
    2 : If List.Selected<>nil then begin
          S:=GetCurrentPath;
          ShellExecute(Handle,'open',PChar(GetCurrentPath+List.Selected.Caption),nil,PChar(S),SW_SHOW);
        end;
  end;
end;

end.
