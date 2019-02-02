unit uGenerationAlgorithm;

interface

uses
  uWorld;

type
  TGenerationSettings = class
  end;

  TGenerationAlgorithm = class
  private
    FFinished: Boolean;
  protected
    World: TWorld;
    Width: Integer;
    Height: Integer;
    procedure Finish();
  public
    procedure NextGeneration(); virtual; abstract;
    procedure SetSettings(Settings: TGenerationSettings); virtual;
    constructor Create(const World: TWorld); virtual;
    property Finished: Boolean read FFinished;
  end;

implementation

{ TGenerationAlgorithm }

constructor TGenerationAlgorithm.Create(const World: TWorld);
begin
  Self.World := World;
  Width := World.Width;
  Height := World.Height;
  FFinished := False;
end;

procedure TGenerationAlgorithm.Finish();
begin
  FFinished := True;
end;

procedure TGenerationAlgorithm.SetSettings(Settings: TGenerationSettings);
begin

end;

end.
