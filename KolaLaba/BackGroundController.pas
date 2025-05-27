unit BackGroundController;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, EventController;

type

  TFigure = class
  public
    Xpoint1: integer;
    Ypoint1: integer;
    Xpoint2: integer;
    Ypoint2: integer;
    PColor: TColor;
    BColor: TColor;
    constructor Create(x1, y1, x2, y2: integer; c1, c2: TColor);
  private
  end;

  TRectangle = class(TFigure)
  public
    procedure Draw(Canvas: TCanvas);
  private
  end;

  TPolyGon = class
  public
    Points: array of TPoint;
    PColor: TColor;
    BColor: TColor;
    constructor Create(Points: array of TPoint; clPen, clBrush: TColor);
    procedure Draw(Canvas: TCanvas);
  private
  end;

  TEllipse = class(TFigure)
  public
    procedure Draw(Canvas: TCanvas);
  private
  end;

  TLine = class(TFigure)
  public
    procedure Draw(Canvas: TCanvas);
  private
  end;

  TMasRectangle = array of TRectangle;
  TMasLine = array of TLine;
  TMasEllipse = array of TEllipse;
  TMasPolyGon = array of TPolyGon;

  TBcgKeyFrameInf = record
    PolyGons: TMasPolyGon;
    Rectangles: TMasRectangle;
    Ellipses: TMasEllipse;
    Lines: TMasLine;
    Time: Cardinal;
  end;

  TBcgKeyFrameAdr = ^TBcgKeyFrame;

  TBcgKeyFrame = record
    Inf: TBcgKeyFrameInf;
    Adr: TBcgKeyFrameAdr;
  end;

  TBackGround = class(TDrawObject)
  public
    BcgFrames: TBcgKeyFrameAdr;
    constructor Create();
    procedure Paint(const CurrentTime: Cardinal; Canvas: TCanvas); override;
    procedure AddKeyFrame(const rec: array of TRectangle;
      ell: array of TEllipse; line: array of TLine; poly: array of TPolyGon; const Time: Cardinal);
    destructor Destroy(); override;
  private
    procedure FreeFrame(FrameForFree: TBcgKeyFrameAdr);
  end;

implementation

constructor TFigure.Create(x1, y1, x2, y2: integer; c1, c2: TColor);
begin
  Xpoint1 := x1;
  Ypoint1 := y1;
  Xpoint2 := x2;
  Ypoint2 := y2;
  PColor := c1;
  BColor := c2;
end;

constructor TPolyGon.Create(Points: array of TPoint; clPen, clBrush: TColor);
var
  i: integer;
begin
  SetLength(self.Points,Length(Points));
  for i := Low(Points) to High(Points) do
  begin
    self.Points[i] := Points[i];
  end;
  PColor := clPen;
  BColor := clBrush;
end;

procedure TRectangle.Draw(Canvas: TCanvas);
begin
  Canvas.Pen.Color := PColor;
  Canvas.Pen.Width := 5;
  Canvas.Brush.Color := BColor;
  Canvas.Rectangle(Xpoint1, Ypoint1, Xpoint2, Ypoint2);
end;

procedure TEllipse.Draw(Canvas: TCanvas);
begin
  Canvas.Pen.Color := PColor;
  Canvas.Pen.Width := 5;
  Canvas.Brush.Color := BColor;
  Canvas.Ellipse(Xpoint1, Ypoint1, Xpoint2, Ypoint2);
end;

procedure TLine.Draw(Canvas: TCanvas);
begin
  Canvas.Pen.Color := PColor;
  Canvas.Pen.Width := 5;
  Canvas.Brush.Color := BColor;
  Canvas.MoveTo(Xpoint1, Ypoint1);
  Canvas.LineTo(Xpoint2, Ypoint2);
end;

procedure TPolyGon.Draw(Canvas: TCanvas);
begin
  Canvas.Pen.Color := PColor;
  Canvas.Pen.Width := 5;
  Canvas.Brush.Color := BColor;
  Canvas.Polygon(self.Points);
end;

procedure TBackGround.AddKeyFrame(const rec: array of TRectangle;
  ell: array of TEllipse; line: array of TLine; poly: array of TPolyGon; const Time: Cardinal);
var
  temp: TBcgKeyFrameAdr;
  i: integer;
begin
  temp := self.BcgFrames;
  while temp^.Adr <> nil do
  begin
    temp := temp^.Adr;
  end;
  New(temp^.Adr);
  temp := temp^.Adr;
  with temp^ do
  begin
    Adr := nil;
    Inf.Time := Time;
    SetLength(Inf.Rectangles, Length(rec));
    for i := Low(rec) to High(rec) do
      Inf.Rectangles[i] := rec[i];

    SetLength(Inf.Ellipses, Length(ell));
    for i := Low(ell) to High(ell) do
      Inf.Ellipses[i] := ell[i];

    SetLength(Inf.Lines, Length(line));
    for i := Low(line) to High(line) do
      Inf.Lines[i] := line[i];


    SetLength(Inf.PolyGons, Length(poly));
    for i := Low(poly) to High(poly) do
      Inf.PolyGons[i] := poly[i];
  end;
end;

constructor TBackGround.Create();
begin
  New(self.BcgFrames);
  self.BcgFrames^.Adr := nil;
end;

procedure TBackGround.Paint(const CurrentTime: Cardinal; Canvas: TCanvas);
var
  left, right, mid: TBcgKeyFrameAdr;
  Steps, i: integer;
  P1, P2: TPoint;
  Polygon: TPolyGon;
begin

  left := self.BcgFrames;
  right := nil;
  mid := left;
  Steps := 0;
  while mid <> right do
  begin
    mid := mid^.Adr;
    Inc(Steps);
  end;
  while (left^.Adr <> right) do
  begin
    mid := left;
    for Steps := 1 to Steps div 2 do
      mid := mid^.Adr;
    if ((mid <> nil) and (mid^.Inf.Time <= CurrentTime)) then
      left := mid
    else
      right := mid;
  end;
  if (right <> nil) and (BcgFrames <> left) then
  begin

    begin
      for Steps := Low(left.Inf.Rectangles) to High(left.Inf.Rectangles) do
      begin
        P1 := Lerp(Point(left.Inf.Rectangles[Steps].Xpoint1,
          left.Inf.Rectangles[Steps].Ypoint1),
          Point(right.Inf.Rectangles[Steps].Xpoint1,
          right.Inf.Rectangles[Steps].Ypoint1), left.Inf.Time, CurrentTime,
          right.Inf.Time);
        P2 := Lerp(Point(left.Inf.Rectangles[Steps].Xpoint2,
          left.Inf.Rectangles[Steps].Ypoint2),
          Point(right.Inf.Rectangles[Steps].Xpoint2,
          right.Inf.Rectangles[Steps].Ypoint2), left.Inf.Time, CurrentTime,
          right.Inf.Time);
        TRectangle.Create(P1.X, P1.Y, P2.X, P2.Y,
          left.Inf.Rectangles[Steps].PColor, left.Inf.Rectangles[Steps].BColor)
          .Draw(Canvas);
      end;
      for Steps := Low(left.Inf.Ellipses) to High(left.Inf.Ellipses) do
      begin
        P1 := Lerp(Point(left.Inf.Ellipses[Steps].Xpoint1,
          left.Inf.Ellipses[Steps].Ypoint1),
          Point(right.Inf.Ellipses[Steps].Xpoint1,
          right.Inf.Ellipses[Steps].Ypoint1), left.Inf.Time, CurrentTime,
          right.Inf.Time);
        P2 := Lerp(Point(left.Inf.Ellipses[Steps].Xpoint2,
          left.Inf.Ellipses[Steps].Ypoint2),
          Point(right.Inf.Ellipses[Steps].Xpoint2,
          right.Inf.Ellipses[Steps].Ypoint2), left.Inf.Time, CurrentTime,
          right.Inf.Time);
        TEllipse.Create(P1.X, P1.Y, P2.X, P2.Y, left.Inf.Ellipses[Steps].PColor,
          left.Inf.Ellipses[Steps].BColor).Draw(Canvas);
      end;
      for Steps := Low(left.Inf.Lines) to High(left.Inf.Lines) do
      begin
        P1 := Lerp(Point(left.Inf.Lines[Steps].Xpoint1,
          left.Inf.Lines[Steps].Ypoint1), Point(right.Inf.Lines[Steps].Xpoint1,
          right.Inf.Lines[Steps].Ypoint1), left.Inf.Time, CurrentTime,
          right.Inf.Time);
        P2 := Lerp(Point(left.Inf.Lines[Steps].Xpoint2,
          left.Inf.Lines[Steps].Ypoint2), Point(right.Inf.Lines[Steps].Xpoint2,
          right.Inf.Lines[Steps].Ypoint2), left.Inf.Time, CurrentTime,
          right.Inf.Time);
        TLine.Create(P1.X, P1.Y, P2.X, P2.Y, left.Inf.Lines[Steps].PColor,
          left.Inf.Lines[Steps].BColor).Draw(Canvas);
      end;
      for Steps := Low(left.Inf.PolyGons) to High(left.Inf.PolyGons) do
      begin
        Polygon := TPolyGon.Create(left.Inf.PolyGons[Steps].Points,
          left.Inf.PolyGons[Steps].PColor, left.Inf.PolyGons[Steps].BColor);
        with left.Inf.PolyGons[Steps] do
        begin
          if (right.Inf.PolyGons <> nil) then
          for i := Low(Points)
            to High(Points) do
          begin
              PolyGon.Points[i] := Lerp(Point(Points[i].X,
              Points[i].Y),
              Point(right.Inf.PolyGons[Steps].Points[i].X,
              right.Inf.PolyGons[Steps].Points[i].Y), left.Inf.Time, CurrentTime,
              right.Inf.Time);
          end;
        end;
        Polygon.Draw(Canvas);
      end;

    end;
  end;
end;

procedure TBackGround.FreeFrame(FrameForFree: TBcgKeyFrameAdr);
begin
  if FrameForFree^.Adr <> nil then
    FreeFrame(FrameForFree^.Adr);
  Dispose(FrameForFree);
end;

destructor TBackGround.Destroy();
begin
  FreeFrame(BcgFrames);
end;

end.
