unit uGenerationAlgorithm;

interface

uses
  uWorld;

type
  TGenerationSettings = class
  end;

  TGenerationAlgorithm = class
  protected
    World: TWorld;
    Width: Integer;
    Height: Integer;
  public
    procedure NextGeneration(); virtual; abstract;
    procedure SetSettings(Settings: TGenerationSettings); virtual;
    constructor Create(const World: TWorld); virtual;
  end;

implementation

{ TGenerationAlgorithm }

constructor TGenerationAlgorithm.Create(const World: TWorld);
begin
  Self.World := World;
  Width := World.Width;
  Height := World.Height;
end;

procedure TGenerationAlgorithm.SetSettings(Settings: TGenerationSettings);
begin

end;

end.
