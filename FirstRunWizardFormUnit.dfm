object FirstRunWizardForm: TFirstRunWizardForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'FirstRunWizardForm'
  ClientHeight = 279
  ClientWidth = 565
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Notebook: TNotebook
    Left = -1
    Top = 0
    Width = 569
    Height = 241
    TabOrder = 0
    object TPage
      Left = 0
      Top = 0
      Caption = 'ProgramLanguage'
      object LanguageLabel: TLabel
        Left = 16
        Top = 79
        Width = 90
        Height = 13
        Caption = 'Programmsprache:'
      end
      object LanguageInfoLabel: TLabel
        Left = 16
        Top = 125
        Width = 497
        Height = 76
        AutoSize = False
        Caption = 'LanguageInfoLabel'
        Visible = False
        WordWrap = True
      end
      object LanguageTopInfoLabel: TLabel
        AlignWithMargins = True
        Left = 16
        Top = 16
        Width = 537
        Height = 26
        Caption = 
          'Please select the language you want to use in D-Fend Reloaded. I' +
          'f there is already the correct language select, you can directly' +
          ' click on "Next".'
        WordWrap = True
      end
      object LanguageComboBox: TComboBox
        Left = 16
        Top = 98
        Width = 290
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 0
        OnChange = LanguageComboBoxChange
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'DOSBox'
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        569
        241)
      object DosBoxButton: TSpeedButton
        Left = 530
        Top = 98
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
        OnClick = DosBoxButtonClick
      end
      object DOSBoxTopInfoLabel: TLabel
        Left = 16
        Top = 16
        Width = 537
        Height = 57
        AutoSize = False
        Caption = 
          'Please select the folder where DOSBox is located. If the edit fi' +
          'eld is not empty, D-Fend Reloaded has already found the DOSBox d' +
          'irectory and you can directly click on "Next".'
        WordWrap = True
      end
      object DOSBoxInfoLabel: TLabel
        Left = 16
        Top = 128
        Width = 537
        Height = 105
        AutoSize = False
        Caption = 
          'When adding games to D-Fend Reloaded, you can specify a custom D' +
          'OSBox program folder for each game. The DOSBox folder from this ' +
          'dialog will be used as the default DOSBox folder for games.'
        WordWrap = True
      end
      object WarningButton: TSpeedButton
        Left = 501
        Top = 97
        Width = 23
        Height = 22
        Anchors = [akTop, akRight]
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00EEEEEEEEEEEE
          EEEEEEEEEEEEEEEEEEEEEEEE99999999EEEEEEE9999009999EEEEE9999900999
          99EEEE999999999999EEEE999999999999EEEE999990099999EEEE9999900999
          99EEEE999990099999EEEE999990099999EEEE999990099999EEEEE999900999
          9EEEEEEE99999999EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE}
        ParentShowHint = False
        ShowHint = True
        Visible = False
        OnClick = WarningButtonClick
      end
      object DosBoxDirEdit: TLabeledEdit
        Left = 16
        Top = 98
        Width = 508
        Height = 21
        EditLabel.Width = 67
        EditLabel.Height = 13
        EditLabel.Caption = 'DosBoxDirEdit'
        TabOrder = 0
        OnChange = DosBoxDirEditChange
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'DOSBoxLanguage'
      ExplicitWidth = 0
      ExplicitHeight = 0
      object DosBoxLangLabel: TLabel
        Left = 16
        Top = 79
        Width = 84
        Height = 13
        Caption = 'DosBoxLangLabel'
      end
      object DOSBoxLanguageTopInfoLabel: TLabel
        Left = 16
        Top = 16
        Width = 545
        Height = 57
        AutoSize = False
        Caption = 
          'Please select the language you want to use in DOSBox. If there i' +
          's already the correct language select, you can directly click on' +
          ' "Next".'
        WordWrap = True
      end
      object DOSBoxLanguageInfoLabel2: TLabel
        Left = 16
        Top = 128
        Width = 545
        Height = 73
        AutoSize = False
        Caption = 
          'There are more DOSBox languages than D-Fend Reloaded languages. ' +
          'So you may want to set DOSBox to another language than D-Fend Re' +
          'loaded.'
        WordWrap = True
      end
      object DosBoxLangEditComboBox: TComboBox
        Left = 16
        Top = 98
        Width = 290
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 0
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'GameDir'
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GameDirTopInfoLabel: TLabel
        Left = 16
        Top = 16
        Width = 529
        Height = 57
        AutoSize = False
        Caption = 
          'Please select the directory you want to store your games in. Thi' +
          's directory will be shown at first when you open the "Select fil' +
          'e" dialog.'
        WordWrap = True
      end
      object GameDirButton: TSpeedButton
        Left = 530
        Top = 97
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
        OnClick = GameDirButtonClick
      end
      object GameDirInfoLabel: TLabel
        Left = 16
        Top = 125
        Width = 537
        Height = 84
        AutoSize = False
        Caption = 'GameDirInfoLabel'
        WordWrap = True
      end
      object GameDirEdit: TLabeledEdit
        Left = 16
        Top = 98
        Width = 506
        Height = 21
        EditLabel.Width = 58
        EditLabel.Height = 13
        EditLabel.Caption = 'GameDirEdit'
        TabOrder = 0
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Update'
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        569
        241)
      object UpdateLabel: TLabel
        Left = 32
        Top = 156
        Width = 534
        Height = 45
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 
          'Bei der Update-Pr'#252'fung werden keine Daten ins Internet '#252'bertrage' +
          'n. Es wird lediglich eine auf SourceForge.net gespeicherte Datei' +
          ' ausgelesen und dann ggf. angeboten, die regul'#228're Update-Datei h' +
          'erunterzuladen.'
        WordWrap = True
      end
      object UpdateTopInfoLabel: TLabel
        Left = 16
        Top = 16
        Width = 309
        Height = 13
        Caption = 'Please select when D-Fend Reloaded should search for updates:'
      end
      object Update0RadioButton: TRadioButton
        Left = 16
        Top = 35
        Width = 540
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Nur manuell auf Updates pr'#252'fen (Men'#252': Hilfe|Nach Updates suchen)'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object Update1RadioButton: TRadioButton
        Left = 16
        Top = 58
        Width = 540
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Einmal w'#246'chentlich pr'#252'fen'
        TabOrder = 1
      end
      object Update2RadioButton: TRadioButton
        Left = 16
        Top = 81
        Width = 540
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Einmal t'#228'glich pr'#252'fen'
        TabOrder = 2
      end
      object Update3RadioButton: TRadioButton
        Left = 16
        Top = 104
        Width = 540
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Bei jedem Start pr'#252'fen'
        TabOrder = 3
      end
      object UpdateCheckBox: TCheckBox
        Left = 16
        Top = 135
        Width = 550
        Height = 17
        Caption = 'Kennung der aktuellen Version in die Abfrage-URL integrieren'
        TabOrder = 4
      end
      object UpdateNowCheckBox: TCheckBox
        Left = 16
        Top = 207
        Width = 540
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Jetzt nach Updates suchen'
        TabOrder = 5
      end
    end
  end
  object BackButton: TBitBtn
    Left = 8
    Top = 247
    Width = 97
    Height = 25
    Caption = 'Zur'#252'ck'
    Enabled = False
    TabOrder = 1
    OnClick = BackButtonClick
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
    Left = 111
    Top = 247
    Width = 97
    Height = 25
    Caption = 'Next'
    TabOrder = 2
    OnClick = NextButtonClick
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
  object OKButton: TBitBtn
    Left = 111
    Top = 247
    Width = 97
    Height = 25
    TabOrder = 3
    Visible = False
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object AcceptAllSettingsButton: TBitBtn
    Left = 317
    Top = 247
    Width = 198
    Height = 25
    Caption = '&Alle Einstellungen akzeptieren'
    TabOrder = 5
    OnClick = OKButtonClick
    Kind = bkAll
  end
  object HelpButton: TBitBtn
    Left = 214
    Top = 247
    Width = 97
    Height = 25
    TabOrder = 4
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
end
