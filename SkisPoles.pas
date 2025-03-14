unit SkisPoles;

interface

uses Winapi.Windows, Vcl.Graphics, System.Types, Vcl.Dialogs, System.SysUtils,
  System.Math;

var startDraw: integer;

procedure SetCanvas(canvas: TCanvas);
procedure SetSize(size: single);
procedure DrawSkisPoles(nowCadr: Integer);
procedure Start;
procedure SetPos(newPos: TPointF);
function GetMaxCadrsCount: Integer;

implementation

uses PointConverter;

type
  TSkisPolesPos = record
    RightSki: TRectF;
    LeftSki: TRectF;
    RightPole: TRectF;
    LeftPole: TRectF;
  end;

  TQueuePos = record
    SkisPolesPositions: TSkisPolesPos;
    CadrsCount: Integer;
  end;

  TSkisPolesPosArr = array of TSkisPolesPos;
  TQueuePosArr = array of TQueuePos;

var
  SkisPolesAllPos: TSkisPolesPosArr;

  FavoritePositions: TSkisPolesPosArr;
  QueuePositions: TQueuePosArr;
  basicColor: TColor = TColor($13458B);
  basicWitdh: single = 1.4;

  basicCanvas: TCanvas;
  basicSize: single;
  pos: TPointF;

procedure SetCanvas(canvas: TCanvas);
begin
  basicCanvas := canvas;
end;

procedure SetSize(size: single);
begin
  basicSize := size;
end;

procedure SetPos(newPos: TPointF);
begin
  pos:= newPos;
end;


procedure PushToQueue(SkisPoles: TSkisPolesPos; countCadrs: Integer);
var
  ToPush: TQueuePos;
begin
  ToPush.SkisPolesPositions := SkisPoles;
  ToPush.CadrsCount := countCadrs;

  SetLength(QueuePositions, Length(QueuePositions)+1);
  QueuePositions[High(QueuePositions)] := ToPush;
end;



function DeltaRectF(StartRect, EndRect: TRectF; c, i: Integer): TRectF;
begin
  Result.Left := StartRect.Left - (StartRect.Left - EndRect.Left) / c * i;
  Result.Top := StartRect.Top - (StartRect.Top - EndRect.Top) / c * i;
  Result.Right := StartRect.Right - (StartRect.Right - EndRect.Right) / c * i;
  Result.Bottom := StartRect.Bottom - (StartRect.Bottom - EndRect.Bottom) / c * i;
end;

function Add2Rect(Rect1, Rect2: TRectF):TRectF;
begin
  result.Top:= Rect1.Top + Rect2.Top;
  result.Bottom:= Rect1.Bottom + Rect2.Bottom;
  result.Right:= Rect1.Right + Rect2.Right;
  result.Left:= Rect1.Left + Rect2.Left;
end;

procedure SetSkisPolesPositions;
var
  SkisPoles: TSkisPolesPos;
  step, hight: single;
  baseFrames: integer;
  rect: TRectF;

procedure SlideAnim(cadrs, range: Integer; X, Y: Real);
begin
  PushToQueue(SkisPoles, cadrs*range);

  SkisPoles.LeftSki:= Add2Rect(SkisPoles.LeftSki, RectF(X*range, Y*range, X*range, Y*range));
  SkisPoles.RightSki:= Add2Rect(SkisPoles.RightSki, RectF(X*range, Y*range, X*range, Y*range));
  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(X*range, Y*range, X*range, Y*range));
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(X*range, Y*range, X*range, Y*range));
end;

begin

  hight:= 0.24;
  //��������� ������� шкаф
  SkisPoles.RightSki.Create (0.445, 0.3, 0.445, 0.3+0.24);
  SkisPoles.LeftSki.Create  (0.42, 0.3, 0.42, 0.3+0.24);
  SkisPoles.RightPole.Create(0.41, 0.3, 0.41, 0.54);
  SkisPoles.LeftPole.Create (0.4, 0.3, 0.4, 0.54);

  PushToQueue(SkisPoles, startDraw); // �����

  PushToQueue(SkisPoles, 15);

  //промежуточный для надевания (переворачивание лыж)
  SkisPoles.LeftSki.Create (0.52, 0.59, 0.52-0.17, 0.59);
  SkisPoles.RightSki.Create  (0.52, 0.64, 0.52-0.17, 0.64);
  PushToQueue(SkisPoles, 15);

  //final ski
  SkisPoles.LeftSki.Create (0.47, 0.7, 0.47-0.17, 0.7);
  SkisPoles.RightSki.Create  (0.43, 0.75, 0.43-0.17, 0.75);
  PushToQueue(SkisPoles, 35); //пауза

  PushToQueue(SkisPoles, 10);

  //берёт палки
  SkisPoles.LeftPole.Create(0.429, 0.412, 0.429, 0.7);
  SkisPoles.RightPole.Create (0.414, 0.444, 0.414, 0.8);
  PushToQueue(SkisPoles, 10);

  step:= 0.0;
  baseFrames:= 10;
  for var i := 0 to 3 do
  begin
    if (i = 0) then step:= 0 else step:= 0.08;
    // Установка позиций каждой конечности
    //1
    SkisPoles.LeftSki:= Add2Rect(SkisPoles.LeftSki, RectF(step, 0, step, 0));
    SkisPoles.RightSki:= Add2Rect(SkisPoles.RightSki, RectF(step, 0, step, 0));
    SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(step, 0, step, 0));
    SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(step, 0, step, 0));
    PushToQueue(SkisPoles, baseFrames);

    //2
    SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(0.005, 0.048, -0.02, -0.005));
    SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(0.005, 0.048, -0.02, -0.005));

    //SkisPoles.RightPole.Create (0.425, 0.501, 0.414, 0.8);
    SkisPoles.LeftSki:= Add2Rect(SkisPoles.LeftSki, RectF(step, 0, step, 0));
    SkisPoles.RightSki:= Add2Rect(SkisPoles.RightSki, RectF(step, 0, step, 0));
    SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(step, 0, step, 0));
    SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(step, 0, step, 0));
    PushToQueue(SkisPoles, baseFrames);

    step:= 0.06;
    //3
    SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(0.005, 0.048, -0.02, -0.005));
    SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(0.005, 0.048, -0.02, -0.005));

    SkisPoles.LeftSki:= Add2Rect(SkisPoles.LeftSki, RectF(step, 0, step, 0));
    SkisPoles.RightSki:= Add2Rect(SkisPoles.RightSki, RectF(step, 0, step, 0));
    SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(step, 0, step, 0));
    SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(step, 0, step, 0));
    PushToQueue(SkisPoles, baseFrames);

    //2
    SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(-0.005, -0.048, 0.02, 0.005));
    SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(-0.005, -0.048, 0.02, 0.005));

    //SkisPoles.RightPole.Create (0.425, 0.501, 0.414, 0.8);
    SkisPoles.LeftSki:= Add2Rect(SkisPoles.LeftSki, RectF(step, 0, step, 0));
    SkisPoles.RightSki:= Add2Rect(SkisPoles.RightSki, RectF(step, 0, step, 0));
    SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(step, 0, step, 0));
    SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(step, 0, step, 0));
    PushToQueue(SkisPoles, baseFrames);

    SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(-0.005, -0.048, 0.02, 0.005));
    SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(-0.005, -0.048, 0.02, 0.005));

  end;

  PushToQueue(SkisPoles, 10);
  PushToQueue(SkisPoles, 20);
  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(-0.004, 0.16, -0.07, 0));
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(0.009, 0.148, -0.09, -0.035));
  //PushToQueue(SkisPoles, 3000);
  // Толчек
  PushToQueue(SkisPoles, 3);
  rect:= RectF(-0.01, 0.01, -0.04, -0.09);
  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, rect);
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, rect);

  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(0.02, 0.025, 0.02, 0.025));
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(0.02, 0.025, 0.02, 0.025));
  SkisPoles.LeftSki:= Add2Rect(SkisPoles.LeftSki, RectF(0.02, 0.025, 0.02, 0.025));
  SkisPoles.RightSki:= Add2Rect(SkisPoles.RightSki, RectF(0.02, 0.025, 0.02, 0.025));
  // Обратно
  PushToQueue(SkisPoles, 3);
  rect:= RectF(0.01, -0.01, 0.04, 0.09);
  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, rect);
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, rect);

  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(0.02, 0.025, 0.02, 0.025));
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(0.02, 0.025, 0.02, 0.025));
  SkisPoles.LeftSki:= Add2Rect(SkisPoles.LeftSki, RectF(0.02, 0.025, 0.02, 0.025));
  SkisPoles.RightSki:= Add2Rect(SkisPoles.RightSki, RectF(0.02, 0.025, 0.02, 0.025));

  SlideAnim(3, 10, 0.02, 0.025);

//  PushToQueue(Person, 4*10);
//
//  Person.LegBody := Person.LegBody + PointF(0.02*10, 0.025*10);
//  Person.Neck := Person.LegBody + PointF(0.04, -0.077);
  baseFrames:= 2;
  // Толчек
  PushToQueue(SkisPoles, baseFrames);
  rect:= RectF(-0.01, 0.01, -0.04, -0.09);
  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, rect);
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, rect);

  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(0.02, 0.025, 0.02, 0.025));
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(0.02, 0.025, 0.02, 0.025));
  SkisPoles.LeftSki:= Add2Rect(SkisPoles.LeftSki, RectF(0.02, 0.025, 0.02, 0.025));
  SkisPoles.RightSki:= Add2Rect(SkisPoles.RightSki, RectF(0.02, 0.025, 0.02, 0.025));
  // Обратно
  PushToQueue(SkisPoles, baseFrames);
  rect:= RectF(0.01, -0.01, 0.04, 0.09);
  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, rect);
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, rect);

  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(0.02, 0.025, 0.02, 0.025));
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(0.02, 0.025, 0.02, 0.025));
  SkisPoles.LeftSki:= Add2Rect(SkisPoles.LeftSki, RectF(0.02, 0.025, 0.02, 0.025));
  SkisPoles.RightSki:= Add2Rect(SkisPoles.RightSki, RectF(0.02, 0.025, 0.02, 0.025));

  SlideAnim(baseFrames, 6, 0.02, 0.025);

  step:= -0.012;
  // Толчек
  PushToQueue(SkisPoles, baseFrames);
  rect:= RectF(-0.01, 0.01, -0.04, -0.09);
  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, rect);
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, rect);

  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(0.03, step, 0.03, step));
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(0.03, step, 0.03, step));
  SkisPoles.LeftSki:= Add2Rect(SkisPoles.LeftSki, RectF(0.03, step, 0.03, step));
  SkisPoles.RightSki:= Add2Rect(SkisPoles.RightSki, RectF(0.03, step, 0.03, step));

  // Обратно
  PushToQueue(SkisPoles, baseFrames);
  rect:= RectF(0.01, -0.01, 0.04, 0.09);
  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, rect);
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, rect);

  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(0.03, step, 0.03, step));
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(0.03, step, 0.03, step));
  SkisPoles.LeftSki:= Add2Rect(SkisPoles.LeftSki, RectF(0.03, step, 0.03, step));
  SkisPoles.RightSki:= Add2Rect(SkisPoles.RightSki, RectF(0.03, step, 0.03, step));

  SlideAnim(baseFrames, 8, 0.02, -0.008);

  // Толчек
  PushToQueue(SkisPoles, baseFrames);
  rect:= RectF(-0.01, 0.01, -0.04, -0.09);
  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, rect);
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, rect);

  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(0.03, step, 0.03, step));
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(0.03, step, 0.03, step));
  SkisPoles.LeftSki:= Add2Rect(SkisPoles.LeftSki, RectF(0.03, step, 0.03, step));
  SkisPoles.RightSki:= Add2Rect(SkisPoles.RightSki, RectF(0.03, step, 0.03, step));
//   Обратно
  PushToQueue(SkisPoles, baseFrames);
  rect:= RectF(0.01, -0.01, 0.04, 0.09);
  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, rect);
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, rect);

  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(0.03, step, 0.03, step));
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(0.03, step, 0.03, step));
  SkisPoles.LeftSki:= Add2Rect(SkisPoles.LeftSki, RectF(0.03, step, 0.03, step));
  SkisPoles.RightSki:= Add2Rect(SkisPoles.RightSki, RectF(0.03, step, 0.03, step));


  SlideAnim(baseFrames, 8, 0.02, -0.008);

  // Падение

  SlideAnim(baseFrames, 7, 0.02, -0.008);

  SlideAnim(baseFrames, 5, 0.02, -0.004);

  SlideAnim(baseFrames, 3, 0.02, 0.00);

  SlideAnim(3, 5, 0.02, 0.004);

  SlideAnim(3, 7, 0.02, 0.008);

  SlideAnim(3, 10, 0.02, 0.016);

  SlideAnim(3, 7, 0.02, 0.02);

  SlideAnim(3, 5, 0.02, 0.03);

  SlideAnim(4, 19, 0.02, 0.04);

  // Приземление
  SlideAnim(4, 2, 0.04, 0.00);

  SlideAnim(6, 2, 0.06, 0.00);

  SlideAnim(8, 1, 0.06, 0.00);

  PushToQueue(SkisPoles, 20);

  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(-0.03, -0.16, 0.03, -0));
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(-0.035, -0.148, 0.055, 0.03));

  step:= 0.01;
  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(-0.02, step, -0.02, step));
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(-0.02, step, -0.02, step));
  SkisPoles.LeftSki:= Add2Rect(SkisPoles.LeftSki, RectF(-0.02, step, -0.02, step));
  SkisPoles.RightSki:= Add2Rect(SkisPoles.RightSki, RectF(-0.02, step, -0.02, step));

  PushToQueue(SkisPoles, 10);


  PushToQueue(SkisPoles, 10);
  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(0.03, 0.16, -0.03, 0));
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(0.035, 0.148, -0.055, -0.03));
  SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(0.004, -0.16, 0.07, 0));
  SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(-0.009, -0.148, 0.09, 0.035));

  step:= 0.0;
  baseFrames:= 10;
  for var i := 0 to 2 do
  begin
    if (i = 0) then step:= 0 else step:= 0.08;
    // Установка позиций каждой конечности
    //1
    SkisPoles.LeftSki:= Add2Rect(SkisPoles.LeftSki, RectF(step, 0, step, 0));
    SkisPoles.RightSki:= Add2Rect(SkisPoles.RightSki, RectF(step, 0, step, 0));
    SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(step, 0, step, 0));
    SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(step, 0, step, 0));
    PushToQueue(SkisPoles, baseFrames);

    //2
    SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(0.005, 0.048, -0.02, -0.005));
    SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(0.005, 0.048, -0.02, -0.005));

    //SkisPoles.RightPole.Create (0.425, 0.501, 0.414, 0.8);
    SkisPoles.LeftSki:= Add2Rect(SkisPoles.LeftSki, RectF(step, 0, step, 0));
    SkisPoles.RightSki:= Add2Rect(SkisPoles.RightSki, RectF(step, 0, step, 0));
    SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(step, 0, step, 0));
    SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(step, 0, step, 0));
    PushToQueue(SkisPoles, baseFrames);

    step:= 0.06;
    //3
    SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(0.005, 0.048, -0.02, -0.005));
    SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(0.005, 0.048, -0.02, -0.005));

    SkisPoles.LeftSki:= Add2Rect(SkisPoles.LeftSki, RectF(step, 0, step, 0));
    SkisPoles.RightSki:= Add2Rect(SkisPoles.RightSki, RectF(step, 0, step, 0));
    SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(step, 0, step, 0));
    SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(step, 0, step, 0));
    PushToQueue(SkisPoles, baseFrames);

    //2
    SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(-0.005, -0.048, 0.02, 0.005));
    SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(-0.005, -0.048, 0.02, 0.005));

    //SkisPoles.RightPole.Create (0.425, 0.501, 0.414, 0.8);
    SkisPoles.LeftSki:= Add2Rect(SkisPoles.LeftSki, RectF(step, 0, step, 0));
    SkisPoles.RightSki:= Add2Rect(SkisPoles.RightSki, RectF(step, 0, step, 0));
    SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(step, 0, step, 0));
    SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(step, 0, step, 0));
    PushToQueue(SkisPoles, baseFrames);

    SkisPoles.LeftPole:= Add2Rect(SkisPoles.LeftPole, RectF(-0.005, -0.048, 0.02, 0.005));
    SkisPoles.RightPole:= Add2Rect(SkisPoles.RightPole, RectF(-0.005, -0.048, 0.02, 0.005));

  end;

  // ��� ��� ����� ��� � � ������
  PushToQueue(SkisPoles, baseFrames+9999);
  PushToQueue(SkisPoles, baseFrames);

end;


function MakeCadrsBetween(pStart, pEnd: TSkisPolesPos; countCadrs: Integer): TSkisPolesPosArr;
var
  i: Integer;
  PersonBetween: TSkisPolesPos;
begin

  countCadrs := countCadrs+1;
  setLength(result, countCadrs);

  for i := 0 to countCadrs-1 do
  begin
    result[i].RightSki := DeltaRectF(pStart.RightSki, pEnd.RightSki, countCadrs, i);
    result[i].LeftSki:= DeltaRectF(pStart.LeftSki, pEnd.LeftSki, countCadrs, i);
    result[i].RightPole := DeltaRectF(pStart.RightPole, pEnd.RightPole, countCadrs, i);
    result[i].LeftPole := DeltaRectF(pStart.LeftPole, pEnd.LeftPole, countCadrs, i);
  end;

end;


// ����������� ���� ������

procedure MakeAllCadrs;
var
  i, j: Integer;
  Person: TSkisPolesPos;
  TempCadrs: TSkisPolesPosArr;
  cadrsCount, oldLength: Integer;
begin
  for i := Low(QueuePositions) to High(QueuePositions)-1 do
  begin
    cadrsCount := QueuePositions[i].CadrsCount;
    // cadrsCount+2 = Length(TempCadrs)

    TempCadrs := MakeCadrsBetween(
    QueuePositions[i].SkisPolesPositions,
    QueuePositions[i+1].SkisPolesPositions,
    cadrsCount);

    oldLength := Length(SkisPolesAllPos);
    SetLength(SkisPolesAllPos, OldLength + cadrsCount+1);

    for j := Low(TempCadrs) to High(TempCadrs) do
      SkisPolesAllPos[OldLength + j] := TempCadrs[j];

  end;
end;

function GetMaxCadrsCount: Integer;
begin
  result := Length(SkisPolesAllPos);
end;

procedure DrawSkiOrPole(skiPos: TRectF; size: single);
var
  intP1: TPoint;
  xy1, xy2: TPointF;
begin
  basicCanvas.Pen.Color := basicColor;
  basicCanvas.Brush.Color := basicColor;
  basicCanvas.Pen.Width := Round(PointConverter.GetPixels * basicWitdh * size);

  skiPos.TopLeft := skiPos.TopLeft + pos;
  skiPos.BottomRight := skiPos.BottomRight + pos;

  intP1 := PointConverter.Convert(skiPos.TopLeft);
  basicCanvas.MoveTo(intP1.X, intP1.Y);
  intP1 := PointConverter.Convert(skiPos.BottomRight);
  basicCanvas.LineTo(intP1.X, intP1.Y);
end;



procedure DrawSkisPoles(nowCadr: Integer);
var
  ToDrawPos: TSkisPolesPos;
begin

  ToDrawPos := SkisPolesAllPos[nowCadr-1];

  DrawSkiOrPole(ToDrawPos.RightSki, basicSize);
  DrawSkiOrPole(ToDrawPos.LeftSki, basicSize);
  DrawSkiOrPole(ToDrawPos.RightPole, basicSize/3);
  DrawSkiOrPole(ToDrawPos.LeftPole, basicSize/3);
end;

procedure Start;
begin
  SetSkisPolesPositions;
  MakeAllCadrs;
end;

end.
