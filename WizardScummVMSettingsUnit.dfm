object WizardScummVMSettingsFrame: TWizardScummVMSettingsFrame
  Left = 0
  Top = 0
  Width = 592
  Height = 511
  TabOrder = 0
  DesignSize = (
    592
    511)
  object LanguageLabel: TLabel
    Left = 8
    Top = 85
    Width = 72
    Height = 13
    Caption = 'LanguageLabel'
  end
  object InfoLabel: TLabel
    Left = 8
    Top = 16
    Width = 543
    Height = 49
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Bitte geben Sie an, auf welcher Vorlage das neue Profil angelegt' +
      ' werden soll.'
    WordWrap = True
  end
  object Bevel: TBevel
    Left = 3
    Top = 56
    Width = 589
    Height = 18
    Anchors = [akLeft, akTop, akRight]
    Shape = bsBottomLine
  end
  object LanguageInfoLabel: TLabel
    Left = 8
    Top = 176
    Width = 569
    Height = 137
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'LanguageInfoLabel'
    WordWrap = True
  end
  object LanguageComboBox: TComboBox
    Left = 8
    Top = 104
    Width = 105
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object StartFullscreenCheckBox: TCheckBox
    Left = 8
    Top = 144
    Width = 569
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'StartFullscreenCheckBox'
    TabOrder = 1
  end
end
