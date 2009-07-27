object SelectTemplateForZipImportForm: TSelectTemplateForZipImportForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'SelectTemplateForZipImportForm'
  ClientHeight = 291
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
  OnShow = FormShow
  DesignSize = (
    486
    291)
  PixelsPerInch = 96
  TextHeight = 13
  object TemplateLabel: TLabel
    Left = 16
    Top = 192
    Width = 77
    Height = 13
    Caption = 'Template to use'
  end
  object ProgramFileLabel: TLabel
    Left = 240
    Top = 192
    Width = 57
    Height = 13
    Caption = 'Program file'
  end
  object SetupFileLabel: TLabel
    Left = 368
    Top = 192
    Width = 45
    Height = 13
    Caption = 'Setup file'
  end
  object OKButton: TBitBtn
    Left = 16
    Top = 258
    Width = 97
    Height = 25
    TabOrder = 8
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 128
    Top = 258
    Width = 97
    Height = 25
    TabOrder = 9
    Kind = bkCancel
  end
  object HelpButton: TBitBtn
    Left = 242
    Top = 258
    Width = 97
    Height = 25
    TabOrder = 10
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object TemplateType1RadioButton: TRadioButton
    Left = 16
    Top = 112
    Width = 449
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Matching auto setup template'
    Checked = True
    TabOrder = 2
    TabStop = True
    OnClick = TypeSelectClick
  end
  object TemplateType2RadioButton: TRadioButton
    Left = 16
    Top = 135
    Width = 449
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Auto setup template'
    TabOrder = 3
    OnClick = TypeSelectClick
  end
  object TemplateType3RadioButton: TRadioButton
    Left = 16
    Top = 158
    Width = 449
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'User template'
    TabOrder = 4
    OnClick = TypeSelectClick
  end
  object ProfileNameEdit: TLabeledEdit
    Left = 16
    Top = 24
    Width = 201
    Height = 21
    EditLabel.Width = 59
    EditLabel.Height = 13
    EditLabel.Caption = 'Profile name'
    TabOrder = 0
  end
  object TemplateComboBox: TComboBox
    Left = 16
    Top = 211
    Width = 201
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    OnChange = TemplateComboBoxChange
    OnDropDown = ComboBoxDropDown
  end
  object ProgramFileComboBox: TComboBox
    Left = 240
    Top = 211
    Width = 108
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    OnDropDown = ComboBoxDropDown
  end
  object FolderEdit: TLabeledEdit
    Left = 16
    Top = 69
    Width = 201
    Height = 21
    EditLabel.Width = 99
    EditLabel.Height = 13
    EditLabel.Caption = 'Folder for new game'
    TabOrder = 1
  end
  object SetupFileComboBox: TComboBox
    Left = 368
    Top = 211
    Width = 108
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
    OnDropDown = ComboBoxDropDown
  end
end
