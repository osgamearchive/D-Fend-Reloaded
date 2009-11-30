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
    Top = 67
    Width = 23
    Height = 22
    Anchors = [akTop, akRight]
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      555555FFFFFFFFFF55555000000000055555577777777775FFFF00B8B8B8B8B0
      0000775F5555555777770B0B8B8B8B8B0FF07F75F555555575F70FB0B8B8B8B8
      B0F07F575FFFFFFFF7F70BFB0000000000F07F557777777777570FBFBF0FFFFF
      FFF07F55557F5FFFFFF70BFBFB0F000000F07F55557F777777570FBFBF0FFFFF
      FFF075F5557F5FFFFFF750FBFB0F000000F0575FFF7F777777575700000FFFFF
      FFF05577777F5FF55FF75555550F00FF00005555557F775577775555550FFFFF
      0F055555557F55557F755555550FFFFF00555555557FFFFF7755555555000000
      0555555555777777755555555555555555555555555555555555}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = GamesListBackgroundButtonClick
  end
  object GamesListFontSizeLabel: TLabel
    Left = 16
    Top = 96
    Width = 59
    Height = 13
    Caption = 'Schriftgr'#246#223'e'
  end
  object GamesListFontColorLabel: TLabel
    Left = 140
    Top = 96
    Width = 61
    Height = 13
    Caption = 'Schriftfarbe:'
  end
  object NoteInTooltipLabel: TLabel
    Left = 32
    Top = 296
    Width = 230
    Height = 13
    Caption = 'Maximale Anzahl an Kommentarzeilen im Tooltip:'
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
    Top = 42
    Width = 129
    Height = 17
    Caption = 'Hintergrundfarbe'
    TabOrder = 1
  end
  object GamesListBackgroundRadioButton3: TRadioButton
    Left = 16
    Top = 67
    Width = 129
    Height = 17
    Caption = 'Hintergrundbild'
    TabOrder = 2
  end
  object GamesListBackgroundColorBox: TColorBox
    Left = 151
    Top = 40
    Width = 130
    Height = 22
    ItemHeight = 16
    TabOrder = 3
    OnChange = GamesListBackgroundColorBoxChange
  end
  object GamesListBackgroundEdit: TEdit
    Left = 151
    Top = 67
    Width = 387
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    OnChange = GamesListBackgroundEditChange
  end
  object GamesListFontSizeEdit: TSpinEdit
    Left = 16
    Top = 110
    Width = 59
    Height = 22
    MaxValue = 48
    MinValue = 1
    TabOrder = 5
    Value = 9
  end
  object GamesListFontColorBox: TColorBox
    Left = 140
    Top = 110
    Width = 130
    Height = 22
    ItemHeight = 16
    TabOrder = 6
  end
  object NotSetGroupBox: TGroupBox
    Left = 16
    Top = 140
    Width = 551
    Height = 46
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Anzeige f'#252'r "Nicht definiert"'
    TabOrder = 7
    DesignSize = (
      551
      46)
    object NotSetRadioButton1: TRadioButton
      Left = 16
      Top = 18
      Width = 130
      Height = 17
      Caption = '"Nicht definiert"'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object NotSetRadioButton2: TRadioButton
      Left = 152
      Top = 18
      Width = 49
      Height = 17
      Caption = '"-"'
      TabOrder = 1
    end
    object NotSetRadioButton3: TRadioButton
      Left = 240
      Top = 18
      Width = 25
      Height = 17
      TabOrder = 2
    end
    object NotSetEdit: TEdit
      Left = 267
      Top = 18
      Width = 270
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      OnChange = NotSetEditChange
    end
  end
  object FavoriteGroupBox: TGroupBox
    Left = 16
    Top = 192
    Width = 551
    Height = 42
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Darstellung der Favoriten'
    TabOrder = 8
    object CheckBoxBold: TCheckBox
      Left = 16
      Top = 17
      Width = 97
      Height = 17
      Caption = 'Fett'
      TabOrder = 0
    end
    object CheckBoxItalic: TCheckBox
      Left = 135
      Top = 16
      Width = 97
      Height = 17
      Caption = 'Kursiv'
      TabOrder = 1
    end
    object CheckBoxUnderline: TCheckBox
      Left = 267
      Top = 16
      Width = 134
      Height = 17
      Caption = 'Unterstrichen'
      TabOrder = 2
    end
  end
  object WindowsExeIconsCheckBox: TCheckBox
    Left = 16
    Top = 250
    Width = 551
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Bei Windows-Profilen Icon aus Programmdatei verwenden'
    TabOrder = 9
  end
  object ShowTooltipsCheckBox: TCheckBox
    Left = 16
    Top = 273
    Width = 551
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Tooltips anzeigen'
    TabOrder = 10
  end
  object NoteInTooltipEdit: TSpinEdit
    Left = 32
    Top = 313
    Width = 57
    Height = 22
    MaxValue = 100
    MinValue = 1
    TabOrder = 11
    Value = 1
  end
  object ImageOpenDialog: TOpenDialog
    DefaultExt = 'jpeg'
    Left = 296
    Top = 22
  end
end
