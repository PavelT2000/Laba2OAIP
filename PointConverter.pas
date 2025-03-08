unit PointConverter;

interface

uses
  System.Types;

procedure SetFieldRect(const AFieldRect: TRect);
function GetPixels(): integer;
function Convert(const APoint: TPointF): TPoint;
function ConvertBack(const APoint: TPoint): TPointF;
function ConvertRect(const ARect: TRectF): TRect;

implementation

uses System.sysUtils;

var FFieldRect: TRect;

procedure SetFieldRect(const AFieldRect: TRect);
begin
  FFieldRect := AFieldRect;
end;

function GetPixels(): integer;
begin
  result:= Round((FFieldRect.Width + FFieldRect.Height) / 2 * 0.01);
end;

function Convert(const APoint: TPointF): TPoint;
begin
  Result.X := Round(APoint.X * (FFieldRect.Width));
  Result.Y := Round(APoint.Y * (FFieldRect.Height));
end;

function ConvertBack(const APoint: TPoint): TPointF;
begin
  Result.X := APoint.X / FFieldRect.Width;
  Result.Y := APoint.Y / FFieldRect.Height;
end;

function ConvertRect(const ARect: TRectF): TRect;
begin
  Result.Top:= Round(ARect.Top * FFieldRect.Height);
  Result.Bottom:= Round(ARect.Bottom * FFieldRect.Height);
  Result.Left:= Round(ARect.Left * FFieldRect.Width);
  Result.Right:= Round(ARect.Right * FFieldRect.Width);
end;

end.
