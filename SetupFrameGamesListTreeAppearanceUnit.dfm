object SetupFrameGamesListTreeAppearance: TSetupFrameGamesListTreeAppearance
  Left = 0
  Top = 0
  Width = 574
  Height = 324
  TabOrder = 0
  DesignSize = (
    574
    324)
  object TreeViewFontSizeLabel: TLabel
    Left = 16
    Top = 88
    Width = 59
    Height = 13
    Caption = 'Schriftgr'#246#223'e'
  end
  object TreeViewFontColorLabel: TLabel
    Left = 140
    Top = 88
    Width = 61
    Height = 13
    Caption = 'Schriftfarbe:'
  end
  object TreeViewGroupsLabel: TLabel
    Left = 16
    Top = 144
    Width = 137
    Height = 13
    Caption = 'Benutzerdefinierte Gruppen:'
  end
  object TreeViewGroupsInfoLabel: TLabel
    Left = 16
    Top = 247
    Width = 537
    Height = 73
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = False
    Caption = 
      'Die benutzerdefinierten Gruppen werden in der Baumstruktur als w' +
      'eitere Filterkategorien angeboten. Bei den Spielen k'#246'nnen Werte ' +
      'f'#252'r die Kategorien '#252'ber die "Benutzerdefinierten Informationen" ' +
      'definiert werden.'
    WordWrap = True
  end
  object TreeViewBackgroundRadioButton1: TRadioButton
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
  object TreeViewBackgroundRadioButton2: TRadioButton
    Left = 16
    Top = 48
    Width = 129
    Height = 17
    Caption = 'Hintergrundfarbe'
    TabOrder = 1
  end
  object TreeViewBackgroundColorBox: TColorBox
    Left = 151
    Top = 46
    Width = 130
    Height = 22
    ItemHeight = 16
    TabOrder = 2
    OnChange = TreeViewBackgroundColorBoxChange
  end
  object TreeViewFontSizeEdit: TSpinEdit
    Left = 16
    Top = 107
    Width = 59
    Height = 22
    MaxValue = 48
    MinValue = 1
    TabOrder = 3
    Value = 9
  end
  object TreeViewFontColorBox: TColorBox
    Left = 140
    Top = 107
    Width = 130
    Height = 22
    ItemHeight = 16
    TabOrder = 4
  end
  object TreeViewGroupsEdit: TMemo
    Left = 16
    Top = 163
    Width = 161
    Height = 78
    TabOrder = 5
  end
  object UserKeysList: TBitBtn
    Left = 183
    Top = 161
    Width = 178
    Height = 25
    Caption = 'Existierende Benutzerschl'#252'ssel'
    TabOrder = 6
    OnClick = UserKeysListClick
  end
  object PopupMenu: TPopupMenu
    Left = 184
    Top = 192
  end
end
