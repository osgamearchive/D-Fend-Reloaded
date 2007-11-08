object InfoForm: TInfoForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Programminfo'
  ClientHeight = 250
  ClientWidth = 576
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 577
    Height = 209
    ActivePage = MainSheet
    TabOrder = 0
    object MainSheet: TTabSheet
      Caption = 'MainSheet'
      object VersionLabel: TLabel
        Left = 16
        Top = 48
        Width = 60
        Height = 13
        Caption = 'VersionLabel'
      end
      object Label1: TLabel
        Left = 16
        Top = 16
        Width = 109
        Height = 16
        Caption = 'D-Fend Reloaded'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object WrittenByLabel: TLabel
        Left = 16
        Top = 80
        Width = 73
        Height = 13
        Caption = 'WrittenByLabel'
      end
      object eMailLabel: TLabel
        Left = 16
        Top = 99
        Width = 49
        Height = 13
        Caption = 'eMailLabel'
      end
      object HomepageLabel: TLabel
        Left = 16
        Top = 136
        Width = 185
        Height = 13
        Cursor = crHandPoint
        Caption = 'http://www.SorryNoHomepageJet.org'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentColor = False
        ParentFont = False
        OnClick = HomepageLabelClick
      end
    end
    object LicenseSheet: TTabSheet
      Caption = 'LicenseSheet'
      ImageIndex = 1
      object LicenseMemo: TRichEdit
        Left = 0
        Top = 0
        Width = 569
        Height = 181
        Align = alClient
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object CompLicenseSheet: TTabSheet
      Caption = 'CompLicenseSheet'
      ImageIndex = 2
      object CompLicenseMemo: TRichEdit
        Left = 0
        Top = 0
        Width = 569
        Height = 181
        Align = alClient
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 215
    Width = 97
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
end
