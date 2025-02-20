unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.MPlayer, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    MediaPlayer1: TMediaPlayer;
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation






{$R *.dfm}

procedure Paint1(Canvas: TCanvas; x1, y1, x2, y2: Integer);
begin
  Canvas.Pen.Color := clRed;
  Canvas.Brush.Color := clRed;
  Canvas.Pen.Width := 5;
  Canvas.MoveTo(x1, y1);
  Canvas.LineTo(x2, y2);
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  grad: Integer;
begin
  Paint1(Canvas, 10, 10, 20, 500);
    Paint1(Canvas, 400, 400, 200, 100);
  Canvas.Ellipse(100-50, 100-50, 100+50, 100+50);     // 150
  grad := 0;
  Paint1(Canvas, 100, 100, 200, 500);
end;

end.
