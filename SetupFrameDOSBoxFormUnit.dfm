object SetupFrameDOSBoxForm: TSetupFrameDOSBoxForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'SetupFrameDOSBoxForm'
  ClientHeight = 448
  ClientWidth = 818
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
  DesignSize = (
    818
    448)
  PixelsPerInch = 96
  TextHeight = 13
  object DosBoxMapperButton: TSpeedButton
    Tag = 2
    Left = 787
    Top = 114
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
  object SDLVideodriverLabel: TLabel
    Left = 14
    Top = 308
    Width = 83
    Height = 13
    Caption = 'SDL Videotreiber:'
  end
  object SDLVideodriverInfoLabel: TLabel
    Left = 14
    Top = 358
    Width = 767
    Height = 50
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Falls es nicht per Keymapper behebbare Probleme mit der Tastatur' +
      'belegung gibt, so kann das Umschalten auf "Win DIB" helfen.'
    WordWrap = True
  end
  object DosBoxButton: TSpeedButton
    Left = 758
    Top = 24
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
    Tag = 1
    Left = 787
    Top = 24
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
  object DosBoxLangLabel: TLabel
    Left = 14
    Top = 52
    Width = 84
    Height = 13
    Caption = 'DosBoxLangLabel'
  end
  object WarningButton: TSpeedButton
    Left = 729
    Top = 24
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
  object DOSBoxKeyboardLayoutLabel: TLabel
    Left = 216
    Top = 52
    Width = 143
    Height = 13
    Caption = 'DOSBoxKeyboardLayoutLabel'
  end
  object DOSBoxCodepageLabel: TLabel
    Left = 416
    Top = 52
    Width = 113
    Height = 13
    Caption = 'DOSBoxCodepageLabel'
  end
  object DosBoxMapperEdit: TLabeledEdit
    Left = 14
    Top = 114
    Width = 738
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 90
    EditLabel.Height = 13
    EditLabel.Caption = 'DosBoxMapperEdit'
    TabOrder = 4
  end
  object HideDosBoxConsoleCheckBox: TCheckBox
    Left = 14
    Top = 200
    Width = 767
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'DosBox-Console ausblenden'
    TabOrder = 6
  end
  object CenterDOSBoxCheckBox: TCheckBox
    Left = 14
    Top = 223
    Width = 767
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'CenterDOSBoxCheckBox'
    TabOrder = 7
  end
  object SDLVideoDriverComboBox: TComboBox
    Left = 14
    Top = 323
    Width = 243
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 10
    Text = 'Direct X'
    Items.Strings = (
      'Direct X'
      'Win DIB')
  end
  object DisableScreensaverCheckBox: TCheckBox
    Left = 14
    Top = 246
    Width = 767
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Disable screensaver when DOSBox is running'
    TabOrder = 8
  end
  object CommandLineEdit: TLabeledEdit
    Left = 14
    Top = 160
    Width = 738
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 84
    EditLabel.Height = 13
    EditLabel.Caption = 'CommandLineEdit'
    TabOrder = 5
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 414
    Width = 97
    Height = 27
    TabOrder = 11
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 414
    Width = 97
    Height = 27
    TabOrder = 12
    Kind = bkCancel
  end
  object RestoreDefaultValuesButton: TBitBtn
    Left = 231
    Top = 414
    Width = 202
    Height = 28
    Caption = 'Vorgabewerte wiederherstellen'
    TabOrder = 13
    OnClick = RestoreDefaultValuesButtonClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333444444
      33333333333F8888883F33330000324334222222443333388F3833333388F333
      000032244222222222433338F8833FFFFF338F3300003222222AAAAA22243338
      F333F88888F338F30000322222A33333A2224338F33F8333338F338F00003222
      223333333A224338F33833333338F38F00003222222333333A444338FFFF8F33
      3338888300003AAAAAAA33333333333888888833333333330000333333333333
      333333333333333333FFFFFF000033333333333344444433FFFF333333888888
      00003A444333333A22222438888F333338F3333800003A2243333333A2222438
      F38F333333833338000033A224333334422224338338FFFFF8833338000033A2
      22444442222224338F3388888333FF380000333A2222222222AA243338FF3333
      33FF88F800003333AA222222AA33A3333388FFFFFF8833830000333333AAAAAA
      3333333333338888883333330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object DosBoxDirEdit: TLabeledEdit
    Left = 14
    Top = 24
    Width = 738
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 67
    EditLabel.Height = 13
    EditLabel.Caption = 'DosBoxDirEdit'
    TabOrder = 0
    OnChange = DosBoxDirEditChange
  end
  object DosBoxLangEditComboBox: TComboBox
    Left = 14
    Top = 67
    Width = 169
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
  end
  object WaitOnErrorCheckBox: TCheckBox
    Left = 14
    Top = 269
    Width = 767
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Wait on error'
    TabOrder = 9
  end
  object DOSBoxKeyboardLayoutComboBox: TComboBox
    Left = 216
    Top = 67
    Width = 169
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
  end
  object DOSBoxCodepageComboBox: TComboBox
    Left = 416
    Top = 67
    Width = 169
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
  end
  object DosBoxTxtOpenDialog: TOpenDialog
    DefaultExt = 'txt'
    Left = 768
    Top = 63
  end
end