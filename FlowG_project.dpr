program FlowG_project;

uses
  Vcl.Forms,
  MainUn in 'MainUn.pas' {FFlowChart_Manager},
  data.Model in 'Units\data.Model.pas',
  TypesAndVars in 'Units\TypesAndVars.pas',
  draw.Structures in 'Units\draw.Structures.pas',
  draw.Model in 'Units\draw.Model.pas',
  Screen in 'Units\Screen.pas',
  View in 'Units\View.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFFlowchart_Manager, FFlowchart_Manager);
  Application.Run;
end.
