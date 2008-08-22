unit LinkFileUnit;
interface

uses Classes, Menus;

Type TLinkFile=class
  private
    FFileNameOnly : String;
    FData : TStringList;
    FChanged : Boolean;
    Procedure DataChanged(Sender : TObject);
    function GetCount: Integer;
    function GetLink(I: Integer): String;
    function GetName(I: Integer): String;
    Procedure LoadData;
    Procedure SaveData;
    function GetData: TStrings;
  public
    Constructor Create(const AFileNameOnly : String);
    Destructor Destroy; override;
    Procedure AddLinksToMenu(const Menu : TMenuItem; const Tag,EditTag : Integer; const OnClick : TNotifyEvent; const EditImage : Integer); overload;
    Procedure AddLinksToMenu(const Menu : TPopupMenu; const Tag,EditTag : Integer; const OnClick : TNotifyEvent; const EditImage : Integer); overload;
    Procedure MoveToTop(const AName : String);
    Function EditFile(const AllowLines : Boolean) : Boolean;
    Function IndexOf(const AName : String) : Integer;
    property Count : Integer read GetCount;
    property Name[I : Integer] : String read GetName;
    property Link[I : Integer] : String read GetLink;
    property Changed : Boolean read FChanged;
    property Data : TStrings read GetData;
end;

Procedure OpenLink(const Link, GameNamePlaceHolder, RealGameName : String);

implementation

uses Windows, SysUtils, Forms, ShellAPI, PrgSetupUnit, CommonTools,
     LanguageSetupUnit, LinkFileEditFormUnit;

{ TLinkFile }

constructor TLinkFile.Create(const AFileNameOnly: String);
begin
  inherited Create;
  FFileNameOnly:=AFileNameOnly;
  FData:=TStringList.Create;
  FData.OnChange:=DataChanged;
  LoadData;
  FChanged:=False;
end;

destructor TLinkFile.Destroy;
begin
  If FChanged then SaveData;
  FData.Free;
  inherited Destroy;
end;

procedure TLinkFile.LoadData;
Var S : String;
    FSt : TStringList;
    I : Integer;
begin
  If FileExists(PrgDataDir+FFileNameOnly) then S:=PrgDataDir+FFileNameOnly else begin
    If not FileExists(PrgDir+FFileNameOnly) then exit;
    S:=PrgDir+FFileNameOnly;
  end;

  FSt:=TStringList.Create;
  try
    try FSt.LoadFromFile(S); except exit; end;
    For I:=0 to FSt.Count-1 do begin
      S:=Trim(FSt[I]);
      If S='' then continue;
      If (S='-') or (S='---') then FData.Add('');
      If Pos(';',S)=0 then continue;
      FData.Add(S);
    end;
  finally
    FSt.Free;
  end;
end;

procedure TLinkFile.SaveData;
Var FSt : TStringList;
    I : Integer;
begin
  FSt:=TStringList.Create;
  try
    For I:=0 to FData.Count-1 do If Trim(FData[I])='' then FSt.Add('---') else FSt.Add(FData[I]);
    try FSt.SaveToFile(PrgDataDir+FFileNameOnly); except end;
  finally
    FSt.Free;
  end;
  FChanged:=False;
end;

procedure TLinkFile.DataChanged(Sender: TObject);
begin
  FChanged:=True;
end;

function TLinkFile.GetCount: Integer;
begin
  result:=FData.Count;
end;

function TLinkFile.GetData: TStrings;
begin
  result:=FData;
end;

function TLinkFile.GetName(I: Integer): String;
Var S : String;
begin
  result:='';
  If (I<0) or (I>=FData.Count) then exit;
  S:=Trim(FData[I]);
  If S='' then exit;
  result:=Trim(Copy(S,1,Pos(';',S)-1));
end;

function TLinkFile.GetLink(I: Integer): String;
Var S : String;
begin
  result:='';
  If (I<0) or (I>=FData.Count) then exit;
  S:=Trim(FData[I]);
  If S='' then exit;
  result:=Trim(Copy(S,Pos(';',S)+1,MaxInt));
end;

procedure TLinkFile.AddLinksToMenu(const Menu: TMenuItem; const Tag, EditTag: Integer; const OnClick: TNotifyEvent; const EditImage: Integer);
Var I : Integer;
    M : TMenuItem;
begin
  While Menu.Count>0 do Menu.Items[0].Free;

  For I:=0 to FData.Count-1 do begin
    M:=TMenuItem.Create(Menu.Owner);
    If Name[I]='' then begin
      M.Caption:='-';
    end else begin
      M.Caption:=Name[I];
      M.Hint:=Link[I];
      M.Tag:=Tag;
      M.OnClick:=OnClick;
    end;
    Menu.Add(M);
  end;

  M:=TMenuItem.Create(Menu.Owner);
  M.Caption:='-';
  Menu.Add(M);

  M:=TMenuItem.Create(Menu.Owner);
  M.Caption:=LanguageSetup.MenuProfileSearchGameEditLinks;
  M.Tag:=EditTag;
  M.OnClick:=OnClick;
  M.ImageIndex:=EditImage;
  Menu.Add(M);
end;

procedure TLinkFile.AddLinksToMenu(const Menu: TPopupMenu; const Tag, EditTag: Integer; const OnClick: TNotifyEvent; const EditImage: Integer);
Var I : Integer;
    M : TMenuItem;
begin
  While Menu.Items.Count>0 do Menu.Items[0].Free;

  For I:=0 to FData.Count-1 do begin
    M:=TMenuItem.Create(Menu.Owner);
    If Name[I]='' then begin
      M.Caption:='-';
    end else begin
      M.Caption:=Name[I];
      M.Hint:=Link[I];
      M.Tag:=Tag;
      M.OnClick:=OnClick;
    end;
    Menu.Items.Add(M);
  end;

  M:=TMenuItem.Create(Menu.Owner);
  M.Caption:='-';
  Menu.Items.Add(M);

  M:=TMenuItem.Create(Menu.Owner);
  M.Caption:=LanguageSetup.MenuProfileSearchGameEditLinks;
  M.Tag:=EditTag;
  M.OnClick:=OnClick;
  M.ImageIndex:=EditImage;
  Menu.Items.Add(M);
end;

function TLinkFile.IndexOf(const AName: String): Integer;
Var I : Integer;
    S : String;
begin
  S:=RemoveUnderline(AName);
  result:=-1;
  For I:=0 to FData.Count-1 do If Name[I]=S then begin result:=I; break; end;
end;

procedure TLinkFile.MoveToTop(const AName: String);
Var I : Integer;
begin
  I:=IndexOf(AName); If I>=0 then FData.Exchange(0,I);
end;

function TLinkFile.EditFile(const AllowLines : Boolean): Boolean;
begin
  result:=ShowLinkFileEditDialog(Application.MainForm,FData,AllowLines);
  If result then SaveData;
end;

{ global }

Procedure OpenLink(const Link, GameNamePlaceHolder, RealGameName : String);
Var S,T,U : String;
    I : Integer;
begin
  S:=ExtUpperCase(Link);
  T:=ExtUpperCase(GameNamePlaceHolder);
  I:=Pos(T,S);
  If I=0 then exit;

  S:=Copy(Link,1,I-1);
  T:=Copy(Link,I+length(GameNamePlaceHolder),MaxInt);

  For I:=1 to length(RealGameName) do begin
    If Pos(RealGameName[I],'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890')<>0
      then U:=U+RealGameName[I]
      else U:=U+'%'+IntToHex(Ord(RealGameName[I]),2);
  end;

  ShellExecute(Application.MainForm.Handle,'open',PChar(S+U+T),nil,nil,SW_SHOW);
end;

end.
