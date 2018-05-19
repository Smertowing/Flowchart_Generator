unit View;

interface
  uses TypesAndVars, draw.Structures, data.Model,
       Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
       Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls,
       Vcl.ExtCtrls;

  procedure drawModel(canvas:TCanvas; var canvWidth, canvHeigth:integer);

implementation

const
    Tabu = 50;

procedure drawAndFixTerminator(Canv:TCanvas; x,y,width,height, space:Integer; var canvWidth, canvHeigth:integer );
begin
  if canvWidth < x+width+tabu then
    canvWidth := x+width+tabu;
  if canvHeigth < y+height+space+tabu then
    canvHeigth := y+height+space+tabu;

  drawTerminator(Canv,x,y,width,height,space);
end;

procedure drawAndFixFunctionalBlock(Canv:TCanvas; x,y,width,height, space:Integer; var canvWidth, canvHeigth:integer);
begin
  if canvWidth < x+width+tabu then
    canvWidth := x+width+tabu;
  if canvHeigth < y+height+tabu then
    canvHeigth := y+height+tabu;

  drawFunctionalBlock(Canv,x,y,width,height,space)
end;

procedure drawAndFixBinaryChoice(Canv:TCanvas; x,y,width,height,space:Integer; var canvWidth, canvHeigth:integer);
begin
  if canvWidth < x+width+tabu then
    canvWidth := x+width+tabu;
  if canvHeigth < y+height+tabu then
    canvHeigth := y+height+tabu;

  drawBinaryChoice(Canv,x,y,width,height,space)
end;

procedure drawAndFixDataBlock(Canv:TCanvas; x,y,width,height,space:Integer; var canvWidth, canvHeigth:integer);
begin
  if canvWidth < x+width+tabu then
    canvWidth := x+width+tabu;
  if canvHeigth < y+height+tabu then
    canvHeigth := y+height+tabu;

  drawDataBlock(Canv,x,y,width,height,space)
end;

procedure drawAndFixLoop(Canv:TCanvas; x,y,width,height, space:Integer; var canvWidth, canvHeigth:integer);
begin
  if canvWidth < x+width+tabu then
    canvWidth := x+width+tabu;
  if canvHeigth < y+2*height+space+tabu then
    canvHeigth := y+2*height+space+tabu;

  drawLoop(Canv,x,y,width,height,space);
end;

procedure drawAndFixLine(Canv:TCanvas; x1,y1,x2,y2:Integer; var canvWidth, canvHeigth:integer);
begin
  if canvWidth < x1 then
    canvWidth := x1+tabu;
  if canvWidth < x2 then
    canvWidth := x2+tabu;
  if canvHeigth < y1 then
    canvHeigth := y1+tabu;
  if canvHeigth < y2 then
    canvHeigth := y2+tabu;

  drawLine(Canv,x1,y1,x2,y2);
end;

procedure drawModel(canvas:TCanvas; var canvWidth, canvHeigth:integer);
const
  skipSpace = 50;
  basicHeight = 50;
  basicWidth = 100;
var
  k: Integer;
  x, y: Integer;
  CurrX, CurrY: integer;
  indentX, indentY, maxX: integer;

procedure DrawProccesingRec(var DList: PDrawList; var indX:integer);
var
  i: integer;
  x, y: integer;

procedure DrawProccesingBlock(var DrList: PDrawList; var iX:integer);
var
  j: Integer;
begin
  if DrList^.numberOfChildren <> 0 then
    for j := 0 to DrList^.numberOfChildren - 1 do
      DrawProccesingRec(DrList^.children[j],iX);
end;

procedure DrawProccesingChoice(var DrList: PDrawList; var iX:integer);
var
  x1,y1, tempIndent, tempY: Integer;
  kekIndentX, kekIndentY: Integer;
begin
  if DrList^.numberOfChildren <> 0 then
    begin
    kekIndentX:=0;
    kekIndentY:=0;
    x1:=CurrX;
    y1:=CurrY;
    CurrY := CurrY + basicHeight + skipSpace;
    DrawProccesingRec(DrList^.children[0], kekIndentX);


    drawAndFixBinaryChoice(Canvas,x1,y1,basicWidth,basicHeight,indentY,canvWidth, canvHeigth);

    if DrList^.numberOfChildren > 1 then
      begin
      tempY := CurrY;
      tempIndent := CurrX;
      iX := skipSpace + basicWidth + kekIndentX;
      CurrY := y1 + basicHeight + skipSpace;
      CurrX := x1 + iX;
      if CurrX > maxX then
        maxX:=CurrX;
      drawAndFixLine(Canvas, X1+basicWidth, Y1+Round(basicHeight/2), CurrX +Round(basicWidth/2), Y1+basicHeight+skipSpace, canvWidth, canvHeigth);
      kekIndentX:=0;
      DrawProccesingRec(DrList^.children[2], kekIndentX);
      if tempY > CurrY then
        begin
        drawAndFixLine(Canvas, CurrX+Round(basicWidth/2), CurrY, tempIndent+Round(basicWidth/2), tempY, canvWidth, canvHeigth);
        CurrY := tempY;
        end
      else
        begin
        drawAndFixLine(Canvas, CurrX+Round(basicWidth/2), CurrY, tempIndent+Round(basicWidth/2), CurrY, canvWidth, canvHeigth);
        drawAndFixLine(Canvas, tempIndent+Round(basicWidth/2), tempY, tempIndent+Round(basicWidth/2), CurrY, canvWidth, canvHeigth);
        end;

      CurrX := tempIndent;
      CurrY := CurrY + skipSpace;
      end
    else
      begin
      tempY := CurrY;
      tempIndent := CurrX;
      iX := skipSpace + basicWidth + kekIndentX;
      CurrY := y1 + basicHeight + skipSpace;
      CurrX := x1 + iX;
      if CurrX > maxX then
        maxX:=CurrX;
      drawAndFixLine(Canvas, X1+basicWidth, Y1+Round(basicHeight/2), CurrX +Round(basicWidth/2), Y1+basicHeight+skipSpace, canvWidth, canvHeigth);
      if tempY > CurrY then
        begin
        drawAndFixLine(Canvas, CurrX+Round(basicWidth/2), CurrY, tempIndent+Round(basicWidth/2), tempY, canvWidth, canvHeigth);
        CurrY := tempY;
        end
      else
        begin
        drawAndFixLine(Canvas, CurrX+Round(basicWidth/2), CurrY, tempIndent+Round(basicWidth/2), CurrY, canvWidth, canvHeigth);
        drawAndFixLine(Canvas, tempIndent+Round(basicWidth/2), tempY, tempIndent+Round(basicWidth/2), CurrY, canvWidth,canvHeigth);
        end;
      CurrY:=CurrY+skipSpace;
      CurrX := tempIndent;
      end;
    iX := skipSpace + basicWidth;
    if CurrX > maxX then
        maxX:=CurrX;
    drawAndFixLine(Canvas, X1+Round(basicWidth/2), Y1+basicHeight, X1+Round(basicWidth/2), Y1+basicHeight+skipSpace, canvWidth, canvHeigth);
    drawAndFixLine(Canvas, CurrX+Round(basicWidth/2), CurrY-skipSpace, CurrX+Round(basicWidth/2), CurrY, canvWidth, canvHeigth);
    end;
end;

procedure DrawProccesingLoop(var DrList: PDrawList; var iX:integer);
var
  x1,y1,j: Integer;
begin
  if DrList^.numberOfChildren <> 0 then
    begin
    x1:=CurrX;
    y1:=CurrY;
    CurrY := CurrY + basicHeight + skipSpace;
    for j := 0 to DrList^.numberOfChildren-1 do
      DrawProccesingRec(DrList^.children[j], iX);
    indentY := CurrY - Y1;
    CurrY := CurrY + basicHeight + skipSpace;
    DrawAndFixLoop(Canvas,x1,y1,basicWidth,basicHeight,indentY, canvWidth, canvHeigth);
    drawAndFixLine(Canvas, X1+Round(basicWidth/2), Y1+basicHeight, X1+Round(basicWidth/2), Y1+basicHeight+skipSpace, canvWidth, canvHeigth);
    drawAndFixLine(Canvas, X1+Round(basicWidth/2), Y1+basicHeight+indentY, X1+Round(basicWidth/2), Y1+basicHeight+skipSpace+indentY,canvWidth, canvHeigth);
    end;
end;

begin
  if DList^.chAvailable then
    case DList^.structure of
      Choice: DrawProccesingChoice(DList, indX);
      Loop: DrawProccesingLoop(DList, indX);
      Block, Terminator, Another: DrawProccesingBlock(DList, indX);
    //  DataBlock: drawDataBlock(pbBox,x,y);
    end
  else
    begin
      X:=CurrX;
      Y:=CurrY;

      if DList^.structure = DataBlock then
        drawAndFixDataBlock(Canvas,X,Y,basicWidth,basicHeight,0, canvWidth, canvHeigth)
      else
        drawAndFixFunctionalBlock(Canvas,X,Y,basicWidth,basicHeight,0,canvWidth, canvHeigth);
      drawAndFixLine(Canvas, X+Round(basicWidth/2), Y+basicHeight, X+Round(basicWidth/2), Y+basicHeight+skipSpace, canvWidth, canvHeigth);

      CurrY := CurrY + basicHeight + skipSpace;
    end;
end;

begin
  CurrX := 100;
  CurrY := 50;
  indentX:=0;
  indentY:=0;
  maxX:=CurrX;
  if DrawList^.numberOfChildren <> 0 then
    for k := 0 to DrawList^.numberOfChildren-1 do
      begin
      x:=CurrX;
      y:=CurrY;
      CurrY := CurrY + basicHeight + skipSpace;
      DrawProccesingRec(DrawList^.children[k], indentX);

      indentY := CurrY - Y;
      DrawAndFixTerminator(Canvas,x,y,basicWidth,basicHeight,indentY, canvWidth,canvHeigth);
      drawAndFixLine(Canvas, X+Round(basicWidth/2), Y+basicHeight, X+Round(basicWidth/2), Y+basicHeight+skipSpace, canvWidth,canvHeigth);
      CurrX := maxX + 200;
      maxX:=CurrX;
      CurrY := 50;
      end;             ;
end;


end.
