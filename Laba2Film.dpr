program Laba2Film;

uses
  Vcl.Forms,
  Main in 'OurLaba\Main.pas' {OurForm},
  drawSomeThing in 'OurLaba\drawSomeThing.pas',
  Location in 'OurLaba\Location.pas',
  PointConverter in 'OurLaba\PointConverter.pas',
  Music in 'OurLaba\Music.pas',
  NikManTest in 'OurLaba\NikManTest.pas',
  SkisPoles in 'OurLaba\SkisPoles.pas',
  BackGroundController in 'KolaLaba\BackGroundController.pas',
  CharacterController in 'KolaLaba\CharacterController.pas',
  EventController in 'KolaLaba\EventController.pas',
  film in 'MishaLaba\film.pas' {Form1},
  ColaMain in 'KolaLaba\ColaMain.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TOurForm, OurForm);
//  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
