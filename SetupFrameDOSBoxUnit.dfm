object SetupFrameDOSBox: TSetupFrameDOSBox
  Left = 0
  Top = 0
  Width = 660
  Height = 385
  TabOrder = 0
  DesignSize = (
    660
    385)
  object DosBoxButton: TSpeedButton
    Tag = 3
    Left = 594
    Top = 32
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
    OnClick = ButtonWork
    ExplicitLeft = 538
  end
  object FindDosBoxButton: TSpeedButton
    Tag = 4
    Left = 621
    Top = 32
    Width = 23
    Height = 22
    Anchors = [akTop, akRight]
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333FF33333333333330003FF3FFFFF3333777003000003333
      300077F777773F333777E00BFBFB033333337773333F7F33333FE0BFBF000333
      330077F3337773F33377E0FBFBFBF033330077F3333FF7FFF377E0BFBF000000
      333377F3337777773F3FE0FBFBFBFBFB039977F33FFFFFFF7377E0BF00000000
      339977FF777777773377000BFB03333333337773FF733333333F333000333333
      3300333777333333337733333333333333003333333333333377333333333333
      333333333333333333FF33333333333330003333333333333777333333333333
      3000333333333333377733333333333333333333333333333333}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonWork
    ExplicitLeft = 565
  end
  object DosBoxMapperButton: TSpeedButton
    Tag = 5
    Left = 594
    Top = 76
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
    OnClick = ButtonWork
  end
  object SDLVideodriverLabel: TLabel
    Left = 16
    Top = 178
    Width = 83
    Height = 13
    Caption = 'SDL Videotreiber:'
  end
  object SDLVideodriverInfoLabel: TLabel
    Left = 16
    Top = 220
    Width = 628
    Height = 50
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Falls es nicht per Keymapper behebbare Probleme mit der Tastatur' +
      'belegung gibt, so kann das Umschalten auf "Win DIB" helfen.'
    WordWrap = True
  end
  object DOSBoxDownloadURLInfo: TLabel
    Left = 16
    Top = 271
    Width = 154
    Height = 13
    Caption = 'You can download DOSBox from'
  end
  object DOSBoxDownloadURL: TLabel
    Left = 16
    Top = 290
    Width = 105
    Height = 13
    Caption = 'DOSBoxDownloadURL'
    OnClick = DOSBoxDownloadURLClick
  end
  object DosBoxDirEdit: TLabeledEdit
    Left = 16
    Top = 32
    Width = 572
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 67
    EditLabel.Height = 13
    EditLabel.Caption = 'DosBoxDirEdit'
    TabOrder = 0
    OnChange = DosBoxDirEditChange
  end
  object HideDosBoxConsoleCheckBox: TCheckBox
    Left = 16
    Top = 104
    Width = 628
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'DosBox-Console ausblenden'
    TabOrder = 2
  end
  object MinimizeDFendCheckBox: TCheckBox
    Left = 16
    Top = 127
    Width = 628
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'D-Fend Reloaded minimieren, wenn DOSBox gestartet wird'
    TabOrder = 3
  end
  object DosBoxMapperEdit: TLabeledEdit
    Left = 16
    Top = 76
    Width = 572
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 90
    EditLabel.Height = 13
    EditLabel.Caption = 'DosBoxMapperEdit'
    TabOrder = 1
  end
  object SDLVideoDriverComboBox: TComboBox
    Left = 16
    Top = 193
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 5
    Text = 'Direct X (default)'
    Items.Strings = (
      'Direct X (default)'
      'Win DIB')
  end
  object CenterDOSBoxCheckBox: TCheckBox
    Left = 16
    Top = 150
    Width = 572
    Height = 17
    Caption = 'CenterDOSBoxCheckBox'
    TabOrder = 4
  end
  object UseShortPathNamesCheckBox: TCheckBox
    Left = 16
    Top = 309
    Width = 628
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Use short path names for mount commands'
    TabOrder = 6
    Visible = False
  end
  object RestoreWindowCheckBox: TCheckBox
    Left = 16
    Top = 329
    Width = 628
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Restore program window when DOSBox is closed'
    TabOrder = 7
    Visible = False
  end
  object DosBoxTxtOpenDialog: TOpenDialog
    DefaultExt = 'txt'
    Left = 120
    Top = 7
  end
end
