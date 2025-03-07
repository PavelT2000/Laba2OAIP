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
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FPSTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

const
  CountSF = 16;

type
  TSnowflake = record
    X, Y: Single;
    Length: Integer;
    Ratio: Single;
    Speed: Single;
  end;

var PLocation: TPointF;
  StartDrag, StopDrag: TPointF;
  IsDragging: Boolean;
  SF_Y, SF_X, SF_ratio: Single;
  SF_Length: Integer;
  Snowflakes: array [1..CountSF] of TSnowflake;


procedure TForm1.FormCreate(Sender: TObject);
var i: Integer;
begin
  drawSomeThing.SetSize(1);
  drawSomeThing.SetCanvas(Canvas);
  Location.SetCanvas(Canvas);
  drawSomeThing.myNeck:= PointF(0.5, 0.5);
  drawSomeThing.myLegBody:= PointF(0.5, 0.65);
  drawSomeThing.createCadrArr();
  MakeAllCadrs(drawSomeThing.ArrMainCadrs1);

  PLocation := point(0, 0);
  StopDrag := point(0, 0);
  IsDragging := false;

  // Snowflakes
  for i := 1 to CountSF do
  begin
    Snowflakes[i].X := Random;
    Snowflakes[i].Y := Random;
    Snowflakes[i].Length := Random(11) + 10; // 10/20
    Snowflakes[i].Ratio := Random(41) / 100 + 0.4; // 0.4/0.8
    Snowflakes[i].Speed := Random(5) / 500 + 0.004; // 0.004/0.012
  end;

  //Music.TurnOn(CalmMind);
end;

procedure NextPaint();
var
  FormRect: TRect;
  i: Integer;
begin
  FormRect := Rect(0, 0, Form1.ClientWidth, Form1.ClientHeight);
  PointConverter.SetFieldRect(FormRect);

  DrawLocation2(PLocation);

  if (allCadrs > 0) and (allCadrs <= 1000) then begin
    prDrawPerson;
  end;
  //DrawPerson(drawSomeThing.MenSki1);
  //DrawPerson(drawSomeThing.MenSki2);

  // SnowFlakes
  for i := 1 to CountSF do
    drawSomeThing.DrawSnowflake(
    PointF(Snowflakes[i].X, Snowflakes[i].Y),
    Snowflakes[i].Length, 1.5, Snowflakes[i].Ratio, Snowflakes[i].Y*200
    );

end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  // При перекрывании окна или его сворачивании: нарисует текущий кадр
  // Рисует следующий кадр
  NextPaint();
end;

procedure TForm1.FPSTimer(Sender: TObject);
var
  i: Integer;
begin
  inc(allCadrs);
  // Тута играемся с переменными для выставления определенных локаций, поз и т.д.


  // SnowFlakes
  for i := 1 to CountSF do
  begin
    Snowflakes[i].Y := Snowflakes[i].Y + Snowflakes[i].Speed;

    if Snowflakes[i].Y > 1 then
    begin
      Snowflakes[i].Y := 0;
      Snowflakes[i].X := Random;
      Snowflakes[i].Length := Random(11) + 10; // 10/20
      Snowflakes[i].Ratio := Random(41) / 100 + 0.4; // 0.4/0.8
      Snowflakes[i].Speed := Random(5) / 500 + 0.004; // 0.004/0.012
    end;
  end;

  //...

  // Убирает все (вызывает OnPaint вручную)
  Form1.Invalidate;
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
    Form1.Invalidate;
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
