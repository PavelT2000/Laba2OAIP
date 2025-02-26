unit drawSomeThing;

interface

uses Winapi.Windows, Vcl.Graphics, System.Types;

type
  //R - right hand, L - left hand
  //H - hand, LG - leg
  TAllHandPos = (RightHandPos1, LeftHandPos1);
  TAllLegPos = (RightLegPos1, LeftLegPos1);

procedure DrawPerson(Canvas: TCanvas; rightHand, leftHand: TAllHandPos;
rightLeg, leftLeg: TAllLegPos; handBody: TPoint);
procedure DrawHand(Canvas: TCanvas; pos: TAllHandPos; startPoint: TPoint); overload;
procedure DrawHand(Canvas: TCanvas; start, elbow, hand: TPoint); overload;

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
  (firstPoint: (X: 40; Y: 40); secondPoint: (X: 40; Y: 80)),      //each line new hand pos
  (firstPoint: (X: -40; Y: 40); secondPoint: (X: -40; Y: 80))
  );

  basicPenWidth: integer = 17;
  basicColor: TColor = clMaroon;

procedure DrawHand(Canvas: TCanvas; start, elbow, hand: TPoint); overload;
begin
  Canvas.Pen.Color:= basicColor;
  Canvas.Brush.Color:= clRed;

  Canvas.Ellipse(start.X, start.Y, (start.X + elbow.X), (elbow.Y + start.Y));

  Canvas.Ellipse((start.X + elbow.X), (elbow.Y + start.Y),
  (hand.X  + start.X), (hand.Y  + start.Y));
end;

procedure DrawHand(Canvas: TCanvas; pos: TAllHandPos; startPoint: TPoint); overload;
var x, y: integer;
begin
  Canvas.Pen.Color:= basicColor;
  Canvas.Brush.Color:= basicColor;
  Canvas.Pen.Width := basicPenWidth;
  Canvas.MoveTo(startPoint.X, startPoint.Y);

  x:= startPoint.X + AllHandPos[pos].firstPoint.X;
  y:= startPoint.Y + AllHandPos[pos].firstPoint.Y;
  Canvas.LineTo(x, y);

  x:= startPoint.X + AllHandPos[pos].secondPoint.X;
  y:= startPoint.Y + AllHandPos[pos].secondPoint.Y;
  Canvas.LineTo(x, y);
end;

procedure DrawLeg(Canvas: TCanvas; pos: TAllLegPos; startPoint: TPoint); overload;
var x, y: integer;
begin
  Canvas.Pen.Color:= basicColor;
  Canvas.Pen.Width := basicPenWidth;
  Canvas.MoveTo(startPoint.X, startPoint.Y);

  x:= startPoint.X + AllLegPos[pos].firstPoint.X;
  y:= startPoint.Y + AllLegPos[pos].firstPoint.Y;
  Canvas.LineTo(x, y);

  x:= startPoint.X + AllLegPos[pos].secondPoint.X;
  y:= startPoint.Y + AllLegPos[pos].secondPoint.Y;
  Canvas.LineTo(x, y);
end;

//from body point create head point and second body point.
//1 body poin for hands, second for Legs, in function first (hand) point
procedure DrawPerson(Canvas: TCanvas; rightHand, leftHand: TAllHandPos;
rightLeg, leftLeg: TAllLegPos; handBody: TPoint);
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
  headRadius:= 27;
  bodyHeight:= 90;

  Canvas.Pen.Color:= basicColor;
  Canvas.Brush.Color:= basicColor;
  Canvas.Ellipse((handBody.X + headRadius), (handBody.Y),
  (handBody.X - headRadius), (handBody.Y - 2*headRadius));

  DrawHand(Canvas, rightHand, handBody);
  DrawHand(Canvas, leftHand, handBody);

  Canvas.Pen.Color:= basicColor;
  Canvas.Brush.Color:= basicColor;
  Canvas.Pen.Width := basicPenWidth+5;
  Canvas.MoveTo(handBody.X, handBody.Y);
  legBody.X:= handBody.X;
  legBody.Y:= handBody.Y + bodyHeight;
  Canvas.LineTo(legBody.X, legBody.Y);


  DrawLeg(Canvas, rightLeg, legBody);
  DrawLeg(Canvas, LeftLeg, legBody);
end;

end.
