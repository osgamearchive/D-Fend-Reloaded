object WizardForm: TWizardForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'WizardForm'
  ClientHeight = 515
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 457
    Height = 476
    ActivePage = BaseSheet
    TabOrder = 0
    OnChange = PageControlChange
    object BaseSheet: TTabSheet
      Caption = 'Basiseinstellungen'
      object GamesFolderButton: TSpeedButton
        Left = 359
        Top = 144
        Width = 79
        Height = 22
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
      object ProgramButton: TSpeedButton
        Tag = 1
        Left = 415
        Top = 192
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
        OnClick = ButtonWork
      end
      object SetupButton: TSpeedButton
        Tag = 2
        Left = 415
        Top = 239
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
        OnClick = ButtonWork
      end
      object BaseInfoLabel1: TLabel
        Left = 16
        Top = 16
        Width = 169
        Height = 13
        Caption = 'Name des Programms / Spiels'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object BaseInfoLabel2: TLabel
        Left = 16
        Top = 104
        Width = 106
        Height = 13
        Caption = 'Zu startende Datei'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object BaseInfoLabel3: TLabel
        Left = 16
        Top = 288
        Width = 220
        Height = 13
        Caption = 'Zus'#228'tzliche Dateien (Handb'#252'cher usw.)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object DataFolderButton: TSpeedButton
        Tag = 4
        Left = 415
        Top = 376
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
        OnClick = ButtonWork
      end
      object BaseDataFolderButton: TSpeedButton
        Tag = 3
        Left = 359
        Top = 328
        Width = 79
        Height = 22
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
      object BaseName: TLabeledEdit
        Left = 16
        Top = 56
        Width = 393
        Height = 21
        EditLabel.Width = 140
        EditLabel.Height = 13
        EditLabel.Caption = 'Name des Programms / Spiels'
        TabOrder = 0
      end
      object GamesFolderEdit: TLabeledEdit
        Left = 16
        Top = 144
        Width = 337
        Height = 21
        EditLabel.Width = 295
        EditLabel.Height = 13
        EditLabel.Caption = 'Bitte entpacken Sie das Programm in ein Unterverzeichnis von'
        ReadOnly = True
        TabOrder = 1
      end
      object ProgramEdit: TLabeledEdit
        Left = 16
        Top = 192
        Width = 393
        Height = 21
        EditLabel.Width = 118
        EditLabel.Height = 13
        EditLabel.Caption = 'Zu startendes Programm'
        TabOrder = 2
      end
      object SetupEdit: TLabeledEdit
        Left = 16
        Top = 240
        Width = 393
        Height = 21
        EditLabel.Width = 129
        EditLabel.Height = 13
        EditLabel.Caption = 'Setup-Programm (optional)'
        TabOrder = 3
      end
      object BaseDataFolderEdit: TLabeledEdit
        Left = 16
        Top = 328
        Width = 337
        Height = 21
        EditLabel.Width = 342
        EditLabel.Height = 13
        EditLabel.Caption = 
          'Bitte entpacken Sie die zus'#228'tzlichen Dateien in ein Unterverzeic' +
          'hnis von'
        ReadOnly = True
        TabOrder = 4
      end
      object DataFolderEdit: TLabeledEdit
        Left = 16
        Top = 376
        Width = 393
        Height = 21
        EditLabel.Width = 241
        EditLabel.Height = 13
        EditLabel.Caption = 'Verzeichnis mit den zus'#228'tzlichen Dateien (optional)'
        TabOrder = 5
      end
    end
    object InfoSheet: TTabSheet
      Caption = 'Programminformationen'
      ImageIndex = 1
      object NotesLabel: TLabel
        Left = 12
        Top = 205
        Width = 69
        Height = 13
        Caption = 'Bemerkungen:'
      end
      object GameInfoValueListEditor: TValueListEditor
        Left = 12
        Top = 17
        Width = 426
        Height = 166
        Strings.Strings = (
          '=')
        TabOrder = 0
        ColWidths = (
          150
          270)
      end
      object NotesMemo: TMemo
        Left = 12
        Top = 224
        Width = 426
        Height = 209
        TabOrder = 1
      end
    end
    object SystemSheet: TTabSheet
      Caption = 'Systemeinstellungen'
      ImageIndex = 2
      object CPULabel: TLabel
        Left = 16
        Top = 152
        Width = 68
        Height = 13
        Caption = 'CPU-Leistung:'
      end
      object StartFullscreenCheckBox: TCheckBox
        Left = 16
        Top = 24
        Width = 409
        Height = 17
        Caption = 'Im Vollbildmodus starten'
        TabOrder = 0
      end
      object CloseDosBoxOnExitCheckBox: TCheckBox
        Left = 16
        Top = 64
        Width = 409
        Height = 17
        Caption = 'DosBox beim Beenden schlie'#223'en'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object CPUComboBox: TComboBox
        Left = 16
        Top = 171
        Width = 265
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 2
        Text = 'gering (Jump&&Run- und Brett-Spiele)'
        Items.Strings = (
          'gering (Jump&&Run- und Brett-Spiele)'
          'mehr (grafisch aufwendige Spiele)'
          'viel (3D-Spiele)')
      end
      object MoreRAMCheckBox: TCheckBox
        Left = 16
        Top = 104
        Width = 422
        Height = 17
        Caption = 'Programm ben'#246'tigt viel Arbeitsspeicher'
        TabOrder = 3
      end
    end
  end
  object NextButton: TBitBtn
    Tag = 1
    Left = 119
    Top = 482
    Width = 97
    Height = 25
    Caption = 'Weiter'
    TabOrder = 2
    OnClick = StepButtonWork
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
    Layout = blGlyphRight
    NumGlyphs = 2
  end
  object PreviousButton: TBitBtn
    Left = 8
    Top = 482
    Width = 97
    Height = 25
    Caption = 'Zur'#252'ck'
    Enabled = False
    TabOrder = 1
    OnClick = StepButtonWork
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
  object OKButton: TBitBtn
    Left = 232
    Top = 482
    Width = 97
    Height = 25
    Enabled = False
    TabOrder = 3
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 345
    Top = 482
    Width = 97
    Height = 25
    TabOrder = 4
    Kind = bkCancel
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'exe'
    Left = 384
  end
end
