unit SetupFrameZipPrgsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, SetupFormUnit, StdCtrls, ExtCtrls, Buttons;

Type TPacker=record
  Name, FileName, Extensions : String;
  ExtractFile, CreateFile, UpdateFile : String;
end;

type
  TSetupFrameZipPrgs = class(TFrame, ISetupFrame)
    DeleteButton: TSpeedButton;
    UpButton: TSpeedButton;
    DownButton: TSpeedButton;
    AddButton: TSpeedButton;
    SelectComboBox: TComboBox;
    SelectLabel: TLabel;
    FilenameEdit: TLabeledEdit;
    FilenameButton: TSpeedButton;
    PrgOpenDialog: TOpenDialog;
    ExtensionsEdit: TLabeledEdit;
    CommandExtractEdit: TLabeledEdit;
    CommandCreateEdit: TLabeledEdit;
    CommandAddEdit: TLabeledEdit;
    InfoLabel: TLabel;
    AutoSetupButton: TBitBtn;
    procedure SelectComboBoxChange(Sender: TObject);
    procedure FilenameButtonClick(Sender: TObject);
    procedure FilenameEditChange(Sender: TObject);
    procedure ButtonWork(Sender: TObject);
    procedure AutoSetupButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
    Packers : Array of TPacker;
    LastIndex : Integer;
    JustChanging : Boolean;
  public
    { Public-Deklarationen }
    Function GetName : String;
    Procedure InitGUIAndLoadSetup(var InitData : TInitData);
    Procedure BeforeChangeLanguage;
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvencedMode : Boolean);
    procedure HideFrame;
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses ShlObj, Math, LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit, HelpConsts,
     CommonTools, ZipInfoFormUnit, IconLoaderUnit;

{$R *.dfm}

Type TPackerDefaultValue=record
  Name, Extensions, CommandExtract, CommandCreate, CommandUpdate  : String;
end;

const PackerDefaultValuesCount=3;

Var PackerDefaultValues : Array[0..PackerDefaultValuesCount-1] of TPackerDefaultValue =(
  (Name: '7z'; Extensions: 'GZIP;BZIP2;TAR'; CommandExtract: 'e "%1" -o"%2" -y'; CommandCreate: 'a "%1" "%2*.*" -r'; CommandUpdate: 'u "%1" "%2*.*" -r'),
  (Name: 'rar'; Extensions: 'RAR'; CommandExtract: 'x "%1" "%2" -y -c-'; CommandCreate: 'a -y -r0 -ep1 "%1" "%2*.*"'; CommandUpdate: 'u -y -r0 -ep1 "%1" "%2*.*"'),
  (Name: 'winrar'; Extensions: 'RAR'; CommandExtract: 'x "%1" "%2" -y -c-'; CommandCreate: 'a -y -r0 -ep1 "%1" "%2*.*"'; CommandUpdate: 'u -y -r0 -ep1 "%1" "%2*.*"')
);

{ TSetupFrameZipPrgs }

function TSetupFrameZipPrgs.GetName: String;
begin
  result:=LanguageSetup.SetupFormExternalPackers;
end;

procedure TSetupFrameZipPrgs.InitGUIAndLoadSetup(var InitData: TInitData);
Var I : Integer;
begin
  NoFlicker(SelectComboBox);
  NoFlicker(FilenameEdit);
  NoFlicker(ExtensionsEdit);
  NoFlicker(CommandExtractEdit);
  NoFlicker(CommandCreateEdit);
  NoFlicker(CommandAddEdit);
  NoFlicker(AutoSetupButton);

  SetLength(Packers,PrgSetup.PackerSettingsCount);
  For I:=0 to length(Packers)-1 do begin
    Packers[I].Name:=ChangeFileExt(ExtractFileName(PrgSetup.PackerSettings[I].ZipFileName),'');
    Packers[I].FileName:=PrgSetup.PackerSettings[I].ZipFileName;
    Packers[I].Extensions:=PrgSetup.PackerSettings[I].FileExtensions;
    Packers[I].ExtractFile:=PrgSetup.PackerSettings[I].ExtractFile;
    Packers[I].CreateFile:=PrgSetup.PackerSettings[I].CreateFile;
    Packers[I].UpdateFile:=PrgSetup.PackerSettings[I].UpdateFile;
  end;

  UserIconLoader.DialogImage(DI_Add,AddButton);
  UserIconLoader.DialogImage(DI_Delete,DeleteButton);
  UserIconLoader.DialogImage(DI_Up,UpButton);
  UserIconLoader.DialogImage(DI_Down,DownButton);
  UserIconLoader.DialogImage(DI_SelectFile,FilenameButton);
  UserIconLoader.DialogImage(DI_ResetDefault,AutoSetupButton);

  LastIndex:=-1;
  JustChanging:=False;
  For I:=0 to length(Packers)-1 do SelectComboBox.Items.Add(Packers[I].Name);
end;

procedure TSetupFrameZipPrgs.BeforeChangeLanguage;
begin
end;

procedure TSetupFrameZipPrgs.LoadLanguage;
begin
  SelectLabel.Caption:=LanguageSetup.SetupFormExternalPackersSelect;
  FilenameEdit.EditLabel.Caption:=LanguageSetup.SetupFormExternalPackersFileName;
  ExtensionsEdit.EditLabel.Caption:=LanguageSetup.SetupFormExternalPackersExtensions;
  CommandExtractEdit.EditLabel.Caption:=LanguageSetup.SetupFormExternalPackersCommandExtract;
  CommandCreateEdit.EditLabel.Caption:=LanguageSetup.SetupFormExternalPackersCommandCreate;
  CommandAddEdit.EditLabel.Caption:=LanguageSetup.SetupFormExternalPackersCommandAdd;
  InfoLabel.Caption:=LanguageSetup.SetupFormExternalPackersInfo;

  HelpContext:=ID_FileOptionsZipPackers;
end;

procedure TSetupFrameZipPrgs.ButtonWork(Sender: TObject);
Var I,J : Integer;
    P : TPacker;
begin
  Case (Sender as TComponent).Tag of
    0 : begin {Add}
          SelectComboBoxChange(Sender);
          I:=length(Packers); SetLength(Packers,I+1);
          with Packers[I] do begin Name:='-'; FileName:=''; Extensions:=''; ExtractFile:=''; CreateFile:=''; UpdateFile:=''; end;
          SelectComboBox.Items.Add('-');
          SelectComboBox.ItemIndex:=SelectComboBox.Items.Count-1;
          LastIndex:=-1;
          SelectComboBoxChange(Sender);
        end;
    1 : begin {Delete}
          I:=SelectComboBox.ItemIndex;
          If I<0 then exit;
          SelectComboBox.ItemIndex:=-1;
          LastIndex:=-1;
          SelectComboBoxChange(Sender);

          For J:=I+1 to length(Packers)-1 do Packers[J-1]:=Packers[J];
          SetLength(Packers,length(Packers)-1);
          SelectComboBox.Items.Delete(I);

          I:=max(I-1,0);
          If SelectComboBox.Items.Count>0 then SelectComboBox.ItemIndex:=I;
          SelectComboBoxChange(Sender);
        end;
    2 : begin {Up}
          I:=SelectComboBox.ItemIndex;
          If I<=0 then exit;
          SelectComboBox.ItemIndex:=-1;
          SelectComboBoxChange(Sender);

          SelectComboBox.Items.Exchange(I,I-1);
          P:=Packers[I]; Packers[I]:=Packers[I-1]; Packers[I-1]:=P;

          SelectComboBox.ItemIndex:=I-1;
          LastIndex:=I-1;
          SelectComboBoxChange(Sender);
        end;
    3 : begin {Down}
          I:=SelectComboBox.ItemIndex;
          If (I<0) or (I=SelectComboBox.Items.Count-1) then exit;
          SelectComboBox.ItemIndex:=-1;
          SelectComboBoxChange(Sender);

          SelectComboBox.Items.Exchange(I,I+1);
          P:=Packers[I]; Packers[I]:=Packers[I+1]; Packers[I+1]:=P;

          SelectComboBox.ItemIndex:=I+1;
          LastIndex:=I+1;
          SelectComboBoxChange(Sender);
        end;  
  end;
end;

procedure TSetupFrameZipPrgs.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameZipPrgs.ShowFrame(const AdvencedMode: Boolean);
begin
  If SelectComboBox.Items.Count>0 then SelectComboBox.ItemIndex:=0;
  SelectComboBoxChange(self);
end;

procedure TSetupFrameZipPrgs.HideFrame;
begin
end;

procedure TSetupFrameZipPrgs.RestoreDefaults;
begin
end;

procedure TSetupFrameZipPrgs.SaveSetup;
Var I : Integer;
begin
  While PrgSetup.PackerSettingsCount>length(Packers) do PrgSetup.DeletePackerSettings(PrgSetup.PackerSettingsCount-1);
  while PrgSetup.PackerSettingsCount<length(Packers) do PrgSetup.AddPackerSettings('');

  SelectComboBox.ItemIndex:=-1;
  SelectComboBoxChange(self);
  For I:=0 to length(Packers)-1 do begin
    PrgSetup.PackerSettings[I].Name:=ChangeFileExt(ExtractFileName(Packers[I].FileName),'');
    PrgSetup.PackerSettings[I].ZipFileName:=Packers[I].FileName;
    PrgSetup.PackerSettings[I].FileExtensions:=CheckExtensionsList(Packers[I].Extensions);
    PrgSetup.PackerSettings[I].ExtractFile:=Packers[I].ExtractFile;
    PrgSetup.PackerSettings[I].CreateFile:=Packers[I].CreateFile;
    PrgSetup.PackerSettings[I].UpdateFile:=Packers[I].UpdateFile;
  end;
end;

procedure TSetupFrameZipPrgs.SelectComboBoxChange(Sender: TObject);
Var B : Boolean;
    S : String;
    I : Integer;
begin
  If JustChanging then exit;
  JustChanging:=True;
  try
    If LastIndex>=0 then begin
      Packers[LastIndex].Name:=SelectComboBox.Items[LastIndex];
      Packers[LastIndex].FileName:=FilenameEdit.Text;
      Packers[LastIndex].Extensions:=CheckExtensionsList(ExtensionsEdit.Text);
      Packers[LastIndex].ExtractFile:=CommandExtractEdit.Text;
      Packers[LastIndex].CreateFile:=CommandCreateEdit.Text;
      Packers[LastIndex].UpdateFile:=CommandAddEdit.Text;
    end;

    SelectComboBox.Enabled:=(SelectComboBox.Items.Count>0);
    DeleteButton.Enabled:=(SelectComboBox.ItemIndex>=0);
    UpButton.Enabled:=(SelectComboBox.ItemIndex>0);
    DownButton.Enabled:=(SelectComboBox.ItemIndex>=0) and (SelectComboBox.ItemIndex<SelectComboBox.Items.Count-1);

    LastIndex:=SelectComboBox.ItemIndex;
    B:=SelectComboBox.ItemIndex>=0;
    FilenameEdit.Visible:=B;
    FilenameButton.Visible:=B;
    ExtensionsEdit.Visible:=B;
    CommandExtractEdit.Visible:=B;
    CommandCreateEdit.Visible:=B;
    CommandAddEdit.Visible:=B;
    AutoSetupButton.Visible:=False;
    If B then begin
      S:=Trim(ExtUpperCase(Packers[SelectComboBox.ItemIndex].Name));
      For I:=0 to PackerDefaultValuesCount-1 do If Trim(ExtUpperCase(PackerDefaultValues[I].Name))=S then begin
        AutoSetupButton.Visible:=True;
        AutoSetupButton.Caption:=LanguageSetup.SetupFormExternalPackersSetupButton+' '+PackerDefaultValues[I].Name;
        break;
      end;
    end;
    If not B then exit;

    FilenameEdit.Text:=Packers[SelectComboBox.ItemIndex].FileName;
    ExtensionsEdit.Text:=CheckExtensionsList(Packers[SelectComboBox.ItemIndex].Extensions);
    CommandExtractEdit.Text:=Packers[SelectComboBox.ItemIndex].ExtractFile;
    CommandCreateEdit.Text:=Packers[SelectComboBox.ItemIndex].CreateFile;
    CommandAddEdit.Text:=Packers[SelectComboBox.ItemIndex].UpdateFile;
  finally
    JustChanging:=False;
  end;
end;

procedure TSetupFrameZipPrgs.FilenameButtonClick(Sender: TObject);
Var S : String;
    DoAutoSetup : Boolean;
begin
  S:=Trim(FilenameEdit.Text); If S<>'' then S:=ExtractFilePath(S);
  If S='' then S:=GetSpecialFolder(Application.MainForm.Handle,CSIDL_PROGRAM_FILES);
  PrgOpenDialog.Title:=LanguageSetup.SetupFormExternalPackersFileNameTitle;
  PrgOpenDialog.Filter:=LanguageSetup.SetupFormExeFilter;
  If S<>'' then PrgOpenDialog.InitialDir:=S;
  If PrgOpenDialog.Execute then begin
    DoAutoSetup:=(Trim(FilenameEdit.Text)='');
    FilenameEdit.Text:=PrgOpenDialog.FileName;
    FilenameEditChange(Sender);
    SelectComboBoxChange(Sender);
    If DoAutoSetup then AutoSetupButtonClick(Sender);
  end;
end;

procedure TSetupFrameZipPrgs.FilenameEditChange(Sender: TObject);
Var I : Integer;
begin
  I:=SelectComboBox.ItemIndex;
  If Trim(FilenameEdit.Text)=''
    then SelectComboBox.Items[I]:='-'
    else SelectComboBox.Items[I]:=ChangeFileExt(ExtractFileName(FilenameEdit.Text),'');
  SelectComboBox.ItemIndex:=I;

  SelectComboBoxChange(Sender);
end;

procedure TSetupFrameZipPrgs.AutoSetupButtonClick(Sender: TObject);
Var S : String;
    I : Integer;
begin
  S:=Trim(ExtUpperCase(Packers[SelectComboBox.ItemIndex].Name));
  For I:=0 to PackerDefaultValuesCount-1 do If Trim(ExtUpperCase(PackerDefaultValues[I].Name))=S then begin
    ExtensionsEdit.Text:=PackerDefaultValues[I].Extensions;
    CommandExtractEdit.Text:=PackerDefaultValues[I].CommandExtract;
    CommandCreateEdit.Text:=PackerDefaultValues[I].CommandCreate;
    CommandAddEdit.Text:=PackerDefaultValues[I].CommandUpdate;
    break;
  end;
end;

end.
