object ModernProfileEditorKeyboardFrame: TModernProfileEditorKeyboardFrame
  Left = 0
  Top = 0
  Width = 641
  Height = 478
  TabOrder = 0
  DesignSize = (
    641
    478)
  object KeyboardLayoutLabel: TLabel
    Left = 24
    Top = 56
    Width = 104
    Height = 13
    Caption = 'KeyboardLayoutLabel'
  end
  object KeyboardLayoutInfoLabel: TLabel
    Left = 24
    Top = 102
    Width = 601
    Height = 43
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'KeyboardLayoutInfoLabel'
    WordWrap = True
  end
  object KeyLockInfoLabel: TLabel
    Left = 24
    Top = 271
    Width = 489
    Height = 42
    AutoSize = False
    Caption = 'KeyLockInfoLabel'
    WordWrap = True
  end
  object KeyboardLayoutComboBox: TComboBox
    Left = 24
    Top = 75
    Width = 161
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object UseScancodesCheckBox: TCheckBox
    Left = 24
    Top = 25
    Width = 601
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'UseScancodesCheckBox'
    TabOrder = 1
  end
  object NumLockRadioGroup: TRadioGroup
    Left = 24
    Top = 176
    Width = 153
    Height = 89
    Caption = 'NumLockRadioGroup'
    ItemIndex = 0
    Items.Strings = (
      'Do not change'
      'off'
      'on')
    TabOrder = 2
  end
  object CapsLockRadioGroup: TRadioGroup
    Left = 193
    Top = 176
    Width = 153
    Height = 89
    Caption = 'CapsLockRadioGroup'
    ItemIndex = 0
    Items.Strings = (
      'Do not change'
      'off'
      'on')
    TabOrder = 3
  end
  object ScrollLockRadioGroup: TRadioGroup
    Left = 360
    Top = 176
    Width = 153
    Height = 89
    Caption = 'ScrollLockRadioGroup'
    ItemIndex = 0
    Items.Strings = (
      'Do not change'
      'off'
      'on')
    TabOrder = 4
  end
end
