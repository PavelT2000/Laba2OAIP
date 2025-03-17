unit Music;

interface

type
    AllMusic = (CalmMind, SnowSong, SlowMo, GameAward, SnowAmbient,
    DrumRoll, Audience, film);

procedure TurnOn(music: Allmusic);
procedure TurnOffAll;

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
    'music\Audience.mp3',
    'music\film.mp3'
    );

var
    musicPlaying: boolean = false;

//procedure PreLoad;
//begin
//  for var i := Low(MusicLocation) to High(MusicLocation) do
//  begin
//    MediaPlayers[i] := TMediaPlayer.Create(Main.Form1 );
//    MediaPlayers[i].Parent := Main.Form1;
//    MediaPlayers[i].Visible := false;
//    MediaPlayers[i].FileName := MusicLocation[i];
//    MediaPlayers[i].Open;
//  end;
//end;


procedure TurnOn(music: Allmusic);
begin
  try
    // Можно будет вынести в отдельную функцию,
    // если надо будет несколько звуков одновременно
    //for var i := Low(MediaPlayers) to High(MediaPlayers) do
      //MediaPlayers[i].Stop;

    Form1.MediaPlayer1.FileName := MusicLocation[music];
    Form1.MediaPlayer1.Open;
    Form1.MediaPlayer1.Play;

    musicPlaying:= True;
  except
    showMessage('Файлы музыки были повреждены!');
  end;
end;


procedure TurnOffAll();
begin
  if (musicPlaying = true) then begin
    Form1.MediaPlayer1.Stop;

    musicPlaying:= False;
  end;
end;

end.
