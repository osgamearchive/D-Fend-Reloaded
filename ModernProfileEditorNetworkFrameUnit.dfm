object ModernProfileEditorNetworkFrame: TModernProfileEditorNetworkFrame
  Left = 0
  Top = 0
  Width = 462
  Height = 345
  TabOrder = 0
  DesignSize = (
    462
    345)
  object PortLabel: TLabel
    Left = 24
    Top = 232
    Width = 45
    Height = 13
    Caption = 'PortLabel'
  end
  object ActivateCheckBox: TCheckBox
    Left = 24
    Top = 24
    Width = 401
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'ActivateCheckBox'
    TabOrder = 0
    OnClick = ActivateCheckBoxClick
  end
  object ConnectionsRadioGroup: TRadioGroup
    Left = 24
    Top = 64
    Width = 185
    Height = 89
    Caption = 'ConnectionsRadioGroup'
    Items.Strings = (
      'None'
      'Client'
      'Server')
    TabOrder = 1
    OnClick = ActivateCheckBoxClick
  end
  object ServerAddressEdit: TLabeledEdit
    Left = 24
    Top = 192
    Width = 417
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 89
    EditLabel.Height = 13
    EditLabel.Caption = 'ServerAddressEdit'
    TabOrder = 2
  end
  object PortEdit: TSpinEdit
    Left = 24
    Top = 251
    Width = 73
    Height = 22
    MaxValue = 65535
    MinValue = 1
    TabOrder = 3
    Value = 1
  end
end
