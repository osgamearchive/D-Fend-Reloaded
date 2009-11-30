object SetupFrameAutomaticConfiguration: TSetupFrameAutomaticConfiguration
  Left = 0
  Top = 0
  Width = 670
  Height = 464
  TabOrder = 0
  DesignSize = (
    670
    464)
  object ZipImportGroupBox: TGroupBox
    Left = 8
    Top = 16
    Width = 649
    Height = 65
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Archive file import'
    TabOrder = 0
    DesignSize = (
      649
      65)
    object ZipImportCheckBox: TCheckBox
      Left = 16
      Top = 24
      Width = 630
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 
        'Do not show dialog if the game can be identifed by an auto setup' +
        ' template'
      TabOrder = 0
    end
  end
  object WizardRadioGroup: TRadioGroup
    Left = 8
    Top = 96
    Width = 649
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Profile wizard'
    TabOrder = 1
  end
end
