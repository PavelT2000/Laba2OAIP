unit PointConverter;

interface

uses
  System.Types;

procedure SetFieldRect(const AFieldRect: TRect);
function Convert(const APoint: TPointF): TPoint;
function GetBasicPenWidth(): integer;

implementation

uses System.sysUtils;

var FFieldRect: TRect;

procedure SetFieldRect(const AFieldRect: TRect);
begin
  FFieldRect := AFieldRect;
end;

function GetBasicPenWidth(): integer;
begin
  result:= Round((FFieldRect.Width + FFieldRect.Height) /
    2 * 0.01);
end;

function Convert(const APoint: TPointF): TPoint;
begin
  Result.X := Round(APoint.X * (FFieldRect.Width));
  Result.Y := Round(APoint.Y * (FFieldRect.Height));
end;

end.
