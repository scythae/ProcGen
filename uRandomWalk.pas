unit uRandomWalk;

interface

uses
  Classes, Types,

  uWorld, uGenerationAlgorithm;

type
  TWalker = record
  strict private const
    MaxFatique = 100;
  strict private
    Fatique: Integer;
    VisitedCells: Cardinal;
  private
    MaxCellCount: Cardinal;
    function GetFinished(): Boolean;
    procedure IncreaseFatique();
    procedure ResetFatique();
    procedure NewCellVisited();
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
    procedure ShowWalkers;
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
  if Walker.GetFinished() then
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

  if (Cell = 0) or (Cell = Walker.Id) then
    Walker.Point := P
  else
    Exit();

  if Cell = Walker.Id then
  begin
    Walker.IncreaseFatique();
    Exit();
  end;

  Walker.NewCellVisited();
  World[P.X, P.Y] := Walker.Id;
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

  if Walkers = nil then
    SetDefaultWalkers()
  else
    Self.Walkers := Walkers;

  ShowWalkers();

  NextGeneration();
end;

procedure TRandomWalk.ShowWalkers();
var
  Walker: TWalker;
begin
  for Walker in Walkers do
  begin
    World[Walker.Point.X, Walker.Point.Y] := Walker.Id;
    Walker.NewCellVisited();
  end;
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
    Walkers[I] := TWalker.Create(StartPoint, I, High(Cardinal));
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
  Result.Fatique := 0;
end;

function TWalker.GetFinished(): Boolean;
begin
  Result := (VisitedCells >= MaxCellCount) or (Fatique >= MaxFatique);
end;

procedure TWalker.IncreaseFatique();
begin
  Inc(Fatique);
end;

procedure TWalker.ResetFatique();
begin
  Fatique := 0;
end;

procedure TWalker.NewCellVisited();
begin
  ResetFatique();
  Inc(VisitedCells);
end;

end.
