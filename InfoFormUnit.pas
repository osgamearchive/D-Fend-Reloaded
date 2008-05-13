unit InfoFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, Grids, ExtCtrls, GIFImg;

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
    EasterImage1: TImage;
    EasterImage2: TImage;
    EasterImage3: TImage;
    Timer: TTimer;
    Image2: TImage;
    procedure FormShow(Sender: TObject);
    procedure HomepageLabelClick(Sender: TObject);
    procedure Label1DblClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private-Deklarationen }
    FImage : TImage;
    Dir : Integer;
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
    St,StShort : TStringList;
    Lang : TLanguageSetup;
    S,T : String;
begin
  FImage:=nil;

  SetVistaFonts(self);
  Font.Charset:=CharsetNameToFontCharSet(LanguageSetup.CharsetName);
  
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
  LanguageAuthorsTab.Cells[2,0]:=LanguageSetup.InfoFormLanguageVersion;
  LanguageAuthorsTab.ColWidths[0]:=175;
  LanguageAuthorsTab.ColWidths[2]:=75;
  LanguageAuthorsTab.ColWidths[1]:=LanguageAuthorsTab.ClientWidth-LanguageAuthorsTab.ColWidths[0]-LanguageAuthorsTab.ColWidths[2]-5;

  try LicenseMemo.Lines.LoadFromFile(PrgDir+'License.txt'); except end;
  LicenseMemo.Lines.Insert(0,'');
  try CompLicenseMemo.Lines.LoadFromFile(PrgDir+'LicenseComponents.txt'); except end;
  CompLicenseMemo.Lines.Insert(0,'');
  try ChangeLogMemo.Lines.LoadFromFile(PrgDir+'ChangeLog.txt'); except end;
  If ChangeLogMemo.Lines.Count>0 then ChangeLogMemo.Lines.Delete(0);
  ChangeLogMemo.Font.Name:='Courier New';

  St:=TStringList.Create;
  StShort:=TStringList.Create;
  try
    If DirectoryExists(PrgDir+LanguageSubDir) then begin
      I:=FindFirst(PrgDir+LanguageSubDir+'\*.ini',faAnyFile,Rec);
      try
        while I=0 do begin
          If StShort.IndexOf(ExtUpperCase(Rec.Name))<0 then begin
            St.Add(PrgDir+LanguageSubDir+'\'+Rec.Name);
            StShort.Add(ExtUpperCase(Rec.Name));
          end;
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
          If StShort.IndexOf(ExtUpperCase(Rec.Name))<0 then begin
            St.Add(PrgDataDir+LanguageSubDir+'\'+Rec.Name);
            StShort.Add(ExtUpperCase(Rec.Name));
          end;
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
        S:=ChangeFileExt(ExtractFileName(St[I]),'');
        T:=Lang.LocalLanguageName;
        If (T<>S) and (T<>'') then S:=T+' ('+S+')';
        LanguageAuthorsTab.Cells[0,I+1]:=S;
        LanguageAuthorsTab.Cells[1,I+1]:=Lang.Author;
        LanguageAuthorsTab.Cells[2,I+1]:=Lang.MaxVersion;
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

procedure TInfoForm.Label1DblClick(Sender: TObject);
begin
  If ((GetKeyState(VK_LSHIFT) div 32)=0) and ((GetKeyState(VK_RSHIFT) div 32)=0) then exit;
  If FImage<>nil then exit;
  FImage:=TImage.Create(MainSheet); FImage.Parent:=MainSheet; Dir:=3;
  with FImage do begin AutoSize:=True; Transparent:=True; Top:=0; Left:=-100; Picture.Assign(EasterImage1.Picture); DoubleBuffered:=True; end;
  Timer.Enabled:=True;
end;

procedure TInfoForm.TimerTimer(Sender: TObject);
const MoveStep=3;
begin
  If Random>0.99 then Case Dir of 1 : Dir:=30; 3 : Dir:=10; 7 : Dir:=90; 9 : Dir:=70; end;
  If Random>0.95 then Case Dir of 1 : Dir:=7; 3 : Dir:=9; 7 : Dir:=1; 9 : Dir:=3; end;
  If FImage.Left<=0 then Case Dir of 1 : Dir:=30; 7 : Dir:=90; end;
  If FImage.Left+FImage.Width>=MainSheet.ClientWidth then Case Dir of 3 : Dir:=10; 9 : Dir:=70; end;
  If FImage.Top<=0 then Case Dir of 7 : Dir:=1; 9 : Dir:=3; end;
  If FImage.Top+FImage.Height>=MainSheet.ClientHeight then Case Dir of 1 : Dir:=7; 3 : Dir:=9; end;
  If Dir mod 10 =0 then FImage.Picture.Assign(EasterImage3.Picture);
  If (Dir>=10) and (Dir mod 10 <9) then inc(Dir);
  Case Dir of
    1 : with FImage do begin Top:=Top+1; Left:=Left-MoveStep; end;
    3 : with FImage do begin Top:=Top+1; Left:=Left+MoveStep; end;
    7 : with FImage do begin Top:=Top-1; Left:=Left-MoveStep; end;
    9 : with FImage do begin Top:=Top-1; Left:=Left+MoveStep; end;
   39,99 : begin FImage.Picture.Assign(EasterImage1.Picture); Dir:=Dir div 10; end;
   19,79 : begin FImage.Picture.Assign(EasterImage2.Picture); Dir:=Dir div 10; end;
  end;
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
