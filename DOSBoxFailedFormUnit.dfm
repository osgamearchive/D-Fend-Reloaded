object DOSBoxFailedForm: TDOSBoxFailedForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'DOSBoxFailedForm'
  ClientHeight = 228
  ClientWidth = 645
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    645
    228)
  PixelsPerInch = 96
  TextHeight = 13
  object InfoLabel: TLabel
    Left = 8
    Top = 8
    Width = 629
    Height = 73
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'InfoLabel'
    WordWrap = True
  end
  object RenderLabel: TLabel
    Left = 8
    Top = 139
    Width = 60
    Height = 13
    Caption = 'RenderLabel'
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 198
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 3
    Kind = bkOK
    ExplicitTop = 213
  end
  object CloseDOSBoxCheckBox: TCheckBox
    Left = 8
    Top = 87
    Width = 629
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'CloseDOSBoxCheckBox'
    TabOrder = 0
  end
  object RenderComboBox: TComboBox
    Left = 8
    Top = 158
    Width = 225
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
  end
  object DoNotShowAgainCheckBox: TCheckBox
    Left = 128
    Top = 202
    Width = 508
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'DoNotShowAgainCheckBox'
    TabOrder = 4
    ExplicitTop = 217
  end
  object ShowConsoleCheckBox: TCheckBox
    Left = 8
    Top = 110
    Width = 629
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'ShowConsoleCheckBox'
    TabOrder = 1
  end
end
