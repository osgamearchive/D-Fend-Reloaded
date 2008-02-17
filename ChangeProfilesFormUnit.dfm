object ChangeProfilesForm: TChangeProfilesForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Change profiles'
  ClientHeight = 583
  ClientWidth = 561
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
  object PageControl: TPageControl
    Left = 8
    Top = 8
    Width = 545
    Height = 536
    ActivePage = TabSheet2
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Step 1: Select games'
      object InfoLabel: TLabel
        Left = 8
        Top = 8
        Width = 158
        Height = 13
        Caption = 'Select the games to be changed:'
      end
      object SelectAllButton: TBitBtn
        Left = 8
        Top = 480
        Width = 107
        Height = 25
        Caption = 'SelectAllButton'
        TabOrder = 0
        OnClick = SelectButtonClick
      end
      object SelectNoneButton: TBitBtn
        Tag = 1
        Left = 121
        Top = 480
        Width = 107
        Height = 25
        Caption = 'SelectNoneButton'
        TabOrder = 1
        OnClick = SelectButtonClick
      end
      object SelectGenreButton: TBitBtn
        Tag = 2
        Left = 234
        Top = 480
        Width = 107
        Height = 25
        Caption = 'By ...'
        TabOrder = 2
        OnClick = SelectButtonClick
      end
      object ListBox: TCheckListBox
        Left = 8
        Top = 27
        Width = 521
        Height = 447
        ItemHeight = 13
        TabOrder = 3
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Step 2: Settings to change'
      ImageIndex = 1
      object GenreCheckBox: TCheckBox
        Left = 16
        Top = 16
        Width = 232
        Height = 17
        Caption = 'Genre'
        TabOrder = 0
        OnClick = CheckBoxClick
      end
      object GenreComboBox: TComboBox
        Left = 247
        Top = 14
        Width = 274
        Height = 21
        ItemHeight = 13
        TabOrder = 1
      end
      object DeveloperCheckBox: TCheckBox
        Left = 16
        Top = 43
        Width = 232
        Height = 17
        Caption = 'Developer'
        TabOrder = 2
        OnClick = CheckBoxClick
      end
      object DeveloperComboBox: TComboBox
        Left = 247
        Top = 41
        Width = 274
        Height = 21
        ItemHeight = 13
        TabOrder = 3
      end
      object PublisherCheckBox: TCheckBox
        Left = 16
        Top = 70
        Width = 232
        Height = 17
        Caption = 'Publisher'
        TabOrder = 4
        OnClick = CheckBoxClick
      end
      object PublisherComboBox: TComboBox
        Left = 247
        Top = 68
        Width = 274
        Height = 21
        ItemHeight = 13
        TabOrder = 5
      end
      object YearCheckBox: TCheckBox
        Left = 16
        Top = 97
        Width = 232
        Height = 17
        Caption = 'Year'
        TabOrder = 6
        OnClick = CheckBoxClick
      end
      object YearComboBox: TComboBox
        Left = 247
        Top = 95
        Width = 274
        Height = 21
        ItemHeight = 13
        TabOrder = 7
      end
      object LanguageCheckBox: TCheckBox
        Left = 16
        Top = 124
        Width = 232
        Height = 17
        Caption = 'Language'
        TabOrder = 8
        OnClick = CheckBoxClick
      end
      object LanguageComboBox: TComboBox
        Left = 247
        Top = 122
        Width = 274
        Height = 21
        ItemHeight = 13
        TabOrder = 9
      end
      object FavouriteCheckBox: TCheckBox
        Left = 16
        Top = 151
        Width = 232
        Height = 17
        Caption = 'Favourite'
        TabOrder = 10
        OnClick = CheckBoxClick
      end
      object FavouriteComboBox: TComboBox
        Left = 248
        Top = 149
        Width = 105
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 11
      end
      object CloseOnExitCheckBox: TCheckBox
        Left = 16
        Top = 178
        Width = 232
        Height = 17
        Caption = 'Close on exit'
        TabOrder = 12
        OnClick = CheckBoxClick
      end
      object CloseOnExitComboBox: TComboBox
        Left = 248
        Top = 176
        Width = 105
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 13
      end
      object StartFullscreenCheckBox: TCheckBox
        Left = 16
        Top = 205
        Width = 232
        Height = 17
        Caption = 'Start fullscreen'
        TabOrder = 14
        OnClick = CheckBoxClick
      end
      object StartFullscreenComboBox: TComboBox
        Left = 247
        Top = 203
        Width = 106
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 15
      end
      object LockMouseCheckBox: TCheckBox
        Left = 16
        Top = 232
        Width = 232
        Height = 17
        Caption = 'Lock mouse'
        TabOrder = 16
        OnClick = CheckBoxClick
      end
      object LockMouseComboBox: TComboBox
        Left = 248
        Top = 230
        Width = 105
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 17
      end
      object UseDoublebufferCheckBox: TCheckBox
        Left = 16
        Top = 259
        Width = 232
        Height = 17
        Caption = 'Use doublebuffer'
        TabOrder = 18
        OnClick = CheckBoxClick
      end
      object UseDoublebufferComboBox: TComboBox
        Left = 248
        Top = 257
        Width = 105
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 19
      end
      object RenderCheckBox: TCheckBox
        Left = 16
        Top = 286
        Width = 232
        Height = 17
        Caption = 'Render'
        TabOrder = 20
        OnClick = CheckBoxClick
      end
      object RenderComboBox: TComboBox
        Left = 248
        Top = 284
        Width = 105
        Height = 21
        ItemHeight = 13
        TabOrder = 21
      end
      object MemoryCheckBox: TCheckBox
        Left = 16
        Top = 393
        Width = 232
        Height = 17
        Caption = 'Memory'
        TabOrder = 28
        OnClick = CheckBoxClick
      end
      object MemoryComboBox: TComboBox
        Left = 247
        Top = 391
        Width = 106
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 29
      end
      object CPUCyclesCheckBox: TCheckBox
        Left = 16
        Top = 420
        Width = 232
        Height = 17
        Caption = 'CPU cycles'
        TabOrder = 30
        OnClick = CheckBoxClick
      end
      object CPUCyclesComboBox: TComboBox
        Left = 248
        Top = 418
        Width = 105
        Height = 21
        ItemHeight = 13
        TabOrder = 31
      end
      object EmulationCoreCheckBox: TCheckBox
        Left = 16
        Top = 447
        Width = 232
        Height = 17
        Caption = 'Emulation core'
        TabOrder = 32
        OnClick = CheckBoxClick
      end
      object EmulationCoreComboBox: TComboBox
        Left = 248
        Top = 445
        Width = 105
        Height = 21
        ItemHeight = 13
        TabOrder = 33
      end
      object KeyboardLayoutCheckBox: TCheckBox
        Left = 16
        Top = 474
        Width = 232
        Height = 17
        Caption = 'Keyboard layout'
        TabOrder = 34
        OnClick = CheckBoxClick
      end
      object KeyboardLayoutComboBox: TComboBox
        Left = 248
        Top = 472
        Width = 105
        Height = 21
        ItemHeight = 13
        TabOrder = 35
      end
      object WindowResolutionCheckBox: TCheckBox
        Left = 16
        Top = 313
        Width = 225
        Height = 17
        Caption = 'Fenster-Aufl'#246'sung'
        TabOrder = 22
        OnClick = CheckBoxClick
      end
      object WindowResolutionComboBox: TComboBox
        Left = 247
        Top = 311
        Width = 106
        Height = 21
        ItemHeight = 13
        TabOrder = 23
      end
      object FullscreenResolutionComboBox: TComboBox
        Left = 248
        Top = 338
        Width = 105
        Height = 21
        ItemHeight = 13
        TabOrder = 25
      end
      object ScaleComboBox: TComboBox
        Left = 247
        Top = 365
        Width = 274
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 27
      end
      object FullscreenResolutionCheckBox: TCheckBox
        Left = 16
        Top = 340
        Width = 226
        Height = 17
        Caption = 'Vollbild-Aufl'#246'sung'
        TabOrder = 24
        OnClick = CheckBoxClick
      end
      object ScaleCheckBox: TCheckBox
        Left = 16
        Top = 367
        Width = 97
        Height = 17
        Caption = 'Skalierung'
        TabOrder = 26
        OnClick = CheckBoxClick
      end
    end
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 550
    Width = 97
    Height = 25
    TabOrder = 1
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 550
    Width = 97
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object PopupMenu: TPopupMenu
    Left = 232
    Top = 546
  end
end
