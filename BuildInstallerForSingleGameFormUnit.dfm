object BuildInstallerForSingleGameForm: TBuildInstallerForSingleGameForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Installer-Paket erstellen'
  ClientHeight = 179
  ClientWidth = 391
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DestFileButton: TSpeedButton
    Left = 362
    Top = 110
    Width = 23
    Height = 22
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      5555555555555555555555555555555555555555555555555555555555555555
      555555555555555555555555555555555555555FFFFFFFFFF555550000000000
      55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
      B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
      000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
      555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
      55555575FFF75555555555700007555555555557777555555555555555555555
      5555555555555555555555555555555555555555555555555555}
    NumGlyphs = 2
    OnClick = DestFileButtonClick
  end
  object InstTypeRadioGroup: TRadioGroup
    Left = 8
    Top = 8
    Width = 348
    Height = 73
    Caption = 'Paket-Erstellung'
    ItemIndex = 1
    Items.Strings = (
      'Nur NSI-Skript erstellen'
      'Skript erstellen und mit NSIS compilieren')
    TabOrder = 0
  end
  object DestFileEdit: TLabeledEdit
    Left = 8
    Top = 110
    Width = 348
    Height = 21
    EditLabel.Width = 112
    EditLabel.Height = 13
    EditLabel.Caption = 'Dateiname des Paketes'
    TabOrder = 1
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 148
    Width = 97
    Height = 25
    TabOrder = 2
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 148
    Width = 97
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
  object HelpButton: TBitBtn
    Left = 232
    Top = 148
    Width = 97
    Height = 25
    TabOrder = 4
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'exe'
    Left = 240
    Top = 120
  end
end
