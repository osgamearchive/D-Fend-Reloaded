unit ReadDriveUnit;
interface

Type TReadDataResult=(RD_OK, RD_CannotOpen, RD_CannotGetDriveData, RD_CannotSetExtendedAccess, RD_CannotOpenOutputFile, RD_ReadError, RD_Canceled);

Type TReadProgressEvent=Procedure(const BytesRead, TotalBytesToRead : Cardinal; var ContinueReading : Boolean) of object;

Function ReadCDData(const Drive : Char; const FileName : String; const OnProgress : TReadProgressEvent) : TReadDataResult;
Function ReadFloppyData(const Drive : Char; const FileName : String; const OnProgress : TReadProgressEvent) : TReadDataResult;

implementation

uses Windows, Classes, Math;

function OpenVolume(const Drive: Char): THandle;
var VolumeName: array [0..6] of Char;
begin
  VolumeName:='\\.\A:'; VolumeName[4]:=Drive;
  result:=CreateFile(VolumeName,GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,0,0);
end;

const FILE_ANY_ACCESS=0;
      METHOD_NEITHER=3;
      FILE_DEVICE_FILE_SYSTEM=9;
      FSCTL_ALLOW_EXTENDED_DASD_IO=(FILE_DEVICE_FILE_SYSTEM shl 16) or (FILE_ANY_ACCESS shl 14) or (32 shl 2) or METHOD_NEITHER;

Function EnableExtendedAccess(const Volume : THandle) : Boolean;
Var I : Cardinal;
begin
  result:=DeviceIoControl(Volume,FSCTL_ALLOW_EXTENDED_DASD_IO, nil,0,nil,0,I,nil);
end;

function CloseVolume(var Volume: THandle): Boolean;
begin
  result:=False;
  if Volume=INVALID_HANDLE_VALUE then exit;
  result:=CloseHandle(Volume);
  if Result then Volume:=INVALID_HANDLE_VALUE;
end;

Function GetDriveData(const Drive : Char; var BytesToRead, SectorSize : Cardinal) : Boolean;
Var lpSectorsPerCluster,lpNumberOfFreeClusters,lpTotalNumberOfClusters : Cardinal;
begin
  result:=GetDiskFreeSpace(PChar(Drive+':\'),lpSectorsPerCluster,SectorSize,lpNumberOfFreeClusters,lpTotalNumberOfClusters);
  if result then BytesToRead:=lpSectorsPerCluster*SectorSize*lpTotalNumberOfClusters;
end;

Procedure GetAlignedBuffer(const BufferSize, Align : Cardinal; var RealPointer, AlignedPointer : Pointer);
begin
  GetMem(RealPointer,BufferSize+Align);
  AlignedPointer:=RealPointer;
  If Cardinal(AlignedPointer) mod Align<>0 then
    AlignedPointer:=Pointer(Cardinal(AlignedPointer)+Align-(Cardinal(AlignedPointer) mod Align));
end;

Function ReadCDData(const Drive : Char; const FileName : String; const OnProgress : TReadProgressEvent) : TReadDataResult;
Var Volume : THandle;
    BytesToRead, SectorSize, BytesRead, TotalBytesToRead, I : Cardinal;
    OutputFile : TFileStream;
    RealPointer, AlignedPointer : Pointer;
    ContinueReading : Boolean;
begin
  if not GetDriveData(Drive,BytesToRead,SectorSize) then begin result:=RD_CannotGetDriveData; exit; end;
  Volume:=OpenVolume(Drive);
  If Volume=INVALID_HANDLE_VALUE then begin result:=RD_CannotOpen; exit; end;
  try
    if not EnableExtendedAccess(Volume) then begin result:=RD_CannotSetExtendedAccess; exit; end;
    try OutputFile:=TFileStream.Create(FileName,fmCreate); except result:=RD_CannotOpenOutputFile; exit; end;
    try
      GetAlignedBuffer(SectorSize,SectorSize,RealPointer,AlignedPointer);
      try
        BytesRead:=0; TotalBytesToRead:=BytesToRead;
        while BytesToRead>0 do begin
          If (not ReadFile(Volume,AlignedPointer^,Min(BytesToRead,SectorSize),I,nil)) or (I<>Min(BytesToRead,SectorSize)) then begin
            result:=RD_ReadError; exit;
          end;
          OutputFile.WriteBuffer(AlignedPointer^,I);
          BytesToRead:=BytesToRead-I;
          BytesRead:=BytesRead+I;
          If Assigned(OnProgress) then begin
            ContinueReading:=True;
            OnProgress(BytesRead,TotalBytesToRead,ContinueReading);
            if not ContinueReading then begin result:=RD_Canceled; exit; end;
          end;
        end;
      finally
        FreeMem(RealPointer);
      end;
    finally
      OutputFile.Free;
    end;
  finally
    CloseVolume(Volume);
  end;
  result:=RD_OK;
end;

Function ReadFloppyData(const Drive : Char; const FileName : String; const OnProgress : TReadProgressEvent) : TReadDataResult;
Var Volume : THandle;
    BytesToRead, SectorSize, BytesRead, I : Cardinal;
    OutputFile : TFileStream;
    RealPointer, AlignedPointer : Pointer;
    ContinueReading : Boolean;
begin
  if not GetDriveData(Drive,BytesToRead,SectorSize) then begin result:=RD_CannotGetDriveData; exit; end;
  Volume:=OpenVolume(Drive);
  If Volume=INVALID_HANDLE_VALUE then begin result:=RD_CannotOpen; exit; end;
  try
    if not EnableExtendedAccess(Volume) then begin result:=RD_CannotSetExtendedAccess; exit; end;
    try OutputFile:=TFileStream.Create(FileName,fmCreate); except result:=RD_CannotOpenOutputFile; exit; end;
    try
      GetAlignedBuffer(SectorSize,SectorSize,RealPointer,AlignedPointer);
      try
        BytesRead:=0;
        repeat
          ReadFile(Volume,AlignedPointer^,SectorSize,I,nil);
          OutputFile.WriteBuffer(AlignedPointer^,I);
          BytesRead:=BytesRead+I;
          If I<SectorSize then begin
            If BytesRead=0 then begin result:=RD_ReadError; exit; end;
            break;
          end;
          If Assigned(OnProgress) then begin
            ContinueReading:=True;
            OnProgress(BytesRead,0,ContinueReading);
            if not ContinueReading then begin result:=RD_Canceled; exit; end;
          end;
        until False;
      finally
        FreeMem(RealPointer);
      end;
    finally
      OutputFile.Free;
    end;
  finally
    CloseVolume(Volume);
  end;
  result:=RD_OK;
end;

end.
