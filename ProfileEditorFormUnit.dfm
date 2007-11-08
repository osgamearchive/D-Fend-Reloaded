object ProfileEditorForm: TProfileEditorForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'ProfileEditorForm'
  ClientHeight = 498
  ClientWidth = 504
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 505
    Height = 459
    ActivePage = ProfileSettingsSheet
    MultiLine = True
    TabOrder = 0
    object ProfileSettingsSheet: TTabSheet
      Caption = 'ProfileSettingsSheet'
      object ExtraDirsLabel: TLabel
        Left = 12
        Top = 288
        Width = 172
        Height = 13
        Caption = 'Zus'#228'tzliche Programmverzeichnisse:'
      end
      object ExtraDirsAddButton: TSpeedButton
        Tag = 2
        Left = 13
        Top = 382
        Width = 23
        Height = 22
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
      end
      object ExtraDirsEditButton: TSpeedButton
        Tag = 3
        Left = 42
        Top = 382
        Width = 23
        Height = 22
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
          000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
          00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
          F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
          0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
          FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
          FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
          0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
          00333377737FFFFF773333303300000003333337337777777333}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = ButtonWork
      end
      object ExtraDirsDelButton: TSpeedButton
        Tag = 4
        Left = 71
        Top = 382
        Width = 23
        Height = 22
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
      end
      object IconPanel: TPanel
        Left = 12
        Top = 3
        Width = 35
        Height = 35
        TabOrder = 0
        object IconImage: TImage
          Left = 1
          Top = 1
          Width = 33
          Height = 33
          Align = alClient
          ExplicitLeft = 12
          ExplicitTop = 9
          ExplicitWidth = 32
          ExplicitHeight = 32
        end
      end
      object IconSelectButton: TBitBtn
        Left = 72
        Top = 9
        Width = 105
        Height = 25
        Caption = 'Icon ausw'#228'hlen...'
        TabOrder = 1
        OnClick = ButtonWork
      end
      object IconDeleteButton: TBitBtn
        Tag = 1
        Left = 192
        Top = 9
        Width = 105
        Height = 25
        Caption = 'Icon l'#246'schen'
        TabOrder = 2
        OnClick = ButtonWork
      end
      object ProfileSettingsValueListEditor: TValueListEditor
        Left = 13
        Top = 44
        Width = 468
        Height = 197
        Strings.Strings = (
          '=')
        TabOrder = 3
        OnEditButtonClick = ProfileSettingsValueListEditorEditButtonClick
        OnKeyUp = ProfileSettingsValueListEditorKeyUp
        OnSetEditText = ProfileSettingsValueListEditorSetEditText
        ColWidths = (
          150
          312)
      end
      object ExtraDirsListBox: TListBox
        Left = 13
        Top = 307
        Width = 467
        Height = 69
        ItemHeight = 13
        TabOrder = 5
        OnClick = ExtraDirsListBoxClick
        OnDblClick = ExtraDirsListBoxDblClick
        OnKeyDown = ExtraDirsListBoxKeyDown
      end
      object GenerateScreenshotFolderNameButton: TBitBtn
        Tag = 9
        Left = 13
        Top = 247
        Width = 260
        Height = 25
        Caption = 'Screenshot-Verzeichnis automatisch festlegen'
        TabOrder = 4
        OnClick = ButtonWork
      end
    end
    object GameInfoSheet: TTabSheet
      Caption = 'GameInfoSheet'
      ImageIndex = 1
      object NotesLabel: TLabel
        Left = 12
        Top = 213
        Width = 69
        Height = 13
        Caption = 'Bemerkungen:'
      end
      object GameInfoValueListEditor: TValueListEditor
        Left = 12
        Top = 16
        Width = 468
        Height = 177
        Strings.Strings = (
          '=')
        TabOrder = 0
        OnEditButtonClick = GameInfoValueListEditorEditButtonClick
        ColWidths = (
          150
          312)
      end
      object NotesMemo: TRichEdit
        Left = 12
        Top = 232
        Width = 468
        Height = 169
        PlainText = True
        ScrollBars = ssBoth
        TabOrder = 1
      end
    end
    object GeneralSheet: TTabSheet
      Caption = 'GeneralSheet'
      ImageIndex = 2
      object GeneralValueListEditor: TValueListEditor
        Left = 12
        Top = 16
        Width = 468
        Height = 385
        Strings.Strings = (
          '=')
        TabOrder = 0
        ColWidths = (
          248
          214)
      end
    end
    object EnvironmentSheet: TTabSheet
      Caption = 'EnvironmentSheet'
      ImageIndex = 3
      object KeyboardLayoutInfoLabel: TLabel
        Left = 12
        Top = 353
        Width = 468
        Height = 49
        AutoSize = False
        WordWrap = True
      end
      object EnvironmentValueListEditor: TValueListEditor
        Left = 12
        Top = 16
        Width = 468
        Height = 385
        Strings.Strings = (
          '=')
        TabOrder = 0
        ColWidths = (
          248
          214)
      end
    end
    object MountingSheet: TTabSheet
      Caption = 'MountingSheet'
      ImageIndex = 4
      object MountingListView: TListView
        Left = 12
        Top = 16
        Width = 471
        Height = 355
        Columns = <>
        ReadOnly = True
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = MountingListViewDblClick
        OnKeyDown = MountingListViewKeyDown
      end
      object MountingAddButton: TBitBtn
        Tag = 5
        Left = 12
        Top = 377
        Width = 105
        Height = 25
        Caption = 'Hinzuf'#252'gen...'
        TabOrder = 1
        OnClick = ButtonWork
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
          333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
          0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
          07333337F33333337F333330FFFFFFFF07333337F33333337F333330FFFFFFFF
          07333FF7F33333337FFFBBB0FFFFFFFF0BB37777F3333333777F3BB0FFFFFFFF
          0BBB3777F3333FFF77773330FFFF000003333337F333777773333330FFFF0FF0
          33333337F3337F37F3333330FFFF0F0B33333337F3337F77FF333330FFFF003B
          B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
          3BB33773333773333773B333333B3333333B7333333733333337}
        NumGlyphs = 2
      end
      object MountingEditButton: TBitBtn
        Tag = 6
        Left = 123
        Top = 377
        Width = 105
        Height = 25
        Caption = 'Bearbeiten...'
        TabOrder = 2
        OnClick = ButtonWork
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
          000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
          00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
          F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
          0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
          FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
          FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
          0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
          00333377737FFFFF773333303300000003333337337777777333}
        NumGlyphs = 2
      end
      object MountingDelButton: TBitBtn
        Tag = 7
        Left = 234
        Top = 377
        Width = 105
        Height = 25
        Caption = 'L'#246'schen'
        TabOrder = 3
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
      object MountingDeleteAllButton: TBitBtn
        Tag = 8
        Left = 345
        Top = 377
        Width = 105
        Height = 25
        Caption = 'Alle l'#246'schen'
        TabOrder = 4
        OnClick = ButtonWork
      end
    end
    object SoundSheet: TTabSheet
      Caption = 'SoundSheet'
      ImageIndex = 5
      object SoundValueListEditor: TValueListEditor
        Left = 12
        Top = 16
        Width = 468
        Height = 121
        Strings.Strings = (
          '=')
        TabOrder = 0
        ColWidths = (
          248
          214)
      end
      object PageControl2: TPageControl
        Left = 12
        Top = 160
        Width = 468
        Height = 241
        ActivePage = SoundSBSheet
        TabOrder = 1
        object SoundSBSheet: TTabSheet
          Caption = 'SoundSBSheet'
          object SoundSBValueListEditor: TValueListEditor
            Left = 3
            Top = 16
            Width = 449
            Height = 185
            Strings.Strings = (
              '=')
            TabOrder = 0
            ColWidths = (
              248
              195)
          end
        end
        object SoundGUSSheet: TTabSheet
          Caption = 'SoundGUSSheet'
          ImageIndex = 1
          object SoundGUSValueListEditor: TValueListEditor
            Left = 3
            Top = 16
            Width = 449
            Height = 185
            Strings.Strings = (
              '=')
            TabOrder = 0
            ColWidths = (
              248
              195)
          end
        end
        object SoundMIDISheet: TTabSheet
          Caption = 'SoundMIDISheet'
          ImageIndex = 2
          object SoundMIDIValueListEditor: TValueListEditor
            Left = 3
            Top = 16
            Width = 449
            Height = 185
            Strings.Strings = (
              '=')
            TabOrder = 0
            ColWidths = (
              248
              195)
          end
        end
        object SoundJoystickSheet: TTabSheet
          Caption = 'SoundJoystickSheet'
          ImageIndex = 4
          object SoundJoystickValueListEditor: TValueListEditor
            Left = 3
            Top = 16
            Width = 449
            Height = 185
            Strings.Strings = (
              '=')
            TabOrder = 0
            ColWidths = (
              248
              195)
          end
        end
        object SoundMiscSheet: TTabSheet
          Caption = 'SoundMiscSheet'
          ImageIndex = 3
          object SoundMiscValueListEditor: TValueListEditor
            Left = 3
            Top = 16
            Width = 449
            Height = 185
            Strings.Strings = (
              '=')
            TabOrder = 0
            ColWidths = (
              248
              195)
          end
        end
      end
    end
    object AutoexecSheet: TTabSheet
      Caption = 'AutoexecSheet'
      ImageIndex = 6
      object AutoexecBootFloppyImageButton: TSpeedButton
        Tag = 13
        Left = 462
        Top = 374
        Width = 23
        Height = 22
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
      object AutoexecOverrideGameStartCheckBox: TCheckBox
        Left = 16
        Top = 16
        Width = 465
        Height = 17
        Caption = 'Spiel-Start '#252'berspringen'
        TabOrder = 0
      end
      object AutoexecOverrideMountingCheckBox: TCheckBox
        Left = 16
        Top = 39
        Width = 457
        Height = 17
        Caption = 'Mounting '#252'berspringen'
        TabOrder = 1
      end
      object AutoexecClearButton: TBitBtn
        Tag = 10
        Left = 12
        Top = 271
        Width = 105
        Height = 25
        Caption = 'L'#246'schen'
        TabOrder = 2
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
        Tag = 11
        Left = 125
        Top = 271
        Width = 105
        Height = 25
        Caption = 'Laden...'
        TabOrder = 3
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
        Tag = 12
        Left = 236
        Top = 271
        Width = 105
        Height = 25
        Caption = 'Speichern...'
        TabOrder = 4
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
      object AutoexecBootNormal: TRadioButton
        Left = 16
        Top = 320
        Width = 457
        Height = 17
        Caption = 'DosBox normal starten'
        Checked = True
        TabOrder = 5
        TabStop = True
      end
      object AutoexecBootHDImage: TRadioButton
        Left = 16
        Top = 347
        Width = 210
        Height = 17
        Caption = 'Festplattenimage starten'
        TabOrder = 6
      end
      object AutoexecBootFloppyImage: TRadioButton
        Left = 16
        Top = 374
        Width = 210
        Height = 17
        Caption = 'Diskettenimage starten'
        TabOrder = 7
      end
      object AutoexecBootHDImageComboBox: TComboBox
        Left = 236
        Top = 343
        Width = 220
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 8
        Text = 'Master (2)'
        Items.Strings = (
          'Master (2)'
          'Slave (3)')
      end
      object AutoexecBootFloppyImageEdit: TEdit
        Left = 236
        Top = 374
        Width = 220
        Height = 21
        TabOrder = 9
      end
      object AutoexecMemo: TRichEdit
        Left = 12
        Top = 72
        Width = 465
        Height = 193
        PlainText = True
        ScrollBars = ssBoth
        TabOrder = 10
      end
    end
    object CustomSetsSheet: TTabSheet
      Caption = 'CustomSetsSheet'
      ImageIndex = 7
      object CustomSetsEnvLabel: TLabel
        Left = 13
        Top = 203
        Width = 104
        Height = 13
        Caption = 'Umgebungsvariablen:'
      end
      object CustomSetsClearButton: TBitBtn
        Tag = 14
        Left = 12
        Top = 167
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
      object CustomSetsLoadButton: TBitBtn
        Tag = 15
        Left = 125
        Top = 167
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
      object CustomSetsSaveButton: TBitBtn
        Tag = 16
        Left = 236
        Top = 167
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
      object CustomSetsValueListEditor: TValueListEditor
        Left = 12
        Top = 222
        Width = 465
        Height = 147
        KeyOptions = [keyEdit, keyAdd, keyDelete]
        TabOrder = 3
        ColWidths = (
          150
          309)
      end
      object CustomSetsEnvAdd: TBitBtn
        Tag = 17
        Left = 12
        Top = 375
        Width = 105
        Height = 25
        Caption = 'Hinzuf'#252'gen'
        TabOrder = 4
        OnClick = ButtonWork
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
      end
      object CustomSetsEnvDel: TBitBtn
        Tag = 18
        Left = 125
        Top = 375
        Width = 105
        Height = 25
        Caption = 'L'#246'schen'
        TabOrder = 5
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
      object CustomSetsMemo: TRichEdit
        Left = 13
        Top = 16
        Width = 464
        Height = 145
        PlainText = True
        ScrollBars = ssBoth
        TabOrder = 6
      end
    end
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 465
    Width = 97
    Height = 25
    TabOrder = 1
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 465
    Width = 97
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object OpenDialog: TOpenDialog
    Left = 232
    Top = 466
  end
  object SaveDialog: TSaveDialog
    Left = 264
    Top = 466
  end
end
