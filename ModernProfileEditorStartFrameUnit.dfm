object ModernProfileEditorStartFrame: TModernProfileEditorStartFrame
  Left = 0
  Top = 0
  Width = 518
  Height = 478
  TabOrder = 0
  DesignSize = (
    518
    478)
  object AutoexecBootFloppyImageInfoLabel: TLabel
    Left = 52
    Top = 418
    Width = 194
    Height = 42
    Anchors = [akLeft, akBottom]
    AutoSize = False
    Caption = 'AutoexecBootFloppyImageInfoLabel'
    WordWrap = True
    ExplicitTop = 427
  end
  object AutoexecBootFloppyImageButton: TSpeedButton
    Tag = 3
    Left = 485
    Top = 391
    Width = 23
    Height = 22
    Anchors = [akRight, akBottom]
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
    ExplicitLeft = 510
    ExplicitTop = 400
  end
  object AutoexecBootFloppyImageAddButton: TSpeedButton
    Tag = 4
    Left = 485
    Top = 419
    Width = 23
    Height = 22
    Anchors = [akRight, akBottom]
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      33333333FF33333333FF333993333333300033377F3333333777333993333333
      300033F77FFF3333377739999993333333333777777F3333333F399999933333
      33003777777333333377333993333333330033377F3333333377333993333333
      3333333773333333333F333333333333330033333333F33333773333333C3333
      330033333337FF3333773333333CC333333333FFFFF77FFF3FF33CCCCCCCCCC3
      993337777777777F77F33CCCCCCCCCC3993337777777777377333333333CC333
      333333333337733333FF3333333C333330003333333733333777333333333333
      3000333333333333377733333333333333333333333333333333}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonWork
    ExplicitLeft = 510
    ExplicitTop = 428
  end
  object AutoexecBootFloppyImageDelButton: TSpeedButton
    Tag = 5
    Left = 485
    Top = 443
    Width = 23
    Height = 22
    Anchors = [akRight, akBottom]
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333FF33333333333330003333333333333777333333333333
      300033FFFFFF3333377739999993333333333777777F3333333F399999933333
      3300377777733333337733333333333333003333333333333377333333333333
      3333333333333333333F333333333333330033333F33333333773333C3333333
      330033337F3333333377333CC3333333333333F77FFFFFFF3FF33CCCCCCCCCC3
      993337777777777F77F33CCCCCCCCCC399333777777777737733333CC3333333
      333333377F33333333FF3333C333333330003333733333333777333333333333
      3000333333333333377733333333333333333333333333333333}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = ButtonWork
    ExplicitLeft = 510
    ExplicitTop = 452
  end
  object AutoexecOverrideGameStartCheckBox: TCheckBox
    Left = 24
    Top = 24
    Width = 465
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Spiel-Start '#252'berspringen'
    TabOrder = 0
  end
  object AutoexecOverrideMountingCheckBox: TCheckBox
    Left = 24
    Top = 47
    Width = 457
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Mounting '#252'berspringen'
    TabOrder = 1
  end
  object AutoexecBootNormal: TRadioButton
    Left = 36
    Top = 341
    Width = 457
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'DosBox normal starten'
    Checked = True
    TabOrder = 3
    TabStop = True
  end
  object AutoexecBootHDImage: TRadioButton
    Left = 36
    Top = 368
    Width = 210
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Festplattenimage starten'
    TabOrder = 4
  end
  object AutoexecBootFloppyImage: TRadioButton
    Left = 36
    Top = 395
    Width = 210
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Diskettenimage starten'
    TabOrder = 5
  end
  object AutoexecBootFloppyImageTab: TStringGrid
    Left = 256
    Top = 391
    Width = 223
    Height = 74
    Anchors = [akLeft, akRight, akBottom]
    ColCount = 1
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor, goThumbTracking]
    TabOrder = 6
  end
  object AutoexecBootHDImageComboBox: TComboBox
    Left = 256
    Top = 364
    Width = 223
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akRight, akBottom]
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 7
    Text = 'Master (2)'
    OnChange = AutoexecBootHDImageComboBoxChange
    Items.Strings = (
      'Master (2)'
      'Slave (3)')
  end
  object AutoexecPageControl: TPageControl
    Left = 24
    Top = 80
    Width = 484
    Height = 249
    ActivePage = AutoexecSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    object AutoexecSheet1: TTabSheet
      Caption = 'Autoexec.bat'
      object Panel1: TPanel
        Left = 0
        Top = 192
        Width = 476
        Height = 29
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object AutoexecClearButton: TBitBtn
          Left = 0
          Top = 3
          Width = 105
          Height = 25
          Caption = 'L'#246'schen'
          TabOrder = 0
          OnClick = ButtonWork
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
            555557777F777555F55500000000555055557777777755F75555005500055055
            555577F5777F57555555005550055555555577FF577F5FF55555500550050055
            5555577FF77577FF555555005050110555555577F757777FF555555505099910
            555555FF75777777FF555005550999910555577F5F77777775F5500505509990
            3055577F75F77777575F55005055090B030555775755777575755555555550B0
            B03055555F555757575755550555550B0B335555755555757555555555555550
            BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
            50BB555555555555575F555555555555550B5555555555555575}
          NumGlyphs = 2
        end
        object AutoexecLoadButton: TBitBtn
          Tag = 1
          Left = 111
          Top = 3
          Width = 105
          Height = 25
          Caption = 'Laden...'
          TabOrder = 1
          OnClick = ButtonWork
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
        end
        object AutoexecSaveButton: TBitBtn
          Tag = 2
          Left = 222
          Top = 3
          Width = 105
          Height = 25
          Caption = 'Speichern...'
          TabOrder = 2
          OnClick = ButtonWork
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
            7700333333337777777733333333008088003333333377F73377333333330088
            88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
            000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
            FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
            99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
            99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
            99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
            93337FFFF7737777733300000033333333337777773333333333}
          NumGlyphs = 2
        end
      end
      object AutoexecMemo: TRichEdit
        Left = 0
        Top = 0
        Width = 476
        Height = 192
        Align = alClient
        PlainText = True
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
    end
    object AutoexecSheet2: TTabSheet
      Caption = 'Abschluss'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel12: TPanel
        Left = 0
        Top = 192
        Width = 476
        Height = 29
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object FinalizationClearButton: TBitBtn
          Tag = 6
          Left = 0
          Top = 3
          Width = 105
          Height = 25
          Caption = 'L'#246'schen'
          TabOrder = 0
          OnClick = ButtonWork
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000120B0000120B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
            555557777F777555F55500000000555055557777777755F75555005500055055
            555577F5777F57555555005550055555555577FF577F5FF55555500550050055
            5555577FF77577FF555555005050110555555577F757777FF555555505099910
            555555FF75777777FF555005550999910555577F5F77777775F5500505509990
            3055577F75F77777575F55005055090B030555775755777575755555555550B0
            B03055555F555757575755550555550B0B335555755555757555555555555550
            BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
            50BB555555555555575F555555555555550B5555555555555575}
          NumGlyphs = 2
        end
        object FinalizationLoadButton: TBitBtn
          Tag = 7
          Left = 111
          Top = 3
          Width = 105
          Height = 25
          Caption = 'Laden...'
          TabOrder = 1
          OnClick = ButtonWork
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
        end
        object FinalizationSaveButton: TBitBtn
          Tag = 8
          Left = 222
          Top = 3
          Width = 105
          Height = 25
          Caption = 'Speichern...'
          TabOrder = 2
          OnClick = ButtonWork
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
            7700333333337777777733333333008088003333333377F73377333333330088
            88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
            000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
            FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
            99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
            99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
            99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
            93337FFFF7737777733300000033333333337777773333333333}
          NumGlyphs = 2
        end
      end
      object FinalizationMemo: TRichEdit
        Left = 0
        Top = 0
        Width = 476
        Height = 192
        Align = alClient
        PlainText = True
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
    end
  end
  object OpenDialog: TOpenDialog
    Left = 192
    Top = 58
  end
  object SaveDialog: TSaveDialog
    Left = 224
    Top = 58
  end
end
