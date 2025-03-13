unit Main;


{$R *.dfm}

interface

uses
  Winapi.Windows, Winapi.Messages, System.Types, System.SysUtils,
  System.Variants, System.Math,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.MPlayer, Vcl.ExtCtrls,

  drawSomeThing, Music, NikManTest, SkisPoles, Clipbrd,
  Location, PointConverter;

type
  TForm1 = class(TForm)
    MediaPlayer1: TMediaPlayer;
    FPS: TTimer;
    CursorPosition: TStaticText;
    CursorHint: TStaticText;
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FPSTimer(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
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
  Snowflakes: array [1..CountSF] of TSnowflake;
  NikTestMaxCadrsCount, SkisPolesMaxCadrsCount: Integer;
  TempCursorStart: TPoint;
  TempCursorEnd: TPoint;


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

  PLocation := pointF(0, 0);
  StopDrag := PLocation;

  NikManTest.SetSize(1);
  NikManTest.SetCanvas(Canvas);
  NikManTest.Start;
  NikTestMaxCadrsCount := NikManTest.GetMaxCadrsCount;

  SkisPoles.SetSize(1);
  SkisPoles.SetCanvas(Canvas);
  SkisPoles.Start;
  SkisPolesMaxCadrsCount := SkisPoles.GetMaxCadrsCount;


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
  allCadrs:= 150;
end;

procedure NextPaint();
var
  FormRect: TRect;
  i: Integer;
begin
  FormRect := Rect(0, 0, Form1.ClientWidth, Form1.ClientHeight);
  PointConverter.SetFieldRect(FormRect);

  DrawLocation3(PLocation);
  NikManTest.SetPos(PLocation);
  SkisPoles.SetPos(PLocation);

  {if (allCadrs > 0) and (allCadrs <= 1000) then begin
    prDrawPerson;
  end;}
  //DrawPerson(drawSomeThing.MenSki1);
  //DrawPerson(drawSomeThing.MenSki2);

  if (allCadrs > 0) and (allCadrs <= SkisPolesMaxCadrsCount) then SkisPoles.DrawSkisPoles(allCadrs);

  if (allCadrs > 0) and (allCadrs <= NikTestMaxCadrsCount) then NikManTest.DrawPerson(allCadrs);

  //едет на трассу
  if (allCadrs > 260) and (allCadrs <= 380) then PLocation:= PLocation + PointF(-0.003, 0);
  //разгоняется
  if (allCadrs > 380) and (allCadrs <= 460) then PLocation:= PLocation + PointF(-0.012, -0.0055);
  //начало полёта
  if (allCadrs > 525) and (allCadrs <= 600) then PLocation:= PLocation + PointF(-0.004, -0.0018);
  //летит
  if (allCadrs > 600) and (allCadrs <= 800) then PLocation:= PLocation + PointF(-0.007, -0.005);
  //приземлился
  if (allCadrs > 800) and (allCadrs <= 850) then PLocation:= PLocation + PointF(-0.003, 0);

  // mod не обязателен, он для повторения анимации
  //NikManTest.DrawPerson(allCadrs+1);




  // SnowFlakes
  for i := 1 to CountSF do
    drawSomeThing.DrawSnowflake(
    PointF(Snowflakes[i].X, Snowflakes[i].Y),
    Snowflakes[i].Length, 1.5, Snowflakes[i].Ratio, Snowflakes[i].Y*200
    );



  // Cursor hint
  Form1.Canvas.Pen.Color := clRed;
  Form1.Canvas.Brush.Color := clRed;
  Form1.Canvas.Pen.Width := Round(PointConverter.GetPixels * 1.4);

  Form1.Canvas.MoveTo(TempCursorStart.X, TempCursorStart.Y);
  Form1.Canvas.LineTo(TempCursorEnd.X, TempCursorEnd.Y);

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

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
var
  CursorPos: TPoint;
  CursorPosF: TPointF;
  X, Y: String;
begin
  case key of
  'q':
    begin
      CursorPos := Form1.ScreenToClient(Mouse.CursorPos);
      TempCursorStart := CursorPos;
      CursorPos := TempCursorEnd - TempCursorStart;
      CursorPosF := PointConverter.ConvertBack(CursorPos);

      X := FloatToStr(RoundTo(CursorPosF.X, -3));
      X := StringReplace(X, ',', '.', [rfReplaceAll]);
      Y := FloatToStr(RoundTo(CursorPosF.Y, -3));
      Y := StringReplace(Y, ',', '.', [rfReplaceAll]);

      Form1.CursorPosition.Caption := X + ', ' + Y;
    end;
  'e':
    begin

      CursorPos := Form1.ScreenToClient(Mouse.CursorPos);
      TempCursorEnd := CursorPos;
      CursorPos := TempCursorEnd - TempCursorStart;
      CursorPosF := PointConverter.ConvertBack(CursorPos);

      X := FloatToStr(RoundTo(CursorPosF.X, -3));
      X := StringReplace(X, ',', '.', [rfReplaceAll]);
      Y := FloatToStr(RoundTo(CursorPosF.Y, -3));
      Y := StringReplace(Y, ',', '.', [rfReplaceAll]);

      Form1.CursorPosition.Caption := X + ', ' + Y;

    end;
  'r':
    begin
      CursorPos := TempCursorEnd - TempCursorStart;
      CursorPosF := PointConverter.ConvertBack(CursorPos);

      X := FloatToStr(RoundTo(CursorPosF.X, -3));
      X := StringReplace(X, ',', '.', [rfReplaceAll]);
      Y := FloatToStr(RoundTo(CursorPosF.Y, -3));
      Y := StringReplace(Y, ',', '.', [rfReplaceAll]);

      Clipboard.AsText := X + ', ' + Y;
      ShowMessage(X + ', ' + Y + ' <-- это скопировано в буфер обмена');
    end;
  end;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Точка, где начинается перетаскивание локации
  StartDrag := PointF(X/ ClientWidth, Y/ ClientHeight);
  IsDragging := true;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if IsDragging then
  begin
    // Берем координаты локации и прибавляем к ней координаты перетащенного курсора
    PLocation := pointF(StopDrag.X + X/ ClientWidth - StartDrag.X, StopDrag.Y + Y/ ClientHeight - StartDrag.Y);
    Form1.Invalidate;
  end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   IsDragging := false;
   // Записываем где сейчас остановилась локация, чтобы потом с этого места ее перетаскивать
   StopDrag := PointF(StopDrag.X + X / ClientWidth - StartDrag.X, StopDrag.Y + Y / ClientHeight - StartDrag.Y);
end;

end.
