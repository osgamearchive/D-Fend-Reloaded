unit LinkFileUnit;
interface

uses Classes, Menus;

Type TLinkFile=class
  private
    FFileNameOnly : String;
    FAllowLinesAndSubs : Boolean;
    FHelpID : Integer;
    FData : TStringList;
    FChanged : Boolean;
    Procedure DataChanged(Sender : TObject);
    function GetCount: Integer;
    function GetLink(I: Integer): String;
    function GetName(I: Integer): String;
    Procedure LoadData;
    Procedure SaveData;
    function GetData: TStrings;
    Procedure CreateAndAddUserMenuItems(const Owner : TComponent; const Tag : Integer; const OnClick : TNotifyEvent);
    Procedure CreateAndAddEditMenuItem(const Owner : TComponent; const EditTag : Integer; const OnClick : TNotifyEvent; const EditImage : Integer);
  public
    Constructor Create(const AFileNameOnly : String; const AAllowLinesAndSubs : Boolean; const AHelpID : Integer);
    Destructor Destroy; override;
    Procedure AddLinksToMenu(const Menu : TMenuItem; const Tag, EditTag : Integer; const OnClick : TNotifyEvent; const EditImage : Integer); overload;
    Procedure AddLinksToMenu(const Menu : TPopupMenu; const Tag, EditTag : Integer; const OnClick : TNotifyEvent; const EditImage : Integer); overload;
    Procedure MoveToTop(const AName : String);
    Function EditFile(const AllowLines : Boolean) : Boolean;
    Function IndexOf(const AName : String) : Integer;
    property Count : Integer read GetCount;
    property Name[I : Integer] : String read GetName;
    property Link[I : Integer] : String read GetLink;
    property Changed : Boolean read FChanged;
    property Data : TStrings read GetData;
    property AllowLinesAndSubs : Boolean read FAllowLinesAndSubs write FAllowLinesAndSubs;
    property HelpIP : Integer read FHelpID write FHelpID;
end;

Procedure OpenLink(const Link, GameNamePlaceHolder, RealGameName : String);

implementation

uses Windows, SysUtils, Forms, ShellAPI, Math, PrgSetupUnit, CommonTools,
     LanguageSetupUnit, LinkFileEditFormUnit, PrgConsts;

{ TLinkFile }

constructor TLinkFile.Create(const AFileNameOnly: String; const AAllowLinesAndSubs : Boolean; const AHelpID : Integer);
begin
  inherited Create;
  FFileNameOnly:=AFileNameOnly;
  FAllowLinesAndSubs:=AAllowLinesAndSubs;
  FHelpID:=AHelpID;
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
  S:='';
  If FileExists(PrgDataDir+SettingsFolder+'\'+FFileNameOnly) then S:=PrgDataDir+SettingsFolder+'\'+FFileNameOnly;
  If (S='') and FileExists(PrgDataDir+FFileNameOnly) then S:=PrgDataDir+FFileNameOnly;
  If (S='') and FileExists(PrgDir+FFileNameOnly) then S:=PrgDir+FFileNameOnly;
  If (S='') and FileExists(PrgDir+BinFolder+'\'+FFileNameOnly) then S:=PrgDir+BinFolder+'\'+FFileNameOnly;
  If S='' then exit;

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
    try FSt.SaveToFile(PrgDataDir+SettingsFolder+'\'+FFileNameOnly); except end;
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

Function GetLevel(const S : String) : Integer;
Var I : Integer;
begin
  result:=0;
  For I:=1 to length(S) do If S[I]='=' then inc(result) else exit;
end;

Procedure TLinkFile.CreateAndAddUserMenuItems(const Owner : TComponent; const Tag : Integer; const OnClick : TNotifyEvent);
Var I,L : Integer;
    Last,M : TMenuItem;
    Level : Array of TMenuItem;
begin
  SetLength(Level,0); Last:=nil;

  For I:=0 to FData.Count-1 do begin
    If ((Trim(Name[I])='') or (Trim(Name[I])='-')) and FAllowLinesAndSubs then begin
      If I=FData.Count-1 then continue;
      SetLength(Level,Min(GetLevel(Name[I+1]),length(Level)));
      M:=TMenuItem.Create(Owner.Owner);
      M.Caption:='-';
      If length(Level)=0 then begin
        If Owner is TMenuItem then (Owner as TMenuItem).Add(M) else (Owner as TPopupMenu).Items.Add(M);
      end else begin
        Level[length(Level)-1].OnClick:=nil;
        Level[length(Level)-1].Add(M);
      end;
      continue;
    end;

    If (Trim(Name[I])='') or (Trim(Name[I])='-') then continue;

    M:=TMenuItem.Create(Owner.Owner);

    If (Last<>nil) and FAllowLinesAndSubs then begin
      L:=Min(GetLevel(Name[I]),length(Level)+1);
      If L=length(Level)+1 then begin SetLength(Level,L); Level[L-1]:=Last; end else SetLength(Level,L);
    end;

    M.Caption:=Copy(Name[I],GetLevel(Name[I])+1,MaxInt);
    M.Hint:=Link[I];
    M.Tag:=Tag;
    M.OnClick:=OnClick;

    If length(Level)=0 then begin
      If Owner is TMenuItem then (Owner as TMenuItem).Add(M) else (Owner as TPopupMenu).Items.Add(M);
    end else begin
      Level[length(Level)-1].OnClick:=nil;
      Level[length(Level)-1].Add(M);
    end;

    Last:=M;
  end;
end;

Procedure TLinkFile.CreateAndAddEditMenuItem(const Owner : TComponent; const EditTag : Integer; const OnClick : TNotifyEvent; const EditImage : Integer);
Var M : TMenuItem;
begin
  M:=TMenuItem.Create(Owner.Owner);
  M.Caption:='-';
  If Owner is TMenuItem then (Owner as TMenuItem).Add(M) else (Owner as TPopupMenu).Items.Add(M);

  M:=TMenuItem.Create(Owner.Owner);
  M.Caption:=LanguageSetup.MenuProfileSearchGameEditLinks;
  M.Tag:=EditTag;
  M.OnClick:=OnClick;
  M.ImageIndex:=EditImage;
  If Owner is TMenuItem then (Owner as TMenuItem).Add(M) else (Owner as TPopupMenu).Items.Add(M);
end;

procedure TLinkFile.AddLinksToMenu(const Menu: TMenuItem; const Tag, EditTag: Integer; const OnClick: TNotifyEvent; const EditImage: Integer);
begin
  While Menu.Count>0 do Menu.Items[0].Free;
  CreateAndAddUserMenuItems(Menu,Tag,OnClick);
  CreateAndAddEditMenuItem(Menu,EditTag,OnClick,EditImage);
end;

procedure TLinkFile.AddLinksToMenu(const Menu: TPopupMenu; const Tag, EditTag: Integer; const OnClick: TNotifyEvent; const EditImage: Integer);
begin
  While Menu.Items.Count>0 do Menu.Items[0].Free;
  CreateAndAddUserMenuItems(Menu,Tag,OnClick);
  CreateAndAddEditMenuItem(Menu,EditTag,OnClick,EditImage);
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
  result:=ShowLinkFileEditDialog(Application.MainForm,FData,AllowLines,FHelpID);
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
