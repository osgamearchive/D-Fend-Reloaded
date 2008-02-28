object ProfileEditorForm: TProfileEditorForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'ProfileEditorForm'
  ClientHeight = 634
  ClientWidth = 536
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
    Width = 537
    Height = 595
    ActivePage = ProfileSettingsSheet
    Images = ImageList
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
        Left = 12
        Top = 522
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
        Left = 41
        Top = 522
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
        Left = 70
        Top = 522
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
        Width = 141
        Height = 25
        Caption = 'Icon ausw'#228'hlen...'
        TabOrder = 1
        OnClick = ButtonWork
      end
      object IconDeleteButton: TBitBtn
        Tag = 1
        Left = 228
        Top = 9
        Width = 141
        Height = 25
        Caption = 'Icon l'#246'schen'
        TabOrder = 2
        OnClick = ButtonWork
      end
      object ProfileSettingsValueListEditor: TValueListEditor
        Left = 13
        Top = 44
        Width = 500
        Height = 197
        Strings.Strings = (
          '=')
        TabOrder = 3
        OnEditButtonClick = ProfileSettingsValueListEditorEditButtonClick
        OnKeyUp = ProfileSettingsValueListEditorKeyUp
        OnSetEditText = ProfileSettingsValueListEditorSetEditText
        ColWidths = (
          150
          344)
      end
      object ExtraDirsListBox: TListBox
        Left = 13
        Top = 307
        Width = 500
        Height = 209
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
        Width = 300
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
        Top = 245
        Width = 69
        Height = 13
        Caption = 'Bemerkungen:'
      end
      object GameInfoValueListEditor: TValueListEditor
        Left = 12
        Top = 16
        Width = 501
        Height = 177
        Strings.Strings = (
          '=')
        TabOrder = 0
        OnEditButtonClick = GameInfoValueListEditorEditButtonClick
        ColWidths = (
          150
          345)
      end
      object NotesMemo: TRichEdit
        Left = 12
        Top = 264
        Width = 501
        Height = 273
        PlainText = True
        ScrollBars = ssBoth
        TabOrder = 3
      end
      object GenerateGameDataFolderNameButton: TBitBtn
        Tag = 19
        Left = 12
        Top = 199
        Width = 278
        Height = 25
        Caption = 'Daten-Verzeichnis automatisch erstellen'
        TabOrder = 1
        OnClick = ButtonWork
      end
      object GameInfoMetaDataButton: TBitBtn
        Tag = 23
        Left = 296
        Top = 199
        Width = 217
        Height = 25
        Caption = 'Benutzerdefinierte Informationen'
        TabOrder = 2
        OnClick = ButtonWork
      end
    end
    object GeneralSheet: TTabSheet
      Caption = 'GeneralSheet'
      ImageIndex = 2
      object GeneralValueListEditor: TValueListEditor
        Left = 11
        Top = 16
        Width = 501
        Height = 521
        Strings.Strings = (
          '=')
        TabOrder = 0
        OnEditButtonClick = GeneralValueListEditorEditButtonClick
        ColWidths = (
          248
          247)
      end
    end
    object EnvironmentSheet: TTabSheet
      Caption = 'EnvironmentSheet'
      ImageIndex = 3
      object KeyboardLayoutInfoLabel: TLabel
        Left = 12
        Top = 498
        Width = 468
        Height = 49
        AutoSize = False
        WordWrap = True
      end
      object EnvironmentValueListEditor: TValueListEditor
        Left = 12
        Top = 16
        Width = 501
        Height = 513
        Strings.Strings = (
          '=')
        TabOrder = 0
        OnEditButtonClick = EnvironmentValueListEditorEditButtonClick
        ColWidths = (
          248
          247)
      end
    end
    object MountingSheet: TTabSheet
      Caption = 'MountingSheet'
      ImageIndex = 4
      object MountingListView: TListView
        Left = 3
        Top = 16
        Width = 523
        Height = 465
        Columns = <>
        ReadOnly = True
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = MountingListViewDblClick
        OnKeyDown = MountingListViewKeyDown
      end
      object MountingAddButton: TBitBtn
        Tag = 5
        Left = 3
        Top = 487
        Width = 94
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
        Left = 103
        Top = 487
        Width = 94
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
        Left = 203
        Top = 487
        Width = 94
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
        Left = 303
        Top = 487
        Width = 90
        Height = 25
        Caption = 'Alle l'#246'schen'
        TabOrder = 4
        OnClick = ButtonWork
      end
      object MountingAutoCreateButton: TBitBtn
        Tag = 20
        Left = 399
        Top = 487
        Width = 127
        Height = 25
        Caption = 'Autom. erstellen'
        TabOrder = 5
        OnClick = ButtonWork
      end
      object AutoMountCheckBox: TCheckBox
        Left = 3
        Top = 522
        Width = 501
        Height = 17
        Caption = 'Aktuell verf'#252'gbare CDs in allen Laufwerken automatisch mounten'
        TabOrder = 6
      end
    end
    object SoundSheet: TTabSheet
      Caption = 'SoundSheet'
      ImageIndex = 5
      object SoundValueListEditor: TValueListEditor
        Left = 12
        Top = 16
        Width = 501
        Height = 121
        Strings.Strings = (
          '=')
        TabOrder = 0
        ColWidths = (
          248
          247)
      end
      object PageControl2: TPageControl
        Left = 12
        Top = 152
        Width = 501
        Height = 241
        ActivePage = SoundSBSheet
        TabOrder = 1
        object SoundSBSheet: TTabSheet
          Caption = 'SoundSBSheet'
          object SoundSBValueListEditor: TValueListEditor
            Left = 3
            Top = 16
            Width = 487
            Height = 185
            Strings.Strings = (
              '=')
            TabOrder = 0
            ColWidths = (
              248
              233)
          end
        end
        object SoundGUSSheet: TTabSheet
          Caption = 'SoundGUSSheet'
          ImageIndex = 1
          object SoundGUSValueListEditor: TValueListEditor
            Left = 3
            Top = 16
            Width = 487
            Height = 185
            Strings.Strings = (
              '=')
            TabOrder = 0
            ColWidths = (
              248
              233)
          end
        end
        object SoundMIDISheet: TTabSheet
          Caption = 'SoundMIDISheet'
          ImageIndex = 2
          object SoundMIDIValueListEditor: TValueListEditor
            Left = 3
            Top = 16
            Width = 487
            Height = 185
            Strings.Strings = (
              '=')
            TabOrder = 0
            ColWidths = (
              248
              233)
          end
        end
        object SoundJoystickSheet: TTabSheet
          Caption = 'SoundJoystickSheet'
          ImageIndex = 4
          object SoundJoystickValueListEditor: TValueListEditor
            Left = 3
            Top = 16
            Width = 487
            Height = 185
            Strings.Strings = (
              '=')
            TabOrder = 0
            ColWidths = (
              248
              233)
          end
        end
        object SoundMiscSheet: TTabSheet
          Caption = 'SoundMiscSheet'
          ImageIndex = 3
          object SoundMiscValueListEditor: TValueListEditor
            Left = 3
            Top = 16
            Width = 487
            Height = 185
            Strings.Strings = (
              '=')
            TabOrder = 0
            ColWidths = (
              248
              233)
          end
        end
        object SoundVolumeSheet: TTabSheet
          Caption = 'SoundVolumeSheet'
          ImageIndex = 5
          object SoundVolumeLeftLabel: TLabel
            Left = 148
            Top = 13
            Width = 23
            Height = 13
            Caption = 'Links'
          end
          object SoundVolumeRightLabel: TLabel
            Left = 212
            Top = 13
            Width = 33
            Height = 13
            Caption = 'Rechts'
          end
          object SoundVolumeMasterLabel: TLabel
            Left = 16
            Top = 36
            Width = 33
            Height = 13
            Caption = 'Master'
          end
          object SoundVolumeDisneyLabel: TLabel
            Left = 16
            Top = 64
            Width = 103
            Height = 13
            Caption = 'Disney Sound System'
          end
          object SoundVolumeSpeakerLabel: TLabel
            Left = 16
            Top = 92
            Width = 80
            Height = 13
            Caption = 'Internal Speaker'
          end
          object SoundVolumeGUSLabel: TLabel
            Left = 16
            Top = 120
            Width = 20
            Height = 13
            Caption = 'GUS'
          end
          object SoundVolumeSBLabel: TLabel
            Left = 16
            Top = 148
            Width = 63
            Height = 13
            Caption = 'SoundBlaster'
          end
          object SoundVolumeFMLabel: TLabel
            Left = 16
            Top = 176
            Width = 14
            Height = 13
            Caption = 'FM'
          end
          object SoundVolumeMasterLeftEdit: TSpinEdit
            Left = 148
            Top = 32
            Width = 49
            Height = 22
            MaxValue = 100
            MinValue = 0
            TabOrder = 0
            Value = 100
          end
          object SoundVolumeMasterRightEdit: TSpinEdit
            Left = 212
            Top = 32
            Width = 49
            Height = 22
            MaxValue = 100
            MinValue = 0
            TabOrder = 1
            Value = 100
          end
          object SoundVolumeDisneyLeftEdit: TSpinEdit
            Left = 148
            Top = 60
            Width = 49
            Height = 22
            MaxValue = 100
            MinValue = 0
            TabOrder = 2
            Value = 100
          end
          object SoundVolumeDisneyRightEdit: TSpinEdit
            Left = 212
            Top = 60
            Width = 49
            Height = 22
            MaxValue = 100
            MinValue = 0
            TabOrder = 3
            Value = 100
          end
          object SoundVolumeSpeakerLeftEdit: TSpinEdit
            Left = 148
            Top = 88
            Width = 49
            Height = 22
            MaxValue = 100
            MinValue = 0
            TabOrder = 4
            Value = 100
          end
          object SoundVolumeSpeakerRightEdit: TSpinEdit
            Left = 212
            Top = 88
            Width = 49
            Height = 22
            MaxValue = 100
            MinValue = 0
            TabOrder = 5
            Value = 100
          end
          object SoundVolumeGUSLeftEdit: TSpinEdit
            Left = 148
            Top = 116
            Width = 49
            Height = 22
            MaxValue = 100
            MinValue = 0
            TabOrder = 6
            Value = 100
          end
          object SoundVolumeGUSRightEdit: TSpinEdit
            Left = 212
            Top = 116
            Width = 49
            Height = 22
            MaxValue = 100
            MinValue = 0
            TabOrder = 7
            Value = 100
          end
          object SoundVolumeSBLeftEdit: TSpinEdit
            Left = 148
            Top = 144
            Width = 49
            Height = 22
            MaxValue = 100
            MinValue = 0
            TabOrder = 8
            Value = 100
          end
          object SoundVolumeSBRightEdit: TSpinEdit
            Left = 212
            Top = 144
            Width = 49
            Height = 22
            MaxValue = 100
            MinValue = 0
            TabOrder = 9
            Value = 100
          end
          object SoundVolumeFMLeftEdit: TSpinEdit
            Left = 148
            Top = 172
            Width = 49
            Height = 22
            MaxValue = 100
            MinValue = 0
            TabOrder = 10
            Value = 100
          end
          object SoundVolumeFMRightEdit: TSpinEdit
            Left = 212
            Top = 172
            Width = 49
            Height = 22
            MaxValue = 100
            MinValue = 0
            TabOrder = 11
            Value = 100
          end
        end
      end
    end
    object AutoexecSheet: TTabSheet
      Caption = 'AutoexecSheet'
      ImageIndex = 6
      object AutoexecBootFloppyImageButton: TSpeedButton
        Tag = 13
        Left = 498
        Top = 456
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
      object AutoexecLabel: TLabel
        Left = 12
        Top = 92
        Width = 70
        Height = 13
        Caption = 'Autoexec.bat:'
      end
      object AutoexecBootFloppyImageAddButton: TSpeedButton
        Tag = 21
        Left = 498
        Top = 484
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
      object AutoexecBootFloppyImageDelButton: TSpeedButton
        Tag = 22
        Left = 498
        Top = 508
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
      object AutoexecBootFloppyImageInfoLabel: TLabel
        Left = 40
        Top = 483
        Width = 194
        Height = 42
        AutoSize = False
        Caption = 'AutoexecBootFloppyImageInfoLabel'
        WordWrap = True
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
        Top = 359
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
      object AutoexecLoadButton: TBitBtn
        Tag = 11
        Left = 125
        Top = 359
        Width = 105
        Height = 25
        Caption = 'Laden...'
        TabOrder = 4
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
        Top = 359
        Width = 105
        Height = 25
        Caption = 'Speichern...'
        TabOrder = 5
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
        Left = 24
        Top = 406
        Width = 457
        Height = 17
        Caption = 'DosBox normal starten'
        Checked = True
        TabOrder = 6
        TabStop = True
      end
      object AutoexecBootHDImage: TRadioButton
        Left = 24
        Top = 433
        Width = 210
        Height = 17
        Caption = 'Festplattenimage starten'
        TabOrder = 7
      end
      object AutoexecBootFloppyImage: TRadioButton
        Left = 24
        Top = 460
        Width = 210
        Height = 17
        Caption = 'Diskettenimage starten'
        TabOrder = 8
      end
      object AutoexecBootHDImageComboBox: TComboBox
        Left = 244
        Top = 429
        Width = 248
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 9
        Text = 'Master (2)'
        Items.Strings = (
          'Master (2)'
          'Slave (3)')
      end
      object AutoexecMemo: TRichEdit
        Left = 12
        Top = 107
        Width = 501
        Height = 238
        PlainText = True
        ScrollBars = ssBoth
        TabOrder = 2
        WordWrap = False
      end
      object AutoexecUse4DOSCheckBox: TCheckBox
        Left = 16
        Top = 65
        Width = 497
        Height = 17
        Caption = 'Use 4DOS as command line interpreter'
        TabOrder = 10
      end
      object AutoexecBootFloppyImageTab: TStringGrid
        Left = 244
        Top = 456
        Width = 248
        Height = 74
        ColCount = 1
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor, goThumbTracking]
        TabOrder = 11
      end
    end
    object CustomSetsSheet: TTabSheet
      Caption = 'CustomSetsSheet'
      ImageIndex = 7
      object CustomSetsEnvLabel: TLabel
        Left = 13
        Top = 275
        Width = 104
        Height = 13
        Caption = 'Umgebungsvariablen:'
      end
      object CustomSetsClearButton: TBitBtn
        Tag = 14
        Left = 13
        Top = 223
        Width = 105
        Height = 25
        Caption = 'L'#246'schen'
        TabOrder = 1
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
        Left = 126
        Top = 223
        Width = 105
        Height = 25
        Caption = 'Laden...'
        TabOrder = 2
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
        Left = 237
        Top = 223
        Width = 105
        Height = 25
        Caption = 'Speichern...'
        TabOrder = 3
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
        Top = 294
        Width = 501
        Height = 211
        KeyOptions = [keyEdit]
        TabOrder = 4
        ColWidths = (
          150
          345)
      end
      object CustomSetsEnvAdd: TBitBtn
        Tag = 17
        Left = 13
        Top = 511
        Width = 105
        Height = 25
        Caption = 'Hinzuf'#252'gen'
        TabOrder = 5
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
        Left = 126
        Top = 511
        Width = 105
        Height = 25
        Caption = 'L'#246'schen'
        TabOrder = 6
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
        Width = 500
        Height = 201
        PlainText = True
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
    end
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 601
    Width = 97
    Height = 25
    TabOrder = 1
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 601
    Width = 97
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object PreviousButton: TBitBtn
    Tag = 1
    Left = 232
    Top = 601
    Width = 113
    Height = 25
    Caption = 'Vorheriges'
    ModalResult = 1
    TabOrder = 3
    Visible = False
    OnClick = OKButtonClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333333333333333333333333333333333333333333333
      3333333333333FF3333333333333003333333333333F77F33333333333009033
      333333333F7737F333333333009990333333333F773337FFFFFF330099999000
      00003F773333377777770099999999999990773FF33333FFFFF7330099999000
      000033773FF33777777733330099903333333333773FF7F33333333333009033
      33333333337737F3333333333333003333333333333377333333333333333333
      3333333333333333333333333333333333333333333333333333333333333333
      3333333333333333333333333333333333333333333333333333}
    NumGlyphs = 2
  end
  object NextButton: TBitBtn
    Tag = 2
    Left = 360
    Top = 601
    Width = 113
    Height = 25
    Caption = 'N'#228'chstes'
    ModalResult = 1
    TabOrder = 4
    Visible = False
    OnClick = OKButtonClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333333333333333333333333333333333333333333333
      3333333333333333333333333333333333333333333FF3333333333333003333
      3333333333773FF3333333333309003333333333337F773FF333333333099900
      33333FFFFF7F33773FF30000000999990033777777733333773F099999999999
      99007FFFFFFF33333F7700000009999900337777777F333F7733333333099900
      33333333337F3F77333333333309003333333333337F77333333333333003333
      3333333333773333333333333333333333333333333333333333333333333333
      3333333333333333333333333333333333333333333333333333}
    NumGlyphs = 2
  end
  object OpenDialog: TOpenDialog
    Left = 440
    Top = 600
  end
  object SaveDialog: TSaveDialog
    Left = 472
    Top = 600
  end
  object ImageList: TImageList
    Left = 504
    Top = 598
    Bitmap = {
      494C010108000C00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF000000000000000000000000000000FFFF0000FF
      FF00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BFBFBF0000000000000000000000
      00000000FF00000000000000000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF000000000000000000000000000000FFFF0000FF
      FF000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      000000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007F7F7F00000000007F7F7F00BFBFBF007F7F7F00000000000000
      00000000000000000000000000000000FF00FFFF000000000000FFFFFF007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F0000000000FFFF000000000000000000000000000000FFFF0000FF
      FF0000FFFF000000000000FFFF0000FFFF0000FFFF0000FFFF00000000000000
      00000000000000FFFF00000000000000000000000000FFFFFF007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F00000000000000000000000000000000000000
      00007F7F7F007F7F7F0000000000BFBFBF00BFBFBF00BFBFBF00000000000000
      000000000000000000000000FF0000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000000000000000000000FFFF0000FF
      FF0000FFFF00000000000000000000FFFF0000FFFF00000000000000000000FF
      FF0000FFFF0000FFFF00000000000000000000000000FFFFFF000000FF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF007F7F7F00000000000000000000000000000000000000
      00007F7F7F007F7F7F0000000000BFBFBF00BFBFBF00BFBFBF00000000000000
      0000000000000000FF000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF000000000000FFFF00000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF00000000000000000000000000FFFFFF00BFBFBF00BFBF
      BF00000000000000000000000000000000000000000000000000000000000000
      0000BFBFBF00BFBFBF007F7F7F00000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F000000000000000000BFBFBF00BFBFBF00000000000000
      00000000FF00000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF00000000000000000000000000FFFFFF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF007F7F7F0000000000000000007F7F7F0000000000BFBF
      BF00BFBFBF00BFBFBF0000000000BFBFBF0000000000BFBFBF007F7F7F000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF0000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000000000000000000000000000FFFFFF00BFBFBF00BFBF
      BF00000000000000000000000000000000000000000000000000000000000000
      0000BFBFBF00BFBFBF007F7F7F0000000000000000007F7F7F00000000007F7F
      7F007F7F7F007F7F7F0000000000BFBFBF0000000000BFBFBF007F7F7F000000
      00000000FF000000FF000000FF000000FF00FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF0000000000000000000000000000FFFF0000FFFF
      000000000000FFFF0000BFBFBF0000000000000000000000000000000000FFFF
      0000FFFF0000FFFF0000000000000000000000000000FFFFFF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF007F7F7F000000000000000000BFBFBF0000000000BFBF
      BF00BFBFBF00BFBFBF0000000000BFBFBF0000000000BFBFBF007F7F7F000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF0000000000000000000000000000FFFF0000FFFF
      0000FFFF000000000000BFBFBF000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000000000000000000000000000FFFFFF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF007F7F7F0000000000000000000000000000000000BFBF
      BF00BFBFBF00BFBFBF000000000000000000BFBFBF00BFBFBF00000000000000
      00000000FF00000000000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF0000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000BFBFBF00BFBFBF00000000007F7F7F00BFBFBF00BFBFBF00000000000000
      0000000000000000FF000000000000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF0000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF00000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BFBFBF00BFBFBF00000000007F7F7F007F7F7F00BFBFBF00000000000000
      000000000000000000000000FF0000000000FFFF000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007F7F7F0000000000FFFF0000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BFBFBF007F7F7F007F7F7F007F7F7F007F7F7F00000000000000
      00000000000000000000000000000000FF00FFFF000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFF0000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BFBFBF00000000007F7F7F0000000000000000000000
      00000000FF00000000000000000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000000000000000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000204000002040000020
      4000002040000020400000204000002040000020400000204000002040000020
      4000002040000020400000204000002040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF007F7F7F000000FF007F7F7F00FFFFFF00000000000000
      0000000000000000000000000000000000000020400000408000004080000020
      6000002040000040800000408000004080000020600000206000004080000040
      8000002060000020600000204000002040000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF000000FF000000FF000000FF0000FFFF00FFFFFF0000FF
      FF0000000000000000000000000000000000002040000040A00040E0E00040E0
      E00000204000006060000040600040E0E00040E0E000004040000040600040E0
      E0000040400040E0E0000000000000204000000000000000000000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000FFFFFF00000000000000000000000000FFFF
      FF000000000000000000FFFFFF0000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF007F7F7F000000FF007F7F7F00FFFFFF0000FFFF00FFFF
      FF0000FFFF00000000000000000000000000002040000040800040E0E0000000
      000040E0E0000040600040E0E000004040000040600040E0E0000040400040E0
      E0000020400040E0E00000204000002040000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF000000000000000000004060000040800040E0E00040E0
      E000002040000040600040E0E000000000004060600000FFFF00002040000040
      600040E0E00000204000002040000020400000000000FFFFFF00FFFFFF00BFBF
      BF0000000000000000000000000000000000000000000000000000000000BFBF
      BF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000FFFFFF000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF000000FF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF000000000000000000002040000040800000FFFF000040
      600040E0E0004040600000E0E000000000000040600040E0E0000040600000E0
      E0000040400040E0E000002040000020400000000000FFFFFF000000FF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFFFF00FFFFFF0000000000FFFFFF000000
      FF00FFFFFF00FF000000FFFFFF0000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF000000FF007F7F7F0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000000000002040000040A00040E0E00040E0
      E00040608000406080004060800040E0E00040E0E000406080004060800040E0
      E0000040600040E0E000004060000020600000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      FF00FFFFFF00FF000000FFFFFF000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF000000FF000000FF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF0000000000004060004060A000406080004060
      8000406080004080800040808000406080004060800040808000408080004060
      8000406080004060800000408000002060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FF000000FFFFFF0000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000FF000000FF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000000000004060000060A000406080000020
      4000004040004080800040608000406080000020400000404000406080004060
      8000004040000040400000406000002060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF007F7F7F007F7F7F0000FFFF00FFFFFF007F7F7F000000FF000000FF00FFFF
      FF0000FFFF00FFFFFF0000FFFF0000000000002040000040A00040E0E00040E0
      E00000204000006060000040600040E0E00040E0E000002040004060800040E0
      E00040E0E0000020400000204000002060000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF000000FF000000FF00FFFFFF0000FFFF007F7F7F000000FF000000FF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000000000004060000040800040E0E0000000
      000040E0E0000040400040E0E000004040000040600040E0E000000000004060
      60000040600040E0E00000204000002060000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF0000000000000000000000FFFFFF0000FFFF00FFFF
      FF000000FF000000FF007F7F7F00FFFFFF007F7F7F000000FF000000FF00FFFF
      FF0000FFFF00FFFFFF000000000000000000004060000040A00040E0E0000000
      000040E0E0000020400040E0E000000000004060600040E0E000000000004060
      600040E0E0004040600000406000002060000000000000000000000000000000
      0000FFFFFF000000000000FF000000FF0000FFFF000000000000FFFFFF000000
      00000000000000000000000000000000000000000000BFBFBF00BFBFBF00FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000BFBFBF00BFBFBF00000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF000000FF000000FF000000FF000000FF000000FF00FFFFFF0000FF
      FF00FFFFFF0000FFFF000000000000000000002040000040A00000FFFF000040
      600040E0E0000040600040E0E000000000000040600040E0E0004040600000E0
      E000002040000020400000204000002040000000000000000000000000000000
      0000FFFFFF0000000000FF00FF0000FF0000FF00FF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF000000FF000000FF000000FF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00000000000000000000000000002040000040A00000FFFF0040E0
      E000406080004080A0004060800040E0E00040E0E00040608000408080004060
      800040E0E00040E0E00000206000002060000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF0000000000000000000000000000000000004060004060A0000040A0000040
      8000004080004060A00000408000004080000040800000408000406080000040
      8000004080000040800040408000004060000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000020400000406000004060000040
      6000004060000040600000406000004060000040600000406000004060000040
      6000004060000040600000406000002040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFC003FFFFFC7B0001C003
      FFFFF8370001C0030000F03E0001C0030000E01D1FF1C0030000E01B1DF1C003
      000080171CF1C0030000001F1C71C003000000101C31C0030000001F1C71C003
      000080171CF1C0030000E01B1DF1C0030000E01D1FF1C003FFFFF03E0001C003
      FFFFF8370001C003FFFFFC7B0001C003FFFFFFFF800080030000F83F00008003
      0000E00F0000C0070000C0070000000100008003000000010000800300000001
      00000001000000010000000100008003000000010000E00F000000010000E00F
      000000010000E00F000080030000E00F000080030000E00F0000C0070000E00F
      FFFFE00F0000E00FFFFFF83F0000E00F00000000000000000000000000000000
      000000000000}
  end
end
