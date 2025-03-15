﻿unit Music;

interface

type
    AllMusic = (CalmMind, SnowSong, SlowMo, GameAward, SnowAmbient,
    DrumRoll, Audience);

procedure TurnOn(music: Allmusic);
procedure PreLoad;

implementation

uses Main, System.SysUtils, Vcl.Dialogs, Vcl.MPlayer;

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
    MediaPlayers: array[allMusic] of TMediaPlayer;


procedure PreLoad;
begin
  for var i := Low(MusicLocation) to High(MusicLocation) do
  begin
    MediaPlayers[i] := TMediaPlayer.Create(Main.Form1 );
    MediaPlayers[i].Parent := Main.Form1;
    MediaPlayers[i].Visible := false;
    MediaPlayers[i].FileName := MusicLocation[i];
    MediaPlayers[i].Open;
  end;
end;


procedure TurnOn(music: Allmusic);
begin
  try
    // Можно будет вынести в отдельную функцию,
    // если надо будет несколько звуков одновременно
    for var i := Low(MediaPlayers) to High(MediaPlayers) do
      MediaPlayers[i].Stop;

    MediaPlayers[music].FileName := MusicLocation[music];

    MediaPlayers[music].Play;

    musicPlaying:= True;
  except
    showMessage('Файлы музыки были повреждены!');
  end;
end;

procedure TurnOff();
begin
  if (musicPlaying = true) then begin
    for var i := Low(MediaPlayers) to High(MediaPlayers) do
      MediaPlayers[i].Stop;

    musicPlaying:= False;
  end;
end;

end.
