object TransferForm: TTransferForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Programme '#252'bertragen'
  ClientHeight = 430
  ClientWidth = 391
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
  object InfoLabel: TLabel
    Left = 8
    Top = 8
    Width = 263
    Height = 13
    Caption = 'Bitte w'#228'hlen Sie die zu '#252'bertragenden Programme aus:'
  end
  object DestPrgDirButton: TSpeedButton
    Left = 362
    Top = 360
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
    OnClick = DestPrgDirButtonClick
  end
  object ListBox: TCheckListBox
    Left = 8
    Top = 27
    Width = 377
    Height = 270
    ItemHeight = 13
    TabOrder = 0
  end
  object SelectAllButton: TBitBtn
    Left = 8
    Top = 303
    Width = 97
    Height = 25
    Caption = 'SelectAllButton'
    TabOrder = 1
  end
  object SelectNoneButton: TBitBtn
    Tag = 1
    Left = 111
    Top = 303
    Width = 97
    Height = 25
    Caption = 'SelectNoneButton'
    TabOrder = 2
    OnClick = SelectButtonClick
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 398
    Width = 97
    Height = 25
    TabOrder = 5
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 398
    Width = 97
    Height = 25
    TabOrder = 6
    Kind = bkCancel
  end
  object DestPrgDirEdit: TLabeledEdit
    Left = 8
    Top = 360
    Width = 348
    Height = 21
    EditLabel.Width = 190
    EditLabel.Height = 13
    EditLabel.Caption = 'Programmverzeichnis der Zielinstallation'
    TabOrder = 4
  end
  object SelectGenreButton: TBitBtn
    Tag = 2
    Left = 214
    Top = 303
    Width = 97
    Height = 25
    Caption = 'By Genre'
    TabOrder = 3
    OnClick = SelectButtonClick
  end
  object PopupMenu: TPopupMenu
    Left = 320
    Top = 312
    object MenuSelect: TMenuItem
      Caption = '&Select'
    end
    object MenuUnselect: TMenuItem
      Caption = '&Unselect'
    end
  end
end
