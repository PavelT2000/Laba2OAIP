unit drawSomeThing;

interface

uses Winapi.Windows, Vcl.Graphics, System.Types, PointConverter;

type
  //R - right hand, L - left hand
  //H - hand, LG - leg
  TAllHandPos = (RightHandPos1, LeftHandPos1);
  TAllLegPos = (RightLegPos1, LeftLegPos1);

procedure DrawPerson(Canvas: TCanvas; rightHand, leftHand: TAllHandPos;
rightLeg, leftLeg: TAllLegPos; handBody: TPoint; size: single);
procedure DrawHand(Canvas: TCanvas; pos: TAllHandPos; startPoint: TPoint; size: single); overload;

implementation

type
  T2Points = Record
    firstPoint: TPoint;
    secondPoint: TPoint;
  End;

const
  //point have coordinates based on local system of coordinate.
  //Center of local coord system is handBody for hand and legBody point for leg
  allHandPos: array[TAllhandPos] of T2Points = (
  (firstPoint: (X: 70; Y: 40); secondPoint: (X: 55; Y: -20)),    //each line new hand pos
  (firstPoint: (X: -70; Y: 40); secondPoint: (X: -55; Y: -20))   //LeftHandPos1
  );

  allLegPos: array[TAllLegPos] of T2Points = (
  (firstPoint: (X: 40; Y: 50); secondPoint: (X: 40; Y: 100)),      //each line new hand pos
  (firstPoint: (X: -40; Y: 50); secondPoint: (X: -40; Y: 100))
  );

  basicPenWidth: integer = 17;
  basicColor: TColor = clMaroon;

{procedure DrawHand(Canvas: TCanvas; start, elbow, hand: TPoint); overload;
begin
  Canvas.Pen.Color:= basicColor;
  Canvas.Brush.Color:= clRed;

  Canvas.Ellipse(start.X, start.Y, (start.X + elbow.X), (elbow.Y + start.Y));

  Canvas.Ellipse((start.X + elbow.X), (elbow.Y + start.Y),
  (hand.X  + start.X), (hand.Y  + start.Y));
end;}

procedure DrawHand(Canvas: TCanvas; pos: TAllHandPos; startPoint: TPoint; size: single); overload;
var x, y: integer;
p1, p2, p3, p4: TPoint;
begin
  Canvas.Pen.Color:= basicColor;
  Canvas.Brush.Color:= basicColor;
  Canvas.Pen.Width := Round(basicPenWidth / size);
  Canvas.MoveTo(startPoint.X, startPoint.Y);

  x:= startPoint.X + Round(AllHandPos[pos].firstPoint.X /size);
  y:= startPoint.Y + Round(AllHandPos[pos].firstPoint.Y /size);

  Canvas.LineTo(x, y);

  x:= startPoint.X + Round(AllHandPos[pos].secondPoint.X /size);
  y:= startPoint.Y + Round(AllHandPos[pos].secondPoint.Y /size);
  Canvas.LineTo(x, y);
end;

procedure DrawLeg(Canvas: TCanvas; pos: TAllLegPos; startPoint: TPoint; size: single); overload;
var x, y: integer;
begin

  Canvas.Pen.Color:= basicColor;
  Canvas.Pen.Width := Round(basicPenWidth / size);
  Canvas.MoveTo(startPoint.X, startPoint.Y);

  x:= startPoint.X + Round(AllLegPos[pos].firstPoint.X /size);
  y:= startPoint.Y + Round(AllLegPos[pos].firstPoint.Y /size);
  Canvas.LineTo(x, y);

  x:= startPoint.X + Round(AllLegPos[pos].secondPoint.X /size);
  y:= startPoint.Y + Round(AllLegPos[pos].secondPoint.Y /size);
  Canvas.LineTo(x, y);
end;

//from body point create head point and second body point.
//1 body poin for hands, second for Legs, in function first (hand) point
procedure DrawPerson(Canvas: TCanvas; rightHand, leftHand: TAllHandPos;
rightLeg, leftLeg: TAllLegPos; handBody: TPoint; size: single);
var legBody, head: TPoint;
    headRadius, bodyHeight, x, y: integer;
{
   o
 \/|\/
  /\
 |  \
}
begin
  //head
  headRadius:= Round(27 / size);
  bodyHeight:= Round(90/ size);
  //handBody.X:= Round(handBody.X / size);
  //handBody.Y:= Round(handBody.Y / size);

  Canvas.Pen.Color:= basicColor;
  Canvas.Brush.Color:= basicColor;
  Canvas.Ellipse((handBody.X + headRadius), (handBody.Y),
  (handBody.X - headRadius), (handBody.Y - 2*headRadius));

  DrawHand(Canvas, rightHand, handBody, size);
  DrawHand(Canvas, leftHand, handBody, size);

  Canvas.Pen.Color:= basicColor;
  Canvas.Brush.Color:= basicColor;
  Canvas.Pen.Width := Round((basicPenWidth+5) / size);
  Canvas.MoveTo(handBody.X, handBody.Y);
  legBody.X:= handBody.X;
  legBody.Y:= handBody.Y + bodyHeight;
  Canvas.LineTo(legBody.X, legBody.Y);


  DrawLeg(Canvas, rightLeg, legBody, size);
  DrawLeg(Canvas, LeftLeg, legBody, size);
end;

end.
