object SetupFrameUpdate: TSetupFrameUpdate
  Left = 0
  Top = 0
  Width = 583
  Height = 240
  TabOrder = 0
  DesignSize = (
    583
    240)
  object UpdateLabel: TLabel
    Left = 16
    Top = 135
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
    ExplicitWidth = 550
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
    ExplicitWidth = 569
  end
  object Update1RadioButton: TRadioButton
    Left = 12
    Top = 40
    Width = 571
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Einmal w'#246'chentlich pr'#252'fen'
    TabOrder = 1
    ExplicitWidth = 569
  end
  object Update2RadioButton: TRadioButton
    Left = 12
    Top = 60
    Width = 571
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Einmal t'#228'glich pr'#252'fen'
    TabOrder = 2
    ExplicitWidth = 569
  end
  object Update3RadioButton: TRadioButton
    Left = 12
    Top = 80
    Width = 571
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Bei jedem Start pr'#252'fen'
    TabOrder = 3
    ExplicitWidth = 569
  end
  object UpdateCheckBox: TCheckBox
    Left = 16
    Top = 108
    Width = 550
    Height = 17
    Caption = 'Kennung der aktuellen Version in die Abfrage-URL integrieren'
    TabOrder = 4
  end
end
