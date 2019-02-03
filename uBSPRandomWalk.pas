unit uBSPRandomWalk;

interface

uses
  Types, SysUtils,
  uBSPRoom, uWorld, uGenerationAlgorithm, uRandomWalk, uUtils;

type
  TBSPRandomWalk = class(TGenerationAlgorithm)
  private
    RandomWalk: TGenerationAlgorithm;
    Root: TBSPRoom;
    Current: TBSPRoom;
    Generation: Integer;
    Era: (eraWalking, eraConnecting);
    procedure NextGenerationOfConnecting();
    procedure NextGenerationOfWalking();
    procedure InitRandomWalk;
    procedure PrintRooms;
  public
    procedure NextGeneration(); override;
    constructor Create(const World: TWorld); override;
    destructor Destroy(); override;
  end;

implementation

constructor TBSPRandomWalk.Create(const World: TWorld);
begin
  inherited;
  Root := TBSPRoom.Create(Rect(0, 0, World.Width - 1, World.Height - 1));
  Root.RandomDivide();
  Current := Root;
  Generation := 1;
  Era := eraWalking;
//  Era := eraConnecting;

//  PrintRooms();

  InitRandomWalk();
end;

procedure TBSPRandomWalk.InitRandomWalk();
var
  Walkers: TArray<TWalker>;
  Rect: TRect;
  Room: TBSPRoom;
  WalkerMaximumCells: Integer;
  WalkerId: Integer;
begin
  WalkerId := 1;
  for Room in Root.GetLeafRooms() do
  begin
    Rect := Room.GetRect();
    WalkerMaximumCells := Rect.Width * Rect.Height div 3;

    Walkers := Walkers + [TWalker.Create(
      Rect.CenterPoint, WalkerId, WalkerMaximumCells
    )];

    Inc(WalkerId);
  end;

  RandomWalk := TRandomWalk.Create(World, Walkers);
end;


procedure TBSPRandomWalk.PrintRooms();
var
  Room: TBSPRoom;
  Wall: TPoint;
begin
  for Room in Root.GetLeafRooms() do
    for Wall in GetPerimeterPoints(Room.GetRect()) do
      World[Wall.X, Wall.Y] := 3000;
end;

destructor TBSPRandomWalk.Destroy();
begin
  FreeAndNil(RandomWalk);
  FreeAndNil(Root);
  inherited;
end;

procedure TBSPRandomWalk.NextGeneration();
begin
  if Finished then
    Exit();

  if (Era = eraWalking) then
    NextGenerationOfWalking()
  else
    NextGenerationOfConnecting();
end;

procedure TBSPRandomWalk.NextGenerationOfWalking();
begin
  RandomWalk.NextGeneration();
  Inc(Generation);

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
    Finish();
    Exit();
  end;

  if (Current.Room1 <> nil) and (Current.Room2 <> nil) then
  begin
    for P in GetRandomWayFromTo(Current.Room1.GetRect().CenterPoint, Current.Room2.GetRect().CenterPoint) do
      World[P.X, P.Y] := 10;
  end;

  Current := Current.GetNextRoom();
  Inc(Generation);
end;

end.
