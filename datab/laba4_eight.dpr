program laba4_eight;

{$APPTYPE CONSOLE}

uses
  SysUtils;

const
  N=8;

type
  TQueensArr = array [1..N] of integer;
  TColums = array [1..N] of Boolean;
  TRigthDia = array [2..2*N] of Boolean;
  TLeftDia = array [1-N..N-1] of Boolean;

var
  NumbSol : integer;

  QueenS : TQueensArr;
  ColumS : TColums;
  RDia : TRigthDia;
  LDia : TLeftDia;

procedure Routine();
var i : Integer;
begin
NumbSol := 1;
for i := 1 to N do
    ColumS[i]:=true;
for i := 2 to (N*2) do
    RDia[i]:=true;
for i := (1-N) to (N-1) do
    LDia[i]:=true;
end;

procedure ChoosenPosition (i,j : integer);
begin
QueenS[i] := j;
ColumS[j] := False;
RDia[i+j] := False;
LDia[j-i] := False;
end;

procedure PrintBoard(QueenS : TQueensArr);
var i,j : integer;
    k : array[1..N] of Char;
    m : integer;
begin
Writeln('Solution number: ',NumbSol);
Writeln('+---+---+---+---+---+---+---+---+');

for i := 1 to N do
  begin
  for m := 1 to N do
    if QueenS[i] = m then
      k[m] := 'Q'
    else
      k[m] := ' ';
  Writeln('| ',k[1],' | ',k[2],' | ',k[3],' | ',k[4],' | ',k[5],' | ',k[6],' | ',k[7],' | ',k[8],' |');
  Writeln('+---+---+---+---+---+---+---+---+');
  end;

Readln;
Inc(NumbSol);
end;

procedure Remove(i,j : Integer);
begin
ColumS[j] := True;
RDia[i+j] := True;
LDia[j-i] := True;
end;

procedure MainAlignment(i : integer);
var j : integer;
begin
for j := 1 to N do
  if ColumS[j] and RDia[i+j] and LDia[j-i] then
    begin
    ChoosenPosition(i,j);
    if i < N then
      MainAlignment(i+1)
    else
      PrintBoard(QueenS);
    Remove(i,j);
    end;
end;

begin
Routine;
MainAlignment(1);
end.



