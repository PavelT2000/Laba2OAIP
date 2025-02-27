program Laba2Film;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  drawSomeThing in 'drawSomeThing.pas',
  Location in 'Location.pas',
  PointConverter in 'PointConverter.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
