object PlaySoundForm: TPlaySoundForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'PlaySoundForm'
  ClientHeight = 47
  ClientWidth = 105
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
  object MediaPlayer: TMediaPlayer
    Left = 8
    Top = 8
    Width = -2
    Height = 30
    VisibleButtons = [btPlay, btPause, btStop]
    TabOrder = 0
  end
end
