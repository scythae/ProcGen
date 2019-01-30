unit uWorld;

interface

uses
  Types;

type
  TCell = Integer;
  PCell = ^TCell;

  TWorld = class
  private
    Storage: TArray<TArray<TCell>>;
    FWidth: Integer;
    FHeight: Integer;
    function GetCell(X, Y: Integer): TCell;
    procedure SetCell(X, Y: Integer; const Value: TCell);
    function GetCellPointer(X, Y: Integer): PCell;
    procedure SetCellPointer(X, Y: Integer; const Value: PCell);
  public
    IgnoreBounds: Boolean;
    property Cell[X, Y: Integer]: TCell read GetCell write SetCell; default;
    property CellPointer[X, Y: Integer]: PCell read GetCellPointer write SetCellPointer;
    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
    procedure RefineCoords(var X, Y: Integer);
    constructor Create(Width, Height: Integer);
    class function GetRandomWorld(Width, Height: Integer): TWorld;
    class function GetEmptyWorld(Width, Height: Integer): TWorld;
  end;

implementation

constructor TWorld.Create(Width, Height: Integer);
begin
  FWidth := Width;
  FHeight := Height;

  SetLength(Storage, Width, Height);
end;

function TWorld.GetCell(X, Y: Integer): TCell;
begin
  RefineCoords(X, Y);
  Result := Storage[X, Y];
end;

function TWorld.GetCellPointer(X, Y: Integer): PCell;
begin
  RefineCoords(X, Y);
  Result := @(Storage[X, Y]);
end;

procedure TWorld.SetCell(X, Y: Integer; const Value: TCell);
begin
  RefineCoords(X, Y);
  Storage[X, Y] := Value;
end;

procedure TWorld.SetCellPointer(X, Y: Integer; const Value: PCell);
begin
  RefineCoords(X, Y);
  Storage[X, Y] := Value^;
end;

procedure TWorld.RefineCoords(var X, Y: Integer);
begin
  if IgnoreBounds then
  begin
    if X < 0 then
      X := Width - 1 - X mod Width
    else if X >= Width then
      X := X mod Width;

    if Y < 0 then
      Y := Height - 1 - X mod Height
    else if Y >= Height then
      Y := Y mod Height;
  end
  else
  begin
    if X < 0 then
      X := 0
    else if X >= Width then
      X := Width - 1;

    if Y < 0 then
      Y := 0
    else if Y >= Height then
      Y := Height - 1;
  end;
end;

class function TWorld.GetEmptyWorld(Width, Height: Integer): TWorld;
var
  X, Y: Integer;
begin
  Result := TWorld.Create(Width, Height);

  for Y := 0 to Height - 1 do
    for X := 0 to Width - 1 do
        Result[X, Y] := 0;
end;

class function TWorld.GetRandomWorld(Width, Height: Integer): TWorld;
var
  X, Y: Integer;
begin
  Result := TWorld.Create(Width, Height);

  for Y := 0 to Height - 1 do
    for X := 0 to Width - 1 do
      if Random() < 0.1 then
        Result[X, Y] := 1;
end;

end.
