unit HashCalc;
interface

Function GetMD5Sum(const FileName : String) : String;

implementation

uses Classes, SysUtils, HashAlgMD5_U, HashValue_U;

Function GetMD5Sum(const FileName : String) : String;
Var HashAlgMD5 : THashAlgMD5;
    HashValue: THashValue;
    FileStream : TFileStream;
begin
  result:='';

  if (Trim(FileName)='') or (not FileExists(FileName)) then exit;

  HashAlgMD5:=THashAlgMD5.Create(nil);
  try
    HashAlgMD5.Init;
    try
      FileStream:=TFileStream.Create(FileName,fmOpenRead);
    except
      exit;
    end;
    try
      HashAlgMD5.Update(FileStream);
    finally
      FileStream.Free;
    end;
    HashValue:=THashValue.Create;
    try
      HashAlgMD5.Final(HashValue);
      result:=HashValue.ValueAsASCIIHex;
    finally
      HashValue.Free;
    end;
  finally
    HashAlgMD5.Free;
  end;
end;

end.
