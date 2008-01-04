unit InfoFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, Grids;

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

uses ShellAPI, VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgConsts;

{$R *.dfm}

procedure TInfoForm.FormShow(Sender: TObject);
Var I : Integer;
    Rec : TSearchRec;
    St : TStringList;
    Lang : TLanguageSetup;
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
  eMailLabel.Caption:='alexanderherzog at users dot sourceforge dot net';
  LanguageAuthorsTab.Cells[0,0]:=LanguageSetup.InfoFormLanguageFile;
  LanguageAuthorsTab.Cells[1,0]:=LanguageSetup.InfoFormLanguageAuthor;
  LanguageAuthorsTab.ColWidths[0]:=150;
  LanguageAuthorsTab.ColWidths[1]:=LanguageAuthorsTab.ClientWidth-LanguageAuthorsTab.ColWidths[0]-10;

  try LicenseMemo.Lines.LoadFromFile(PrgDir+'License.txt'); except end;
  try CompLicenseMemo.Lines.LoadFromFile(PrgDir+'LicenseComponents.txt'); except end;
  try ChangeLogMemo.Lines.LoadFromFile(PrgDir+'ChangeLog.txt'); except end;

  St:=TStringList.Create;
  try
    I:=FindFirst(PrgDir+LanguageSubDir+'\*.ini',faAnyFile,Rec);
    try
      while I=0 do begin
        St.Add(Copy(Rec.Name,1,length(Rec.Name)-4));
        I:=FindNext(Rec);
      end;
    finally
      FindClose(Rec);
    end;

    LanguageAuthorsTab.RowCount:=St.Count+1;
    For I:=0 to St.Count-1 do begin
      Lang:=TLanguageSetup.Create(St[I]+'.ini');
      try
        LanguageAuthorsTab.Cells[0,I+1]:=St[I];
        LanguageAuthorsTab.Cells[1,I+1]:=Lang.Author;
      finally
        Lang.Free;
      end;
    end;

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
