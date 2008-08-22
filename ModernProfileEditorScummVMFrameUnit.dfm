object ModernProfileEditorScummVMFrame: TModernProfileEditorScummVMFrame
  Left = 0
  Top = 0
  Width = 602
  Height = 486
  TabOrder = 0
  DesignSize = (
    602
    486)
  object LanguageLabel: TLabel
    Left = 24
    Top = 13
    Width = 72
    Height = 13
    Caption = 'LanguageLabel'
  end
  object AutosaveLabel: TLabel
    Left = 24
    Top = 72
    Width = 71
    Height = 13
    Caption = 'AutosaveLabel'
  end
  object TalkSpeedLabel: TLabel
    Left = 24
    Top = 128
    Width = 74
    Height = 13
    Caption = 'TalkSpeedLabel'
  end
  object LanguageComboBox: TComboBox
    Left = 24
    Top = 32
    Width = 105
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object SubtitlesCheckBox: TCheckBox
    Left = 24
    Top = 192
    Width = 561
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'SubtitlesCheckBox'
    TabOrder = 3
  end
  object AutosaveEdit: TSpinEdit
    Left = 24
    Top = 91
    Width = 105
    Height = 22
    MaxValue = 86400
    MinValue = 1
    TabOrder = 1
    Value = 300
  end
  object TalkSpeedEdit: TSpinEdit
    Left = 24
    Top = 147
    Width = 105
    Height = 22
    MaxValue = 1000
    MinValue = 1
    TabOrder = 2
    Value = 60
  end
  object SavePathGroupBox: TGroupBox
    Left = 24
    Top = 232
    Width = 561
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Folder for saved games'
    TabOrder = 4
    Visible = False
    DesignSize = (
      561
      105)
    object SavePathEditButton: TSpeedButton
      Left = 535
      Top = 71
      Width = 23
      Height = 22
      Anchors = [akTop, akRight]
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
      OnClick = SavePathEditButtonClick
    end
    object SavePathDefaultRadioButton: TRadioButton
      Left = 16
      Top = 25
      Width = 529
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Use game folder (default)'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object SavePathCustomRadioButton: TRadioButton
      Left = 16
      Top = 48
      Width = 529
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Use this custom folder'
      TabOrder = 1
    end
    object SavePathEdit: TEdit
      Left = 32
      Top = 71
      Width = 497
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      OnChange = SavePathEditChange
    end
  end
end
