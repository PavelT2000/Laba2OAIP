unit EventController;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TDrawObject = class
  public
    procedure Paint(const CurrentTime: Cardinal; Canvas: TCanvas);
      virtual; abstract;
    procedure AddKeyFrame(); virtual; abstract;
    function Lerp(StartPoint, EndPoint: TPoint;
      Start, Time, Ending: Cardinal): TPoint;
  private

  end;

  TDrawObjectAdr = ^TDrawObjects;

  TDrawObjects = record
    Inf: TDrawObject;
    Adr: TDrawObjectAdr;
  end;

  TDrawer = class
  public
    DrawObjects: TDrawObjectAdr;
    StartTime: Cardinal;
    LengthTime: Cardinal;
    constructor Create(Time, Length: Cardinal);
    procedure DrawFrame(Sender: TWinControl; Canvas: TCanvas);
    procedure AddDrawObj(Obj: TDrawObject);
    destructor Destroy; override;
  private
    procedure Draw(CurTime: Cardinal; Adr: TDrawObjectAdr; Canvas: TCanvas);
    procedure Clear(Adr: TDrawObjectAdr);
  end;

implementation

uses CharacterController;

function TDrawObject.Lerp(StartPoint, EndPoint: TPoint;
  Start, Time, Ending: Cardinal): TPoint;
var
  delTime: Double;
begin
  delTime := (Time - Start) / (Ending - Start + 1);
  Result.X := Round(StartPoint.X + (EndPoint.X - StartPoint.X) * delTime);
  Result.Y := Round(StartPoint.Y + (EndPoint.Y - StartPoint.Y) * delTime);
end;

constructor TDrawer.Create(Time, Length: Cardinal);
begin
  self.StartTime := Time;
  self.LengthTime := Length;
  New(self.DrawObjects);
  self.DrawObjects^.Adr := nil;
end;

procedure TDrawer.AddDrawObj(Obj: TDrawObject);
var
  temp: TDrawObjectAdr;
begin
  temp := self.DrawObjects;
  while temp^.Adr <> nil do
  begin
    temp := temp^.Adr;
  end;
  New(temp^.Adr);
  temp := temp^.Adr;
  temp^.Adr := nil;
  temp^.Inf := Obj;
end;

procedure TDrawer.Draw(CurTime: Cardinal; Adr: TDrawObjectAdr; Canvas: TCanvas);
begin
  Adr.Inf.Paint(CurTime, Canvas);
  if Adr.Adr <> nil then
    Draw(CurTime, Adr.Adr, Canvas);
end;

procedure TDrawer.DrawFrame(Sender: TWinControl; Canvas: TCanvas);
var
  CurTime: Cardinal;
  i: Integer;
begin
  CurTime := GetTickCount - StartTime;
  Draw(CurTime, DrawObjects.Adr, Canvas);
  if CurTime < LengthTime then
    Sender.Invalidate;
end;

procedure TDrawer.Clear(Adr: TDrawObjectAdr);
begin
  if Adr.Adr <> nil then
    Clear(Adr.Adr);
  Dispose(Adr);
end;

destructor TDrawer.Destroy;

begin
  Clear(DrawObjects);
end;

end.
