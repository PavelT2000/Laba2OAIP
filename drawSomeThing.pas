unit drawSomeThing;
//DrowSomething
interface

uses Winapi.Windows, Vcl.Graphics, System.Types, Vcl.Dialogs, System.SysUtils,
  System.Math;

type
  TAllMenPos = (MenSki1, MenSki2, MenSki3, menSki4);

  MainCadr = record
    PrCadr: TAllMenPos; //кадр с которого начать, следующий элемент на котором закончить
    numCadrs: integer;  //количество кадров сколько надо создать и отрисовать
  end;
  TArrMainCadr = array of MainCadr;

var myNeck, myLegBody: TPointF;
    allCadrs: integer;
    ArrMainCadrs1: TArrMainCadr;

procedure createCadrArr();
procedure MakeAllCadrs(const ArrCadr: TArrMainCadr);
procedure SetCanvas(canvas: TCanvas);
procedure SetSize(size: single);
procedure createArrMenPos(pos1, pos2: TAllMenPos; cadrs, firstFreePos: Integer);
procedure prDrawPerson();
procedure DrawPerson(menPos: TAllMenPos); overload;

procedure DrawSnowflake(SFPosF: TPointF; Length: Integer;
  size, Ratio, OffsetAngle: single);

implementation

uses PointConverter;

type
  T2PointF = Record
    firstPoint: TPointF;
    secondPoint: TPointF;
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
  allMenPos: array [TAllMenPos] of TMenPosPointF =(
  (rightHand: (firstPoint: (X: 0.028; Y: 0.062); secondPoint: (X: 0.065; Y: 0.05));
  leftHand: (firstPoint: (X: - 0.04; Y: 0.055); secondPoint: (X: 0.005; Y: 0.075));
  rightLeg: (firstPoint: (X: 0.034; Y: 0.06); secondPoint: (X: 0.03; Y: 0.13));
  leftLeg: (firstPoint: (X: - 0.02; Y: 0.062); secondPoint: (X: - 0.05; Y: 0.13))),
  //menSki1
  (rightHand: (firstPoint: (X: 0.018; Y: 0.062); secondPoint: (X: 0.052; Y: 0.035));
  leftHand: (firstPoint: (X: - 0.026; Y: 0.055); secondPoint: (X: 0.012; Y: 0.088));
  rightLeg: (firstPoint: (X: 0.025; Y: 0.06); secondPoint: (X: 0.013; Y: 0.13));
  leftLeg: (firstPoint: (X: - 0.012; Y: 0.062); secondPoint: (X: - 0.023; Y: 0.13))),
  //menSki2
  (rightHand: (firstPoint: (X: 0.008; Y: 0.062); secondPoint: (X: 0.042; Y: 0.052));
  leftHand: (firstPoint: (X: - 0.015; Y: 0.055); secondPoint: (X: 0.027; Y: 0.075));
  rightLeg: (firstPoint: (X: 0.008; Y: 0.06); secondPoint: (X: 0.001; Y: 0.13));
  leftLeg: (firstPoint: (X: - 0.004; Y: 0.062); secondPoint: (X: - 0.015; Y: 0.13))),
  //menSki3
  (rightHand: (firstPoint: (X: - 0.015; Y: 0.055); secondPoint: (X: 0.027; Y: 0.075));
  leftHand: (firstPoint: (X: 0.008; Y: 0.062); secondPoint: (X: 0.042; Y: 0.052));
  rightLeg: (firstPoint: (X: - 0.004; Y: 0.062); secondPoint: (X: - 0.015; Y: 0.13));
  leftLeg:  (firstPoint: (X: 0.008; Y: 0.06); secondPoint: (X: 0.001; Y: 0.13)))
  //menSki4
  );

  basicColor: TColor = clMaroon;
  basicColor2: TColor = clBlack;
  basicWitdh: single = 1.4;
  SFColor: TColor = clAqua;

var
  myCanvas: TCanvas;
  mySize: single;
  PrPointF: array of TMenPosPointF;

procedure createCadrArr();
//DrowSomething/CreateCadrArray
begin
  setLength(ArrMainCadrs1, 4);
  ArrMainCadrs1[0].PrCadr:= MenSki1; ArrMainCadrs1[0].numCadrs:= 16;
  ArrMainCadrs1[1].PrCadr:= MenSki2; ArrMainCadrs1[1].numCadrs:= 16;
  ArrMainCadrs1[2].PrCadr:= MenSki3; ArrMainCadrs1[2].numCadrs:= 16;
  ArrMainCadrs1[3].PrCadr:= MenSki4; ArrMainCadrs1[3].numCadrs:= 16;
end;

procedure MakeAllCadrs(const ArrCadr: TArrMainCadr);
//DrowSomething/MakeAllCadrs
var
    sumNumCadrs, firstFreePos: integer;
begin
  sumNumCadrs:= 0;
  for var i := 0 to length(ArrCadr)-2 do begin
    inc(sumNumCadrs, ArrCadr[i].numCadrs);
  end;
  setLength(PrPointF, sumNumCadrs);

  firstFreePos:= 0;
  for var i := 0 to length(ArrCadr)-2 do begin
    createArrMenPos(ArrCadr[i].PrCadr, ArrCadr[i+1].PrCadr,
    ArrCadr[i].numCadrs, firstFreePos);
    inc(firstFreePos, ArrCadr[i].numCadrs);
  end;
  allCadrs:= 0;
end;

procedure SetCanvas(canvas: TCanvas);
//DrowSomething/SetCanvas
begin
  myCanvas := canvas;
end;

procedure SetSize(size: single);
//DrowSomething/SetSize
begin
  mySize := size;
end;

function CalculateAngleVectors(vector1, vector2: TPointF): Double;
//DrowSomething/CalculateAngleVectors
begin
  result := ArcCos(vector1.DotProduct(vector2) /
    (vector1.Length * vector2.Length))
end;

// создаёт массив из cadrs элементов для создания анимации включая заданные точки
//первый кадр не отрисовывается
function createArrPointF(pStart, pEnd: TPointF; cadrs: Integer): TPointFArr;
//DrowSomething/createArrPointF
var
  deltaX, deltaY: single;
begin
  if (cadrs > 1) then
  begin
    setLength(result, cadrs);
    deltaX := (pStart.X - pEnd.X) / (cadrs);
    deltaY := (pStart.Y - pEnd.Y) / (cadrs);
    for var i := 0 to cadrs-1 do
    begin
      result[i].X := pStart.X - deltaX * i;
      result[i].Y := pStart.Y - deltaY * i;
    end;
  end;
end;

function createArr2PointF(pStart, pEnd: T2PointF; cadrs: Integer): T2PointFArr;
//DrowSomething/createArr2PointF
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
procedure createArrMenPos(pos1, pos2: TAllMenPos; cadrs, firstFreePos: Integer);
//DrowSomething/createArrMenPos
var
  RH, LH, RL, LL: T2PointFArr; // R - right, L - left; H - hand, L - leg
begin
  RH := createArr2PointF(allMenPos[pos1].rightHand,
    allMenPos[pos2].rightHand, cadrs);
  LH := createArr2PointF(allMenPos[pos1].leftHand,
    allMenPos[pos2].leftHand, cadrs);
  RL := createArr2PointF(allMenPos[pos1].rightLeg,
    allMenPos[pos2].rightLeg, cadrs);
  LL := createArr2PointF(allMenPos[pos1].leftLeg,
    allMenPos[pos2].leftLeg, cadrs);

  for var i := 0 to cadrs - 1 do
  begin
    PrPointF[firstFreePos+i].rightHand := RH[i];
    PrPointF[firstFreePos+i].leftHand := LH[i];
    PrPointF[firstFreePos+i].rightLeg := RL[i];
    PrPointF[firstFreePos+i].leftLeg := LL[i];
  end;
end;

procedure DrawHandPointF(pos: T2PointF; startPoint: TPointF; size: single);
//DrowSomething/DrawHandPointF
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

procedure DrawLegPointF(pos: T2PointF; startPoint: TPointF; size: single);
//DrowSomething/DrawLegPointF
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

procedure DrawHead(neck, legBody: TPointF; size: single);
//DrowSomething/DrawHead
var
  intP1: TPoint;
  Rect: TRect;
  headRadius: Integer;
  angle: Double;
begin
  myCanvas.Pen.Color := basicColor;
  myCanvas.Brush.Color := basicColor;
  myCanvas.Pen.Width := Round(PointConverter.GetPixels * basicWitdh * size);
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
  myCanvas.Ellipse(Rect);
end;

procedure DrawBody(neck, legBody: TPointF; size: single);
//DrowSomething/DrawBody
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
procedure DrawPerson(menPos: TAllMenPos); overload;
//DrowSomething/DrawPerson
begin
  DrawHead(myNeck, myLegBody, mySize);
  DrawHandPointF(allMenPos[menPos].rightHand, myNeck, mySize);
  DrawHandPointF(allMenPos[menPos].leftHand, myNeck, mySize);
  DrawBody(myNeck, myLegBody, mySize);
  DrawLegPointF(allMenPos[menPos].rightLeg, myLegBody, mySize);
  DrawLegPointF(allMenPos[menPos].leftLeg, myLegBody, mySize);
end;

// рисование по заготовленным данным
procedure prDrawPerson();
//DrowSomething/prDrawPerson
begin
  if (allCadrs < length(PrPointF)) then
  begin
    DrawHead(myNeck, myLegBody, mySize);
    DrawHandPointF(PrPointF[allCadrs].rightHand, myNeck, mySize);
    DrawHandPointF(PrPointF[allCadrs].leftHand, myNeck, mySize);
    DrawBody(myNeck, myLegBody, mySize);
    DrawLegPointF(PrPointF[allCadrs].rightLeg, myLegBody, mySize);
    DrawLegPointF(PrPointF[allCadrs].leftLeg, myLegBody, mySize);
  end;
end;

procedure DrawSnowflake(SFPosF: TPointF; Length: Integer;
  size, Ratio, OffsetAngle: single);
//DrowSomething/DrawSnowflake


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
