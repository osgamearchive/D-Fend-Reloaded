object BuildImageFromFolderForm: TBuildImageFromFolderForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Imagedatei von Ordnerinhalt erstellen'
  ClientHeight = 377
  ClientWidth = 493
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
  DesignSize = (
    493
    377)
  PixelsPerInch = 96
  TextHeight = 13
  object FileNameButton: TSpeedButton
    Tag = 1
    Left = 463
    Top = 72
    Width = 23
    Height = 22
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      555555FFFFFFFFFF55555000000000055555577777777775FFFF00B8B8B8B8B0
      0000775F5555555777770B0B8B8B8B8B0FF07F75F555555575F70FB0B8B8B8B8
      B0F07F575FFFFFFFF7F70BFB0000000000F07F557777777777570FBFBF0FFFFF
      FFF07F55557F5FFFFFF70BFBFB0F000000F07F55557F777777570FBFBF0FFFFF
      FFF075F5557F5FFFFFF750FBFB0F000000F0575FFF7F777777575700000FFFFF
      FFF05577777F5FF55FF75555550F00FF00005555557F775577775555550FFFFF
      0F055555557F55557F755555550FFFFF00555555557FFFFF7755555555000000
      0555555555777777755555555555555555555555555555555555}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonWork
  end
  object FolderButton: TSpeedButton
    Left = 463
    Top = 28
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
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonWork
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 346
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 10
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 346
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 11
    Kind = bkCancel
  end
  object FolderEdit: TLabeledEdit
    Left = 8
    Top = 29
    Width = 449
    Height = 21
    EditLabel.Width = 77
    EditLabel.Height = 13
    EditLabel.Caption = 'Quellverzeichnis'
    TabOrder = 0
  end
  object FileNameEdit: TLabeledEdit
    Left = 8
    Top = 72
    Width = 449
    Height = 21
    EditLabel.Width = 73
    EditLabel.Height = 13
    EditLabel.Caption = 'Diskettenimage'
    TabOrder = 1
  end
  object MakeBootableCheckBox: TCheckBox
    Left = 8
    Top = 176
    Width = 478
    Height = 17
    Caption = 'Make floppy image bootable'
    TabOrder = 3
    OnClick = MakeBootableCheckBoxClick
  end
  object AddKeyboardDriverCheckBox: TCheckBox
    Left = 8
    Top = 199
    Width = 478
    Height = 17
    Caption = 'Use DOSBox default keyboard layout on bootdisk'
    Enabled = False
    TabOrder = 4
  end
  object WriteToFloppyCheckBox: TCheckBox
    Left = 8
    Top = 314
    Width = 478
    Height = 17
    Caption = 'Fertiges Image auf reale Diskette schreiben'
    TabOrder = 9
  end
  object AddMouseDriverCheckBox: TCheckBox
    Left = 8
    Top = 222
    Width = 477
    Height = 17
    Caption = 'Include mouse driver on bootdisk'
    Enabled = False
    TabOrder = 5
  end
  object HelpButton: TBitBtn
    Left = 232
    Top = 346
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 12
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object AddFormatCheckBox: TCheckBox
    Left = 8
    Top = 268
    Width = 516
    Height = 17
    Caption = 'Add disk management utilities'
    TabOrder = 7
  end
  object AddEditCheckbox: TCheckBox
    Left = 8
    Top = 291
    Width = 477
    Height = 17
    Caption = 'Add text editor'
    TabOrder = 8
  end
  object ImageTypeGroupBox: TRadioGroup
    Left = 8
    Top = 99
    Width = 449
    Height = 62
    Caption = 'Image type'
    ItemIndex = 0
    Items.Strings = (
      'Floppy disk image'
      'Harddisk image')
    TabOrder = 2
    OnClick = ImageTypeGroupBoxClick
  end
  object MemoryManagerCheckBox: TCheckBox
    Left = 8
    Top = 245
    Width = 477
    Height = 17
    Caption = 'Use memory manager on disk image'
    TabOrder = 6
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'img'
    Left = 416
    Top = 10
  end
end
