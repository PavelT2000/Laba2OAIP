unit PointConverter;

interface

uses
  System.Types,sysutils;

type
  TPointConverter = class
  private
    class var FFieldRect: TRect;
  public
    class procedure SetFieldRect(const AFieldRect: TRect);
    class function Convert(const APoint: TPointF): TPoint;
  end;

implementation

class procedure TPointConverter.SetFieldRect(const AFieldRect: TRect);
begin
  FFieldRect := AFieldRect;
end;

class function TPointConverter.Convert(const APoint: TPointF): TPoint;
begin
  Result.X := Round(APoint.X * (FFieldRect.Width));
  Result.Y := Round(APoint.Y * (FFieldRect.Height));
end;

end.
