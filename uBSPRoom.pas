unit uBSPRoom;

interface

uses
  Types, SysUtils, Math,

  uUtils;

type
  TBSPRoom = class
  private
    Rect: TRect;
    Visited: Boolean;
    function GetCentersOfLeafRooms: TArray<TPoint>;
  public
    Parent: TBSPRoom;
    Room1: TBSPRoom;
    Room2: TBSPRoom;
    constructor Create(Rect: TRect; Parent: TBSPRoom = nil);
    destructor Destroy(); override;
    procedure RandomDivide();
    function GetRect(): TRect;
    function GetRects(): TArray<TRect>;
    function GetNextRoom(): TBSPRoom;
    procedure UnvisitAll;
    function GetLeafRooms(): TArray<TBSPRoom>;
    function IsLeafRoom(): Boolean;
  end;

implementation

const
  MinRoomSize = 15;
  MaximumSidesRatio = 2.0;

destructor TBSPRoom.Destroy();
begin
  FreeAndNil(Room1);
  FreeAndNil(Room2);
  inherited;
end;

function TBSPRoom.GetCentersOfLeafRooms(): TArray<TPoint>;
begin
  if IsLeafRoom() then
    Result := [Self.Rect.CenterPoint]
  else
    Result := Room1.GetCentersOfLeafRooms() + Room2.GetCentersOfLeafRooms();
end;

function TBSPRoom.GetLeafRooms(): TArray<TBSPRoom>;
begin
  if IsLeafRoom() then
    Result := [Self]
  else
    Result := Room1.GetLeafRooms() + Room2.GetLeafRooms();
end;


function TBSPRoom.IsLeafRoom(): Boolean;
begin
  Result := (Room1 = nil) or (Room2 = nil);
end;

function TBSPRoom.GetNextRoom(): TBSPRoom;
begin
  if not Visited then
  begin
    Visited := True;
    Exit(Self);
  end;

  if Assigned(Room1) and not Room1.Visited then
    Exit(Room1.GetNextRoom());

  if Assigned(Room2) and not Room2.Visited then
    Exit(Room2.GetNextRoom());

  if Assigned(Parent) then
    Exit(Parent.GetNextRoom());

  Result := nil;
end;

procedure TBSPRoom.UnvisitAll();
begin
  Visited := False;

  if Assigned(Room1) then
    Room1.UnvisitAll();

  if Assigned(Room2) then
    Room2.UnvisitAll();
end;

function TBSPRoom.GetRect(): TRect;
begin
  Result := Rect;
end;

function TBSPRoom.GetRects(): TArray<TRect>;
begin
  Result := [Rect] + Room1.GetRects() + Room2.GetRects();
end;

constructor TBSPRoom.Create(Rect: TRect; Parent: TBSPRoom = nil);
begin
  Self.Rect := Rect;
  Self.Parent := Parent;
end;

procedure TBSPRoom.RandomDivide();
var
  SplitHorizontal: Boolean;
  Border: Integer;
  Rect1, Rect2: TRect;
  SidesRatio: Single;

  procedure DefineDirectionOfSplitting();
  begin
    SidesRatio := Rect.Width / Rect.Height;
    if SidesRatio > MaximumSidesRatio then
      SplitHorizontal := True
    else if (1 / SidesRatio) > MaximumSidesRatio then
      SplitHorizontal := False
    else
      SplitHorizontal := Random() < 0.5;
  end;

  function RoomSize(): Integer;
  begin
    if SplitHorizontal then Exit(Rect.Width) else Exit(Rect.Height);
  end;

  function BorderStart(): Integer;
  begin
    if SplitHorizontal then Exit(Rect.Left) else Exit(Rect.Top);
  end;

  function FindBorder(const MinLimit, MaxLimit: Integer; var Border: Integer): Boolean;
  begin
    Result := MinLimit < MaxLimit;
    if Result then
      Border := RandomRange(MinLimit, MaxLimit) + BorderStart();
  end;
begin
  DefineDirectionOfSplitting();

  if not FindBorder(MinRoomSize, RoomSize() - MinRoomSize, Border) then
    Exit();

  Rect1 := Rect;
  Rect2 := Rect;
  if SplitHorizontal then begin
    Rect1.Right := Border;
    Rect2.Left := Border;
  end else begin
    Rect1.Bottom := Border;
    Rect2.Top := Border;
  end;

  Room1 := TBSPRoom.Create(Rect1, Self);
  Room1.RandomDivide();
  Room2 := TBSPRoom.Create(Rect2, Self);
  Room2.RandomDivide();
end;

end.
