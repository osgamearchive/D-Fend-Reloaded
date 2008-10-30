object ModernProfileEditorHelperProgramsFrame: TModernProfileEditorHelperProgramsFrame
  Left = 0
  Top = 0
  Width = 693
  Height = 566
  TabOrder = 0
  DesignSize = (
    693
    566)
  object Command1Edit: TLabeledEdit
    Left = 32
    Top = 56
    Width = 633
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 150
    EditLabel.Height = 13
    EditLabel.Caption = 'Command before main program'
    TabOrder = 1
    OnChange = Command1EditChange
  end
  object Command2Edit: TLabeledEdit
    Left = 32
    Top = 192
    Width = 633
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 142
    EditLabel.Height = 13
    EditLabel.Caption = 'Command after main program'
    TabOrder = 5
    OnChange = Command2EditChange
  end
  object Command1CheckBox: TCheckBox
    Left = 16
    Top = 16
    Width = 649
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Execute command before main program'
    TabOrder = 0
  end
  object Command2CheckBox: TCheckBox
    Left = 16
    Top = 153
    Width = 649
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Execute command after main program quits'
    TabOrder = 4
  end
  object RunMinimized1CheckBox: TCheckBox
    Left = 32
    Top = 83
    Width = 633
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Run minimized'
    TabOrder = 2
  end
  object Wait1CheckBox: TCheckBox
    Left = 32
    Top = 106
    Width = 633
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Wait before execution of the main program'
    TabOrder = 3
  end
  object RunMinimized2CheckBox: TCheckBox
    Left = 32
    Top = 219
    Width = 633
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Run minimized'
    TabOrder = 6
  end
end
