unit draw.Model;

interface
  uses TypesAndVars, data.Model, View,
       Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
       Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls,
       Vcl.ExtCtrls;

  procedure CreatingDrawModel(Form: TForm; paintBox: TPaintBox);
  procedure FindAndBlue(x,y:integer; var a,b:Integer);
  procedure FindBranch(x,y:Integer; var a,b: integer; var Str:string);
  procedure FindBranchAndResetCaption(x,y:Integer; str:string);
  procedure changeTheirMind(x,y:Integer);
  procedure RestoreDafault;
  procedure ChangeChildrenState(x,y:integer);
  procedure EraseDrawList(var DList: PDrawList);

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
  DrawUnit^.x := -1000;
  DrawUnit^.y := -1000;
  DrawUnit^.color := clBlack;
  DrawUnit^.Space := 0;
  DrawUnit^.hiddenstructure := Block;
end;

procedure EraseDrawList(var DList: PDrawList);
var
  i: integer;
begin
  i:=0;
  while i <= DList^.NumberOfChildren - 1 do
    begin
      EraseDrawList(DList^.Children[i]);
      Inc(i);
    end;
  Dispose(DList);
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

procedure RestoreDafault();

procedure RestoreDefaultRec(var DList:PDrawList);
var
  k:Integer;
begin
  K:=0;
  if DList^.chAvailable then
    while  k <= DList^.NumberOfChildren-1 do
    begin
      RestoreDefaultRec(DList^.children[k]);
      Inc(k);
    end;
  Dlist^.color := clBlack;
end;

begin
  RestoreDefaultRec(DrawList);
end;

procedure FindAndBlue(x,y:integer; var a,b:Integer);

procedure FindAndBlueDrawList(var DList:PDrawList; x,y:integer);
var
  k:Integer;
begin
  K:=0;
  if DList^.chAvailable then
    while  k <= DList^.NumberOfChildren-1 do
    begin
      FindAndBlueDrawList(DList^.children[k], x, y);
      Inc(k);
    end;

  if (x >= DList^.x) and (x<= Dlist^.x + basicWidth) and (((y>= Dlist^.y) and (y<= Dlist^.y + basicHeight)) or
  (y>= Dlist^.y + Dlist^.space) and (y<= Dlist^.y + Dlist^.space + basicHeight))  then
    begin
      Dlist^.color := clBlue;
      a:=DList^.branch^.DeclarationLine;
      b:=DList^.branch^.EndLine;
    end;
end;

begin
  FindAndBlueDrawList(DrawList,x,y);
end;

procedure changeChildrenState(x,y:integer);

procedure changeChildrenStateRec(var DList:PDrawList; x,y:integer);
var
  k:Integer;
begin
  K:=0;
  if DList^.chAvailable then
    while  k <= DList^.NumberOfChildren-1 do
    begin
      changeChildrenStateRec(DList^.children[k], x, y);
      Inc(k);
    end;

  if (x >= DList^.x) and (x<= Dlist^.x + basicWidth) and (((y>= Dlist^.y) and (y<= Dlist^.y + basicHeight)) or
  (y>= Dlist^.y + Dlist^.space) and (y<= Dlist^.y + Dlist^.space + basicHeight))  then
    begin
      if DList^.chAvailable then
        DList^.chAvailable := False
      else
        begin
          if DList^.numberOfChildren <> 0 then
            DList^.chAvailable := True;
        end;
    end;
end;

begin
  changeChildrenStateRec(DrawList,x,y);
end;

procedure FindBranch(x,y:Integer; var a,b: integer; var Str:string);

procedure FindBranchRec(var DList:PDrawList; x,y:integer);
var
  k:Integer;
begin
  K:=0;
  if DList^.chAvailable then
    while  k <= DList^.NumberOfChildren-1 do
    begin
      FindBranchRec(DList^.children[k],x,y);
      Inc(k);
    end;
  if (x >= DList^.x) and (x<= Dlist^.x + basicWidth) and (((y>= Dlist^.y) and (y<= Dlist^.y + basicHeight)) or
  (y>= Dlist^.y + Dlist^.space) and (y<= Dlist^.y + Dlist^.space + basicHeight))  then
    begin
      a:=DList^.x;
      b:=DList^.y;
      Str:=Dlist^.caption;
    end;
end;

begin
  FindBranchRec(DrawList,x,y);
end;

procedure FindBranchAndResetCaption(x,y:Integer; str:string);

procedure FindBranchAndResetCaptionRec(var DList:PDrawList; x,y:integer);
var
  k:Integer;
begin
  K:=0;
  if DList^.chAvailable then
    while  k <= DList^.NumberOfChildren-1 do
    begin
      FindBranchAndResetCaptionRec(DList^.children[k],x,y);
      Inc(k);
    end;
  if (x >= DList^.x) and (x<= Dlist^.x + basicWidth) and (((y>= Dlist^.y) and (y<= Dlist^.y + basicHeight)) or
  (y>= Dlist^.y + Dlist^.space) and (y<= Dlist^.y + Dlist^.space + basicHeight))  then
    begin
      DList^.caption := Str;
    end;
end;

begin
  FindBranchAndResetCaptionRec(DrawList,x,y);
end;

procedure changeTheirMind(x,y:Integer);

procedure changeTheirMindRec(var DList:PDrawList; x,y:integer);
var
  k:Integer;
begin
  K:=0;
  if DList^.chAvailable then
    while  k <= DList^.NumberOfChildren-1 do
    begin
      changeTheirMindRec(DList^.children[k],x,y);
      Inc(k);
    end;
  if (x >= DList^.x) and (x<= Dlist^.x + basicWidth) and (((y>= Dlist^.y) and (y<= Dlist^.y + basicHeight)) or
  (y>= Dlist^.y + Dlist^.space) and (y<= Dlist^.y + Dlist^.space + basicHeight))  then
    begin
      case DList^.hiddenstructure of
        DataBlock: DList^.hiddenstructure := Block;
        Block: DList^.hiddenstructure := PredefinedBlock;
        PredefinedBlock: DList^.hiddenstructure := DataBlock;
      end;

    end;
end;

begin
  changeTheirMindRec(DrawList,x,y);
end;

end.
