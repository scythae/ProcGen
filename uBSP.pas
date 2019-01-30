unit uBSP;

interface

uses
  Types, SysUtils,

  uWorld, uGenerationAlgorithm;


type
  TBSPRoom = class
  private
    Rect: TRect;
    Visited: Boolean;
  public
    Parent: TBSPRoom;
    Room1: TBSPRoom;
    Room2: TBSPRoom;
    constructor Create(Rect: TRect);
    destructor Destroy(); override;
    procedure RandomDivide();
    function GetRects(): TArray<TRect>;
    function GetNextRoom(): TBSPRoom;
  end;

  TBSP = class(TGenerationAlgorithm)
  private
    Root: TBSPRoom;
    Current: TBSPRoom;
    Generation: Integer;
    function GetRectPoints(Rect: TRect): TArray<TPoint>;
  public
    procedure NextGeneration(); override;
    constructor Create(const World: TWorld); override;
    destructor Destroy(); override;
  end;

const
  MinRoomSize = 10;

implementation

function MakeRect(const Left, Top, Right, Bottom: Integer): TRect;
begin
  Result.Left := Left;
  Result.Top := Top;
  Result.Right := Right;
  Result.Bottom := Bottom;
end;

{ TBSPRoom }

destructor TBSPRoom.Destroy();
begin
  FreeAndNil(Room1);
  FreeAndNil(Room2);
  inherited;
end;

function TBSPRoom.GetNextRoom(): TBSPRoom;
begin
  if not Visited then
  begin
    Visited := True;
    Exit(Self);
  end;

  if Assigned(Room1) and not Room1.Visited then
    Exit(Room1.GetNextRoom());

  if Assigned(Room2) and not Room2.Visited then
    Exit(Room2.GetNextRoom());

  if Assigned(Parent) then
    Exit(Parent.GetNextRoom());

  Result := nil;
end;

function TBSPRoom.GetRects(): TArray<TRect>;
begin
  Result := [Rect] + Room1.GetRects() + Room2.GetRects();
end;

constructor TBSPRoom.Create(Rect: TRect);
begin
  Self.Rect := Rect;
end;

procedure TBSPRoom.RandomDivide();
var
  Direction: Integer;
  Border: Integer;
  RangeForBorder: Integer;
  Rect1, Rect2: TRect;
begin
  Direction := Random(2);

  if Direction = 1 then
  begin
    RangeForBorder := Rect.Width + 1 - MinRoomSize * 2;
    if RangeForBorder < 0 then
      Exit();

    Border := Rect.Left + MinRoomSize + Random(RangeForBorder);

    Rect1 := MakeRect(Rect.Left, Rect.Top, Border, Rect.Bottom);
    Rect2 := MakeRect(Border, Rect.Top, Rect.Right, Rect.Bottom);
  end
  else
  begin
    RangeForBorder := Rect.Height + 1 - MinRoomSize * 2;
    if RangeForBorder < 0 then
      Exit();

    Border := Rect.Top + MinRoomSize + Random(RangeForBorder);

    Rect1 := MakeRect(Rect.Left, Rect.Top, Rect.Right, Border);
    Rect2 := MakeRect(Rect.Left, Border, Rect.Right, Rect.Bottom);
  end;

  Room1 := TBSPRoom.Create(Rect1);
  Room2 := TBSPRoom.Create(Rect2);
  Room1.Parent := Self;
  Room2.Parent := Self;
  Room1.RandomDivide();
  Room2.RandomDivide();
end;

{ TBSP }

constructor TBSP.Create(const World: TWorld);
begin
  inherited;
  Root := TBSPRoom.Create(MakeRect(0, 0, World.Width - 1, World.Height - 1));
  Root.RandomDivide();
  Current := Root.GetNextRoom();
  Generation := 1;
end;

destructor TBSP.Destroy();
begin
  FreeAndNil(Root);
  inherited;
end;

function TBSP.GetRectPoints(Rect: TRect): TArray<TPoint>;
var
  Width, Height: Integer;
  X, Y: Integer;
  I: Integer;

  procedure AddPoint();
  begin
    Result[I] := Point(Rect.Left + X, Rect.Top + Y);
    Inc(I);
  end;
begin
  Width := Rect.Right - Rect.Left + 1;
  Height := Rect.Bottom - Rect.Top + 1;
  if (Width <= 0) or (Height <= 0) then
    Exit();

  SetLength(Result, Width * 2 + Height * 2 - 4);
  I := 0;

  Y := 0;
  for X := 0 to Width - 1 do
    AddPoint();

  X := Width - 1;
  for Y := 1 to Height - 2 do
    AddPoint();

  Y := Height - 1;
  for X := Width - 1 downto 0 do
    AddPoint();

  X := 0;
  for Y := Height - 2 downto 1 do
    AddPoint();
end;

procedure TBSP.NextGeneration();
var
  Wall: TPoint;
begin
  if Current = nil then
    Exit();

  for Wall in GetRectPoints(Current.Rect) do
    World[Wall.X, Wall.Y] := 1;

  Inc(Generation);

  Current := Current.GetNextRoom();
end;

end.
