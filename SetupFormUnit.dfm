object SetupForm: TSetupForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'SetupForm'
  ClientHeight = 345
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object OKButton: TBitBtn
    Left = 8
    Top = 311
    Width = 97
    Height = 25
    TabOrder = 1
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 311
    Width = 97
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object PageControl: TPageControl
    Left = -1
    Top = 0
    Width = 459
    Height = 305
    ActivePage = GeneralSheet
    TabOrder = 0
    object GeneralSheet: TTabSheet
      Caption = 'Allgemein'
      object BaseDirButton: TSpeedButton
        Left = 415
        Top = 24
        Width = 23
        Height = 22
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
      end
      object GameDirButton: TSpeedButton
        Tag = 1
        Left = 415
        Top = 80
        Width = 23
        Height = 22
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
      end
      object DataDirButton: TSpeedButton
        Tag = 2
        Left = 415
        Top = 136
        Width = 23
        Height = 22
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
      end
      object BaseDirEdit: TLabeledEdit
        Left = 16
        Top = 24
        Width = 393
        Height = 21
        EditLabel.Width = 54
        EditLabel.Height = 13
        EditLabel.Caption = 'BaseDirEdit'
        TabOrder = 0
      end
      object ReopenLastActiveProfileSheetCheckBox: TCheckBox
        Left = 16
        Top = 176
        Width = 339
        Height = 17
        Caption = 'Zuletzt aktive Seite im Profileditor merken'
        TabOrder = 3
      end
      object RestoreWindowSizeCheckBox: TCheckBox
        Left = 16
        Top = 208
        Width = 387
        Height = 17
        Caption = 'Letzte Fenstergr'#246#223'e beim Programmstart wiederherstellen'
        TabOrder = 4
      end
      object MinimizeToTrayCheckBox: TCheckBox
        Left = 16
        Top = 240
        Width = 387
        Height = 17
        Caption = 'In den Benachrichtigungsbereich minimieren'
        TabOrder = 5
      end
      object GameDirEdit: TLabeledEdit
        Left = 16
        Top = 80
        Width = 393
        Height = 21
        EditLabel.Width = 58
        EditLabel.Height = 13
        EditLabel.Caption = 'GameDirEdit'
        TabOrder = 1
      end
      object DataDirEdit: TLabeledEdit
        Left = 16
        Top = 136
        Width = 393
        Height = 21
        EditLabel.Width = 54
        EditLabel.Height = 13
        EditLabel.Caption = 'DataDirEdit'
        TabOrder = 2
      end
    end
    object LanguageSheet: TTabSheet
      Caption = 'Sprache'
      ImageIndex = 4
      object LanguageLabel: TLabel
        Left = 16
        Top = 16
        Width = 90
        Height = 13
        Caption = 'Programmsprache:'
      end
      object DosBoxLangLabel: TLabel
        Left = 16
        Top = 72
        Width = 84
        Height = 13
        Caption = 'DosBoxLangLabel'
      end
      object LanguageComboBox: TComboBox
        Left = 16
        Top = 32
        Width = 417
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = LanguageComboBoxChange
      end
      object DosBoxLangEditComboBox: TComboBox
        Left = 16
        Top = 91
        Width = 417
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
      end
    end
    object ListViewSheet: TTabSheet
      Caption = 'Spieleliste'
      ImageIndex = 6
      object ListViewLabel: TLabel
        Left = 14
        Top = 16
        Width = 200
        Height = 13
        Caption = 'Sichtbare Spalten und deren Reihenfolge:'
      end
      object ListViewUpButton: TSpeedButton
        Left = 231
        Top = 35
        Width = 23
        Height = 22
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000333
          3333333333777F33333333333309033333333333337F7F333333333333090333
          33333333337F7F33333333333309033333333333337F7F333333333333090333
          33333333337F7F33333333333309033333333333FF7F7FFFF333333000090000
          3333333777737777F333333099999990333333373F3333373333333309999903
          333333337F33337F33333333099999033333333373F333733333333330999033
          3333333337F337F3333333333099903333333333373F37333333333333090333
          33333333337F7F33333333333309033333333333337373333333333333303333
          333333333337F333333333333330333333333333333733333333}
        NumGlyphs = 2
        OnClick = ListViewMoveButtonClick
      end
      object ListViewDownButton: TSpeedButton
        Tag = 1
        Left = 231
        Top = 63
        Width = 23
        Height = 22
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
        OnClick = ListViewMoveButtonClick
      end
      object ColDefaultValueSpeedButton: TSpeedButton
        Tag = 2
        Left = 231
        Top = 91
        Width = 23
        Height = 22
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333FFFFF3333333333999993333333333F77777FFF333333999999999
          3333333777333777FF3333993333339993333377FF3333377FF3399993333339
          993337777FF3333377F3393999333333993337F777FF333337FF993399933333
          399377F3777FF333377F993339993333399377F33777FF33377F993333999333
          399377F333777FF3377F993333399933399377F3333777FF377F993333339993
          399377FF3333777FF7733993333339993933373FF3333777F7F3399933333399
          99333773FF3333777733339993333339933333773FFFFFF77333333999999999
          3333333777333777333333333999993333333333377777333333}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = ListViewMoveButtonClick
      end
      object ScreenshotPreviewLabel: TLabel
        Left = 14
        Top = 168
        Width = 157
        Height = 13
        Caption = 'Gr'#246#223'e der Screenshot-Vorschau:'
      end
      object ListViewListBox: TCheckListBox
        Left = 14
        Top = 35
        Width = 211
        Height = 102
        ItemHeight = 13
        TabOrder = 0
      end
      object ScreenshotPreviewEdit: TSpinEdit
        Left = 14
        Top = 187
        Width = 67
        Height = 22
        MaxValue = 250
        MinValue = 20
        TabOrder = 1
        Value = 100
      end
    end
    object DosBoxSheet: TTabSheet
      Caption = 'DosBox'
      ImageIndex = 3
      object DosBoxButton: TSpeedButton
        Tag = 3
        Left = 394
        Top = 23
        Width = 23
        Height = 22
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
      end
      object FindDosBoxButton: TSpeedButton
        Tag = 4
        Left = 421
        Top = 23
        Width = 23
        Height = 22
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
      end
      object DosBoxMapperButton: TSpeedButton
        Tag = 5
        Left = 394
        Top = 71
        Width = 23
        Height = 22
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
      end
      object SDLVideodriverLabel: TLabel
        Left = 16
        Top = 192
        Width = 113
        Height = 18
        AutoSize = False
        Caption = 'SDL Videotreiber:'
      end
      object SDLVideodriverInfoLabel: TLabel
        Left = 16
        Top = 216
        Width = 417
        Height = 58
        AutoSize = False
        Caption = 
          'Falls es nicht per Keymapper behebbare Probleme mit der Tastatur' +
          'belegung gibt, so kann das Umschalten auf "Win DIB" helfen.'
        WordWrap = True
      end
      object DosBoxDirEdit: TLabeledEdit
        Left = 16
        Top = 24
        Width = 361
        Height = 21
        EditLabel.Width = 67
        EditLabel.Height = 13
        EditLabel.Caption = 'DosBoxDirEdit'
        TabOrder = 0
        OnChange = DosBoxDirEditChange
      end
      object HideDosBoxConsoleCheckBox: TCheckBox
        Left = 16
        Top = 120
        Width = 401
        Height = 17
        Caption = 'DosBox-Console ausblenden'
        TabOrder = 2
      end
      object MinimizeDFendCheckBox: TCheckBox
        Left = 16
        Top = 152
        Width = 401
        Height = 17
        Caption = 'D-Fend minimieren, wenn DosBox gestartet wird'
        TabOrder = 3
      end
      object DosBoxMapperEdit: TLabeledEdit
        Left = 16
        Top = 72
        Width = 361
        Height = 21
        EditLabel.Width = 90
        EditLabel.Height = 13
        EditLabel.Caption = 'DosBoxMapperEdit'
        TabOrder = 1
        OnChange = DosBoxDirEditChange
      end
      object SDLVideoDriverComboBox: TComboBox
        Left = 117
        Top = 189
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 4
        Text = 'Direct X (default)'
        Items.Strings = (
          'Direct X (default)'
          'Win DIB')
      end
    end
    object SecuritySheet: TTabSheet
      Caption = 'Sicherheit'
      ImageIndex = 5
      object DeleteProectionLabel: TLabel
        Left = 40
        Top = 88
        Width = 363
        Height = 57
        AutoSize = False
        Caption = 
          'Diese Option stellt sicher, dass auch beim L'#246'schen von falsch ko' +
          'nfigurierten Profilen niemals Dateien, die nicht zu D-Fend geh'#246'r' +
          'en, gel'#246'scht werden k'#246'nnen.'
        WordWrap = True
      end
      object AskBeforeDeleteCheckBox: TCheckBox
        Left = 16
        Top = 24
        Width = 387
        Height = 17
        Caption = 'Vor dem L'#246'schen von Eintr'#228'gen nachfragen'
        TabOrder = 0
      end
      object DeleteProectionCheckBox: TCheckBox
        Left = 16
        Top = 64
        Width = 387
        Height = 17
        Caption = 'Niemals Dateien au'#223'erhalb des Basis-Verzeichnisses l'#246'schen'
        TabOrder = 1
      end
    end
    object DefaultValueSheet: TTabSheet
      Caption = 'Vorgabewerte'
      ImageIndex = 1
      object DefaultValueLabel: TLabel
        Left = 11
        Top = 19
        Width = 50
        Height = 13
        Caption = 'Kategorie:'
      end
      object DefaultValueSpeedButton: TSpeedButton
        Left = 248
        Top = 16
        Width = 23
        Height = 22
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000130B0000130B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333FFFFF3333333333999993333333333F77777FFF333333999999999
          3333333777333777FF3333993333339993333377FF3333377FF3399993333339
          993337777FF3333377F3393999333333993337F777FF333337FF993399933333
          399377F3777FF333377F993339993333399377F33777FF33377F993333999333
          399377F333777FF3377F993333399933399377F3333777FF377F993333339993
          399377FF3333777FF7733993333339993933373FF3333777F7F3399933333399
          99333773FF3333777733339993333339933333773FFFFFF77333333999999999
          3333333777333777333333333999993333333333377777333333}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = DefaultValueSpeedButtonClick
      end
      object DefaultValueComboBox: TComboBox
        Left = 88
        Top = 16
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = DefaultValueComboBoxChange
      end
      object DefaultValueMemo: TRichEdit
        Left = 11
        Top = 44
        Width = 260
        Height = 221
        PlainText = True
        ScrollBars = ssVertical
        TabOrder = 1
      end
    end
    object ServiceSheet: TTabSheet
      Caption = 'Upgrade'
      ImageIndex = 2
      object Service1Button: TBitBtn
        Left = 16
        Top = 24
        Width = 417
        Height = 33
        Caption = 'Alte, nicht mehr genutzte Setup-Dateien von D-Fend v2 l'#246'schen'
        TabOrder = 0
        WordWrap = True
        OnClick = UpgradeButtonClick
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
      object Service2Button: TBitBtn
        Tag = 1
        Left = 16
        Top = 72
        Width = 417
        Height = 33
        Caption = 'Absolute durch relative Pfade ersetzen'
        TabOrder = 1
        WordWrap = True
        OnClick = UpgradeButtonClick
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
          55555555FFFFFFFFFF55555000000000055555577777777775F55500B8B8B8B8
          B05555775F555555575F550F0B8B8B8B8B05557F75F555555575550BF0B8B8B8
          B8B0557F575FFFFFFFF7550FBF0000000000557F557777777777500BFBFBFBFB
          0555577F555555557F550B0FBFBFBFBF05557F7F555555FF75550F0BFBFBF000
          55557F75F555577755550BF0BFBF0B0555557F575FFF757F55550FB700007F05
          55557F557777557F55550BFBFBFBFB0555557F555555557F55550FBFBFBFBF05
          55557FFFFFFFFF7555550000000000555555777777777755555550FBFB055555
          5555575FFF755555555557000075555555555577775555555555}
        NumGlyphs = 2
      end
      object Service3Button: TBitBtn
        Tag = 2
        Left = 16
        Top = 119
        Width = 417
        Height = 33
        Caption = '"DosBox DOS"-Profil wiederherstellen'
        TabOrder = 2
        WordWrap = True
        OnClick = UpgradeButtonClick
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333333FFFFFFFFFFFFF33000077777770033377777777777773F000007888888
          00037F3337F3FF37F37F00000780088800037F3337F77F37F37F000007800888
          00037F3337F77FF7F37F00000788888800037F3337777777337F000000000000
          00037F3FFFFFFFFFFF7F00000000000000037F77777777777F7F000FFFFFFFFF
          00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
          00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
          00037F7F333333337F7F000FFFFFFFFF07037F7F33333333777F000FFFFFFFFF
          0003737FFFFFFFFF7F7330099999999900333777777777777733}
        NumGlyphs = 2
      end
      object Service4Button: TBitBtn
        Tag = 3
        Left = 16
        Top = 168
        Width = 417
        Height = 33
        Caption = 'Vorgabe-Profil wiederherstellen'
        TabOrder = 3
        WordWrap = True
        OnClick = UpgradeButtonClick
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333333FFFFFFFFFFFFF33000077777770033377777777777773F000007888888
          00037F3337F3FF37F37F00000780088800037F3337F77F37F37F000007800888
          00037F3337F77FF7F37F00000788888800037F3337777777337F000000000000
          00037F3FFFFFFFFFFF7F00000000000000037F77777777777F7F000FFFFFFFFF
          00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
          00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
          00037F7F333333337F7F000FFFFFFFFF07037F7F33333333777F000FFFFFFFFF
          0003737FFFFFFFFF7F7330099999999900333777777777777733}
        NumGlyphs = 2
      end
    end
  end
  object DefaultValuePopupMenu: TPopupMenu
    Left = 392
    Top = 8
    object PopupThisValue: TMenuItem
      Caption = 'Diese Kategorie'
      OnClick = PopupMenuWork
    end
    object PopupAllValues: TMenuItem
      Tag = 1
      Caption = 'Alle Kategorien'
      OnClick = PopupMenuWork
    end
  end
  object DosBoxLngOpenDialog: TOpenDialog
    DefaultExt = 'lng'
    Left = 360
    Top = 8
  end
  object DosBoxTxtOpenDialog: TOpenDialog
    DefaultExt = 'txt'
    Left = 328
    Top = 8
  end
end
