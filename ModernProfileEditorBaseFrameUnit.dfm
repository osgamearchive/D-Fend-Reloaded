object ModernProfileEditorBaseFrame: TModernProfileEditorBaseFrame
  Left = 0
  Top = 0
  Width = 598
  Height = 542
  TabOrder = 0
  DesignSize = (
    598
    542)
  object InfoLabel: TLabel
    Left = 36
    Top = 448
    Width = 546
    Height = 81
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = False
    Caption = 'InfoLabel'
    WordWrap = True
  end
  object IconPanel: TPanel
    Left = 20
    Top = 11
    Width = 35
    Height = 35
    TabOrder = 0
    object IconImage: TImage
      Left = 1
      Top = 1
      Width = 33
      Height = 33
      Align = alClient
      ExplicitLeft = 9
      ExplicitTop = 0
    end
  end
  object IconSelectButton: TBitBtn
    Left = 80
    Top = 17
    Width = 153
    Height = 25
    Caption = 'Icon ausw'#228'hlen...'
    TabOrder = 1
    OnClick = IconButtonClick
  end
  object IconDeleteButton: TBitBtn
    Tag = 1
    Left = 239
    Top = 17
    Width = 153
    Height = 25
    Caption = 'Icon l'#246'schen'
    TabOrder = 2
    OnClick = IconButtonClick
  end
  object ProfileNameEdit: TLabeledEdit
    Left = 21
    Top = 80
    Width = 561
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 75
    EditLabel.Height = 13
    EditLabel.Caption = 'ProfileNameEdit'
    TabOrder = 3
    OnChange = ProfileNameEditChange
  end
  object ProfileFileNameEdit: TLabeledEdit
    Left = 20
    Top = 128
    Width = 562
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 91
    EditLabel.Height = 13
    EditLabel.Caption = 'ProfileFileNameEdit'
    ReadOnly = True
    TabOrder = 4
  end
  object GameExeGroup: TGroupBox
    Left = 20
    Top = 168
    Width = 570
    Height = 121
    Anchors = [akLeft, akTop, akRight]
    Caption = 'GameExeGroup'
    TabOrder = 5
    DesignSize = (
      570
      121)
    object GameExeButton: TSpeedButton
      Left = 532
      Top = 45
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
      OnClick = ExeSelectButtonClick
      ExplicitLeft = 431
    end
    object GameExeEdit: TLabeledEdit
      Left = 16
      Top = 45
      Width = 510
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 63
      EditLabel.Height = 13
      EditLabel.Caption = 'GameExeEdit'
      TabOrder = 0
    end
    object GameParameterEdit: TLabeledEdit
      Left = 16
      Top = 89
      Width = 510
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 95
      EditLabel.Height = 13
      EditLabel.Caption = 'GameParameterEdit'
      TabOrder = 1
    end
  end
  object SetupExeGroup: TGroupBox
    Left = 20
    Top = 312
    Width = 570
    Height = 121
    Anchors = [akLeft, akTop, akRight]
    Caption = 'SetupExeGroup'
    TabOrder = 6
    DesignSize = (
      570
      121)
    object SetupExeButton: TSpeedButton
      Tag = 1
      Left = 532
      Top = 45
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
      OnClick = ExeSelectButtonClick
      ExplicitLeft = 431
    end
    object SetupExeEdit: TLabeledEdit
      Left = 16
      Top = 45
      Width = 510
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 64
      EditLabel.Height = 13
      EditLabel.Caption = 'SetupExeEdit'
      TabOrder = 0
    end
    object SetupParameterEdit: TLabeledEdit
      Left = 16
      Top = 89
      Width = 510
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      EditLabel.Width = 96
      EditLabel.Height = 13
      EditLabel.Caption = 'SetupParameterEdit'
      TabOrder = 1
    end
  end
  object OpenDialog: TOpenDialog
    Left = 536
    Top = 15
  end
end
