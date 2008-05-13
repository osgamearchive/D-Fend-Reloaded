object WizardBaseFrame: TWizardBaseFrame
  Left = 0
  Top = 0
  Width = 592
  Height = 600
  TabOrder = 0
  DesignSize = (
    592
    600)
  object InfoLabel: TLabel
    Left = 8
    Top = 16
    Width = 571
    Height = 49
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Bitte geben Sie den Namen f'#252'r das Spiel oder das Programm, f'#252'r w' +
      'elches Sie ein neues Profil anlegen m'#246'chten, an. Dieser Name wir' +
      'd in der Spieleauswahlliste f'#252'r dieses Profil angezeigt werden. ' +
      'Sie k'#246'nnen den Profilnamen sp'#228'ter jeder Zeit '#252'ber den Profiledit' +
      'or '#228'ndern.'
    WordWrap = True
  end
  object Bevel: TBevel
    Left = 3
    Top = 56
    Width = 589
    Height = 18
    Anchors = [akLeft, akTop, akRight]
    Shape = bsBottomLine
  end
  object BaseName: TLabeledEdit
    Left = 8
    Top = 104
    Width = 571
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 140
    EditLabel.Height = 13
    EditLabel.Caption = 'Name des Programms / Spiels'
    TabOrder = 0
  end
  object EmulationTypeRadioGroup: TRadioGroup
    Left = 8
    Top = 144
    Width = 571
    Height = 57
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Emulationstyp'
    ItemIndex = 0
    Items.Strings = (
      'DOSBox (erm'#246'glicht die Ausf'#252'hrung beliebiger DOS-Programme)'
      'Scumm-basierendes Adventure')
    TabOrder = 1
    Visible = False
  end
  object ListScummGamesButton: TBitBtn
    Left = 8
    Top = 216
    Width = 353
    Height = 25
    Caption = 'Liste der der unterst'#252'tzten Scumm-Spiele anzeigen'
    TabOrder = 2
    Visible = False
    WordWrap = True
    OnClick = ButtonWork
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      33333FFFFFFFFFFFFFFF000000000000000077777777777777770FFFFFFFFFFF
      FFF07F3FF3FF3FF3FFF70F00F00F00F000F07F773773773777370FFFFFFFFFFF
      FFF07F3FF3FF3FF3FFF70F00F00F00F000F07F773773773777370FFFFFFFFFFF
      FFF07F3FF3FF3FF3FFF70F00F00F00F000F07F773773773777370FFFFFFFFFFF
      FFF07F3FF3FF3FF3FFF70F00F00F00F000F07F773773773777370FFFFFFFFFFF
      FFF07FFFFFFFFFFFFFF70CCCCCCCCCCCCCC07777777777777777088CCCCCCCCC
      C8807FF7777777777FF700000000000000007777777777777777333333333333
      3333333333333333333333333333333333333333333333333333}
    NumGlyphs = 2
  end
  object ShowInfoButton: TBitBtn
    Tag = 1
    Left = 8
    Top = 247
    Width = 353
    Height = 25
    Caption = 'Informationen zur D-Fend Reloaded Dateistruktur'
    TabOrder = 3
    WordWrap = True
    OnClick = ButtonWork
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333FFFFF3333333333F797F3333333333F737373FF333333BFB999BFB
      33333337737773773F3333BFBF797FBFB33333733337333373F33BFBFBFBFBFB
      FB3337F33333F33337F33FBFBFB9BFBFBF3337333337F333373FFBFBFBF97BFB
      FBF37F333337FF33337FBFBFBFB99FBFBFB37F3333377FF3337FFBFBFBFB99FB
      FBF37F33333377FF337FBFBF77BF799FBFB37F333FF3377F337FFBFB99FB799B
      FBF373F377F3377F33733FBF997F799FBF3337F377FFF77337F33BFBF99999FB
      FB33373F37777733373333BFBF999FBFB3333373FF77733F7333333BFBFBFBFB
      3333333773FFFF77333333333FBFBF3333333333377777333333}
    NumGlyphs = 2
  end
end
