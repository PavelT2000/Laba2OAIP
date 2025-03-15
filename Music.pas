unit Music;

interface

type
    AllMusic = (CalmMind, SnowSong, SlowMo, GameAward, SnowAmbient,
    DrumRoll, Audience);

procedure TurnOn(music: Allmusic);

implementation

uses Main, System.SysUtils, Vcl.Dialogs;

const
    MusicLocation: array[allMusic] of string = (
    'music\calmMind.mp3',
    'music\InTheSnowSong.mp3',
    'music\SlowMo.mp3',
    'music\GameAward.mp3',
    'music\SnowAmbient.mp3',
    'music\DrumRoll.mp3',
    'music\Audience.mp3'
    );

var
    musicPlaying: boolean = false;

procedure TurnOn(music: Allmusic);
begin
  try
    Main.Form1.MediaPlayer1.FileName:= MusicLocation[music];
    Main.Form1.MediaPlayer1.Open;
    Main.Form1.MediaPlayer1.Play;
    musicPlaying:= True;
  except
    showMessage('Файлы музыки были повреждены!');
  end;
end;

procedure TurnOff();
begin
  if (musicPlaying = true) then begin
    Main.Form1.MediaPlayer1.Stop;
    Main.Form1.MediaPlayer1.Close;
    musicPlaying:= False;
  end;
end;

end.
