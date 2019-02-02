unit uUtils;

interface

uses
  Types;

function GetLinePoints(pFrom, pTo: TPoint): TArray<TPoint>;

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

end.
