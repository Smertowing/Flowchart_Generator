unit draw.Model;

interface
  uses TypesAndVars, draw.Structures, data.Model,
       Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
       Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls,
       Vcl.ExtCtrls;

  procedure CreatingDrawModel(Form: TForm; paintBox: TPaintBox);

implementation

const
  skipSpace = 50;

var
  pbMain: TPaintBox;
  TempTreeStructure: PTreeStructure;
  CurrentLine: integer;
  CurrX, CurrY: integer;

procedure CreateDrawUnit(var DrawUnit: PDrawList);
begin
  New(DrawUnit);
  SetLength (DrawUnit^.children, 0);
  DrawUnit^.chAvailable := False;
  DrawUnit^.numberOfChildren := 0;
//  DrawUnit^.next := nil;
  DrawUnit^.branch := nil;
  DrawUnit^.structure := Another;
end;

{ procedure CopyingTree();
begin
  drawList := CreateDraUnit();
  DrawList^.branch := TreeStructure;
  DrawList^.height := 0;
  DrawList^.width := 0;
end;
                             }

procedure DeclStruct(var Structure: TStructuresList; i: integer);
begin
  case i of
    1: Structure := Terminator;
    2: Structure := Terminator;
    3: Structure := Choice;
    4: Structure := Loop;
    5: Structure := Loop;
    6: Structure := Loop;
    7: Structure := Block;
  else
    Structure := Another;
  end;
end;

procedure FillDrawUnit(var DList: PDrawList; Tree: PTreeStructure);
var
  i,k: integer;
begin
  K:=0;
  while  k <= Tree^.NumberOfChildren-1 do
  begin
    Inc(DList^.numberOfChildren);
    SetLength(DList^.children, DList^.numberOfChildren);
    CreateDrawUnit(DList^.children[k]);
    FillDrawUnit(Dlist^.children[k], Tree^.Children[k]);
    Inc(k);
  end;

  DList^.height := 50;
  DList^.width := 100;
  if DList^.numberOfChildren <> 0 then
    DList^.chAvailable := True
  else
    DList^.chAvailable := False;
  DList^.branch := Tree;
  DList^.caption := Tree^.BlockName;

  i:=1;
  while i<=numberOfBlockDecl do
      begin
        if checkStr(DList^.caption, trim(BlockDeclNames[i])) then
          DeclStruct(DList^.structure, i);
      inc(i);
      end;

end;

{ procedure DrawBlock(x,y,Width,Height,i: Integer; var DList: PDrawList);
begin
  case i of
    1: drawTerminator(pbMain,x,y,Width,Height,0);
    2: drawTerminator(pbMain,x,y,Width,Height,0);
    3: drawBinaryChoice(pbMain,x,y,Width,Height,0);
    4: drawLoop(pbMain,x,y,Width,Height,0);
    5: drawLoop(pbMain,x,y,Width,Height,0);
    6: drawLoop(pbMain,x,y,Width,Height,0);
    7: drawFunctionalBlock(pbMain,x,y,Width,Height,0);
  end;
end;            }

procedure DrawProccesingRec(var DList: PDrawList; var SpaceX, SpaceY: integer);
var
  i, tempSpaceX, tempSpaceY, tempWidth, tempHeight: integer;
  x, y: integer;
  NothingToDo:boolean;
begin
  y:=CurrY;
  x:=Currx-Round(DList^.width/2);
  tempSpaceX:=0;
  tempSpaceY:=0;
  if DList^.chAvailable then
    begin
    i:=0;
    CurrY:=CurrY+skipSpace;
    while i <= DList^.numberOfChildren-1 do
      begin
      DrawProccesingRec(DList^.children[i], tempSpaceX, tempSpaceY);
      Inc(i);
      end;
    end;

  tempSpaceY := SpaceY+skipSpace;
  tempSpaceX := DList^.width;


  i:=1;
  NothingToDo:=true;
  {  while i<=numberOfBlockDecl do
      begin
        if checkStr(DList^.caption, trim(BlockDeclNames[i])) then
          begin
            DrawBlock(x,y,tempSpaceX,tempSpaceY,i,DList);
            NothingToDo := False;
          end;
      inc(i);
      end;           }

  case DList^.structure of
    Terminator: drawTerminator(pbMain,x,y,tempSpaceX,DList^.height, tempspaceY);
    Choice: drawBinaryChoice(pbMain,x,y,tempSpaceX,DList^.height,tempspaceY);
    DataBlock: drawDataBlock(pbMain,x,y,tempSpaceX,DList^.height,tempspaceY);
    Loop: drawLoop(pbMain,x,y,tempSpaceX,DList^.height,tempspaceY);
    Block: drawFunctionalBlock(pbMain,x,y,tempSpaceX,DList^.height,tempspaceY);
   end;

  SpaceY := SpaceY+DList^.Height+skipSpace;
end;

procedure CreatingDrawModel(Form: TForm; paintBox: TPaintBox);
var
  x, y: Integer;
begin
  pbMain:=PaintBox;
  CreateDrawUnit(DrawList);
  FillDrawUnit(DrawList, TreeStructure);

  CurrX := 300;
  CurrY := 100;
  x:=0;
  y:=0              ;
  DrawProccesingRec(DrawList, x, y);
end;


end.
