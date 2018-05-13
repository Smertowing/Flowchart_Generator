unit draw.Model;

interface
  uses TypesAndVars, draw.Structures, data.Model,
       Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
       Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls,
       Vcl.ExtCtrls;


implementation

const
  skipSpace = 50;

var
  pbMain: TPaintBox;
  TempTreeStructure: PTreeStructure;
  CurrentLine: integer;
  CurrX, CurrY: integer;

function CreateDrawList(): PDrawList;
begin
  New(Result);
  SetLength (Result^.children, 0);
  Result^.chAvailable := False;
  Result^.numberOfChildren := 0;
  Result^.next := nil;
  Result^.branch := nil;
end;

procedure CopyingTree();
begin
  drawList := CreateDrawList();
  DrawList^.branch := TreeStructure;
  DrawList^.height := 0;
  DrawList^.width := 0;
end;

procedure CreatingDrawModel(Form: TForm; paintBox: TPaintBox);
begin
  CopyingTree();

end;

procedure DrawBlock(x,y,Width,Height,i: Integer; var DList: PDrawList);
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
end;

procedure DrawProccesingRec(var DList: PDrawList; var SpaceX, SpaceY: integer);
var
  i, tempSpaceX, tempSpaceY, tempWidth, tempHeight: integer;
  x, y: integer;
  NothingToDo:boolean;
begin
  repeat
  y:=CurrY;
  x:=CurrY-Round(DList^.width/2);
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

  tempSpaceY := SpaceY+DList^.Height;
  tempSpaceX := DList^.width;
  SpaceY := SpaceY+DList^.Height+skipSpace;

  i:=1;
  NothingToDo:=true;
    while i<=numberOfBlockDecl do
      begin
        if checkStr(DList^.caption, trim(BlockDeclNames[i])) then
          begin
            DrawBlock(x,y,tempSpaceX,tempSpaceY,i,DList);
            NothingToDo := False;
          end;
      inc(i);
      end;

  DList := DList^.next;
  until DList = nil;
end;


procedure clearScreen(Form: TForm; paintBox: TPaintBox);
begin
  with paintBox do
    begin
      Canvas.Rectangle(0,0, Form.Width, form.Height);
    end;
end;



end.
