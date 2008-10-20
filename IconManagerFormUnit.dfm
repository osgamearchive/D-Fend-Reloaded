object IconManagerForm: TIconManagerForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Icon Manager'
  ClientHeight = 347
  ClientWidth = 551
  Color = clBtnFace
  Constraints.MinHeight = 250
  Constraints.MinWidth = 550
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    551
    347)
  PixelsPerInch = 96
  TextHeight = 13
  object CustomIconButton: TSpeedButton
    Left = 520
    Top = 268
    Width = 23
    Height = 22
    Anchors = [akRight, akBottom]
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
    OnClick = CustomIconButtonClick
  end
  object ListView: TListView
    Left = 0
    Top = 0
    Width = 551
    Height = 239
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <>
    HideSelection = False
    IconOptions.Arrangement = iaLeft
    IconOptions.AutoArrange = True
    LargeImages = ImageList
    ReadOnly = True
    SmallImages = ImageList
    SortType = stText
    TabOrder = 0
    OnChange = ListViewChange
    OnClick = ListViewClick
    OnDblClick = ListViewDblClick
    OnKeyDown = ListViewKeyDown
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 314
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 4
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 111
    Top = 314
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 5
    Kind = bkCancel
  end
  object AddButton: TBitBtn
    Left = 214
    Top = 314
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Hinzuf'#252'gen'
    TabOrder = 6
    OnClick = AddButtonClick
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
  object DelButton: TBitBtn
    Left = 317
    Top = 314
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'L'#246'schen'
    TabOrder = 7
    OnClick = DelButtonClick
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
  end
  object LibraryIconRadioButton: TRadioButton
    Left = 8
    Top = 245
    Width = 535
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Use icon from list above'
    Checked = True
    TabOrder = 1
    TabStop = True
  end
  object CustomIconRadioButton: TRadioButton
    Left = 8
    Top = 270
    Width = 217
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Use custom icon'
    TabOrder = 2
  end
  object CustomIconEdit: TEdit
    Left = 224
    Top = 268
    Width = 285
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 3
    OnChange = CustomIconEditChange
  end
  object HelpButton: TBitBtn
    Left = 420
    Top = 314
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 8
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object ImageList: TImageList
    Height = 32
    Width = 32
    Left = 456
    Top = 277
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'ico'
    Left = 488
    Top = 277
  end
end
