object WizardBaseFrame: TWizardBaseFrame
  Left = 0
  Top = 0
  Width = 592
  Height = 600
  TabOrder = 0
  DesignSize = (
    592
    600)
  object InfoLabel: TLabel
    Left = 8
    Top = 16
    Width = 571
    Height = 49
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Please choose the type of profile you want to create.'
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
  object EmulationTypeLabel: TLabel
    Left = 8
    Top = 87
    Width = 95
    Height = 13
    Caption = 'EmulationTypeLabel'
    FocusControl = EmulationTypeComboBox
  end
  object WizardModeLabel: TLabel
    Left = 8
    Top = 148
    Width = 84
    Height = 13
    Caption = 'WizardModeLabel'
    FocusControl = WizardModeComboBox
  end
  object ListScummGamesLabel: TLabel
    Left = 8
    Top = 240
    Width = 151
    Height = 13
    Caption = 'List of supported Scumm games'
    OnClick = ButtonWork
  end
  object ShowInfoLabel: TLabel
    Tag = 1
    Left = 8
    Top = 264
    Width = 256
    Height = 13
    Caption = 'Information about the D-Fend Reloaded file structure'
    OnClick = ButtonWork
  end
  object EmulationTypeComboBox: TComboBox
    Left = 8
    Top = 103
    Width = 571
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 0
    Text = 'DOSBox (erm'#246'glicht die Ausf'#252'hrung beliebiger DOS-Programme)'
    Items.Strings = (
      'DOSBox (erm'#246'glicht die Ausf'#252'hrung beliebiger DOS-Programme)'
      'Scumm-basierendes Adventure'
      'Windows-Spiel')
  end
  object WizardModeComboBox: TComboBox
    Left = 8
    Top = 164
    Width = 571
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    ItemIndex = 1
    TabOrder = 1
    Text = 
      'Only setup game automatically if matching auto setup template ex' +
      'ists'
    Items.Strings = (
      'Always setup game automatically'
      
        'Only setup game automatically if matching auto setup template ex' +
        'ists'
      'Always show all setup pages of this wizard')
  end
end
