unit uRandomWalk;

interface

uses
  Classes, Types,

  uWorld, uGenerationAlgorithm;

type
  TWalker = record
    Point: TPoint;
    Id: Integer;
  end;

  TRandomWalk = class(TGenerationAlgorithm)
  private
    Walkers: TArray<TWalker>;
    VisitedCells: Cardinal;
    GenerationsMultiplier: Integer;
    MaximumCells: Cardinal;
    WalkerSize: Integer;
    procedure Visit(const Walker: TWalker);
    procedure MoveWalker(var Walker: TWalker);
    procedure NextGenerationInternal();
    function GetCellsOccupiedByWalker(Walker: TWalker): TArray<PCell>;
  public
    procedure NextGeneration(); override;
    procedure SetSettings(Settings: TGenerationSettings); override;
    constructor Create(const World: TWorld); override;
  end;

  TrwSettings = class(TGenerationSettings)
  public
    MaximumCells: Cardinal;
  end;

implementation

{ TRandomWalk }

procedure TRandomWalk.NextGeneration();
var
  I: Integer;
begin
  for I := 0 to GenerationsMultiplier do
    NextGenerationInternal();
end;

procedure TRandomWalk.NextGenerationInternal();
var
  I: Integer;
begin
  if VisitedCells >= MaximumCells then
    Exit();

  for I := 0 to Length(Walkers) - 1 do
  begin
    MoveWalker(Walkers[I]);
    Visit(Walkers[I]);
  end;
end;

procedure TRandomWalk.MoveWalker(var Walker: TWalker);
var
  Direction: Integer;
  P: TPoint;
  Cell: TCell;
begin
  P := Walker.Point;

  Direction := Random(4);
//  case Direction of
//    0:
//      if P.Y < Height-1 then
//        Inc(P.Y);
//    1:
//      if P.Y > 0 then
//        Dec(P.Y);
//    2:
//      if P.X > 0 then
//        Dec(P.X);
//    3:
//      if P.X < Width-1 then
//        Inc(P.X);
//  end;

  case Direction of
    0: Inc(P.Y, WalkerSize);
    1: Dec(P.Y, WalkerSize);
    2: Dec(P.X, WalkerSize);
    3: Inc(P.X, WalkerSize);
  end;

  World.RefineCoords(P.X, P.Y);

  Cell := World[P.X, P.Y];
  if (Cell = 0) or (Cell = Walker.Id) then
    Walker.Point := P;
end;

procedure TRandomWalk.Visit(const Walker: TWalker);
var
  Cell: PCell;
begin
  for Cell in GetCellsOccupiedByWalker(Walker) do
    if (Cell^ = 0) and (Cell^ <> Walker.Id) then
    begin
      Cell^ := Walker.Id;
      Inc(VisitedCells);
    end;
end;

function TRandomWalk.GetCellsOccupiedByWalker(Walker: TWalker): TArray<PCell>;

  procedure AddCell(const OffsetX, OffsetY: Integer);
  begin
    Result := Result + [World.CellPointer[Walker.Point.X + OffsetX, Walker.Point.Y + OffsetY]];
  end;

var
  OffsetX, OffsetY: Integer;
begin

  for OffsetY := 0 to WalkerSize - 1 do
    for OffsetX := 0 to WalkerSize - 1 do
      AddCell(OffsetX, OffsetY);
end;

procedure TRandomWalk.SetSettings(Settings: TGenerationSettings);
begin
  if not (Settings is TrwSettings) then
    Exit();

  Self.MaximumCells := TrwSettings(Settings).MaximumCells;
end;

constructor TRandomWalk.Create(const World: TWorld);
var
  I: Integer;
  StartPoint: TPoint;
begin
  inherited;

  SetLength(Walkers, 4);
  GenerationsMultiplier := 10;
  WalkerSize := 1;

  StartPoint.X := Random(Width);
  StartPoint.Y := Random(Height);

  for I := 0 to Length(Walkers) - 1 do
  begin
    Walkers[I].Point.X := StartPoint.X;
    Walkers[I].Point.Y := StartPoint.Y;
    Walkers[I].Id := I + 1;
  end;

  VisitedCells := 0;

  NextGeneration();
end;

end.
