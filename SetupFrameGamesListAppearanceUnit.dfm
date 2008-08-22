object SetupFrameGamesListAppearance: TSetupFrameGamesListAppearance
  Left = 0
  Top = 0
  Width = 576
  Height = 394
  TabOrder = 0
  DesignSize = (
    576
    394)
  object GamesListBackgroundButton: TSpeedButton
    Tag = 7
    Left = 544
    Top = 77
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
    OnClick = GamesListBackgroundButtonClick
  end
  object GamesListFontSizeLabel: TLabel
    Left = 16
    Top = 120
    Width = 59
    Height = 13
    Caption = 'Schriftgr'#246#223'e'
  end
  object GamesListFontColorLabel: TLabel
    Left = 140
    Top = 120
    Width = 61
    Height = 13
    Caption = 'Schriftfarbe:'
  end
  object GamesListBackgroundRadioButton1: TRadioButton
    Left = 16
    Top = 16
    Width = 551
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Standard Hintergrundfarbe'
    Checked = True
    TabOrder = 0
    TabStop = True
  end
  object GamesListBackgroundRadioButton2: TRadioButton
    Left = 16
    Top = 48
    Width = 129
    Height = 17
    Caption = 'Hintergrundfarbe'
    TabOrder = 1
  end
  object GamesListBackgroundRadioButton3: TRadioButton
    Left = 16
    Top = 80
    Width = 129
    Height = 17
    Caption = 'Hintergrundbild'
    TabOrder = 2
  end
  object GamesListBackgroundColorBox: TColorBox
    Left = 151
    Top = 46
    Width = 130
    Height = 22
    ItemHeight = 16
    TabOrder = 3
    OnChange = GamesListBackgroundColorBoxChange
  end
  object GamesListBackgroundEdit: TEdit
    Left = 151
    Top = 78
    Width = 387
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    OnChange = GamesListBackgroundEditChange
  end
  object GamesListFontSizeEdit: TSpinEdit
    Left = 16
    Top = 136
    Width = 59
    Height = 22
    MaxValue = 48
    MinValue = 1
    TabOrder = 5
    Value = 9
  end
  object GamesListFontColorBox: TColorBox
    Left = 140
    Top = 136
    Width = 130
    Height = 22
    ItemHeight = 16
    TabOrder = 6
  end
  object NotSetGroupBox: TGroupBox
    Left = 16
    Top = 172
    Width = 551
    Height = 60
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Anzeige f'#252'r "Nicht definiert"'
    TabOrder = 7
    DesignSize = (
      551
      60)
    object NotSetRadioButton1: TRadioButton
      Left = 16
      Top = 26
      Width = 130
      Height = 17
      Caption = '"Nicht definiert"'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object NotSetRadioButton2: TRadioButton
      Left = 152
      Top = 26
      Width = 49
      Height = 17
      Caption = '"-"'
      TabOrder = 1
    end
    object NotSetRadioButton3: TRadioButton
      Left = 240
      Top = 26
      Width = 25
      Height = 17
      TabOrder = 2
    end
    object NotSetEdit: TEdit
      Left = 267
      Top = 26
      Width = 270
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      OnChange = NotSetEditChange
    end
  end
  object FavoriteGroupBox: TGroupBox
    Left = 16
    Top = 238
    Width = 551
    Height = 59
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Darstellung der Favoriten'
    TabOrder = 8
    object CheckBoxBold: TCheckBox
      Left = 16
      Top = 25
      Width = 97
      Height = 17
      Caption = 'Fett'
      TabOrder = 0
    end
    object CheckBoxItalic: TCheckBox
      Left = 135
      Top = 24
      Width = 97
      Height = 17
      Caption = 'Kursiv'
      TabOrder = 1
    end
    object CheckBoxUnderline: TCheckBox
      Left = 267
      Top = 24
      Width = 134
      Height = 17
      Caption = 'Unterstrichen'
      TabOrder = 2
    end
  end
  object GridLinesCheckBox: TCheckBox
    Left = 16
    Top = 312
    Width = 551
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Gitterlinien im Ansichtsmodus "Details" anzeigen'
    TabOrder = 9
    Visible = False
  end
  object ImageOpenDialog: TOpenDialog
    DefaultExt = 'jpeg'
    Left = 296
    Top = 22
  end
end
