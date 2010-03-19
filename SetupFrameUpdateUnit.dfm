object SetupFrameUpdate: TSetupFrameUpdate
  Left = 0
  Top = 0
  Width = 583
  Height = 367
  TabOrder = 0
  DesignSize = (
    583
    367)
  object UpdateLabel: TLabel
    Left = 16
    Top = 132
    Width = 552
    Height = 45
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Bei der Update-Pr'#252'fung werden keine Daten ins Internet '#252'bertrage' +
      'n. Es wird lediglich eine auf SourceForge.net gespeicherte Datei' +
      ' ausgelesen und dann ggf. angeboten, die regul'#228're Update-Datei h' +
      'erunterzuladen.'
    WordWrap = True
  end
  object DataReaderInfoLabel: TLabel
    Left = 16
    Top = 216
    Width = 199
    Height = 13
    Caption = 'Mobygames reader configuration update:'
  end
  object PackagesLabel: TLabel
    Left = 16
    Top = 256
    Width = 102
    Height = 13
    Caption = 'Package lists update:'
  end
  object CheatsLabel: TLabel
    Left = 16
    Top = 294
    Width = 86
    Height = 13
    Caption = 'Cheats database:'
  end
  object Update0RadioButton: TRadioButton
    Left = 12
    Top = 20
    Width = 571
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Nur manuell auf Updates pr'#252'fen (Men'#252': Hilfe|Nach Updates suchen)'
    Checked = True
    TabOrder = 0
    TabStop = True
  end
  object Update1RadioButton: TRadioButton
    Left = 12
    Top = 40
    Width = 571
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Einmal w'#246'chentlich pr'#252'fen'
    TabOrder = 1
  end
  object Update2RadioButton: TRadioButton
    Left = 12
    Top = 60
    Width = 571
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Einmal t'#228'glich pr'#252'fen'
    TabOrder = 2
  end
  object Update3RadioButton: TRadioButton
    Left = 12
    Top = 80
    Width = 571
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Bei jedem Start pr'#252'fen'
    TabOrder = 3
  end
  object UpdateCheckBox: TCheckBox
    Left = 16
    Top = 108
    Width = 550
    Height = 17
    Caption = 'Kennung der aktuellen Version in die Abfrage-URL integrieren'
    TabOrder = 4
  end
  object DataReaderComboBox: TComboBox
    Left = 16
    Top = 231
    Width = 305
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
  end
  object PackagesComboBox: TComboBox
    Left = 16
    Top = 271
    Width = 305
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
  end
  object UpdateButton: TBitBtn
    Left = 16
    Top = 180
    Width = 161
    Height = 25
    Caption = 'Search for updates now'
    TabOrder = 5
    OnClick = ButtonWork
    Glyph.Data = {
      36040000424D3604000000000000360000002800000010000000100000000100
      2000000000000004000000000000000000000000000000000000FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF0010992000D26C1000D26C1000D26C
      1000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF001099200010992000A3D6A700A3D6A700E3B79400E3B7
      9400D26C1000D26C1000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0010992000B1E7BC00B1E7BC00109920004AB25A00D26C1000C55E
      0A00E3B79400E3B79400D26C1000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0010992000BCEDD3005CCC8B004AB25A004AB25A00D26C1000C55E
      0A00C55E0A00E3B79400D26C1000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF0010992000BCEDD3008CD49B004AB25A00E9A04100E9A04100E9A04100D26C
      1000D26C100010992000A3D6A700D26C1000FF00FF00FF00FF00FF00FF00FF00
      FF00D26C1000FAEBD000E9A04100E3B79400E9A04100E9A04100E9A041004AB2
      5A004AB25A004AB25A00A3D6A70010992000FF00FF00FF00FF00FF00FF00FF00
      FF00D26C1000FAEBD000E9A041008CD49B00E9A04100E9A04100E9A041005CCC
      8B005CCC8B004AB25A00A3D6A70010992000FF00FF00FF00FF00FF00FF00FF00
      FF00D26C1000FAEBD000BCEDD300BCEDD3008CD49B00FAEBD000FAEBD0004AB2
      5A005CCC8B005CCC8B00B1E7BC0010992000FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00D26C1000E6F7EC00BCEDD300E6F7EC00458F6300458F6300E6F7
      EC004AB25A00B1E7BC0010992000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF0010992000E6F7EC00FF00FF00458F63005CCC8B004AB25A00458F
      6300E6F7EC00B1E7BC0010992000FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00458F63005CCC8B005CCC8B005CCC8B005CCC
      8B00458F6300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00458F6300458F6300458F63005CCC8B005CCC8B00458F
      6300458F6300458F6300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00458F63005CCC8B005CCC8B00458F
      6300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00458F63005CCC8B004AB25A00458F
      6300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
      FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
  end
  object CheatsComboBox: TComboBox
    Left = 16
    Top = 309
    Width = 305
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 8
  end
end
