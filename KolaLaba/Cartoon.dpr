program Cartoon;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form2},
  CharacterController in 'CharacterController.pas',
  EventController in 'EventController.pas',
  BackGroundController in 'BackGroundController.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
