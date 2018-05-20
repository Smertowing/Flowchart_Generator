unit draw.Model;

interface
  uses TypesAndVars, data.Model, View,
       Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
       Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls,
       Vcl.ExtCtrls;

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

procedure CreatingDrawModel(Form: TForm; paintBox: TPaintBox);
var
  tempWidth, tempHeight: Integer;
begin
  paintBox.Width:=High(Integer);
  paintBox.Height:=High(Integer);
  CreateDrawUnit(DrawList);
  FillDrawUnit(DrawList, TreeStructure);
  HealDrawStructure(DrawList);

  tempWidth := 0;
  tempHeight := 0;
  drawModel(paintBox.Canvas, tempWidth, tempHeight);
  paintBox.Width := tempWidth;
  paintBox.Height := tempHeight;
end;


end.
