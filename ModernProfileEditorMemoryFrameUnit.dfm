object ModernProfileEditorMemoryFrame: TModernProfileEditorMemoryFrame
  Left = 0
  Top = 0
  Width = 447
  Height = 427
  TabOrder = 0
  DesignSize = (
    447
    427)
  object MemoryLabel: TLabel
    Left = 24
    Top = 16
    Width = 63
    Height = 13
    Caption = 'MemoryLabel'
  end
  object LoadFixLabel: TLabel
    Left = 42
    Top = 213
    Width = 62
    Height = 13
    Caption = 'LoadFixLabel'
  end
  object DOS32AInfoLabel: TLabel
    Left = 38
    Top = 311
    Width = 387
    Height = 98
    AutoSize = False
    Caption = 'DOS32AInfoLabel'
    WordWrap = True
  end
  object MemoryEdit: TSpinEdit
    Left = 24
    Top = 32
    Width = 49
    Height = 22
    MaxValue = 63
    MinValue = 1
    TabOrder = 0
    Value = 32
  end
  object XMSCheckBox: TCheckBox
    Left = 24
    Top = 72
    Width = 401
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'XMSCheckBox'
    TabOrder = 1
  end
  object EMSCheckBox: TCheckBox
    Left = 24
    Top = 104
    Width = 401
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'EMSCheckBox'
    TabOrder = 2
  end
  object UMBCheckBox: TCheckBox
    Left = 24
    Top = 136
    Width = 401
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'UMBCheckBox'
    TabOrder = 3
  end
  object LoadFixCheckBox: TCheckBox
    Left = 24
    Top = 184
    Width = 401
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'LoadFixCheckBox'
    TabOrder = 4
  end
  object LoadFixEdit: TSpinEdit
    Left = 42
    Top = 232
    Width = 45
    Height = 22
    MaxValue = 512
    MinValue = 1
    TabOrder = 5
    Value = 64
  end
  object DOS32ACheckBox: TCheckBox
    Left = 24
    Top = 288
    Width = 401
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'DOS32ACheckBox'
    TabOrder = 6
  end
end
