unit film;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, MMSystem, Vcl.MPlayer;

const
  n = 23;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure FormPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    procedure DrawMan;
    procedure DrawPerson;
    procedure Coordinates;
    procedure DrawCartoon;
    procedure RStartGoing;
    procedure REndGoing;
    procedure RGoing;
    procedure RStartRun;
    procedure REndRun;
    procedure RRun;
    procedure Turnik;
    procedure FGoing;
    procedure TJump;
    procedure TPullUp;
    procedure TFell;
    procedure Hello;
    procedure Shtanga;
    procedure ShtEx;
    procedure Relax;
    procedure Background;
    procedure DrawHouse1;
    procedure DrawHouse2;
    procedure DrawHouse3;
  public
    { Public declarations }
  end;

type
  TSP = Record
    h: integer;
    dist: integer;
  End;

  tmas = array [1 .. n] of TSP;

var
  Form1: TForm1;
  tr, x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6, x7, y7, x8, y8, x9, y9,
    x10, y10, x11, y11, x12, y12, x13, y13, tx1, ty1, tx2, ty2, tx3, ty3, tx4,
    ty4, shtx, shty, tempx1, tempx2, lfeet, rfeet, lfeet2, rfeet2, kadr, kadr2,
    xHouses: integer;
  k, body, lhand0, lhand1, rhand0, rhand1, lleg0, lleg1, rleg0, rleg1: real;
  person: array [1 .. 2] of integer;
  arr: tmas;

implementation

{$R *.dfm}

procedure TForm1.FormPaint(Sender: TObject);
begin
  // �������� �������: ��������� ��������� � ������� �������
  DrawMan;
  kadr := 0;
  kadr2 := 0;
  person[1] := -100;
  person[2] := 230;
  lhand0 := 45;
  lhand1 := 0;
  rhand0 := 45;
  rhand1 := 0;
  lleg0 := 45;
  lleg1 := 0;
  rleg0 := 45;
  rleg1 := 0;
  lfeet := 1;
  rfeet := 1;
  lfeet2 := 1;
  rfeet2 := 1;
  body := 0;
  tx1 := 1040;
  ty1 := 590;
  shtx := 1215;
  shty := 416;
  k := 1;
  xHouses := 10;
  Randomize;
  arr[1].dist := 10;
  arr[1].h := Random(3);
  for var i := 2 to 23 do
  begin
    arr[i].h := Random(3);
    arr[i].dist := Random(3) * 25 + 200 + arr[i - 1].dist;
  end;
  tr := 0;
  {MediaPlayer1.FileName :=
    'C:\Users\������\Desktop\university\sem2\oaip\lab22\final2\lab222\fon_music.mp3';
  MediaPlayer1.Open;
  MediaPlayer1.Play;}
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  // ������ - ��������� ���������, ������� �����
  Canvas.FillRect(ClientRect);
  DoubleBuffered := True;
  DrawCartoon;
end;

// ������������ ��������� ����� 1
procedure TForm1.DrawHouse1;
begin
  Canvas.PolyLine([Point(xHouses, 400), Point(xHouses, 50), Point(xHouses + 200,
    50), Point(xHouses + 200, 400), Point(xHouses, 400)]);
  Canvas.PolyLine([Point(xHouses + 20, 350), Point(xHouses + 70, 350),
    Point(xHouses + 70, 280), Point(xHouses + 20, 280),
    Point(xHouses + 20, 350)]);
  Canvas.PolyLine([Point(xHouses + 20, 250), Point(xHouses + 70, 250),
    Point(xHouses + 70, 180), Point(xHouses + 20, 180),
    Point(xHouses + 20, 250)]);
  Canvas.PolyLine([Point(xHouses + 20, 150), Point(xHouses + 70, 150),
    Point(xHouses + 70, 80), Point(xHouses + 20, 80),
    Point(xHouses + 20, 150)]);
  Canvas.PolyLine([Point(xHouses + 180, 350), Point(xHouses + 130, 350),
    Point(xHouses + 130, 280), Point(xHouses + 180, 280),
    Point(xHouses + 180, 350)]);
  Canvas.PolyLine([Point(xHouses + 180, 250), Point(xHouses + 130, 250),
    Point(xHouses + 130, 180), Point(xHouses + 180, 180),
    Point(xHouses + 180, 250)]);
  Canvas.PolyLine([Point(xHouses + 180, 150), Point(xHouses + 130, 150),
    Point(xHouses + 130, 80), Point(xHouses + 180, 80),
    Point(xHouses + 180, 150)]);
end;

// ������������ ��������� ����� 2
procedure TForm1.DrawHouse2;
begin
  Canvas.PolyLine([Point(xHouses, 400), Point(xHouses, 100),
    Point(xHouses + 100, 100), Point(xHouses + 100, 400), Point(xHouses, 400)]);
  Canvas.PolyLine([Point(xHouses + 25, 350), Point(xHouses + 25, 280),
    Point(xHouses + 75, 280), Point(xHouses + 75, 350),
    Point(xHouses + 25, 350)]);
  Canvas.PolyLine([Point(xHouses + 25, 200), Point(xHouses + 25, 130),
    Point(xHouses + 75, 130), Point(xHouses + 75, 200),
    Point(xHouses + 25, 200)]);
end;

// ������������ ��������� ����� 3
procedure TForm1.DrawHouse3;
begin
  Canvas.PolyLine([Point(xHouses, 400), Point(xHouses, 70), Point(xHouses + 150,
    70), Point(xHouses + 150, 400), Point(xHouses, 400)]);
  Canvas.PolyLine([Point(xHouses + 20, 350), Point(xHouses + 70, 350),
    Point(xHouses + 70, 280), Point(xHouses + 20, 280),
    Point(xHouses + 20, 350)]);
  Canvas.PolyLine([Point(xHouses + 20, 250), Point(xHouses + 70, 250),
    Point(xHouses + 70, 180), Point(xHouses + 20, 180),
    Point(xHouses + 20, 250)]);
  Canvas.PolyLine([Point(xHouses + 20, 150), Point(xHouses + 70, 150),
    Point(xHouses + 70, 80), Point(xHouses + 20, 80),
    Point(xHouses + 20, 150)]);
  Canvas.PolyLine([Point(xHouses + 130, 350), Point(xHouses + 80, 350),
    Point(xHouses + 80, 280), Point(xHouses + 130, 280),
    Point(xHouses + 130, 350)]);
  Canvas.PolyLine([Point(xHouses + 130, 250), Point(xHouses + 80, 250),
    Point(xHouses + 80, 180), Point(xHouses + 130, 180),
    Point(xHouses + 130, 250)]);
  Canvas.PolyLine([Point(xHouses + 130, 150), Point(xHouses + 80, 150),
    Point(xHouses + 80, 80), Point(xHouses + 130, 80),
    Point(xHouses + 130, 150)]);
end;

// ������������ ��������� ������� ����
procedure TForm1.Background;
begin
  for var g := 1 to 23 do
  begin
    xHouses := arr[g].dist + tr;
    if arr[g].h = 0 then
      DrawHouse1;
    if arr[g].h = 1 then
      DrawHouse2;
    if arr[g].h = 2 then
      DrawHouse3;
  end;
end;

// ������������ ������� ��������� ����� �������� �� ��������� ����������
procedure TForm1.Coordinates;
begin
  x1 := Round(person[1] - sin(body * pi / 180) * 25 * k);
  y1 := Round(person[2] + cos(body * pi / 180) * 25 * k);
  x2 := Round(person[1] - sin(body * pi / 180) * 150 * k);
  y2 := Round(person[2] + cos(body * pi / 180) * 150 * k);
  x3 := Round(person[1] - sin(body * pi / 180) * 50 * k);
  y3 := Round(person[2] + cos(body * pi / 180) * 50 * k);
  x4 := x3 - Round(sin((lhand0 + body) * pi / 180) * 50 * k);
  y4 := y3 + Round(cos((lhand0 + body) * pi / 180) * 50 * k);
  x5 := x4 - Round(sin((lhand1 + body) * pi / 180) * 50 * k);
  y5 := y4 + Round(cos((lhand1 + body) * pi / 180) * 50 * k);
  x6 := x3 + Round(sin((180 - rhand0 + body) * pi / 180) * 50 * k);
  y6 := y3 - Round(cos((180 - rhand0 + body) * pi / 180) * 50 * k);
  x7 := x6 + Round(sin((180 - rhand1 + body) * pi / 180) * 50 * k);
  y7 := y6 - Round(cos((180 - rhand1 + body) * pi / 180) * 50 * k);
  x8 := x2 - Round(sin((lleg0 + body) * pi / 180) * 50 * k);
  y8 := y2 + Round(cos((lleg0 + body) * pi / 180) * 50 * k);
  x9 := x8 - Round(sin((lleg1 + body) * pi / 180) * 50 * k);
  y9 := y8 + Round(cos((lleg1 + body) * pi / 180) * 50 * k);
  x10 := x2 + Round(sin((180 - rleg0 + body) * pi / 180) * 50 * k);
  y10 := y2 - Round(cos((180 - rleg0 + body) * pi / 180) * 50 * k);
  x11 := x10 + Round(sin((180 - rleg1 + body) * pi / 180) * 50 * k);
  y11 := y10 - Round(cos((180 - rleg1 + body) * pi / 180) * 50 * k);
  x12 := x9 - Round(sin((lfeet2 * (body + lleg1) + (90 * lfeet)) * pi /
    180) * 15 * k);
  y12 := y9 + Round(cos((lfeet2 * (body + lleg1) + (90 * lfeet)) * pi /
    180) * 15 * k);
  x13 := x11 - Round(sin((rfeet2 * (body - rleg1) - (90 * rfeet)) * pi /
    180) * 15 * k);
  y13 := y11 + Round(cos((rfeet2 * (body - rleg1) - (90 * rfeet)) * pi /
    180) * 15 * k);
end;

// ������������ ��������� �������� �� ������ �������� �����
procedure TForm1.DrawPerson;
begin
  Canvas.Ellipse(Round(person[1] - 25 * k), Round(person[2] - 25 * k),
    Round(person[1] + 25 * k), Round(person[2] + 25 * k));
  Canvas.PolyLine([Point(x1, y1), Point(x2, y2)]);
  Canvas.PolyLine([Point(x3, y3), Point(x4, y4), Point(x5, y5)]);
  Canvas.PolyLine([Point(x3, y3), Point(x6, y6), Point(x7, y7)]);
  Canvas.PolyLine([Point(x2, y2), Point(x8, y8), Point(x9, y9),
    Point(x12, y12)]);
  Canvas.PolyLine([Point(x2, y2), Point(x10, y10), Point(x11, y11),
    Point(x13, y13)]);
end;

// ������������ �������� ����� � ��������� ��������
procedure TForm1.DrawMan;
begin
  Coordinates;
  DrawPerson;
end;

// ������������ ��������� ������
procedure TForm1.Shtanga;
begin
  Canvas.PolyLine([Point(shtx - 125, shty), Point(shtx + 125, shty)]);
  Canvas.Rectangle(shtx - 175, shty - 50, shtx - 125, shty + 50);
  Canvas.Rectangle(shtx - 200, shty - 25, shtx - 174, shty + 25);
  Canvas.Rectangle(shtx + 175, shty - 50, shtx + 125, shty + 50);
  Canvas.Rectangle(shtx + 200, shty - 25, shtx + 174, shty + 25);
end;

// ������������ ��������� �����������
procedure TForm1.Turnik;
begin
  tx2 := tx1;
  ty2 := ty1 - 500;
  tx3 := tx2 + 350;
  ty3 := ty2;
  tx4 := tx3;
  ty4 := ty1;
  Canvas.PolyLine([Point(tx1, ty1), Point(tx2, ty2), Point(tx3, ty3),
    Point(tx4, ty4)]);
end;

// ������������ ��������� ���� �� ������
procedure TForm1.DrawCartoon;
begin
  if (kadr >= 10) then
    Background;
  if (kadr = 60) or (kadr = 180) or (kadr = 300) or (kadr = 420) or (kadr = 540)
    or (kadr = 630) or (kadr = 720) or (kadr = 780) or (kadr = 900) or
    (kadr = 1020) or (kadr = 1110) or (kadr = 1370) or (kadr = 1430) or
    (kadr = 1550) or (kadr = 1670) or (kadr = 1760) or (kadr = 1880) or
    (kadr = 2010) or (kadr = 2080) or (kadr = 2220) or (kadr = 2360) or
    (kadr = 2500) or (kadr = 2560) or (kadr = 2620) or (kadr = 2740) or
    (kadr = 2860) or (kadr = 2980) or (kadr = 3070) or (kadr = 3450) or
    (kadr = 3540) or (kadr = 3600) or (kadr = 3720) or (kadr = 3840) or
    (kadr = 3960) or (kadr = 4080) then
    kadr2 := 0;
  if kadr < 60 then
  begin
    person[1] := person[1] + Round(25 * k / 30);
    RStartGoing;
  end
  else if (kadr >= 60) and (kadr < 540) then
  begin
    person[1] := person[1] + Round(25 * k / 30);
    RGoing;
  end
  else if (kadr >= 540) and (kadr < 630) then
  begin
    REndGoing;
    if kadr < 600 then
    begin
      person[1] := person[1] + Round(25 * k / 30);
    end;
  end
  else if (kadr >= 630) and (kadr < 720) then
  begin
    Hello;
  end
  else if (kadr >= 720) and (kadr < 780) then
  begin
    RStartGoing;
    tr := tr - 2;
    shtx := shtx - 2;
    Shtanga;
  end
  else if (kadr >= 780) and (kadr < 1020) then
  begin
    RGoing;
    tr := tr - 2;
    shtx := shtx - 2;
    Shtanga;
  end
  else if (kadr >= 1020) and (kadr < 1110) then
  begin
    REndGoing;
    if (kadr < 1080) then
    begin
      shtx := shtx - 2;
      tr := tr - 2;
    end;
    Shtanga;
  end
  else if (kadr >= 1110) and (kadr < 1370) then
  begin
    ShtEx;
    Shtanga;
  end
  else if (kadr >= 1370) and (kadr < 1430) then
  begin
    RStartGoing;
    tr := tr - 2;
    shtx := shtx - 2;
    tx1 := tx1 - 2;
    Shtanga;
    Turnik;
  end
  else if (kadr >= 1430) and (kadr < 1670) then
  begin
    RGoing;
    tr := tr - 2;
    shtx := shtx - 2;
    tx1 := tx1 - 2;
    Shtanga;
    Turnik;
  end
  else if (kadr >= 1670) and (kadr < 1760) then
  begin
    REndGoing;
    if (kadr < 1730) then
    begin
      tr := tr - 2;
      shtx := shtx - 2;
      tx1 := tx1 - 2;
    end;
    Shtanga;
    Turnik;
  end
  else if (kadr >= 1760) and (kadr < 2000) then
  begin
    k := k + 0.002083333;
    FGoing;
    Turnik;
  end
  else if (kadr >= 2000) and (kadr < 2010) then
  begin
    DrawMan;
    Turnik;
  end
  else if (kadr >= 2010) and (kadr < 2070) then
  begin
    TJump;
    Turnik;
  end
  else if (kadr >= 2070) and (kadr < 2080) then
  begin
    Coordinates;
    x5 := tempx1;
    x7 := tempx2;
    y5 := ty2;
    y7 := ty2;
    DrawPerson;
    kadr2 := kadr2 + 1;
    Turnik;
  end
  else if (kadr >= 2080) and (kadr < 2210) then
  begin
    TPullUp;
    Turnik;
  end
  else if (kadr >= 2210) and (kadr < 2220) then
  begin
    Coordinates;
    x5 := tempx1;
    x7 := tempx2;
    y5 := ty2;
    y7 := ty2;
    DrawPerson;
    kadr2 := kadr2 + 1;
    Turnik;
  end
  else if (kadr >= 2220) and (kadr < 2350) then
  begin
    TPullUp;
    Turnik;
  end
  else if (kadr >= 2350) and (kadr < 2360) then
  begin
    Coordinates;
    x5 := tempx1;
    x7 := tempx2;
    y5 := ty2;
    y7 := ty2;
    DrawPerson;
    kadr2 := kadr2 + 1;
    Turnik;
  end
  else if (kadr >= 2360) and (kadr < 2500) then
  begin
    TPullUp;
    Turnik;
  end
  else if (kadr >= 2500) and (kadr < 2560) then
  begin
    TFell;
    Turnik;
  end
  else if (kadr >= 2560) and (kadr < 2620) then
  begin
    RStartRun;
    tr := tr - 4;
    tx1 := tx1 - 4;
    Turnik;
  end
  else if (kadr >= 2620) and (kadr < 2980) then
  begin
    RRun;
    tr := tr - 4;
    tx1 := tx1 - 4;
    Turnik;
  end
  else if (kadr >= 2980) and (kadr < 3070) then
  begin
    REndRun;
    if (kadr < 3040) then
    begin
      tr := tr - 2;
      tx1 := tx1 - 2;
    end;
    Turnik;
  end
  else if (kadr >= 3070) and (kadr < 3450) then
  begin
    Relax;
  end
  // 3540
  else if (kadr >= 3450) and (kadr < 3540) then
    Hello
  else if (kadr >= 3540) and (kadr < 3600) then
  begin
    person[1] := person[1] + Round(25 * k / 30);
    RStartGoing;
  end
  else if (kadr >= 3600) and (kadr < 4080) then
  begin
    person[1] := person[1] + Round(25 * k / 30);
    RGoing;
  end
  else if (kadr = 4100) then
  kadr := kadr + 1;
end;

// ������������ ��������� ����� �����������/��������
procedure TForm1.Hello;
begin
  if kadr2 < 30 then
  begin
    rhand0 := rhand0 + 1.5;
    rhand1 := rhand1 + 195 / 30;
  end
  else if (kadr2 >= 30) and (kadr2 < 45) then
    rhand1 := rhand1 - 2
  else if (kadr2 >= 45) and (kadr2 < 60) then
    rhand1 := rhand1 + 2
  else if (kadr2 >= 60) and (kadr2 < 90) then
  begin
    rhand0 := rhand0 - 1.5;
    rhand1 := rhand1 - 195 / 30;
  end;
  kadr2 := kadr2 + 1;
  DrawMan;
end;

// ������������ ��������� ����� ������
procedure TForm1.Relax;
begin
  if (kadr2 < 30) then
  begin
    rhand0 := rhand0 + 1.5;
    lhand0 := lhand0 + 1.5;
    rhand1 := rhand1 + 3;
    lhand1 := lhand1 + 3;
  end
  else if (kadr2 >= 30) and (kadr2 < 90) then
  begin
    rhand0 := rhand0 + 0.75;
    lhand0 := lhand0 + 0.75;
    rhand1 := rhand1 + 1.75;
    lhand1 := lhand1 + 1.75;
  end
  else if (kadr2 >= 90) and (kadr2 < 120) then
  begin
    rhand0 := rhand0 - 1.5;
    lhand0 := lhand0 - 1.5;
    rhand1 := rhand1 - 3.5;
    lhand1 := lhand1 - 3.5;
  end
  else if (kadr2 >= 120) and (kadr2 < 180) then
  begin
    rhand0 := rhand0 - 0.75;
    lhand0 := lhand0 - 0.75;
    rhand1 := rhand1 - 1.75;
    lhand1 := lhand1 - 1.75;
  end
  else if (kadr2 >= 190) and (kadr2 < 220) then
  begin
    rhand0 := rhand0 + 1.5;
    lhand0 := lhand0 + 1.5;
    rhand1 := rhand1 + 3.5;
    lhand1 := lhand1 + 3.5;
  end
  else if (kadr2 >= 220) and (kadr2 < 280) then
  begin
    rhand0 := rhand0 + 0.75;
    lhand0 := lhand0 + 0.75;
    rhand1 := rhand1 + 1.75;
    lhand1 := lhand1 + 1.75;
  end
  else if (kadr2 >= 280) and (kadr2 < 310) then
  begin
    rhand0 := rhand0 - 1.5;
    lhand0 := lhand0 - 1.5;
    rhand1 := rhand1 - 3.5;
    lhand1 := lhand1 - 3.5;
  end
  else if (kadr2 >= 310) and (kadr2 < 370) then
  begin
    rhand0 := rhand0 - 0.75;
    lhand0 := lhand0 - 0.75;
    rhand1 := rhand1 - 1.5;
    lhand1 := lhand1 - 1.5;
  end;
  kadr2 := kadr2 + 1;
  DrawMan;
end;

// ������������ ��������� ����� ������ ��������
procedure TForm1.RStartGoing;
begin
  lfeet := -1;
  rfeet2 := 0;
  if kadr2 < 30 then
  begin
    if kadr2 mod 2 = 0 then
      person[2] := person[2] - 1;
    rhand0 := rhand0 - 15 / 60;
    rhand1 := rhand1 + 90 / 60;
    lleg0 := lleg0 - 75 / 30;
    lleg1 := lleg1 + 45 / 30;
    rleg0 := rleg0 - 45 / 30;
  end
  else if (kadr2 >= 30) and (kadr2 < 60) then
  begin
    person[2] := person[2] - Round((100 - cos(14.5 * pi / 180) * 100) / 30 *
      1000) div 1000;
    rhand0 := rhand0 - 15 / 60;
    rhand1 := rhand1 + 90 / 60;
    lleg0 := lleg0 + 15.5 / 30;
    lleg1 := lleg1 - 59.5 / 30;
    rleg0 := rleg0 - 14.5 / 30;
    rleg1 := rleg1 - 14.5 / 30;
  end;
  DrawMan;
  kadr2 := kadr2 + 1;
end;

// ������������ ��������� ����� ������ ����
procedure TForm1.RStartRun;
begin
  lfeet := -1;
  rfeet2 := 0;
  if kadr2 < 30 then
  begin
    if kadr2 mod 2 = 0 then
    begin
      body := body + 1;
      person[2] := person[2] - 1;
    end;
    rhand0 := rhand0 - 15 / 60;
    rhand1 := rhand1 + 90 / 60;
    lleg0 := lleg0 - 105 / 30;
    lleg1 := lleg1 + 45 / 30;
    rleg0 := rleg0 - 45 / 30;
  end
  else if (kadr2 >= 30) and (kadr2 < 60) then
  begin
    rhand0 := rhand0 - 15 / 60;
    rhand1 := rhand1 + 90 / 60;
    lleg0 := lleg0 + 15.5 / 30;
    lleg1 := lleg1 - 89.5 / 30;
    rleg0 := rleg0 - 14.5 / 30;
    rleg1 := rleg1 - 14.5 / 30;
  end;
  DrawMan;
  kadr2 := kadr2 + 1;
end;

// ������������ ��������� ����� ����
procedure TForm1.RRun;
begin
  if kadr2 < 30 then
  begin
    rfeet2 := 1;
    lfeet2 := 0;
    rhand0 := rhand0 - 75 / 60;
    rhand1 := rhand1 - 90 / 60;
    lhand0 := lhand0 - 75 / 60;
    lhand1 := lhand1 - 90 / 60;
    lleg0 := lleg0 + 59 / 60;
    lleg1 := lleg1 + 59 / 60;
    rleg0 := rleg0 + 74.5 / 30;
    rleg1 := rleg1 - 30.5 / 30;
  end
  else if (kadr2 >= 30) and (kadr2 < 60) then
  begin
    rhand0 := rhand0 - 75 / 60;
    rhand1 := rhand1 - 90 / 60;
    lhand0 := lhand0 - 75 / 60;
    lhand1 := lhand1 - 90 / 60;
    lleg0 := lleg0 + 59 / 60;
    lleg1 := lleg1 + 59 / 60;
    rleg0 := rleg0 - 15.5 / 30;
    rleg1 := rleg1 + 89.5 / 30;
  end
  else if (kadr2 >= 60) and (kadr2 < 90) then
  begin
    rfeet2 := 0;
    lfeet2 := 1;
    // person[2] := person[2] - Round((100 - cos(14.5*pi/180)*100)/30*1000) div 1000;
    lhand0 := lhand0 + 75 / 60;
    lhand1 := lhand1 + 90 / 60;
    rhand0 := rhand0 + 75 / 60;
    rhand1 := rhand1 + 90 / 60;
    rleg0 := rleg0 - 59 / 60;
    rleg1 := rleg1 - 59 / 60;
    lleg0 := lleg0 - 74.5 / 30;
    lleg1 := lleg1 + 30.5 / 30;
  end
  else if (kadr2 >= 90) and (kadr2 < 120) then
  begin
    lhand0 := lhand0 + 75 / 60;
    lhand1 := lhand1 + 90 / 60;
    rhand0 := rhand0 + 75 / 60;
    rhand1 := rhand1 + 90 / 60;
    rleg0 := rleg0 - 59 / 60;
    rleg1 := rleg1 - 59 / 60;
    lleg0 := lleg0 + 15.5 / 30;
    lleg1 := lleg1 - 89.5 / 30;
  end;
  DrawMan;
  kadr2 := kadr2 + 1;
end;

// ������������ ��������� ����� ���������� ����
procedure TForm1.REndRun;
begin
  if kadr2 < 30 then
  begin
    rfeet2 := 1;
    lfeet2 := 0;
    body := body - 0.25;
    rhand0 := rhand0 - 75 / 60;
    rhand1 := rhand1 - 90 / 60;
    lhand0 := lhand0 - 75 / 60;
    lhand1 := lhand1 - 90 / 60;
    lleg0 := lleg0 + 59 / 60;
    lleg1 := lleg1 + 59 / 60;
    rleg0 := rleg0 + 74.5 / 30;
    rleg1 := rleg1 - 30.5 / 30;
  end
  else if (kadr2 >= 30) and (kadr2 < 60) then
  begin
    body := body - 0.25;
    rhand0 := rhand0 - 75 / 60;
    rhand1 := rhand1 - 90 / 60;
    lhand0 := lhand0 - 75 / 60;
    lhand1 := lhand1 - 90 / 60;
    lleg0 := lleg0 + 59 / 60;
    lleg1 := lleg1 + 59 / 60;
    rleg0 := rleg0 - 45 / 30;
    rleg1 := rleg1 + 59.5 / 30;
  end
  else if (kadr2 >= 60) and (kadr2 < 90) then
  begin
    if kadr2 mod 2 = 0 then
      person[2] := person[2] + 1;
    rhand0 := rhand0 + 90 / 30;
    lhand0 := lhand0 + 75 / 30;
    lhand1 := lhand1 + 90 / 30;
    lleg0 := lleg0 + 30.5 / 30;
    lleg1 := lleg1 - 14.5 / 30;
    rleg0 := rleg0 + 30.5 / 30;
    rleg1 := rleg1 - 14.5 / 30;
    lfeet := 1;
    rfeet2 := 1;
  end;
  kadr2 := kadr2 + 1;
  DrawMan;
end;

// ������������ ��������� ����� ���������� ������
procedure TForm1.REndGoing;
begin
  if kadr2 < 30 then
  begin
    rfeet2 := 1;
    lfeet2 := 0;
    person[2] := person[2] - Round((100 - cos(14.5 * pi / 180) * 100) / 30 *
      1000) div 1000;
    rhand0 := rhand0 - 75 / 60;
    rhand1 := rhand1 - 90 / 60;
    lhand0 := lhand0 - 75 / 60;
    lhand1 := lhand1 - 90 / 60;
    lleg0 := lleg0 + 29 / 60;
    lleg1 := lleg1 + 29 / 60;
    rleg0 := rleg0 + 44.5 / 30;
    rleg1 := rleg1 - 30.5 / 30;
  end
  else if (kadr2 >= 30) and (kadr2 < 60) then
  begin
    person[2] := person[2] - Round((100 - cos(14.5 * pi / 180) * 100) / 30 *
      1000) div 1000;
    rhand0 := rhand0 - 75 / 60;
    rhand1 := rhand1 - 90 / 60;
    lhand0 := lhand0 - 75 / 60;
    lhand1 := lhand1 - 90 / 60;
    lleg0 := lleg0 + 29 / 60;
    lleg1 := lleg1 + 29 / 60;
    rleg0 := rleg0 - 15.5 / 30;
    rleg1 := rleg1 + 59.5 / 30;
  end
  else if (kadr2 >= 60) and (kadr2 < 90) then
  begin
    if kadr2 mod 2 = 0 then
      person[2] := person[2] + 1;
    rhand0 := rhand0 + 90 / 30;
    lhand0 := lhand0 + 75 / 30;
    lhand1 := lhand1 + 90 / 30;
    lleg0 := lleg0 + 30.5 / 30;
    lleg1 := lleg1 - 14.5 / 30;
    rleg0 := rleg0 + 30.5 / 30;
    rleg1 := rleg1 - 14.5 / 30;
    lfeet := 1;
    rfeet2 := 1;
  end;
  kadr2 := kadr2 + 1;
  DrawMan;
end;

// ������������ ��������� ����� ������ � ������
procedure TForm1.FGoing;
begin
  if (kadr2 < 30) then
  begin
    rleg0 := rleg0 + 1.5;
    lhand1 := lhand1 + 1;
    rhand1 := rhand1 - 1;
  end
  else if (kadr2 >= 30) and (kadr2 < 60) then
  begin
    rleg0 := rleg0 - 1.5;
    lhand1 := lhand1 - 1;
    rhand1 := rhand1 + 1;
  end
  else if (kadr2 >= 60) and (kadr2 < 90) then
  begin
    lleg0 := lleg0 + 1.5;
    lhand1 := lhand1 - 1;
    rhand1 := rhand1 + 1;
  end
  else if (kadr2 >= 90) and (kadr2 < 120) then
  begin
    lleg0 := lleg0 - 1.5;
    lhand1 := lhand1 + 1;
    rhand1 := rhand1 - 1;
  end;
  DrawMan;
  kadr2 := kadr2 + 1;
end;

// ������������ ��������� ����� ������
procedure TForm1.RGoing;
begin
  if kadr2 < 30 then
  begin
    rfeet2 := 1;
    lfeet2 := 0;
    person[2] := person[2] - Round((100 - cos(14.5 * pi / 180) * 100) / 30 *
      1000) div 1000;
    rhand0 := rhand0 - 75 / 60;
    rhand1 := rhand1 - 90 / 60;
    lhand0 := lhand0 - 75 / 60;
    lhand1 := lhand1 - 90 / 60;
    lleg0 := lleg0 + 29 / 60;
    lleg1 := lleg1 + 29 / 60;
    rleg0 := rleg0 + 44.5 / 30;
    rleg1 := rleg1 - 30.5 / 30;
  end
  else if (kadr2 >= 30) and (kadr2 < 60) then
  begin
    person[2] := person[2] - Round((100 - cos(14.5 * pi / 180) * 100) / 30 *
      1000) div 1000;
    rhand0 := rhand0 - 75 / 60;
    rhand1 := rhand1 - 90 / 60;
    lhand0 := lhand0 - 75 / 60;
    lhand1 := lhand1 - 90 / 60;
    lleg0 := lleg0 + 29 / 60;
    lleg1 := lleg1 + 29 / 60;
    rleg0 := rleg0 - 15.5 / 30;
    rleg1 := rleg1 + 59.5 / 30;
  end
  else if (kadr2 >= 60) and (kadr2 < 90) then
  begin
    rfeet2 := 0;
    lfeet2 := 1;
    person[2] := person[2] - Round((100 - cos(14.5 * pi / 180) * 100) / 30 *
      1000) div 1000;
    lhand0 := lhand0 + 75 / 60;
    lhand1 := lhand1 + 90 / 60;
    rhand0 := rhand0 + 75 / 60;
    rhand1 := rhand1 + 90 / 60;
    rleg0 := rleg0 - 29 / 60;
    rleg1 := rleg1 - 29 / 60;
    lleg0 := lleg0 - 44.5 / 30;
    lleg1 := lleg1 + 30.5 / 30;
  end
  else if (kadr2 >= 90) and (kadr2 < 120) then
  begin
    person[2] := person[2] - Round((100 - cos(14.5 * pi / 180) * 100) / 30 *
      1000) div 1000;
    lhand0 := lhand0 + 75 / 60;
    lhand1 := lhand1 + 90 / 60;
    rhand0 := rhand0 + 75 / 60;
    rhand1 := rhand1 + 90 / 60;
    rleg0 := rleg0 - 29 / 60;
    rleg1 := rleg1 - 29 / 60;
    lleg0 := lleg0 + 15.5 / 30;
    lleg1 := lleg1 - 59.5 / 30;
  end;
  DrawMan;
  kadr2 := kadr2 + 1;
end;

// ������������ ��������� ����� ������
procedure TForm1.TJump;
begin
  if (kadr2 < 30) then
  begin
    rfeet2 := 1;
    lleg0 := lleg0 - 20 / 30;
    lleg1 := lleg1 + 20 / 30;
    rleg0 := rleg0 - 20 / 30;
    rleg1 := rleg1 + 20 / 30;
    lhand0 := lhand0 + 1.5;
    lhand1 := lhand1 + 3;
    rhand0 := rhand0 + 1.5;
    rhand1 := rhand1 + 3;
    person[2] := person[2] - 2;
  end
  else if (kadr2 >= 30) and (kadr2 < 60) then
  begin
    lleg0 := lleg0 + 20 / 30;
    lleg1 := lleg1 - 20 / 30;
    rleg0 := rleg0 + 20 / 30;
    rleg1 := rleg1 - 20 / 30;
    lhand0 := lhand0 + 1.5;
    lhand1 := lhand1 + 3;
    rhand0 := rhand0 + 1.5;
    rhand1 := rhand1 + 3;
    person[2] := person[2] - 1;
  end;
  kadr2 := kadr2 + 1;
  if kadr2 = 59 then
  begin
    Coordinates;
    tempx1 := x5;
    tempx2 := x7;
    y5 := ty2;
    y7 := ty2;
    DrawPerson;
  end
  else
    DrawMan;
end;

// ������������ ��������� ����� �������
procedure TForm1.TFell;
begin
  if (kadr2 < 30) then
  begin
    lleg0 := lleg0 - 20 / 30;
    lleg1 := lleg1 + 20 / 30;
    rleg0 := rleg0 - 20 / 30;
    rleg1 := rleg1 + 20 / 30;
    lhand0 := lhand0 - 1.5;
    lhand1 := lhand1 - 3;
    rhand0 := rhand0 - 1.5;
    rhand1 := rhand1 - 3;
    person[2] := person[2] + 2;
  end
  else if (kadr2 >= 30) and (kadr2 < 60) then
  begin
    lleg0 := lleg0 + 20 / 30;
    lleg1 := lleg1 - 20 / 30;
    rleg0 := rleg0 + 20 / 30;
    rleg1 := rleg1 - 20 / 30;
    lhand0 := lhand0 - 1.5;
    lhand1 := lhand1 - 3;
    rhand0 := rhand0 - 1.5;
    rhand1 := rhand1 - 3;
    person[2] := person[2] + 1;
  end;
  kadr2 := kadr2 + 1;
  DrawMan;
end;

// ������������ ��������� ����� �������� ������
procedure TForm1.TPullUp;
begin
  if (kadr2 >= 0) and (kadr2 < 30) then
  begin
    if kadr2 mod 2 = 0 then
    begin
      lhand1 := lhand1 + 1;
      rhand1 := rhand1 + 1;
    end;
    lhand0 := lhand0 - 1.5;
    rhand0 := rhand0 - 1.5;
    person[2] := person[2] - 2;
  end
  else if (kadr2 >= 30) and (kadr2 < 60) then
  begin
    lhand0 := lhand0 - 1;
    rhand0 := rhand0 - 1;
    if kadr2 mod 2 = 0 then
    begin
      lhand1 := lhand1 - 1;
      rhand1 := rhand1 - 1;
    end;
    person[2] := person[2] - 1;
  end
  else if (kadr2 >= 70) and (kadr2 < 100) then
  begin
    lhand0 := lhand0 + 1;
    rhand0 := rhand0 + 1;
    if kadr2 mod 2 = 0 then
    begin
      lhand1 := lhand1 + 1;
      rhand1 := rhand1 + 1;
    end;
    person[2] := person[2] + 1;
  end
  else if (kadr2 >= 100) and (kadr2 < 130) then
  begin
    if kadr2 mod 2 = 0 then
    begin
      lhand1 := lhand1 - 1;
      rhand1 := rhand1 - 1;
    end;
    lhand0 := lhand0 + 1.5;
    rhand0 := rhand0 + 1.5;
    person[2] := person[2] + 2;
  end;
  Coordinates;
  x5 := tempx1;
  x7 := tempx2;
  y5 := ty2;
  y7 := ty2;
  DrawPerson;
  kadr2 := kadr2 + 1;
end;

// ������������ ��������� ����� ������ �� �������
procedure TForm1.ShtEx;
begin
  if kadr2 < 30 then
  begin
    tempx1 := x5;
    tempx2 := x7;
    person[2] := person[2] + 2;
    Coordinates;
    if shty <= y5 then
    begin
      y5 := shty;
      y7 := shty;
    end;
    y8 := y8 - 2 * kadr2;
    y10 := y10 - 2 * kadr2;
    y9 := y9 - 2 * kadr2;
    y11 := y11 - 2 * kadr2;
    y12 := y9;
    y13 := y11;
    DrawPerson;
  end
  else if (kadr2 >= 30) and (kadr2 < 60) then
  begin
    person[2] := person[2] - 2;
    shty := shty - 2;
    Coordinates;
    y5 := shty;
    y7 := shty;
    y8 := y8 - 2 * (60 - kadr2);
    y10 := y10 - 2 * (60 - kadr2);
    y9 := y9 - 2 * (60 - kadr2);
    y11 := y11 - 2 * (60 - kadr2);
    y12 := y9;
    y13 := y11;
    DrawPerson;
  end
  else if (kadr2 >= 60) and (kadr2 < 70) then
    DrawPerson
  else if (kadr2 >= 70) and (kadr2 < 130) then
  begin
    lhand0 := lhand0 + 1.5;
    rhand0 := rhand0 + 1.5;
    shty := shty - 3;
    Coordinates;
    y5 := shty;
    y7 := shty;
    x5 := tempx1;
    x7 := tempx2;
    DrawPerson;
  end
  else if (kadr2 >= 130) and (kadr2 < 190) then
  begin
    lhand0 := lhand0 - 1.5;
    rhand0 := rhand0 - 1.5;
    shty := shty + 3;
    Coordinates;
    y5 := shty;
    y7 := shty;
    x5 := tempx1;
    x7 := tempx2;
    DrawPerson;
  end
  else if (kadr2 >= 190) and (kadr2 < 200) then
    DrawPerson
  else if (kadr2 >= 200) and (kadr2 < 230) then
  begin
    person[2] := person[2] + 2;
    shty := shty + 2;
    Coordinates;
    y5 := shty;
    y7 := shty;
    y8 := y8 - 2 * (kadr2 - 200);
    y10 := y10 - 2 * (kadr2 - 200);
    y9 := y9 - 2 * (kadr2 - 200);
    y11 := y11 - 2 * (kadr2 - 200);
    y12 := y9;
    y13 := y11;
    DrawPerson;
  end
  else if (kadr2 >= 230) and (kadr2 < 260) then
  begin
    person[2] := person[2] - 2;
    Coordinates;
    if shty <= y5 then
    begin
      y5 := shty;
      y7 := shty;
    end;
    y8 := y8 - 2 * (260 - kadr2);
    y10 := y10 - 2 * (260 - kadr2);
    y9 := y9 - 2 * (260 - kadr2);
    y11 := y11 - 2 * (260 - kadr2);
    y12 := y9;
    y13 := y11;
    DrawPerson;
  end;
  kadr2 := kadr2 + 1;
end;

end.
