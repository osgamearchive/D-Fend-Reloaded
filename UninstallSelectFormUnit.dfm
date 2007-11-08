object UninstallSelectForm: TUninstallSelectForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Programme deinstallieren'
  ClientHeight = 503
  ClientWidth = 396
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
  object InfoLabel: TLabel
    Left = 8
    Top = 8
    Width = 272
    Height = 13
    Caption = 'Bitte w'#228'hlen Sie die zu deinstallierenden Programme aus:'
  end
  object ActionsRadioGroup: TRadioGroup
    Left = 8
    Top = 352
    Width = 377
    Height = 105
    Caption = 'Aktionen'
    ItemIndex = 2
    Items.Strings = (
      'Nur Profi-Listen Eintrag l'#246'schen'
      'Profil-Listen Eintrag und Programmverzeichnis l'#246'schen'
      
        'Profil-Listen Eintrag und alle Programmdatenverzeichnisse l'#246'sche' +
        'n'
      'F'#252'r jeden Eintrag einzelen ausw'#228'hlen')
    TabOrder = 0
  end
  object ListBox: TCheckListBox
    Left = 8
    Top = 27
    Width = 377
    Height = 270
    ItemHeight = 13
    TabOrder = 1
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 470
    Width = 97
    Height = 25
    TabOrder = 2
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 470
    Width = 97
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
  object SelectAllButton: TBitBtn
    Left = 8
    Top = 303
    Width = 97
    Height = 25
    Caption = 'SelectAllButton'
    TabOrder = 4
    OnClick = SelectButtonClick
  end
  object SelectNoneButton: TBitBtn
    Tag = 1
    Left = 111
    Top = 303
    Width = 97
    Height = 25
    Caption = 'SelectNoneButton'
    TabOrder = 5
    OnClick = SelectButtonClick
  end
  object SelectGenreButton: TBitBtn
    Tag = 2
    Left = 214
    Top = 303
    Width = 97
    Height = 25
    Caption = 'By Genre'
    TabOrder = 6
    OnClick = SelectButtonClick
  end
  object PopupMenu: TPopupMenu
    Left = 320
    Top = 312
    object MenuSelect: TMenuItem
      Caption = '&Select'
    end
    object MenuUnselect: TMenuItem
      Caption = '&Unselect'
    end
  end
end
