unit Main;

{$R *.dfm}

interface

uses
  Winapi.Windows, Winapi.Messages, System.Types, System.SysUtils,
  System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.MPlayer, Vcl.ExtCtrls,

  drawSomeThing, Music,
  Location;

type
  TForm1 = class(TForm)
    MediaPlayer1: TMediaPlayer;
    PaintBox1: TPaintBox;
    FPS: TTimer;
    procedure FormPaint(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;


implementation
var Location: TPoint;

procedure Paint1(Canvas: TCanvas; x1, y1, x2, y2: Integer);
begin
  Canvas.Pen.Color := clRed;
  Canvas.Brush.Color := clRed;
  Canvas.Pen.Width := 5;
  Canvas.MoveTo(x1, y1);
  Canvas.LineTo(x2, y2);
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  grad: Integer;
  centerPoint: TPoint;
begin
  drawSomeThing.SetCanvas(Canvas);
  Location := point(0, 0);

  //Music.TurnOn(CalmMind);
  DrawLocation(Form1.Canvas, Location);
  centerPoint := point(Round(Form1.ClientWidth / 2),
    Round(Form1.ClientHeight / 2));
  drawSomeThing.DrawPerson(RightHandPos1, LeftHandPos1, RightLegPos1,
    LeftLegPos1, centerPoint, 1.7);

  { Paint1(Canvas, 10, 10, 20, 500);
    Paint1(Canvas, 400, 400, 200, 100);
    Canvas.Ellipse(100-50, 100-50, 100+50, 100+50);     // 150
    grad := 0;
    Paint1(Canvas, 100, 100, 200, 500); }
end;

procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  Location := Location + point(X, Y);
end;

end.
