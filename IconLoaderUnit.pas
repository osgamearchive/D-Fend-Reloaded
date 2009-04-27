unit IconLoaderUnit;
interface

uses Classes, Controls, Graphics, Buttons, IniFiles;

const DI_SelectFolder=0;
      DI_SelectFile=1;
      DI_ExploreFolder=2;
      DI_ImageFloppy=3;
      DI_ImageHD=4;
      DI_ImageCD=5;
      DI_Add=6;
      DI_Delete=7;
      DI_Up=8;
      DI_Down=9;
      DI_Import=10;
      DI_Export=11;
      DI_ExtraPrgFiles=12;
      DI_Internet=13;
      DI_Edit=14;
      DI_Screenshot=15;
      DI_Clear=16;
      DI_Load=17;
      DI_Save=18;
      DI_Create=19;
      DI_Wizard=20;
      DI_Previous=21;
      DI_Next=22;
      DI_ViewFile=23;
      DI_Run=24;
      DI_Zoom=25;
      DI_ZipFile=26;
      DI_ResetDefault=27;
      DI_FindFile=28;
      DI_ScummVM=29;
      DI_Table=30;
      DI_Folders=31;
      DI_Calculator=32;
      DI_Update=33;
      DI_CopyToClipboard=34;
      DI_BackgroundImage=35;
      DI_Image=36;
      DI_Sound=37;
      DI_Video=38;
      DI_InternetPage=39;
      DI_Folder=40;
      DI_TextFile=41;
      DI_CloseWindow=42;
      DI_UseTemplate=43;
      DI_Help=44;

Type TImageListRec=record
  ImageList, OriginalImageList : TImageList;
  ImageLoaded : TList;
  Name : String;
  AddImages, NeedReinit : Boolean;
end;

Type TUserIconLoader=class
  private
    ImageListList : Array of TImageListRec;
    DialogImageList : TImageList;
    DialogImageLoaded : TList;
    FIconsLoaded : Boolean;
    FIconSet : String;
    FIconSetPath : String;
    Function CreateMask(const B : TBitmap) : TBitmap;
    Function LoadIconToImageList(const ImageList : TImageList; const Nr : Integer; const FileName : String) : Boolean;
    Procedure LoadUserIconsForList(const ImageList : TImageList; const IniSectionName : String; const AddImages : Boolean; const ImageLoaded : TList; const Ini : TIniFile; const RelBase : String);
    Procedure AddEmptyImages(const ImageList : TImageList; const ImageLoaded : TList; const MaxNr : Integer);
    procedure SetIconSet(const Value: String);
    Function GetDialogButtonBitmap(const Nr : Integer) : TBitmap;
    Function IsImageEmpty(const B : TBitmap) : Boolean;
    Function GetOriginalOfMainIconList : TImageList; {for use in GetExampleImage}
  public
    Constructor Create;
    Destructor Destroy; override;
    Procedure RegisterImageList(const ImageList : TImageList; const Name : String; const AddImages : Boolean = False);
    Procedure UnRegisterImageList(const ImageList : TImageList);
    Procedure DirectLoad(const ImageList : TImageList; const Name : String; const AddImages : Boolean = False; const ImageLoaded : TList = nil);
    Procedure LoadIcons;
    Procedure DialogImage(const Nr : Integer; const SpeedButton : TSpeedButton); overload;
    Procedure DialogImage(const Nr : Integer; const BitBtn : TBitBtn); overload;
    Procedure DialogImage(const Nr : Integer; const ImageList : TImageList; const NrInImageList : Integer); overload;
    property IconSet : String read FIconSet write SetIconSet;
    property IconSetPath : String read FIconSetPath;
    property IconsLoaded : Boolean read FIconsLoaded;
end;

var UserIconLoader : TUserIconLoader;

Procedure ListOfIconSets(const ShortName, LongName, Author : TStringList);
Function GetExampleImage(const ShortName : String) : TBitmap;

implementation

uses SysUtils, CommonTools, PrgSetupUnit, PrgConsts;

{ global }

Procedure ListOfIconSets(const ShortName, LongName, Author : TStringList);
Procedure AddRec(const Dir, Sub : String);
Var Ini : TIniFile;
begin
  Ini:=TIniFile.Create(Dir+IconSetsFolder+'\'+Sub+'\'+IconsConfFile);
  try
    ShortName.Add(Sub);
    LongName.Add(Ini.ReadString('Information','Name',Sub));
    Author.Add(Ini.ReadString('Information','Author',''));
  finally
    Ini.Free;
  end;
end;
Var Rec : TSearchRec;
    I,J : Integer;
    B : Boolean;
    S : String;
begin
  I:=FindFirst(PrgDataDir+IconSetsFolder+'\*.*',faDirectory,Rec);
  try
    While I=0 do begin
      If ((Rec.Attr and faDirectory)<>0) and (Rec.Name<>'.') and (Rec.Name<>'..') and FileExists(PrgDataDir+IconSetsFolder+'\'+Rec.Name+'\'+IconsConfFile) then AddRec(PrgDataDir,Rec.Name);
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;

  If PrgDir=PrgDataDir then exit;

  I:=FindFirst(PrgDir+IconSetsFolder+'\*.*',faDirectory,Rec);
  try
    While I=0 do begin
      If ((Rec.Attr and faDirectory)<>0) and (Rec.Name<>'.') and (Rec.Name<>'..') and FileExists(PrgDir+IconSetsFolder+'\'+Rec.Name+'\'+IconsConfFile) then begin
        B:=True; S:=ExtUpperCase(Rec.Name);
        For J:=0 to ShortName.Count-1 do If ExtUpperCase(ShortName[J])=S then begin B:=False; break; end;
        If B then AddRec(PrgDir,Rec.Name);
      end;
      I:=FindNext(Rec);
    end;
  finally
    FindClose(Rec);
  end;
end;

Function GetExampleImage(const ShortName : String) : TBitmap;
Var TempUserIconLoader : TUserIconLoader;
    ImageList : TImageList;
    B : TBitmap;
    I,X,Y : Integer;
    C : TColor;
begin
  TempUserIconLoader:=TUserIconLoader.Create;
  try
    ImageList:=TImageList.Create(nil);
    try
      ImageList.AddImages(UserIconLoader.GetOriginalOfMainIconList);
      TempUserIconLoader.IconSet:=ShortName;
      TempUserIconLoader.DirectLoad(ImageList,'Main');
      result:=TBitmap.Create;
      result.Height:=ImageList.Height;
      result.Width:=6*ImageList.Width;
      B:=TBitmap.Create;
      try
        For I:=0 to 5 do begin
          B.Height:=0;
          ImageList.GetBitmap(I,B);
          C:=B.Canvas.Pixels[0,B.Height-1];
          For X:=0 to B.Width-1 do For Y:=0 to B.Height-1 do if B.Canvas.Pixels[X,Y]=C then B.Canvas.Pixels[X,Y]:=clWhite;
          result.Canvas.Draw(B.Width*I,0,B);
        end;
      finally
        B.Free;
      end;
    finally
      ImageList.Free;
    end;
  finally
    TempUserIconLoader.Free;
  end;
end;

{ TUserIconLoader }

constructor TUserIconLoader.Create;
begin
  inherited Create;
  FIconsLoaded:=False;
  FIconSet:='';
  DialogImageList:=TImageList.Create(nil);
  RegisterImageList(DialogImageList,'Dialogs',True);
  DialogImageLoaded:=ImageListList[0].ImageLoaded;
end;

destructor TUserIconLoader.Destroy;
begin
  While length(ImageListList)>0 do UnRegisterImageList(ImageListList[length(ImageListList)-1].ImageList);
  DialogImageList.Free;
  inherited Destroy;
end;

procedure TUserIconLoader.RegisterImageList(const ImageList: TImageList; const Name: String; const AddImages : Boolean);
Var I : Integer;
begin
  I:=length(ImageListList);
  SetLength(ImageListList,I+1);
  ImageListList[I].ImageList:=ImageList;
  ImageListList[I].Name:=Name;
  ImageListList[I].AddImages:=AddImages;
  ImageListList[I].OriginalImageList:=TImageList.Create(nil);
  ImageListList[I].OriginalImageList.AddImages(ImageList);
  ImageListList[I].NeedReinit:=False;
  ImageListList[I].ImageLoaded:=TList.Create;

  If FIconsLoaded then begin
    DirectLoad(ImageListList[I].ImageList,ImageListList[I].Name,ImageListList[I].AddImages);
    ImageListList[I].NeedReinit:=True;
  end;
end;

procedure TUserIconLoader.SetIconSet(const Value: String);
begin
  If FIconSet=Value then exit;
  FIconSet:=Value;
  LoadIcons;
end;

procedure TUserIconLoader.UnRegisterImageList(const ImageList: TImageList);
Var I,J : Integer;
begin
  For I:=0 to length(ImageListList)-1 do If ImageListList[I].ImageList=ImageList then begin
    If ImageListList[I].OriginalImageList<>nil then ImageListList[I].OriginalImageList.Free;
    If ImageListList[I].ImageLoaded<>nil then ImageListList[I].ImageLoaded.Free;
    For J:=I to length(ImageListList)-2 do ImageListList[J]:=ImageListList[J+1];
    SetLength(ImageListList,length(ImageListList)-1);
    exit;
  end;
end;

procedure TUserIconLoader.DirectLoad(const ImageList: TImageList; const Name: String; const AddImages : Boolean; const ImageLoaded : TList);
Var Ini : TIniFile;
begin
  If FIconSetPath<>'' then begin
    Ini:=TIniFile.Create(FIconSetPath+IconsConfFile);
    try
      LoadUserIconsForList(ImageList,Name,AddImages,ImageLoaded,Ini,FIconSetPath);
    finally
      Ini.Free;
    end;
  end;

  Ini:=TIniFile.Create(PrgDataDir+SettingsFolder+'\'+IconsConfFile);
  try
    LoadUserIconsForList(ImageList,Name,AddImages,ImageLoaded,Ini,PrgDataDir+SettingsFolder+'\');
  finally
    Ini.Free;
  end;
end;

Procedure TUserIconLoader.AddEmptyImages(const ImageList : TImageList; const ImageLoaded : TList; const MaxNr : Integer);
Var B : TBitmap;
begin
  B:=TBitmap.Create;
  try
    B.Width:=ImageList.Width; B.Height:=ImageList.Height;
    While ImageList.Count<MaxNr+1 do ImageList.Add(B,B);
  finally
    B.Free;
  end;

  While ImageLoaded.Count<MaxNr+1 do ImageLoaded.Add(Pointer(0));
end;

Function TUserIconLoader.CreateMask(const B : TBitmap) : TBitmap;
Var C : TColor;
    X,Y : Integer;
begin
  result:=TBitmap.Create;
  result.SetSize(B.Width,B.Height);
  C:=B.Canvas.Pixels[0,B.Height-1];
  For X:=0 to B.Width-1 do For Y:=0 to B.Height-1 do If B.Canvas.Pixels[X,Y]=C then result.Canvas.Pixels[X,Y]:=$FFFFFF else result.Canvas.Pixels[X,Y]:=clGray;
end;

Function TUserIconLoader.LoadIconToImageList(const ImageList : TImageList; const Nr : Integer; const FileName : String) : Boolean;
Var P : TPicture;
    B,B2 : TBitmap;
begin
  result:=False;
  if not FileExists(FileName) then exit;
  P:=LoadImageFromFile(FileName);
  If P=nil then exit;
  try
    If Trim(ExtUpperCase(ExtractFileExt(FileName)))='.BMP' then begin
      try
        B2:=CreateMask(P.Bitmap);
        try
          ImageList.Insert(Nr,P.Bitmap,B2);
        finally
          B2.Free;
        end;
        ImageList.Delete(Nr+1);
      except end;
    end else begin
      B:=TBitmap.Create;
      try
        B.SetSize(P.Width,P.Height);
        B.Canvas.Draw(0,0,P.Graphic);
        try
          B2:=CreateMask(B);
          try
            ImageList.Replace(Nr,B,B2);
          finally
            B2.Free;
          end;
        except end;
      finally
        B.Free;
      end;
    end;
  finally
    P.Free;
  end;
  result:=True;
end;

Procedure TUserIconLoader.LoadUserIconsForList(const ImageList : TImageList; const IniSectionName : String; const AddImages : Boolean; const ImageLoaded : TList; const Ini : TIniFile; const RelBase : String);
Var I,J : Integer;
    St : TStringList;
begin
  St:=TStringList.Create;
  try
    Ini.ReadSection(IniSectionName,St);
    For I:=0 to St.Count-1 do begin
      if not TryStrToInt(St[I],J) then continue;
      If J<1 then continue;
      If J>ImageList.Count then begin
        If not AddImages then continue;
        AddEmptyImages(ImageList,ImageLoaded,J-1);
      end;
      LoadIconToImageList(ImageList,J-1,MakeExtAbsPath(Ini.ReadString(IniSectionName,IntToStr(J),''),RelBase));
      If AddImages then ImageLoaded[J-1]:=Pointer(1);
    end;
  finally
    St.Free;
  end;
end;

procedure TUserIconLoader.LoadIcons;
Procedure CheckDir(const Name : String);
begin
  If DirectoryExists(PrgDataDir+IconSetsFolder+'\'+Name) then begin FIconSetPath:=IncludeTrailingPathDelimiter(PrgDataDir+IconSetsFolder+'\'+Name); exit; end;
  If DirectoryExists(PrgDir+IconSetsFolder+'\'+Name) then begin FIconSetPath:=IncludeTrailingPathDelimiter(PrgDir+IconSetsFolder+'\'+Name); exit; end;
end;
Var Ini : TIniFile;
    I : Integer;
begin
  If FIconSet='' then FIconSet:='Modern';

  FIconSetPath:='';
  CheckDir(FIconSet);
  If FIconSetPath='' then CheckDir('Modern');
  If FIconSetPath='' then CheckDir('Classic');

  For I:=0 to Length(ImageListList)-1 do If ImageListList[I].NeedReinit then begin
    ImageListList[I].ImageList.Clear;
    If not ImageListList[I].AddImages then ImageListList[I].ImageList.AddImages(ImageListList[I].OriginalImageList);
  end;

  If FIconSetPath<>'' then begin
    Ini:=TIniFile.Create(FIconSetPath+IconsConfFile);
    try
      For I:=0 to Length(ImageListList)-1 do begin
        LoadUserIconsForList(ImageListList[I].ImageList,ImageListList[I].Name,ImageListList[I].AddImages,ImageListList[I].ImageLoaded,Ini,FIconSetPath);
      end;
    finally
      Ini.Free;
    end;
  end;

  Ini:=TIniFile.Create(PrgDataDir+SettingsFolder+'\'+IconsConfFile);
  try
    For I:=0 to Length(ImageListList)-1 do begin
      LoadUserIconsForList(ImageListList[I].ImageList,ImageListList[I].Name,ImageListList[I].AddImages,ImageListList[I].ImageLoaded,Ini,PrgDataDir+SettingsFolder+'\');
    end;
  finally
    Ini.Free;
  end;

  For I:=0 to Length(ImageListList)-1 do  ImageListList[I].NeedReinit:=True;

  FIconsLoaded:=True;
end;

Function TUserIconLoader.GetDialogButtonBitmap(const Nr : Integer) : TBitmap;
Var B1,B2 : TBitmap;
begin
  result:=nil;
  If (Nr<0) or (Nr>=DialogImageList.Count) then exit;
  If (Nr>=DialogImageLoaded.Count) or (Integer(DialogImageLoaded[Nr])=0) then exit;

  B1:=TBitmap.Create;
  try
    B1.Width:=DialogImageList.Width; B1.Height:=DialogImageList.Height;
    DialogImageList.GetBitmap(Nr,B1);
    B2:=CreateMask(B1);
    try
      result:=TBitmap.Create;
      result.Width:=2*B1.Width; result.Height:=B1.Height;
      result.PixelFormat:=pf8bit;
      result.Canvas.Draw(0,0,B1);
      result.Canvas.Draw(16,0,B2);
    finally
      B2.Free;
    end;
  finally
    B1.Free;
  end;
end;

Type TByteArray=Array[0..MaxInt-1] of Byte;

function TUserIconLoader.IsImageEmpty(const B: TBitmap) : Boolean;
Var I,J : Integer;
begin
  result:=False;
  For I:=0 to B.Height-1 do begin
    For J:=0 to (B.Width div 2)-1 do If TByteArray(B.ScanLine[I]^)[J]<>0 then exit;
    For J:=B.Width div 2 to B.Width-1 do If TByteArray(B.ScanLine[I]^)[J]<>255 then exit;
  end;
  result:=True;
end;

procedure TUserIconLoader.DialogImage(const Nr: Integer; const SpeedButton: TSpeedButton);
Var B : TBitmap;
begin
  B:=GetDialogButtonBitmap(Nr);
  If B=nil then exit;
  try
    If not IsImageEmpty(B) then SpeedButton.Glyph:=B;
  finally
    B.Free;
  end;
end;

Procedure TUserIconLoader.DialogImage(const Nr : Integer; const BitBtn : TBitBtn);
Var B : TBitmap;
begin
  B:=GetDialogButtonBitmap(Nr);
  If B=nil then exit;
  try
    If not IsImageEmpty(B) then BitBtn.Glyph:=B;
  finally
    B.Free;
  end;
end;

Procedure TUserIconLoader.DialogImage(const Nr : Integer; const ImageList : TImageList; const NrInImageList : Integer);
Var B : TBitmap;
begin
  If (Nr<0) or (Nr>=DialogImageList.Count) then exit;
  ImageList.AddImage(DialogImageList,Nr);
  B:=GetDialogButtonBitmap(Nr);
  If B=nil then exit;
  try If IsImageEmpty(B) then exit; finally B.Free; end;
  ImageList.Move(ImageList.Count-1,NrInImageList);
  ImageList.Delete(NrInImageList+1);
end;

function TUserIconLoader.GetOriginalOfMainIconList: TImageList;
Var I : Integer;
begin
  result:=nil;
  For I:=0 to length(ImageListList)-1 do If ExtUpperCase(ImageListList[I].Name)='MAIN' then begin
    result:=ImageListList[I].OriginalImageList;
    break;
  end;
end;

initialization
  UserIconLoader:=TUserIconLoader.Create;
finalization
  UserIconLoader.Free;
end.
