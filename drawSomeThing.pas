﻿unit drawSomeThing;

interface

uses Winapi.Windows, Vcl.Graphics, System.Types;

type
  //R - right hand, L - left hand
  //H - hand, LG - leg
  TAllHandPos = (RightHandPos1, LeftHandPos1);
  TAllLegPos = (RightLegPos1, LeftLegPos1);
  TAllMenPos = (MenPos1);

procedure SetCanvas(canvas: TCanvas);
procedure DrawPerson(rightHand, leftHand: TAllHandPos;
rightLeg, leftLeg: TAllLegPos; handBody, legBody: TPointF; size: single);
procedure DrawHand(pos: TAllHandPos; startPoint: TPointF; size: single); overload;
procedure DrawSnowflake(SFPos: TPoint; Length: Integer; Size, Ratio, OffsetAngle: single);

implementation

uses PointConverter;

type
  T2Points = Record
    firstPoint: TPointF;
    secondPoint: TPointF;
  End;
  TMenParts = Record
    RightHand: TAllHandPos;
    LeftHand: TAllHandPos;
    RightLeg: TAllLegPos;
    LeftLeg: TAllLegPos;
  End;

const
  //point have coordinates based on local system of coordinate.
  //Center of local coord system is handBody for hand and legBody point for leg
  allHandPos: array[TAllhandPos] of T2Points = (
  (firstPoint: (X: 0.070; Y: 0.040); secondPoint: (X: 0.055; Y: -0.020)),    //each line new hand pos
  (firstPoint: (X: -0.070; Y: 0.040); secondPoint: (X: -0.055; Y: -0.020))   //LeftHandPos1
  );

  allLegPos: array[TAllLegPos] of T2Points = (
  (firstPoint: (X: 0.040; Y: 0.050); secondPoint: (X: 0.040; Y: 0.100)),      //each line new hand pos
  (firstPoint: (X: -0.040; Y: 0.050); secondPoint: (X: -0.040; Y: 0.100))
  );

  allMenPos: array[TAllMenPos] of TMenParts = (
  (RightHand: RightHandPos1; LeftHand: LeftHandPos1;
  RightLeg: RightLegPos1; LeftLeg: LeftLegPos1)
  );

  basicColor: TColor = clMaroon;
  basicRightHandPos: TAllHandPos = RightHandPos1;
  SFColor: TColor = clBlack;

var
    myCanvas: TCanvas;

procedure SetCanvas(canvas: TCanvas);
begin
  myCanvas:= canvas;
end;

{procedure DrawHand(Canvas: TCanvas; start, elbow, hand: TPoint); overload;
begin
  Canvas.Pen.Color:= basicColor;
  Canvas.Brush.Color:= clRed;

  Canvas.Ellipse(start.X, start.Y, (start.X + elbow.X), (elbow.Y + start.Y));

  Canvas.Ellipse((start.X + elbow.X), (elbow.Y + start.Y),
  (hand.X  + start.X), (hand.Y  + start.Y));
end;}

procedure DrawHand(pos: TAllHandPos; startPoint: TPointF; size: single); overload;
var
    intP1: TPoint;
    p1: TPointF;
begin
  myCanvas.Pen.Color:= basicColor;
  myCanvas.Brush.Color:= basicColor;
  myCanvas.Pen.Width:= Round(PointConverter.GetPixels * 1.75 * size);

  intP1:= PointConverter.Convert(StartPoint);
  myCanvas.MoveTo(intP1.X, intP1.Y);

  p1.X:= startPoint.X + AllHandPos[pos].firstPoint.X *size;
  p1.Y:= startPoint.Y + AllHandPos[pos].firstPoint.Y *size;
  intP1:= PointConverter.Convert(p1);
  myCanvas.LineTo(intP1.X, intP1.Y);

  p1.X:= startPoint.X + (AllHandPos[pos].secondPoint.X *size);
  p1.Y:= startPoint.Y + AllHandPos[pos].secondPoint.Y *size;
  intP1:= PointConverter.Convert(p1);
  myCanvas.LineTo(intP1.X, intP1.Y);
end;

procedure DrawLeg(pos: TAllLegPos; startPoint: TPointF; size: single); overload;
var
    intP1: TPoint;
    p1: TPointF;
begin
  myCanvas.Pen.Color:= basicColor;
  myCanvas.Brush.Color:= basicColor;
  myCanvas.Pen.Width:= Round(PointConverter.GetPixels * 1.75 * size);

  intP1:= PointConverter.Convert(StartPoint);
  myCanvas.MoveTo(intP1.X, intP1.Y);

  p1.X:= startPoint.X + AllLegPos[pos].firstPoint.X *size;
  p1.Y:= startPoint.Y + AllLegPos[pos].firstPoint.Y *size;
  intP1:= PointConverter.Convert(p1);
  myCanvas.LineTo(intP1.X, intP1.Y);

  p1.X:= startPoint.X + AllLegPos[pos].secondPoint.X *size;
  p1.Y:= startPoint.Y + AllLegPos[pos].secondPoint.Y *size;
  intP1:= PointConverter.Convert(p1);
  myCanvas.LineTo(intP1.X, intP1.Y);
end;

//from body point create head point and second body point.
//1 body poin for hands, second for Legs, in function first (hand) point
procedure DrawPerson(rightHand, leftHand: TAllHandPos;
rightLeg, leftLeg: TAllLegPos; handBody, legBody: TPointF; size: single); overload;
var
    IntP1: TPoint;
    Rect: TRect;
    headRadius: integer;
{
   o
 \/|\/
  /\
 |  \
}
begin
  //head
  headRadius:= Round(PointConverter.GetPixels*3 * size); //значение в пиксилях

  myCanvas.Pen.Color:= basicColor;
  myCanvas.Brush.Color:= basicColor;

  IntP1:= PointConverter.Convert(handBody);
  Rect.Left:= IntP1.X - headRadius;
  Rect.Top:= IntP1.Y - 2*headRadius;
  Rect.Right:= IntP1.X + headRadius;
  Rect.Bottom:= IntP1.Y;
  myCanvas.Ellipse(Rect);

  DrawHand(rightHand, handBody, size);
  DrawHand(leftHand, handBody, size);

  myCanvas.Pen.Width := Round(PointConverter.GetPixels* 1.8 *size);
  IntP1:= PointConverter.Convert(handBody);
  myCanvas.MoveTo(IntP1.X, IntP1.Y);
  IntP1:= PointConverter.Convert(legBody);
  myCanvas.LineTo(IntP1.X, IntP1.Y);

  DrawLeg(rightLeg, legBody, size);
  DrawLeg(LeftLeg, legBody, size);
end;

procedure DrawPerson(menPos: TAllMenPos; handBody, legBody: TPointF; size: single); overload;
var
    IntP1: TPoint;
    Rect: TRect;
    headRadius: integer;
begin
  //head
  headRadius:= Round(PointConverter.GetPixels*3 * size); //значение в пиксилях

  myCanvas.Pen.Color:= basicColor;
  myCanvas.Brush.Color:= basicColor;

  IntP1:= PointConverter.Convert(handBody);
  Rect.Left:= IntP1.X - headRadius;
  Rect.Top:= IntP1.Y - 2*headRadius;
  Rect.Right:= IntP1.X + headRadius;
  Rect.Bottom:= IntP1.Y;
  myCanvas.Ellipse(Rect);

  DrawHand(AllMenPos[menPos].RightHand, handBody, size);
  DrawHand(AllMenPos[menPos].LeftHand, handBody, size);

  myCanvas.Pen.Width := Round(PointConverter.GetPixels* 1.8 *size);
  IntP1:= PointConverter.Convert(handBody);
  myCanvas.MoveTo(IntP1.X, IntP1.Y);
  IntP1:= PointConverter.Convert(legBody);
  myCanvas.LineTo(IntP1.X, IntP1.Y);

  DrawLeg(AllMenPos[menPos].RightLeg, legBody, size);
  DrawLeg(AllMenPos[menPos].LeftLeg, legBody, size);
end;

procedure DrawSnowflake(SFPos: TPoint; Length: Integer; Size, Ratio, OffsetAngle: single);
// SFPos - координаты снежинки
// length - длина любой из 6 полосок в пикселях
// Size - ширина линий
// Ratio - коэффициент должен быть от 0 до 1, от него зависит
// на сколько далеко будут маленькие ответвления
// OffsetAngle - задаешь угол в градусах и снежинка поворачивается
var
  i: Integer;
  Angle: array[0..5] of Double;
  EndPoints, BranchPoints: array[0..5] of TPoint;
  Offset: Integer;
begin
  myCanvas.Pen.Color := SFColor;
  myCanvas.Brush.Color := SFColor;
  myCanvas.Pen.Width := Round((myCanvas.ClipRect.Width + myCanvas.ClipRect.Height) / 2 * 0.017);
  myCanvas.Pen.Width := Round(myCanvas.Pen.Width * Size);

  Offset := Round(Length * Ratio); // Длина и отдаленность маленьких веточек

  // Нужные для лучей точки
  for i := 0 to 5 do
  begin
    Angle[i] := i * 60 * Pi / 180 + OffsetAngle * Pi / 180;
    EndPoints[i].X := SFPos.X + Round(cos(Angle[i]) * Length);
    EndPoints[i].Y := SFPos.Y + Round(sin(Angle[i]) * Length);

    BranchPoints[i].X := SFPos.X + Round(cos(Angle[i]) * (Length - Offset));
    BranchPoints[i].Y := SFPos.Y + Round(sin(Angle[i]) * (Length - Offset));
  end;

  for i := 0 to 5 do
  begin
    // 6 Лучей
    myCanvas.MoveTo(SFPos.X, SFPos.Y);
    myCanvas.LineTo(EndPoints[i].X, EndPoints[i].Y);

    // Маленькие ответвления
    myCanvas.MoveTo(BranchPoints[i].X, BranchPoints[i].Y);
    myCanvas.LineTo(
      BranchPoints[i].X + Round(cos(Angle[i] + Pi / 6) * Offset),
      BranchPoints[i].Y + Round(sin(Angle[i] + Pi / 6) * Offset)
    );

    myCanvas.MoveTo(BranchPoints[i].X, BranchPoints[i].Y);
    myCanvas.LineTo(
      BranchPoints[i].X + Round(cos(Angle[i] - Pi / 6) * Offset),
      BranchPoints[i].Y + Round(sin(Angle[i] - Pi / 6) * Offset)
    );
  end;
end;

end.

