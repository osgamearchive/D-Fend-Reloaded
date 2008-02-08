unit IconLoaderUnit;
interface

uses Controls;

Type TImageListRec=record
  ImageList : TImageList;
  Name : String;
end;

Type TUserIconLoader=class
  private
    ImageListList : Array of TImageListRec;
  public
    Procedure RegisterImageList(const ImageList : TImageList; const Name : String);
    Procedure LoadIcons;
end;

Procedure LoadUserIcons(const ImageList : TImageList; const Name : String);

implementation

uses Classes, SysUtils, Graphics, INIFiles, CommonTools, PrgSetupUnit;

Procedure LoadIconToImageList(const ImageList : TImageList; const Nr : Integer; const FileName : String);
Var P : TPicture;
begin
  if not FileExists(FileName) then exit;
  P:=LoadImageFromFile(FileName);
  If P=nil then exit;
  try
    ImageList.Insert(Nr,P.Bitmap,nil);
    ImageList.Delete(Nr+1);
  finally
    P.Free;
  end;
end;

Procedure LoadUserIconsForList(const ImageList : TImageList; const IniSectionName : String; const Ini : TIniFile);
Var I,J : Integer;
    St : TStringList;
begin
  St:=TStringList.Create;
  try
    Ini.ReadSection(IniSectionName,St);
    For I:=0 to St.Count-1 do begin
      if not TryStrToInt(St[I],J) then continue;
      If (J<1) or (J>ImageList.Count) then continue;
      LoadIconToImageList(ImageList,J-1,MakeAbsPath(Ini.ReadString(IniSectionName,IntToStr(J),''),PrgSetup.BaseDir));
    end;
  finally
    St.Free;
  end;
end;

{ TUserIconLoader }

procedure TUserIconLoader.RegisterImageList(const ImageList: TImageList; const Name: String);
Var I : Integer;
begin
  I:=length(ImageListList);
  SetLength(ImageListList,I+1);
  ImageListList[I].ImageList:=ImageList;
  ImageListList[I].Name:=Name;
end;

procedure TUserIconLoader.LoadIcons;
Var Ini : TIniFile;
    I : Integer;
begin
  Ini:=TIniFile.Create(PrgDataDir+'Icons.ini');
  try
    For I:=0 to Length(ImageListList)-1 do LoadUserIconsForList(ImageListList[I].ImageList,ImageListList[I].Name,Ini);
  finally
    Ini.Free;
  end;
end;

{ global }

Procedure LoadUserIcons(const ImageList : TImageList; const Name : String);
Var UserIconLoader : TUserIconLoader;
begin
  UserIconLoader:=TUserIconLoader.Create;
  try
    UserIconLoader.RegisterImageList(ImageList,Name);
    UserIconLoader.LoadIcons;
  finally
    UserIconLoader.Free;
  end;
end;


end.
