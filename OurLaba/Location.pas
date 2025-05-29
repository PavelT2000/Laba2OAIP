﻿unit Location;

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
    p3, p4, p5, p6, p7, p8, p9, p10, p11 :TPoint;
    high, width: single;
    rect: TRect;
    //colorArr: array[0..1] of TColor;
    num: integer;
    color1, color2, color3: Tcolor;
    Loc2Off: single;

    // Location2
    polyPoints: array of TPoint;
    maxX: Single; // Максимальная X-координата в исходном коде
    maxY: Single;  // Максимальная Y-координата в исходном коде
    Offset: Single;
    xHouses: Single;
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

  p1 := PointF(-0.01, 0.03);
  p2 := PointF(1.36, 0.101);
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

  //void bg
  myCanvas.Brush.Color:= RGB(173, 216, 230);
  p1 := PointF(0.32, 0.1);
  p2 := PointF(0.48, 0.55);
  rect:= ConvertRect((AddPosRect(RectF(p1.X, p1.Y, p2.x, p2.y), pos)));
  myCanvas.Rectangle(rect);

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

  pos:= pos + PointF(1.16+0.8, 0.05);

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

  p3 := Convert(PointF(0.2-0.8, 0.55)+pos);
  p4 := Convert(PointF(0.2, 0.55)+pos);
  p7 := Convert(PointF(0.2, 0.55+0.4)+pos);
  p8 := Convert(PointF(-0.6, 0.55+0.4)+pos);

  myCanvas.Polygon([p3, p4, p7, p8]);

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
  p11:= Convert(PointF(0.2-0.8, 0.55+0.4)+pos);
  p3 := Convert(PointF(0.2, 0.55+0.4)+pos);
  p4 := Convert(PointF(0.54, 0.93+0.4)+pos);
  p5 := Convert(PointF(0.91, 0.81+0.4)+pos);
  p6 := Convert(PointF(0.75, 1.4+0.4)+pos);
  p7 := Convert(PointF(1.95, 1.95+0.4)+pos);
  p8 := Convert(PointF(0-1.16, 1.95+0.4)+pos);
  p9 := Convert(PointF(0-1.16, 0.99)+pos);
  p10 := Convert(PointF(0.2-0.8, 0.99)+pos);
  myCanvas.Polygon([p11, p3, p4, p5, p6, p7, p8, p9, p10]);



  // Локация2 (Коли)

  maxX := 2000/1.2;
  maxY:= 1000/1.2;
  Offset := 0;
  myCanvas.Pen.Color := clBlack;
  myCanvas.Brush.Color := clWhite;

  pos := pos - PointF(1.5+0.8, 1.5);

//  Loc2Off := 100;
//  myCanvas.Rectangle()

  // Первый прямоугольник
  myCanvas.Brush.Color := RGB(191, 119, 0);
  p1 := PointF(910/maxX, 700/maxY);
  p2 := PointF(990/maxX, 550/maxY);
  rect := ConvertRect(AddPosRect(RectF(p1.X, p1.Y, p2.X, p2.Y), pos));
  myCanvas.Rectangle(rect);

  // Второй прямоугольник
  p1 := PointF(1410/maxX, 700/maxY);
  p2 := PointF(1490/maxX, 550/maxY);
  rect := ConvertRect(AddPosRect(RectF(p1.X, p1.Y, p2.X, p2.Y), pos));
  myCanvas.Rectangle(rect);

  // Третий прямоугольник
  p1 := PointF(1910/maxX, 700/maxY);
  p2 := PointF(1990/maxX, 550/maxY);
  rect := ConvertRect(AddPosRect(RectF(p1.X, p1.Y, p2.X, p2.Y), pos));
  myCanvas.Rectangle(rect);

  // Четвертый прямоугольник (с учетом Offset)
  p1 := PointF((2410 - Offset)/maxX, 700/maxY);
  p2 := PointF((2490 - Offset)/maxX, 550/maxY);
  rect := ConvertRect(AddPosRect(RectF(p1.X, p1.Y, p2.X, p2.Y), pos));
  myCanvas.Rectangle(rect);

  // Эллипсы (TEllipse)
  myCanvas.Brush.Color := RGB(111, 250, 0);
  // Первый эллипс
  p1 := PointF(800/maxX, 600/maxY);
  p2 := PointF(1100/maxX, 200/maxY);
  rect := ConvertRect(AddPosRect(RectF(p1.X, p1.Y, p2.X, p2.Y), pos));
  myCanvas.Ellipse(rect);

  // Второй эллипс
  p1 := PointF(1300/maxX, 600/maxY);
  p2 := PointF(1600/maxX, 200/maxY);
  rect := ConvertRect(AddPosRect(RectF(p1.X, p1.Y, p2.X, p2.Y), pos));
  myCanvas.Ellipse(rect);

  // Третий эллипс
  p1 := PointF(1800/maxX, 600/maxY);
  p2 := PointF(2100/maxX, 200/maxY);
  rect := ConvertRect(AddPosRect(RectF(p1.X, p1.Y, p2.X, p2.Y), pos));
  myCanvas.Ellipse(rect);

  // Четвертый эллипс (с учетом Offset)
  p1 := PointF((2300 - Offset)/maxX, 600/maxY);
  p2 := PointF((2600 - Offset)/maxX, 200/maxY);
  rect := ConvertRect(AddPosRect(RectF(p1.X, p1.Y, p2.X, p2.Y), pos));
  myCanvas.Ellipse(rect);

  // Создаем полигон из двух линий
  myCanvas.Brush.Color := RGB(95, 158, 160);
  SetLength(polyPoints, 4);
  polyPoints[0] := Convert(AddPos(PointF(400/maxX, 785/maxY), pos)); // Начало первой линии
  polyPoints[1] := Convert(AddPos(PointF(10000/maxX, 785/maxY), pos)); // Конец первой линии
  polyPoints[2] := Convert(AddPos(PointF(10000/maxX, 840/maxY), pos)); // Конец второй линии (x взят от конца первой)
  polyPoints[3] := Convert(AddPos(PointF(200/maxX, 840/maxY), pos)); // Начало второй линии

  myCanvas.Polygon(polyPoints);

  // Многоугольники (TPolyGon)
  // Первый многоугольник
  myCanvas.Brush.Color:= color3;
  SetLength(polyPoints, 4);
  polyPoints[0] := Convert(AddPos(PointF(700/maxX, -10/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF(700/maxX, 700/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF(-10/maxX, 900/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF(-10/maxX, -10/maxY), pos));
  myCanvas.Polygon(polyPoints);

  // Второй многоугольник (дверной проем)
  myCanvas.Brush.Color := clBlack; // он черный, этот проем
  SetLength(polyPoints, 4);
  polyPoints[0] := Convert(AddPos(PointF(400/maxX, 500/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF(400/maxX, 785/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF(200/maxX, 840/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF(200/maxX, 555/maxY), pos));
  myCanvas.Polygon(polyPoints);

  // Третий многоугольник  (дверь)
  myCanvas.Brush.Color := RGB(237, 187, 30); // вернул цвет кисти
  SetLength(polyPoints, 4);
  polyPoints[0] := Convert(AddPos(PointF(400/maxX, 500/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF(400/maxX, 785/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF(600/maxX, 730/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF(600/maxX, 445/maxY), pos));
  myCanvas.Polygon(polyPoints);



  // Локация3 (Миши)
  maxX := 1000*1.2;
  maxY:= 500*1.2;
  myCanvas.Pen.Color := clBlack;
  myCanvas.Brush.Color := clWhite;

  pos := pos + PointF(4.4, 2.933);
  xHouses := 1;

  // Дом 1

  // Основной контур дома
  myCanvas.Brush.Color := RGB(210, 180, 140);
  SetLength(polyPoints, 5);
  polyPoints[0] := Convert(AddPos(PointF(xHouses/maxX, 400/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF(xHouses/maxX, 50/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 200)/maxX, 50/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 200)/maxX, 400/maxY), pos));
  polyPoints[4] := polyPoints[0]; // Замыкаем полигон
  myCanvas.Polygon(polyPoints);

  // Окно 1
  myCanvas.Brush.Color := RGB(200, 230, 250);

  SetLength(polyPoints, 5);
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 20)/maxX, 350/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 70)/maxX, 350/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 70)/maxX, 280/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 20)/maxX, 280/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окно 2
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 20)/maxX, 250/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 70)/maxX, 250/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 70)/maxX, 180/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 20)/maxX, 180/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окно 3
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 20)/maxX, 150/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 70)/maxX, 150/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 70)/maxX, 80/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 20)/maxX, 80/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окна справа (3 окна)
  // Окно 4
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 180)/maxX, 350/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 130)/maxX, 350/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 130)/maxX, 280/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 180)/maxX, 280/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окно 5
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 180)/maxX, 250/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 130)/maxX, 250/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 130)/maxX, 180/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 180)/maxX, 180/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окно 6
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 180)/maxX, 150/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 130)/maxX, 150/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 130)/maxX, 80/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 180)/maxX, 80/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);


  xHouses := 300;
  // Дом 2

  myCanvas.Brush.Color := RGB(200, 160, 160);
  SetLength(polyPoints, 5);
  polyPoints[0] := Convert(AddPos(PointF(xHouses/maxX, 400/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF(xHouses/maxX, 70/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 150)/maxX, 70/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 150)/maxX, 400/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  myCanvas.Brush.Color := RGB(220, 240, 255);

  // Окно 1
  SetLength(polyPoints, 5);
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 20)/maxX, 350/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 70)/maxX, 350/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 70)/maxX, 280/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 20)/maxX, 280/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окно 2
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 20)/maxX, 250/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 70)/maxX, 250/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 70)/maxX, 180/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 20)/maxX, 180/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окно 3
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 20)/maxX, 150/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 70)/maxX, 150/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 70)/maxX, 80/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 20)/maxX, 80/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окна справа
  // Окно 4
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 130)/maxX, 350/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 80)/maxX, 350/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 80)/maxX, 280/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 130)/maxX, 280/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окно 5
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 130)/maxX, 250/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 80)/maxX, 250/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 80)/maxX, 180/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 130)/maxX, 180/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окно 6
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 130)/maxX, 150/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 80)/maxX, 150/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 80)/maxX, 80/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 130)/maxX, 80/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);


  // Дом 3
  xHouses := 450;
  myCanvas.Brush.Color := RGB(180, 210, 140);
  SetLength(polyPoints, 5);
  polyPoints[0] := Convert(AddPos(PointF(xHouses/maxX, 400/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF(xHouses/maxX, 100/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 100)/maxX, 100/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 100)/maxX, 400/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  myCanvas.Brush.Color := RGB(200, 230, 250);
  // Окно 1
  SetLength(polyPoints, 5);
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 25)/maxX, 350/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 25)/maxX, 280/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 75)/maxX, 280/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 75)/maxX, 350/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окно 2
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 25)/maxX, 200/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 25)/maxX, 130/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 75)/maxX, 130/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 75)/maxX, 200/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);


  // Дом 1 (4)
  xHouses := 850;

  // Основной контур дома
  myCanvas.Brush.Color := RGB(140, 140, 210);
  SetLength(polyPoints, 5);
  polyPoints[0] := Convert(AddPos(PointF(xHouses/maxX, 400/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF(xHouses/maxX, 50/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 200)/maxX, 50/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 200)/maxX, 400/maxY), pos));
  polyPoints[4] := polyPoints[0]; // Замыкаем полигон
  myCanvas.Polygon(polyPoints);

  // Окно 1
  myCanvas.Brush.Color := RGB(200, 230, 250);

  SetLength(polyPoints, 5);
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 20)/maxX, 350/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 70)/maxX, 350/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 70)/maxX, 280/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 20)/maxX, 280/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окно 2
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 20)/maxX, 250/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 70)/maxX, 250/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 70)/maxX, 180/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 20)/maxX, 180/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окно 3
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 20)/maxX, 150/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 70)/maxX, 150/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 70)/maxX, 80/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 20)/maxX, 80/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окна справа (3 окна)
  // Окно 4
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 180)/maxX, 350/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 130)/maxX, 350/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 130)/maxX, 280/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 180)/maxX, 280/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окно 5
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 180)/maxX, 250/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 130)/maxX, 250/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 130)/maxX, 180/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 180)/maxX, 180/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окно 6
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 180)/maxX, 150/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 130)/maxX, 150/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 130)/maxX, 80/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 180)/maxX, 80/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Дом 2 (5)
  xHouses := 1200;

  myCanvas.Brush.Color := RGB(210, 180, 140);
  SetLength(polyPoints, 5);
  polyPoints[0] := Convert(AddPos(PointF(xHouses/maxX, 400/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF(xHouses/maxX, 70/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 150)/maxX, 70/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 150)/maxX, 400/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  myCanvas.Brush.Color := RGB(220, 240, 255);

  // Окно 1
  SetLength(polyPoints, 5);
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 20)/maxX, 350/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 70)/maxX, 350/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 70)/maxX, 280/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 20)/maxX, 280/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окно 2
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 20)/maxX, 250/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 70)/maxX, 250/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 70)/maxX, 180/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 20)/maxX, 180/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окно 3
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 20)/maxX, 150/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 70)/maxX, 150/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 70)/maxX, 80/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 20)/maxX, 80/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окна справа
  // Окно 4
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 130)/maxX, 350/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 80)/maxX, 350/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 80)/maxX, 280/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 130)/maxX, 280/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окно 5
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 130)/maxX, 250/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 80)/maxX, 250/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 80)/maxX, 180/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 130)/maxX, 180/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

  // Окно 6
  polyPoints[0] := Convert(AddPos(PointF((xHouses + 130)/maxX, 150/maxY), pos));
  polyPoints[1] := Convert(AddPos(PointF((xHouses + 80)/maxX, 150/maxY), pos));
  polyPoints[2] := Convert(AddPos(PointF((xHouses + 80)/maxX, 80/maxY), pos));
  polyPoints[3] := Convert(AddPos(PointF((xHouses + 130)/maxX, 80/maxY), pos));
  polyPoints[4] := polyPoints[0];
  myCanvas.Polygon(polyPoints);

end;

end.
