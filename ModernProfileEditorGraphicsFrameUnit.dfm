object ModernProfileEditorGraphicsFrame: TModernProfileEditorGraphicsFrame
  Left = 0
  Top = 0
  Width = 640
  Height = 537
  TabOrder = 0
  DesignSize = (
    640
    537)
  object WindowResolutionLabel: TLabel
    Left = 24
    Top = 13
    Width = 113
    Height = 13
    Caption = 'WindowResolutionLabel'
  end
  object FullscreenResolutionLabel: TLabel
    Left = 184
    Top = 13
    Width = 123
    Height = 13
    Caption = 'FullscreenResolutionLabel'
  end
  object RenderLabel: TLabel
    Left = 24
    Top = 176
    Width = 60
    Height = 13
    Caption = 'RenderLabel'
  end
  object VideoCardLabel: TLabel
    Left = 24
    Top = 232
    Width = 74
    Height = 13
    Caption = 'VideoCardLabel'
  end
  object ScaleLabel: TLabel
    Left = 24
    Top = 288
    Width = 50
    Height = 13
    Caption = 'ScaleLabel'
  end
  object FrameSkipLabel: TLabel
    Left = 24
    Top = 344
    Width = 74
    Height = 13
    Caption = 'FrameSkipLabel'
  end
  object WindowResolutionComboBox: TComboBox
    Left = 24
    Top = 32
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 0
  end
  object FullscreenResolutionComboBox: TComboBox
    Left = 184
    Top = 32
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 1
  end
  object StartFullscreenCheckBox: TCheckBox
    Left = 24
    Top = 72
    Width = 577
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'StartFullscreenCheckBox'
    TabOrder = 2
  end
  object DoublebufferingCheckBox: TCheckBox
    Left = 24
    Top = 104
    Width = 577
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'DoublebufferingCheckBox'
    TabOrder = 3
  end
  object KeepAspectRatioCheckBox: TCheckBox
    Left = 24
    Top = 136
    Width = 577
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'KeepAspectRatioCheckBox'
    TabOrder = 4
  end
  object RenderComboBox: TComboBox
    Left = 24
    Top = 195
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 5
  end
  object VideoCardComboBox: TComboBox
    Left = 24
    Top = 251
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 6
  end
  object ScaleComboBox: TComboBox
    Left = 24
    Top = 307
    Width = 369
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 7
  end
  object FrameSkipEdit: TSpinEdit
    Left = 24
    Top = 363
    Width = 60
    Height = 22
    MaxValue = 10
    MinValue = 0
    TabOrder = 8
    Value = 0
  end
  object TextModeLinesRadioGroup: TRadioGroup
    Left = 24
    Top = 405
    Width = 169
    Height = 76
    Caption = 'TextModeLinesRadioGroup'
    ItemIndex = 0
    Items.Strings = (
      '25'
      '28'
      '50')
    TabOrder = 9
    Visible = False
  end
end
