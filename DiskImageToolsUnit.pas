unit DiskImageToolsUnit;
interface

{
Sectors=cyl*heads*spt*bps; (spt=Sectors per Track; bps=Bytes per Sector=512)

Floppy Formats:

cyl=40; heads=1; spt= 8;   160kb= 163840 (5,25" Single-Sided, Double Density (DD))
cyl=40; heads=1; spt= 9;   180kb= 184320 (5,25" Single-Sided, Double Density (DD))
cyl=40; heads=2; spt= 8;   320kb= 327680 (5,25" Double-Sided, Double Density (DD))
cyl=40; heads=2; spt= 9;   360kb= 368640 (5,25" Double-Sided, Double Density (DD))
cyl=80; heads=2; spt= 9;   720kb= 737280 (3,5" Double-Sided, Double Density (DD))
cyl=80; heads=2; spt=15;  1200kb=1228800 (5,25" Double-Sided, High-Density (HD))
cyl=80; heads=2; spt=18;  1440kb=1474560 (3,5" Double-Sided, High-Density (HD))
cyl=80; heads=2; spt=21;  1680kb=1720320 (3,5" Double-Sided, Custom Density)
cyl=82; heads=2; spt=21;  1720kb=1763328 (3,5" Double-Sided, Custom Density)
cyl=80; heads=2; spt=36;  2880kb=2949120 (3,5" Double-Sided, Extended Density (ED))


HD Formats:
cyl=63; heads=16; spt=X
}
Function WriteFlatImage(const SecCount : Integer; const FileName : String; const Compressed : Boolean) : Boolean;

Procedure CompressFile(const FileName : String);

implementation

uses Windows;

const COMPRESSION_FORMAT_NONE    = 0;
      COMPRESSION_FORMAT_DEFAULT = 1;
      FILE_DEVICE_FILE_SYSTEM    = 9;
      METHOD_BUFFERED            = 0;
      FILE_READ_DATA             = 1;
      FILE_WRITE_DATA            = 2;
      FSCTL_SET_COMPRESSION      = (FILE_DEVICE_FILE_SYSTEM shl 16) or ((FILE_READ_DATA or FILE_WRITE_DATA) shl 14) or (16 shl 2) or METHOD_BUFFERED;

Procedure CompressFile(const FileName : String);
Var hFile : THandle;
    Mode : Short;
    C : Cardinal;
begin
  hFile:=CreateFile(PChar(Filename),GENERIC_WRITE or GENERIC_READ,0,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  if hFile=INVALID_HANDLE_VALUE then exit;
  try
    Mode:=COMPRESSION_FORMAT_DEFAULT;
    DeviceIoControl(hFile, FSCTL_SET_COMPRESSION,@Mode,sizeof(Mode),nil,0,C,nil);
  finally
    CloseHandle(hFile);
  end;
end;

Function WriteFlatImage(const SecCount : Integer; const FileName : String; const Compressed : Boolean) : Boolean;
Var hFile : THandle;
    Buffer : Array[0..511] of Byte;
    C : Cardinal;
    I1, I2 : Integer;
    Mode : Short;
begin
  FillChar(Buffer,SizeOf(Buffer),0);

  hFile:=CreateFile(PChar(Filename),GENERIC_WRITE or GENERIC_READ,0,nil,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0);
  result:=(hFile<>INVALID_HANDLE_VALUE); if not result then exit;
  try
    result:=WriteFile(hFile,Buffer,SizeOf(Buffer),C,nil) and (C=SizeOf(Buffer)); if not result then exit;

    If Compressed then begin
      Mode:=COMPRESSION_FORMAT_DEFAULT;
      DeviceIoControl(hFile, FSCTL_SET_COMPRESSION,@Mode,sizeof(Mode),nil,0,C,nil);
    end;

    I1:=((SecCount-1) shl 9);
    I2:=((SecCount-1) shr 23);
    result:=(SetFilePointer(hFile,I1,@I2,FILE_BEGIN)<>$ffffffff);

    result:=WriteFile(hFile,Buffer,SizeOf(Buffer),C,nil) and (C=SizeOf(Buffer)); if not result then exit;
  finally
    CloseHandle(hFile);
  end;
end;

end.
