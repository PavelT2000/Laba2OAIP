unit drawSomeThing;

interface

uses Winapi.Windows, Vcl.Graphics, System.Types, Vcl.Dialogs, System.SysUtils, System.Math;

type
  //R - right hand, L - left hand
  //H - hand, LG - leg
  TAllHandPos = (RightHandPos1, LeftHandPos1, RightHandSki1, LeftHandSki1,
  RightHandSki2, LeftHandSki2, RightHandSki3, LeftHandSki3);
  TAllLegPos = (RightLegPos1, LeftLegPos1, RightLegWalk1, leftLegSki1,
  RightLegWalk2, leftLegSki2, RightLegWalk3, leftLegSki3);
  TAllMenPos = (MenPos1);

procedure SetCanvas(canvas: TCanvas);
procedure DrawPerson(rightHand, leftHand: TAllHandPos;
rightLeg, leftLeg: TAllLegPos; handBody, legBody: TPointF; size: single);
procedure DrawHand(pos: TAllHandPos; startPoint: TPointF; size: single); overload;
procedure DrawSnowflake(SFPosF: TPointF; Length: Integer; Size, Ratio, OffsetAngle: single);
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
  (firstPoint: (X: 0.070; Y: 0.040); secondPoint: (X: 0.055; Y: -0.020)),       //each line new hand pos
  (firstPoint: (X: -0.070; Y: 0.040); secondPoint: (X: -0.055; Y: -0.020)),     //LeftHandPos1
  (firstPoint: (X: 0.028; Y: 0.062); secondPoint: (X: 0.065; Y: 0.05)),         //RightHandSki1
  (firstPoint: (X: -0.04; Y: 0.055); secondPoint: (X: 0.005; Y: 0.075)),        //LeftHandSki1
  (firstPoint: (X: 0.018; Y: 0.062); secondPoint: (X: 0.052; Y: 0.035)),         //RightHandSki2
  (firstPoint: (X: -0.026; Y: 0.055); secondPoint: (X: 0.012; Y: 0.088)),          //LeftHandSki2
  (firstPoint: (X: 0.008; Y: 0.062); secondPoint: (X: 0.042; Y: 0.052)),         //RightHandSki3
  (firstPoint: (X: -0.015; Y: 0.055); secondPoint: (X: 0.027; Y: 0.075))         //LeftHandSki3
  );

  allLegPos: array[TAllLegPos] of T2Points = (
  (firstPoint: (X: 0.040; Y: 0.050); secondPoint: (X: 0.040; Y: 0.100)),        //each line new hand pos
  (firstPoint: (X: -0.040; Y: 0.050); secondPoint: (X: -0.040; Y: 0.100)),
  (firstPoint: (X: 0.034; Y: 0.06); secondPoint: (X: 0.03; Y: 0.13)),          //RightLegWalk1
  (firstPoint: (X: -0.02; Y: 0.062); secondPoint: (X: -0.05; Y: 0.13)),           //leftLegSki1
  (firstPoint: (X: 0.025; Y: 0.06); secondPoint: (X: 0.013; Y: 0.13)),           //RightLegWalk2
  (firstPoint: (X: -0.012; Y: 0.062); secondPoint: (X: -0.023; Y: 0.13)),            //leftLegSki2
  (firstPoint: (X: 0.008; Y: 0.06); secondPoint: (X: 0.001; Y: 0.13)),           //RightLegWalk3
  (firstPoint: (X: -0.004; Y: 0.062); secondPoint: (X: -0.015; Y: 0.13))        //leftLegSki3
  );

  allMenPos: array[TAllMenPos] of TMenParts = (
  (RightHand: RightHandPos1; LeftHand: LeftHandPos1;
  RightLeg: RightLegPos1; LeftLeg: LeftLegPos1)
  );

  basicColor: TColor = clMaroon;
  basicColor2: TColor = clBlack;
  basicRightHandPos: TAllHandPos = RightHandPos1;
  SFColor: TColor = clAqua;

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

function CalculateAngleVectors(vector1, vector2: TPointF): Double;
begin
  result:= ArcCos(vector1.DotProduct(vector2)/(vector1.length * vector2.length))
end;


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

procedure DrawHead(neck, legBody: TPointF; size: single);
var
    IntP1: TPoint;
    Rect: TRect;
    headRadius: integer;
    angle: Double;
begin
  myCanvas.Pen.Color:= basicColor;
  myCanvas.Brush.Color:= basicColor;
  myCanvas.Pen.Width := Round(PointConverter.GetPixels* 1.8 *size);
  headRadius:= Round(PointConverter.GetPixels*3 * size); //значение в пиксилях

  angle := CalculateAngleVectors(legbody-neck, pointf(0, -1)) + Pi/2;
  // showmessage(FloatToStr(angle));
  IntP1:= PointConverter.Convert(neck);
  IntP1.X := IntP1.X + Round(cos(angle) * headRadius);
  IntP1.Y := IntP1.Y + Round(sin(angle) * headRadius);

  Rect.Left:= IntP1.X - headRadius;
  Rect.Top:= IntP1.Y - headRadius;
  Rect.Right:= IntP1.X + headRadius;
  Rect.Bottom:= IntP1.Y + headRadius;
  myCanvas.Ellipse(Rect);
end;

//from body point create head point and second body point.
//1 body poin for hands, second for Legs, in function first (hand) point
procedure DrawPerson(rightHand, leftHand: TAllHandPos;
rightLeg, leftLeg: TAllLegPos; handBody, legBody: TPointF; size: single); overload;
var
    IntP1: TPoint;
{
   o
 \/|\/
  /\
 |  \
}
begin
  DrawHead(handBody, legBody, size);

  DrawHand(rightHand, handBody, size);
  DrawHand(leftHand, handBody, size);

  myCanvas.Pen.Color:= basicColor;
  myCanvas.Brush.Color:= basicColor;
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
  DrawHead(handBody, legBody, size);

  DrawHand(AllMenPos[menPos].RightHand, handBody, size);
  DrawHand(AllMenPos[menPos].LeftHand, handBody, size);

  myCanvas.Pen.Color:= basicColor;
  myCanvas.Brush.Color:= basicColor;
  myCanvas.Pen.Width := Round(PointConverter.GetPixels* 1.8 *size);
  IntP1:= PointConverter.Convert(handBody);
  myCanvas.MoveTo(IntP1.X, IntP1.Y);
  IntP1:= PointConverter.Convert(legBody);
  myCanvas.LineTo(IntP1.X, IntP1.Y);

  DrawLeg(AllMenPos[menPos].RightLeg, legBody, size);
  DrawLeg(AllMenPos[menPos].LeftLeg, legBody, size);
end;

procedure DrawSnowflake(SFPosF: TPointF; Length: Integer; Size, Ratio, OffsetAngle: single);
// SFPosF - координаты снежинки
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
  SFPos: TPoint;
begin
  myCanvas.Pen.Color := SFColor;
  myCanvas.Brush.Color := SFColor;
  myCanvas.Pen.Width:= Round(PointConverter.GetPixels * 0.1 * size);

  Length := Round(PointConverter.GetPixels * 0.1 * Length);

  SFPos:= PointConverter.Convert(SFPosF);

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

