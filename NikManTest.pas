﻿unit NikManTest;

interface

uses Winapi.Windows, Vcl.Graphics, System.Types, Vcl.Dialogs, System.SysUtils,
  System.Math;

type

//  TPosition2 = record
//    X1, Y1: Single;
//    X2, Y2: Single;
//    constructor SetPos(aX1, aY1, aX2, aY2: Single);
//  end;
//
//  TPosition = record
//    X, Y: Single;
//    constructor SetPos(aX, aY: Single);
//  end;

  TPersonPos = record
    RightHand: TRectF;
    LeftHand: TRectF;
    RightLeg: TRectF;
    LeftLeg: TRectF;
    Neck: TPointF;
    LegBody: TPointF;
  end;

  TQueuePos = record
    PersonPositions: TPersonPos;
    CadrsCount: Integer;
  end;

  TPersonPosArr = array of TPersonPos;
  TQueuePosArr = array of TQueuePos;

procedure SetCanvas(canvas: TCanvas);
procedure SetSize(size: single);
procedure DrawPerson(nowCadr: Integer);
procedure Start;
procedure SetPos(newPos: TPointF);
function GetMaxCadrsCount: Integer;

implementation

uses PointConverter, SkisPoles;

var
  PersonAllPos: TPersonPosArr;
  FavoritePositions: TPersonPosArr;
  QueuePositions: TQueuePosArr;
  basicColor: TColor = clMaroon;
  basicColor2: TColor = clBlack;
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

function CalculateAngleVectors(vector1, vector2: TPointF): Double;
begin
  result := ArcCos(vector1.DotProduct(vector2) /
    (vector1.Length * vector2.Length));
  if vector1.X < vector2.X then
    result := - result;

end;

procedure DrawHand(menPos: TRectF; startPoint: TPointF; size: single);
var
  intP1: TPoint;
  p1: TPointF;
begin
  basicCanvas.Pen.Color := basicColor;
  basicCanvas.Brush.Color := basicColor;
  basicCanvas.Pen.Width := Round(PointConverter.GetPixels * basicWitdh * size);
  startPoint:= startPoint + pos;

  intP1 := PointConverter.Convert(startPoint);
  basicCanvas.MoveTo(intP1.X, intP1.Y);

  p1:= p1 + pos;
  p1.X := startPoint.X + menPos.Left * size;
  p1.Y := startPoint.Y + menPos.Top * size;
  intP1 := PointConverter.Convert(p1);
  basicCanvas.LineTo(intP1.X, intP1.Y);
  
  p1:= p1 + pos;
  p1.X := startPoint.X + menPos.Right * size;
  p1.Y := startPoint.Y + menPos.Bottom * size;
  intP1 := PointConverter.Convert(p1);
  basicCanvas.LineTo(intP1.X, intP1.Y);
end;

procedure DrawLeg(menPos: TRectF; startPoint: TPointF; size: single);
var
  intP1: TPoint;
  p1: TPointF;
begin
  basicCanvas.Pen.Color := basicColor;
  basicCanvas.Brush.Color := basicColor;
  basicCanvas.Pen.Width := Round(PointConverter.GetPixels * basicWitdh * size);
  startPoint:= startPoint + pos;

  intP1 := PointConverter.Convert(startPoint);
  basicCanvas.MoveTo(intP1.X, intP1.Y);

  p1:= p1 + pos;
  p1.X := startPoint.X + menPos.Left * size;
  p1.Y := startPoint.Y + menPos.Top * size;
  intP1 := PointConverter.Convert(p1);
  basicCanvas.LineTo(intP1.X, intP1.Y);

  p1:= p1 + pos;
  p1.X := startPoint.X + menPos.Right * size;
  p1.Y := startPoint.Y + menPos.Bottom * size;
  intP1 := PointConverter.Convert(p1);
  basicCanvas.LineTo(intP1.X, intP1.Y);
end;

procedure DrawHead(neck, legBody: TPointF; size: single);
var
  intP1: TPoint;
  Rect: TRect;
  headRadius: Integer;
  angle: Double;
begin
  basicCanvas.Pen.Color := basicColor;
  basicCanvas.Brush.Color := basicColor;
  basicCanvas.Pen.Width := Round(PointConverter.GetPixels * basicWitdh * size);
  headRadius := Round(PointConverter.GetPixels * 2.4 * size);
  // значение в пиксилях
  neck:= neck + pos;
  legBody:= legBody + pos;

  angle := CalculateAngleVectors(legBody - neck, pointf(0, -1)) + Pi / 2;
  // showmessage(FloatToStr(angle));
  intP1 := PointConverter.Convert(neck);
  intP1.X := intP1.X + Round(cos(angle) * headRadius);
  intP1.Y := intP1.Y + Round(sin(angle) * headRadius);

  Rect.Left := intP1.X - headRadius;
  Rect.Top := intP1.Y - headRadius;
  Rect.Right := intP1.X + headRadius;
  Rect.Bottom := intP1.Y + headRadius;
  basicCanvas.Ellipse(Rect);
end;

procedure DrawBody(neck, legBody: TPointF; size: single);
var
  intP1: TPoint;
begin
  basicCanvas.Pen.Color := basicColor;
  basicCanvas.Brush.Color := basicColor;
  basicCanvas.Pen.Width := Round(PointConverter.GetPixels * basicWitdh * size);
  neck:= neck + pos;
  legBody:= legBody + pos;

  intP1 := PointConverter.Convert(neck);
  basicCanvas.MoveTo(intP1.X, intP1.Y);
  intP1 := PointConverter.Convert(legBody);
  basicCanvas.LineTo(intP1.X, intP1.Y);
end;


procedure PushToQueue(Person: TPersonPos; countCadrs: Integer);
var
  ToPush: TQueuePos;
begin
  ToPush.PersonPositions := Person;
  ToPush.CadrsCount := countCadrs;

  SetLength(QueuePositions, Length(QueuePositions)+1);
  QueuePositions[High(QueuePositions)] := ToPush;
end;

function Add2Rect(Rect1, Rect2: TRectF):TRectF;
begin
  result.Top:= Rect1.Top + Rect2.Top;
  result.Bottom:= Rect1.Bottom + Rect2.Bottom;
  result.Right:= Rect1.Right + Rect2.Right;
  result.Left:= Rect1.Left + Rect2.Left;
end;

procedure SetPersonPositions;
var
  Person: TPersonPos;
  step, step2: single;
  baseFrames: integer;

procedure SlideAnim(cadrs, range: Integer; X, Y: Real);
begin
  PushToQueue(Person, cadrs*range);

  Person.LegBody := Person.LegBody + PointF(X*range, Y*range);
  Person.Neck := Person.LegBody + PointF(0.04, -0.077);
end;

begin
  SetLength(FavoritePositions, 100);
  step:= 0.009;
  step2:= -0.0084;
  baseFrames:= 3;
  //стартовая позиция
  Person.Neck := PointF   (0.1, 0.7);
  Person.LegBody := PointF(0.1, 0.85);

  for var i := 0 to 5 do
  begin
    // Установка позиций каждой конечности
    //1
    Person.RightHand.Create (0.028, 0.062, 0.065, 0.05);
    Person.LeftHand.Create  (- 0.04, 0.055, 0.005, 0.075);
    Person.RightLeg.Create  (0.034, 0.06, 0.03, 0.13);
    Person.LeftLeg.Create   (- 0.02, 0.062, -0.05, 0.13);
    Person.Neck:= Person.Neck + PointF(step, step2);
    Person.LegBody:= Person.LegBody + PointF(step, step2);

    // Позиция и кол-во кадров для плавного перехода к следующей позиции
    PushToQueue(Person, baseFrames);
    //2
    Person.RightHand.Create ( 0.018, 0.062, 0.052, 0.035);
    Person.LeftHand.Create  (- 0.026, 0.055, 0.012, 0.088);
    Person.RightLeg.Create  (0.025, 0.06, 0.013, 0.13);
    Person.LeftLeg.Create   (- 0.012, 0.062, - 0.023, 0.13);
    Person.Neck:= Person.Neck + PointF(step, step2);
    Person.LegBody:= Person.LegBody + PointF(step, step2);
    PushToQueue(Person, baseFrames);

    //3
    Person.RightHand.Create (0.008, 0.062, 0.042, 0.052);
    Person.LeftHand.Create  (-0.015, 0.055, 0.027, 0.075);
    Person.RightLeg.Create  (0.008, 0.06, 0.001, 0.13);
    Person.LeftLeg.Create   (-0.004, 0.062, -0.015, 0.13);
    Person.Neck:= Person.Neck + PointF(step, step2);
    Person.LegBody:= Person.LegBody + PointF(step, step2);
    PushToQueue(Person, baseFrames);

    //4
    Person.RightHand.Create (-0.015, 0.055, 0.027, 0.075);
    Person.LeftHand.Create  (0.008, 0.062, 0.042, 0.052);
    Person.RightLeg.Create  (-0.004, 0.062, -0.015, 0.13);
    Person.LeftLeg.Create   (0.008, 0.06, 0.001, 0.13);
    Person.Neck:= Person.Neck + PointF(step, step2);
    Person.LegBody:= Person.LegBody + PointF(step, step2);
    PushToQueue(Person, -1);
    // при -1 никаких кадров создаваться не будет
    // Подробнее в функции MakeCadrsBetween

    //switch
    Person.RightHand.Create (0.008, 0.062, 0.042, 0.052);
    Person.LeftHand.Create  (-0.015, 0.055, 0.027, 0.075);
    Person.RightLeg.Create  (0.008, 0.06, 0.001, 0.13);
    Person.LeftLeg.Create   (-0.004, 0.062, -0.015, 0.13);
//    Person.Neck.X:= Person.Neck.X + step/baseFrames;
//    person.LegBody.X:= person.LegBody.X + step/baseFrames;
    PushToQueue(Person, baseFrames);

    //2
    Person.RightHand.Create ( 0.018, 0.062, 0.052, 0.035);
    Person.LeftHand.Create  (- 0.026, 0.055, 0.012, 0.088);
    Person.RightLeg.Create  (0.025, 0.06, 0.013, 0.13);
    Person.LeftLeg.Create   (- 0.012, 0.062, - 0.023, 0.13);
    Person.Neck:= Person.Neck + PointF(step, step2);
    Person.LegBody:= Person.LegBody + PointF(step, step2);
    PushToQueue(Person, baseFrames);
  end;

//  PushToQueue(Person, baseFrames+9999999);


   // Тянется к лыжам
  Person.RightHand.Create ( 0.027, 0.043, 0.050, -0.015);
  Person.LeftHand.Create  ( 0.046, 0.023, 0.075, -0.015);
  Person.RightLeg.Create  ( 0.012, 0.062,  0.023, 0.13);
  Person.LeftLeg.Create   (- 0.012, 0.062, - 0.023, 0.13);
  PushToQueue(Person, 2); // Пауза

  PushToQueue(Person, 15);

  // Поднимает лыжи
  Person.RightHand.Create ( 0.027, 0.038, 0.050, -0.020);
  Person.LeftHand.Create  ( 0.046, 0.018, 0.075, -0.020);
  PushToQueue(Person, 15);

  for var i := Low(QueuePositions) to High(QueuePositions) do
  begin
    SkisPoles.startDraw := SkisPoles.startDraw + QueuePositions[i].CadrsCount + 1;//добавляем начальные кадры
  end;

  // Опускает лыжи
  Person.RightHand.Create ( 0.027, 0.043, 0.050, -0.015);
  Person.LeftHand.Create  ( 0.046, 0.023, 0.075, -0.015);
  PushToQueue(Person, 15);

  //поворачивает лыжи
  Person.Neck := PointF(0.382, 0.472);
  Person.RightHand.Create ( 0.018, 0.068, 0.055, 0.118);
  Person.LeftHand.Create  (0.007, 0.085, 0.04, 0.166);
  PushToQueue(Person, 15);

  // сгибается
  Person.RightLeg.Create  ( 0.012, 0.062-0.05,  0.023, 0.13-0.05);
  Person.LeftLeg.Create   (- 0.012, 0.062-0.05, -0.023, 0.13-0.05);
  Person.LegBody := Person.LegBody + PointF(0, 0.05);
  Person.Neck := Person.LegBody + PointF(0.024, -0.057);

  Person.RightHand.Create  ( -0.021, 0.072, 0.003, 0.105);
  Person.LeftHand.Create   (-0.009, 0.089, 0.008, 0.153);
  PushToQueue(Person, 10);

  //надевает лыжи
  Person.RightLeg.Create  ( 0.012, 0.062-0.05,  0.018, 0.043);
  Person.LeftLeg.Create   (- 0.012, 0.062-0.05, -0.019, 0.096);
  PushToQueue(Person, 10);

  PushToQueue(Person, 15);


  // Тянется к палкам
  Person.RightHand.Create ( 0.017, 0.043, 0.030, -0.015);
  Person.LeftHand.Create  ( 0.036, 0.023, 0.040, -0.015);
  Person.RightLeg.Create  ( 0.015, 0.043,  0.018, 0.093);
  Person.LeftLeg.Create   (- 0.012, 0.062, -0.015, 0.146);
  Person.LegBody := Person.LegBody + PointF(0, -0.05);
  Person.Neck := Person.LegBody + PointF(0, -0.15);
  PushToQueue(Person, 10);

  //взял палки
  Person.RightHand.Create ( 0.026, 0.031, 0.06, 0);
  Person.LeftHand.Create  ( 0.013, 0.06, 0.045, 0.039);

  PushToQueue(Person, 10);

 // Дальше ходьба, но уже с лыжами и палками

  baseFrames:= 10;
  step:= 0.00;
  for var i := 0 to 3 do
  begin
    if (i = 0) then step:= 0
    else step:= 0.08;
    // Установка позиций каждой конечности
    //1
    Person.RightHand.Create ( 0.026, 0.031, 0.06, 0);
    Person.LeftHand.Create  ( 0.013, 0.06, 0.045, 0.039);
    Person.Neck.X:= Person.Neck.X + step;
    person.LegBody.X:= person.LegBody.X + step;
    //PushToQueue(Person, 10000);
    PushToQueue(Person, baseFrames);

    //2
    Person.RightHand.Create ( 0.013, 0.031, 0.049, 0.023);
    Person.LeftHand.Create  (0, 0.06, 0.034, 0.062);
    Person.Neck:= Person.Neck + PointF(0.019, 0.022);
    Person.Neck.X:= Person.Neck.X + step;
    person.LegBody.X:= person.LegBody.X + step;
    //PushToQueue(Person, 10000);
    PushToQueue(Person, baseFrames);

    step:= 0.06;
    //3
    Person.RightHand.Create ( -0.012, 0.017, 0.025, 0.037);
    Person.LeftHand.Create  (-0.023, 0.044, 0.012, 0.074);
    Person.Neck:= Person.Neck + PointF(0.019, 0.022);
    Person.Neck.X:= Person.Neck.X + step;
    person.LegBody.X:= person.LegBody.X + step;
    //PushToQueue(Person, 100);
    PushToQueue(Person, baseFrames);

    //2
    Person.RightHand.Create ( 0.013, 0.034, 0.049, 0.026);
    Person.LeftHand.Create  (0, 0.06, 0.034, 0.062);
    Person.Neck:= Person.Neck - PointF(0.019, 0.022);
    Person.Neck.X:= Person.Neck.X + step;
    person.LegBody.X:= person.LegBody.X + step;
    //PushToQueue(Person, 100);
    PushToQueue(Person, baseFrames);

    Person.Neck:= Person.Neck - PointF(0.019, 0.022);

  end;

  //1
    Person.RightHand.Create ( 0.026, 0.031, 0.06, 0);
    Person.LeftHand.Create  ( 0.013, 0.06, 0.045, 0.039);
    //PushToQueue(Person, 10000);
    PushToQueue(Person, baseFrames);

  PushToQueue(Person, 15);

  Person.RightHand.Create (-0.008, 0.05, 0.017, 0.024);
  Person.LeftHand.Create  (-0.014, 0.051, 0.017, 0.033);
  Person.RightLeg.Create  ( 0.039, 0.007,  0.03, 0.033);
  Person.LeftLeg.Create   (0.027, 0.055, 0.016, 0.086);
  Person.LegBody := Person.LegBody + PointF(-0.02, 0.06);
  Person.Neck := Person.LegBody + PointF(0.04, -0.077);

  PushToQueue(Person, 3);
  ///PushToQueue(Person, 3000);

  // Толчек
  PushToQueue(Person, 3);
  Person.RightHand.Create (-0.041, 0.03, -0.005, 0.051);
  Person.LeftHand.Create  (-0.039, 0.031, -0.005, 0.047);
  Person.LegBody := Person.LegBody + PointF(0.02, 0.025);
  Person.Neck := Person.LegBody + PointF(0.04, -0.077);
  PushToQueue(Person, 3);
  Person.RightHand.Create (-0.008, 0.05, 0.017, 0.024);
  Person.LeftHand.Create  (-0.014, 0.051, 0.017, 0.033);
  Person.LegBody := Person.LegBody + PointF(0.02, 0.025);
  Person.Neck := Person.LegBody + PointF(0.04, -0.077);

  SlideAnim(3, 10, 0.02, 0.025);
  
//  PushToQueue(Person, 4*10);
//
//  Person.LegBody := Person.LegBody + PointF(0.02*10, 0.025*10);
//  Person.Neck := Person.LegBody + PointF(0.04, -0.077);
  baseFrames:= 2;
  // Толчек
  PushToQueue(Person, baseFrames);
  Person.RightHand.Create (-0.041, 0.03, -0.005, 0.051);
  Person.LeftHand.Create  (-0.039, 0.031, -0.005, 0.047);
  Person.LegBody := Person.LegBody + PointF(0.02, 0.025);
  Person.Neck := Person.LegBody + PointF(0.04, -0.077);
  // Обратно
  PushToQueue(Person, baseFrames);
  Person.RightHand.Create (-0.008, 0.05, 0.017, 0.024);
  Person.LeftHand.Create  (-0.014, 0.051, 0.017, 0.033);
  Person.LegBody := Person.LegBody + PointF(0.02, 0.025);
  Person.Neck := Person.LegBody + PointF(0.04, -0.077);

  SlideAnim(baseFrames, 6, 0.02, 0.025);

  // Толчек
  PushToQueue(Person, baseFrames);
  Person.RightHand.Create (-0.041, 0.03, -0.005, 0.051);
  Person.LeftHand.Create  (-0.039, 0.031, -0.005, 0.047);
  Person.LegBody := Person.LegBody + PointF(0.02*1.5, -0.008*1.5);
  Person.Neck := Person.LegBody + PointF(0.04, -0.077);

  // Обратно
  PushToQueue(Person, baseFrames);
  Person.RightHand.Create (-0.008, 0.05, 0.017, 0.024);
  Person.LeftHand.Create  (-0.014, 0.051, 0.017, 0.033);
  Person.LegBody := Person.LegBody + PointF(0.02*1.5, -0.008*1.5);
  Person.Neck := Person.LegBody + PointF(0.04, -0.077);

  SlideAnim(baseFrames, 8, 0.02, -0.008);

  // Толчек
  PushToQueue(Person, baseFrames);
  Person.RightHand.Create (-0.041, 0.03, -0.005, 0.051);
  Person.LeftHand.Create  (-0.039, 0.031, -0.005, 0.047);
  Person.LegBody := Person.LegBody + PointF(0.02*1.5, -0.008*1.5);
  Person.Neck := Person.LegBody + PointF(0.04, -0.077);
//   Обратно
  PushToQueue(Person, baseFrames);
  Person.RightHand.Create (-0.008, 0.05, 0.017, 0.024);
  Person.LeftHand.Create  (-0.014, 0.051, 0.017, 0.033);
  Person.LegBody := Person.LegBody + PointF(0.02*1.5, -0.008*1.5);
  Person.Neck := Person.LegBody + PointF(0.04, -0.077);

  
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

  PushToQueue(Person, 20);

  Person.RightLeg.Create  ( 0.015, 0.043,  0.018, 0.093);
  Person.LeftLeg.Create   (- 0.012, 0.062, -0.015, 0.146);
  Person.LegBody := Person.LegBody + PointF(0, -0.05);
  Person.Neck := Person.LegBody + PointF(0, -0.15);

  PushToQueue(Person, 10);
  PushToQueue(Person, 10);
  
  baseFrames:= 10;
  step:= 0.00;
  for var i := 0 to 2 do
  begin
    if (i = 0) then step:= 0
    else step:= 0.08;
    // Установка позиций каждой конечности
    //1
    Person.RightHand.Create ( 0.026, 0.031, 0.06, 0);
    Person.LeftHand.Create  ( 0.013, 0.06, 0.045, 0.039);
    Person.Neck.X:= Person.Neck.X + step;
    person.LegBody.X:= person.LegBody.X + step;
    //PushToQueue(Person, 10000);
    PushToQueue(Person, baseFrames);

    //2
    Person.RightHand.Create ( 0.013, 0.031, 0.049, 0.023);
    Person.LeftHand.Create  (0, 0.06, 0.034, 0.062);
    Person.Neck:= Person.Neck + PointF(0.019, 0.022);
    Person.Neck.X:= Person.Neck.X + step;
    person.LegBody.X:= person.LegBody.X + step;
    //PushToQueue(Person, 10000);
    PushToQueue(Person, baseFrames);

    step:= 0.06;
    //3
    Person.RightHand.Create ( -0.012, 0.017, 0.025, 0.037);
    Person.LeftHand.Create  (-0.023, 0.044, 0.012, 0.074);
    Person.Neck:= Person.Neck + PointF(0.019, 0.022);
    Person.Neck.X:= Person.Neck.X + step;
    person.LegBody.X:= person.LegBody.X + step;
    //PushToQueue(Person, 100);
    PushToQueue(Person, baseFrames);

    //2
    Person.RightHand.Create ( 0.013, 0.034, 0.049, 0.026);
    Person.LeftHand.Create  (0, 0.06, 0.034, 0.062);
    Person.Neck:= Person.Neck - PointF(0.019, 0.022);
    Person.Neck.X:= Person.Neck.X + step;
    person.LegBody.X:= person.LegBody.X + step;
    //PushToQueue(Person, 100);
    PushToQueue(Person, baseFrames);

    Person.Neck:= Person.Neck - PointF(0.019, 0.022);

  end;
  //1
    Person.RightHand.Create ( 0.026, 0.031, 0.06, 0);
    Person.LeftHand.Create  ( 0.013, 0.06, 0.045, 0.039);
    //PushToQueue(Person, 10000);
    PushToQueue(Person, baseFrames);

  PushToQueue(Person, baseFrames+9999);
  PushToQueue(Person, baseFrames+9999);

end;


// Промежуточные кадры

function DeltaRectF(StartRect, EndRect: TRectF; c, i: Integer): TRectF;
begin
  Result.Left := StartRect.Left - (StartRect.Left - EndRect.Left) / c * i;
  Result.Top := StartRect.Top - (StartRect.Top - EndRect.Top) / c * i;
  Result.Right := StartRect.Right - (StartRect.Right - EndRect.Right) / c * i;
  Result.Bottom := StartRect.Bottom - (StartRect.Bottom - EndRect.Bottom) / c * i;
end;

function DeltaPointF(StartPoint, EndPoint: TPointF; c, i: Integer): TPointF;
begin
  Result.X := StartPoint.X - (StartPoint.X - EndPoint.X) / c * i;
  Result.Y := StartPoint.Y - (StartPoint.Y - EndPoint.Y) / c * i;
end;

function MakeCadrsBetween(pStart, pEnd: TPersonPos; countCadrs: Integer): TPersonPosArr;
var
  i: Integer;
  PersonBetween: TPersonPos;
begin

  countCadrs := countCadrs+1;
  setLength(result, countCadrs);
  // при -1 никакие кадры (промежуточные и крайние) создаваться не будут
  // при 0 будет создаваться только начальный кадр (без промежуточных и конечного)
  // при 1 будет создаваться крайний и промежуточный кадр
  // при >1 будут создаваться countCadrs промежуточных кадров + начальный кадр

  for i := 0 to countCadrs-1 do
  begin
    result[i].RightHand := DeltaRectF(pStart.RightHand, pEnd.RightHand, countCadrs, i);
    result[i].LeftHand:= DeltaRectF(pStart.LeftHand, pEnd.LeftHand, countCadrs, i);
    result[i].RightLeg := DeltaRectF(pStart.RightLeg, pEnd.RightLeg, countCadrs, i);
    result[i].LeftLeg := DeltaRectF(pStart.LeftLeg, pEnd.LeftLeg, countCadrs, i);
    result[i].Neck := DeltaPointF(pStart.Neck, pEnd.Neck, countCadrs, i);
    result[i].LegBody := DeltaPointF(pStart.LegBody, pEnd.LegBody, countCadrs, i);
  end;

end;


// Составление всех кадров

procedure MakeAllCadrs;
var
  i, j: Integer;
  Person: TPersonPos;
  TempCadrs: TPersonPosArr;
  cadrsCount, oldLength: Integer; 
begin
  for i := Low(QueuePositions) to High(QueuePositions)-1 do
  begin
    cadrsCount := QueuePositions[i].CadrsCount;
    // cadrsCount+2 = Length(TempCadrs)

    TempCadrs := MakeCadrsBetween(
    QueuePositions[i].PersonPositions,
    QueuePositions[i+1].PersonPositions,
    cadrsCount);

    oldLength := Length(PersonAllPos);
    SetLength(PersonAllPos, OldLength + cadrsCount+1);

    for j := Low(TempCadrs) to High(TempCadrs) do
      PersonAllPos[OldLength + j] := TempCadrs[j];

  end;
end;

function GetMaxCadrsCount: Integer;
begin
  result := Length(PersonAllPos);
end;



procedure DrawPerson(nowCadr: Integer);
var
  ToDrawPos: TPersonPos;

begin

  ToDrawPos := PersonAllPos[nowCadr-1];

  DrawHead(ToDrawPos.Neck, ToDrawPos.LegBody, basicSize);
  DrawBody(ToDrawPos.Neck, ToDrawPos.LegBody, basicSize);
  DrawHand(ToDrawPos.RightHand, ToDrawPos.Neck, basicSize);
  DrawHand(ToDrawPos.LeftHand, ToDrawPos.Neck, basicSize);
  DrawLeg(ToDrawPos.RightLeg, ToDrawPos.LegBody, basicSize);
  DrawLeg(ToDrawPos.LeftLeg, ToDrawPos.LegBody, basicSize);
end;

procedure Start;
begin
  SetPersonPositions;
  MakeAllCadrs;
end;



end.
