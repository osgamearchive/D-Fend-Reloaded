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
    Top = 272
    Width = 60
    Height = 13
    Caption = 'RenderLabel'
  end
  object VideoCardLabel: TLabel
    Left = 184
    Top = 272
    Width = 74
    Height = 13
    Caption = 'VideoCardLabel'
  end
  object ScaleLabel: TLabel
    Left = 24
    Top = 328
    Width = 50
    Height = 13
    Caption = 'ScaleLabel'
  end
  object FrameSkipLabel: TLabel
    Left = 424
    Top = 328
    Width = 74
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'FrameSkipLabel'
  end
  object FullscreenInfoLabel: TLabel
    Left = 40
    Top = 138
    Width = 584
    Height = 35
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'FullscreenInfoLabel'
    WordWrap = True
  end
  object PixelShaderLabel: TLabel
    Left = 504
    Top = 328
    Width = 81
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'PixelShaderLabel'
    Visible = False
  end
  object ResolutionInfoLabel: TLabel
    Left = 24
    Top = 59
    Width = 600
    Height = 46
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'ResolutionInfoLabel'
    WordWrap = True
  end
  object GlideEmulationLabel: TLabel
    Left = 24
    Top = 240
    Width = 94
    Height = 13
    Caption = 'GlideEmulationLabel'
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
    Top = 120
    Width = 600
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'StartFullscreenCheckBox'
    TabOrder = 2
  end
  object DoublebufferingCheckBox: TCheckBox
    Left = 24
    Top = 176
    Width = 600
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'DoublebufferingCheckBox'
    TabOrder = 3
  end
  object KeepAspectRatioCheckBox: TCheckBox
    Left = 24
    Top = 208
    Width = 600
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'KeepAspectRatioCheckBox'
    TabOrder = 4
  end
  object RenderComboBox: TComboBox
    Left = 24
    Top = 291
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 6
  end
  object VideoCardComboBox: TComboBox
    Left = 184
    Top = 291
    Width = 284
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 7
  end
  object ScaleComboBox: TComboBox
    Left = 24
    Top = 347
    Width = 377
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 0
    TabOrder = 8
  end
  object FrameSkipEdit: TSpinEdit
    Left = 422
    Top = 347
    Width = 60
    Height = 22
    Anchors = [akTop, akRight]
    MaxValue = 10
    MinValue = 0
    TabOrder = 9
    Value = 0
  end
  object TextModeLinesRadioGroup: TRadioGroup
    Left = 24
    Top = 381
    Width = 169
    Height = 76
    Caption = 'TextModeLinesRadioGroup'
    ItemIndex = 0
    Items.Strings = (
      '25'
      '28'
      '50')
    TabOrder = 11
    Visible = False
  end
  object VGASettingsGroupBox: TGroupBox
    Left = 207
    Top = 381
    Width = 417
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    Caption = 'VGASettingsGroupBox'
    TabOrder = 12
    Visible = False
    DesignSize = (
      417
      105)
    object VGAChipsetLabel: TLabel
      Left = 16
      Top = 26
      Width = 81
      Height = 13
      Caption = 'VGAChipsetLabel'
    end
    object VideoRamLabel: TLabel
      Left = 167
      Top = 26
      Width = 72
      Height = 13
      Caption = 'VideoRamLabel'
    end
    object VGASettingsLabel: TLabel
      Left = 16
      Top = 68
      Width = 385
      Height = 34
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'This settings are only used if video card type is "vga".'
      WordWrap = True
    end
    object VGAChipsetComboBox: TComboBox
      Left = 16
      Top = 40
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 0
    end
    object VideoRamComboBox: TComboBox
      Left = 167
      Top = 40
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 1
    end
  end
  object PixelShaderComboBox: TComboBox
    Left = 504
    Top = 347
    Width = 120
    Height = 21
    Style = csDropDownList
    Anchors = [akTop, akRight]
    ItemHeight = 0
    TabOrder = 10
    Visible = False
    OnChange = PixelShaderComboBoxChange
  end
  object GlideEmulationComboBox: TComboBox
    Left = 184
    Top = 236
    Width = 105
    Height = 21
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 5
  end
end
