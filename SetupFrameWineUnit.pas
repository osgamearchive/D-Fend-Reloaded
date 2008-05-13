unit SetupFrameWineUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, Grids, ValEdit, SetupFormUnit;

type
  TSetupFrameWine = class(TFrame, ISetupFrame)
    MainCheckBox: TCheckBox;
    MainInfoLabel: TLabel;
    ListInfoLabel: TLabel;
    List: TValueListEditor;
    RemapMountsCheckBox: TCheckBox;
    RemapScreenshotFolderCheckBox: TCheckBox;
    RemapMapperFileCheckBox: TCheckBox;
    RemapDOSBoxFolderCheckBox: TCheckBox;
    LinuxLinkModeCheckBox: TCheckBox;
    ShellScriptPreambleEdit: TLabeledEdit;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Function GetName : String;  
    Procedure InitGUIAndLoadSetup(InitData : TInitData);
    Procedure LoadLanguage;
    Procedure DOSBoxDirChanged;
    Procedure ShowFrame(const AdvencedMode : Boolean);
    Procedure RestoreDefaults;
    Procedure SaveSetup;
  end;

implementation

uses LanguageSetupUnit, VistaToolsUnit, PrgSetupUnit;

{$R *.dfm}

{ TSetupFrameWineFrame }

function TSetupFrameWine.GetName: String;
begin
  result:='Wine support';
end;

procedure TSetupFrameWine.InitGUIAndLoadSetup(InitData: TInitData);
Var I : Integer;
begin
  NoFlicker(MainCheckBox);
  NoFlicker(List);
  NoFlicker(RemapMountsCheckBox);
  NoFlicker(RemapScreenshotFolderCheckBox);
  NoFlicker(RemapMapperFileCheckBox);
  NoFlicker(RemapDOSBoxFolderCheckBox);
  NoFlicker(LinuxLinkModeCheckBox);
  NoFlicker(ShellScriptPreambleEdit);

  MainCheckBox.Checked:=PrgSetup.EnableWineMode;
  For I:=0 to 25 do List.Strings.Add(chr(ord('A')+I)+':='+PrgSetup.LinuxRemap[chr(ord('A')+I)]);
  RemapMountsCheckBox.Checked:=PrgSetup.RemapMounts;
  RemapScreenshotFolderCheckBox.Checked:=PrgSetup.RemapScreenShotFolder;
  RemapMapperFileCheckBox.Checked:=PrgSetup.RemapMapperFile;
  RemapDOSBoxFolderCheckBox.Checked:=PrgSetup.RemapDOSBoxFolder;
  LinuxLinkModeCheckBox.Checked:=PrgSetup.LinuxLinkMode;
  ShellScriptPreambleEdit.Text:=PrgSetup.LinuxShellScriptPreamble;
end;

procedure TSetupFrameWine.LoadLanguage;
begin
  List.TitleCaptions[0]:='Wine drive letter';
  List.TitleCaptions[1]:='Linux path';
end;

procedure TSetupFrameWine.DOSBoxDirChanged;
begin
end;

procedure TSetupFrameWine.ShowFrame(const AdvencedMode: Boolean);
begin
end;

procedure TSetupFrameWine.RestoreDefaults;
Var I : Integer;
begin
  MainCheckBox.Checked:=False;
  For I:=0 to 25 do List.Strings[I]:=(chr(ord('A')+I)+':=');
  RemapMountsCheckBox.Checked:=False;
  RemapScreenshotFolderCheckBox.Checked:=False;
  RemapMapperFileCheckBox.Checked:=False;
  RemapDOSBoxFolderCheckBox.Checked:=False;
  LinuxLinkModeCheckBox.Checked:=False;
  ShellScriptPreambleEdit.Text:='#!/bin/bash';
end;

procedure TSetupFrameWine.SaveSetup;
Var I : Integer;
begin
  PrgSetup.EnableWineMode:=MainCheckBox.Checked;
  For I:=0 to 25 do PrgSetup.LinuxRemap[chr(ord('A')+I)]:=List.Strings.ValueFromIndex[I];
  PrgSetup.RemapMounts:=RemapMountsCheckBox.Checked;
  PrgSetup.RemapScreenShotFolder:=RemapScreenshotFolderCheckBox.Checked;
  PrgSetup.RemapMapperFile:=RemapMapperFileCheckBox.Checked;
  PrgSetup.RemapDOSBoxFolder:=RemapDOSBoxFolderCheckBox.Checked;
  PrgSetup.LinuxLinkMode:=LinuxLinkModeCheckBox.Checked;
  PrgSetup.LinuxShellScriptPreamble:=ShellScriptPreambleEdit.Text;
end;

end.
