object SelectTemplateForZipImportForm: TSelectTemplateForZipImportForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'SelectTemplateForZipImportForm'
  ClientHeight = 288
  ClientWidth = 486
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
  DesignSize = (
    486
    288)
  PixelsPerInch = 96
  TextHeight = 13
  object TemplateLabel: TLabel
    Left = 16
    Top = 189
    Width = 77
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Template to use'
    ExplicitTop = 192
  end
  object ProgramFileLabel: TLabel
    Left = 240
    Top = 189
    Width = 57
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'Program file'
    ExplicitTop = 192
  end
  object SetupFileLabel: TLabel
    Left = 368
    Top = 189
    Width = 45
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'Setup file'
    ExplicitTop = 192
  end
  object WarningLabel: TLabel
    Left = 223
    Top = 76
    Width = 77
    Height = 13
    Caption = 'Already existing'
    Visible = False
  end
  object OKButton: TBitBtn
    Left = 16
    Top = 255
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 8
    OnClick = OKButtonClick
    Kind = bkOK
    ExplicitTop = 258
  end
  object CancelButton: TBitBtn
    Left = 128
    Top = 255
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 9
    Kind = bkCancel
    ExplicitTop = 258
  end
  object HelpButton: TBitBtn
    Left = 242
    Top = 255
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 10
    OnClick = HelpButtonClick
    Kind = bkHelp
    ExplicitTop = 258
  end
  object TemplateType1RadioButton: TRadioButton
    Left = 16
    Top = 109
    Width = 460
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Matching auto setup template'
    Checked = True
    TabOrder = 2
    TabStop = True
    OnClick = TypeSelectClick
    ExplicitTop = 112
  end
  object TemplateType2RadioButton: TRadioButton
    Left = 16
    Top = 132
    Width = 460
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Auto setup template'
    TabOrder = 3
    OnClick = TypeSelectClick
    ExplicitTop = 135
  end
  object TemplateType3RadioButton: TRadioButton
    Left = 16
    Top = 155
    Width = 460
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'User template'
    TabOrder = 4
    OnClick = TypeSelectClick
    ExplicitTop = 158
  end
  object ProfileNameEdit: TLabeledEdit
    Left = 16
    Top = 24
    Width = 460
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    EditLabel.Width = 59
    EditLabel.Height = 13
    EditLabel.Caption = 'Profile name'
    TabOrder = 0
    OnChange = ProfileNameEditChange
  end
  object TemplateComboBox: TComboBox
    Left = 16
    Top = 208
    Width = 201
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akRight, akBottom]
    ItemHeight = 0
    TabOrder = 5
    OnChange = TemplateComboBoxChange
    OnDropDown = ComboBoxDropDown
  end
  object ProgramFileComboBox: TComboBox
    Left = 240
    Top = 208
    Width = 108
    Height = 21
    Style = csDropDownList
    Anchors = [akRight, akBottom]
    ItemHeight = 0
    TabOrder = 6
    OnDropDown = ComboBoxDropDown
  end
  object FolderEdit: TLabeledEdit
    Left = 16
    Top = 74
    Width = 201
    Height = 21
    EditLabel.Width = 99
    EditLabel.Height = 13
    EditLabel.Caption = 'Folder for new game'
    TabOrder = 1
    OnChange = FolderEditChange
  end
  object SetupFileComboBox: TComboBox
    Left = 368
    Top = 208
    Width = 108
    Height = 21
    Style = csDropDownList
    Anchors = [akRight, akBottom]
    ItemHeight = 0
    TabOrder = 7
    OnDropDown = ComboBoxDropDown
  end
end
