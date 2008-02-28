unit LanguageEditorFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, ExtCtrls;

type
  TLanguageEditorForm = class(TForm)
    Panel1: TPanel;
    CloseButton: TBitBtn;
    SectionComboBox: TComboBox;
    InfoLabel: TLabel;
    Tab: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SectionComboBoxChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
  private
    { Private-Deklarationen }
    DefaultLanguageFile : String;
    LastSection : Integer;
    Procedure LoadSection(const Section : String);
    Procedure SaveSection(const Section : String);
  public
    { Public-Deklarationen }
    LanguageFile : String;
  end;

var
  LanguageEditorForm: TLanguageEditorForm;

Procedure ShowLanguageEditorDialog(const AOwner : TComponent; const ALanguageFile : String);

implementation

uses Math, IniFiles, VistaToolsUnit, LanguageSetupUnit, PrgSetupUnit, PrgConsts,
     CommonTools;

{$R *.dfm}

procedure TLanguageEditorForm.FormCreate(Sender: TObject);
begin
  SetVistaFonts(self);
  NoFlicker(CloseButton);
  NoFlicker(SectionComboBox);
  NoFlicker(Tab);

  CloseButton.Caption:=LanguageSetup.Close;
  Caption:=LanguageSetup.LanguageEditorCaption;

  DefaultLanguageFile:=PrgDir+LanguageSubDir+'\English.ini';
  LastSection:=-1;
end;

procedure TLanguageEditorForm.FormShow(Sender: TObject);
Var Ini : TIniFile;
    St,St2,St3 : TStringList;
    I : Integer;
begin
  Caption:=Caption+' ['+LanguageFile+']';

  {Init table}
  FormResize(Sender);
  Tab.Cells[0,0]:='Identifier';
  Tab.Cells[1,0]:='English';
  Tab.Cells[2,0]:=ChangeFileExt(ExtractFileName(LanguageFile),'');

  {Init sections}
  St:=TStringList.Create;
  St2:=TStringList.Create;
  St3:=TStringList.Create;
  try
    Ini:=TIniFile.Create(DefaultLanguageFile);
    try
      St3.Clear; Ini.ReadSections(St3);
      For I:=0 to St3.Count-1 do If St2.IndexOf(ExtUpperCase(St3[I]))<0 then begin St2.Add(ExtUpperCase(St3[I])); St.Add(St3[I]); end;
    finally
      Ini.Free;
    end;

    Ini:=TIniFile.Create(LanguageFile);
    try
      St3.Clear; Ini.ReadSections(St3);
      For I:=0 to St3.Count-1 do If St2.IndexOf(ExtUpperCase(St3[I]))<0 then begin St2.Add(ExtUpperCase(St3[I])); St.Add(St3[I]); end;
    finally
      Ini.Free;
    end;

    St.Sort;
    SectionComboBox.Items.AddStrings(St);
  finally
    St.Free;
    St2.Free;
    St3.Free;
  end;

  {Load first section}
  If SectionComboBox.Items.Count>=0 then begin
    SectionComboBox.ItemIndex:=0;
    SectionComboBoxChange(Sender);
  end;
end;

procedure TLanguageEditorForm.FormResize(Sender: TObject);
Var I : Integer;
begin
  I:=Tab.ClientWidth-10;
  Tab.ColWidths[0]:=I*1 div 5;
  Tab.ColWidths[1]:=I*2 div 5;
  Tab.ColWidths[2]:=I*2 div 5;
end;

procedure TLanguageEditorForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SectionComboBoxChange(Sender);
end;

procedure TLanguageEditorForm.LoadSection(const Section: String);
Var Ini1, Ini2 : TIniFile;
    St,St2,St3 : TStringList;
    I,Untranslated : Integer;
    S,T : String;
begin
  Untranslated:=0;
  Ini1:=TIniFile.Create(DefaultLanguageFile); try Ini2:=TIniFile.Create(LanguageFile);
  try
    St:=TStringList.Create;
    St2:=TStringList.Create;
    St3:=TStringList.Create;
    try
      St3.Clear; Ini1.ReadSection(Section,St3);
      For I:=0 to St3.Count-1 do If St2.IndexOf(ExtUpperCase(St3[I]))<0 then begin St2.Add(ExtUpperCase(St3[I])); St.Add(St3[I]); end;
      St3.Clear; Ini2.ReadSection(Section,St3);
      For I:=0 to St3.Count-1 do If St2.IndexOf(ExtUpperCase(St3[I]))<0 then begin St2.Add(ExtUpperCase(St3[I])); St.Add(St3[I]); end;

      Tab.RowCount:=Max(2,St.Count+1);
      Tab.Cells[0,1]:=''; Tab.Cells[1,1]:=''; Tab.Cells[2,1]:='';
      For I:=0 to St.Count-1 do begin
        Tab.Cells[0,I+1]:=St[I];
        S:=Ini1.ReadString(Section,St[I],''); Tab.Cells[1,I+1]:=S;
        If (ExtUpperCase(Section)='AUTHOR') and (ExtUpperCase(St[I])='NAME') then S:=LanguageSetup.NotSet;
        T:=Ini2.ReadString(Section,St[I],S); Tab.Cells[2,I+1]:=T;
        If S=T then inc(Untranslated);
      end;
    finally
      St.Free;
      St2.Free;
      St3.Free;
    end;
  finally Ini2.Free; end; finally Ini1.Free; end;

  Case Untranslated of
    0 : InfoLabel.Caption:=LanguageSetup.LanguageEditorInfoAllTranslated;
    1 : InfoLabel.Caption:=LanguageSetup.LanguageEditorInfoOneTranslationMissing;
    else InfoLabel.Caption:=Format(LanguageSetup.LanguageEditorInfoTranslationsMissing,[Untranslated]);
  end;
end;

procedure TLanguageEditorForm.SaveSection(const Section: String);
Var Ini : TIniFile;
    I : Integer;
begin
  Ini:=TIniFile.Create(LanguageFile);
  try
    For I:=1 to Tab.RowCount-1 do If Tab.Cells[0,I]<>'' then
      Ini.WriteString(Section,Tab.Cells[0,I],Tab.Cells[2,I]);
  finally
    Ini.Free;
  end;
end;

procedure TLanguageEditorForm.SectionComboBoxChange(Sender: TObject);
begin
  If LastSection>=0 then SaveSection(SectionComboBox.Items[LastSection]);

  LastSection:=SectionComboBox.ItemIndex;
  LoadSection(SectionComboBox.Items[LastSection]);
end;

{ global }

Procedure ShowLanguageEditorDialog(const AOwner : TComponent; const ALanguageFile : String);
begin
  LanguageEditorForm:=TLanguageEditorForm.Create(AOwner);
  try
    LanguageEditorForm.LanguageFile:=ALanguageFile;
    LanguageEditorForm.ShowModal;
  finally
    LanguageEditorForm.Free;
  end;
end;

end.
