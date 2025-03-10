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

var
  PersonAllPos: TPersonPosArr;
  FavoritePositions: TPersonPosArr;
  QueuePositions: TQueuePosArr;
  basicColor: TColor = clMaroon;
  basicColor2: TColor = clBlack;
  basicWitdh: single = 1.4;

  basicCanvas: TCanvas;
  basicSize: single;

procedure SetCanvas(canvas: TCanvas);
procedure SetSize(size: single);
procedure DrawPerson(nowCadr: Integer);
procedure Start;
function GetMaxCadrsCount: Integer;

implementation

uses PointConverter;




procedure SetCanvas(canvas: TCanvas);
begin
  basicCanvas := canvas;
end;

procedure SetSize(size: single);
begin
  basicSize := size;
end;

function CalculateAngleVectors(vector1, vector2: TPointF): Double;
begin
  result := ArcCos(vector1.DotProduct(vector2) /
    (vector1.Length * vector2.Length));
  if vector1.X < vector2.X then
    result := - result;

end;



procedure DrawHand(pos: TRectF; startPoint: TPointF; size: single);
var
  intP1: TPoint;
  p1: TPointF;
begin
  basicCanvas.Pen.Color := basicColor;
  basicCanvas.Brush.Color := basicColor;
  basicCanvas.Pen.Width := Round(PointConverter.GetPixels * basicWitdh * size);

  intP1 := PointConverter.Convert(startPoint);
  basicCanvas.MoveTo(intP1.X, intP1.Y);

  p1.X := startPoint.X + pos.Left * size;
  p1.Y := startPoint.Y + pos.Top * size;
  intP1 := PointConverter.Convert(p1);
  basicCanvas.LineTo(intP1.X, intP1.Y);
  

  p1.X := startPoint.X + pos.Right * size;
  p1.Y := startPoint.Y + pos.Bottom * size;
  intP1 := PointConverter.Convert(p1);
  basicCanvas.LineTo(intP1.X, intP1.Y);
end;

procedure DrawLeg(pos: TRectF; startPoint: TPointF; size: single);
var
  intP1: TPoint;
  p1: TPointF;
begin
  basicCanvas.Pen.Color := basicColor;
  basicCanvas.Brush.Color := basicColor;
  basicCanvas.Pen.Width := Round(PointConverter.GetPixels * basicWitdh * size);

  intP1 := PointConverter.Convert(startPoint);
  basicCanvas.MoveTo(intP1.X, intP1.Y);

  p1.X := startPoint.X + pos.Left * size;
  p1.Y := startPoint.Y + pos.Top * size;
  intP1 := PointConverter.Convert(p1);
  basicCanvas.LineTo(intP1.X, intP1.Y);


  p1.X := startPoint.X + pos.Right * size;
  p1.Y := startPoint.Y + pos.Bottom * size;
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


procedure SetPersonPositions;
var
  Person: TPersonPos;
  step: single;
  baseFrames: integer;
begin
  SetLength(FavoritePositions, 100);
  step:= 0.01;
  baseFrames:= 10;
  //стартовая позиция
  Person.Neck := PointF   (0.1, 0.5);
  Person.LegBody := PointF(0.1, 0.65);

  for var i := 0 to 0 do
  begin
    // Установка позиций каждой конечности
    //1
    Person.RightHand.Create (0.028, 0.062, 0.065, 0.05);
    Person.LeftHand.Create  (- 0.04, 0.055, 0.005, 0.075);
    Person.RightLeg.Create  (0.034, 0.06, 0.03, 0.13);
    Person.LeftLeg.Create   (- 0.02, 0.062, -0.05, 0.13);
    Person.Neck.X:= Person.Neck.X + step;
    person.LegBody.X:= person.LegBody.X + step;

    // Позиция и кол-во кадров для плавного перехода к следующей позиции
    PushToQueue(Person, baseFrames);
    //2
    Person.RightHand.Create ( 0.018, 0.062, 0.052, 0.035);
    Person.LeftHand.Create  (- 0.026, 0.055, 0.012, 0.088);
    Person.RightLeg.Create  (0.025, 0.06, 0.013, 0.13);
    Person.LeftLeg.Create   (- 0.012, 0.062, - 0.023, 0.13);
    Person.Neck.X:= Person.Neck.X + step;
    person.LegBody.X:= person.LegBody.X + step;
    PushToQueue(Person, baseFrames);

    //3
    Person.RightHand.Create (0.008, 0.062, 0.042, 0.052);
    Person.LeftHand.Create  (-0.015, 0.055, 0.027, 0.075);
    Person.RightLeg.Create  (0.008, 0.06, 0.001, 0.13);
    Person.LeftLeg.Create   (-0.004, 0.062, -0.015, 0.13);
    Person.Neck.X:= Person.Neck.X + step;
    person.LegBody.X:= person.LegBody.X + step;
    PushToQueue(Person, baseFrames);

    //4
    Person.RightHand.Create (-0.015, 0.055, 0.027, 0.075);
    Person.LeftHand.Create  (0.008, 0.062, 0.042, 0.052);
    Person.RightLeg.Create  (-0.004, 0.062, -0.015, 0.13);
    Person.LeftLeg.Create   (0.008, 0.06, 0.001, 0.13);
    Person.Neck.X:= Person.Neck.X + step;
    person.LegBody.X:= person.LegBody.X + step;
    PushToQueue(Person, 0);

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
    Person.Neck.X:= Person.Neck.X + step;
    person.LegBody.X:= person.LegBody.X + step;
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
  PushToQueue(Person, 10);

  // Опускает лыжи
  Person.RightHand.Create ( 0.027, 0.043, 0.050, -0.015);
  Person.LeftHand.Create  ( 0.046, 0.023, 0.075, -0.015);
  PushToQueue(Person, 15);

  // сгибается и надевает лыжи
  Person.RightLeg.Create  ( 0.012, 0.062-0.05,  0.023, 0.13-0.05);
  Person.LeftLeg.Create   (- 0.012, 0.062-0.05, - 0.023, 0.13-0.05);
  Person.LegBody := Person.LegBody + PointF(0, 0.05);
  Person.Neck := Person.LegBody + PointF(0.024, -0.057);

  Person.RightHand.Create  ( -0.021, 0.072, 0.003, 0.105);
  Person.LeftHand.Create   (0.008, 0.08, 0.032, 0.105);
  PushToQueue(Person, 10);


  PushToQueue(Person, 15);


  // Тянется к палкам
  Person.RightHand.Create ( 0.017, 0.043, 0.030, -0.015);
  Person.LeftHand.Create  ( 0.036, 0.023, 0.040, -0.015);
  Person.RightLeg.Create  ( 0.012, 0.062,  0.023, 0.13);
  Person.LeftLeg.Create   (- 0.012, 0.062, - 0.023, 0.13);
  Person.LegBody := Person.LegBody + PointF(0, -0.05);
  Person.Neck := Person.LegBody + PointF(0, -0.15);
  PushToQueue(Person, 10); // Пауза

  PushToQueue(Person, 10);


//  // Дальше ходьба, но уже с лыжами и палками
//  Person.RightHand.Create (0.028, 0.062, 0.065, 0.05);
//  Person.LeftHand.Create  (- 0.04, 0.055, 0.005, 0.075);
//  Person.RightLeg.Create  (0.034, 0.06, 0.03, 0.13);
//  Person.LeftLeg.Create   (- 0.02, 0.062, -0.05, 0.13);
//  PushToQueue(Person, 10);



    for var i := 0 to 3 do
  begin
    // Установка позиций каждой конечности
    //1
    Person.RightHand.Create (0.028, 0.062, 0.065, 0.05);
    Person.LeftHand.Create  (- 0.04, 0.055, 0.005, 0.075);
    Person.RightLeg.Create  (0.034, 0.06, 0.03, 0.13);
    Person.LeftLeg.Create   (- 0.02, 0.062, -0.05, 0.13);
    Person.Neck.X:= Person.Neck.X + step;
    person.LegBody.X:= person.LegBody.X + step;

    // Позиция и кол-во кадров для плавного перехода к следующей позиции
    PushToQueue(Person, baseFrames);
    //2
    Person.RightHand.Create ( 0.018, 0.062, 0.052, 0.035);
    Person.LeftHand.Create  (- 0.026, 0.055, 0.012, 0.088);
    Person.RightLeg.Create  (0.025, 0.06, 0.013, 0.13);
    Person.LeftLeg.Create   (- 0.012, 0.062, - 0.023, 0.13);
    Person.Neck.X:= Person.Neck.X + step;
    person.LegBody.X:= person.LegBody.X + step;
    PushToQueue(Person, baseFrames);

    //3
    Person.RightHand.Create (0.008, 0.062, 0.042, 0.052);
    Person.LeftHand.Create  (-0.015, 0.055, 0.027, 0.075);
    Person.RightLeg.Create  (0.008, 0.06, 0.001, 0.13);
    Person.LeftLeg.Create   (-0.004, 0.062, -0.015, 0.13);
    Person.Neck.X:= Person.Neck.X + step;
    person.LegBody.X:= person.LegBody.X + step;
    PushToQueue(Person, baseFrames);

    //4
    Person.RightHand.Create (-0.015, 0.055, 0.027, 0.075);
    Person.LeftHand.Create  (0.008, 0.062, 0.042, 0.052);
    Person.RightLeg.Create  (-0.004, 0.062, -0.015, 0.13);
    Person.LeftLeg.Create   (0.008, 0.06, 0.001, 0.13);
    Person.Neck.X:= Person.Neck.X + step;
    person.LegBody.X:= person.LegBody.X + step;
    PushToQueue(Person, 0);

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
    Person.Neck.X:= Person.Neck.X + step;
    person.LegBody.X:= person.LegBody.X + step;
    PushToQueue(Person, baseFrames);
  end;


  PushToQueue(Person, baseFrames+999);
  PushToQueue(Person, baseFrames+999);

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
  // Эт чтоб при 0 были как минимум крайние кадры

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
