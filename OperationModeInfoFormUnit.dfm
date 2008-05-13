object OperationModeInfoForm: TOperationModeInfoForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'OperationModeInfoForm'
  ClientHeight = 322
  ClientWidth = 621
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  DesignSize = (
    621
    322)
  PixelsPerInch = 96
  TextHeight = 13
  object TopLabel: TLabel
    Left = 16
    Top = 16
    Width = 205
    Height = 13
    Caption = 'Operation mode chosen during installation:'
  end
  object OpModeLabel: TLabel
    Left = 16
    Top = 35
    Width = 65
    Height = 13
    Caption = 'OpModeLabel'
  end
  object OKButton: TBitBtn
    Left = 16
    Top = 289
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 0
    Kind = bkOK
    ExplicitTop = 316
  end
  object PrgDirEdit: TLabeledEdit
    Left = 16
    Top = 207
    Width = 597
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    EditLabel.Width = 47
    EditLabel.Height = 13
    EditLabel.Caption = 'PrgDirEdit'
    ReadOnly = True
    TabOrder = 1
    ExplicitTop = 234
  end
  object PrgDataDirEdit: TLabeledEdit
    Left = 16
    Top = 255
    Width = 597
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    EditLabel.Width = 70
    EditLabel.Height = 13
    EditLabel.Caption = 'PrgDataDirEdit'
    ReadOnly = True
    TabOrder = 2
    ExplicitTop = 282
  end
  object CheckBox1: TCheckBox
    Left = 16
    Top = 64
    Width = 597
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Program settings are stored in program folder'
    Enabled = False
    TabOrder = 3
    ExplicitWidth = 494
  end
  object CheckBox3: TCheckBox
    Left = 16
    Top = 111
    Width = 597
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'All users on this system share settings and profiles'
    Enabled = False
    TabOrder = 4
  end
  object CheckBox4: TCheckBox
    Left = 16
    Top = 134
    Width = 597
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Useable without admin rights and under Windows Vista'
    Enabled = False
    TabOrder = 5
  end
  object CheckBox5: TCheckBox
    Left = 16
    Top = 157
    Width = 597
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 
      'DOSBox and games directories are stored relative to D-Fend Reloa' +
      'ded folder (for portable use)'
    Enabled = False
    TabOrder = 6
  end
  object CheckBox2: TCheckBox
    Left = 16
    Top = 87
    Width = 597
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Program settings are stored in the user profile folder'
    Enabled = False
    TabOrder = 7
  end
end
