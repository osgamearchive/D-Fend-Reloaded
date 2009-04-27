object ScanGamesFolderForm: TScanGamesFolderForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'ScanGamesFolderForm'
  ClientHeight = 286
  ClientWidth = 496
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Step1Label: TLabel
    Left = 8
    Top = 16
    Width = 299
    Height = 13
    Caption = 'Step 1: Copy/extract games to subfolders of the games folder'
  end
  object Step2Label: TLabel
    Left = 8
    Top = 88
    Width = 291
    Height = 13
    Caption = 'Step 2: Click on "Automatically detect and setup new games"'
  end
  object OpenFolderButton: TBitBtn
    Left = 8
    Top = 35
    Width = 313
    Height = 25
    Caption = 'Open games folder in Explorer'
    TabOrder = 0
    OnClick = OpenFolderButtonClick
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
  end
  object ScanButton: TBitBtn
    Left = 8
    Top = 107
    Width = 313
    Height = 25
    Caption = 'Automatically detect and setup new games'
    TabOrder = 1
    OnClick = ScanButtonClick
  end
  object CloseButton: TBitBtn
    Left = 8
    Top = 252
    Width = 97
    Height = 25
    TabOrder = 4
    Kind = bkClose
  end
  object ProgressBar: TProgressBar
    Left = 8
    Top = 220
    Width = 473
    Height = 17
    Step = 1
    TabOrder = 3
    Visible = False
  end
  object DetectionTypeRadioGroupBox: TRadioGroup
    Left = 8
    Top = 138
    Width = 473
    Height = 63
    Caption = 'Detection settings'
    ItemIndex = 0
    Items.Strings = (
      'Only add game if matching auto setup template exists'
      'Try to add all games')
    TabOrder = 2
  end
  object HelpButton: TBitBtn
    Left = 111
    Top = 253
    Width = 97
    Height = 25
    TabOrder = 5
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
end
