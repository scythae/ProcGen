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
    tbGenerationInterval: TTrackBar;
    lGenerationInterval: TLabel;
    lMinimumNeighbours: TLabel;
    tbMinNeighbours: TTrackBar;
    lMaximumNeighbours: TLabel;
    tbMaxNeighbours: TTrackBar;
    tbMaximumCells: TTrackBar;
    rgGenerationType: TRadioGroup;
    lMaximumCells: TLabel;
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
    procedure Restart;
    procedure ReloadSettings();
    procedure TestSomething;
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

procedure TfrMain.TestSomething();
var
  P: TPoint;
begin
  World := TWorld.GetEmptyWorld(WorldWidth, WorldHeight);

  for P in GetRandomWayFromTo(Point(20, 20), Point(60, 60)) do
    World[P.X, P.Y] := 1;

  Repaint();
end;

procedure TfrMain.Restart();
begin
  tmrGeneration.Enabled := False;

  WorldWidth := 100;
  WorldHeight := 100;

  FreeAndNil(Generator);

//  TestSomething();
//  Exit();

  if rgGenerationType.ItemIndex = 0 then
  begin
    World := TWorld.GetRandomWorld(WorldWidth, WorldHeight);
    World.IgnoreBounds := True;
    Generator := TCellularAutomaton.Create(World);
  end;

  if rgGenerationType.ItemIndex = 1 then
  begin
    World := TWorld.GetEmptyWorld(WorldWidth, WorldHeight);
    Generator := TRandomWalk.Create(World);
  end;

  if rgGenerationType.ItemIndex = 2 then
  begin
    World := TWorld.GetEmptyWorld(WorldWidth, WorldWidth);
    Generator := TBSP.Create(World);
  end;

  if rgGenerationType.ItemIndex = 3 then
  begin
    World := TWorld.GetEmptyWorld(WorldWidth, WorldWidth);
    Generator := TBSPRandomWalk.Create(World);
  end;

  ReloadSettings();

  tmrGeneration.Enabled := True;
end;

procedure TfrMain.rgGenerationTypeClick(Sender: TObject);
begin
  tbMinNeighbours.Enabled := rgGenerationType.ItemIndex = 0;
  tbMaxNeighbours.Enabled := rgGenerationType.ItemIndex = 0;
  tbMaximumCells.Enabled := rgGenerationType.ItemIndex = 1;

  Restart();
end;

procedure TfrMain.ReloadSettings();
var
  caSettings: TcaSettings;
  rwSettings: TrwSettings;
begin
  caSettings := TcaSettings.Create();
  caSettings.MinNeighbours := tbMinNeighbours.Position;
  caSettings.MaxNeighbours := tbMaxNeighbours.Position;

  rwSettings := TrwSettings.Create();
  rwSettings.MaximumCells := tbMaximumCells.Position;

  Generator.SetSettings(caSettings);
  Generator.SetSettings(rwSettings);

  tmrGeneration.Interval := tbGenerationInterval.Position;
end;

procedure TfrMain.OnSettingsChange(Sender: TObject);
begin
  ReloadSettings();
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
//  R, G, B: Integer;
begin
  Rect.Left := X * CellSide;
  Rect.Top := Y * CellSide;
  Rect.Width := CellSide;
  Rect.Height := CellSide;

  Canvas.Rectangle(Rect);
//
//  R := Random(55) + 200;
//  G := Random(55) + 200;
//  B := Random(55) + 200;

//
  case CellTypeId of
    0: Canvas.Brush.Color := clGray;
//    1: Canvas.Brush.Color := clBlue;
//    2: Canvas.Brush.Color := clGreen;
//    3: Canvas.Brush.Color := clRed;
    else
      Canvas.Brush.Color := clBlack;
  end;

  Canvas.FillRect(Rect);
end;

end.
