unit uRandomWalk;

interface

uses
  Classes, Types,

  uWorld, uGenerationAlgorithm;

type
  TWalker = record
  private
    VisitedCells: Cardinal;
    MaxCellCount: Cardinal;
    function GetFinished(): Boolean;
  public
    Point: TPoint;
    Id: Integer;
    class function Create(StartPoint: TPoint; Id: Integer; MaxCellCount: Cardinal): TWalker; static;
  end;

  TRandomWalk = class(TGenerationAlgorithm)
  private
    Walkers: TArray<TWalker>;
    GenerationsMultiplier: Integer;
    procedure MoveWalker(var Walker: TWalker);
    procedure NextGenerationInternal();
    procedure SetDefaultWalkers;
  public
    procedure NextGeneration(); override;
    procedure SetSettings(Settings: TGenerationSettings); override;
    constructor Create(const World: TWorld; Walkers: TArray<TWalker> = nil); reintroduce;
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
  AllWalkersFinished: Boolean;
begin
  if Finished then
    Exit();

  AllWalkersFinished := True;
  for I := 0 to Length(Walkers) - 1 do
  begin
    MoveWalker(Walkers[I]);
    AllWalkersFinished := AllWalkersFinished and Walkers[I].GetFinished();
  end;

  if AllWalkersFinished then
    Finish();
end;

procedure TRandomWalk.MoveWalker(var Walker: TWalker);
var
  Direction: Integer;
  P: TPoint;
  Cell: TCell;
begin
  if Walker.VisitedCells >= Walker.MaxCellCount then
    Exit();

  P := Walker.Point;

  Direction := Random(4);
  case Direction of
    0: Inc(P.Y);
    1: Dec(P.Y);
    2: Dec(P.X);
    3: Inc(P.X);
  end;

  World.RefineCoords(P.X, P.Y);

  Cell := World[P.X, P.Y];
  if (Cell <> 0) and (Cell <> Walker.Id) then
    Exit();

  World[P.X, P.Y] := Walker.Id;

  Walker.Point := P;
  Inc(Walker.VisitedCells);
end;

procedure TRandomWalk.SetSettings(Settings: TGenerationSettings);
var
  I: Integer;
begin
  if not (Settings is TrwSettings) then
    Exit();

  for I := 0 to High(Walkers) do
    Walkers[I].MaxCellCount := TrwSettings(Settings).MaximumCells;
end;

constructor TRandomWalk.Create(const World: TWorld; Walkers: TArray<TWalker> = nil);
begin
  inherited Create(World);

  GenerationsMultiplier := 10;

  SetDefaultWalkers();

  NextGeneration();
end;

procedure TRandomWalk.SetDefaultWalkers();
var
  I: Integer;
  StartPoint: TPoint;
begin
  SetLength(Walkers, 4);

  StartPoint.X := Width div 4 + Random(Width div 2);
  StartPoint.Y := Height div 4 + Random(Height div 2);

  for I := 0 to Length(Walkers) - 1 do
  begin
    Walkers[I] := TWalker.Create(StartPoint, 1, High(Cardinal));
  end;
end;

{ TWalker }

class function TWalker.Create(StartPoint: TPoint; Id: Integer;
  MaxCellCount: Cardinal): TWalker;
begin
  Result.Point := StartPoint;
  Result.Id := Id;
  Result.MaxCellCount := MaxCellCount;
  Result.VisitedCells := 0;
end;

function TWalker.GetFinished(): Boolean;
begin
  Result := VisitedCells >= MaxCellCount;
end;

end.
