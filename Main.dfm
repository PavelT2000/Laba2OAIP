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
  OnPaint = FormPaint
  TextHeight = 15
  object PaintBox1: TPaintBox
    Left = 0
    Top = 0
    Width = 1098
    Height = 577
    Align = alClient
    OnMouseDown = PaintBox1MouseDown
    OnMouseMove = PaintBox1MouseMove
    OnMouseUp = PaintBox1MouseUp
    ExplicitLeft = -8
    ExplicitWidth = 937
    ExplicitHeight = 585
  end
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
  object FPS: TTimer
    Left = 296
    Top = 24
  end
end
