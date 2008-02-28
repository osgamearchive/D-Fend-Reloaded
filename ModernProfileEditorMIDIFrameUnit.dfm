object ModernProfileEditorMIDIFrame: TModernProfileEditorMIDIFrame
  Left = 0
  Top = 0
  Width = 760
  Height = 578
  TabOrder = 0
  DesignSize = (
    760
    578)
  object TypeLabel: TLabel
    Left = 24
    Top = 24
    Width = 49
    Height = 13
    Caption = 'TypeLabel'
  end
  object DeviceLabel: TLabel
    Left = 24
    Top = 80
    Width = 57
    Height = 13
    Caption = 'DeviceLabel'
  end
  object TypeComboBox: TComboBox
    Left = 24
    Top = 43
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 0
  end
  object DeviceComboBox: TComboBox
    Left = 24
    Top = 99
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 1
  end
  object AdditionalSettingsEdit: TLabeledEdit
    Left = 24
    Top = 152
    Width = 713
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 104
    EditLabel.Height = 13
    EditLabel.Caption = 'AdditionalSettingsEdit'
    TabOrder = 2
  end
end
