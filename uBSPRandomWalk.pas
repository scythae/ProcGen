unit uBSPRandomWalk;

interface

uses
  Types, SysUtils,
  uBSPRoom, uWorld, uGenerationAlgorithm, uBSP, uRandomWalk, uUtils;

type
  TBSPRandomWalk = class(TGenerationAlgorithm)
  private
    BSP: TBSP;
    RandomWalk: TRandomWalk;
    Root: TBSPRoom;
    Current: TBSPRoom;
    Era: (eraDividing, eraWalking, eraConnecting);
    procedure InitRandomWalk();
    procedure NextGenerationOfDividing();
    procedure NextGenerationOfConnecting();
    procedure NextGenerationOfWalking();
    procedure UniteRoomsAndPassages();
  public
    procedure NextGeneration(); override;
    procedure SetSettings(Settings: TGenerationSettings); override;
    constructor Create(const World: TWorld); override;
    destructor Destroy(); override;
  end;

implementation

constructor TBSPRandomWalk.Create(const World: TWorld);
begin
  inherited;

  BSP := TBSP.Create(World);
  RandomWalk := TRandomWalk.Create(World);

  World.FillWith(cellEmpty);
  Era := eraDividing;
end;

destructor TBSPRandomWalk.Destroy();
begin
  FreeAndNil(BSP);
  FreeAndNil(RandomWalk);
  inherited;
end;

procedure TBSPRandomWalk.SetSettings(Settings: TGenerationSettings);
begin
  if (BSP <> nil) then
    BSP.SetSettings(Settings);

  if (RandomWalk <> nil) then
    RandomWalk.SetSettings(Settings);
end;

procedure TBSPRandomWalk.NextGeneration();
begin
  if Finished then
    Exit();

  if (Era = eraDividing) then
    NextGenerationOfDividing()
  else if (Era = eraWalking) then
    NextGenerationOfWalking()
  else
    NextGenerationOfConnecting();
end;

procedure TBSPRandomWalk.NextGenerationOfDividing();
begin
  if BSP.Finished then
  begin
    Root := BSP.GetRoot();
    Root.UnvisitAll();
    Current := Root;

    Sleep(500);

    World.FillWith(cellRock);
    InitRandomWalk();
    Era := eraWalking;
    Exit();
  end;

  BSP.NextGeneration();

  if BSP.Finished then
  begin
    World.ReplaceCells(cellRock, cellEmpty);
  end;
end;

procedure TBSPRandomWalk.InitRandomWalk();
var
  Walkers: TArray<TWalker>;
  Rect: TRect;
  Room: TBSPRoom;
  WalkerMaximumCells: Integer;
  WalkerId: Integer;
begin
  WalkerId := cellGrass;

  for Room in Root.GetLeafRooms() do
  begin
    Rect := Room.GetRect();
    WalkerMaximumCells := Rect.Width * Rect.Height div 2;

    Walkers := Walkers + [TWalker.Create(
      Rect.CenterPoint, WalkerId, WalkerMaximumCells
    )];

    Inc(WalkerId);
  end;

  RandomWalk.SetWalkers(Walkers);
end;

procedure TBSPRandomWalk.NextGenerationOfWalking();
begin
  RandomWalk.NextGeneration();

  if RandomWalk.Finished then
  begin
    Current := Root;
    Root.UnvisitAll();
    Era := eraConnecting;
  end;
end;

procedure TBSPRandomWalk.NextGenerationOfConnecting();
var
  P: TPoint;
begin
  if (Current = nil) then
  begin
    UniteRoomsAndPassages();
    BSP.ColonizeRoomCentersWithCell(cellGrass);
    Finish();
    Exit();
  end;

  if (Current.Room1 <> nil) and (Current.Room2 <> nil) then
  begin
    for P in GetRandomWayFromTo(Current.Room1.GetRect().CenterPoint, Current.Room2.GetRect().CenterPoint) do
      World[P.X, P.Y] := cellGrass;
  end;

  Current := Current.GetNextRoom();
end;

procedure TBSPRandomWalk.UniteRoomsAndPassages();
begin
  World.ReplaceAllCellsExceptWith(cellRock, cellEmpty);
end;

end.
