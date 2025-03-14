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

function AddPos(point, pos: TPointF): TPointF;
begin
  result.X:= point.x + pos.x;
  result.y:= point.y + pos.y;
end;

procedure DrawLocation(pos: TPointF);
var
  p1, p2, p3, p4: TPoint;
begin
  myCanvas.Pen.Width:= Round(PointConverter.GetPixels()/3.2);
  myCanvas.Pen.Color:=clBlack;

  //p1 := Convert(PointF(0+pos.x, 0.55+pos.y));
  //myCanvas.MoveTo(p1.X, p1.Y);
  p1 := Convert(PointF(0.2+pos.x, 0.55+pos.y));
  myCanvas.MoveTo(p1.X, p1.Y);
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
    p3, p4, p5, p6, p7, p8, p9, p10 :TPoint;
    high, width: single;
    rect: TRect;
    //colorArr: array[0..1] of TColor;
    num: integer;
    color1, color2, color3: Tcolor;
begin
  myCanvas.Pen.Width:= Round(PointConverter.GetPixels()/3.2);
  myCanvas.Pen.Color:=clBlack;
  //pos:= pos - PointF(0.2, 0);
  high:= 0.07;
  width:= 0.114;
  p1.y:= 0.55;
  color1:= RGB(220, 20, 60);
  color2:= RGB(0, 206, 209);

  while (p1.y <= 1) do begin
    p1.x:= -0.007;
    p2.y:= p1.y+ high;
    While (p1.x <= 1.2) do begin
      myCanvas.Brush.Color:= color1;
      p2.x:= p1.x + width;
      rect:= ConvertRect(AddPosRect(RectF(p1.X, p1.Y, p2.x, p2.y), pos));
      myCanvas.Rectangle(rect);
      p1.x:= p1.x + width;

      myCanvas.Brush.Color:= color2;
      p2.x:= p1.x + width;
      rect:= ConvertRect(AddPosRect(RectF(p1.X, p1.Y, p2.x, p2.y), pos));
      myCanvas.Rectangle(rect);
      p1.x:= p1.x + width;
    end;
    p1.y:= p1.y + high;

    p1.x:= -0.007;
    p2.y:= p1.y+ high;
    While (p1.x <= 1.2) do begin
      myCanvas.Brush.Color:= color2;
      p2.x:= p1.x + width;
      rect:= ConvertRect((AddPosRect(RectF(p1.X, p1.Y, p2.x, p2.y), pos)));
      myCanvas.Rectangle(rect);
      p1.x:= p1.x + width;

      myCanvas.Brush.Color:= color1;
      p2.x:= p1.x + width;
      rect:= ConvertRect((AddPosRect(RectF(p1.X, p1.Y, p2.x, p2.y), pos)));
      myCanvas.Rectangle(rect);
      p1.x:= p1.x + width;
    end;
    p1.y:= p1.y + high;
  end;

  //top
  p3:= Convert(AddPos(PointF(0, 0.1), pos));
  myCanvas.MoveTo(p3.X, p3.Y);
  p3:= Convert(AddPos(PointF(1, 0.1), pos));
  myCanvas.LineTo(p3.X, p3.Y);

  //top
  color3:= RGB(188, 143, 143);
  myCanvas.Brush.Color:= color3;
  p1 := PointF(-0.01, 0.1);
  p2 := PointF(0.32, 0.55);
  rect:= ConvertRect((AddPosRect(RectF(p1.X, p1.Y, p2.x, p2.y), pos)));
  myCanvas.Rectangle(rect);

  p1 := PointF(0.48, 0.1);
  p2 := PointF(1.36, 0.55);
  rect:= ConvertRect((AddPosRect(RectF(p1.X, p1.Y, p2.x, p2.y), pos)));
  myCanvas.Rectangle(rect);
  //closet
  p3:= Convert(AddPos(PointF(0.32, 0.1), pos));
  myCanvas.MoveTo(p3.X, p3.Y);
  p3:= Convert(AddPos(PointF(0.32, 0.55), pos));
  myCanvas.LineTo(p3.X, p3.Y);

  p3:= Convert(AddPos(PointF(0.48, 0.1), pos));
  myCanvas.MoveTo(p3.X, p3.Y);
  p3:= Convert(AddPos(PointF(0.48, 0.55), pos));
  myCanvas.LineTo(p3.X, p3.Y);
  //door
  p3:= Convert(PointF(0.48, 0.1)+pos);
  //myCanvas.MoveTo(p3.X, p3.Y);
  p4:= Convert(PointF(0.58, 0.15)+pos);
  //myCanvas.LineTo(p3.X, p3.Y);
  p5:= Convert(PointF(0.58, 0.6)+pos);
  //myCanvas.LineTo(p3.X, p3.Y);
  p6:= Convert(PointF(0.48, 0.55)+pos);
  //myCanvas.LineTo(p3.X, p3.Y);

  myCanvas.Brush.Color:= RGB(252, 119, 3);
  myCanvas.Polygon([p3, p4, p5, p6]);
  //window
  p3:= Convert(PointF(0.51, 0.22)+pos);
  //myCanvas.MoveTo(p3.X, p3.Y);
  p4:= Convert(PointF(0.55, 0.25)+pos);
  //myCanvas.LineTo(p3.X, p3.Y);
  p5:= Convert(PointF(0.55, 0.35)+pos);
  //myCanvas.LineTo(p3.X, p3.Y);
  p6:= Convert(PointF(0.51, 0.32)+pos);
  //myCanvas.LineTo(p3.X, p3.Y);
  //p3:= Convert(PointF(0.51, 0.22)+pos);
  //myCanvas.LineTo(p3.X, p3.Y);

  myCanvas.Brush.Color:= color3;
  myCanvas.Polygon([p3, p4, p5, p6]);

  pos:= pos + PointF(1.16, 0.05);

  //точки для полегонов, верх лево, верх право, низ право, низ лево

  myCanvas.Brush.Color:= RGB(95, 158, 160);
  {p3 := Convert(PointF(0.2, 0.55)+pos);
  p4 := Convert(PointF(0.6, 1.05)+pos);
  p5 := Convert(PointF(0.54, 0.93+0.4)+pos);
  p6 := Convert(PointF(0.2, 0.55+0.4)+pos);
  myCanvas.Polygon([p3, p4, p5, p6]);

  p3 := p4;
  p6 := p5;
  p4 := Convert(PointF(1, 0.9)+pos);
  p5 := Convert(PointF(0.91, 0.81+0.4)+pos);
  myCanvas.Polygon([p3, p4, p5, p6]);}

  p3 := Convert(PointF(0.2, 0.55)+pos);
  p4 := Convert(PointF(0.6, 1.05)+pos);
  p5 := Convert(PointF(1, 0.9)+pos);
  p6 := Convert(PointF(0.91, 0.81+0.4)+pos);
  p7 := Convert(PointF(0.54, 0.93+0.4)+pos);
  p8 := Convert(PointF(0.2, 0.55+0.4)+pos);

  myCanvas.Polygon([p3, p4, p5, p6, p7, p8]);

  p3 := p5;
  p6 := p6;
  p4 := Convert(PointF(0.82, 1.63)+pos);
  p5 := Convert(PointF(0.75, 1.4+0.4)+pos);
  myCanvas.Polygon([p3, p4, p5, p6]);

  p3 := p4;
  p6 := p5;
  p4 := Convert(PointF(2, 2.1)+pos);
  p5 := Convert(PointF(1.95, 1.95+0.4)+pos);
  myCanvas.Polygon([p3, p4, p5, p6]);

  p3 := p4;
  p6 := p5;
  p4 := Convert(PointF(3.4, 2.1)+pos);
  p5 := Convert(PointF(3.35, 1.95+0.4)+pos);
  myCanvas.Polygon([p3, p4, p5, p6]);

  //black side
  myCanvas.Brush.Color:= RGB(192, 192, 192);
  p3 := Convert(PointF(0.2, 0.55+0.4)+pos);
  p4 := Convert(PointF(0.54, 0.93+0.4)+pos);
  p5 := Convert(PointF(0.91, 0.81+0.4)+pos);
  p6 := Convert(PointF(0.75, 1.4+0.4)+pos);
  p7 := Convert(PointF(1.95, 1.95+0.4)+pos);
  p8 := Convert(PointF(0-1.16, 1.95+0.4)+pos);
  p9 := Convert(PointF(0-1.16, 0.99)+pos);
  p10 := Convert(PointF(0.2, 0.99)+pos);
  myCanvas.Polygon([p3, p4, p5, p6, p7, p8, p9, p10]);

end;

end.
