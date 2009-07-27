unit CreateImageUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ImgList, ExtCtrls;

type
  TCreateImageForm = class(TForm)
    PageControl: TPageControl;
    FloppyImageSheet: TTabSheet;
    HDImageSheet: TTabSheet;
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    ImageList: TImageList;
    FloppyImageTypeComboBox: TComboBox;
    FloppyImageTypeLabel: TLabel;
    FloppyCylindersLabel: TLabel;
    FloppyHeadsLabel: TLabel;
    FloppySPTLabel: TLabel;
    FloppyCylindersComboBox: TComboBox;
    FloppyHeadsComboBox: TComboBox;
    FloppySPTComboBox: TComboBox;
    FloppyImageSizeEdit: TLabeledEdit;
    FloppyImageFileEdit: TLabeledEdit;
    FloppyFileButton: TSpeedButton;
    OpenDialog: TOpenDialog;
    HDSizeEdit: TLabeledEdit;
    HDGeometryEdit: TLabeledEdit;
    HDImageFileEdit: TLabeledEdit;
    HDFileButton: TSpeedButton;
    HDCompressedCheckBox: TCheckBox;
    FloppyCompressedCheckBox: TCheckBox;
    FloppyMakeBootableCheckBox: TCheckBox;
    FloppyNeedFreeDOSLabel: TLabel;
    FloppyMakeBootableWithKeyboardDriverCheckBox: TCheckBox;
    FloppyMakeBootableWithMouseDriverCheckBox: TCheckBox;
    ImageTypeRadioGroup: TRadioGroup;
    HelpButton: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FloppyFileButtonClick(Sender: TObject);
    procedure FloppyImageTypeComboBoxChange(Sender: TObject);
    procedure FloppyDataChange(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure HDSizeEditChange(Sender: TObject);
    procedure FloppyMakeBootableCheckBoxClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private-Deklarationen }
    JustChanging : Boolean;
    CompressImage : Boolean;
    Procedure CalcFloppySize;
    Procedure SimpleImageCreator;
    Procedure FATImageCreator;
  public
    { Public-Deklarationen }
    ImageFileName : String;
  end;

var
  CreateImageForm: TCreateImageForm;

Function ShowCreateImageFileDialog(const AOwner : TComponent; const ShowFloppySheet, ShowHDSheet : Boolean) : String;

function BuildStandardFloppyImage(const FileName: String): Boolean;
Function MakeFloppyBootable(const ImageFile : String; const MakeBootable, WithKeyboardDriver, WithMouseDriver : Boolean; const CopyFolder : String='') : Boolean;
Function MakeHDBootable(const ImageFile : String; const WithKeyboardDriver, WithMouseDriver : Boolean) : Boolean;

implementation

uses ShellAPI, VistaToolsUnit, LanguageSetupUnit, DiskImageToolsUnit,
     PrgSetupUnit, CommonTools, PrgConsts, GameDBUnit, DOSBoxUnit, ImageTools,
     HelpConsts, IconLoaderUnit;

{$R *.dfm}

var FloppyCylinders : Array[0..7] of Integer = (40, 40, 40, 40, 80, 80, 80, 80);
    FloppyHeads     : Array[0..7] of Integer = ( 1,  1,  2,  2,  2,  2,  2,  2);
    FloppySPT       : Array[0..7] of Integer = ( 8,  9,  8,  9,  9, 15, 18, 36);

const FloppyDefault=6;

procedure TCreateImageForm.FormCreate(Sender: TObject);
Var I : Integer;
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);

  Caption:=LanguageSetup.CreateImageForm;
  FloppyImageSheet.Caption:=LanguageSetup.ProfileMountingFloppyImageSheet;
  HDImageSheet.Caption:=LanguageSetup.ProfileMountingImageSheet;
  FloppyImageTypeLabel.Caption:=LanguageSetup.CreateImageFormFloppyImageType;
  FloppyCylindersLabel.Caption:=LanguageSetup.CreateImageFormCylinders;
  FloppyHeadsLabel.Caption:=LanguageSetup.CreateImageFormHeads;
  FloppySPTLabel.Caption:=LanguageSetup.CreateImageFormSPT;
  FloppyImageSizeEdit.EditLabel.Caption:=LanguageSetup.CreateImageFormFloppyImageSize;
  FloppyImageFileEdit.EditLabel.Caption:=LanguageSetup.CreateImageFormFilename;
  FloppyFileButton.Hint:=LanguageSetup.ChooseFile;
  FloppyCompressedCheckBox.Caption:=LanguageSetup.CreateImageFormCompression;
  FloppyMakeBootableCheckBox.Caption:=LanguageSetup.CreateImageFormMakeFloppyBootable;
  FloppyNeedFreeDOSLabel.Caption:=LanguageSetup.ProfileEditorNeedFreeDOS;
  FloppyMakeBootableWithKeyboardDriverCheckBox.Caption:=LanguageSetup.CreateImageFormMakeFloppyBootableWithKeyboardDriver;
  FloppyMakeBootableWithMouseDriverCheckBox.Caption:=LanguageSetup.CreateImageFormMakeFloppyBootableWithMouseDriver;
  HDSizeEdit.EditLabel.Caption:=LanguageSetup.CreateImageFormHDImageSize;
  HDGeometryEdit.EditLabel.Caption:=LanguageSetup.CreateImageFormHDImageGeometry;
  HDImageFileEdit.EditLabel.Caption:=LanguageSetup.CreateImageFormFilename;
  HDFileButton.Hint:=LanguageSetup.ChooseFile;
  HDCompressedCheckBox.Caption:=LanguageSetup.CreateImageFormCompression;
  ImageTypeRadioGroup.Caption:=LanguageSetup.CreateImageFormHDImageType;
  ImageTypeRadioGroup.Items[0]:=LanguageSetup.CreateImageFormHDImageTypePlain;
  ImageTypeRadioGroup.Items[1]:=LanguageSetup.CreateImageFormHDImageTypeFAT;

  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  HelpButton.Caption:=LanguageSetup.Help;

  UserIconLoader.DialogImage(DI_SelectFile,FloppyFileButton);
  UserIconLoader.DialogImage(DI_SelectFile,HDFileButton);
  UserIconLoader.DialogImage(DI_ImageFloppy,ImageList,0);
  UserIconLoader.DialogImage(DI_ImageHD,ImageList,1);
  UserIconLoader.DialogImage(DI_OK,OKButton);
  UserIconLoader.DialogImage(DI_Cancel,CancelButton);
  UserIconLoader.DialogImage(DI_Help,HelpButton);

  If DirectoryExists(IncludeTrailingPathDelimiter(MakeAbsPath(PrgSetup.PathToFREEDOS,PrgSetup.BaseDir))) then begin
    FloppyNeedFreeDOSLabel.Font.Color:=clGrayText;
  end else begin
    FloppyNeedFreeDOSLabel.Font.Color:=clRed;
  end;

  If FileExists(PrgDir+MakeDOSFilesystemFileName) or FileExists(PrgDir+BinFolder+'\'+MakeDOSFilesystemFileName) then begin
    FloppyCylindersComboBox.Items.Add('40');
    FloppyCylindersComboBox.Items.Add('80');
    FloppySPTComboBox.Items.Add('8');
    FloppySPTComboBox.Items.Add('9');
    FloppySPTComboBox.Items.Add('15');
    FloppySPTComboBox.Items.Add('18');
    FloppySPTComboBox.Items.Add('36');
  end else begin
    For I:=1 to 100 do FloppyCylindersComboBox.Items.Add(IntToStr(I));
    For I:=1 to 40 do FloppySPTComboBox.Items.Add(IntToStr(I));
  end;
  For I:=1 to 2 do FloppyHeadsComboBox.Items.Add(IntToStr(I));
  FloppyImageTypeComboBox.Items.Add('5,25" single-sided, double density (DD)');
  FloppyImageTypeComboBox.Items.Add('5,25" single-sided, double density (DD)');
  FloppyImageTypeComboBox.Items.Add('5,25" double-sided, double density (DD)');
  FloppyImageTypeComboBox.Items.Add('5,25" double-sided, double density (DD)');
  FloppyImageTypeComboBox.Items.Add('3,5" double-sided, double density (DD)');
  FloppyImageTypeComboBox.Items.Add('5,25" double-sided, high-density (HD)');
  FloppyImageTypeComboBox.Items.Add('3,5" double-sided, high-density (HD)');
  FloppyImageTypeComboBox.Items.Add('3,5" double-sided, extended density (ED)');
  FloppyImageTypeComboBox.Items.Add('Custom format');

  JustChanging:=False;
  FloppyImageTypeComboBox.ItemIndex:=6;
  FloppyImageTypeComboBoxChange(Sender);
  HDSizeEditChange(Sender);

  OpenDialog.Title:=LanguageSetup.ProfileMountingFile;
  OpenDialog.Filter:=LanguageSetup.ProfileMountingFileFilterImgOnly;
end;

procedure TCreateImageForm.FloppyImageTypeComboBoxChange(Sender: TObject);
begin
  FloppyMakeBootableCheckBox.Enabled:=(FloppyImageTypeComboBox.ItemIndex=FloppyDefault);
  FloppyMakeBootableCheckBox.Checked:=FloppyMakeBootableCheckBox.Checked and FloppyMakeBootableCheckBox.Enabled;

  If JustChanging then exit;
  If FloppyImageTypeComboBox.ItemIndex=8 then exit;

  JustChanging:=True;
  try
    FloppyCylindersComboBox.ItemIndex:=
      FloppyCylindersComboBox.Items.IndexOf(IntToStr(FloppyCylinders[FloppyImageTypeComboBox.ItemIndex]));
    FloppyHeadsComboBox.ItemIndex:=
      FloppyHeadsComboBox.Items.IndexOf(IntToStr(FloppyHeads[FloppyImageTypeComboBox.ItemIndex]));
    FloppySPTComboBox.ItemIndex:=
      FloppySPTComboBox.Items.IndexOf(IntToStr(FloppySPT[FloppyImageTypeComboBox.ItemIndex]));
    CalcFloppySize;
  finally
    JustChanging:=False;
  end;
end;

procedure TCreateImageForm.FloppyDataChange(Sender: TObject);
Var I : Integer;
begin
  If JustChanging then exit;
  JustChanging:=True;
  try
    For I:=0 to 7 do If (StrToInt(FloppyCylindersComboBox.Text)=FloppyCylinders[I]) and (StrToInt(FloppyHeadsComboBox.Text)=FloppyHeads[I]) and (StrToInt(FloppySPTComboBox.Text)=FloppySPT[I]) then begin
      FloppyImageTypeComboBox.ItemIndex:=I;
      exit;
    end;
    FloppyImageTypeComboBox.ItemIndex:=8;
  finally
    JustChanging:=False;
    CalcFloppySize;
    FloppyMakeBootableCheckBox.Enabled:=(FloppyImageTypeComboBox.ItemIndex=FloppyDefault);
    FloppyMakeBootableCheckBox.Checked:=FloppyMakeBootableCheckBox.Checked and FloppyMakeBootableCheckBox.Enabled;
  end;
end;

procedure TCreateImageForm.CalcFloppySize;
Var I : Integer;
begin
  I:=512*StrToInt(FloppyCylindersComboBox.Text)*StrToInt(FloppyHeadsComboBox.Text)*StrToInt(FloppySPTComboBox.Text);
  FloppyImageSizeEdit.Text:=Format('%s Bytes = %s KB',[IntToStr(I),IntToStr(I div 1024)]);
end;

procedure TCreateImageForm.FloppyFileButtonClick(Sender: TObject);
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          If FloppyImageFileEdit.Text=''
            then OpenDialog.InitialDir:=PrgSetup.GameDir
            else OpenDialog.InitialDir:=ExtractFilePath(FloppyImageFileEdit.Text);
          if not OpenDialog.Execute then exit;
          FloppyImageFileEdit.Text:=OpenDialog.FileName;
        end;
    1 : begin
          If HDImageFileEdit.Text=''
            then OpenDialog.InitialDir:=PrgSetup.GameDir
            else OpenDialog.InitialDir:=ExtractFilePath(HDImageFileEdit.Text);
          if not OpenDialog.Execute then exit;
          HDImageFileEdit.Text:=OpenDialog.FileName;
        end;
  end;
end;

procedure TCreateImageForm.HDSizeEditChange(Sender: TObject);
begin
  HDGeometryEdit.Text:='';
  try
    HDGeometryEdit.Text:=GetGemoetryFromMB(StrToInt(HDSizeEdit.Text));
  except
    exit;
  end;
end;

procedure TCreateImageForm.FloppyMakeBootableCheckBoxClick(Sender: TObject);
begin
  FloppyMakeBootableWithKeyboardDriverCheckBox.Enabled:=FloppyMakeBootableCheckBox.Checked;
  FloppyMakeBootableWithMouseDriverCheckBox.Enabled:=FloppyMakeBootableCheckBox.Checked;
end;

procedure TCreateImageForm.OKButtonClick(Sender: TObject);
begin
  If PageControl.ActivePageIndex=0 then begin
    {Floppy Image}
    ImageFileName:=FloppyImageFileEdit.Text;
    If Trim(ImageFileName)='' then begin
      MessageDlg(LanguageSetup.MessageNoFileName,mtError,[mbOK],0);
      ModalResult:=mrNone; exit;
    end;
    If FileExists(ImageFileName) then begin
      If MessageDlg(Format(LanguageSetup.MessageConfirmationOverwriteFile,[ImageFileName]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then begin
        ModalResult:=mrNone; exit;
      end;
      ExtDeleteFile(ImageFileName,ftProfile);
    end;
    CompressImage:=FloppyCompressedCheckBox.Checked;
  end else begin
    {HD Image}
    ImageFileName:=HDImageFileEdit.Text;
    If Trim(ImageFileName)='' then begin
      MessageDlg(LanguageSetup.MessageNoFileName,mtError,[mbOK],0);
      ModalResult:=mrNone; exit;
    end;
    If FileExists(ImageFileName) then begin
      If MessageDlg(Format(LanguageSetup.MessageConfirmationOverwriteFile,[ImageFileName]),mtConfirmation,[mbYes,mbNo],0)<>mrYes then begin
        ModalResult:=mrNone; exit;
      end;
      ExtDeleteFile(ImageFileName,ftProfile);
    end;
    CompressImage:=HDCompressedCheckBox.Checked;
  end;

  If ((not FileExists(PrgDir+MakeDOSFilesystemFileName)) and (not FileExists(PrgDir+BinFolder+'\'+MakeDOSFilesystemFileName))) or ((PageControl.ActivePageIndex=1) and (ImageTypeRadioGroup.ItemIndex=0)) then begin
    SimpleImageCreator;
  end else begin
    FATImageCreator;
    Case PageControl.ActivePageIndex of
      0 : If FloppyMakeBootableCheckBox.Checked then MakeFloppyBootable(ImageFileName,True,FloppyMakeBootableWithKeyboardDriverCheckBox.Checked,FloppyMakeBootableWithMouseDriverCheckBox.Checked);
      {1 : If HDMakeBootableCheckBox.Checked then MakeHDBootable(ImageFileName,HDMakeBootableWithKeyboardDriverCheckBox.Checked,HDMakeBootableWithMouseDriverCheckBox.Checked);}
    end;
  end;
end;

procedure TCreateImageForm.FATImageCreator;
const ParamFile='DFend-mkdosfs-InFile.txt';
      ParamBatchFile='DFend-mkdosfs.bat';
Var St : TStringList;
    I : Integer;
    {StartupInfo : TStartupInfo;
    ProcessInformation : TProcessInformation;}
begin
  St:=TStringList.Create;
  try
    If PageControl.ActivePageIndex=0 then begin
      {Floppy Image}
      St.Add('fd');
      St.Add(ImageFileName);
      St.Add(FloppySPTComboBox.Text);
      St.Add(FloppyHeadsComboBox.Text);
      St.Add(FloppyCylindersComboBox.Text);
      If (FloppySPTComboBox.Text='36') and (FloppyHeadsComboBox.Text='2') and (FloppyCylindersComboBox.Text='80')
        then St.Add('2')
        else St.Add('1');
      St.Add('2');
      St.Add('12');
    end else begin
      {HD Image}
      try I:=StrToInt(HDSizeEdit.Text); except I:=-1; end;
      If (I<=0) or (I>1000) then begin
        MessageDlg(LanguageSetup.MessageWrongDiskSize,mtError,[mbOK],0);
        ModalResult:=mrNone;
        exit;
      end;
      I:=(I*1024) div 1000;
      St.Add('hd');
      St.Add(ImageFileName);
      St.Add(IntToStr(I));
      Case I of
        1.. 32 : St.Add('1');
       33.. 64 : St.Add('2');
       65..128 : St.Add('4');
      129..256 : St.Add('8');
      257..512 : St.Add('16');
      else       St.Add('32');
      End;
      St.Add('2');
      St.Add('16');
    end;

    If FileExists(PrgDir+MakeDOSFilesystemFileName) then begin
      if not RunWithInput(PrgDir+MakeDOSFilesystemFileName,'',False,St) then exit;
    end else begin
      if not RunWithInput(PrgDir+BinFolder+'\'+MakeDOSFilesystemFileName,'',False,St) then exit;
    end;
  finally
    St.Free;
  end;

  {St:=TStringList.Create;
  try
    St.Add('"'+PrgDir+MakeDOSFilesystemFileName+'" < "'+TempDir+ParamFile+'"');
    St.SaveToFile(TempDir+ParamBatchFile);
  finally
    St.Free;
  end;

  StartupInfo.cb:=SizeOf(StartupInfo);
  with StartupInfo do begin lpReserved:=nil; lpDesktop:=nil; dwFlags:=0; cbReserved2:=0; lpReserved2:=nil; end;
  CreateProcess(PChar(TempDir+ParamBatchFile),PChar('"'+TempDir+ParamBatchFile+'"'),nil,nil,False,0,nil,PChar(PrgDir),StartupInfo,ProcessInformation);

  WaitForSingleObject(ProcessInformation.hThread,INFINITE);
  CloseHandle(ProcessInformation.hThread);
  CloseHandle(ProcessInformation.hProcess);

  ExtDeleteFile(TempDir+ParamFile,ftTemp);
  ExtDeleteFile(TempDir+ParamBatchFile,ftTemp);}
  If CompressImage then CompressFile(ImageFileName);
end;

procedure TCreateImageForm.SimpleImageCreator;
Var I : Integer;
begin
  If PageControl.ActivePageIndex=0 then begin
    {Floppy Image}
    I:=StrToInt(FloppyCylindersComboBox.Text)*StrToInt(FloppyHeadsComboBox.Text)*StrToInt(FloppySPTComboBox.Text);
  end else begin
    {HD Image}
    try I:=StrToInt(HDSizeEdit.Text)*128 div 63; {512*63*16*X=Bytes => X=MBytes*128/63} except I:=-1; end;
    If I<=0 then begin
      MessageDlg(LanguageSetup.MessageWrongDiskSize,mtError,[mbOK],0);
      ModalResult:=mrNone;
      exit;
    end;
    I:=I*16*63;
  end;
  if not WriteFlatImage(I,ImageFileName,CompressImage) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[ImageFileName]),mtError,[mbOK],0);
    ModalResult:=mrNone;
    exit;
  end;
end;

procedure TCreateImageForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,ID_ExtrasImagesCreateImage);
end;

procedure TCreateImageForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  If (Key=VK_F1) and (Shift=[]) then HelpButtonClick(Sender);
end;

{ global }

Function ShowCreateImageFileDialog(const AOwner : TComponent; const ShowFloppySheet, ShowHDSheet : Boolean) : String;
begin
  CreateImageForm:=TCreateImageForm.Create(AOwner);
  try
    CreateImageForm.FloppyImageSheet.TabVisible:=ShowFloppySheet;
    CreateImageForm.HDImageSheet.TabVisible:=ShowHDSheet;
    If CreateImageForm.ShowModal=mrOk then result:=CreateImageForm.ImageFileName else result:='';
  finally
    CreateImageForm.Free;
  end;
end;

function BuildStandardFloppyImage(const FileName: String): Boolean;
const ParamFile='DFend-mkdosfs-InFile.txt';
      ParamBatchFile='DFend-mkdosfs.bat';
Var St : TStringList;
    StartupInfo : TStartupInfo;
    ProcessInformation : TProcessInformation;
begin
  result:=False;

  If (not FileExists(PrgDir+MakeDOSFilesystemFileName)) and (not FileExists(PrgDir+BinFolder+'\'+MakeDOSFilesystemFileName)) then begin
    MessageDlg(Format(LanguageSetup.MessageCouldNotFindFile,[PrgDir+BinFolder+'\'+MakeDOSFilesystemFileName]),mtError,[mbOK],0);
    exit;
  end;

  St:=TStringList.Create;
  try
    St.Add('fd');
    St.Add(FileName);
    St.Add('18');
    St.Add('2');
    St.Add('80');
    St.Add('1');
    St.Add('2');
    St.Add('12');
    St.SaveToFile(TempDir+ParamFile);
  finally
    St.Free;
  end;

  St:=TStringList.Create;
  try
    If FileExists(PrgDir+MakeDOSFilesystemFileName) then begin
      St.Add('"'+PrgDir+MakeDOSFilesystemFileName+'" < "'+TempDir+ParamFile+'"');
    end else begin
      St.Add('"'+PrgDir+BinFolder+'\'+MakeDOSFilesystemFileName+'" < "'+TempDir+ParamFile+'"');
    end;
    St.SaveToFile(TempDir+ParamBatchFile);
  finally
    St.Free;
  end;

  StartupInfo.cb:=SizeOf(StartupInfo);
  with StartupInfo do begin lpReserved:=nil; lpDesktop:=nil; lpTitle:=nil; dwFlags:=0; cbReserved2:=0; lpReserved2:=nil; end;
  CreateProcess(PChar(TempDir+ParamBatchFile),PChar('"'+TempDir+ParamBatchFile+'"'),nil,nil,False,0,nil,PChar(PrgDir),StartupInfo,ProcessInformation);

  WaitForSingleObject(ProcessInformation.hThread,INFINITE);
  CloseHandle(ProcessInformation.hThread);
  CloseHandle(ProcessInformation.hProcess);

  ExtDeleteFile(TempDir+ParamFile,ftTemp);
  ExtDeleteFile(TempDir+ParamBatchFile,ftTemp);

  result:=True;
end;

const BootSec : Array[0..511] of Byte = (
  $EB, $3C, $90, $46, $52, $44, $4F, $53, $34, $2E, $31, $00, $02, $01, $01, $00, $02, $E0, $00, $40, $0B, $F0, $09, $00,
  $12, $00, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $29, $0B, $60, $F5, $37, $46, $52, $45, $45, $44,
  $4F, $53, $32, $30, $30, $30, $46, $41, $54, $31, $32, $20, $20, $20, $FA, $FC, $31, $C0, $8E, $D8, $BD, $00, $7C, $B8,
  $E0, $1F, $8E, $C0, $89, $EE, $89, $EF, $B9, $00, $01, $F3, $A5, $EA, $5E, $7C, $E0, $1F, $00, $00, $60, $00, $8E, $D8,
  $8E, $D0, $8D, $66, $A0, $FB, $80, $7E, $24, $FF, $75, $03, $88, $56, $24, $C7, $46, $C0, $10, $00, $C7, $46, $C2, $01,
  $00, $8C, $5E, $C6, $C7, $46, $C4, $A0, $63, $8B, $76, $1C, $8B, $7E, $1E, $03, $76, $0E, $83, $D7, $00, $89, $76, $D2,
  $89, $7E, $D4, $8A, $46, $10, $98, $F7, $66, $16, $01, $C6, $11, $D7, $89, $76, $D6, $89, $7E, $D8, $8B, $5E, $0B, $B1,
  $05, $D3, $EB, $8B, $46, $11, $31, $D2, $F7, $F3, $50, $01, $C6, $83, $D7, $00, $89, $76, $DA, $89, $7E, $DC, $8B, $46,
  $D6, $8B, $56, $D8, $5F, $C4, $5E, $5A, $E8, $98, $00, $C4, $7E, $5A, $B9, $0B, $00, $BE, $F1, $7D, $57, $F3, $A6, $5F,
  $26, $8B, $45, $1A, $74, $0B, $83, $C7, $20, $26, $80, $3D, $00, $75, $E7, $72, $68, $50, $C4, $5E, $5A, $8B, $7E, $16,
  $8B, $46, $D2, $8B, $56, $D4, $E8, $6A, $00, $58, $1E, $07, $8E, $5E, $5C, $BF, $00, $20, $AB, $89, $C6, $01, $F6, $01,
  $C6, $D1, $EE, $AD, $73, $04, $B1, $04, $D3, $E8, $80, $E4, $0F, $3D, $F8, $0F, $72, $E8, $31, $C0, $AB, $0E, $1F, $C4,
  $5E, $5A, $BE, $00, $20, $AD, $09, $C0, $75, $05, $88, $D3, $FF, $6E, $5A, $48, $48, $8B, $7E, $0D, $81, $E7, $FF, $00,
  $F7, $E7, $03, $46, $DA, $13, $56, $DC, $E8, $20, $00, $EB, $E0, $5E, $AC, $56, $B4, $0E, $CD, $10, $3C, $2E, $75, $F5,
  $C3, $E8, $F1, $FF, $45, $72, $72, $6F, $72, $21, $2E, $30, $E4, $CD, $13, $CD, $16, $CD, $19, $56, $89, $46, $C8, $89,
  $56, $CA, $8C, $86, $9E, $E7, $89, $9E, $9C, $E7, $E8, $D0, $FF, $2E, $B4, $41, $BB, $AA, $55, $8A, $56, $24, $84, $D2,
  $74, $19, $CD, $13, $72, $15, $D1, $E9, $81, $DB, $54, $AA, $75, $0D, $8D, $76, $C0, $89, $5E, $CC, $89, $5E, $CE, $B4,
  $42, $EB, $26, $8B, $4E, $C8, $8B, $56, $CA, $8A, $46, $18, $F6, $66, $1A, $91, $F7, $F1, $92, $F6, $76, $18, $89, $D1,
  $88, $C6, $86, $E9, $D0, $C9, $D0, $C9, $08, $E1, $41, $C4, $5E, $C4, $B8, $01, $02, $8A, $56, $24, $CD, $13, $72, $89,
  $8B, $46, $0B, $57, $BE, $A0, $63, $C4, $BE, $9C, $E7, $89, $C1, $F3, $A4, $5F, $B1, $04, $D3, $E8, $01, $86, $9E, $E7,
  $83, $46, $C8, $01, $83, $56, $CA, $00, $4F, $75, $8B, $C4, $9E, $9C, $E7, $5E, $C3, $4B, $45, $52, $4E, $45, $4C, $20,
  $20, $53, $59, $53, $00, $00, $55, $AA
);

Procedure WriteBootSector(const ImageFile : String);
Var MSt : TMemoryStream;
begin
  MSt:=TMemoryStream.Create;
  try
    MSt.LoadFromFile(ImageFile);
    MSt.Position:=0;
    MSt.WriteBuffer(BootSec,512);
    MSt.SaveToFile(ImageFile);
  finally
    MSt.Free;
  end;
end;

Function GetKeyaboardLayout : String;
Var S : String;
begin
  result:=LanguageSetup.GameKeyboardLayoutDefault;
  If Pos('(',result)>0 then begin
    S:=Copy(result,Pos('(',result)+1,MaxInt);
    If Pos(')',S)>0 then begin S:=Trim(Copy(S,1,Pos(')',S)-1)); If S<>'' then result:=S; end;
  end;
end;

Function GetCodepage : String;
begin
  result:=LanguageSetup.GameKeyboardCodepageDefault;
end;

Function MakeFloppyBootable(const ImageFile : String; const MakeBootable, WithKeyboardDriver, WithMouseDriver : Boolean; const CopyFolder : String) : Boolean;
Var TempGameFileName, FreeDOSDir : String;
    DefaultGame, TempGame : TGame;
    St : TStringList;
begin
  result:=False;

  try WriteBootSector(ImageFile); except exit; end;

  FreeDOSDir:=Trim(PrgSetup.PathToFREEDOS);
  If FreeDOSDir<>'' then FreeDOSDir:=IncludeTrailingPathDelimiter(MakeAbsPath(FreeDOSDir,PrgSetup.BaseDir));
  If (FreeDOSDir='') or (not DirectoryExists(FreeDOSDir)) then begin
    MessageDlg(LanguageSetup.ProfileEditorNeedFreeDOS,mtError,[mbOK],0);
    exit;
  end;

  TempGameFileName:=TempDir+'TempDOSBox.prof';
  TempGame:=TGame.Create(TempGameFileName);
  try
    DefaultGame:=TGame.Create(PrgSetup);
    try TempGame.AssignFrom(DefaultGame); finally DefaultGame.Free; end;

    TempGame.Autoexec:='';
    TempGame.AutoexecOverridegamestart:=True;
    TempGame.AutoexecOverrideMount:=False;
    TempGame.AutoexecBootImage:='';

    TempGame.Mount0:=FreeDOSDir+';DRIVE;C;False;;105';
    TempGame.Mount1:=ImageFile+';FLOPPYIMAGE;A;;;';
    If CopyFolder<>'' then begin
      TempGame.NrOfMounts:=3;
      TempGame.Mount2:=CopyFolder+';DRIVE;D;False;;1000';
    end else begin
      TempGame.NrOfMounts:=2;
    end;

    St:=TStringList.Create;
    try
      If CopyFolder<>'' then begin
        St.Add('C:\4DOS.COM /C COPY D:\*.* A:\ /S');
      end;
      If MakeBootable then begin
        St.Add('copy C:\kernel.sys A:\');
        St.Add('copy C:\command.com A:\');
        St.Add('echo. > A:\config.sys');
        If WithKeyboardDriver then begin
          St.Add('echo keyb '+GetKeyaboardLayout+','+GetCodepage+' > A:\Autoexec.bat');
          St.Add('copy C:\keyb.exe A:\');
          St.Add('copy C:\keyboard.sys A:\');
        end;
        If WithMouseDriver then begin
          If WithKeyboardDriver
            then St.Add('echo ctmouse.exe >> A:\Autoexec.bat')
            else St.Add('echo ctmouse.exe > A:\Autoexec.bat');
          St.Add('copy C:\ctmouse.exe A:\');
        end;
      end;
      St.Add('exit');
      TempGame.Autoexec:=StringListToString(St);
    finally
      St.Free;
    end;

    TempGame.StoreAllValues;
    RunCommand(TempGame,'',True);
  finally
    TempGame.Free;
  end;
  result:=True;
end;

Function MakeHDBootable(const ImageFile : String; const WithKeyboardDriver, WithMouseDriver : Boolean) : Boolean;
Var TempFloppyImage : String;
    TempGameFileName, FreeDOSDir : String;
    DefaultGame, TempGame : TGame;
    St : TStringList;

begin
  result:=False;

  { Create bootable floppy image}

  TempFloppyImage:=ShortName(TempDir)+'TempFloppy.img';
  if not BuildStandardFloppyImage(TempFloppyImage) then exit;

  try WriteBootSector(TempFloppyImage); except exit; end;

  FreeDOSDir:=Trim(PrgSetup.PathToFREEDOS);
  If FreeDOSDir<>'' then FreeDOSDir:=IncludeTrailingPathDelimiter(MakeAbsPath(FreeDOSDir,PrgSetup.BaseDir));
  If (FreeDOSDir='') or (not DirectoryExists(FreeDOSDir)) then begin
    MessageDlg(LanguageSetup.ProfileEditorNeedFreeDOS,mtError,[mbOK],0);
    exit;
  end;

  TempGameFileName:=TempDir+'TempDOSBox.prof';
  TempGame:=TGame.Create(TempGameFileName);
  try
    DefaultGame:=TGame.Create(PrgSetup);
    try TempGame.AssignFrom(DefaultGame); finally DefaultGame.Free; end;

    TempGame.Autoexec:='';
    TempGame.AutoexecOverridegamestart:=True;
    TempGame.AutoexecOverrideMount:=False;
    TempGame.AutoexecBootImage:='';

    TempGame.NrOfMounts:=3;
    TempGame.Mount0:=FreeDOSDir+';DRIVE;C;False;;105';
    TempGame.Mount1:=TempFloppyImage+';FLOPPYIMAGE;A;;;';
    TempGame.Mount2:=ImageFile+';IMAGE;2;;;'+GetGeometryFromFile(ImageFile);

    St:=TStringList.Create;
    try
      St.Add('copy C:\kernel.sys A:\');
      St.Add('copy C:\command.com A:\');
      St.Add('echo. > A:\config.sys');
      If WithKeyboardDriver then begin
        St.Add('echo keyb '+GetKeyaboardLayout+','+GetCodepage+' > A:\Autoexec.bat');
        St.Add('copy C:\keyb.exe A:\');
        St.Add('copy C:\keyboard.sys A:\');
      end;
      If WithMouseDriver then begin
        If WithKeyboardDriver
          then St.Add('echo ctmouse.exe >> A:\Autoexec.bat')
          else St.Add('echo ctmouse.exe > A:\Autoexec.bat');
        St.Add('copy C:\ctmouse.exe A:\');
      end;
      St.Add('copy C:\sys.com A:\');
      If WithKeyboardDriver or WithMouseDriver
        then St.Add('echo Sys C: >> A:\Autoexec.bat')
        else St.Add('echo Sys C: > A:\Autoexec.bat');
      St.Add('echo copy *.* C: >> A:\Autoexec.bat');
      St.Add('echo cls >> A:\Autoexec.bat');
      St.Add('echo @echo Image creation finished. >> A:\Autoexec.bat');
      St.Add('echo @echo You can close this DOSBox window now. >> A:\Autoexec.bat');
      St.Add('boot "'+TempFloppyImage+'"');
      TempGame.Autoexec:=StringListToString(St);
    finally
      St.Free;
    end;

    TempGame.StoreAllValues;
    RunCommand(TempGame,'',True);
  finally
    TempGame.Free;
  end;
  result:=True;
end;

end.
