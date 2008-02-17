unit ProfileMountEditorFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ExtCtrls, ComCtrls, ImgList, Grids, Menus;

type
  TProfileMountEditorForm = class(TForm)
    OKButton: TBitBtn;
    CancelButton: TBitBtn;
    OpenDialog: TOpenDialog;
    PageControl: TPageControl;
    FolderSheet: TTabSheet;
    FolderEdit: TLabeledEdit;
    FolderButton: TSpeedButton;
    FolderDriveLetterComboBox: TComboBox;
    FolderDriveLetterLabel: TLabel;
    FolderFreeSpaceTrackBar: TTrackBar;
    FolderFreeSpaceLabel: TLabel;
    FloppySheet: TTabSheet;
    CDROMSheet: TTabSheet;
    FloppyImageSheet: TTabSheet;
    CDROMImageSheet: TTabSheet;
    ImageSheet: TTabSheet;
    CDROMEdit: TLabeledEdit;
    CDROMButton: TSpeedButton;
    CDROMLabelEdit: TLabeledEdit;
    CDROMDriveLetterComboBox: TComboBox;
    CDROMDriveLetterLabel: TLabel;
    FloppyEdit: TLabeledEdit;
    FloppyDriveLetterComboBox: TComboBox;
    FloppyButton: TSpeedButton;
    FloppyDriveLetterLabel: TLabel;
    CDROMIOCtrlCheckBox: TCheckBox;
    ImageList: TImageList;
    FloppyImageButton: TSpeedButton;
    FloppyImageDriveLetterComboBox: TComboBox;
    FloppyImageDriveLetterLabel: TLabel;
    CDROMImageDriveLetterLabel: TLabel;
    CDROMImageDriveLetterComboBox: TComboBox;
    CDROMImageButton: TSpeedButton;
    ImageEdit: TLabeledEdit;
    ImageButton: TSpeedButton;
    ImageDriveLetterComboBox: TComboBox;
    ImageDriveLetterLabel: TLabel;
    ImageGeometryEdit: TLabeledEdit;
    FloppyImageCreateButton: TSpeedButton;
    ImageCreateButton: TSpeedButton;
    DriveLetterInfoLabel1: TLabel;
    DriveLetterInfoLabel2: TLabel;
    CDROMImageLabel: TLabel;
    CDROMImageTab: TStringGrid;
    CDROMImageSwitchLabel: TLabel;
    CDROMImageAddButton: TSpeedButton;
    CDROMImageDelButton: TSpeedButton;
    FloppyImageEdit: TLabeledEdit;
    FloppyImageSheet2: TTabSheet;
    FloppyImageTab: TStringGrid;
    FloppyImageLabel: TLabel;
    FloppyImageButton2: TSpeedButton;
    FloppyImageAddButton: TSpeedButton;
    FloppyImageDelButton: TSpeedButton;
    FloppyImageDriveLetterComboBox2: TComboBox;
    FloppyImageDriveLetterLabel2: TLabel;
    DriveLetterInfoLabel3: TLabel;
    FloppyImageSwitchLabel: TLabel;
    ZipSheet: TTabSheet;
    ZipFolderEdit: TLabeledEdit;
    ZipFolderButton: TSpeedButton;
    ZipFolderDriveLetterComboBox: TComboBox;
    ZipFolderDriveLetterLabel: TLabel;
    ZipFolderFreeSpaceTrackbar: TTrackBar;
    ZipFolderFreeSpaceLabel: TLabel;
    ZipFileEdit: TLabeledEdit;
    ZipFileButton: TSpeedButton;
    ISOImageCreateButton: TSpeedButton;
    FloppyImageCreateButton2: TSpeedButton;
    FloppyPopupMenu: TPopupMenu;
    FloppyPopupCreateImage: TMenuItem;
    FloppyPopupReadImage: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FolderButtonClick(Sender: TObject);
    procedure FolderFreeSpaceTrackBarChange(Sender: TObject);
    procedure ZipFolderFreeSpaceTrackBarChange(Sender: TObject);
    procedure FloppyPopupWork(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Data : String;
  end;

var
  ProfileMountEditorForm: TProfileMountEditorForm;

Function ShowProfileMountEditorDialog(const AOwner : TComponent; var AData : String) : Boolean;

implementation

uses LanguageSetupUnit, VistaToolsUnit, CommonTools, PrgSetupUnit,
     CreateImageUnit, CreateISOImageFormUnit;

{$R *.dfm}

procedure TProfileMountEditorForm.FormCreate(Sender: TObject);
Var C : Char;
begin
  DoubleBuffered:=True;
  SetVistaFonts(self);

  FloppyImageSheet.TabVisible:=not PrgSetup.AllowMultiFloppyImagesMount;
  FloppyImageSheet2.TabVisible:=PrgSetup.AllowMultiFloppyImagesMount;
  ZipSheet.TabVisible:=PrgSetup.AllowPhysFSUsage;

  Caption:=LanguageSetup.ProfileMounting;

  FolderSheet.Caption:=LanguageSetup.ProfileMountingFolderSheet;
  FloppySheet.Caption:=LanguageSetup.ProfileMountingFloppySheet;
  CDROMSheet.Caption:=LanguageSetup.ProfileMountingCDROMSheet;
  FloppyImageSheet.Caption:=LanguageSetup.ProfileMountingFloppyImageSheet;
  FloppyImageSheet2.Caption:=LanguageSetup.ProfileMountingFloppyImageSheet;
  CDROMImageSheet.Caption:=LanguageSetup.ProfileMountingCDROMImageSheet;
  ImageSheet.Caption:=LanguageSetup.ProfileMountingImageSheet;
  ZipSheet.Caption:=LanguageSetup.ProfileMountingPhysFSSheet;

  FolderEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingFolder;
  FolderDriveLetterLabel.Caption:=LanguageSetup.ProfileMountingLetter;
  FloppyEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingFolder;
  FloppyDriveLetterLabel.Caption:=LanguageSetup.ProfileMountingLetter;
  CDROMEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingFolder;
  CDROMLabelEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingLabel;
  CDROMIOCtrlCheckBox.Caption:=LanguageSetup.ProfileMountingIOControl;
  CDROMDriveLetterLabel.Caption:=LanguageSetup.ProfileMountingLetter;
  FloppyImageEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingFile;
  FloppyImageDriveLetterLabel.Caption:=LanguageSetup.ProfileMountingLetter;
  DriveLetterInfoLabel1.Caption:=LanguageSetup.ProfileMountingLetterInfo;
  CDROMImageLabel.Caption:=LanguageSetup.ProfileMountingFile;
  CDROMImageAddButton.Hint:=LanguageSetup.ProfileMountingAddImage;
  CDROMImageDelButton.Hint:=LanguageSetup.ProfileMountingDelImage;
  CDROMImageSwitchLabel.Caption:=LanguageSetup.ProfileMountingSwitchImage;
  CDROMImageDriveLetterLabel.Caption:=LanguageSetup.ProfileMountingLetter;
  ImageEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingFile;
  ImageGeometryEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingGeometry;
  ImageDriveLetterLabel.Caption:=LanguageSetup.ProfileMountingLetter;
  DriveLetterInfoLabel2.Caption:=LanguageSetup.ProfileMountingLetterInfo;
  FloppyImageLabel.Caption:=LanguageSetup.ProfileMountingFile;
  FloppyImageAddButton.Hint:=LanguageSetup.ProfileMountingAddImage;
  FloppyImageDelButton.Hint:=LanguageSetup.ProfileMountingDelImage;
  FloppyImageSwitchLabel.Caption:=LanguageSetup.ProfileMountingSwitchImage;
  FloppyImageDriveLetterLabel2.Caption:=LanguageSetup.ProfileMountingLetter;
  DriveLetterInfoLabel3.Caption:=LanguageSetup.ProfileMountingLetterInfo;
  ZipFolderEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingFolder;
  ZipFolderDriveLetterLabel.Caption:=LanguageSetup.ProfileMountingLetter;
  ZipFileEdit.EditLabel.Caption:=LanguageSetup.ProfileMountingZipFile;

  FloppyPopupCreateImage.Caption:=LanguageSetup.ProfileMountingFloppyImageCreate;
  FloppyPopupReadImage.Caption:=LanguageSetup.ProfileMountingFloppyImageRead;

  OKButton.Caption:=LanguageSetup.OK;
  CancelButton.Caption:=LanguageSetup.Cancel;
  FolderButton.Hint:=LanguageSetup.ChooseFolder;
  FloppyButton.Hint:=LanguageSetup.ChooseFolder;
  CDROMButton.Hint:=LanguageSetup.ChooseFolder;
  FloppyImageButton.Hint:=LanguageSetup.ChooseFile;
  FloppyImageCreateButton.Hint:=LanguageSetup.ProfileMountingCreateImage;
  FloppyImageButton2.Hint:=LanguageSetup.ChooseFile;
  FloppyImageCreateButton2.Hint:=LanguageSetup.ProfileMountingCreateImage;
  CDROMImageButton.Hint:=LanguageSetup.ChooseFile;
  ISOImageCreateButton.Hint:=LanguageSetup.ProfileMountingCreateImage;
  ImageButton.Hint:=LanguageSetup.ChooseFile;
  ImageCreateButton.Hint:=LanguageSetup.ProfileMountingCreateImage;
  ZipFolderButton.Hint:=LanguageSetup.ChooseFolder;
  ZipFileButton.Hint:=LanguageSetup.ChooseFile;

  FolderDriveLetterComboBox.Items.BeginUpdate;
  try
    FolderDriveLetterComboBox.Items.Capacity:=30;
    For C:='A' to 'Y' do FolderDriveLetterComboBox.Items.Add(C);
    FolderDriveLetterComboBox.ItemIndex:=2;
  finally
    FolderDriveLetterComboBox.Items.EndUpdate;
  end;
  FloppyDriveLetterComboBox.Items.BeginUpdate;
  try
    FloppyDriveLetterComboBox.Items.Capacity:=30;
    FloppyDriveLetterComboBox.Items.AddStrings(FolderDriveLetterComboBox.Items);
    FloppyDriveLetterComboBox.ItemIndex:=0;
  finally
    FloppyDriveLetterComboBox.Items.EndUpdate;
  end;
  CDROMDriveLetterComboBox.Items.BeginUpdate;
  try
    CDROMDriveLetterComboBox.Items.Capacity:=30;
    CDROMDriveLetterComboBox.Items.AddStrings(FolderDriveLetterComboBox.Items);
    CDROMDriveLetterComboBox.ItemIndex:=3;
  finally
    CDROMDriveLetterComboBox.Items.EndUpdate;
  end;
  FloppyImageDriveLetterComboBox.Items.BeginUpdate;
  try
    FloppyImageDriveLetterComboBox.Items.Capacity:=30;
    FloppyImageDriveLetterComboBox.Items.AddStrings(FolderDriveLetterComboBox.Items);
    FloppyImageDriveLetterComboBox.Items.Add('0');
    FloppyImageDriveLetterComboBox.Items.Add('1');
    FloppyImageDriveLetterComboBox.ItemIndex:=0;
  finally
    FloppyImageDriveLetterComboBox.Items.EndUpdate;
  end;
  CDROMImageDriveLetterComboBox.Items.BeginUpdate;
  try
    CDROMImageDriveLetterComboBox.Items.Capacity:=30;
    CDROMImageDriveLetterComboBox.Items.AddStrings(FolderDriveLetterComboBox.Items);
    CDROMImageDriveLetterComboBox.ItemIndex:=3;
  finally
    CDROMImageDriveLetterComboBox.Items.EndUpdate;
  end;
  ImageDriveLetterComboBox.Items.BeginUpdate;
  try
    ImageDriveLetterComboBox.Items.Capacity:=30;
    ImageDriveLetterComboBox.Items.AddStrings(FolderDriveLetterComboBox.Items);
    ImageDriveLetterComboBox.Items.Add('2');
    ImageDriveLetterComboBox.Items.Add('3');
    ImageDriveLetterComboBox.ItemIndex:=3;
  finally
    ImageDriveLetterComboBox.Items.EndUpdate;
  end;
  FloppyImageDriveLetterComboBox2.Items.BeginUpdate;
  try
    FloppyImageDriveLetterComboBox2.Items.Capacity:=30;
    FloppyImageDriveLetterComboBox2.Items.AddStrings(FolderDriveLetterComboBox.Items);
    FloppyImageDriveLetterComboBox2.Items.Add('0');
    FloppyImageDriveLetterComboBox2.Items.Add('1');
    FloppyImageDriveLetterComboBox2.ItemIndex:=0;
  finally
    FloppyImageDriveLetterComboBox2.Items.EndUpdate;
  end;
  ZipFolderDriveLetterComboBox.Items.BeginUpdate;
  try
    ZipFolderDriveLetterComboBox.Items.Capacity:=30;
    ZipFolderDriveLetterComboBox.Items.AddStrings(FolderDriveLetterComboBox.Items);
    ZipFolderDriveLetterComboBox.ItemIndex:=2;
  finally
    ZipFolderDriveLetterComboBox.Items.EndUpdate;
  end;

  ImageGeometryEdit.Text:='512,63,16,142';
end;

procedure TProfileMountEditorForm.FormShow(Sender: TObject);
Var St,St2 : TStringList;
    S,T : String;
    I : Integer;
begin
  CDROMImageTab.ColWidths[0]:=CDROMImageTab.ClientWidth-25;
  FloppyImageTab.ColWidths[0]:=FloppyImageTab.ClientWidth-25;

  {general: RealFolder;Type;Letter;IO;Label;FreeSpace}

  St:=ValueToList(Data);
  try
    If St.Count<2 then exit;
    S:=Trim(ExtUpperCase(St[1]));

    If S='DRIVE' then begin
      {RealFolder;DRIVE;Letter;False;;FreeSpace}
      PageControl.ActivePageIndex:=0;
      FolderEdit.Text:=St[0];
      If St.Count>=3 then begin
        I:=FolderDriveLetterComboBox.Items.IndexOf(Trim(UpperCase(St[2]))); If I<0 then I:=2;
        FolderDriveLetterComboBox.ItemIndex:=I;
      end;
      If St.Count>=6 then begin
        try I:=StrToInt(St[5]); except I:=0; end;
        If (I>=10) and (I<=4000) then FolderFreeSpaceTrackBar.Position:=I;
      end;
    end;

    If S='FLOPPY' then begin
      {RealFolder;FLOPPY;Letter;False;;}
      PageControl.ActivePageIndex:=1;
      FloppyEdit.Text:=St[0];
      If St.Count>=3 then begin
        I:=FloppyDriveLetterComboBox.Items.IndexOf(Trim(UpperCase(St[2]))); If I<0 then I:=2;
        FloppyDriveLetterComboBox.ItemIndex:=I;
      end;
    end;

    If S='CDROM' then begin
      {RealFolder;CDROM;Letter;IO;Label;}
      PageControl.ActivePageIndex:=2;
      CDROMEdit.Text:=St[0];
      If St.Count>=3 then begin
        I:=CDROMDriveLetterComboBox.Items.IndexOf(Trim(UpperCase(St[2]))); If I<0 then I:=2;
        CDROMDriveLetterComboBox.ItemIndex:=I;
      end;
      If St.Count>=4 then begin
        CDROMIOCtrlCheckBox.Checked:=(Trim(ExtUpperCase(St[3]))='TRUE');
      end;
      If St.Count>=5 then begin
        CDROMLabelEdit.Text:=St[4];
      end;
    end;

    If S='FLOPPYIMAGE' then begin
      {ImageFile;FLOPPYIMAGE;Letter;;;}
      If FloppyImageSheet.TabVisible then begin
        PageControl.ActivePageIndex:=3;
        FloppyImageEdit.Text:=St[0];
        If St.Count>=3 then begin
          I:=FloppyImageDriveLetterComboBox.Items.IndexOf(Trim(UpperCase(St[2]))); If I<0 then I:=2;
          FloppyImageDriveLetterComboBox.ItemIndex:=I;
        end;
      end else begin
        PageControl.ActivePageIndex:=4;
        St2:=TStringList.Create;
        try
          S:=Trim(St[0]);
          I:=Pos('$',S);
          While I>0 do begin St2.Add(Trim(Copy(S,1,I-1))); S:=Trim(Copy(S,I+1,MaxInt)); I:=Pos('$',S); end;
          St2.Add(S);
          FloppyImageTab.RowCount:=St2.Count;
          For I:=0 to St2.Count-1 do FloppyImageTab.Cells[0,I]:=St2[I];
        finally
          St2.Free;
        end;
        If St.Count>=3 then begin
          I:=FloppyImageDriveLetterComboBox.Items.IndexOf(Trim(UpperCase(St[2]))); If I<0 then I:=2;
          FloppyImageDriveLetterComboBox.ItemIndex:=I;
        end;
      end;
    end;

    If S='CDROMIMAGE' then begin
      {ImageFile;CDROMIMAGE;Letter;;;}
      PageControl.ActivePageIndex:=5;
      St2:=TStringList.Create;
      try
        S:=Trim(St[0]);
        I:=Pos('$',S);
        While I>0 do begin St2.Add(Trim(Copy(S,1,I-1))); S:=Trim(Copy(S,I+1,MaxInt)); I:=Pos('$',S); end;
        St2.Add(S);
        CDROMImageTab.RowCount:=St2.Count;
        For I:=0 to St2.Count-1 do CDROMImageTab.Cells[0,I]:=St2[I];
      finally
        St2.Free;
      end;
      If St.Count>=3 then begin
        I:=CDROMImageDriveLetterComboBox.Items.IndexOf(Trim(UpperCase(St[2]))); If I<0 then I:=2;
        CDROMImageDriveLetterComboBox.ItemIndex:=I;
      end;
    end;

    If S='IMAGE' then begin
      {ImageFile;IMAGE;LetterOR23;;;geometry}
      PageControl.ActivePageIndex:=6;
      ImageEdit.Text:=St[0];
      If St.Count>=3 then begin
        I:=ImageDriveLetterComboBox.Items.IndexOf(Trim(UpperCase(St[2]))); If I<0 then I:=2;
        ImageDriveLetterComboBox.ItemIndex:=I;
      end;
      If St.Count>=6 then begin
        ImageGeometryEdit.Text:=St[5];
      end;
    end;

    If S='PHYSFS' then begin
      {RealFolder$ZipFile;PHYSFS;Letter;False;;FreeSpace}
      PageControl.ActivePageIndex:=7;
      S:=Trim(St[0]); I:=Pos('$',S); If I=0 then T:='' else begin T:=Trim(Copy(S,I+1,MaxInt)); S:=Trim(Copy(S,1,I-1)); end;
      ZipFolderEdit.Text:=S; ZipFileEdit.Text:=T;
      If St.Count>=3 then begin
        I:=ZipFolderDriveLetterComboBox.Items.IndexOf(Trim(UpperCase(St[2]))); If I<0 then I:=2;
        ZipFolderDriveLetterComboBox.ItemIndex:=I;
      end;
      If St.Count>=6 then begin
        try I:=StrToInt(St[5]); except I:=0; end;
        If (I>=10) and (I<=4000) then ZipFolderFreeSpaceTrackBar.Position:=I;
      end;
    end;

  finally
    St.Free;
  end;

  FolderFreeSpaceTrackBarChange(Sender);
  ZipFolderFreeSpaceTrackBarChange(Sender);
end;

procedure TProfileMountEditorForm.FolderFreeSpaceTrackBarChange(Sender: TObject);
begin
  FolderFreeSpaceLabel.Caption:=Format(LanguageSetup.ProfileMountingFreeSpace,[FolderFreeSpaceTrackbar.Position]);
end;

procedure TProfileMountEditorForm.ZipFolderFreeSpaceTrackBarChange(Sender: TObject);
begin
  ZipFolderFreeSpaceLabel.Caption:=Format(LanguageSetup.ProfileMountingFreeSpace,[ZipFolderFreeSpaceTrackbar.Position]);
end;

procedure TProfileMountEditorForm.OKButtonClick(Sender: TObject);
Var S : String;
    I : Integer;
begin
  Case PageControl.ActivePageIndex of
    0 : begin
          {RealFolder;DRIVE;Letter;False;;FreeSpace}
          Data:=FolderEdit.Text+';Drive;'+FolderDriveLetterComboBox.Text+';False;;';
          If FolderFreeSpaceTrackBar.Position<>105 then Data:=Data+IntToStr(FolderFreeSpaceTrackBar.Position);
        end;
    1 : begin
          {RealFolder;FLOPPY;Letter;False;;}
          Data:=FloppyEdit.Text+';Floppy;'+FloppyDriveLetterComboBox.Text+';False;;';
        end;
    2 : begin
          {RealFolder;CDROM;Letter;IO;Label;}
          If CDROMIOCtrlCheckBox.Checked then S:='true' else S:='false';
          Data:=CDROMEdit.Text+';CDROM;'+CDROMDriveLetterComboBox.Text+';'+S+';'+CDROMLabelEdit.Text+';';
        end;
    3 : begin
          {ImageFile;FLOPPYIMAGE;Letter;;;}
          Data:=FloppyImageEdit.Text+';FloppyImage;'+FloppyImageDriveLetterComboBox.Text+';;;';
        end;
    4 : begin
          {ImageFile;FLOPPYIMAGE;Letter;;;}
          S:=FloppyImageTab.Cells[0,0]; For I:=1 to FloppyImageTab.RowCount-1 do S:=S+'$'+FloppyImageTab.Cells[0,I];
          Data:=S+';FloppyImage;'+FloppyImageDriveLetterComboBox.Text+';;;';
        end;
    5 : begin
          {ImageFile;CDROMIMAGE;Letter;;;}
          S:=CDROMImageTab.Cells[0,0]; For I:=1 to CDROMImageTab.RowCount-1 do S:=S+'$'+CDROMImageTab.Cells[0,I];
          Data:=S+';CDROMImage;'+CDROMImageDriveLetterComboBox.Text+';;;';
        end;
    6 : begin
          {ImageFile;IMAGE;LetterOR23;;;geometry}
          Data:=ImageEdit.Text+';Image;'+ImageDriveLetterComboBox.Text+';;;'+ImageGeometryEdit.Text;
        end;
    7 : begin
          {RealFolder$ZipFile;PHYSFS;Letter;False;;FreeSpace}
          Data:=ZipFolderEdit.Text+'$'+ZipFileEdit.Text+';PhysFS;'+ZipFolderDriveLetterComboBox.Text+';False;;';
          If ZipFolderFreeSpaceTrackBar.Position<>105 then Data:=Data+';'+IntToStr(ZipFolderFreeSpaceTrackBar.Position);
        end;
  end;
end;

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

procedure TProfileMountEditorForm.FolderButtonClick(Sender: TObject);
Var S : String;
    I : Integer;
    P : TPoint;
begin
  Case (Sender as TComponent).Tag of
    0 : begin
          {Folder as HD-Drive}
          S:=MakeAbsPath(FolderEdit.Text,PrgSetup.BaseDir);
          if not SelectDirectory(Handle,LanguageSetup.ProfileMountingFolder,S) then exit;
          FolderEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir);
        end;
    1 : begin
          {Folder as Floppy-Drive}
          S:=MakeAbsPath(FloppyEdit.Text,PrgSetup.BaseDir);
          if not SelectDirectory(Handle,LanguageSetup.ProfileMountingFolder,S) then exit;
          FloppyEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir);
        end;
    2 : begin
          {Real CD-Drive}
          S:=MakeAbsPath(CDROMEdit.Text,PrgSetup.BaseDir);
          if not SelectDirectory(Handle,LanguageSetup.ProfileMountingFolder,S) then exit;
          CDROMEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir);
        end;
    3 : begin
          {Floppy Image}
          S:=MakeAbsPath(FloppyImageEdit.Text,PrgSetup.BaseDir);
          OpenDialog.DefaultExt:='img';
          OpenDialog.InitialDir:=ExtractFilePath(S);
          OpenDialog.Title:=LanguageSetup.ProfileMountingFile;
          OpenDialog.Filter:=LanguageSetup.ProfileMountingFileFilter;
          if not OpenDialog.Execute then exit;
          FloppyImageEdit.Text:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
        end;
    4 : begin
          {CDROM Image}
          If CDROMImageTab.Row<0 then begin
            MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
            exit;
          end;
          S:=MakeAbsPath(CDROMImageTab.Cells[0,CDROMImageTab.Row],PrgSetup.BaseDir);
          OpenDialog.DefaultExt:='iso';
          OpenDialog.InitialDir:=ExtractFilePath(S);
          OpenDialog.Title:=LanguageSetup.ProfileMountingFile;
          OpenDialog.Filter:=LanguageSetup.ProfileMountingFileFilter;
          if not OpenDialog.Execute then exit;
          CDROMImageTab.Cells[0,CDROMImageTab.Row]:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
        end;
    5 : begin
          {HD Image}
          S:=MakeAbsPath(ImageEdit.Text,PrgSetup.BaseDir);
          OpenDialog.DefaultExt:='img';
          OpenDialog.InitialDir:=ExtractFilePath(S);
          OpenDialog.Title:=LanguageSetup.ProfileMountingFile;
          OpenDialog.Filter:=LanguageSetup.ProfileMountingFileFilter;
          if not OpenDialog.Execute then exit;
          ImageEdit.Text:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
          ImageGeometryEdit.Text:=GetGeometryFromFile(OpenDialog.FileName);
        end;
    6 : begin
          {Create floppy Image}
          P:=FloppyImageSheet.ClientToScreen(Point(FloppyImageCreateButton.Left,FloppyImageCreateButton.Top));
          FloppyPopupMenu.Popup(P.X+5,P.Y+5);
        end;
    7 : begin
          {Create HD Image}
          S:=ShowCreateImageFileDialog(self,False,True);
          If S='' then exit;
          ImageEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir);
          ImageGeometryEdit.Text:=GetGeometryFromFile(S);
        end;
    8 : begin
          {Add CDROM Image}
          CDROMImageTab.RowCount:=CDROMImageTab.RowCount+1;
          CDROMImageTab.Row:=CDROMImageTab.RowCount-1;
        end;
    9 : begin
          {Remove CDROM Image}
          If CDROMImageTab.Row<0 then begin
            MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
            exit;
          end;
          If CDROMImageTab.RowCount=1 then begin
            CDROMImageTab.Cells[0,0]:='';
          end else begin
            For I:=CDROMImageTab.Row+1 to CDROMImageTab.RowCount-1 do CDROMImageTab.Cells[0,I-1]:=CDROMImageTab.Cells[0,I];
            CDROMImageTab.RowCount:=CDROMImageTab.RowCount-1;
          end;
        end;
   10 : begin
          {Floppy Image 2}
          If FloppyImageTab.Row<0 then begin
            MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
            exit;
          end;
          S:=MakeAbsPath(FloppyImageTab.Cells[0,FloppyImageTab.Row],PrgSetup.BaseDir);
          OpenDialog.DefaultExt:='iso';
          OpenDialog.InitialDir:=ExtractFilePath(S);
          OpenDialog.Title:=LanguageSetup.ProfileMountingFile;
          OpenDialog.Filter:=LanguageSetup.ProfileMountingFileFilter;
          if not OpenDialog.Execute then exit;
          FloppyImageTab.Cells[0,FloppyImageTab.Row]:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
        end;
   11 : begin
          {Add Floppy Image}
          FloppyImageTab.RowCount:=FloppyImageTab.RowCount+1;
          FloppyImageTab.Row:=FloppyImageTab.RowCount-1;
        end;
   12 : begin
          {Remove Floppy Image}
          If FloppyImageTab.Row<0 then begin
            MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
            exit;
          end;
          If FloppyImageTab.RowCount=1 then begin
            FloppyImageTab.Cells[0,0]:='';
          end else begin
            For I:=FloppyImageTab.Row+1 to FloppyImageTab.RowCount-1 do FloppyImageTab.Cells[0,I-1]:=FloppyImageTab.Cells[0,I];
            FloppyImageTab.RowCount:=FloppyImageTab.RowCount-1;
          end;
        end;
   13 : begin
          {Folder as (zip) HD-Drive}
          S:=MakeAbsPath(ZipFolderEdit.Text,PrgSetup.BaseDir);
          if not SelectDirectory(Handle,LanguageSetup.ProfileMountingFolder,S) then exit;
          ZipFolderEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir);
        end;
   14 : begin
          {Zip-File as HD-Drive}
          S:=MakeAbsPath(ZipFileEdit.Text,PrgSetup.BaseDir);
          OpenDialog.DefaultExt:='zip';
          OpenDialog.InitialDir:=ExtractFilePath(S);
          OpenDialog.Title:=LanguageSetup.ProfileMountingZipFile;
          OpenDialog.Filter:=LanguageSetup.ProfileMountingZipFileFilter;
          if not OpenDialog.Execute then exit;
          ZipFileEdit.Text:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
        end;
   15 : begin
          {Create ISO Image}
          If CDROMImageTab.Row<0 then begin
            MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
            exit;
          end;
          if not ShowCreateISOImageDialog(self,S,False) then exit;
          If S='' then exit;
          CDROMImageTab.Cells[0,CDROMImageTab.Row]:=MakeRelPath(S,PrgSetup.BaseDir);
       end;
   16 : begin
          {Create floppy Image 2}
          If FloppyImageTab.Row<0 then begin
            MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
            exit;
          end;
          P:=FloppyImageSheet2.ClientToScreen(Point(FloppyImageCreateButton2.Left,FloppyImageCreateButton2.Top));
          FloppyPopupMenu.Popup(P.X+5,P.Y+5);
       end;
  end;
end;

procedure TProfileMountEditorForm.FloppyPopupWork(Sender: TObject);
Var S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : If PageControl.ActivePageIndex=FloppyImageSheet.PageIndex then begin
          S:=ShowCreateImageFileDialog(self,True,False);
          If S='' then exit;
          FloppyImageEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir);;
        end else begin
          If FloppyImageTab.Row<0 then begin
            MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
            exit;
          end;
          S:=ShowCreateImageFileDialog(self,True,False);
          If S='' then exit;
          FloppyImageTab.Cells[0,FloppyImageTab.Row]:=MakeRelPath(S,PrgSetup.BaseDir);
        end;
    1 : If PageControl.ActivePageIndex=FloppyImageSheet.PageIndex then begin
          if not ShowCreateISOImageDialog(self,S,True) then exit;
          If S='' then exit;
          FloppyImageEdit.Text:=MakeRelPath(S,PrgSetup.BaseDir);
        end else begin
          If FloppyImageTab.Row<0 then begin
            MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
            exit;
          end;
          if not ShowCreateISOImageDialog(self,S,True) then exit;
          If S='' then exit;
          FloppyImageTab.Cells[0,FloppyImageTab.Row]:=MakeRelPath(S,PrgSetup.BaseDir);
        end;
  end;
end;

{ global }

Function ShowProfileMountEditorDialog(const AOwner : TComponent; var AData : String) : Boolean;
begin
  ProfileMountEditorForm:=TProfileMountEditorForm.Create(AOwner);
  try
    ProfileMountEditorForm.Data:=AData;
    result:=(ProfileMountEditorForm.ShowModal=mrOK);
    if result then AData:=ProfileMountEditorForm.Data;
  finally
    ProfileMountEditorForm.Free;
  end;
end;

end.
