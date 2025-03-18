unit drawSomeThing;
//DrowSomething
interface

uses Winapi.Windows, Vcl.Graphics, System.Types, Vcl.Dialogs, System.SysUtils,
  System.Math;

procedure SetCanvas(canvas: TCanvas);


procedure DrawSnowflake(SFPosF: TPointF; Length: Integer;
  size, Ratio, OffsetAngle: single);

implementation

uses PointConverter;

const

  SFColor: TColor = clAqua;

var
  myCanvas: TCanvas;


procedure SetCanvas(canvas: TCanvas);
//DrowSomething/SetCanvas
begin
  myCanvas := canvas;
end;


procedure DrawSnowflake(SFPosF: TPointF; Length: Integer;
  size, Ratio, OffsetAngle: single);
//DrowSomething/DrawSnowflake


// SFPosF - координаты снежинки
// length - длина любой из 6 полосок в пикселях
// Size - ширина линий
// Ratio - коэффициент должен быть от 0 до 1, от него зависит
// на сколько далеко будут маленькие ответвления
// OffsetAngle - задаешь угол в градусах и снежинка поворачивается
var
  i: Integer;
  angle: array [0 .. 5] of Double;
  EndPoints, BranchPoints: array [0 .. 5] of TPoint;
  Offset: Integer;
  SFPos: TPoint;
begin
  myCanvas.Pen.Color := SFColor;
  myCanvas.Brush.Color := SFColor;
  myCanvas.Pen.Width := Round(PointConverter.GetPixels * 0.1 * size);

  Length := Round(PointConverter.GetPixels * 0.1 * Length);

  SFPos := PointConverter.Convert(SFPosF);

  Offset := Round(Length * Ratio); // Длина и отдаленность маленьких веточек

  // Нужные для лучей точки
  for i := 0 to 5 do
  begin
    angle[i] := i * 60 * Pi / 180 + OffsetAngle * Pi / 180;
    EndPoints[i].X := SFPos.X + Round(cos(angle[i]) * Length);
    EndPoints[i].Y := SFPos.Y + Round(sin(angle[i]) * Length);

    BranchPoints[i].X := SFPos.X + Round(cos(angle[i]) * (Length - Offset));
    BranchPoints[i].Y := SFPos.Y + Round(sin(angle[i]) * (Length - Offset));
  end;

  for i := 0 to 5 do
  begin
    // 6 Лучей
    myCanvas.MoveTo(SFPos.X, SFPos.Y);
    myCanvas.LineTo(EndPoints[i].X, EndPoints[i].Y);

    // Маленькие ответвления
    myCanvas.MoveTo(BranchPoints[i].X, BranchPoints[i].Y);
    myCanvas.LineTo(BranchPoints[i].X + Round(cos(angle[i] + Pi / 6) * Offset),
      BranchPoints[i].Y + Round(sin(angle[i] + Pi / 6) * Offset));

    myCanvas.MoveTo(BranchPoints[i].X, BranchPoints[i].Y);
    myCanvas.LineTo(BranchPoints[i].X + Round(cos(angle[i] - Pi / 6) * Offset),
      BranchPoints[i].Y + Round(sin(angle[i] - Pi / 6) * Offset));
  end;
end;

end.
