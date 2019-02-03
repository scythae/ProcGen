unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Types, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ComCtrls,

  uWorld,
  uUtils,
  uGenerationAlgorithm,
  uCellularAutomaton,
  uRandomWalk,
  uBSP,
  uBSPRandomWalk;

type
  TSettings = record
    MinNeighbours: Integer;
    MaxNeighbours: Integer;
    TimerInterval: Integer;
  end;

  TfrMain = class(TForm)
    tmrGeneration: TTimer;
    pSettings: TPanel;
    btnRestart: TButton;
    rgGenerationType: TRadioGroup;
    pCASettings: TPanel;
    lMinimumNeighbours: TLabel;
    tbMinNeighbours: TTrackBar;
    lMaximumNeighbours: TLabel;
    tbMaxNeighbours: TTrackBar;
    pRWSettings: TPanel;
    lRWMaximumCells: TLabel;
    tbMaximumCells: TTrackBar;
    pGenerationMultiplier: TPanel;
    lGenerationMultiplier: TLabel;
    tbGenerationMultiplier: TTrackBar;
    pGenerationsInterval: TPanel;
    lGenerationInterval: TLabel;
    tbGenerationInterval: TTrackBar;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure tmrGenerationTimer(Sender: TObject);
    procedure btnRestartClick(Sender: TObject);
    procedure OnSettingsChange(Sender: TObject);
    procedure rgGenerationTypeClick(Sender: TObject);
  private
    World: TWorld;
    Generator: TGenerationAlgorithm;
    WorldWidth: Integer;
    WorldHeight: Integer;
    procedure PrintWorld;
    procedure DrawCell(X, Y, CellTypeId: Integer);
    procedure Restart();
    procedure ReloadGeneratorSettings();
    procedure MakeRandomWayFromTo(pFrom, pTo: TPoint);
  public
    { Public declarations }
  end;

var
  frMain: TfrMain;

implementation

{$R *.dfm}

procedure TfrMain.FormCreate(Sender: TObject);
begin
  Restart();
  rgGenerationTypeClick(nil);
end;

procedure TfrMain.btnRestartClick(Sender: TObject);
begin
  Restart();
end;

procedure TfrMain.MakeRandomWayFromTo(pFrom, pTo: TPoint);
var
  P: TPoint;
begin
  for P in GetRandomWayFromTo(Point(20, 20), Point(60, 60)) do
    World[P.X, P.Y] := cellEmpty;

  Repaint();
end;

procedure TfrMain.Restart();
begin
  tmrGeneration.Enabled := False;

  WorldWidth := 100;
  WorldHeight := 100;

  FreeAndNil(Generator);
  FreeAndNil(World);

  if rgGenerationType.ItemIndex = 0 then
  begin
    World := TWorld.GetRandomFilledWorld(WorldWidth, WorldHeight, cellWater);
    World.IgnoreBounds := True;
    Generator := TCellularAutomaton.Create(World);
  end;

  if rgGenerationType.ItemIndex = 1 then
  begin
    World := TWorld.GetWorldOfValue(WorldWidth, WorldHeight, cellRock);
    Generator := TRandomWalk.Create(World);
  end;

  if rgGenerationType.ItemIndex = 2 then
  begin
    World := TWorld.GetWorldOfValue(WorldWidth, WorldHeight, cellEmpty);
    Generator := TBSP.Create(World);
  end;

  if rgGenerationType.ItemIndex = 3 then
  begin
    World := TWorld.GetWorldOfValue(WorldWidth, WorldHeight, cellRock);
    Generator := TBSPRandomWalk.Create(World);
  end;

  if rgGenerationType.ItemIndex = 4 then
  begin
    World := TWorld.GetWorldOfValue(WorldWidth, WorldHeight, cellRock);
    MakeRandomWayFromTo(Point(20, 20), Point(60, 60));
    Exit();
  end;

  ReloadGeneratorSettings();

  tmrGeneration.Enabled := True;
end;

procedure TfrMain.rgGenerationTypeClick(Sender: TObject);
begin
  pCASettings.Visible := rgGenerationType.ItemIndex = 0;
  pRWSettings.Visible := rgGenerationType.ItemIndex in [1, 3];
  pGenerationMultiplier.Visible := rgGenerationType.ItemIndex in [1, 3];
  pGenerationsInterval.Visible := rgGenerationType.ItemIndex <> 4;

  if rgGenerationType.ItemIndex = 0 then
    tbGenerationInterval.Position := 300
  else
    tbGenerationInterval.Position := 1;

  if rgGenerationType.ItemIndex = 3 then
    tbGenerationMultiplier.Position := 5
  else
    tbGenerationMultiplier.Position := 10;

  Restart();
end;

procedure TfrMain.ReloadGeneratorSettings();
var
  caSettings: TcaSettings;
  rwSettings: TrwSettings;
begin
  if Generator = nil then
    Exit();

  caSettings := TcaSettings.Create();
  caSettings.MinNeighbours := tbMinNeighbours.Position;
  caSettings.MaxNeighbours := tbMaxNeighbours.Position;

  rwSettings := TrwSettings.Create();
  rwSettings.MaximumCells := tbMaximumCells.Position;
  rwSettings.GenerationMultiplier := tbGenerationMultiplier.Position;

  Generator.SetSettings(caSettings);
  Generator.SetSettings(rwSettings);

  FreeAndNil(caSettings);
  FreeAndNil(rwSettings);

  tmrGeneration.Interval := tbGenerationInterval.Position;
end;

procedure TfrMain.OnSettingsChange(Sender: TObject);
begin
  ReloadGeneratorSettings();
end;

procedure TfrMain.tmrGenerationTimer(Sender: TObject);
begin
  Generator.NextGeneration();

  Repaint();

  if Generator.Finished then
    tmrGeneration.Enabled := False;
end;

procedure TfrMain.FormPaint(Sender: TObject);
begin
  PrintWorld();
end;

procedure TfrMain.PrintWorld();
var
  X, Y: Integer;
begin
  for Y := 0 to WorldHeight - 1 do
    for X := 0 to WorldWidth - 1 do
      DrawCell(X, Y, World[X, Y])
end;

procedure TfrMain.DrawCell(X, Y: Integer; CellTypeId: Integer);
const
  CellSide = 10;
var
  Rect: TRect;
  C: TColor;
begin
  Rect.Left := X * CellSide;
  Rect.Top := Y * CellSide;
  Rect.Width := CellSide;
  Rect.Height := CellSide;

  Canvas.Rectangle(Rect);

  case CellTypeId of
    cellEmpty: C := clBlack;
    cellRock: C := clGray;
    cellGrass: C := clGreen;
    cellWater: C := clBlue;
    cellLava: C := clRed;
    else
      C := clOlive;
  end;

  Canvas.Brush.Color := C;
  Canvas.FillRect(Rect);
end;

end.
