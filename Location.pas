unit Location;

interface

uses Winapi.Windows, Vcl.Graphics, System.Types, PointConverter;
procedure DrawLocation(pos: TPointF);
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
  myCanvas.Pen.Width:= PointConverter.GetBasicPenWidth();
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

end.
