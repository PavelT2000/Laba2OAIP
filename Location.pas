unit Location;

interface

uses Winapi.Windows, Vcl.Graphics, System.Types, PointConverter;
procedure DrawLocation(Canvas: TCanvas;pos:TPointF);

implementation

procedure DrawLocation(Canvas: TCanvas;pos:TPointF);
var
  p1, p2, p3, p4: TPoint;
begin
  TPointConverter.SetFieldRect(Canvas.ClipRect);
  Canvas.Pen.Width := trunc((Canvas.ClipRect.Width + Canvas.ClipRect.Height) /
    2 * 0.01);
  Canvas.Pen.Color:=clBlack;

  p1 := TPointConverter.Convert(PointF(0+pos.x, 0.55+pos.y));
  Canvas.MoveTo(p1.X, p1.Y);
  p1 := TPointConverter.Convert(PointF(0.2+pos.x, 0.55+pos.y));
  Canvas.LineTo(p1.X, p1.Y);
  p1 := TPointConverter.Convert(PointF(0.6+pos.x, 1.05+pos.y));
  Canvas.LineTo(p1.X, p1.Y);
  p1 := TPointConverter.Convert(PointF(1+pos.x, 0.9+pos.y));
  Canvas.LineTo(p1.X, p1.Y);
  p1 := TPointConverter.Convert(PointF(1+pos.x, 1.4+pos.y));
  Canvas.LineTo(p1.X, p1.Y);
   p1 := TPointConverter.Convert(PointF(2+pos.x, 2+pos.y));
  Canvas.LineTo(p1.X, p1.Y);












end;

end.
