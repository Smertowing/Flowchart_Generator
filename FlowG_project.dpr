program FlowG_project;

uses
  Vcl.Forms,
  MainUn in '..\..\Flowchart_Generator\Flowchart_BKit\MainUn.pas' {Form1},
  Model in '..\..\Flowchart_Generator\Flowchart_BKit\Units\Model.pas',
  TypesAndVars in '..\..\Flowchart_Generator\Flowchart_BKit\Units\TypesAndVars.pas',
  GraphicStruc in '..\..\Flowchart_Generator\Flowchart_BKit\Units\GraphicStruc.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFlowchart_Manager, Flowchart_Manager);
  Application.Run;
end.
