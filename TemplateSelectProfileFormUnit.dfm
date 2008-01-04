object TemplateSelectProfileForm: TTemplateSelectProfileForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Profil ausw'#228'hlen'
  ClientHeight = 302
  ClientWidth = 560
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
  object ListView: TListView
    Left = 0
    Top = 0
    Width = 561
    Height = 263
    Columns = <>
    SmallImages = ListViewImageList
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = ListViewColumnClick
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 269
    Width = 97
    Height = 25
    TabOrder = 1
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 269
    Width = 97
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object ImageList: TImageList
    Left = 224
    Top = 272
  end
  object ListViewImageList: TImageList
    Left = 264
    Top = 272
  end
  object ListviewIconImageList: TImageList
    Height = 32
    Width = 32
    Left = 304
    Top = 272
  end
end
