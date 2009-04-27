object SelectFileToStartForm: TSelectFileToStartForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'SelectFileToStartForm'
  ClientHeight = 272
  ClientWidth = 506
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  DesignSize = (
    506
    272)
  PixelsPerInch = 96
  TextHeight = 13
  object InfoLabel: TLabel
    Left = 8
    Top = 16
    Width = 489
    Height = 57
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'InfoLabel'
    WordWrap = True
  end
  object GameExeLabel: TLabel
    Left = 8
    Top = 80
    Width = 70
    Height = 13
    Caption = 'GameExeLabel'
  end
  object SetupExeLabel: TLabel
    Left = 176
    Top = 80
    Width = 71
    Height = 13
    Caption = 'SetupExeLabel'
  end
  object TemplateLabel: TLabel
    Left = 8
    Top = 181
    Width = 69
    Height = 13
    Caption = 'TemplateLabel'
    Visible = False
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 242
    Width = 97
    Height = 25
    TabOrder = 0
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 111
    Top = 242
    Width = 97
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object GameExeComboBox: TComboBox
    Left = 8
    Top = 99
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
  end
  object SetupExeComboBox: TComboBox
    Left = 176
    Top = 99
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
  end
  object MoreButton: TBitBtn
    Left = 214
    Top = 241
    Width = 131
    Height = 25
    Caption = 'More settings'
    TabOrder = 4
    OnClick = MoreButtonClick
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
  end
  object FolderEdit: TLabeledEdit
    Left = 8
    Top = 152
    Width = 490
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 48
    EditLabel.Height = 13
    EditLabel.Caption = 'FolderEdit'
    TabOrder = 5
    Visible = False
  end
  object TemplateComboBox: TComboBox
    Left = 8
    Top = 200
    Width = 490
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 6
    Visible = False
  end
end
