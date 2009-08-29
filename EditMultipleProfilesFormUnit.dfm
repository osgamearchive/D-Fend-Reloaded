object EditMultipleProfilesForm: TEditMultipleProfilesForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'EditMultipleProfilesForm'
  ClientHeight = 514
  ClientWidth = 634
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 500
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
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  OnShow = FormShow
  DesignSize = (
    634
    514)
  PixelsPerInch = 96
  TextHeight = 13
  object ReplaceFolderToButton: TSpeedButton
    Left = 375
    Top = 486
    Width = 23
    Height = 20
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000120B0000120B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
      5555555555555555555555555555555555555555555555555555555555555555
      555555555555555555555555555555555555555FFFFFFFFFF555550000000000
      55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
      B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
      000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
      555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
      55555575FFF75555555555700007555555555557777555555555555555555555
      5555555555555555555555555555555555555555555555555555}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    Visible = False
  end
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 634
    Height = 475
    ActivePage = TabSheet1
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      DesignSize = (
        626
        447)
      object InfoLabel: TLabel
        Left = 8
        Top = 8
        Width = 158
        Height = 13
        Caption = 'Select the games to be changed:'
      end
      object ListBox: TCheckListBox
        Left = 8
        Top = 24
        Width = 608
        Height = 389
        Anchors = [akLeft, akTop, akRight, akBottom]
        ItemHeight = 13
        TabOrder = 0
      end
      object SelectAllButton: TBitBtn
        Left = 8
        Top = 419
        Width = 107
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'SelectAllButton'
        TabOrder = 1
        OnClick = SelectButtonClick
      end
      object SelectNoneButton: TBitBtn
        Tag = 1
        Left = 121
        Top = 419
        Width = 107
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'SelectNoneButton'
        TabOrder = 2
        OnClick = SelectButtonClick
      end
      object SelectGenreButton: TBitBtn
        Tag = 2
        Left = 234
        Top = 419
        Width = 107
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'By ...'
        TabOrder = 3
        OnClick = SelectButtonClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object ScrollBox: TScrollBox
        Left = 0
        Top = 0
        Width = 626
        Height = 447
        HorzScrollBar.Visible = False
        VertScrollBar.Smooth = True
        VertScrollBar.Tracking = True
        Align = alClient
        Color = clWindow
        ParentColor = False
        TabOrder = 0
      end
    end
  end
  object OKButton: TBitBtn
    Left = 8
    Top = 481
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 1
    OnClick = OKButtonClick
    Kind = bkOK
  end
  object CancelButton: TBitBtn
    Left = 120
    Top = 481
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 2
    Kind = bkCancel
  end
  object HelpButton: TBitBtn
    Left = 232
    Top = 481
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 3
    OnClick = HelpButtonClick
    Kind = bkHelp
  end
  object PopupMenu: TPopupMenu
    Left = 344
    Top = 427
  end
end
