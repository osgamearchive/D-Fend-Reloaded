unit InfoFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, Grids, ExtCtrls;

type
  TInfoForm = class(TForm)
    PageControl: TPageControl;
    MainSheet: TTabSheet;
    LicenseSheet: TTabSheet;
    CompLicenseSheet: TTabSheet;
    BitBtn1: TBitBtn;
    VersionLabel: TLabel;
    Label1: TLabel;
    WrittenByLabel: TLabel;
    eMailLabel: TLabel;
    CompLicenseMemo: TRichEdit;
    LicenseMemo: TRichEdit;
    HomepageLabel: TLabel;
    ChangeLogTabSheet: TTabSheet;
    ChangeLogMemo: TRichEdit;
    LanguageSheet: TTabSheet;
    LanguageAuthorsTab: TStringGrid;
    DFendTabSheet: TTabSheet;
    DFendInfoLabel: TLabel;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
    procedure HomepageLabelClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  InfoForm: TInfoForm;

Procedure ShowInfoDialog(const AOwner : TComponent);

implementation

uses ShellAPI, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgConsts, PrgSetupUnit;

{$R *.dfm}

procedure TInfoForm.FormShow(Sender: TObject);
Var I : Integer;
    Rec : TSearchRec;
    St : TStringList;
    Lang : TLanguageSetup;
    S,T : String;
begin
  SetVistaFonts(self);

  Caption:=LanguageSetup.InfoForm;
  MainSheet.Caption:=LanguageSetup.InfoFormMain;
  LanguageSheet.Caption:=LanguageSetup.InfoFormLanguage;
  LicenseSheet.Caption:=LanguageSetup.InfoFormLicense;
  CompLicenseSheet.Caption:=LanguageSetup.InfoFormCompLicense;
  ChangeLogTabSheet.Caption:=LanguageSetup.InfoFormChangeLog;

  VersionLabel.Caption:=GetFileVersionAsString;
  WrittenByLabel.Caption:=LanguageSetup.InfoFormWrittenBy+' Alexander Herzog';
  S:='alexanderherzog'; T:='users.sourceforge.net';
  eMailLabel.Caption:=S+'@'+T;
  LanguageAuthorsTab.Cells[0,0]:=LanguageSetup.InfoFormLanguageFile;
  LanguageAuthorsTab.Cells[1,0]:=LanguageSetup.InfoFormLanguageAuthor;
  LanguageAuthorsTab.ColWidths[0]:=150;
  LanguageAuthorsTab.ColWidths[1]:=LanguageAuthorsTab.ClientWidth-LanguageAuthorsTab.ColWidths[0]-5;

  try LicenseMemo.Lines.LoadFromFile(PrgDir+'License.txt'); except end;
  LicenseMemo.Lines.Insert(0,'');
  try CompLicenseMemo.Lines.LoadFromFile(PrgDir+'LicenseComponents.txt'); except end;
  CompLicenseMemo.Lines.Insert(0,'');
  try ChangeLogMemo.Lines.LoadFromFile(PrgDir+'ChangeLog.txt'); except end;
  If ChangeLogMemo.Lines.Count>0 then ChangeLogMemo.Lines.Delete(0);
  ChangeLogMemo.Font.Name:='Courier New';

  St:=TStringList.Create;
  try
    If DirectoryExists(PrgDir+LanguageSubDir) then begin
      I:=FindFirst(PrgDir+LanguageSubDir+'\*.ini',faAnyFile,Rec);
      try
        while I=0 do begin
          St.Add(PrgDir+LanguageSubDir+'\'+Rec.Name);
          I:=FindNext(Rec);
        end;
      finally
        FindClose(Rec);
      end;
    end;

    If DirectoryExists(PrgDataDir+LanguageSubDir) and (PrgDataDir<>PrgDir) then begin
      I:=FindFirst(PrgDataDir+LanguageSubDir+'\*.ini',faAnyFile,Rec);
      try
        while I=0 do begin
          St.Add(PrgDataDir+LanguageSubDir+'\'+Rec.Name);
          I:=FindNext(Rec);
        end;
      finally
        FindClose(Rec);
      end;
    end;

    LanguageAuthorsTab.RowCount:=St.Count+1;
    For I:=0 to St.Count-1 do begin
      Lang:=TLanguageSetup.Create(St[I]);
      try
        LanguageAuthorsTab.Cells[0,I+1]:=ChangeFileExt(ExtractFileName(St[I]),'');
        LanguageAuthorsTab.Cells[1,I+1]:=Lang.Author;
      finally
        Lang.Free;
      end;
    end;

  finally
    St.Free;
  end;

  St:=StringToStringList(LanguageSetup.InfoFormDFend);
  try
    DFendInfoLabel.Caption:=St.Text;
  finally
    St.Free;
  end;
end;

procedure TInfoForm.HomepageLabelClick(Sender: TObject);
begin
  ShellExecute(Handle,'open',PChar(HomepageLabel.Caption),nil,nil,SW_SHOW);
end;

{ global }

Procedure ShowInfoDialog(const AOwner : TComponent);
begin
  InfoForm:=TInfoForm.Create(AOwner);
  try
    InfoForm.ShowModal;
  finally
    InfoForm.Free;
  end;
end;

end.
