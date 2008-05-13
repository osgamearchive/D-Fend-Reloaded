object ModernProfileEditorScummVMGraphicsFrame: TModernProfileEditorScummVMGraphicsFrame
  Left = 0
  Top = 0
  Width = 602
  Height = 530
  TabOrder = 0
  DesignSize = (
    602
    530)
  object FilterLabel: TLabel
    Left = 24
    Top = 13
    Width = 49
    Height = 13
    Caption = 'FilterLabel'
  end
  object FilterComboBox: TComboBox
    Left = 24
    Top = 32
    Width = 561
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 0
    TabOrder = 0
  end
  object StartFullscreenCheckBox: TCheckBox
    Left = 24
    Top = 72
    Width = 561
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'StartFullscreenCheckBox'
    TabOrder = 1
  end
  object KeepAspectRatioCheckBox: TCheckBox
    Left = 24
    Top = 104
    Width = 561
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'KeepAspectRatioCheckBox'
    TabOrder = 2
  end
end
