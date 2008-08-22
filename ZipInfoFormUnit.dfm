object ZipInfoForm: TZipInfoForm
  Left = 0
  Top = 0
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = 'ZipInfoForm'
  ClientHeight = 152
  ClientWidth = 429
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  GlassFrame.Enabled = True
  GlassFrame.SheetOfGlass = True
  object InfoLabel: TLabel
    Left = 24
    Top = 56
    Width = 377
    Height = 81
    AutoSize = False
    Caption = 'InfoLabel'
    WordWrap = True
  end
  object ProgressBar: TProgressBar
    Left = 24
    Top = 16
    Width = 385
    Height = 17
    TabOrder = 0
  end
end
