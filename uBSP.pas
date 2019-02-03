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
    Generation: Integer;
    Era: (eraDividing, eraConnecting);
    procedure NextGenerationOfDividing();
    procedure NextGenerationOfConnecting;
  public
    procedure NextGeneration(); override;
    constructor Create(const World: TWorld); override;
    destructor Destroy(); override;
  end;

implementation

constructor TBSP.Create(const World: TWorld);
begin
  inherited;
  Root := TBSPRoom.Create(Rect(0, 0, World.Width - 1, World.Height - 1));
  Root.RandomDivide();
  Current := Root.GetNextRoom();
  Generation := 1;
  Era := eraDividing;
end;

destructor TBSP.Destroy();
begin
  FreeAndNil(Root);
  inherited;
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
    World[Wall.X, Wall.Y] := 1;

  Inc(Generation);

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
  begin
    for P in GetLinePoints(Current.Room1.GetRect().CenterPoint, Current.Room2.GetRect().CenterPoint) do
      if World[P.X, P.Y] = 1 then
        World[P.X, P.Y] := 0;
  end;

  Current := Current.GetNextRoom();
  Inc(Generation);
end;

end.
