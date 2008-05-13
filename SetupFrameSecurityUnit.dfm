object SetupFrameSecurity: TSetupFrameSecurity
  Left = 0
  Top = 0
  Width = 653
  Height = 240
  TabOrder = 0
  DesignSize = (
    653
    240)
  object DeleteProectionLabel: TLabel
    Left = 40
    Top = 88
    Width = 601
    Height = 57
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Diese Option stellt sicher, dass auch beim L'#246'schen von falsch ko' +
      'nfigurierten Profilen niemals Dateien, die nicht zu D-Fend geh'#246'r' +
      'en, gel'#246'scht werden k'#246'nnen.'
    WordWrap = True
    ExplicitWidth = 545
  end
  object UseChecksumsLabel: TLabel
    Left = 40
    Top = 167
    Width = 601
    Height = 58
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Sowohl '#252'ber die Programmdatei wie auch (sofern vorhanden) '#252'ber d' +
      'ie Setupdatei wird jeweils eine Pr'#252'fsumme berechnet und im Profi' +
      'l gespeichert. Mit Hilfe dieser Pr'#252'fsumme kann festgestellt werd' +
      'en, ob ein importiertes Profil '#252'berhaupt f'#252'r ein vorliegende Spi' +
      'el gedacht war und ob sich Programmdateien ver'#228'ndert haben.'
    WordWrap = True
  end
  object AskBeforeDeleteCheckBox: TCheckBox
    Left = 16
    Top = 24
    Width = 625
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Vor dem L'#246'schen von Eintr'#228'gen nachfragen'
    TabOrder = 0
  end
  object DeleteProectionCheckBox: TCheckBox
    Left = 16
    Top = 64
    Width = 625
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Niemals Dateien au'#223'erhalb des Basis-Verzeichnisses l'#246'schen'
    TabOrder = 1
  end
  object UseChecksumsCheckBox: TCheckBox
    Left = 16
    Top = 144
    Width = 569
    Height = 17
    Caption = 'DOS-Programmdateien per Pr'#252'fsumme auf '#196'nderungen '#252'berpr'#252'fen'
    TabOrder = 2
  end
end
