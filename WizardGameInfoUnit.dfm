object WizardGameInfoFrame: TWizardGameInfoFrame
  Left = 0
  Top = 0
  Width = 592
  Height = 506
  TabOrder = 0
  DesignSize = (
    592
    506)
  object InfoLabel: TLabel
    Left = 8
    Top = 16
    Width = 571
    Height = 49
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 
      'Bitte geben Sie die Metadaten zu dem Spiel oder Programm an. All' +
      ' diese Angaben sind optional k'#246'nnen auch sp'#228'ter '#252'ber den Profile' +
      'editor erg'#228'nzt und ver'#228'ndert werden, d.h. Sie m'#252'ssen nicht alle ' +
      'Felder unbedingt jetzt ausf'#252'llen.'
    WordWrap = True
  end
  object Bevel: TBevel
    Left = 0
    Top = 56
    Width = 597
    Height = 18
    Anchors = [akLeft, akTop, akRight]
    Shape = bsBottomLine
  end
  object UserDefinedDataLabel: TLabel
    Left = 8
    Top = 274
    Width = 107
    Height = 13
    Caption = 'UserDefinedDataLabel'
  end
  object NotesLabel: TLabel
    Left = 8
    Top = 387
    Width = 69
    Height = 13
    Caption = 'Bemerkungen:'
  end
  object AddButton: TSpeedButton
    Left = 527
    Top = 260
    Width = 23
    Height = 22
    Anchors = [akTop, akRight]
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      33333333FF33333333FF333993333333300033377F3333333777333993333333
      300033F77FFF3333377739999993333333333777777F3333333F399999933333
      33003777777333333377333993333333330033377F3333333377333993333333
      3333333773333333333F333333333333330033333333F33333773333333C3333
      330033333337FF3333773333333CC333333333FFFFF77FFF3FF33CCCCCCCCCC3
      993337777777777F77F33CCCCCCCCCC3993337777777777377333333333CC333
      333333333337733333FF3333333C333330003333333733333777333333333333
      3000333333333333377733333333333333333333333333333333}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = AddButtonClick
  end
  object DelButton: TSpeedButton
    Left = 556
    Top = 260
    Width = 23
    Height = 22
    Anchors = [akTop, akRight]
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333FF33333333333330003333333333333777333333333333
      300033FFFFFF3333377739999993333333333777777F3333333F399999933333
      3300377777733333337733333333333333003333333333333377333333333333
      3333333333333333333F333333333333330033333F33333333773333C3333333
      330033337F3333333377333CC3333333333333F77FFFFFFF3FF33CCCCCCCCCC3
      993337777777777F77F33CCCCCCCCCC399333777777777737733333CC3333333
      333333377F33333333FF3333C333333330003333733333333777333333333333
      3000333333333333377733333333333333333333333333333333}
    NumGlyphs = 2
    ParentShowHint = False
    ShowHint = True
    OnClick = DelButtonClick
  end
  object GameInfoValueListEditor: TValueListEditor
    Left = 8
    Top = 88
    Width = 571
    Height = 145
    Anchors = [akLeft, akTop, akRight]
    Strings.Strings = (
      '=')
    TabOrder = 0
    ColWidths = (
      150
      415)
  end
  object FavouriteCheckBox: TCheckBox
    Left = 8
    Top = 247
    Width = 505
    Height = 17
    Caption = 'FavouriteCheckBox'
    TabOrder = 1
  end
  object Tab: TStringGrid
    Left = 8
    Top = 288
    Width = 571
    Height = 89
    Anchors = [akLeft, akTop, akRight]
    ColCount = 2
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor, goThumbTracking]
    TabOrder = 2
  end
  object NotesMemo: TRichEdit
    Left = 8
    Top = 402
    Width = 571
    Height = 95
    Anchors = [akLeft, akTop, akRight, akBottom]
    PlainText = True
    ScrollBars = ssBoth
    TabOrder = 3
  end
end
