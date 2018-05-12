program TreeTask;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Windows;

type
  TData = Integer;
  PNode = ^TNode;
  TNode = record
    Data : TData;
    PLeft, PRight : PNode;
  private
    LeftHeight, RightHeigh : Integer;
  end;

const
  Fn = 'E:\2nd semester\OAIP\lab_8\tree\files\kek';
var
  PTree : PNode;
  Data : TData;
  Cmd, Code, Res, testN : Integer;
  S, FileName,fileSaveName : String;
  
//Free Memory
procedure TreeFree(var aPNode : PNode);
begin
  if aPNode <> nil then
  begin
  TreeFree(aPNode^.PLeft); 
  TreeFree(aPNode^.PRight); 
  Dispose(aPNode);
  aPNode := nil; 
  end;
end;

//Show Tree
procedure TreeWritelnS(const aPNode : PNode; const aName : String);
var
  i: Byte;
begin
  if aPNode <> nil then
  begin
  TreeWritelnS(aPNode^.PRight, aName + '-1');
  for i := 1 to Length(aName)+1  do
    write(' ');
  Writeln(aPNode^.Data);
  TreeWritelnS(aPNode^.PLeft, aName + '-2');
  end;
end;

//Rec Input Tree TextFile
procedure NodeLoad(var aPNode : PNode; var aF : TextFile; var N: Integer);
var
  Data : TData;
  S : String;
  Code : Integer;
  NLeft, NRight: Integer;
begin
  NLeft:=0;
  NRight:=0;
  aPNode := nil;
  if not Eof(aF) then   //End of file = end of branch
    begin
    Readln(aF, S);
    Val(S, Data, Code);
    if Code = 0 then      //Not numeric data = end of branch
      begin
      New(aPNode);
      aPNode^.Data := Data;
      NodeLoad(aPNode^.PLeft, aF, NLeft);
      aPNode^.LeftHeight := NLeft;

      writeln(Data, ' left ',NLeft);

      NodeLoad(aPNode^.PRight, aF, NRight);
      aPNode^.RightHeigh := NRight;

      writeln(Data, ' right ',NRight);

      if NRight > NLeft then
        N := NRight
      else
        N := NLeft;
      Inc(N);
      end
    end
end;

//Input Tree TextFile
procedure TreeLoad(var aPNode : PNode; const aFileName : String);
var
  F: TextFile;
  TempN: integer;
begin
  TreeFree(aPNode);
  AssignFile(F, aFileName);
  Reset(F);
  try
    NodeLoad(aPNode, F, TempN);
  finally
    CloseFile(F);
  end;
end;

//Safe File
procedure NodeSave(const aPNode : PNode; var aF : TextFile);
begin
  if aPNode = nil then        
    Writeln(aF)
  else
  begin
    Writeln(aF, aPNode^.Data);
    NodeSave(aPNode^.PLeft, aF);
    NodeSave(aPNode^.PRight, aF);
  end;
end;

//Free to file
procedure TreeSave(var aPNode : PNode; const aFileName : String);
var
  F : TextFile;
begin
  AssignFile(F, aFileName);
  Rewrite(F);
  try
    NodeSave(aPNode, F);
  finally
    CloseFile(F);
  end;
end;

procedure BalancingNodes(var aPNode : PNode; const N: Integer);
var
  NLeft, NRight: Integer;
  delta, L,R: integer;
begin
  if aPNode <> nil then
  begin
    L:= aPNode^.LeftHeight;
    R:= aPNode^.RightHeigh;
    delta := Abs(L - R);
    if (delta > 1) and (((L + 1) < N) or ((R + 1) < N)) then
      begin
        if (L > R) and ((R + 1) < N) then
          begin
          NLeft := R + 1;
          NRight := R + 1;
          end;
        if (R > L) and ((L + 1) < N) then
          begin
          NRight := L + 1;
          NLeft := L + 1;
          end;
      end
    else
      begin
      NLeft := N - 1;
      NRight := N - 1;
      end;

    if NLeft <= 0 then
      TreeFree(aPNode^.PLeft)
    else
      BalancingNodes(aPNode^.PLeft, NLeft);
    if NRight <= 0 then
      TreeFree (aPNode^.PRight)
    else
      BalancingNodes(aPNode^.PRight, NRight);
  end;
end;

// Main balancing
procedure BalancingTree(var aPNode: PNode);
var
  max: Integer;
begin
  if aPNode^.LeftHeight > aPNode^.RightHeigh then
    max := aPNode^.LeftHeight
  else
    max := aPNode^.RightHeigh;
  inc(max);
  BalancingNodes(aPNode, max);
  Write('Nodes balanced to AVL');
end;

begin
  PTree := nil;
  repeat
    //Menu.
    Writeln('----------');
    Writeln('Choose wisely:');
    Writeln('1: Input Tree.');
    Writeln('2: Output Tree.');
    Writeln('3: Show Tree');
    Writeln('4: Balance Tree');
    Writeln('5: Free memory');
    Writeln('6: Exit');
    Write('I choose: ');
    Readln(S);
    Val(S, Cmd, Code);
    if Code <> 0 then
      Cmd := -1;
    case Cmd of
      1:
      begin
        Writeln('Choose number of test file (from 1 to 7)');
          repeat
          Readln(testN);
          if not ((testN >= 1) and (testN <=7)) then
            Writeln('Try again');
          until (testN >= 1) and (testN <=7);
        fileName := Fn+IntToStr(testN)+'.txt';
        fileSaveName := Fn+IntToStr(testN)+'_balanced.txt';
        TreeLoad(PTree, FileName);
        Write('File: "', FileName, '".');
      end;
      2:
      begin
        TreeSave(PTree, FileSaveName);
        Write('File: "', fileSaveName, '".');
      end;
      3:
      begin
        Writeln;
        TreeWritelnS(PTree, '0');
      end;
      5, 6:
      begin
        TreeFree(PTree);
        Write('Memory disposed');
      end;
      4:
      begin
        BalancingTree(PTree);
      end
      else
        Write('Unknown, try again.');
    end;
    Readln;
  until Cmd = 6;
  Write('Completed, press any button.');
  Readln;
end.
