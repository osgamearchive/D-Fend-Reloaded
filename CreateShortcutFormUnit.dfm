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
    TabOrder = 2
    TabStop = True
  end
  object StartmenuRadioButton: TRadioButton
    Left = 24
    Top = 48
    Width = 113
    Height = 17
    Caption = 'StartmenuRadioButton'
    TabOrder = 3
  end
  object StartmenuEdit: TEdit
    Left = 48
    Top = 71
    Width = 121
    Height = 21
    TabOrder = 4
    Text = 'Dosgames'
    OnChange = StartmenuEditChange
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 147
    Width = 97
    Height = 25
    TabOrder = 6
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 149
    Width = 97
    Height = 25
    TabOrder = 7
    Kind = bkCancel
  end
  object UseProfileIconCheckBox: TCheckBox
    Left = 16
    Top = 112
    Width = 225
    Height = 17
    Caption = 'UseProfileIconCheckBox'
    TabOrder = 5
  end
  object LinkNameEdit: TLabeledEdit
    Left = 208
    Top = 40
    Width = 121
    Height = 21
    EditLabel.Width = 63
    EditLabel.Height = 13
    EditLabel.Caption = 'LinkNameEdit'
    TabOrder = 0
    Visible = False
  end
  object LinkCommentEdit: TLabeledEdit
    Left = 208
    Top = 85
    Width = 121
    Height = 21
    EditLabel.Width = 81
    EditLabel.Height = 13
    EditLabel.Caption = 'LinkCommentEdit'
    TabOrder = 1
    Visible = False
  end
end
