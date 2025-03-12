unit SkisPoles;

interface

uses Winapi.Windows, Vcl.Graphics, System.Types, Vcl.Dialogs, System.SysUtils,
  System.Math;

var startDraw: integer;

procedure SetCanvas(canvas: TCanvas);
procedure SetSize(size: single);
procedure DrawSkisPoles(nowCadr: Integer);
procedure Start;
procedure SetPos(newPos: TPointF);
function GetMaxCadrsCount: Integer;

implementation

uses PointConverter;

type
  TSkisPolesPos = record
    RightSki: TRectF;
    LeftSki: TRectF;
    RightPole: TRectF;
    LeftPole: TRectF;
  end;

  TQueuePos = record
    SkisPolesPositions: TSkisPolesPos;
    CadrsCount: Integer;
  end;

  TSkisPolesPosArr = array of TSkisPolesPos;
  TQueuePosArr = array of TQueuePos;

var
  SkisPolesAllPos: TSkisPolesPosArr;

  FavoritePositions: TSkisPolesPosArr;
  QueuePositions: TQueuePosArr;
  basicColor: TColor = TColor($13458B);
  basicWitdh: single = 1.4;

  basicCanvas: TCanvas;
  basicSize: single;
  pos: TPointF;

procedure SetCanvas(canvas: TCanvas);
begin
  basicCanvas := canvas;
end;

procedure SetSize(size: single);
begin
  basicSize := size;
end;

procedure SetPos(newPos: TPointF);
begin
  pos:= newPos;
end;


procedure PushToQueue(SkisPoles: TSkisPolesPos; countCadrs: Integer);
var
  ToPush: TQueuePos;
begin
  ToPush.SkisPolesPositions := SkisPoles;
  ToPush.CadrsCount := countCadrs;

  SetLength(QueuePositions, Length(QueuePositions)+1);
  QueuePositions[High(QueuePositions)] := ToPush;
end;



function DeltaRectF(StartRect, EndRect: TRectF; c, i: Integer): TRectF;
begin
  Result.Left := StartRect.Left - (StartRect.Left - EndRect.Left) / c * i;
  Result.Top := StartRect.Top - (StartRect.Top - EndRect.Top) / c * i;
  Result.Right := StartRect.Right - (StartRect.Right - EndRect.Right) / c * i;
  Result.Bottom := StartRect.Bottom - (StartRect.Bottom - EndRect.Bottom) / c * i;
end;

procedure SetSkisPolesPositions;
var
  SkisPoles: TSkisPolesPos;
  step: single;
  baseFrames: integer;
  skiLength: real;
begin
  //SetLength(FavoritePositions, 100);
  step:= 0.01;
  baseFrames:= 25;
  skiLength := 0.24;
  //��������� �������
  SkisPoles.RightSki.Create (0.445, 0.3, 0.445, 0.3+skiLength);
  SkisPoles.LeftSki.Create  (0.42, 0.3, 0.42, 0.3+skiLength);
  SkisPoles.RightPole.Create(0.41, 0.3, 0.41, 0.54);
  SkisPoles.LeftPole.Create (0.4, 0.3, 0.4, 0.54);

  PushToQueue(SkisPoles, startDraw); // �����

  PushToQueue(SkisPoles, 40);

  SkisPoles.RightSki.Create (0.44, 0.7, 0.44-skiLength, 0.7);
  SkisPoles.LeftSki.Create  (0.4, 0.75, 0.4-skiLength, 0.75);



  // ��� ��� ����� ��� � � ������
  PushToQueue(SkisPoles, baseFrames+1232);
  PushToQueue(SkisPoles, baseFrames);

end;


function MakeCadrsBetween(pStart, pEnd: TSkisPolesPos; countCadrs: Integer): TSkisPolesPosArr;
var
  i: Integer;
  PersonBetween: TSkisPolesPos;
begin

  countCadrs := countCadrs+1;
  setLength(result, countCadrs);

  for i := 0 to countCadrs-1 do
  begin
    result[i].RightSki := DeltaRectF(pStart.RightSki, pEnd.RightSki, countCadrs, i);
    result[i].LeftSki:= DeltaRectF(pStart.LeftSki, pEnd.LeftSki, countCadrs, i);
    result[i].RightPole := DeltaRectF(pStart.RightPole, pEnd.RightPole, countCadrs, i);
    result[i].LeftPole := DeltaRectF(pStart.LeftPole, pEnd.LeftPole, countCadrs, i);
  end;

end;


// ����������� ���� ������

procedure MakeAllCadrs;
var
  i, j: Integer;
  Person: TSkisPolesPos;
  TempCadrs: TSkisPolesPosArr;
  cadrsCount, oldLength: Integer;
begin
  for i := Low(QueuePositions) to High(QueuePositions)-1 do
  begin
    cadrsCount := QueuePositions[i].CadrsCount;
    // cadrsCount+2 = Length(TempCadrs)

    TempCadrs := MakeCadrsBetween(
    QueuePositions[i].SkisPolesPositions,
    QueuePositions[i+1].SkisPolesPositions,
    cadrsCount);

    oldLength := Length(SkisPolesAllPos);
    SetLength(SkisPolesAllPos, OldLength + cadrsCount+1);

    for j := Low(TempCadrs) to High(TempCadrs) do
      SkisPolesAllPos[OldLength + j] := TempCadrs[j];

  end;
end;

function GetMaxCadrsCount: Integer;
begin
  result := Length(SkisPolesAllPos);
end;

procedure DrawSkiOrPole(skiPos: TRectF; size: single);
var
  intP1: TPoint;
  xy1, xy2: TPointF;
begin
  basicCanvas.Pen.Color := basicColor;
  basicCanvas.Brush.Color := basicColor;
  basicCanvas.Pen.Width := Round(PointConverter.GetPixels * basicWitdh * size);

  skiPos.TopLeft := skiPos.TopLeft + pos;
  skiPos.BottomRight := skiPos.BottomRight + pos;

  intP1 := PointConverter.Convert(skiPos.TopLeft);
  basicCanvas.MoveTo(intP1.X, intP1.Y);
  intP1 := PointConverter.Convert(skiPos.BottomRight);
  basicCanvas.LineTo(intP1.X, intP1.Y);
end;



procedure DrawSkisPoles(nowCadr: Integer);
var
  ToDrawPos: TSkisPolesPos;
begin

  ToDrawPos := SkisPolesAllPos[nowCadr-1];

  DrawSkiOrPole(ToDrawPos.RightSki, basicSize);
  DrawSkiOrPole(ToDrawPos.LeftSki, basicSize);
  DrawSkiOrPole(ToDrawPos.RightPole, basicSize/3);
  DrawSkiOrPole(ToDrawPos.LeftPole, basicSize/3);
end;

procedure Start;
begin
  SetSkisPolesPositions;
  MakeAllCadrs;
end;

end.
