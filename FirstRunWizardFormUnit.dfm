object FirstRunWizardForm: TFirstRunWizardForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'FirstRunWizardForm'
  ClientHeight = 293
  ClientWidth = 565
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    565
    293)
  PixelsPerInch = 96
  TextHeight = 13
  object Notebook: TNotebook
    Left = -1
    Top = 0
    Width = 569
    Height = 258
    Anchors = [akLeft, akTop, akRight, akBottom]
    PageIndex = 1
    TabOrder = 0
    object TPage
      Left = 0
      Top = 0
      Caption = 'Start'
      object StartLabel: TLabel
        Left = 8
        Top = 8
        Width = 553
        Height = 50
        AutoSize = False
        Caption = 
          'In this wizard you can configurate the basic settings needed to ' +
          'use D-Fend Reloaded. You can also change all settings offered in' +
          ' this wizard from the program settings dialog.'
        WordWrap = True
      end
      object StartLabelLanguage: TLabel
        Left = 8
        Top = 60
        Width = 91
        Height = 13
        Caption = 'Program language:'
      end
      object StartLabelLanguageValue: TLabel
        Left = 8
        Top = 75
        Width = 33
        Height = 13
        Caption = 'English'
      end
      object StartLabelDOSBox: TLabel
        Left = 8
        Top = 100
        Width = 74
        Height = 13
        Caption = 'DOSBox folder:'
      end
      object StartLabelDOSBoxValue: TLabel
        Left = 8
        Top = 115
        Width = 253
        Height = 13
        Caption = 'Default (C:\Program files\D-Fend Reloaded\DOSBox)'
      end
      object StartLabelDOSBoxLanguage: TLabel
        Left = 8
        Top = 140
        Width = 90
        Height = 13
        Caption = 'DOSBox language:'
      end
      object StartLabelDOSBoxLanguageValue: TLabel
        Left = 8
        Top = 155
        Width = 33
        Height = 13
        Caption = 'English'
      end
      object StartLabelGamesFolder: TLabel
        Left = 8
        Top = 180
        Width = 67
        Height = 13
        Caption = 'Games folder:'
      end
      object StartLabelGamesFolderValue: TLabel
        Left = 8
        Top = 195
        Width = 245
        Height = 13
        Caption = 'Default (C:\Users\you\D-Fend Reloaded\VirtualHD)'
      end
      object StartLabelUpdates: TLabel
        Left = 8
        Top = 220
        Width = 83
        Height = 13
        Caption = 'Update checking:'
      end
      object StartLabelUpdatesValue: TLabel
        Left = 8
        Top = 235
        Width = 101
        Height = 13
        Caption = 'Manual checking only'
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'ProgramLanguage'
      object LanguageLabel: TLabel
        Left = 8
        Top = 79
        Width = 90
        Height = 13
        Caption = 'Programmsprache:'
      end
      object LanguageInfoLabel: TLabel
        Left = 8
        Top = 125
        Width = 537
        Height = 76
        AutoSize = False
        Caption = 'LanguageInfoLabel'
        Visible = False
        WordWrap = True
      end
      object LanguageTopInfoLabel: TLabel
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 537
        Height = 26
        Caption = 
          'Please select the language you want to use in D-Fend Reloaded. I' +
          'f there is already the correct language select, you can directly' +
          ' click on "Next".'
        WordWrap = True
      end
      object LanguageComboBox: TComboBox
        Left = 8
        Top = 98
        Width = 290
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = LanguageComboBoxChange
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'DOSBox'
      DesignSize = (
        569
        258)
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
        Left = 8
        Top = 8
        Width = 545
        Height = 57
        AutoSize = False
        Caption = 
          'Please select the folder where DOSBox is located. If the edit fi' +
          'eld is not empty, D-Fend Reloaded has already found the DOSBox d' +
          'irectory and you can directly click on "Next".'
        WordWrap = True
      end
      object DOSBoxInfoLabel: TLabel
        Left = 8
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
        Left = 8
        Top = 98
        Width = 516
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
      object DosBoxLangLabel: TLabel
        Left = 8
        Top = 79
        Width = 84
        Height = 13
        Caption = 'DosBoxLangLabel'
      end
      object DOSBoxLanguageTopInfoLabel: TLabel
        Left = 8
        Top = 8
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
        Left = 8
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
        Left = 8
        Top = 98
        Width = 290
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'GameDir'
      object GameDirTopInfoLabel: TLabel
        Left = 8
        Top = 8
        Width = 545
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
        Left = 8
        Top = 125
        Width = 537
        Height = 84
        AutoSize = False
        Caption = 'GameDirInfoLabel'
        WordWrap = True
      end
      object GameDirEdit: TLabeledEdit
        Left = 8
        Top = 98
        Width = 516
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
      DesignSize = (
        569
        258)
      object UpdateLabel: TLabel
        Left = 8
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
        Left = 8
        Top = 8
        Width = 309
        Height = 13
        Caption = 'Please select when D-Fend Reloaded should search for updates:'
      end
      object Update0RadioButton: TRadioButton
        Left = 8
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
        Left = 8
        Top = 58
        Width = 540
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Einmal w'#246'chentlich pr'#252'fen'
        TabOrder = 1
      end
      object Update2RadioButton: TRadioButton
        Left = 8
        Top = 81
        Width = 540
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Einmal t'#228'glich pr'#252'fen'
        TabOrder = 2
      end
      object Update3RadioButton: TRadioButton
        Left = 8
        Top = 104
        Width = 540
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Bei jedem Start pr'#252'fen'
        TabOrder = 3
      end
      object UpdateCheckBox: TCheckBox
        Left = 8
        Top = 135
        Width = 550
        Height = 17
        Caption = 'Kennung der aktuellen Version in die Abfrage-URL integrieren'
        TabOrder = 4
      end
      object UpdateNowCheckBox: TCheckBox
        Left = 8
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
    Top = 264
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Back'
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
    Left = 60
    Top = 264
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
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
    Left = 99
    Top = 264
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 3
    Visible = False
    Kind = bkOK
  end
  object AcceptAllSettingsButton: TBitBtn
    Left = 317
    Top = 264
    Width = 198
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Accept all settings'
    TabOrder = 4
    Kind = bkAll
  end
  object HelpButton: TBitBtn
    Left = 521
    Top = 264
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 6
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object EditSettingsButton: TBitBtn
    Left = 182
    Top = 264
    Width = 198
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Edit settings'
    TabOrder = 5
    OnClick = NextButtonClick
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
end
