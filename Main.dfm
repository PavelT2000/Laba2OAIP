object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 577
  ClientWidth = 1098
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnPaint = FormPaint
  TextHeight = 15
  object MediaPlayer1: TMediaPlayer
    Left = 8
    Top = 24
    Width = 253
    Height = 30
    DoubleBuffered = True
    FileName = 'D:\programs\gitHub_repository\Laba2OAIP\calmMind.mp3'
    Visible = False
    ParentDoubleBuffered = False
    TabOrder = 0
  end
  object CursorPosition: TStaticText
    Left = 8
    Top = 8
    Width = 30
    Height = 19
    Caption = '0, 0'
    TabOrder = 1
  end
  object CursorHint: TStaticText
    Left = 8
    Top = 33
    Width = 94
    Height = 19
    Caption = 'q = start, e = end'
    TabOrder = 2
  end
  object FPS: TTimer
    Interval = 40
    OnTimer = FPSTimer
    Left = 296
    Top = 24
  end
end
