object SetupFrameSurface: TSetupFrameSurface
  Left = 0
  Top = 0
  Width = 733
  Height = 589
  TabOrder = 0
  object StartSizeLabel: TLabel
    Left = 16
    Top = 16
    Width = 168
    Height = 13
    Caption = 'Fenstergr'#246#223'e beim Programmstart:'
  end
  object StartSizeComboBox: TComboBox
    Left = 16
    Top = 37
    Width = 233
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 0
    Text = 'Vorgabewerte f'#252'r Fenstergr'#246#223'e'
    Items.Strings = (
      'Vorgabewerte f'#252'r Fenstergr'#246#223'e'
      'Letzte Fenstergr'#246#223'e wiederherstellen'
      'Minimiert starten'
      'Maximiert starten')
  end
end
