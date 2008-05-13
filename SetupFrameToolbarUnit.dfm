object SetupFrameToolbar: TSetupFrameToolbar
  Left = 0
  Top = 0
  Width = 685
  Height = 505
  TabOrder = 0
  DesignSize = (
    685
    505)
  object AddButtonFunctionLabel: TLabel
    Left = 193
    Top = 113
    Width = 183
    Height = 13
    Caption = 'Funktion der Hinzuf'#252'gen-Schaltfl'#228'che:'
  end
  object ToolbarImageButton: TSpeedButton
    Tag = 9
    Left = 650
    Top = 198
    Width = 23
    Height = 22
    Anchors = [akTop, akRight]
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
      333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
      0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
      07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
      07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
      0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
      33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
      B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
      3BB33773333773333773B333333B3333333B7333333733333337}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = ToolbarImageButtonClick
  end
  object ToolbarFontSizeLabel: TLabel
    Left = 15
    Top = 237
    Width = 59
    Height = 13
    Caption = 'Schriftgr'#246#223'e'
  end
  object ButtonsLabel: TLabel
    Left = 16
    Top = 47
    Width = 92
    Height = 13
    Caption = 'Sichtbare Symbole:'
  end
  object AddButtonFunctionComboBox: TComboBox
    Left = 193
    Top = 132
    Width = 233
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 2
    TabOrder = 3
    Text = 'Auswahlmen'#252
    Items.Strings = (
      'Hinzuf'#252'gen-Dialog'
      'Assistent'
      'Auswahlmen'#252)
  end
  object ShowToolbarCheckBox: TCheckBox
    Left = 16
    Top = 17
    Width = 657
    Height = 17
    Caption = 'Symbolleiste anzeigen'
    TabOrder = 0
  end
  object ShowToolbarCaptionsCheckBox: TCheckBox
    Left = 193
    Top = 74
    Width = 480
    Height = 17
    Caption = 'Beschriftungen der Symbolleiste anzeigen'
    TabOrder = 2
  end
  object ToolbarImageEdit: TEdit
    Left = 152
    Top = 199
    Width = 492
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    OnChange = ToolbarImageEditChange
  end
  object ToolbarImageCheckBox: TCheckBox
    Left = 16
    Top = 203
    Width = 130
    Height = 17
    Caption = 'Hintergrundbild'
    TabOrder = 5
  end
  object ToolbarFontSizeEdit: TSpinEdit
    Left = 15
    Top = 256
    Width = 59
    Height = 22
    MaxValue = 48
    MinValue = 1
    TabOrder = 6
    Value = 9
  end
  object ButtonsListBox: TCheckListBox
    Left = 16
    Top = 66
    Width = 161
    Height = 119
    ItemHeight = 13
    TabOrder = 1
  end
  object ImageOpenDialog: TOpenDialog
    DefaultExt = 'jpeg'
    Left = 480
    Top = 134
  end
end
