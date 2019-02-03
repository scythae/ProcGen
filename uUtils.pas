unit uUtils;

interface

uses
  Types, Math;

type
  TGetWayFunc = reference to function(pFrom, pTo: TPoint): TArray<TPoint>;

function GetLinePoints(pFrom, pTo: TPoint): TArray<TPoint>;
function GetPerimeterPoints(Rect: TRect): TArray<TPoint>;
function GetRandomWayFromTo(pFrom, pTo: TPoint): TArray<TPoint>;

implementation

function GetLinePoints(pFrom, pTo: TPoint): TArray<TPoint>;
var
  xDiff, yDiff: Integer;
  tmpP: TPoint;
  IteratingHorizontal: Boolean;
  MainDiff, SecDiff: Integer;
  MainCoord: Integer;
  SecCoord: Single;
  SecDelta: Single;
  I: Integer;

  function GetPoint(Coord1, Coord2: Integer): TPoint;
  begin
    if IteratingHorizontal then
    begin
      Result.X := Coord1;
      Result.Y := Coord2;
    end else begin
      Result.X := Coord2;
      Result.Y := Coord1;
    end;
  end;
begin
  xDiff := pTo.X - pFrom.X;
  yDiff := pTo.Y - pFrom.Y;

  if (xDiff = 0) and (yDiff = 0) then
  begin
    Result := [pFrom];
    Exit();
  end;

  IteratingHorizontal := Abs(xDiff) >= Abs(yDiff);

  if IteratingHorizontal then
  begin
    MainDiff := xDiff;
    SecDiff := yDiff;
  end else begin
    MainDiff := yDiff;
    SecDiff := xDiff;
  end;

  if MainDiff < 0 then
  begin
    MainDiff := -MainDiff;
    SecDiff := -SecDiff;
    tmpP := pFrom;
    pFrom := pTo;
    pTo := pFrom;
  end;

  SecDelta := SecDiff / MainDiff;

  SetLength(Result, MainDiff);

  tmpP := GetPoint(pFrom.X, pFrom.Y);

  MainCoord := tmpP.X;
  SecCoord := tmpP.Y;

  for I := 0 to MainDiff do
  begin
    MainCoord := MainCoord + 1;
    SecCoord := SecCoord + SecDelta;
    Result[I] := GetPoint(MainCoord, Round(SecCoord));
  end;
end;

function GetPerimeterPoints(Rect: TRect): TArray<TPoint>;
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

function GetRandomWayFromTo(pFrom, pTo: TPoint): TArray<TPoint>;
type
  TDirection = (dUp, dDown, dLeft, dRight);
var
  AnyAnotherDirectionPool: array [0..2] of TDirection;

  function GetDirectionFromTo(const pFrom, pTo: TPoint): TDirection;
  begin
    if (pFrom.X = pTo.X) or (Random() < 0.5) then
      if pFrom.Y > pTo.Y then
        Exit(dUp)
      else
        Exit(dDown)
    else
      if pFrom.X > pTo.X then
        Exit(dLeft)
      else
        Exit(dRight);
  end;

  procedure MoveTo(var P: TPoint; Direction: TDirection);
  begin
    case Direction of
      dUp: Dec(P.Y);
      dDown: Inc(P.Y);
      dLeft: Dec(P.X);
      dRight: Inc(P.X);
    end;
  end;

  function AnyDirectionBut(Direction: TDirection): TDirection;
  var
    I, J: Integer;
  begin
    J := 0;
    for I := 0 to Integer(High(TDirection)) do
    begin
      if TDirection(I) = Direction then
        Continue;
      AnyAnotherDirectionPool[J] := TDirection(I);
      Inc(J);
    end;

    Result := AnyAnotherDirectionPool[Random(J)];
  end;
var
  P: TPoint;
  Direction: TDirection;
begin
  Randomize();
  P := pFrom;

  Result := [P];

  while P <> pTo do
  begin
    Direction := GetDirectionFromTo(P, pTo);
    if Random() < 0.7 then
      MoveTo(P, Direction)
    else
      MoveTo(P, AnyDirectionBut(Direction));

    Result := Result + [P];
  end;
end;

end.
