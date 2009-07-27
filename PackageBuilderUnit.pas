unit PackageBuilderUnit;
interface

uses Classes;

Function GetPackageDataForFile(const DataFileName : String) : TStringList;

implementation

uses SysUtils, Dialogs, IniFiles, CommonTools, PackageDBLanguage, HashCalc,
     PackageDBToolsUnit, LanguageSetupUnit;

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

Function AddPackageDataZip(const St : TStringList; const DataFileName : String) : Boolean;
Var PackageSize, PackageChecksum, DataFileNameInXML : String;
begin
  result:=False;
  If not FileExists(DataFileName) then begin
    MessageDlg(Format(LanguageSetup.MessageFileNotFound,[DataFileName]),mtError,[mbOK],0);
    exit;
  end;
  PackageSize:=GetFileSize(DataFileName);
  PackageChecksum:=GetMD5Sum(DataFileName);
  DataFileNameInXML:=URLFileNameFromFileName(ExtractFileName(DataFileName));
  result:=True;

  St.Add('  <Game');
  St.Add('    Name=""');
  St.Add('    Genre=""');
  St.Add('    Developer=""');
  St.Add('    Publisher=""');
  St.Add('    Year=""');
  St.Add('    Language="English"');
  St.Add('    License=""');
  St.Add('    PackageChecksum="'+PackageChecksum+'"');
  St.Add('    GameExeChecksum=""');
  St.Add('    Size="'+PackageSize+'">'+DataFileNameInXML+'</Game>');
end;

Function AddPackageDataAutoSetup(const St : TStringList; const DataFileName : String) : Boolean;
Var PackageSize, PackageChecksum, DataFileNameInXML : String;
    Ini : TIniFile;
begin
  result:=False;
  If not FileExists(DataFileName) then begin
    MessageDlg(Format(LanguageSetup.MessageFileNotFound,[DataFileName]),mtError,[mbOK],0);
    exit;
  end;
  PackageSize:=GetFileSize(DataFileName);
  PackageChecksum:=GetMD5Sum(DataFileName);
  DataFileNameInXML:=URLFileNameFromFileName(ExtractFileName(DataFileName));
  result:=True;

  Ini:=TIniFile.Create(DataFileName);
  try
    St.Add('  <AutoSetup');
    St.Add('    Name="'+Ini.ReadString('ExtraInfo','Name','')+'"');
    St.Add('    Genre="'+Ini.ReadString('ExtraInfo','Genre','')+'"');
    St.Add('    Developer="'+Ini.ReadString('ExtraInfo','Developer','')+'"');
    St.Add('    Publisher="'+Ini.ReadString('ExtraInfo','Publisher','')+'"');
    St.Add('    Year="'+Ini.ReadString('ExtraInfo','Year','')+'"');
    St.Add('    Language="'+Ini.ReadString('ExtraInfo','Language','')+'"');
    St.Add('    PackageChecksum="'+PackageChecksum+'"');
    St.Add('    GameExeChecksum="'+Ini.ReadString('Extra','ExeMD5','')+'"');
    St.Add('    Size="'+PackageSize+'">'+DataFileNameInXML+'</AutoSetup>');
  finally
    Ini.Free;
  end;
end;

Function AddPackageDataLanguage(const St : TStringList; const DataFileName : String) : Boolean;
Var PackageSize, PackageChecksum, DataFileNameInXML : String;
    Ini : TIniFile;
begin
  result:=False;
  If not FileExists(DataFileName) then begin
    MessageDlg(Format(LanguageSetup.MessageFileNotFound,[DataFileName]),mtError,[mbOK],0);
    exit;
  end;
  PackageSize:=GetFileSize(DataFileName);
  PackageChecksum:=GetMD5Sum(DataFileName);
  DataFileNameInXML:=URLFileNameFromFileName(ExtractFileName(DataFileName));
  result:=True;

  Ini:=TIniFile.Create(DataFileName);
  try
    St.Add('  <Language');
    St.Add('    Name="'+ChangeFileExt(ExtractFileName(DataFileName),'')+'"');
    St.Add('    Version="'+Ini.ReadString('LanguageFileInfo','MaxVersion','')+'"');
    St.Add('    Author="'+Ini.ReadString('Author','Name','')+'"');
    St.Add('    PackageChecksum="'+PackageChecksum+'"');
    St.Add('    Size="'+PackageSize+'">'+DataFileNameInXML+'</Language>');
  finally
    Ini.Free;
  end;
end;

Function AddPackageDataExe(const St : TStringList; const DataFileName : String) : Boolean;
Var PackageSize, PackageChecksum, DataFileNameInXML : String;
begin
  result:=False;
  If not FileExists(DataFileName) then begin
    MessageDlg(Format(LanguageSetup.MessageFileNotFound,[DataFileName]),mtError,[mbOK],0);
    exit;
  end;
  PackageSize:=GetFileSize(DataFileName);
  PackageChecksum:=GetMD5Sum(DataFileName);
  DataFileNameInXML:=URLFileNameFromFileName(ExtractFileName(DataFileName));
  result:=True;

  St.Add('  <ExePackage');
  St.Add('    Name=""');
  St.Add('    Description=""');
  St.Add('    PackageChecksum="'+PackageChecksum+'"');
  St.Add('    Size="'+PackageSize+'">'+DataFileNameInXML+'</ExePackage>');
end;

Function AddPackageDataIcon(const St : TStringList; const DataFileName : String) : Boolean;
Var PackageSize, PackageChecksum, DataFileNameInXML : String;
begin
  result:=False;
  If not FileExists(DataFileName) then begin
    MessageDlg(Format(LanguageSetup.MessageFileNotFound,[DataFileName]),mtError,[mbOK],0);
    exit;
  end;
  PackageSize:=GetFileSize(DataFileName);
  PackageChecksum:=GetMD5Sum(DataFileName);
  DataFileNameInXML:=URLFileNameFromFileName(ExtractFileName(DataFileName));
  result:=True;

  St.Add('  <Icon');
  St.Add('    Name=""');
  St.Add('    FileChecksum="'+PackageChecksum+'"');
  St.Add('    Size="'+PackageSize+'">'+DataFileNameInXML+'</Icon>');
end;

Function GetPackageDataForFile(const DataFileName : String) : TStringList;
Var Ext : String;
begin
  result:=nil;

  Ext:=ExtUpperCase(ExtractFileExt(DataFileName));
  If (Ext<>'.ZIP') and (Ext<>'.PROF') and (Ext<>'.INI') and (Ext<>'.EXE') and (Ext<>'.ICO') then begin
    MessageDlg(LANG_PackageBuilderWrongFileType,mtError,[mbOK],0);
    exit;
  end;

  result:=TStringList.Create;

  result.Add('<?xml version="1.0" encoding="ISO-8859-1" standalone="no"?>');
  result.Add('<!DOCTYPE DFRPackagesFile SYSTEM "http:/'+'/dfendreloaded.sourceforge.net/Packages/DFRPackagesFile.dtd">');
  result.Add('');
  result.Add('<DFRPackagesFile Name="" LastUpdateDate="'+EncodeUpdateDate(Date)+'">');

  If Ext='.ZIP' then begin If not AddPackageDataZip(result,DataFileName) then begin FreeAndNil(result); exit; end; end;
  If Ext='.PROF' then begin If not AddPackageDataAutoSetup(result,DataFileName) then begin FreeAndNil(result); exit; end; end;
  If Ext='.INI' then begin If not AddPackageDataLanguage(result,DataFileName) then begin FreeAndNil(result); exit; end; end;
  If Ext='.EXE' then begin If not AddPackageDataExe(result,DataFileName) then begin FreeAndNil(result); exit; end; end;
  If Ext='.ICO' then begin If not AddPackageDataIcon(result,DataFileName) then begin FreeAndNil(result); exit; end; end;
  {... Iconset}

  result.Add('</DFRPackagesFile>');
end;

end.
