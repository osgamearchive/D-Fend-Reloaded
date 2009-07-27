object LanguageEditorForm: TLanguageEditorForm
  Left = 0
  Top = 0
  Caption = 'Language editor'
  ClientHeight = 549
  ClientWidth = 724
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 724
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      724
      41)
    object InfoLabel: TLabel
      Left = 168
      Top = 16
      Width = 45
      Height = 13
      Caption = 'InfoLabel'
    end
    object CloseButton: TBitBtn
      Left = 631
      Top = 9
      Width = 83
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 0
      Kind = bkClose
    end
    object SectionComboBox: TComboBox
      Left = 8
      Top = 11
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 0
      TabOrder = 1
      OnChange = SectionComboBoxChange
    end
  end
  object Tab: TStringGrid
    Left = 0
    Top = 41
    Width = 724
    Height = 508
    Align = alClient
    ColCount = 3
    FixedCols = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goAlwaysShowEditor, goThumbTracking]
    TabOrder = 1
  end
end
