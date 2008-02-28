object ChangeProfilesForm: TChangeProfilesForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Change profiles'
  ClientHeight = 583
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 8
    Top = 8
    Width = 609
    Height = 536
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Step 1: Select games'
      ExplicitWidth = 537
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
        Width = 585
        Height = 447
        ItemHeight = 13
        TabOrder = 3
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Step 2: Settings to change'
      ImageIndex = 1
      ExplicitWidth = 537
      DesignSize = (
        601
        508)
      object GenreCheckBox: TCheckBox
        Left = 16
        Top = 16
        Width = 296
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Genre'
        TabOrder = 0
        OnClick = CheckBoxClick
        ExplicitWidth = 232
      end
      object GenreComboBox: TComboBox
        Left = 311
        Top = 14
        Width = 274
        Height = 21
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 1
        ExplicitLeft = 247
      end
      object DeveloperCheckBox: TCheckBox
        Left = 16
        Top = 43
        Width = 296
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Developer'
        TabOrder = 2
        OnClick = CheckBoxClick
        ExplicitWidth = 232
      end
      object DeveloperComboBox: TComboBox
        Left = 311
        Top = 41
        Width = 274
        Height = 21
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 3
        ExplicitLeft = 247
      end
      object PublisherCheckBox: TCheckBox
        Left = 16
        Top = 70
        Width = 296
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Publisher'
        TabOrder = 4
        OnClick = CheckBoxClick
        ExplicitWidth = 232
      end
      object PublisherComboBox: TComboBox
        Left = 311
        Top = 68
        Width = 274
        Height = 21
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 5
        ExplicitLeft = 247
      end
      object YearCheckBox: TCheckBox
        Left = 16
        Top = 97
        Width = 296
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Year'
        TabOrder = 6
        OnClick = CheckBoxClick
        ExplicitWidth = 232
      end
      object YearComboBox: TComboBox
        Left = 311
        Top = 95
        Width = 274
        Height = 21
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 7
        ExplicitLeft = 247
      end
      object LanguageCheckBox: TCheckBox
        Left = 16
        Top = 124
        Width = 296
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Language'
        TabOrder = 8
        OnClick = CheckBoxClick
        ExplicitWidth = 232
      end
      object LanguageComboBox: TComboBox
        Left = 311
        Top = 122
        Width = 274
        Height = 21
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 9
        ExplicitLeft = 247
      end
      object FavouriteCheckBox: TCheckBox
        Left = 16
        Top = 151
        Width = 296
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Favourite'
        TabOrder = 10
        OnClick = CheckBoxClick
        ExplicitWidth = 232
      end
      object FavouriteComboBox: TComboBox
        Left = 312
        Top = 149
        Width = 105
        Height = 21
        Style = csDropDownList
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 11
        ExplicitLeft = 248
      end
      object CloseOnExitCheckBox: TCheckBox
        Left = 16
        Top = 178
        Width = 296
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Close on exit'
        TabOrder = 12
        OnClick = CheckBoxClick
        ExplicitWidth = 232
      end
      object CloseOnExitComboBox: TComboBox
        Left = 312
        Top = 176
        Width = 105
        Height = 21
        Style = csDropDownList
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 13
        ExplicitLeft = 248
      end
      object StartFullscreenCheckBox: TCheckBox
        Left = 16
        Top = 205
        Width = 296
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Start fullscreen'
        TabOrder = 14
        OnClick = CheckBoxClick
        ExplicitWidth = 232
      end
      object StartFullscreenComboBox: TComboBox
        Left = 311
        Top = 203
        Width = 106
        Height = 21
        Style = csDropDownList
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 15
        ExplicitLeft = 247
      end
      object LockMouseCheckBox: TCheckBox
        Left = 16
        Top = 232
        Width = 296
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Lock mouse'
        TabOrder = 16
        OnClick = CheckBoxClick
        ExplicitWidth = 232
      end
      object LockMouseComboBox: TComboBox
        Left = 312
        Top = 230
        Width = 105
        Height = 21
        Style = csDropDownList
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 17
        ExplicitLeft = 248
      end
      object UseDoublebufferCheckBox: TCheckBox
        Left = 16
        Top = 259
        Width = 296
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Use doublebuffer'
        TabOrder = 18
        OnClick = CheckBoxClick
        ExplicitWidth = 232
      end
      object UseDoublebufferComboBox: TComboBox
        Left = 312
        Top = 257
        Width = 105
        Height = 21
        Style = csDropDownList
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 19
        ExplicitLeft = 248
      end
      object RenderCheckBox: TCheckBox
        Left = 16
        Top = 286
        Width = 296
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Render'
        TabOrder = 20
        OnClick = CheckBoxClick
        ExplicitWidth = 232
      end
      object RenderComboBox: TComboBox
        Left = 312
        Top = 284
        Width = 105
        Height = 21
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 21
        ExplicitLeft = 248
      end
      object MemoryCheckBox: TCheckBox
        Left = 16
        Top = 393
        Width = 296
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Memory'
        TabOrder = 28
        OnClick = CheckBoxClick
        ExplicitWidth = 232
      end
      object MemoryComboBox: TComboBox
        Left = 311
        Top = 391
        Width = 106
        Height = 21
        Style = csDropDownList
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 29
        ExplicitLeft = 247
      end
      object CPUCyclesCheckBox: TCheckBox
        Left = 16
        Top = 420
        Width = 296
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'CPU cycles'
        TabOrder = 30
        OnClick = CheckBoxClick
        ExplicitWidth = 232
      end
      object CPUCyclesComboBox: TComboBox
        Left = 312
        Top = 418
        Width = 105
        Height = 21
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 31
        ExplicitLeft = 248
      end
      object EmulationCoreCheckBox: TCheckBox
        Left = 16
        Top = 447
        Width = 296
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Emulation core'
        TabOrder = 32
        OnClick = CheckBoxClick
        ExplicitWidth = 232
      end
      object EmulationCoreComboBox: TComboBox
        Left = 312
        Top = 445
        Width = 105
        Height = 21
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 33
        ExplicitLeft = 248
      end
      object KeyboardLayoutCheckBox: TCheckBox
        Left = 16
        Top = 474
        Width = 296
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Keyboard layout'
        TabOrder = 34
        OnClick = CheckBoxClick
        ExplicitWidth = 232
      end
      object KeyboardLayoutComboBox: TComboBox
        Left = 312
        Top = 472
        Width = 105
        Height = 21
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 35
        ExplicitLeft = 248
      end
      object WindowResolutionCheckBox: TCheckBox
        Left = 16
        Top = 313
        Width = 289
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Fenster-Aufl'#246'sung'
        TabOrder = 22
        OnClick = CheckBoxClick
        ExplicitWidth = 225
      end
      object WindowResolutionComboBox: TComboBox
        Left = 311
        Top = 311
        Width = 106
        Height = 21
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 23
        ExplicitLeft = 247
      end
      object FullscreenResolutionComboBox: TComboBox
        Left = 312
        Top = 338
        Width = 105
        Height = 21
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 25
        ExplicitLeft = 248
      end
      object ScaleComboBox: TComboBox
        Left = 311
        Top = 365
        Width = 274
        Height = 21
        Style = csDropDownList
        Anchors = [akTop, akRight]
        ItemHeight = 13
        TabOrder = 27
        ExplicitLeft = 247
      end
      object FullscreenResolutionCheckBox: TCheckBox
        Left = 16
        Top = 340
        Width = 290
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Vollbild-Aufl'#246'sung'
        TabOrder = 24
        OnClick = CheckBoxClick
        ExplicitWidth = 226
      end
      object ScaleCheckBox: TCheckBox
        Left = 16
        Top = 367
        Width = 161
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Skalierung'
        TabOrder = 26
        OnClick = CheckBoxClick
        ExplicitWidth = 97
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
