unit MainUn;

interface

uses
  TypesAndVars, data.Model, draw.Structures, draw.Model, Screen,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, System.Actions, Vcl.ActnList;

type
  TFlowchart_Manager = class(TForm)
    pnlMemoTree: TPanel;
    trMainTree: TTreeView;
    mmoMainMemo: TMemo;
    splMemoTree: TSplitter;
    MainMenu: TMainMenu;
    scrMain: TScrollBox;
    pbMain: TPaintBox;
    dlgOpenFile: TOpenDialog;
    alMain: TActionList;
    fileOpen: TAction;
    fileSave: TAction;
    fileSaveAs: TAction;
    File1: TMenuItem;
    Open1: TMenuItem;
    fileOpen1: TMenuItem;
    fileSaveAs1: TMenuItem;
    btnTemp: TButton;
    procedure StartRoutine();
    procedure createtree();
    procedure FormDestroy(Sender: TObject);
    procedure RecTreeConstructor(const shift: Integer; TempTreeStructure: PTreeStructure);
    procedure btnTempClick(Sender: TObject);
    procedure pbMainPaint(Sender: TObject);
    procedure scrMainMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure fileOpenExecute(Sender: TObject);
    

  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  Flowchart_Manager: TFlowchart_Manager;
  FileUsed: TextFile;
  TempNode: TTreeNode;
  CurrentMaxNode: Integer;

implementation

{$R *.dfm}

procedure TFlowchart_Manager.FormDestroy(Sender: TObject);
begin
strList.Free;
if TreeStructure <> nil then
  EraseTree(TreeStructure);
end;

procedure TFlowchart_Manager.pbMainPaint(Sender: TObject);
begin
  if DrawList <> nil then
    screenUpdate(Flowchart_Manager,pbMain);

end;

procedure TFlowchart_Manager.RecTreeConstructor(const shift: Integer; TempTreeStructure: PTreeStructure);
var
  i: Integer;
  tempI: Integer;
  tempShift: Integer;
begin
  i := 1;
  while i <= TempTreeStructure^.NumberOfChildren do
    begin
    inc(currentMaxNode);
    trMainTree.Items.AddChild(trMainTree.Items[shift], TempTreeStructure^.Children[i-1]^.BlockName);

    if TempTreeStructure^.Children[i-1]^.NumberOfChildren > 0 then
      begin
      tempI := CurrentMaxNode;
      RecTreeConstructor(tempI, TempTreeStructure^.Children[i-1]);
      end;

    inc(i);
    end;

end;

procedure TFlowchart_Manager.scrMainMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  (Sender as TScrollBox).VertScrollBar.Position := (Sender as TScrollBox).VertScrollBar.Position - (Sender as TScrollBox).VertScrollBar.Increment;
end;

procedure TFlowchart_Manager.btnTempClick(Sender: TObject);
begin
//  drawTerminator(pbMain,50,50,100,50);
//  drawFunctionalBlock(pbMain, 50,50,100,50);
//  drawBinaryChoice(pbMain,50,50,100,50);
//  drawLoop(pbMain,50,50,100,50,400)
//  drawDataBlock(pbMain,50,50,100,50);
  if TreeStructure <> nil then
    CreatingDrawModel(Flowchart_Manager, pbMain);
end;

procedure TFlowchart_Manager.CreateTree();
var
  i: Integer;
begin
trMainTree.Items.Clear;
trMainTree.Items.Add(nil, StrList[0]);
CurrentMaxNode := 0;
RecTreeConstructor(0, TreeStructure);
end;


procedure TFlowchart_Manager.fileOpenExecute(Sender: TObject);
begin
  if dlgOpenFile.Execute then
    CurrentFile := dlgOpenFile.FileName;
  TreeStructure := nil;
  StartRoutine();
  CreatingDataModel();
  createtree;
end;

procedure TFlowchart_Manager.StartRoutine();
var   S:string;
begin
mmoMainMemo.Lines.Clear;

if FileExists(currentFile) then
  mmoMainMemo.Lines. LoadFromFile(currentFile);

AssignFile(FileUsed, currentFile);
Reset(FileUsed);

StrList:=TStringList.Create;
StrList.Sorted:=False;
StrList.Duplicates:=dupAccept;

while not Eof(FileUsed) do
  begin
  Readln(FileUsed, S);
  StrList.Add(S)
  end;

CloseFile(FileUsed);
end;




end.
