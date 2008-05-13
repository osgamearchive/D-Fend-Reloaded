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
end
