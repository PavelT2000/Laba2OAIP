program Laba2Film;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  drawSomeThing in 'drawSomeThing.pas',
  Location in 'Location.pas',
  PointConverter in 'PointConverter.pas',
  Music in 'Music.pas',
  StikMan in 'StikMan.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
