unit drawSomeThing;

interface

uses Winapi.Windows, Vcl.Graphics, System.Types, Vcl.Dialogs, System.SysUtils,
  System.Math;

type
  // R - right hand, L - left hand
  // H - hand, LG - leg
  TAllHandPos = (RightHandPos1, LeftHandPos1, RightHandSki1, LeftHandSki1,
    RightHandSki2, LeftHandSki2, RightHandSki3, LeftHandSki3);
  TAllLegPos = (RightLegPos1, LeftLegPos1, RightLegSki1, leftLegSki1,
    RightLegSki2, leftLegSki2, RightLegSki3, leftLegSki3);
  TAllMenPos = (MenSki1, MenSki2, MenSki3);

var myNeck, myLegBody: TPointF;

procedure SetCanvas(canvas: TCanvas);
procedure SetSize(size: single);
procedure DrawPerson(rightHand, leftHand: TAllHandPos;
  rightLeg, leftLeg: TAllLegPos; neck, legBody: TPointF; size: single); overload;
procedure DrawSnowflake(SFPosF: TPointF; Length: Integer;
  size, Ratio, OffsetAngle: single);
procedure createArrMenPos(pos1, pos2: TAllMenPos; cadrs: Integer);
procedure prDrawPerson();
procedure DrawPerson(menPos: TAllMenPos); overload;

implementation

uses PointConverter;

type
  T2PointF = Record
    firstPoint: TPointF;
    secondPoint: TPointF;
  End;

  TMenParts = Record
    rightHand: TAllHandPos;
    leftHand: TAllHandPos;
    rightLeg: TAllLegPos;
    leftLeg: TAllLegPos;
  End;

  TMenPosPointF = Record
    rightHand: T2PointF;
    leftHand: T2PointF;
    rightLeg: T2PointF;
    leftLeg: T2PointF;
  end;

  TPointFArr = array of TPointF;
  T2PointFArr = array of T2PointF;
  TMenPosArr = array of TMenPosPointF;

const
  // point have coordinates based on local system of coordinate.
  // Center of local coord system is handBody for hand and legBody point for leg
  allHandPos: array [TAllHandPos] of T2PointF = ((firstPoint: (X: 0.070;
    Y: 0.040); secondPoint: (X: 0.055; Y: - 0.020)), // each line new hand pos
    (firstPoint: (X: - 0.070; Y: 0.040); secondPoint: (X: - 0.055; Y: - 0.020)),
    // LeftHandPos1
    (firstPoint: (X: 0.028; Y: 0.062); secondPoint: (X: 0.065; Y: 0.05)),
    // RightHandSki1
    (firstPoint: (X: - 0.04; Y: 0.055); secondPoint: (X: 0.005; Y: 0.075)),
    // LeftHandSki1
    (firstPoint: (X: 0.018; Y: 0.062); secondPoint: (X: 0.052; Y: 0.035)),
    // RightHandSki2
    (firstPoint: (X: - 0.026; Y: 0.055); secondPoint: (X: 0.012; Y: 0.088)),
    // LeftHandSki2
    (firstPoint: (X: 0.008; Y: 0.062); secondPoint: (X: 0.042; Y: 0.052)),
    // RightHandSki3
    (firstPoint: (X: - 0.015; Y: 0.055); secondPoint: (X: 0.027; Y: 0.075))
    // LeftHandSki3
    );

  allLegPos: array [TAllLegPos] of T2PointF = ((firstPoint: (X: 0.040;
    Y: 0.050); secondPoint: (X: 0.040; Y: 0.100)), // each line new hand pos
    (firstPoint: (X: - 0.040; Y: 0.050); secondPoint: (X: - 0.040; Y: 0.100)),
    (firstPoint: (X: 0.034; Y: 0.06); secondPoint: (X: 0.03; Y: 0.13)),
    // RightLegSki1
    (firstPoint: (X: - 0.02; Y: 0.062); secondPoint: (X: - 0.05; Y: 0.13)),
    // leftLegSki1
    (firstPoint: (X: 0.025; Y: 0.06); secondPoint: (X: 0.013; Y: 0.13)),
    // RightLegSki2
    (firstPoint: (X: - 0.012; Y: 0.062); secondPoint: (X: - 0.023; Y: 0.13)),
    // leftLegSki2
    (firstPoint: (X: 0.008; Y: 0.06); secondPoint: (X: 0.001; Y: 0.13)),
    // RightLegSki3
    (firstPoint: (X: - 0.004; Y: 0.062); secondPoint: (X: - 0.015; Y: 0.13))
    // leftLegSki3
    );

  allMenPos: array [TAllMenPos] of TMenParts =
  ((rightHand: RightHandSki1; leftHand: LeftHandSki1;
  rightLeg: RightLegSki1; leftLeg: leftLegSki1),
  //menSki1
  (rightHand: RightHandSki2; leftHand: LeftHandSki2;
  rightLeg: RightLegSki2; leftLeg: leftLegSki2),
  //menSki2
  (rightHand: RightHandSki3; leftHand: LeftHandSki3;
  rightLeg: RightLegSki3; leftLeg: leftLegSki3)
  //menSki3
  );

  basicColor: TColor = clMaroon;
  basicColor2: TColor = clBlack;
  basicWitdh: single = 1.4;
  basicRightHandPos: TAllHandPos = RightHandPos1;
  SFColor: TColor = clAqua;

var
  myCanvas: TCanvas;
  //RHand, LHand: TAllHandPos;
  //RLeg, LLeg: TAllLegPos;
  mySize: single;
  PrPointF: array of TMenPosPointF;
  cadrNow: integer;

procedure SetCanvas(canvas: TCanvas);
begin
  myCanvas := canvas;
end;

procedure SetSize(size: single);
begin
  mySize := size;
end;

function CalculateAngleVectors(vector1, vector2: TPointF): Double;
begin
  result := ArcCos(vector1.DotProduct(vector2) /
    (vector1.Length * vector2.Length))
end;

// создаёт массив из cadrs элементов для создания анимации включая заданные точки
function createArrPointF(pStart, pEnd: TPointF; cadrs: Integer): TPointFArr;
var
  deltaX, deltaY: single;
begin
  if (cadrs > 1) then
  begin
    setLength(result, cadrs);
    deltaX := (pStart.X - pEnd.X) / (cadrs - 1);
    deltaY := (pStart.Y - pEnd.Y) / (cadrs - 1);
    for var i := 0 to cadrs - 1 do
    begin
      result[i].X := pStart.X - deltaX * i;
      result[i].Y := pStart.Y - deltaY * i;
    end;
  end;
end;

function createArr2PointF(pStart, pEnd: T2PointF; cadrs: Integer): T2PointFArr;
var
  arr1, arr2: TPointFArr;
begin
  arr1 := createArrPointF(pStart.firstPoint, pEnd.firstPoint, cadrs);
  arr2 := createArrPointF(pStart.secondPoint, pEnd.secondPoint, cadrs);
  setLength(result, cadrs);
  for var i := 0 to cadrs - 1 do
  begin
    result[i].firstPoint := arr1[i];
    result[i].secondPoint := arr2[i];
  end;
end;

// хакидываем в PrPointF заготовленные точки для последующей рисовки
procedure createArrMenPos(pos1, pos2: TAllMenPos; cadrs: Integer);
var
  RH, LH, RL, LL: T2PointFArr; // R - right, L - left; H - hand, L - leg
begin
  RH := createArr2PointF(allHandPos[allMenPos[pos1].rightHand],
    allHandPos[allMenPos[pos2].rightHand], cadrs);
  LH := createArr2PointF(allHandPos[allMenPos[pos1].leftHand],
    allHandPos[allMenPos[pos2].leftHand], cadrs);
  RL := createArr2PointF(allLegPos[allMenPos[pos1].rightLeg],
    allLegPos[allMenPos[pos2].rightLeg], cadrs);
  LL := createArr2PointF(allLegPos[allMenPos[pos1].leftLeg],
    allLegPos[allMenPos[pos2].leftLeg], cadrs);

  setLength(PrPointF, cadrs);
  for var i := 0 to cadrs - 1 do
  begin
    PrPointF[i].rightHand := RH[i];
    PrPointF[i].leftHand := LH[i];
    PrPointF[i].rightLeg := RL[i];
    PrPointF[i].leftLeg := LL[i];
  end;
  cadrNow:= 0;
end;

{// подготовка переменных для последующей отрисовки
procedure PrCoord(setRHand, setLHand: TAllHandPos; setRLeg, setLLeg: TAllLegPos;
  setNeck, setLegBody: TPointF);
begin
  RHand := setRHand;
  LHand := setLHand;
  RLeg := setRLeg;
  LLeg := setLLeg;
  myNeck := setNeck;
  myLegBody := setLegBody;
end;}

procedure DrawHandPointF(pos: T2PointF; startPoint: TPointF; size: single);
var
  intP1: TPoint;
  p1: TPointF;
begin
  myCanvas.Pen.Color := basicColor;
  myCanvas.Brush.Color := basicColor;
  myCanvas.Pen.Width := Round(PointConverter.GetPixels * basicWitdh * size);

  intP1 := PointConverter.Convert(startPoint);
  myCanvas.MoveTo(intP1.X, intP1.Y);

  p1.X := startPoint.X + pos.firstPoint.X * size;
  p1.Y := startPoint.Y + pos.firstPoint.Y * size;
  intP1 := PointConverter.Convert(p1);
  myCanvas.LineTo(intP1.X, intP1.Y);

  p1.X := startPoint.X + (pos.secondPoint.X * size);
  p1.Y := startPoint.Y + pos.secondPoint.Y * size;
  intP1 := PointConverter.Convert(p1);
  myCanvas.LineTo(intP1.X, intP1.Y);
end;

procedure DrawHand(pos: TAllHandPos; startPoint: TPointF; size: single);
var
  point: T2PointF;
begin
  point.firstPoint:= AllHandPos[pos].firstPoint;
  point.secondPoint:= AllHandPos[pos].secondPoint;
  DrawHandPointF(point, startPoint, size);
end;

procedure DrawLegPointF(pos: T2PointF; startPoint: TPointF; size: single);
var
  intP1: TPoint;
  p1: TPointF;
begin
  myCanvas.Pen.Color := basicColor;
  myCanvas.Brush.Color := basicColor;
  myCanvas.Pen.Width := Round(PointConverter.GetPixels * basicWitdh * size);

  intP1 := PointConverter.Convert(startPoint);
  myCanvas.MoveTo(intP1.X, intP1.Y);

  p1.X := startPoint.X + pos.firstPoint.X * size;
  p1.Y := startPoint.Y + pos.firstPoint.Y * size;
  intP1 := PointConverter.Convert(p1);
  myCanvas.LineTo(intP1.X, intP1.Y);

  p1.X := startPoint.X + pos.secondPoint.X * size;
  p1.Y := startPoint.Y + pos.secondPoint.Y * size;
  intP1 := PointConverter.Convert(p1);
  myCanvas.LineTo(intP1.X, intP1.Y);
end;

procedure DrawLeg (pos: TAllLegPos; startPoint: TPointF; size: single);
var
  point: T2PointF;
begin
  point.firstPoint:= AllLegPos[pos].firstPoint;
  point.secondPoint:= AllLegPos[pos].secondPoint;
  DrawHandPointF(point, startPoint, size);
end;

procedure DrawHead(neck, legBody: TPointF; size: single);
var
  intP1: TPoint;
  Rect: TRect;
  headRadius: Integer;
  angle: Double;
begin
  myCanvas.Pen.Color := basicColor;
  myCanvas.Brush.Color := basicColor;
  myCanvas.Pen.Width := Round(PointConverter.GetPixels * basicWitdh * size);
  headRadius := Round(PointConverter.GetPixels * 3 * size);
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
  myCanvas.Ellipse(Rect);
end;

procedure DrawBody(neck, legBody: TPointF; size: single);
var
  intP1: TPoint;
begin
  myCanvas.Pen.Color := basicColor;
  myCanvas.Brush.Color := basicColor;
  myCanvas.Pen.Width := Round(PointConverter.GetPixels * basicWitdh * size);

  intP1 := PointConverter.Convert(neck);
  myCanvas.MoveTo(intP1.X, intP1.Y);
  intP1 := PointConverter.Convert(legBody);
  myCanvas.LineTo(intP1.X, intP1.Y);
end;

// from body point create head point and second body point.
// 1 body poin for hands, second for Legs, in function first (hand) point
procedure DrawPerson(rightHand, leftHand: TAllHandPos;
  rightLeg, leftLeg: TAllLegPos; neck, legBody: TPointF; size: single);
  overload;
begin
  DrawHead(neck, legBody, size);     // o
  DrawHand(rightHand, neck, size); // \/|\/
  DrawHand(leftHand, neck, size);   // /\
  DrawBody(neck, legBody, size);   // |  \
  DrawLeg(rightLeg, legBody, size);
  DrawLeg(leftLeg, legBody, size);
end;

procedure DrawPerson(menPos: TAllMenPos); overload;
begin
  DrawHead(myNeck, myLegBody, mySize);
  DrawHand(allMenPos[menPos].rightHand, myNeck, mySize);
  DrawHand(allMenPos[menPos].leftHand, myNeck, mySize);
  DrawBody(myNeck, myLegBody, mySize);
  DrawLeg(allMenPos[menPos].rightLeg, myLegBody, mySize);
  DrawLeg(allMenPos[menPos].leftLeg, myLegBody, mySize);
end;

// рисование по заготовленным данным
procedure prDrawPerson();
begin
  DrawHead(myNeck, myLegBody, mySize);
  DrawHandPointF(PrPointF[cadrNow].rightHand, myNeck, mySize);
  DrawHandPointF(PrPointF[cadrNow].leftHand, myNeck, mySize);
  DrawBody(myNeck, myLegBody, mySize);
  DrawLegPointF(PrPointF[cadrNow].rightLeg, myLegBody, mySize);
  DrawLegPointF(PrPointF[cadrNow].leftLeg, myLegBody, mySize);
  inc(cadrNow);
end;

procedure DrawSnowflake(SFPosF: TPointF; Length: Integer;
  size, Ratio, OffsetAngle: single);
// SFPosF - координаты снежинки
// length - длина любой из 6 полосок в пикселях
// Size - ширина линий
// Ratio - коэффициент должен быть от 0 до 1, от него зависит
// на сколько далеко будут маленькие ответвления
// OffsetAngle - задаешь угол в градусах и снежинка поворачивается
var
  i: Integer;
  angle: array [0 .. 5] of Double;
  EndPoints, BranchPoints: array [0 .. 5] of TPoint;
  Offset: Integer;
  SFPos: TPoint;
begin
  myCanvas.Pen.Color := SFColor;
  myCanvas.Brush.Color := SFColor;
  myCanvas.Pen.Width := Round(PointConverter.GetPixels * 0.1 * size);

  Length := Round(PointConverter.GetPixels * 0.1 * Length);

  SFPos := PointConverter.Convert(SFPosF);

  Offset := Round(Length * Ratio); // Длина и отдаленность маленьких веточек

  // Нужные для лучей точки
  for i := 0 to 5 do
  begin
    angle[i] := i * 60 * Pi / 180 + OffsetAngle * Pi / 180;
    EndPoints[i].X := SFPos.X + Round(cos(angle[i]) * Length);
    EndPoints[i].Y := SFPos.Y + Round(sin(angle[i]) * Length);

    BranchPoints[i].X := SFPos.X + Round(cos(angle[i]) * (Length - Offset));
    BranchPoints[i].Y := SFPos.Y + Round(sin(angle[i]) * (Length - Offset));
  end;

  for i := 0 to 5 do
  begin
    // 6 Лучей
    myCanvas.MoveTo(SFPos.X, SFPos.Y);
    myCanvas.LineTo(EndPoints[i].X, EndPoints[i].Y);

    // Маленькие ответвления
    myCanvas.MoveTo(BranchPoints[i].X, BranchPoints[i].Y);
    myCanvas.LineTo(BranchPoints[i].X + Round(cos(angle[i] + Pi / 6) * Offset),
      BranchPoints[i].Y + Round(sin(angle[i] + Pi / 6) * Offset));

    myCanvas.MoveTo(BranchPoints[i].X, BranchPoints[i].Y);
    myCanvas.LineTo(BranchPoints[i].X + Round(cos(angle[i] - Pi / 6) * Offset),
      BranchPoints[i].Y + Round(sin(angle[i] - Pi / 6) * Offset));
  end;
end;

end.
