unit draw.Model;

interface
  uses TypesAndVars, draw.Structures, data.Model,
       Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
       Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls,
       Vcl.ExtCtrls;

  procedure drawModel(Form: TForm; paintBox: TPaintBox);
  procedure CreatingDrawModel(Form: TForm; paintBox: TPaintBox);

implementation


var
  pbBox: TPaintBox;
//  TempTreeStructure: PTreeStructure;
//  CurrentLine: integer;

procedure CreateDrawUnit(var DrawUnit: PDrawList);
begin
  New(DrawUnit);
  SetLength(DrawUnit^.children, 0);
  DrawUnit^.chAvailable := False;
  DrawUnit^.numberOfChildren := 0;
//  DrawUnit^.next := nil;
  DrawUnit^.branch := nil;
  DrawUnit^.structure := Another;
end;

procedure DeclStruct(var Structure: TStructuresList; i: integer);
begin
  case i of
    1,2: Structure := Terminator;
    3: Structure := Choice;
    4,5,6: Structure := Loop;
    7,8: Structure := Block;
  else
    Structure := Another;
  end;
end;

procedure FillDrawUnit(var DList: PDrawList; Tree: PTreeStructure);
var
  i,k: integer;
begin
  DList^.numberOfChildren := Tree^.NumberOfChildren;
  SetLength(DList^.children, DList^.numberOfChildren);
  K:=0;
  while  k <= Tree^.NumberOfChildren-1 do
  begin
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

procedure drawModel(Form: TForm; paintBox: TPaintBox);
const
  skipSpace = 50;
var
  k: Integer;
  x, y: Integer;
  CurrX, CurrY: integer;

procedure DrawProccesingRec(var DList: PDrawList; var SpaceX, SpaceY: integer);
var
  i, tempSpaceX, tempSpaceY, tempWidth, tempHeight: integer;
  x, y: integer;
begin
  y:=CurrY;
  CurrY := CurrY + DList^.height + skipSpace;
  x:=CurrX-Round(DList^.width/2);
  tempSpaceX:=0;
  tempSpaceY:=0;
  if DList^.chAvailable then
    begin
    i:=0;
    while i <= DList^.numberOfChildren-1 do
      begin
      DrawProccesingRec(DList^.children[i], tempSpaceX, tempSpaceY);
      Inc(i);
      end;
    end;

  tempHeight := SpaceY;
  tempWidth := DList^.width;


  i:=1;
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
    Terminator: drawTerminator(pbBox,x,y,tempWidth,DList^.height, tempHeight);
    Choice: drawBinaryChoice(pbBox,x,y,tempWidth,DList^.height,tempHeight);
    DataBlock: drawDataBlock(pbBox,x,y,tempWidth,DList^.height,tempHeight);
    Loop: drawLoop(pbBox,x,y,tempWidth,DList^.height,tempHeight);
    Block: drawFunctionalBlock(pbBox,x,y,tempWidth,DList^.height,tempHeight);
   end;

  SpaceY := SpaceY + DList^.height + skipSpace;
end;

begin
  CurrX := 100;
  CurrY := 50;
  x:=0;
  y:=0;
  if DrawList^.numberOfChildren <> 0 then
    for k := 0 to DrawList^.numberOfChildren-1 do
      begin
      DrawProccesingRec(DrawList^.children[k], x, y);
      x:=0;
      y:=0;
      currY := 50;
      CurrX := CurrX + 200;
      end;             ;
end;

procedure CreatingDrawModel(Form: TForm; paintBox: TPaintBox);
begin
  pbBox:=PaintBox;
  CreateDrawUnit(DrawList);
  FillDrawUnit(DrawList, TreeStructure);
  drawModel(Form,paintBox);
end;


end.
