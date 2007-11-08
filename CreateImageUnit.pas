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
    procedure FormCreate(Sender: TObject);
    procedure FloppyFileButtonClick(Sender: TObject);
    procedure FloppyImageTypeComboBoxChange(Sender: TObject);
    procedure FloppyDataChange(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure HDSizeEditChange(Sender: TObject);
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

implementation

uses ShellAPI, VistaToolsUnit, LanguageSetupUnit, DiskImageToolsUnit,
     PrgSetupUnit, CommonTools, PrgConsts;

{$R *.dfm}

var FloppyCylinders : Array[0..7] of Integer = (40, 40, 40, 40, 80, 80, 80, 80);
    FloppyHeads     : Array[0..7] of Integer = ( 1,  1,  2,  2,  2,  2,  2,  2);
    FloppySPT       : Array[0..7] of Integer = ( 8,  9,  8,  9,  9, 15, 18, 36);

procedure TCreateImageForm.FormCreate(Sender: TObject);
Var I : Integer;
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);

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
  HDSizeEdit.EditLabel.Caption:=LanguageSetup.CreateImageFormHDImageSize;
  HDGeometryEdit.EditLabel.Caption:=LanguageSetup.CreateImageFormHDImageGeometry;
  HDImageFileEdit.EditLabel.Caption:=LanguageSetup.CreateImageFormFilename;
  HDFileButton.Hint:=LanguageSetup.ChooseFile;
  HDCompressedCheckBox.Caption:=LanguageSetup.CreateImageFormCompression;

  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;

  If FileExists(PrgDir+MakeDOSFilesystemFileName) then begin
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
  FloppyImageTypeComboBox.Items.Add('5,25" Single-Sided, Double Density (DD)');
  FloppyImageTypeComboBox.Items.Add('5,25" Single-Sided, Double Density (DD)');
  FloppyImageTypeComboBox.Items.Add('5,25" Double-Sided, Double Density (DD)');
  FloppyImageTypeComboBox.Items.Add('5,25" Double-Sided, Double Density (DD)');
  FloppyImageTypeComboBox.Items.Add('3,5" Double-Sided, Double Density (DD)');
  FloppyImageTypeComboBox.Items.Add('5,25" Double-Sided, High-Density (HD)');
  FloppyImageTypeComboBox.Items.Add('3,5" Double-Sided, High-Density (HD)');
  FloppyImageTypeComboBox.Items.Add('3,5" Double-Sided, Extended Density (ED)');
  FloppyImageTypeComboBox.Items.Add('Custom Format');

  JustChanging:=False;
  FloppyImageTypeComboBox.ItemIndex:=6;
  FloppyImageTypeComboBoxChange(Sender);
  HDSizeEditChange(Sender);

  OpenDialog.Title:=LanguageSetup.ProfileMountingFile;
  OpenDialog.Filter:=LanguageSetup.ProfileMountingFileFilterImgOnly;
end;

procedure TCreateImageForm.FloppyImageTypeComboBoxChange(Sender: TObject);
begin
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
Var I : Integer;
begin
  HDGeometryEdit.Text:='';
  try
    I:=StrToInt(HDSizeEdit.Text)*128 div 63;
    {512*63*16*X=Bytes => X=MBytes*128/63}
    HDGeometryEdit.Text:='512,63,16,'+IntToStr(I);
  except
    exit;
  end;
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
      DeleteFile(ImageFileName);
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
      DeleteFile(ImageFileName);
    end;
    CompressImage:=HDCompressedCheckBox.Checked;
  end;

  If FileExists(PrgDir+MakeDOSFilesystemFileName) then FATImageCreator else SimpleImageCreator;
end;

procedure TCreateImageForm.FATImageCreator;
const ParamFile='DFend-mkdosfs-InFile.txt';
      ParamBatchFile='DFend-mkdosfs.bat';
Var St : TStringList;
    I : Integer;
    StartupInfo : TStartupInfo;
    ProcessInformation : TProcessInformation;
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
      St.Add('1');
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
    St.SaveToFile(TempDir+ParamFile);
  finally
    St.Free;
  end;

  St:=TStringList.Create;
  try
    St.Add('"'+PrgDir+MakeDOSFilesystemFileName+'" < "'+TempDir+ParamFile+'"');
    St.SaveToFile(TempDir+ParamBatchFile);
  finally
    St.Free;
  end;

  StartupInfo.cb:=SizeOf(StartupInfo);
  with StartupInfo do begin lpReserved:=nil; lpDesktop:=nil; dwFlags:=0; cbReserved2:=0; lpReserved2:=nil; end;
  CreateProcess(PChar(TempDir+ParamBatchFile),PChar(TempDir+ParamBatchFile),nil,nil,False,0,nil,PChar(PrgDir),StartupInfo,ProcessInformation);

  WaitForSingleObject(ProcessInformation.hThread,INFINITE);
  CloseHandle(ProcessInformation.hThread);
  CloseHandle(ProcessInformation.hProcess);

  DeleteFile(TempDir+ParamFile);
  DeleteFile(TempDir+ParamBatchFile);
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

end.
