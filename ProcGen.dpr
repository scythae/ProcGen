program ProcGen;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frMain},
  uCellularAutomaton in 'uCellularAutomaton.pas',
  uWorld in 'uWorld.pas',
  uRandomWalk in 'uRandomWalk.pas',
  uGenerationAlgorithm in 'uGenerationAlgorithm.pas',
  uBSP in 'uBSP.pas',
  uBSPRoom in 'uBSPRoom.pas',
  uUtils in 'uUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrMain, frMain);
  Application.Run;
end.
