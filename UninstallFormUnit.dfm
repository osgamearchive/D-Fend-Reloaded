object UninstallForm: TUninstallForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = 'Programm deinstallieren'
  ClientHeight = 276
  ClientWidth = 684
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox: TCheckListBox
    Left = 0
    Top = 33
    Width = 684
    Height = 209
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 684
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object InfoLabel: TLabel
      Left = 8
      Top = 10
      Width = 264
      Height = 13
      Caption = 'Bitte w'#228'hlen Sie die zu deinstallierenden Komponenten:'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 242
    Width = 684
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object OKButton: TBitBtn
      Left = 8
      Top = 6
      Width = 97
      Height = 25
      TabOrder = 0
      OnClick = OKButtonClick
      Kind = bkOK
    end
    object CancelButton: TBitBtn
      Left = 120
      Top = 6
      Width = 97
      Height = 25
      TabOrder = 1
      Kind = bkCancel
    end
    object SelectAllButton: TBitBtn
      Left = 232
      Top = 6
      Width = 97
      Height = 25
      Caption = 'SelectAllButton'
      TabOrder = 2
      OnClick = SelectButtonClick
    end
    object SelectNoneButton: TBitBtn
      Tag = 1
      Left = 344
      Top = 6
      Width = 97
      Height = 25
      Caption = 'SelectNoneButton'
      TabOrder = 3
      OnClick = SelectButtonClick
    end
  end
end