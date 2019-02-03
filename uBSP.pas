unit uBSP;

interface

uses
  Types, SysUtils,
  uBSPRoom, uWorld, uGenerationAlgorithm, uUtils;

type
  TBSP = class(TGenerationAlgorithm)
  private
    Root: TBSPRoom;
    Current: TBSPRoom;
    Era: (eraDividing, eraConnecting);
    procedure NextGenerationOfDividing();
    procedure NextGenerationOfConnecting;
    procedure UniteRoomsAndPassages;
  public
    procedure NextGeneration(); override;
    constructor Create(const World: TWorld); override;
    destructor Destroy(); override;
    function GetRoot(): TBSPRoom;
    procedure ColonizeRoomCentersWithCell(CellId: Integer);
  end;

implementation

constructor TBSP.Create(const World: TWorld);
begin
  inherited;
  Root := TBSPRoom.Create(Rect(0, 0, World.Width - 1, World.Height - 1));
  Root.RandomDivide();
  Current := Root.GetNextRoom();
  Era := eraDividing;
end;

destructor TBSP.Destroy();
begin
  FreeAndNil(Root);
  inherited;
end;

function TBSP.GetRoot: TBSPRoom;
begin
  Result := Root;
end;

procedure TBSP.NextGeneration();
begin
  if Finished then
    Exit();

  if (Era = eraDividing) then
    NextGenerationOfDividing()
  else
    NextGenerationOfConnecting();
end;

procedure TBSP.NextGenerationOfDividing();
var
  Wall: TPoint;
begin
  if (Current = nil) then
    Exit();

  for Wall in GetPerimeterPoints(Current.GetRect()) do
    World[Wall.X, Wall.Y] := cellRock;

  Current := Current.GetNextRoom();
  if (Current = nil) then
  begin
    Current := Root;
    Root.UnvisitAll();
    Era := eraConnecting;
  end;
end;

procedure TBSP.NextGenerationOfConnecting();
var
  P: TPoint;
begin
  if (Current = nil) then
  begin
    Finish();
    Exit();
  end;

  if (Current.Room1 <> nil) or (Current.Room2 <> nil) then
    for P in GetLinePoints(Current.Room1.GetRect().CenterPoint, Current.Room2.GetRect().CenterPoint) do
      World[P.X, P.Y] := cellGrass;

  Current := Current.GetNextRoom();

  if (Current = nil) then
  begin
    UniteRoomsAndPassages();
    ColonizeRoomCentersWithCell(cellGrass);
  end;
end;

procedure TBSP.UniteRoomsAndPassages();
begin
  World.ReplaceAllCellsExceptWith(cellRock, cellEmpty);
end;

procedure TBSP.ColonizeRoomCentersWithCell(CellId: Integer);
var
  P: TPoint;
  Room: TBSPRoom;
begin
  for Room in Root.GetLeafRooms() do
  begin
    P := Room.GetRect().CenterPoint;
    World[P.X, P.Y] := CellId;
  end;
end;

end.
