unit uCellularAutomaton;

interface

uses
  uWorld, uGenerationAlgorithm;

type
  TCellularAutomaton = class(TGenerationAlgorithm)
  private
    tmpWorld: TWorld;
    function getNeighboursCount(X, Y: Integer): Integer;
  public
    MinNeighbours: Integer;
    MaxNeighbours: Integer;
    procedure NextGeneration(); override;
    procedure SetSettings(Settings: TGenerationSettings); override;
    constructor Create(const World: TWorld); override;
  end;

  TcaSettings = class(TGenerationSettings)
  public
    MinNeighbours: Integer;
    MaxNeighbours: Integer;
  end;

implementation

const
  cellLife = cellWater;

{ TCellularAutomation }

procedure TCellularAutomaton.NextGeneration();
var
  X, Y, NeighboursCount: Integer;
begin
  for Y := 0 to Height - 1 do
    for X := 0 to Width - 1 do
    begin
      NeighboursCount := getNeighboursCount(X, Y);
      if (World[X, Y] = cellEmpty) and (NeighboursCount = 3) then
        tmpWorld[X, Y] := cellLife
      else if (NeighboursCount > MinNeighbours) and (NeighboursCount < MaxNeighbours) then
        tmpWorld[X, Y] := cellLife
      else
        tmpWorld[X, Y] := cellEmpty;
    end;

  for Y := 0 to Height - 1 do
    for X := 0 to Width - 1 do
      World[X, Y] := tmpWorld[X, Y];
end;

constructor TCellularAutomaton.Create(const World: TWorld);
begin
  inherited;

  tmpWorld := TWorld.GetWorldOfValue(Width, Height, cellEmpty);
end;

function TCellularAutomaton.getNeighboursCount(X, Y: Integer): Integer;
var
  tmpX, tmpY, tmpX2, tmpY2: Integer;
begin
  Result := 0;
  for tmpY := Y-1 to Y+1 do
    for tmpX := X-1 to X+1 do
    begin
      if tmpX < 0 then
        tmpX2 := Width - 1
      else if tmpX >= Width then
        tmpX2 := 0
      else
        tmpX2 := tmpX;

      if tmpY < 0 then
        tmpY2 := Height - 1
      else if tmpY >= Height then
        tmpY2 := 0
      else
        tmpY2 := tmpY;


      if World[tmpX2, tmpY2] = cellLife then
        Inc(Result);
    end;
end;

procedure TCellularAutomaton.SetSettings(Settings: TGenerationSettings);
begin
  if not (Settings is TcaSettings) then
    Exit();

  Self.MinNeighbours := TcaSettings(Settings).MinNeighbours;
  Self.MaxNeighbours := TcaSettings(Settings).MaxNeighbours;
end;

end.
