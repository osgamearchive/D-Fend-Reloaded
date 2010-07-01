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
  object MIDISelectLabel1: TLabel
    Left = 255
    Top = 179
    Width = 473
    Height = 41
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'If no device is selected, the Windows default MIDI device will b' +
      'e used.'
    WordWrap = True
  end
  object MIDISelectLabel2: TLabel
    Left = 24
    Top = 313
    Width = 713
    Height = 32
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Clicking a device from the list will add it to the additionally ' +
      'MIDI settings field.'
    Visible = False
    WordWrap = True
  end
  object InfoLabel: TLabel
    Left = 200
    Top = 24
    Width = 528
    Height = 69
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'The MIDI device will be available on address 330 and interrupt 2' +
      ' in DOSBox.'
    WordWrap = True
  end
  object TypeComboBox: TComboBox
    Left = 24
    Top = 43
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object DeviceComboBox: TComboBox
    Left = 24
    Top = 99
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
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
  object MIDISelectButton: TButton
    Left = 24
    Top = 179
    Width = 225
    Height = 25
    Caption = 'Select MIDI device from device manager'
    TabOrder = 3
    OnClick = MIDISelectButtonClick
  end
  object MIDISelectListBox: TListBox
    Left = 24
    Top = 210
    Width = 225
    Height = 97
    ItemHeight = 13
    TabOrder = 4
    Visible = False
    OnClick = MIDISelectListBoxClick
  end
end
