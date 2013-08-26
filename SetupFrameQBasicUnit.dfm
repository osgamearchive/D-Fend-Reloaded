object SetupFrameQBasic: TSetupFrameQBasic
  Left = 0
  Top = 0
  Width = 657
  Height = 210
  TabOrder = 0
  DesignSize = (
    657
    210)
  object QBasicButton: TSpeedButton
    Tag = 19
    Left = 602
    Top = 32
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
    ExplicitLeft = 538
  end
  object FindQBasicButton: TSpeedButton
    Tag = 20
    Left = 631
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
    ExplicitLeft = 567
  end
  object QBasicDownloadURLInfo: TLabel
    Left = 16
    Top = 120
    Width = 147
    Height = 13
    Caption = 'You can download QBasic from'
    Visible = False
  end
  object QBasicDownloadURL: TLabel
    Left = 16
    Top = 139
    Width = 98
    Height = 13
    Caption = 'QBasicDownloadURL'
    Visible = False
    OnClick = QBasicDownloadURLClick
  end
  object QBasicEdit: TLabeledEdit
    Left = 16
    Top = 32
    Width = 580
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 50
    EditLabel.Height = 13
    EditLabel.Caption = 'QBasicEdit'
    TabOrder = 0
  end
  object QBasicParamEdit: TLabeledEdit
    Left = 16
    Top = 82
    Width = 580
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 80
    EditLabel.Height = 13
    EditLabel.Caption = 'QBasicParamEdit'
    TabOrder = 1
  end
  object PrgOpenDialog: TOpenDialog
    DefaultExt = 'exe'
    Left = 224
    Top = 7
  end
end
