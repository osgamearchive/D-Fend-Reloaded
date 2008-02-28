unit ModernProfileEditorStartFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Buttons, StdCtrls, Grids, ComCtrls, GameDBUnit, ModernProfileEditorFormUnit;

type
  TModernProfileEditorStartFrame = class(TFrame, IModernProfileEditorFrame)
    AutoexecOverrideGameStartCheckBox: TCheckBox;
    AutoexecOverrideMountingCheckBox: TCheckBox;
    AutoexecLabel: TLabel;
    AutoexecMemo: TRichEdit;
    AutoexecClearButton: TBitBtn;
    AutoexecLoadButton: TBitBtn;
    AutoexecSaveButton: TBitBtn;
    AutoexecBootNormal: TRadioButton;
    AutoexecBootHDImage: TRadioButton;
    AutoexecBootFloppyImage: TRadioButton;
    AutoexecBootFloppyImageInfoLabel: TLabel;
    AutoexecBootFloppyImageTab: TStringGrid;
    AutoexecBootHDImageComboBox: TComboBox;
    AutoexecBootFloppyImageButton: TSpeedButton;
    AutoexecBootFloppyImageAddButton: TSpeedButton;
    AutoexecBootFloppyImageDelButton: TSpeedButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    procedure ButtonWork(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    Procedure InitGUI(const OnProfileNameChange : TTextEvent; const GameDB: TGameDB; const CurrentProfileName, CurrentProfileExe, CurrentProfileSetup : PString);
    Procedure SetGame(const Game : TGame; const LoadFromTemplate : Boolean);
    Function CheckValue : Boolean;
    Procedure GetGame(const Game : TGame);
  end;

implementation

uses VistaToolsUnit, LanguageSetupUnit, CommonTools, PrgSetupUnit;

{$R *.dfm}

{ TModernProfileEditorStartFrame }

procedure TModernProfileEditorStartFrame.InitGUI(const OnProfileNameChange: TTextEvent; const GameDB: TGameDB; const CurrentProfileName, CurrentProfileExe, CurrentProfileSetup: PString);
begin
  NoFlicker(AutoexecOverrideGameStartCheckBox);
  NoFlicker(AutoexecOverrideMountingCheckBox);
  {NoFlicker(AutoexecMemo); - will hide text in Memo}
  NoFlicker(AutoexecClearButton);
  NoFlicker(AutoexecLoadButton);
  NoFlicker(AutoexecSaveButton);
  NoFlicker(AutoexecBootNormal);
  NoFlicker(AutoexecBootHDImage);
  NoFlicker(AutoexecBootFloppyImage);
  NoFlicker(AutoexecBootHDImageComboBox);
  NoFlicker(AutoexecBootFloppyImageTab);

  AutoexecOverrideGameStartCheckBox.Caption:=LanguageSetup.ProfileEditorAutoexecOverrideGameStart;
  AutoexecOverrideMountingCheckBox.Caption:=LanguageSetup.ProfileEditorAutoexecOverrideMounting;
  AutoexecLabel.Caption:=LanguageSetup.ProfileEditorAutoexecBat;
  AutoexecMemo.Font.Name:='Courier New';
  AutoexecClearButton.Caption:=LanguageSetup.Del;
  AutoexecLoadButton.Caption:=LanguageSetup.Load;
  AutoexecSaveButton.Caption:=LanguageSetup.Save;
  AutoexecBootNormal.Caption:=LanguageSetup.ProfileEditorAutoexecBootNormal;
  AutoexecBootHDImage.Caption:=LanguageSetup.ProfileEditorAutoexecBootHDImage;
  AutoexecBootFloppyImage.Caption:=LanguageSetup.ProfileEditorAutoexecBootFloppyImage;
  AutoexecBootFloppyImageInfoLabel.Caption:=LanguageSetup.ProfileMountingSwitchImage;
  AutoexecBootFloppyImageButton.Hint:=LanguageSetup.ChooseFile;
  AutoexecBootFloppyImageAddButton.Hint:=LanguageSetup.ProfileMountingAddImage;
  AutoexecBootFloppyImageDelButton.Hint:=LanguageSetup.ProfileMountingDelImage;
end;

procedure TModernProfileEditorStartFrame.SetGame(const Game: TGame; const LoadFromTemplate: Boolean);
Var St, St2 : TStringList;
    S : String;
    I : Integer;
begin
  AutoexecOverrideGameStartCheckBox.Checked:=Game.AutoexecOverridegamestart;
  AutoexecOverrideMountingCheckBox.Checked:=Game.AutoexecOverrideMount;
  St:=StringToStringList(Game.Autoexec);
  try
    AutoexecMemo.Lines.Assign(St);
  finally
    St.Free;
  end;
  S:=Trim(Game.AutoexecBootImage);
  If (S='2') or (S='3') then begin
    AutoexecBootHDImage.Checked:=True;
    If S='2' then AutoexecBootHDImageComboBox.ItemIndex:=0 else AutoexecBootHDImageComboBox.ItemIndex:=1;
  end else If S<>'' then begin
    AutoexecBootFloppyImage.Checked:=True;
    St2:=TStringList.Create;
    try
      S:=Trim(S);
      I:=Pos('$',S);
      While I>0 do begin St2.Add(Trim(Copy(S,1,I-1))); S:=Trim(Copy(S,I+1,MaxInt)); I:=Pos('$',S); end;
      St2.Add(S);
      AutoexecBootFloppyImageTab.RowCount:=St2.Count;
      For I:=0 to St2.Count-1 do AutoexecBootFloppyImageTab.Cells[0,I]:=St2[I];
    finally
      St2.Free;
    end;
  end;
end;

procedure TModernProfileEditorStartFrame.ButtonWork(Sender: TObject);
Var I : Integer;
    S : String;
begin
  Case (Sender as TComponent).Tag of
    0 : AutoexecMemo.Lines.Clear;
    1 : begin
          OpenDialog.DefaultExt:='txt';
          OpenDialog.Filter:=LanguageSetup.ProfileEditorAutoexecFilter;
          OpenDialog.Title:=LanguageSetup.ProfileEditorAutoexecLoadTitle;
          OpenDialog.InitialDir:=PrgDataDir;
          if not OpenDialog.Execute then exit;
          try
            AutoexecMemo.Lines.LoadFromFile(OpenDialog.FileName);
          except
            MessageDlg(Format(LanguageSetup.MessageCouldNotOpenFile,[OpenDialog.FileName]),mtError,[mbOK],0);
          end;
        end;
    2 : begin
          SaveDialog.DefaultExt:='txt';
          SaveDialog.Filter:=LanguageSetup.ProfileEditorAutoexecFilter;
          SaveDialog.Title:=LanguageSetup.ProfileEditorAutoexecSaveTitle;
          SaveDialog.InitialDir:=PrgDataDir;
          if not SaveDialog.Execute then exit;
          try
            AutoexecMemo.Lines.SaveToFile(SaveDialog.FileName);
          except
            MessageDlg(Format(LanguageSetup.MessageCouldNotSaveFile,[SaveDialog.FileName]),mtError,[mbOK],0);
          end;
        end;
    3 : begin
          If AutoexecBootFloppyImageTab.Row<0 then begin
            MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
            exit;
          end;
          S:=MakeAbsPath(AutoexecBootFloppyImageTab.Cells[0,AutoexecBootFloppyImageTab.Row],PrgSetup.BaseDir);
          OpenDialog.DefaultExt:='img';
          OpenDialog.InitialDir:=ExtractFilePath(S);
          OpenDialog.Title:=LanguageSetup.ProfileMountingFile;
          OpenDialog.Filter:=LanguageSetup.ProfileMountingFileFilter;
          if not OpenDialog.Execute then exit;
          AutoexecBootFloppyImageTab.Cells[0,AutoexecBootFloppyImageTab.Row]:=MakeRelPath(OpenDialog.FileName,PrgSetup.BaseDir);
        end;
    4 : begin
          AutoexecBootFloppyImageTab.RowCount:=AutoexecBootFloppyImageTab.RowCount+1;
          AutoexecBootFloppyImageTab.Row:=AutoexecBootFloppyImageTab.RowCount-1;
        end;
    5 : begin
          If AutoexecBootFloppyImageTab.Row<0 then begin
            MessageDlg(LanguageSetup.MessageNoImageSelected,mtError,[mbOK],0);
            exit;
          end;
          If AutoexecBootFloppyImageTab.RowCount=1 then begin
            AutoexecBootFloppyImageTab.Cells[0,0]:='';
          end else begin
            For I:=AutoexecBootFloppyImageTab.Row+1 to AutoexecBootFloppyImageTab.RowCount-1 do AutoexecBootFloppyImageTab.Cells[0,I-1]:=AutoexecBootFloppyImageTab.Cells[0,I];
            AutoexecBootFloppyImageTab.RowCount:=AutoexecBootFloppyImageTab.RowCount-1;
          end;
        end;
  end;
end;

function TModernProfileEditorStartFrame.CheckValue: Boolean;
begin
  result:=True;
end;

procedure TModernProfileEditorStartFrame.GetGame(const Game: TGame);
Var S : String;
    I : Integer;
begin
  Game.AutoexecOverridegamestart:=AutoexecOverrideGameStartCheckBox.Checked;
  Game.AutoexecOverrideMount:=AutoexecOverrideMountingCheckBox.Checked;
  Game.Autoexec:=StringListToString(AutoexecMemo.Lines);
  If AutoexecBootNormal.Checked then Game.AutoexecBootImage:='';
  If AutoexecBootHDImage.Checked then begin
    If AutoexecBootHDImageComboBox.ItemIndex=0 then Game.AutoexecBootImage:='2' else Game.AutoexecBootImage:='3';
  end;
  If AutoexecBootFloppyImage.Checked then begin
    S:=AutoexecBootFloppyImageTab.Cells[0,0];
    For I:=1 to AutoexecBootFloppyImageTab.RowCount-1 do S:=S+'$'+AutoexecBootFloppyImageTab.Cells[0,I];
    Game.AutoexecBootImage:=S;
  end;
end;

end.
