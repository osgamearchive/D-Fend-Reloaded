unit PackageBuilderUnit;
interface

uses Classes, GameDBUnit;

Function AddPackageDataZip(const St : TStringList; const Game : TGame; const DataFileName : String) : Boolean;
Function AddPackageDataAutoSetup(const St : TStringList; const DataFileName : String) : Boolean;
Function AddPackageDataIcon(const St : TStringList; const DataFileName : String) : Boolean;
Function AddPackageDataIconSet(const St : TStringList; const IconSetIniFile : String; const DataFileName : String) : Boolean;
Function AddPackageDataLanguage(const St : TStringList; const DataFileName : String) : Boolean;
Function AddPackageDataExe(const St : TStringList; const DataFileName : String) : Boolean;
Function AddPackageDataHeader : TStringList;
Procedure AddPackageDataFooter(const St : TStringList);

implementation

uses SysUtils, Dialogs, IniFiles, CommonTools, HashCalc, PackageDBToolsUnit,
     LanguageSetupUnit;

Function GetFileSize(const FileName : String) : String;
Var Rec : TSearchRec;
    I : Integer;
begin
  result:='';
  I:=FindFirst(FileName,faAnyFile,Rec);
  try
    If I=0 then result:=IntToStr(Rec.Size);
  finally
    FindClose(Rec);
  end;
end;

Function FileOK(const DataFileName : String) : Boolean;
begin
  result:=FileExists(DataFileName);
  If not result then MessageDlg(Format(LanguageSetup.MessageFileNotFound,[DataFileName]),mtError,[mbOK],0);
end;

Function AddPackageDataZip(const St : TStringList; const Game : TGame; const DataFileName : String) : Boolean;
Var S : String;
    I : Integer;
    St2 : TStringList;
begin
  result:=FileOK(DataFileName); if not result then exit;

  St.Add('  <Game');
  If Game=nil then S:='' else S:=Game.CacheName;
  St.Add('    Name="'+S+'"');
  If Game=nil then S:='' else S:=Game.CacheGenre;
  St.Add('    Genre="'+S+'"');
  If Game=nil then S:='' else S:=Game.CacheDeveloper;
  St.Add('    Developer="'+S+'"');
  If Game=nil then S:='' else S:=Game.CachePublisher;
  St.Add('    Publisher="'+S+'"');
  If Game=nil then S:='' else S:=Game.CacheYear;
  St.Add('    Year="'+S+'"');
  If Game=nil then S:='English' else S:=Game.CacheLanguage;
  St.Add('    Language="'+S+'"');
  If Game=nil then S:='' else begin
    S:='';
    St2:=StringToStringList(Game.UserInfo);
    try
      For I:=0 to St2.Count-1 do If ExtUpperCase(Copy(Trim(St2[I]),1,8))='LICENSE=' then begin S:=Copy(Trim(St2[I]),9,MaxInt); break; end;
    finally
      St2.Free;
    end;
  end;
  St.Add('    License="'+S+'"');
  St.Add('    PackageChecksum="'+GetMD5Sum(DataFileName)+'"');
  St.Add('    GameExeChecksum=""');
  St.Add('    Size="'+GetFileSize(DataFileName)+'">'+URLFileNameFromFileName(ExtractFileName(DataFileName))+'</Game>');
end;

Function AddPackageDataAutoSetup(const St : TStringList; const DataFileName : String) : Boolean;
Var Ini : TIniFile;
begin
  result:=FileOK(DataFileName); if not result then exit;

  Ini:=TIniFile.Create(DataFileName);
  try
    St.Add('  <AutoSetup');
    St.Add('    Name="'+Ini.ReadString('ExtraInfo','Name','')+'"');
    St.Add('    Genre="'+Ini.ReadString('ExtraInfo','Genre','')+'"');
    St.Add('    Developer="'+Ini.ReadString('ExtraInfo','Developer','')+'"');
    St.Add('    Publisher="'+Ini.ReadString('ExtraInfo','Publisher','')+'"');
    St.Add('    Year="'+Ini.ReadString('ExtraInfo','Year','')+'"');
    St.Add('    Language="'+Ini.ReadString('ExtraInfo','Language','')+'"');
    St.Add('    PackageChecksum="'+GetMD5Sum(DataFileName)+'"');
    St.Add('    GameExeChecksum="'+Ini.ReadString('Extra','ExeMD5','')+'"');
    St.Add('    Size="'+GetFileSize(DataFileName)+'">'+URLFileNameFromFileName(ExtractFileName(DataFileName))+'</AutoSetup>');
  finally
    Ini.Free;
  end;
end;

Function AddPackageDataIcon(const St : TStringList; const DataFileName : String) : Boolean;
begin
  result:=FileOK(DataFileName); if not result then exit;

  St.Add('  <Icon');
  St.Add('    Name="'+ChangeFileExt(ExtractFileName(DataFileName),'')+'"');
  St.Add('    FileChecksum="'+GetMD5Sum(DataFileName)+'"');
  St.Add('    Size="'+GetFileSize(DataFileName)+'">'+URLFileNameFromFileName(ExtractFileName(DataFileName))+'</Icon>');
end;

Function AddPackageDataIconSet(const St : TStringList; const IconSetIniFile : String; const DataFileName : String) : Boolean;
Var Ini : TIniFile;
    I : Integer;
    S : String;
begin
  result:=FileOK(DataFileName); if not result then exit;

  Ini:=TIniFile.Create(IconSetIniFile);
  try
    St.Add('  <IconSet');
    St.Add('    Name="'+Ini.ReadString('Information','Name',ChangeFileExt(ExtractFileName(DataFileName),''))+'"');
    St.Add('    FileChecksum="'+GetMD5Sum(DataFileName)+'"');
    I:=VersionToInt(GetNormalFileVersionAsString); S:=IntToStr(I div 10000)+'.'+IntToStr((I div 100) mod 100)+'.';
    St.Add('    MinVersion="'+S+'0"');
    St.Add('    MaxVersion="'+S+'99"');
    St.Add('    Author="'+Ini.ReadString('Information','Author','')+'"');
    St.Add('    Size="'+GetFileSize(DataFileName)+'">'+URLFileNameFromFileName(ExtractFileName(DataFileName))+'</Icon>');
  finally
    Ini.Free;
  end;
end;

Function AddPackageDataLanguage(const St : TStringList; const DataFileName : String) : Boolean;
Var Ini : TIniFile;
    I : Integer;
    S : String;
begin
  result:=FileOK(DataFileName); if not result then exit;

  Ini:=TIniFile.Create(DataFileName);
  try
    St.Add('  <Language');
    St.Add('    Name="'+ChangeFileExt(ExtractFileName(DataFileName),'')+'"');
    I:=VersionToInt(Ini.ReadString('LanguageFileInfo','MaxVersion','')); S:=IntToStr(I div 10000)+'.'+IntToStr((I div 100) mod 100)+'.';
    St.Add('    MinVersion="'+S+'0"');
    St.Add('    MaxVersion="'+S+'99"');
    St.Add('    Author="'+Ini.ReadString('Author','Name','')+'"');
    St.Add('    PackageChecksum="'+GetMD5Sum(DataFileName)+'"');
    St.Add('    Size="'+GetFileSize(DataFileName)+'">'+URLFileNameFromFileName(ExtractFileName(DataFileName))+'</Language>');
  finally
    Ini.Free;
  end;
end;

Function AddPackageDataExe(const St : TStringList; const DataFileName : String) : Boolean;
begin
  result:=FileOK(DataFileName); if not result then exit;

  St.Add('  <ExePackage');
  St.Add('    Name="'+ChangeFileExt(ExtractFileName(DataFileName),'')+'"');
  St.Add('    Description=""');
  St.Add('    PackageChecksum="'+GetMD5Sum(DataFileName)+'"');
  St.Add('    Size="'+GetFileSize(DataFileName)+'">'+URLFileNameFromFileName(ExtractFileName(DataFileName))+'</ExePackage>');
end;

Function AddPackageDataHeader : TStringList;
begin
  result:=TStringList.Create;

  result.Add('<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>');
  result.Add('<!DOCTYPE DFRPackagesFile SYSTEM "http:/'+'/dfendreloaded.sourceforge.net/Packages/DFRPackagesFile.dtd">');
  result.Add('');
  result.Add('<DFRPackagesFile Name="" LastUpdateDate="'+EncodeUpdateDate(Date)+'">');
end;

Procedure AddPackageDataFooter(const St : TStringList);
begin
  St.Add('</DFRPackagesFile>');
end;

end.
