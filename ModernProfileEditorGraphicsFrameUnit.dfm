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
    Top = 224
    Width = 60
    Height = 13
    Caption = 'RenderLabel'
  end
  object VideoCardLabel: TLabel
    Left = 24
    Top = 280
    Width = 74
    Height = 13
    Caption = 'VideoCardLabel'
  end
  object ScaleLabel: TLabel
    Left = 24
    Top = 336
    Width = 50
    Height = 13
    Caption = 'ScaleLabel'
  end
  object FrameSkipLabel: TLabel
    Left = 408
    Top = 336
    Width = 74
    Height = 13
    Caption = 'FrameSkipLabel'
  end
  object FullscreenInfoLabel: TLabel
    Left = 40
    Top = 90
    Width = 569
    Height = 35
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'FullscreenInfoLabel'
    WordWrap = True
  end
  object WindowResolutionComboBox: TComboBox
    Left = 24
    Top = 32
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object FullscreenResolutionComboBox: TComboBox
    Left = 184
    Top = 32
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
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
    Top = 128
    Width = 577
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'DoublebufferingCheckBox'
    TabOrder = 3
  end
  object KeepAspectRatioCheckBox: TCheckBox
    Left = 24
    Top = 160
    Width = 577
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'KeepAspectRatioCheckBox'
    TabOrder = 4
  end
  object RenderComboBox: TComboBox
    Left = 24
    Top = 243
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
  end
  object VideoCardComboBox: TComboBox
    Left = 24
    Top = 299
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
  end
  object ScaleComboBox: TComboBox
    Left = 24
    Top = 355
    Width = 369
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 8
  end
  object FrameSkipEdit: TSpinEdit
    Left = 408
    Top = 355
    Width = 60
    Height = 22
    MaxValue = 10
    MinValue = 0
    TabOrder = 9
    Value = 0
  end
  object TextModeLinesRadioGroup: TRadioGroup
    Left = 24
    Top = 389
    Width = 169
    Height = 76
    Caption = 'TextModeLinesRadioGroup'
    ItemIndex = 0
    Items.Strings = (
      '25'
      '28'
      '50')
    TabOrder = 10
    Visible = False
  end
  object GlideEmulationCheckBox: TCheckBox
    Left = 24
    Top = 192
    Width = 577
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'GlideEmulationCheckBox'
    TabOrder = 5
    Visible = False
  end
  object VGASettingsGroupBox: TGroupBox
    Left = 208
    Top = 232
    Width = 417
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    Caption = 'VGASettingsGroupBox'
    TabOrder = 11
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
      ItemHeight = 13
      TabOrder = 0
    end
    object VideoRamComboBox: TComboBox
      Left = 167
      Top = 40
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
    end
  end
end
