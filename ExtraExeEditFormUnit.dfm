object ExtraExeEditForm: TExtraExeEditForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'ExtraExeEditForm'
  ClientHeight = 374
  ClientWidth = 645
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
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    645
    374)
  PixelsPerInch = 96
  TextHeight = 13
  object InfoLabel: TLabel
    Left = 8
    Top = 302
    Width = 629
    Height = 36
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'InfoLabel'
    WordWrap = True
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 341
    Width = 97
    Height = 25
    TabOrder = 0
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 111
    Top = 341
    Width = 97
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object List: TValueListEditor
    Left = 8
    Top = 8
    Width = 629
    Height = 292
    KeyOptions = [keyEdit]
    TabOrder = 2
    OnEditButtonClick = ListEditButtonClick
    ColWidths = (
      150
      473)
  end
  object HelpButton: TBitBtn
    Left = 214
    Top = 341
    Width = 97
    Height = 25
    TabOrder = 3
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object OpenDialog: TOpenDialog
    Left = 608
    Top = 7
  end
end
