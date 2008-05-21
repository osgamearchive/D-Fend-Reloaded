object WizardPrgFileFrame: TWizardPrgFileFrame
  Left = 0
  Top = 0
  Width = 592
  Height = 450
  TabOrder = 0
  DesignSize = (
    592
    450)
  object InfoLabel: TLabel
    Left = 8
    Top = 16
    Width = 569
    Height = 49
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Bitte geben Sie an, wo sich das zu startende Spiel oder Programm' +
      ' befindet. Wenn Sie die Spieldateien jeweils in den Unterverzeic' +
      'hnissen der angegebenen Verzeichnisse ablegen, kann D-Fend Reloa' +
      'ded mit relativen Pfaden arbeiten.'
    WordWrap = True
  end
  object SetupButton: TSpeedButton
    Tag = 2
    Left = 561
    Top = 151
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
    OnClick = ButtonWork
  end
  object ProgramButton: TSpeedButton
    Tag = 1
    Left = 561
    Top = 104
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
    OnClick = ButtonWork
  end
  object GamesFolderButton: TSpeedButton
    Left = 476
    Top = 203
    Width = 79
    Height = 22
    Anchors = [akTop, akRight]
    Caption = 'Explorer'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      5555555555555555555555555555555555555555555555555555555555555555
      555555555555555555555555555555555555555FFFFFFFFFF555550000000000
      55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
      B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
      000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
      555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
      55555575FFF75555555555700007555555555557777555555555555555555555
      5555555555555555555555555555555555555555555555555555}
    NumGlyphs = 2
    OnClick = ButtonWork
  end
  object BaseInfoLabel3: TLabel
    Left = 8
    Top = 248
    Width = 188
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Zus'#228'tzliche Dateien (Handb'#252'cher usw.)'
    Visible = False
  end
  object BaseDataFolderButton: TSpeedButton
    Tag = 3
    Left = 505
    Top = 335
    Width = 79
    Height = 22
    Anchors = [akTop, akRight]
    Caption = 'Explorer'
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      5555555555555555555555555555555555555555555555555555555555555555
      555555555555555555555555555555555555555FFFFFFFFFF555550000000000
      55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
      B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
      000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
      555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
      55555575FFF75555555555700007555555555557777555555555555555555555
      5555555555555555555555555555555555555555555555555555}
    NumGlyphs = 2
    Visible = False
    OnClick = ButtonWork
  end
  object DataFolderButton: TSpeedButton
    Tag = 4
    Left = 561
    Top = 288
    Width = 23
    Height = 22
    Anchors = [akTop, akRight]
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      5555555555555555555555555555555555555555555555555555555555555555
      555555555555555555555555555555555555555FFFFFFFFFF555550000000000
      55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
      B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
      000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
      555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
      55555575FFF75555555555700007555555555557777555555555555555555555
      5555555555555555555555555555555555555555555555555555}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    Visible = False
    OnClick = ButtonWork
  end
  object Bevel: TBevel
    Left = 3
    Top = 56
    Width = 589
    Height = 18
    Anchors = [akLeft, akTop, akRight]
    Shape = bsBottomLine
  end
  object FolderInfoButton: TSpeedButton
    Left = 561
    Top = 203
    Width = 23
    Height = 22
    Anchors = [akTop, akRight]
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
    OnClick = FolderInfoButtonClick
  end
  object GamesFolderEdit: TLabeledEdit
    Left = 8
    Top = 203
    Width = 462
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 318
    EditLabel.Height = 13
    EditLabel.Caption = 'Empfohlenes '#252'bergeordnetes Verzeichnis f'#252'r das Spieleverzeichnis'
    ReadOnly = True
    TabOrder = 0
  end
  object ProgramEdit: TLabeledEdit
    Left = 8
    Top = 104
    Width = 547
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 118
    EditLabel.Height = 13
    EditLabel.Caption = 'Zu startendes Programm'
    TabOrder = 1
  end
  object SetupEdit: TLabeledEdit
    Left = 8
    Top = 152
    Width = 547
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 129
    EditLabel.Height = 13
    EditLabel.Caption = 'Setup-Programm (optional)'
    TabOrder = 2
  end
  object DataFolderEdit: TLabeledEdit
    Left = 8
    Top = 288
    Width = 547
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 241
    EditLabel.Height = 13
    EditLabel.Caption = 'Verzeichnis mit den zus'#228'tzlichen Dateien (optional)'
    TabOrder = 3
    Visible = False
  end
  object BaseDataFolderEdit: TLabeledEdit
    Left = 8
    Top = 336
    Width = 491
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 354
    EditLabel.Height = 13
    EditLabel.Caption = 
      'Empfohlenes '#252'bergeordnetes Verzeichnis f'#252'r das Zusatzdaten-Verze' +
      'ichnis'
    ReadOnly = True
    TabOrder = 4
    Visible = False
  end
  object DataFolderShowButton: TBitBtn
    Left = 8
    Top = 257
    Width = 217
    Height = 25
    Caption = 'Zus'#228'tzliche Dateien konfigurieren'
    TabOrder = 5
    OnClick = DataFolderShowButtonClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333303333
      333333333337F33333333333333033333333333333373F333333333333090333
      33333333337F7F33333333333309033333333333337373F33333333330999033
      3333333337F337F33333333330999033333333333733373F3333333309999903
      333333337F33337F33333333099999033333333373333373F333333099999990
      33333337FFFF3FF7F33333300009000033333337777F77773333333333090333
      33333333337F7F33333333333309033333333333337F7F333333333333090333
      33333333337F7F33333333333309033333333333337F7F333333333333090333
      33333333337F7F33333333333300033333333333337773333333}
    NumGlyphs = 2
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'exe'
    Left = 456
    Top = 56
  end
end