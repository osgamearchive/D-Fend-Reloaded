object CreateShortcutForm: TCreateShortcutForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'CreateShortcut'
  ClientHeight = 184
  ClientWidth = 249
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
  object DesktopRadioButton: TRadioButton
    Left = 24
    Top = 16
    Width = 113
    Height = 17
    Caption = 'DesktopRadioButton'
    Checked = True
    TabOrder = 0
    TabStop = True
  end
  object StartmenuRadioButton: TRadioButton
    Left = 24
    Top = 48
    Width = 113
    Height = 17
    Caption = 'StartmenuRadioButton'
    TabOrder = 1
  end
  object StartmenuEdit: TEdit
    Left = 48
    Top = 71
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'Dosgames'
    OnChange = StartmenuEditChange
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 147
    Width = 97
    Height = 25
    TabOrder = 4
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 149
    Width = 97
    Height = 25
    TabOrder = 5
    Kind = bkCancel
  end
  object UseProfileIconCheckBox: TCheckBox
    Left = 16
    Top = 112
    Width = 225
    Height = 17
    Caption = 'UseProfileIconCheckBox'
    TabOrder = 3
  end
end