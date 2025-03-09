unit Location;

interface

uses Winapi.Windows, Vcl.Graphics, System.Types, PointConverter;
procedure DrawLocation(pos: TPointF);
procedure DrawLocation2(pos: TPointF);
Procedure DrawLocation3(pos: TPointF);
procedure SetCanvas(Canvas: TCanvas);

implementation

var
    myCanvas: TCanvas;

procedure SetCanvas(Canvas: TCanvas);
begin
  myCanvas:= canvas;
end;

procedure DrawLocation(pos: TPointF);
var
  p1, p2, p3, p4: TPoint;
begin
  myCanvas.Pen.Width:= PointConverter.GetPixels();
  myCanvas.Pen.Color:=clBlack;

  p1 := Convert(PointF(0+pos.x, 0.55+pos.y));
  myCanvas.MoveTo(p1.X, p1.Y);
  p1 := Convert(PointF(0.2+pos.x, 0.55+pos.y));
  myCanvas.LineTo(p1.X, p1.Y);
  p1 := Convert(PointF(0.6+pos.x, 1.05+pos.y));
  myCanvas.LineTo(p1.X, p1.Y);
  p1 := Convert(PointF(1+pos.x, 0.9+pos.y));
  myCanvas.LineTo(p1.X, p1.Y);
  p1 := Convert(PointF(1+pos.x, 1.4+pos.y));
  myCanvas.LineTo(p1.X, p1.Y);
  p1 := Convert(PointF(2+pos.x, 2+pos.y));
  myCanvas.LineTo(p1.X, p1.Y);

end;
procedure DrawLocation2(pos: TPointF);
var
  p1, p2, p3, p4: TPoint;
  Rect:TRect;
begin
  myCanvas.Pen.Width:= PointConverter.GetPixels();
  myCanvas.Pen.Color:=clBlack;
  myCanvas.Brush.Color:=RGB(200,200,200);
  rect:=ConvertRect(RectF(0.25+pos.x,0+pos.y,0.75+pos.x,0.4+pos.y));
  myCanvas.FillRect(rect);
  myCanvas.Brush.Color:=RGB(160,160,160);
  rect:=ConvertRect(RectF(0.25+pos.x,0.4+pos.y,0.75+pos.x,1.5+pos.y));
  myCanvas.FillRect(rect);
  myCanvas.Brush.Color:=RGB(100,100,100);
  rect:=ConvertRect(RectF(0.25+pos.x,1.5+pos.y,0.75+pos.x,1.7+pos.y));
  myCanvas.FillRect(rect);
  myCanvas.Brush.Color:=RGB(160,160,160);
  rect:=ConvertRect(RectF(0.25+pos.x,1.7+pos.y,0.75+pos.x,3+pos.y));
  myCanvas.FillRect(rect);
end;

Procedure DrawLocation3(pos: TPointF);
var
    p1, p2: TPointF;
    high, width: single;
    rect: TRect;
    //colorArr: array[0..1] of TColor;
    num: integer;
    color1, color2: Tcolor;
begin
  myCanvas.Pen.Width:= Round(PointConverter.GetPixels()/3.2);
  myCanvas.Pen.Color:=clBlack;
  //colorArr[0]:= clSilver;
  //colorArr[1]:= clFuchsia;
  high:= 0.07;
  width:= 0.114;
  p1.y:= 0.55;
  color1:= RGB(220, 20, 60);
  color2:= RGB(0, 206, 209);

  while (p1.y <= 1) do begin
    p1.x:= -0.007;
    p2.y:= p1.y+ high;
    While (p1.x <= 1) do begin
      myCanvas.Brush.Color:= color1;
      p2.x:= p1.x + width;
      rect:= ConvertRect(RectF(p1.X, p1.Y, p2.x, p2.y));
      myCanvas.Rectangle(rect);
      p1.x:= p1.x + width;

      myCanvas.Brush.Color:= color2;
      p2.x:= p1.x + width;
      rect:= ConvertRect(RectF(p1.X, p1.Y, p2.x, p2.y));
      myCanvas.Rectangle(rect);
      p1.x:= p1.x + width;
    end;
    p1.y:= p1.y + high;

    p1.x:= -0.007;
    p2.y:= p1.y+ high;
    While (p1.x <= 1) do begin
      myCanvas.Brush.Color:= color2;
      p2.x:= p1.x + width;
      rect:= ConvertRect(RectF(p1.X, p1.Y, p2.x, p2.y));
      myCanvas.Rectangle(rect);
      p1.x:= p1.x + width;

      myCanvas.Brush.Color:= color1;
      p2.x:= p1.x + width;
      rect:= ConvertRect(RectF(p1.X, p1.Y, p2.x, p2.y));
      myCanvas.Rectangle(rect);
      p1.x:= p1.x + width;
    end;
    p1.y:= p1.y + high;
  end;

end;

end.
