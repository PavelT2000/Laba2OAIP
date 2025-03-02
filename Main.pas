unit Main;


{$R *.dfm}

interface

uses
  Winapi.Windows, Winapi.Messages, System.Types, System.SysUtils,
  System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.MPlayer, Vcl.ExtCtrls,

  drawSomeThing, Music,
  Location, PointConverter;

type
  TForm1 = class(TForm)
    MediaPlayer1: TMediaPlayer;
    FPS: TTimer;
    PaintBox1: TPaintBox;
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;


implementation
var PLocation: TPointF;
var StartDrag, StopDrag: TPointF;
var IsDragging: Boolean;

procedure Paint1(Canvas: TCanvas; x1, y1, x2, y2: Integer);
begin
  Canvas.Pen.Color := clRed;
  Canvas.Brush.Color := clRed;
  Canvas.Pen.Width := 5;
  Canvas.MoveTo(x1, y1);
  Canvas.LineTo(x2, y2);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

  PLocation := point(0, 0);
  StopDrag := point(0, 0);
  IsDragging := false;
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  grad: Integer;
  centerPoint: TPoint;
  FormRect: TRect;
begin
  FormRect := Rect(0, 0, ClientWidth, ClientHeight);
  PointConverter.SetFieldRect(FormRect);

  drawSomeThing.SetCanvas(Canvas);
  Location.SetCanvas(Canvas);
  //Music.TurnOn(CalmMind);

  DrawLocation(PLocation);
  centerPoint := point(Round(ClientWidth / 2),
    Round(Form1.ClientHeight / 2));
  drawSomeThing.DrawPerson(RightHandPos1, LeftHandPos1, RightLegPos1,
    LeftLegPos1, centerPoint, 1.7);

  drawSomeThing.DrawSnowflake(point(300, 200), 50, 7, 0.4, 0);

  { Paint1(Canvas, 10, 10, 20, 500);
    Paint1(Canvas, 400, 400, 200, 100);
    Canvas.Ellipse(100-50, 100-50, 100+50, 100+50);     // 150
    grad := 0;
    Paint1(Canvas, 100, 100, 200, 500); }
end;

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Точка, где начинается перетаскивание локации
  StartDrag := PointF(X/ ClientWidth, Y/ ClientHeight);
  IsDragging := true;
end;

procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if IsDragging then
  begin
    // Берем координаты локации и прибавляем к ней координаты перетащенного курсора
    PLocation := pointF(StopDrag.X + X/ ClientWidth - StartDrag.X, StopDrag.Y + Y/ ClientHeight - StartDrag.Y);
    PaintBox1.Invalidate;
  end;
end;

procedure TForm1.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   IsDragging := false;
   // Записываем где сейчас остановилась локация, чтобы потом с этого места ее перетаскивать
   StopDrag := PointF(StopDrag.X + X / ClientWidth - StartDrag.X, StopDrag.Y + Y / ClientHeight - StartDrag.Y);
end;

end.
