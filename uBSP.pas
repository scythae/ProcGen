unit uBSP;

interface

uses
  Types, SysUtils,
  uBSPRoom, uWorld, uGenerationAlgorithm;

type
  TBSP = class(TGenerationAlgorithm)
  private
    Root: TBSPRoom;
    Current: TBSPRoom;
    Generation: Integer;
    Era: (eraDividing, eraConnecting);
    function GetRectPoints(Rect: TRect): TArray<TPoint>;
    procedure NextGenerationOfDividing();
    procedure NextGenerationOfConnecting;
  public
    procedure NextGeneration(); override;
    constructor Create(const World: TWorld); override;
    destructor Destroy(); override;
  end;

implementation

function MakeRect(const Left, Top, Right, Bottom: Integer): TRect;
begin
  Result.Left := Left;
  Result.Top := Top;
  Result.Right := Right;
  Result.Bottom := Bottom;
end;
{ TBSP }

constructor TBSP.Create(const World: TWorld);
begin
  inherited;
  Root := TBSPRoom.Create(MakeRect(0, 0, World.Width - 1, World.Height - 1));
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

function TBSP.GetRectPoints(Rect: TRect): TArray<TPoint>;
var
  Width, Height: Integer;
  X, Y: Integer;
  I: Integer;

  procedure AddPoint();
  begin
    Result[I] := Point(Rect.Left + X, Rect.Top + Y);
    Inc(I);
  end;
begin
  Width := Rect.Right - Rect.Left + 1;
  Height := Rect.Bottom - Rect.Top + 1;
  if (Width <= 0) or (Height <= 0) then
    Exit();

  SetLength(Result, Width * 2 + Height * 2 - 4);
  I := 0;

  Y := 0;
  for X := 0 to Width - 1 do
    AddPoint();

  X := Width - 1;
  for Y := 1 to Height - 2 do
    AddPoint();

  Y := Height - 1;
  for X := Width - 1 downto 0 do
    AddPoint();

  X := 0;
  for Y := Height - 2 downto 1 do
    AddPoint();
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

  for Wall in GetRectPoints(Current.GetRect()) do
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

  for P in Current.GetPointsOfLineBetweenSubrooms() do
    if World[P.X, P.Y] = 1 then
      World[P.X, P.Y] := 0;

  Current := Current.GetNextRoom();
  Inc(Generation);
end;

end.
