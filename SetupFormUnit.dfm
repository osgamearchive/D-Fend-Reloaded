object SetupForm: TSetupForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'SetupForm'
  ClientHeight = 417
  ClientWidth = 604
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
  object ModeLabel: TLabel
    Left = 248
    Top = 387
    Width = 35
    Height = 13
    Caption = 'Modus:'
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 383
    Width = 97
    Height = 25
    TabOrder = 1
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 383
    Width = 97
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object PageControl: TPageControl
    Left = -1
    Top = 0
    Width = 610
    Height = 377
    ActivePage = GeneralSheet
    Images = ImageList
    MultiLine = True
    TabOrder = 0
    object GeneralSheet: TTabSheet
      Caption = 'Allgemein'
      object AddButtonFunctionLabel: TLabel
        Left = 16
        Top = 153
        Width = 183
        Height = 13
        Caption = 'Funktion der Hinzuf'#252'gen-Schaltfl'#228'che:'
      end
      object StartSizeLabel: TLabel
        Left = 16
        Top = 16
        Width = 168
        Height = 13
        Caption = 'Fenstergr'#246#223'e beim Programmstart:'
      end
      object MinimizeToTrayCheckBox: TCheckBox
        Left = 16
        Top = 84
        Width = 387
        Height = 17
        Caption = 'In den Benachrichtigungsbereich minimieren'
        TabOrder = 1
      end
      object AddButtonFunctionComboBox: TComboBox
        Left = 16
        Top = 172
        Width = 233
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 2
        TabOrder = 3
        Text = 'Auswahlmen'#252
        Items.Strings = (
          'Hinzuf'#252'gen-Dialog'
          'Assistent'
          'Auswahlmen'#252)
      end
      object StartWithWindowsCheckBox: TCheckBox
        Left = 16
        Top = 116
        Width = 422
        Height = 17
        Caption = 'Mit Windows starten'
        TabOrder = 2
      end
      object StartSizeComboBox: TComboBox
        Left = 16
        Top = 37
        Width = 233
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'Vorgabewerte f'#252'r Fenstergr'#246#223'e'
        Items.Strings = (
          'Vorgabewerte f'#252'r Fenstergr'#246#223'e'
          'Letzte Fenstergr'#246#223'e wiederherstellen'
          'Minimiert starten'
          'Maximiert starten')
      end
      object ToolbarGroupBox: TGroupBox
        Left = 16
        Top = 213
        Width = 569
        Height = 113
        Caption = 'Symbolleiste'
        TabOrder = 4
        DesignSize = (
          569
          113)
        object ToolbarFontSizeLabel: TLabel
          Left = 15
          Top = 61
          Width = 59
          Height = 13
          Caption = 'Schriftgr'#246#223'e'
        end
        object ToolbarImageButton: TSpeedButton
          Tag = 9
          Left = 530
          Top = 23
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
          ExplicitLeft = 482
        end
        object ToolbarImageEdit: TEdit
          Left = 152
          Top = 25
          Width = 372
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          OnChange = ToolbarImageEditChange
        end
        object ToolbarFontSizeEdit: TSpinEdit
          Left = 15
          Top = 80
          Width = 59
          Height = 22
          MaxValue = 48
          MinValue = 1
          TabOrder = 2
          Value = 9
        end
        object ToolbarImageCheckBox: TCheckBox
          Left = 16
          Top = 27
          Width = 130
          Height = 17
          Caption = 'Hintergrundbild'
          TabOrder = 0
        end
      end
    end
    object DirectorySheet: TTabSheet
      Caption = 'Verzeichnisse'
      ImageIndex = 1
      DesignSize = (
        602
        329)
      object BaseDirButton: TSpeedButton
        Left = 569
        Top = 31
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
      end
      object GameDirButton: TSpeedButton
        Tag = 1
        Left = 569
        Top = 87
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
      end
      object DataDirButton: TSpeedButton
        Tag = 2
        Left = 569
        Top = 143
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
      end
      object BaseDirEdit: TLabeledEdit
        Left = 16
        Top = 32
        Width = 547
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 54
        EditLabel.Height = 13
        EditLabel.Caption = 'BaseDirEdit'
        TabOrder = 0
      end
      object GameDirEdit: TLabeledEdit
        Left = 16
        Top = 88
        Width = 547
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 58
        EditLabel.Height = 13
        EditLabel.Caption = 'GameDirEdit'
        TabOrder = 1
      end
      object DataDirEdit: TLabeledEdit
        Left = 16
        Top = 145
        Width = 547
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 54
        EditLabel.Height = 13
        EditLabel.Caption = 'DataDirEdit'
        TabOrder = 2
      end
    end
    object LanguageSheet: TTabSheet
      Caption = 'Sprache'
      ImageIndex = 2
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
      object LanguageInfoLabel: TLabel
        Left = 208
        Top = 35
        Width = 385
        Height = 77
        AutoSize = False
        Caption = 'LanguageInfoLabel'
        Visible = False
        WordWrap = True
      end
      object LanguageComboBox: TComboBox
        Left = 16
        Top = 32
        Width = 169
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = LanguageComboBoxChange
      end
      object DosBoxLangEditComboBox: TComboBox
        Left = 16
        Top = 91
        Width = 169
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
      end
    end
    object ListViewSheet: TTabSheet
      Caption = 'Spieleliste'
      ImageIndex = 3
      DesignSize = (
        602
        329)
      object PageControl1: TPageControl
        Left = 6
        Top = 11
        Width = 588
        Height = 298
        ActivePage = ListViewSheet1
        Anchors = [akLeft, akTop, akRight, akBottom]
        MultiLine = True
        TabOrder = 0
        object ListViewSheet1: TTabSheet
          Caption = 'Spalten in der Spieleliste'
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
          object ListViewListBox: TCheckListBox
            Left = 14
            Top = 35
            Width = 211
            Height = 102
            ItemHeight = 13
            TabOrder = 0
          end
        end
        object ListViewSheet2: TTabSheet
          Caption = 'Aussehen der Spieleliste'
          ImageIndex = 1
          object GamesListBackgroundButton: TSpeedButton
            Tag = 7
            Left = 544
            Top = 77
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
          object GamesListFontSizeLabel: TLabel
            Left = 16
            Top = 120
            Width = 59
            Height = 13
            Caption = 'Schriftgr'#246#223'e'
          end
          object GamesListFontColorLabel: TLabel
            Left = 96
            Top = 120
            Width = 61
            Height = 13
            Caption = 'Schriftfarbe:'
          end
          object GamesListBackgroundRadioButton1: TRadioButton
            Left = 16
            Top = 16
            Width = 551
            Height = 17
            Caption = 'Standard Hintergrundfarbe'
            Checked = True
            TabOrder = 0
            TabStop = True
          end
          object GamesListBackgroundRadioButton2: TRadioButton
            Left = 16
            Top = 48
            Width = 129
            Height = 17
            Caption = 'Hintergrundfarbe'
            TabOrder = 1
          end
          object GamesListBackgroundRadioButton3: TRadioButton
            Left = 16
            Top = 80
            Width = 129
            Height = 17
            Caption = 'Hintergrundbild'
            TabOrder = 3
          end
          object GamesListBackgroundColorBox: TColorBox
            Left = 151
            Top = 46
            Width = 130
            Height = 22
            ItemHeight = 16
            TabOrder = 2
            OnChange = GamesListBackgroundColorBoxChange
          end
          object GamesListBackgroundEdit: TEdit
            Left = 151
            Top = 78
            Width = 387
            Height = 21
            TabOrder = 4
            OnChange = GamesListBackgroundEditChange
          end
          object GamesListFontSizeEdit: TSpinEdit
            Left = 16
            Top = 139
            Width = 59
            Height = 22
            MaxValue = 48
            MinValue = 1
            TabOrder = 5
            Value = 9
          end
          object GamesListFontColorBox: TColorBox
            Left = 96
            Top = 139
            Width = 130
            Height = 22
            ItemHeight = 16
            TabOrder = 6
          end
        end
        object ListViewSheet3: TTabSheet
          Caption = 'Aussehen der Baumstruktur'
          ImageIndex = 2
          DesignSize = (
            580
            252)
          object TreeViewFontSizeLabel: TLabel
            Left = 16
            Top = 88
            Width = 59
            Height = 13
            Caption = 'Schriftgr'#246#223'e'
          end
          object TreeViewFontColorLabel: TLabel
            Left = 96
            Top = 88
            Width = 61
            Height = 13
            Caption = 'Schriftfarbe:'
          end
          object TreeViewGroupsLabel: TLabel
            Left = 16
            Top = 144
            Width = 137
            Height = 13
            Caption = 'Benutzerdefinierte Gruppen:'
          end
          object TreeViewGroupsInfoLabel: TLabel
            Left = 216
            Top = 168
            Width = 351
            Height = 73
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 
              'Die benutzerdefinierten Gruppen werden in der Baumstruktur als w' +
              'eitere Filterkategorien angeboten. Bei den Spielen k'#246'nnen Werte ' +
              'f'#252'r die Kategorien '#252'ber die "Benutzerdefinierten Informationen" ' +
              'definiert werden.'
            WordWrap = True
          end
          object TreeViewBackgroundColorBox: TColorBox
            Left = 151
            Top = 46
            Width = 130
            Height = 22
            ItemHeight = 16
            TabOrder = 0
            OnChange = TreeViewBackgroundColorBoxChange
          end
          object TreeViewBackgroundRadioButton2: TRadioButton
            Left = 16
            Top = 48
            Width = 129
            Height = 17
            Caption = 'Hintergrundfarbe'
            TabOrder = 1
          end
          object TreeViewBackgroundRadioButton1: TRadioButton
            Left = 16
            Top = 16
            Width = 551
            Height = 17
            Caption = 'Standard Hintergrundfarbe'
            Checked = True
            TabOrder = 2
            TabStop = True
          end
          object TreeViewFontSizeEdit: TSpinEdit
            Left = 16
            Top = 107
            Width = 59
            Height = 22
            MaxValue = 48
            MinValue = 1
            TabOrder = 3
            Value = 9
          end
          object TreeViewFontColorBox: TColorBox
            Left = 96
            Top = 107
            Width = 130
            Height = 22
            ItemHeight = 16
            TabOrder = 4
          end
          object TreeViewGroupsEdit: TMemo
            Left = 16
            Top = 163
            Width = 185
            Height = 78
            TabOrder = 5
          end
        end
        object ListViewSheet4: TTabSheet
          Caption = 'Aussehen der Screenshot-Vorschau'
          ImageIndex = 3
          object ScreenshotPreviewLabel: TLabel
            Left = 16
            Top = 176
            Width = 157
            Height = 13
            Caption = 'Gr'#246#223'e der Screenshot-Vorschau:'
          end
          object ScreenshotsListBackgroundButton: TSpeedButton
            Tag = 8
            Left = 544
            Top = 77
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
          object ScreenshotsListFontSizeLabel: TLabel
            Left = 16
            Top = 120
            Width = 59
            Height = 13
            Caption = 'Schriftgr'#246#223'e'
          end
          object ScreenshotsListFontColorLabel: TLabel
            Left = 96
            Top = 120
            Width = 61
            Height = 13
            Caption = 'Schriftfarbe:'
          end
          object ScreenshotPreviewEdit: TSpinEdit
            Left = 16
            Top = 195
            Width = 67
            Height = 22
            MaxValue = 250
            MinValue = 20
            TabOrder = 0
            Value = 100
          end
          object ScreenshotsListBackgroundRadioButton2: TRadioButton
            Left = 16
            Top = 48
            Width = 129
            Height = 17
            Caption = 'Hintergrundfarbe'
            TabOrder = 1
          end
          object ScreenshotsListBackgroundColorBox: TColorBox
            Left = 151
            Top = 46
            Width = 130
            Height = 22
            ItemHeight = 16
            TabOrder = 2
            OnChange = ScreenshotsListBackgroundColorBoxChange
          end
          object ScreenshotsListBackgroundRadioButton3: TRadioButton
            Left = 16
            Top = 80
            Width = 129
            Height = 17
            Caption = 'Hintergrundbild'
            TabOrder = 3
          end
          object ScreenshotsListBackgroundEdit: TEdit
            Left = 151
            Top = 78
            Width = 387
            Height = 21
            TabOrder = 4
            OnChange = ScreenshotsListBackgroundEditChange
          end
          object ScreenshotsListFontSizeEdit: TSpinEdit
            Left = 16
            Top = 139
            Width = 59
            Height = 22
            MaxValue = 48
            MinValue = 1
            TabOrder = 5
            Value = 9
          end
          object ScreenshotsListFontColorBox: TColorBox
            Left = 96
            Top = 139
            Width = 130
            Height = 22
            ItemHeight = 16
            TabOrder = 6
          end
          object ScreenshotsListBackgroundRadioButton1: TRadioButton
            Left = 16
            Top = 16
            Width = 551
            Height = 17
            Caption = 'Standard Hintergrundfarbe'
            Checked = True
            TabOrder = 7
            TabStop = True
          end
        end
      end
    end
    object ProfileEditorSheet: TTabSheet
      Caption = 'Profileditor'
      ImageIndex = 8
      DesignSize = (
        602
        329)
      object ReopenLastActiveProfileSheetCheckBox: TCheckBox
        Left = 14
        Top = 24
        Width = 571
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Zuletzt aktive Seite im Profileditor merken'
        TabOrder = 0
      end
      object ProfileEditorDFendRadioButton: TRadioButton
        Left = 16
        Top = 65
        Width = 569
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Klassischen D-Fend Profileditor verwenden'
        TabOrder = 1
      end
      object ProfileEditorModernRadioButton: TRadioButton
        Left = 16
        Top = 85
        Width = 569
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Modernen Profileditor verwenden'
        Checked = True
        TabOrder = 2
        TabStop = True
      end
    end
    object DosBoxSheet: TTabSheet
      Caption = 'DosBox'
      ImageIndex = 4
      DesignSize = (
        602
        329)
      object DosBoxButton: TSpeedButton
        Tag = 3
        Left = 538
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
      end
      object FindDosBoxButton: TSpeedButton
        Tag = 4
        Left = 565
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
      end
      object DosBoxMapperButton: TSpeedButton
        Tag = 5
        Left = 538
        Top = 132
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
      end
      object SDLVideodriverLabel: TLabel
        Left = 16
        Top = 244
        Width = 113
        Height = 18
        AutoSize = False
        Caption = 'SDL Videotreiber:'
      end
      object SDLVideodriverInfoLabel: TLabel
        Left = 16
        Top = 268
        Width = 572
        Height = 58
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'Falls es nicht per Keymapper behebbare Probleme mit der Tastatur' +
          'belegung gibt, so kann das Umschalten auf "Win DIB" helfen.'
        WordWrap = True
      end
      object PathFREEDOSButton: TSpeedButton
        Tag = 6
        Left = 538
        Top = 82
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
      end
      object DosBoxDirEdit: TLabeledEdit
        Left = 16
        Top = 32
        Width = 516
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
        Top = 172
        Width = 572
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'DosBox-Console ausblenden'
        TabOrder = 3
      end
      object MinimizeDFendCheckBox: TCheckBox
        Left = 16
        Top = 204
        Width = 572
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'D-Fend minimieren, wenn DosBox gestartet wird'
        TabOrder = 4
      end
      object DosBoxMapperEdit: TLabeledEdit
        Left = 16
        Top = 132
        Width = 516
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 90
        EditLabel.Height = 13
        EditLabel.Caption = 'DosBoxMapperEdit'
        TabOrder = 2
        OnChange = DosBoxDirEditChange
      end
      object SDLVideoDriverComboBox: TComboBox
        Left = 117
        Top = 241
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
      object PathFREEDOSEdit: TLabeledEdit
        Left = 16
        Top = 82
        Width = 516
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 86
        EditLabel.Height = 13
        EditLabel.Caption = 'PathFREEDOSEdit'
        TabOrder = 1
        OnChange = DosBoxDirEditChange
      end
    end
    object WaveEncSheet: TTabSheet
      Caption = 'Wave Encoder'
      ImageIndex = 9
      DesignSize = (
        602
        329)
      object WaveEncMp3Button1: TSpeedButton
        Tag = 10
        Left = 538
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
      end
      object WaveEncMp3Button2: TSpeedButton
        Tag = 11
        Left = 565
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
      end
      object WaveEncOggButton1: TSpeedButton
        Tag = 12
        Left = 538
        Top = 82
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
      object WaveEncOggButton2: TSpeedButton
        Tag = 13
        Left = 567
        Top = 82
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
      end
      object WaveEncMp3Edit: TLabeledEdit
        Left = 16
        Top = 32
        Width = 516
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 83
        EditLabel.Height = 13
        EditLabel.Caption = 'WaveEncMp3Edit'
        TabOrder = 0
        OnChange = DosBoxDirEditChange
      end
      object WaveEncOggEdit: TLabeledEdit
        Left = 16
        Top = 82
        Width = 516
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        EditLabel.Width = 83
        EditLabel.Height = 13
        EditLabel.Caption = 'WaveEncOggEdit'
        TabOrder = 1
        OnChange = DosBoxDirEditChange
      end
    end
    object SecuritySheet: TTabSheet
      Caption = 'Sicherheit'
      ImageIndex = 5
      DesignSize = (
        602
        329)
      object DeleteProectionLabel: TLabel
        Left = 40
        Top = 88
        Width = 545
        Height = 57
        Anchors = [akLeft, akTop, akRight]
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
        Width = 569
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Vor dem L'#246'schen von Eintr'#228'gen nachfragen'
        TabOrder = 0
      end
      object DeleteProectionCheckBox: TCheckBox
        Left = 16
        Top = 64
        Width = 569
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Niemals Dateien au'#223'erhalb des Basis-Verzeichnisses l'#246'schen'
        TabOrder = 1
      end
    end
    object DefaultValueSheet: TTabSheet
      Caption = 'Vorgabewerte'
      ImageIndex = 6
      DesignSize = (
        602
        329)
      object DefaultValueLabel: TLabel
        Left = 11
        Top = 19
        Width = 50
        Height = 13
        Caption = 'Kategorie:'
      end
      object DefaultValueSpeedButton: TSpeedButton
        Left = 293
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
        Width = 192
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = DefaultValueComboBoxChange
      end
      object DefaultValueMemo: TRichEdit
        Left = 11
        Top = 44
        Width = 574
        Height = 261
        Anchors = [akLeft, akTop, akRight]
        PlainText = True
        ScrollBars = ssVertical
        TabOrder = 1
        WordWrap = False
      end
    end
    object ServiceSheet: TTabSheet
      Caption = 'Service'
      ImageIndex = 7
      DesignSize = (
        602
        329)
      object Service1Button: TBitBtn
        Left = 16
        Top = 79
        Width = 569
        Height = 26
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Alte, nicht mehr genutzte Setup-Dateien von D-Fend v2 l'#246'schen'
        TabOrder = 2
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
        Top = 111
        Width = 569
        Height = 26
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Absolute durch relative Pfade ersetzen'
        TabOrder = 3
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
        Top = 15
        Width = 569
        Height = 26
        Anchors = [akLeft, akTop, akRight]
        Caption = '"DosBox DOS"-Profil wiederherstellen'
        TabOrder = 0
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
        Top = 47
        Width = 569
        Height = 26
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Vorgabe-Profil wiederherstellen'
        TabOrder = 1
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
      object UpdateGroupBox: TGroupBox
        Left = 16
        Top = 143
        Width = 569
        Height = 172
        Caption = 'Nach Updates suchen'
        TabOrder = 4
        DesignSize = (
          569
          172)
        object UpdateLabel: TLabel
          Left = 16
          Top = 120
          Width = 550
          Height = 49
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 
            'Bei der Update-Pr'#252'fung werden keine Daten ins Internet '#252'bertrage' +
            'n. Es wird lediglich eine auf SourceForge.net gespeicherte Datei' +
            ' ausgelesen und dann ggf. angeboten, die regul'#228're Update-Datei h' +
            'erunterzuladen.'
          WordWrap = True
        end
        object Update3RadioButton: TRadioButton
          Left = 16
          Top = 93
          Width = 569
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Bei jedem Start pr'#252'fen'
          TabOrder = 0
        end
        object Update2RadioButton: TRadioButton
          Left = 16
          Top = 70
          Width = 569
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Einmal t'#228'glich pr'#252'fen'
          TabOrder = 1
        end
        object Update1RadioButton: TRadioButton
          Left = 16
          Top = 47
          Width = 569
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Einmal w'#246'chentlich pr'#252'fen'
          TabOrder = 2
        end
        object Update0RadioButton: TRadioButton
          Left = 16
          Top = 24
          Width = 569
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Nur manuell auf Updates pr'#252'fen (Men'#252': Hilfe|Nach Updates suchen)'
          Checked = True
          TabOrder = 3
          TabStop = True
        end
      end
    end
  end
  object ModeComboBox: TComboBox
    Left = 296
    Top = 383
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 3
    Text = 'Easy'
    OnChange = ModeComboBoxChange
    Items.Strings = (
      'Easy'
      'Advanced')
  end
  object DefaultValuePopupMenu: TPopupMenu
    Left = 504
    Top = 385
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
    Left = 472
    Top = 385
  end
  object DosBoxTxtOpenDialog: TOpenDialog
    DefaultExt = 'txt'
    Left = 440
    Top = 385
  end
  object PrgOpenDialog: TOpenDialog
    DefaultExt = 'exe'
    Left = 408
    Top = 385
  end
  object ImageList: TImageList
    Left = 536
    Top = 389
    Bitmap = {
      494C01010A000C00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
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
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000BFBFBF0000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000FFFFFF00000000000000000000000000FFFF
      FF000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000007F7F7F00000000007F7F7F00BFBFBF007F7F7F00000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      00007F7F7F007F7F7F0000000000BFBFBF00BFBFBF00BFBFBF00000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      00007F7F7F007F7F7F0000000000BFBFBF00BFBFBF00BFBFBF00000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFFFF00FFFFFF0000000000FFFFFF000000
      FF00FFFFFF00FF000000FFFFFF00000000000000000000000000000000007F7F
      7F007F7F7F007F7F7F000000000000000000BFBFBF00BFBFBF00000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      FF00FFFFFF00FF000000FFFFFF0000000000000000007F7F7F0000000000BFBF
      BF00BFBFBF00BFBFBF0000000000BFBFBF0000000000BFBFBF007F7F7F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FF000000FFFFFF0000000000000000007F7F7F00000000007F7F
      7F007F7F7F007F7F7F0000000000BFBFBF0000000000BFBFBF007F7F7F000000
      00000000FF000000FF000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000BFBFBF0000000000BFBF
      BF00BFBFBF00BFBFBF0000000000BFBFBF0000000000BFBFBF007F7F7F000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000000000BFBF
      BF00BFBFBF00BFBFBF000000000000000000BFBFBF00BFBFBF00000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000BFBFBF00BFBFBF00000000007F7F7F00BFBFBF00BFBFBF00000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BFBFBF00BFBFBF00FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000BFBFBF00BFBFBF00000000000000000000000000000000000000
      0000BFBFBF00BFBFBF00000000007F7F7F007F7F7F00BFBFBF00000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BFBFBF007F7F7F007F7F7F007F7F7F007F7F7F00000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000BFBFBF00000000007F7F7F0000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000020400000408000004080000020
      6000002040000040800000408000004080000020600000206000004080000040
      8000002060000020600000204000002040000000000000000000000000000000
      00000000000000000000BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000002040000040A00040E0E00040E0
      E00000204000006060000040600040E0E00040E0E000004040000040600040E0
      E0000040400040E0E00000000000002040000000000000000000000000000000
      00007F7F7F007F7F7F00BFBFBF007F7F7F00000000007F7F7F00BFBFBF007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000002040000040800040E0E0000000
      000040E0E0000040600040E0E000004040000040600040E0E0000040400040E0
      E0000020400040E0E0000020400000204000000000000000000000000000BFBF
      BF00BFBFBF00BFBFBF00BFBFBF007F7F7F00000000007F7F7F00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF000000000000000000FFFF0000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      000000000000000000000000000000000000004060000040800040E0E00040E0
      E000002040000040600040E0E000000000004060600000FFFF00002040000040
      600040E0E0000020400000204000002040000000000000000000000000007F7F
      7F007F7F7F007F7F7F00BFBFBF00BFBFBF0000000000BFBFBF00BFBFBF007F7F
      7F007F7F7F007F7F7F000000000000000000FFFF00000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      000000000000000000000000000000000000002040000040800000FFFF000040
      600040E0E0004040600000E0E000000000000040600040E0E0000040600000E0
      E0000040400040E0E0000020400000204000000000000000000000000000BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00000000000000000000000000BFBFBF00BFBF
      BF00BFBFBF00BFBFBF000000000000000000FFFF000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      000000000000000000000000000000000000002040000040A00040E0E00040E0
      E00040608000406080004060800040E0E00040E0E000406080004060800040E0
      E0000040600040E0E00000406000002060000000000000000000000000007F7F
      7F007F7F7F007F7F7F007F7F7F000000000000000000000000007F7F7F007F7F
      7F007F7F7F007F7F7F000000000000000000FFFF00000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      000000000000000000000000000000000000004060004060A000406080004060
      8000406080004080800040808000406080004060800040808000408080004060
      800040608000406080000040800000206000000000000000000000000000BFBF
      BF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBF
      BF00BFBFBF00BFBFBF000000000000000000FFFF000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF0000000000000000000000FF000000FF00000000007F7F7F000000FF000000
      FF0000000000000000000000FF000000FF000000FF0000000000000000000000
      000000000000000000000000000000000000004060000060A000406080000020
      4000004040004080800040608000406080000020400000404000406080004060
      8000004040000040400000406000002060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF00000000000000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF007F7F7F000000FF00000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      000000000000000000000000000000000000002040000040A00040E0E00040E0
      E00000204000006060000040600040E0E00040E0E000002040004060800040E0
      E00040E0E0000020400000204000002060000000000000000000000000000000
      000000000000BFBFBF000000000000000000000000000000000000000000BFBF
      BF000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF00000000000000
      000000000000000000000000000000000000004060000040800040E0E0000000
      000040E0E0000040400040E0E000004040000040600040E0E000000000004060
      60000040600040E0E00000204000002060000000000000000000000000000000
      000000000000BFBFBF000000000000000000000000000000000000000000BFBF
      BF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      000000000000000000000000000000000000004060000040A00040E0E0000000
      000040E0E0000020400040E0E000000000004060600040E0E000000000004060
      600040E0E0004040600000406000002060000000000000000000000000000000
      000000000000BFBFBF000000000000000000000000000000000000000000BFBF
      BF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      000000000000000000000000000000000000002040000040A00000FFFF000040
      600040E0E0000040600040E0E000000000000040600040E0E0004040600000E0
      E000002040000020400000204000002040000000000000000000000000000000
      00007F7F7F007F7F7F00BFBFBF00000000000000000000000000BFBFBF007F7F
      7F007F7F7F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F000000
      FF0000000000000000000000000000000000002040000040A00000FFFF0040E0
      E000406080004080A0004060800040E0E00040E0E00040608000408080004060
      800040E0E00040E0E00000206000002060000000000000000000000000000000
      00000000000000000000BFBFBF00BFBFBF00BFBFBF00BFBFBF00BFBFBF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F000000FF00000000000000000000000000004060004060A0000040A0000040
      8000004080004060A00000408000004080000040800000408000406080000040
      8000004080000040800040408000004060000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF00000000000020400000406000004060000040
      6000004060000040600000406000004060000040600000406000004060000040
      6000004060000040600000406000002040000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      FF00000080000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007F7F7F00000000000000
      000000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      FF00000080000000FF0000000000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      FF00000080000000FF0000808000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00000000000000
      0000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      FF00000080000000FF0000808000008080000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000009966FF0099666600993300006633
      00006600000099330000999966009966FF000000CC009999CC00993333009933
      0000663300006600000066330000CC99990000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000FFFFFF000000000000000000FFFFFF000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      FF00000080000000FF0000808000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF00000000000000000000000000000000000000
      00000000000000000000000000000000000099CCFF006666FF00666699009933
      33009933000066000000996666009966FF000000CC00CC99CC00993300006600
      000066330000CC996600CCCCCC009999FF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000007F7F7F00000000000000
      000000000000FFFFFF00000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CC666600CCCC99009999FF006666
      FF006666990099333300996666009999CC000000CC00CC99CC00993333009999
      6600CCCCCC009999FF006666CC006633990000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000FFFFFF000000000000000000FFFFFF000000
      00000000000000000000FFFFFF000000000000000000000000007F7F7F000000
      0000FFFFFF00000000007F7F7F00000000000000000000000000000080000000
      8000000080000000800000008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CC66660099996600FFFFCC000000
      0000CCCCFF009999FF00FFFFCC006666FF000000CC009999FF00FFFFCC000000
      00009999FF009999FF00CCCC9900CC99660000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000007F7F7F0000000000000000000000000000808000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000003333CC006633FF003300CC003333
      CC003333CC003333CC003333CC003300CC003300CC003333CC003333CC003333
      CC003300CC006633CC003333FF003333CC0000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000FFFFFF000000000000000000FFFFFF000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000808000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000003333FF003333FF003333CC006633
      CC003300CC003333CC003333CC003300CC003333CC003300CC003333CC003333
      CC003333CC003300CC003333CC003333FF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000008080000080800000808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000CC996600CC996600CCCCCC009999
      FF00CCCCFF0000000000FFFFCC006666CC000000CC00CCCCCC00CCCCFF00CC99
      FF00CCCCFF0000000000CCCC9900CC66660000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000FFFFFF000000000000000000FFFFFF000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000808000008080000080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000066333300663399006666FF00CCCC
      FF00CC99CC0099663300CC6633006666FF000000CC00CC99CC00996633006633
      66006666CC009966FF00CCCCCC00CC99990000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000080800000808000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009966FF0099CCFF00CCCC99009966
      33006633000066000000CC9966006666CC003300FF009999CC00993300006633
      000099000000996666006666CC006699FF0000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000808000000000000000000000000000000000007F7F
      7F00000000007F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000099666600660000006600
      00006633000099330000996666009966FF000000CC009999FF00996600009900
      0000663300006633000099330000CC99990000000000BFBFBF00BFBFBF00FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000BFBFBF00BFBFBF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007F7F
      7F00000000007F7F7F0000000000000000000000000000FFFF0000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      00000000000000000000000000007F7F7F000000000000000000000000007F7F
      7F00000000007F7F7F0000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF000000000000FC7B00000000
      0000F837000000000000F03E000000000000E01D000000000000E01B00000000
      00008017000000000000001F0000000000000010000000000000001F00000000
      00008017000000000000E01B000000000000E01D000000000000F03E00000000
      FFFFF83700000000FFFFFC7B000000008000FC1FFFFFFFFF0000F007FFF8FFFF
      0000E00320F8F9FF0000C001007FF0FF0000C001007CF0FF0000C001003CE07F
      0000C001000FC07F0000C0010004843F0000E003000C1E3F0000F1C701FFFE1F
      0000F1C7E3FCFF1F0000F1C7FFFCFF8F0000F007FFFFFFC70000F80FFFF8FFE3
      0000FC1FFFF8FFF80000FFFFFFFFFFFFF862BFFFFFFFFFFF80E0BFFFFFFF0000
      01E0B049FFFF000001E0807F0000000031E1B07F0000000031C1B9FF00000000
      C181BFFF10100000C307B04900000000FE17807F00000000CC37B07F04040000
      A877B9FF0000000040F7BFFF0000000001E3048F80000000C1E307FFFFFF0000
      C0E307FFFFFFFFFFC83F9FFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object ImageOpenDialog: TOpenDialog
    DefaultExt = 'jpeg'
    Left = 568
    Top = 384
  end
end
