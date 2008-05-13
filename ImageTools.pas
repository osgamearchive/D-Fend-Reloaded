unit ImageTools;
interface

Function GetGeometryFromFile(const FileName : String) : String;
Function GetGemoetryFromMB(const Size : Integer) : String;
Function ShortName(const LongName : String) : String;

implementation

uses Windows, SysUtils, PrgSetupUnit;

Function GetGeometryFromFile(const FileName : String) : String;
Var hFile : THandle;
    LoDWORD, HiDWORD : DWORD;
    LoI, HiI : Int64;
begin
  hFile:=CreateFile(PChar(FileName),GENERIC_READ,0,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  If hFile=INVALID_HANDLE_VALUE then begin
    result:='';
  end else begin
    try
      LoDWORD:=GetFileSize(hFile,@HiDWORD);
      LoI:=LoDWORD; HiI:=HiDWORD;
      LoI:=LoI+$100000000*HiI;
      LoI:=LoI div 512 div 63 div 16;
      result:='512,63,16,'+IntToStr(LoI);
    finally
      CloseHandle(hFile);
    end;
  end;
end;

Function GetGemoetryFromMB(const Size : Integer) : String;
begin
  {Correct way for calculating the size (512*63*16*X=Bytes => X=MBytes*128/63)
  but not the way mkdosfs works:
  I:=Size*128 div 63;
  result:='512,63,16,'+IntToStr(I);}

  {mkdosfs simply does this:}
  result:='512,63,16,'+IntToStr(Size*2);
end;

Function ShortName(const LongName : String) : String;
begin
  If PrgSetup.UseShortFolderNames then begin
    SetLength(result,MAX_PATH+10);
    if GetShortPathName(PChar(LongName),PChar(result),MAX_PATH)=0
      then result:=LongName
      else SetLength(result,StrLen(PChar(result)));
  end else begin
    result:=LongName;
  end;
end;

end.
