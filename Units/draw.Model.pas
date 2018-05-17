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

//  DList^.height := 50;
//  DList^.width := 100;
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

procedure HealDrawStructure(var DList: PDrawList);
var
  i: Integer;
begin
  for i := 0 to DList^.numberOfChildren - 1 do
    begin
      DList^.children[i]^.structure := Terminator;
    end;

end;

procedure drawModel(Form: TForm; paintBox: TPaintBox);
const
  skipSpace = 50;
  basicHeight = 50;
  basicWidth = 100;
var
  k: Integer;
  x, y: Integer;
  CurrX, CurrY: integer;
  indentX, indentY: integer;

procedure DrawProccesingRec(var DList: PDrawList; var indentX:integer);
var
  i: integer;
  x, y: integer;

procedure DrawProccesingBlock(var DrList: PDrawList);
var
  j: Integer;
begin
  if DrList^.numberOfChildren <> 0 then
    for j := 0 to DrList^.numberOfChildren - 1 do
      DrawProccesingRec(DrList^.children[j],indentX);
end;

procedure DrawProccesingChoice(var DrList: PDrawList);
var
  x1,y1, tempIndent, tempY: Integer;
begin
  if DrList^.numberOfChildren <> 0 then
    begin
    x1:=CurrX;
    y1:=CurrY;
    CurrY := CurrY + basicHeight + skipSpace;
    DrawProccesingRec(DrList^.children[0], indentX);
    drawBinaryChoice(pbBox,x1,y1,basicWidth,basicHeight,indentY);
    if DrList^.numberOfChildren > 1 then
      begin
      tempY := CurrY;
      tempIndent := CurrX;
      CurrY := y1 + basicHeight + skipSpace;
      CurrX := x1 + skipSpace + basicWidth;
      DrawProccesingRec(DrList^.children[2], indentX);
      drawLine(pbBox, CurrX+Round(basicWidth/2), CurrY, tempIndent+Round(basicWidth/2), CurrY);
      if tempY > CurrY then
        CurrY := tempY;
      CurrX := tempIndent;
      CurrY := CurrY + skipSpace;
      drawLine(pbBox, X1+basicWidth, Y1+Round(basicHeight/2), X1+Round(basicWidth/2)+ skipSpace + basicWidth, Y1+basicHeight+skipSpace);

      end;
    drawLine(pbBox, X1+Round(basicWidth/2), Y1+basicHeight, X1+Round(basicWidth/2), Y1+basicHeight+skipSpace);
    drawLine(pbBox, CurrX+Round(basicWidth/2), CurrY-skipSpace, CurrX+Round(basicWidth/2), CurrY);

    end;
end;

procedure DrawProccesingLoop(var DrList: PDrawList);
var
  x1,y1,j: Integer;
begin
  if DrList^.numberOfChildren <> 0 then
    begin
    x1:=CurrX;
    y1:=CurrY;
    CurrY := CurrY + basicHeight + skipSpace;
    for j := 0 to DrList^.numberOfChildren-1 do
      DrawProccesingRec(DrList^.children[j], indentX);
    indentY := CurrY - Y1;
    CurrY := CurrY + basicHeight + skipSpace;
    DrawLoop(pbBox,x1,y1,basicWidth,basicHeight,indentY);
    drawLine(pbBox, X1+Round(basicWidth/2), Y1+basicHeight, X1+Round(basicWidth/2), Y1+basicHeight+skipSpace);
    drawLine(pbBox, X1+Round(basicWidth/2), Y1+basicHeight+indentY, X1+Round(basicWidth/2), Y1+basicHeight+skipSpace+indentY);
    end;
end;

begin
  if DList^.chAvailable then
    case DList^.structure of
      Choice: DrawProccesingChoice(DList);
      Loop: DrawProccesingLoop(DList);
      Block, Terminator, Another: DrawProccesingBlock(DList);
    //  DataBlock: drawDataBlock(pbBox,x,y);
    end
  else
    begin
      X:=CurrX + indentX;
      Y:=CurrY;

      if DList^.structure = DataBlock then
        drawDataBlock(pbBox,X,Y,basicWidth,basicHeight,0)
      else
        drawFunctionalBlock(pbBox,X,Y,basicWidth,basicHeight,0);
      drawLine(pbBox, X+Round(basicWidth/2), Y+basicHeight, X+Round(basicWidth/2), Y+basicHeight+skipSpace);

      CurrY := CurrY + basicHeight + skipSpace;
    end;
end;

begin
  CurrX := 100;
  CurrY := 50;
  indentX:=0;
  if DrawList^.numberOfChildren <> 0 then
    for k := 0 to DrawList^.numberOfChildren-1 do
      begin
      x:=CurrX;
      y:=CurrY;
      CurrY := CurrY + basicHeight + skipSpace;
      DrawProccesingRec(DrawList^.children[k], indentX);
      indentY := CurrY - Y;
      DrawTerminator(pbBox,x,y,basicWidth,basicHeight,indentY);
      drawLine(pbBox, X+Round(basicWidth/2), Y+basicHeight, X+Round(basicWidth/2), Y+basicHeight+skipSpace);
      CurrX := CurrX + indentX + 200;
      CurrY := 50;
      end;             ;
end;

procedure CreatingDrawModel(Form: TForm; paintBox: TPaintBox);
begin
  pbBox:=PaintBox;
  CreateDrawUnit(DrawList);
  FillDrawUnit(DrawList, TreeStructure);
  HealDrawStructure(DrawList);
  drawModel(Form,paintBox);
end;


end.
