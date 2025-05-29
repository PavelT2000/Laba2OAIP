unit ColaMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CharacterController, EventController,
  BackGroundController,
  Vcl.ExtCtrls, Vcl.MPlayer;

type
  TForm2 = class(TForm)
    procedure OnPaint(Sender: TObject);
    procedure OnCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

var
  Wheel1: TBodyPRow = ((250, 700), (0, -1), (1, -1), (0, 1), (3, 1), (1, 3),
    (10, 1), (1, 5), (1, 1), (1, 0), (1, -1), (2, 1), (1, -1), (0, -1));
  Wheel2: TBodyPRow = ((300, 750), (-1, 0), (-1, -1), (1, 0), (1, -3), (3, -1),
    (1, -10), (5, -1), (1, -1), (0, -1), (-1, -1), (1, -2), (-1, -1), (-1, 0));
  Wheel3: TBodyPRow = ((350, 700), (0, 1), (-1, 1), (0, -1), (-3, -1), (-1, -3),
    (-10, -1), (-1, -5), (-1, -1), (-1, 0), (-1, 1), (-2, -1), (-1, 1), (0, 1));
  Wheel4: TBodyPRow = ((300, 650), (1, 0), (1, 1), (-1, 0), (-1, 3), (-3, 1),
    (-1, 10), (-5, 1), (-1, 1), (0, 1), (1, 1), (-1, 2), (1, 1), (1, 0));
  Laying: TBodyPRow = ((1700, 810), (-1, 0), (-1, 0), (-1, 0), (10, -1), (1, 0),
    (10, 1), (1, 0), (10, -1), (1, 0), (10, -1), (10, 1), (1, 0), (10, 1));
  GetUp: TBodyPRow = ((1700, 810), (-1, 0), (-1, 0), (-1, 0), (1, -5), (0, 1),
    (1, -3), (0, 1), (10, -1), (1, 0), (10, -1), (10, 1), (1, 0), (10, 1));
  First: TBodyPRow = ((1630, 720), (0, -1), (0, -1), (0, -1), (-1, 1), (0, 1),
    (1, 1), (0, 1), (-1, 1), (0, 1), (-1, 0), (1, 1), (0, 1), (1, 0));
  Centered: TBodyPRow = ((950, 720), (0, -1), (0, -1), (0, -1), (-1, 1), (0, 1),
    (1, 1), (0, 1), (-1, 1), (0, 1), (-1, 0), (1, 1), (0, 1), (1, 0));
  Walk1: TBodyPRow = ((975, 705), (0, -1), (0, -1), (0, -1), (-1, 3), (0, 1),
    (1, 5), (1, 3), (0, 1), (-1, 1), (1, 1), (1, 5), (0, 1), (1, 0));
  Walk2: TBodyPRow = ((995, 705), (0, -1), (0, -1), (0, -1), (-1, 7), (1, 10),
    (0, 1), (1, 7), (1, 6), (-3, 1), (3, 1), (0, 1), (-1, 5), (1, 0));
  Walk3: TBodyPRow = ((1020, 700), (0, -1), (0, -1), (0, -1), (0, 1), (1, 10),
    (-1, 10), (0, 1), (1, 3), (-1, 5), (5, 1), (-1, 5), (-1, 3), (2, 1));
  Walk4: TBodyPRow = ((1030, 700), (0, -1), (0, -1), (0, -1), (1, 3), (1, 5),
    (-1, 6), (-1, 5), (1, 3), (1, 3), (5, 1), (-1, 5), (-1, 2), (2, 1));
  Walk5: TBodyPRow = ((975, 705), (0, -1), (0, -1), (0, -1), (1, 5), (1, 3),
    (-1, 3), (0, 1), (1, 5), (0, 1), (1, 0), (0, 1), (-1, 1), (1, 1));
  Walk6: TBodyPRow = ((995, 705), (0, -1), (0, -1), (0, -1), (0, 1), (1, 7),
    (-1, 7), (1, 10), (0, 1), (-1, 5), (1, 0), (1, 6), (-3, 1), (3, 1));
  Walk7: TBodyPRow = ((1020, 700), (0, -1), (0, -1), (0, -1), (-1, 10), (0, 1),
    (0, 1), (1, 10), (-1, 5), (-1, 3), (2, 1), (1, 3), (-1, 5), (5, 1));
  Walk8: TBodyPRow = ((1030, 700), (0, -1), (0, -1), (0, -1), (-1, 6), (-1, 5),
    (1, 3), (1, 5), (-1, 5), (-1, 2), (2, 1), (1, 3), (1, 3), (5, 1));

  CenteredUp: TBodyPRow = ((950, 600), (0, -1), (0, -1), (0, -1), (-1, 1),
    (0, 1), (1, 1), (0, 1), (-1, 1), (0, 1), (-1, 0), (1, 1), (0, 1), (1, 0));
  FlowLeftBase: TBodyPRow = ((950, 600), (0, -1), (0, -1), (-1, -1), (-1, 3),
    (1, 3), (1, -3), (-1, -1), (-1, 1), (0, 1), (-1, 0), (1, 1),
    (0, 1), (1, 0));
  FlowLeft: TBodyPRow = ((950, 600), (-1, -2), (-2, -1), (-1, 0), (1, 3),
    (4, 1), (-1, -3), (-1, 0), (-1, 1), (0, 1), (-1, 0), (1, 1),
    (0, 1), (1, 0));
  FlowRightBase: TBodyPRow = ((950, 600), (0, -1), (0, -1), (1, -1), (-1, -3),
    (1, -1), (1, 3), (-1, 3), (-1, 1), (0, 1), (-1, 0), (1, 1), (0, 1), (1, 0));
  FlowRight: TBodyPRow = ((950, 600), (1, -2), (2, -1), (1, 0), (1, -3), (1, 0),
    (-1, 3), (-4, 1), (-1, 1), (0, 1), (-1, 0), (1, 1), (0, 1), (1, 0));
  SquatsBase: TBodyPRow = ((950, 550), (0, -1), (0, -1), (0, -1), (-3, 1),
    (1, 0), (3, 1), (-1, 0), (-1, 5), (0, 1), (-1, 5), (1, 5), (0, 1), (1, 5));
  Squats: TBodyPRow = ((950, 730), (0, -1), (0, -1), (0, -1), (-3, 1), (1, 0),
    (3, 1), (-1, 0), (-3, -1), (2, 1), (-2, -1), (3, -1), (-2, 1), (2, -1));
  Charge: TBodyPRow = ((950, 730), (0, -1), (0, -1), (0, -1), (-3, -1), (0, 1),
    (3, -1), (0, 1), (-3, -1), (2, 1), (-1, 0), (3, -1), (-2, 1), (1, 0));
  Jump: TBodyPRow = ((950, 450), (0, -1), (0, -1), (0, -1), (-1, 2), (0, 1),
    (1, 2), (0, 1), (-1, 2), (0, 1), (-1, 1), (1, 2), (0, 1), (1, 1));
  Star: TBodyPRow = ((950, 300), (0, -1), (0, -1), (0, -1), (-2, -1), (-1, -2),
    (2, -1), (1, -2), (-1, 1), (-1, 1), (-2, 1), (1, 1), (1, 1), (2, 1));
  CenteredDown: TBodyPRow = ((950, 900), (0, -1), (0, -1), (0, -1), (-1, 0),
    (1, 0), (1, 1), (0, 1), (-1, 10), (0, 1), (0, 1), (1, 10), (0, 1), (0, 1));
  Centered2: TBodyPRow = ((950, 720), (0, -1), (0, -1), (0, -1), (-1, 1),
    (0, 1), (1, 1), (0, 1), (-1, 10), (0, 1), (0, 1), (1, 10), (0, 1), (0, 1));

var
  Characer, Character: TCharacter;
  bg, BackGround, CoolCircle, CoolTransition: TBackGround;
  Driver: TDrawer;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  Driver.Destroy;
  Characer.Destroy;
  bg.Destroy;
end;

procedure TForm2.OnCreate(Sender: TObject);
var
  Period, MovementX, Start, Offset, I: integer;
begin
  Driver := TDrawer.Create(GetTickCount, 39999);
  bg := TBackGround.Create();

  Offset := 0;

  bg.AddKeyFrame([TRectangle.Create(910, 700, 990, 550, clBlack, ClWhite),
    TRectangle.Create(1410, 700, 1490, 550, clBlack, ClWhite),
    TRectangle.Create(1910, 700, 1990, 550, clBlack, ClWhite)],
    [TEllipse.Create(800, 600, 1100, 200, clBlack, ClWhite),
    TEllipse.Create(1300, 600, 1600, 200, clBlack, ClWhite),
    TEllipse.Create(1800, 600, 2100, 200, clBlack, ClWhite)],
    [TLine.Create(400, 785, 10000, 785, clBlack, clBlack),
    TLine.Create(200, 840, 10000, 840, clBlack, clBlack)],
    [TPolyGon.Create([Point(700, -10), Point(700, 700), Point(-10, 900),
    Point(-10, -10)], clBlack, ClWhite), TPolyGon.Create([Point(400, 500),
    Point(400, 785), Point(200, 840), Point(200, 555)], clBlack, clBlack),
    TPolyGon.Create([Point(400, 500), Point(400, 785), Point(200, 840),
    Point(200, 555)], clBlack, ClWhite)], 0);

  bg.AddKeyFrame([TRectangle.Create(910, 700, 990, 550, clBlack, ClWhite),
    TRectangle.Create(1410, 700, 1490, 550, clBlack, ClWhite),
    TRectangle.Create(1910, 700, 1990, 550, clBlack, ClWhite)],
    [TEllipse.Create(800, 600, 1100, 200, clBlack, ClWhite),
    TEllipse.Create(1300, 600, 1600, 200, clBlack, ClWhite),
    TEllipse.Create(1800, 600, 2100, 200, clBlack, ClWhite)],
    [TLine.Create(400, 785, 10000, 785, clBlack, clBlack),
    TLine.Create(200, 840, 10000, 840, clBlack, clBlack)],
    [TPolyGon.Create([Point(700, -10), Point(700, 700), Point(-10, 900),
    Point(-10, -10)], clBlack, ClWhite), TPolyGon.Create([Point(400, 500),
    Point(400, 785), Point(200, 840), Point(200, 555)], clBlack, clBlack),
    TPolyGon.Create([Point(400, 500), Point(400, 785), Point(200, 840),
    Point(200, 555)], clBlack, ClWhite)], 5000);

  bg.AddKeyFrame([TRectangle.Create(910, 700, 990, 550, clBlack, ClWhite),
    TRectangle.Create(1410, 700, 1490, 550, clBlack, ClWhite),
    TRectangle.Create(1910, 700, 1990, 550, clBlack, ClWhite)],
    [TEllipse.Create(800, 600, 1100, 200, clBlack, ClWhite),
    TEllipse.Create(1300, 600, 1600, 200, clBlack, ClWhite),
    TEllipse.Create(1800, 600, 2100, 200, clBlack, ClWhite)],
    [TLine.Create(400, 785, 10000, 785, clBlack, clBlack),
    TLine.Create(200, 840, 10000, 840, clBlack, clBlack)],
    [TPolyGon.Create([Point(700, -10), Point(700, 700), Point(-10, 900),
    Point(-10, -10)], clBlack, ClWhite), TPolyGon.Create([Point(400, 500),
    Point(400, 785), Point(200, 840), Point(200, 555)], clBlack, clBlack),
    TPolyGon.Create([Point(400, 500), Point(400, 785), Point(450, 935),
    Point(450, 650)], clBlack, ClWhite)], 5050);

  bg.AddKeyFrame([TRectangle.Create(910, 700, 990, 550, clBlack, ClWhite),
    TRectangle.Create(1410, 700, 1490, 550, clBlack, ClWhite),
    TRectangle.Create(1910, 700, 1990, 550, clBlack, ClWhite)],
    [TEllipse.Create(800, 600, 1100, 200, clBlack, ClWhite),
    TEllipse.Create(1300, 600, 1600, 200, clBlack, ClWhite),
    TEllipse.Create(1800, 600, 2100, 200, clBlack, ClWhite)],
    [TLine.Create(400, 785, 10000, 785, clBlack, clBlack),
    TLine.Create(200, 840, 10000, 840, clBlack, clBlack)],
    [TPolyGon.Create([Point(700, -10), Point(700, 700), Point(-10, 900),
    Point(-10, -10)], clBlack, ClWhite), TPolyGon.Create([Point(400, 500),
    Point(400, 785), Point(200, 840), Point(200, 555)], clBlack, clBlack),
    TPolyGon.Create([Point(400, 500), Point(400, 785), Point(600, 730),
    Point(600, 445)], clBlack, ClWhite)], 5100);

  bg.AddKeyFrame([TRectangle.Create(910, 700, 990, 550, clBlack, ClWhite),
    TRectangle.Create(1410, 700, 1490, 550, clBlack, ClWhite),
    TRectangle.Create(1910, 700, 1990, 550, clBlack, ClWhite),
    TRectangle.Create(2410 - Offset, 700, 2490 - Offset, 550, clBlack, ClWhite)
    ], [TEllipse.Create(800, 600, 1100, 200, clBlack, ClWhite),
    TEllipse.Create(1300, 600, 1600, 200, clBlack, ClWhite),
    TEllipse.Create(1800, 600, 2100, 200, clBlack, ClWhite),
    TEllipse.Create(2300 - Offset, 600, 2600 - Offset, 200, clBlack, ClWhite)],
    [TLine.Create(400, 785, 10000, 785, clBlack, clBlack),
    TLine.Create(200, 840, 10000, 840, clBlack, clBlack)],
    [TPolyGon.Create([Point(700, -10), Point(700, 700), Point(-10, 900),
    Point(-10, -10)], clBlack, ClWhite), TPolyGon.Create([Point(400, 500),
    Point(400, 785), Point(200, 840), Point(200, 555)], clBlack, clBlack),
    TPolyGon.Create([Point(400, 500), Point(400, 785), Point(600, 730),
    Point(600, 445)], clBlack, ClWhite)], 8000);

  Offset := 680;

  bg.AddKeyFrame([TRectangle.Create(910 - Offset, 700, 990 - Offset, 550,
    clBlack, ClWhite), TRectangle.Create(1410 - Offset, 700, 1490 - Offset, 550,
    clBlack, ClWhite), TRectangle.Create(1910 - Offset, 700, 1990 - Offset, 550,
    clBlack, ClWhite), TRectangle.Create(2410 - Offset, 700, 2490 - Offset, 550,
    clBlack, ClWhite)], [TEllipse.Create(800 - Offset, 600, 1100 - Offset, 200,
    clBlack, ClWhite), TEllipse.Create(1300 - Offset, 600, 1600 - Offset, 200,
    clBlack, ClWhite), TEllipse.Create(1800 - Offset, 600, 2100 - Offset, 200,
    clBlack, ClWhite), TEllipse.Create(2300 - Offset, 600, 2600 - Offset, 200,
    clBlack, ClWhite)], [TLine.Create(400 - Offset, 785, 10000 - Offset, 785,
    clBlack, clBlack), TLine.Create(200 - Offset, 840, 10000 - Offset, 840,
    clBlack, clBlack)], [TPolyGon.Create([Point(700 - Offset, -10),
    Point(700 - Offset, 700), Point(-10 - Offset, 900), Point(-10 - Offset, -10)
    ], clBlack, ClWhite), TPolyGon.Create([Point(400 - Offset, 500),
    Point(400 - Offset, 785), Point(200 - Offset, 840), Point(200 - Offset, 555)
    ], clBlack, clBlack), TPolyGon.Create([Point(400 - Offset, 500),
    Point(400 - Offset, 785), Point(600 - Offset, 730), Point(600 - Offset, 445)
    ], clBlack, ClWhite)], 9000);

  bg.AddKeyFrame([TRectangle.Create(910 - Offset, 700, 990 - Offset, 550,
    clBlack, ClWhite), TRectangle.Create(1410 - Offset, 700, 1490 - Offset, 550,
    clBlack, ClWhite), TRectangle.Create(1910 - Offset, 700, 1990 - Offset, 550,
    clBlack, ClWhite), TRectangle.Create(2410 - Offset, 700, 2490 - Offset, 550,
    clBlack, ClWhite), TRectangle.Create(2910 - Offset, 700, 2990 - Offset, 550,
    clBlack, ClWhite), TRectangle.Create(3410 - Offset, 700, 3490 - Offset, 550,
    clBlack, ClWhite)], [TEllipse.Create(800 - Offset, 600, 1100 - Offset, 200,
    clBlack, ClWhite), TEllipse.Create(1300 - Offset, 600, 1600 - Offset, 200,
    clBlack, ClWhite), TEllipse.Create(1800 - Offset, 600, 2100 - Offset, 200,
    clBlack, ClWhite), TEllipse.Create(2300 - Offset, 600, 2600 - Offset, 200,
    clBlack, ClWhite), TEllipse.Create(2800 - Offset, 600, 3100 - Offset, 200,
    clBlack, ClWhite), TEllipse.Create(3300 - Offset, 600, 3600 - Offset, 200,
    clBlack, ClWhite)], [TLine.Create(400 - Offset, 785, 10000 - Offset, 785,
    clBlack, clBlack), TLine.Create(200 - Offset, 840, 10000 - Offset, 840,
    clBlack, clBlack)], [TPolyGon.Create([Point(700 - Offset, -10),
    Point(700 - Offset, 700), Point(-10 - Offset, 900), Point(-10 - Offset, -10)
    ], clBlack, ClWhite), TPolyGon.Create([Point(400 - Offset, 500),
    Point(400 - Offset, 785), Point(200 - Offset, 840), Point(200 - Offset, 555)
    ], clBlack, clBlack), TPolyGon.Create([Point(400 - Offset, 500),
    Point(400 - Offset, 785), Point(600 - Offset, 730), Point(600 - Offset, 445)
    ], clBlack, ClWhite)], 10500);

  Offset := 1700;

  bg.AddKeyFrame([TRectangle.Create(910 - Offset, 700, 990 - Offset, 550,
    clBlack, ClWhite), TRectangle.Create(1410 - Offset, 700, 1490 - Offset, 550,
    clBlack, ClWhite), TRectangle.Create(1910 - Offset, 700, 1990 - Offset, 550,
    clBlack, ClWhite), TRectangle.Create(2410 - Offset, 700, 2490 - Offset, 550,
    clBlack, ClWhite), TRectangle.Create(2910 - Offset, 700, 2990 - Offset, 550,
    clBlack, ClWhite), TRectangle.Create(3410 - Offset, 700, 3490 - Offset, 550,
    clBlack, ClWhite)], [TEllipse.Create(800 - Offset, 600, 1100 - Offset, 200,
    clBlack, ClWhite), TEllipse.Create(1300 - Offset, 600, 1600 - Offset, 200,
    clBlack, ClWhite), TEllipse.Create(1800 - Offset, 600, 2100 - Offset, 200,
    clBlack, ClWhite), TEllipse.Create(2300 - Offset, 600, 2600 - Offset, 200,
    clBlack, ClWhite), TEllipse.Create(2800 - Offset, 600, 3100 - Offset, 200,
    clBlack, ClWhite), TEllipse.Create(3300 - Offset, 600, 3600 - Offset, 200,
    clBlack, ClWhite)], [TLine.Create(400 - Offset, 785, 10000 - Offset, 785,
    clBlack, clBlack), TLine.Create(200 - Offset, 840, 10000 - Offset, 840,
    clBlack, clBlack)], [TPolyGon.Create([Point(700 - Offset, -10),
    Point(700 - Offset, 700), Point(-10 - Offset, 900), Point(-10 - Offset, -10)
    ], clBlack, ClWhite), TPolyGon.Create([Point(400 - Offset, 500),
    Point(400 - Offset, 785), Point(200 - Offset, 840), Point(200 - Offset, 555)
    ], clBlack, clBlack), TPolyGon.Create([Point(400 - Offset, 500),
    Point(400 - Offset, 785), Point(600 - Offset, 730), Point(600 - Offset, 445)
    ], clBlack, ClWhite)], 16000);

  Characer := TCharacter.Create();
  Period := 400;
  MovementX := 100;
  Start := 5000;
  Wheel4[1, 1] := (Wheel3[1, 1] - 4 * MovementX);
  Wheel3[1, 1] := (Wheel3[1, 1] - 3 * MovementX);
  Wheel2[1, 1] := (Wheel2[1, 1] - 2 * MovementX);
  Wheel1[1, 1] := (Wheel1[1, 1] - 1 * MovementX);
  for I := 0 to 3 do
  begin
    Wheel1[1, 1] := (Wheel1[1, 1] + 4 * MovementX);
    Wheel2[1, 1] := (Wheel2[1, 1] + 4 * MovementX);
    Wheel3[1, 1] := (Wheel3[1, 1] + 4 * MovementX);
    Wheel4[1, 1] := (Wheel4[1, 1] + 4 * MovementX);
    Wheel1[1, 2] := (Wheel1[1, 2] + 15);
    Wheel2[1, 2] := (Wheel2[1, 2] + 15);
    Wheel3[1, 2] := (Wheel3[1, 2] + 15);
    Wheel4[1, 2] := (Wheel4[1, 2] + 15);
    Characer.AddKeyFrame(Wheel4, 50, Start + 0 + Period * I);
    Characer.AddKeyFrame(Wheel3, 50, Start + 100 + Period * I);
    Characer.AddKeyFrame(Wheel2, 50, Start + 200 + Period * I);
    if I <> 3 then
      Characer.AddKeyFrame(Wheel1, 50, Start + 300 + Period * I);
  end;
  Characer.AddKeyFrame(Laying, 50, 7000);
  Characer.AddKeyFrame(GetUp, 50, 8000);
  Characer.AddKeyFrame(Centered, 50, 9000);
  Characer.AddKeyFrame(Centered, 50, 10000);
  Start := 10500;
  Period := 800;
  Walk5[1, 1] := Walk5[1, 1] + 70;
  Walk6[1, 1] := Walk6[1, 1] + 70;
  Walk7[1, 1] := Walk7[1, 1] + 70;
  Walk8[1, 1] := Walk8[1, 1] + 70;
  MovementX := 150;
  for I := 0 to 6 do
  begin
    Characer.AddKeyFrame(Walk1, 50, Start + 0 + Period * I);
    Characer.AddKeyFrame(Walk2, 50, Start + 100 + Period * I);
    Characer.AddKeyFrame(Walk3, 50, Start + 200 + Period * I);
    Characer.AddKeyFrame(Walk4, 50, Start + 300 + Period * I);
    Characer.AddKeyFrame(Walk5, 50, Start + 400 + Period * I);
    Characer.AddKeyFrame(Walk6, 50, Start + 500 + Period * I);
    Characer.AddKeyFrame(Walk7, 50, Start + 600 + Period * I);
    Characer.AddKeyFrame(Walk8, 50, Start + 700 + Period * I);
    Walk1[1, 1] := Walk1[1, 1] + MovementX;
    Walk2[1, 1] := Walk2[1, 1] + MovementX;
    Walk3[1, 1] := Walk3[1, 1] + MovementX;
    Walk4[1, 1] := Walk4[1, 1] + MovementX;
    Walk5[1, 1] := Walk5[1, 1] + MovementX;
    Walk6[1, 1] := Walk6[1, 1] + MovementX;
    Walk7[1, 1] := Walk7[1, 1] + MovementX;
    Walk8[1, 1] := Walk8[1, 1] + MovementX;
  end;

  CoolTransition := TBackGround.Create();
  CoolTransition.AddKeyFrame([TRectangle.Create(2000, 1200, 2000, -10, clBlack,
    clBlack)], [], [], [], 15500);
  CoolTransition.AddKeyFrame([TRectangle.Create(-10, 1200, 2000, -10, clBlack,
    clBlack)], [], [], [], 16000);
  CoolTransition.AddKeyFrame([TRectangle.Create(-10, 1200, -10, -10, clBlack,
    clBlack)], [], [], [], 16500);
  Driver.AddDrawObj(bg);
  Driver.AddDrawObj(Characer);

  Character := TCharacter.Create();
  BackGround := TBackGround.Create();

  BackGround.AddKeyFrame([TRectangle.Create(-10, 500, 2000, 650, clBlack,
    ClWhite), TRectangle.Create(410, 700, 490, 550, clBlack, ClWhite),
    TRectangle.Create(1410, 700, 1490, 550, clBlack, ClWhite)],
    [TEllipse.Create(300, 600, 600, 200, clBlack, ClWhite),
    TEllipse.Create(1300, 600, 1600, 200, clBlack, ClWhite)], [], [], 16000);
  BackGround.AddKeyFrame([TRectangle.Create(-10, 500, 2000, 650, clBlack,
    ClWhite), TRectangle.Create(410, 700, 490, 550, clBlack, ClWhite),
    TRectangle.Create(1410, 700, 1490, 550, clBlack, ClWhite)],
    [TEllipse.Create(300, 600, 600, 200, clBlack, ClWhite),
    TEllipse.Create(1300, 600, 1600, 200, clBlack, ClWhite)], [], [], 40000);

  Character.AddKeyFrame(CenteredUp, 80, 16000);
  Character.AddKeyFrame(CenteredUp, 80, 17000);
  Start := 18000;
  Period := 1000;
  for I := 0 to 3 do
  begin
    Character.AddKeyFrame(FlowLeftBase, 80, Start + Period * I);
    Character.AddKeyFrame(FlowLeft, 80, Start + 300 + Period * I);
  end;
  Character.AddKeyFrame(FlowLeftBase, 80, 22000);
  Start := 23000;
  Period := 1000;
  for I := 0 to 3 do
  begin
    Character.AddKeyFrame(FlowRightBase, 80, Start + Period * I);
    Character.AddKeyFrame(FlowRight, 80, Start + 300 + Period * I);
  end;
  Character.AddKeyFrame(FlowRightBase, 80, 27000);
  Character.AddKeyFrame(CenteredUp, 80, 28000);
  Start := 29000;
  Period := 1000;
  for I := 0 to 3 do
  begin
    Character.AddKeyFrame(SquatsBase, 80, Start + Period * I);
    Character.AddKeyFrame(Squats, 80, Start + 300 + Period * I);
  end;

  Character.AddKeyFrame(CenteredUp, 80, 33000);
  Character.AddKeyFrame(Charge, 80, 34000);
  Character.AddKeyFrame(Jump, 80, 34300);
  Character.AddKeyFrame(Star, 80, 34700);
  Character.AddKeyFrame(Star, 80, 34900);
  Character.AddKeyFrame(Jump, 80, 35300);
  Character.AddKeyFrame(CenteredUp, 80, 35700);
  Character.AddKeyFrame(Centered2, 100, 36000);
  Character.AddKeyFrame(Centered2, 150, 37000);
  Character.AddKeyFrame(CenteredDown, 300, 38000);
  Character.AddKeyFrame(CenteredDown, 300, 40000);

  CoolCircle := TBackGround.Create();

  CoolCircle.AddKeyFrame([], [TEllipse.Create(800, 700, 900, 600, clBlack,
    clBlack)], [], [], 37000);
  CoolCircle.AddKeyFrame([], [TEllipse.Create(300, 800, 1100, 0, clBlack,
    clBlack)], [], [], 37700);
  CoolCircle.AddKeyFrame([], [TEllipse.Create(-200, 1800, 2200, -600, clBlack,
    clBlack)], [], [], 38100);
  CoolCircle.AddKeyFrame([], [TEllipse.Create(-200, 1800, 2200, -600, clBlack,
    clBlack)], [], [], 40000);

  Driver.AddDrawObj(BackGround);
  Driver.AddDrawObj(Character);
  Driver.AddDrawObj(CoolCircle);
  Driver.AddDrawObj(CoolTransition);
//  Form2.MediaPlayer1.Play;
end;

procedure TForm2.OnPaint(Sender: TObject);
begin
  Driver.DrawFrame(Form2, Form2.Canvas);
end;

end.
