program lab_1_binary_search;

{$APPTYPE CONSOLE}

uses
  SysUtils;

const N = 1000;

type
    TRecord = record
       Numb:integer;
       St:string;
       BoolF:boolean;
    end;
    TMasRe = array[1..N] of TRecord;

var
  Mas:TMasRe;
  BoolIn:boolean;
  InputBinaryStr,InputBinaryIntS:string;
  InputBinaryInt,InputBinaryIntEr:integer;



procedure generateArrayOFRecord(N:integer;var Mas:TMasRe);
var
  i:integer;
begin
randomize;
  for i:=1 to N do
  begin
  Mas[i].numb:=Random(201);
  Mas[i].st:='my_test_' + IntToStr(i);
  Mas[i].BoolF:=false;
  end;
end;

procedure saveArray(N:integer; Mas:TMasRe; filename:string; task:integer);
var
  i:integer;
  ExternalPath: TextFile;
begin
  Writeln('Task ' + IntToStr(task) + ' completed. File "' + filename + '" saved');
  AssignFile(ExternalPath, '\\Vboxsvr\winhack\2nd semester\OAIP\lab_1_binary\SupportFiles\'+filename);
  Rewrite(ExternalPath);
  write(ExternalPath, 'Number Field':16);
  write(ExternalPath, 'String Field':16);
  writeln(ExternalPath, 'Boolean Field':16);
for i:=1 to N do
  begin
  write(ExternalPath, Mas[i].numb:16);
  write(ExternalPath, Mas[i].St:16);
  writeln(ExternalPath, Mas[i].BoolF:16);
  end;
  CloseFile(ExternalPath);
end;

procedure SortStr(Size: integer; var SA: TMasRe);
var t,i,steps,j,m:integer;
    tmp:TRecord;
begin
  t := Trunc(Ln(Size) / Ln(2)) - 1;
  for i:=1 to t do
  begin
    steps:= (1 shl (t+1-i)) - 1;
    for j:=(steps + 1) to Size do
    begin
      tmp:=SA[j];
      m:=j-steps;
      While ((m>=1) and (SA[m].St > tmp.St)) do
      begin
        SA[M+steps] := SA[m];
        m:=m-steps;
      end;
      SA[m+steps] := tmp;
    end;
  end;
end;

procedure SortInt(Size: integer; var SA: TMasRe);
var t,i,steps,j,m:integer;
    tmp:TRecord;
begin
  t := Trunc(Ln(Size) / Ln(2)) - 1;
  for i:=1 to t do
  begin
    steps:= (1 shl (t+1-i)) - 1;
    for j:=(steps + 1) to Size do
    begin
      tmp:=SA[j];
      m:=j-steps;
      While ((m>=1) and (SA[m].Numb > tmp.numb)) do
      begin
        SA[M+steps] := SA[m];
        m:=m-steps;
      end;
      SA[m+steps] := tmp;
    end;
  end;
end;

procedure stringBinSearch(N:Integer; elem:string; var Mas:TMasRe);
var
  left,right,middle,sought:integer;
begin
  left:=1;
  right:=N;
  sought:=-1;
  while (left <= right) do
  begin
    middle := (left + right) div 2;
    Mas[middle].BoolF := true;
    if ((Mas[middle].st) = elem) then
    begin
      sought:= middle;
      left := right + 1;
    end
    else
    begin
      if (Mas[middle].st > elem) then
	begin
        right := middle - 1
	end
      else
	begin
        left := middle +1;
	end;
    end;
  end;
  if (sought = -1) then
	begin
    writeln('Not found')
	end
  else
	begin
    Writeln('Element index: ' + IntToStr(sought))
	end;
end;

function numberOfTrue(N:integer; var Mas:TMasRe):Integer;
var
  i,k:integer;
begin
  k:=0;
  for i:= 1 to N do
  begin
    if (Mas[i].BoolF = True) then
	begin
      Inc(k);
	end;
  end;
Result:=k;
end;

procedure FlagsToFalse(N:integer; var Mas:TMasRe);
var
  i:Integer;
begin
  for i:=1 to N do
  begin
    Mas[i].BoolF := false;
  end;
end;

procedure intBinSearch(N,elem:Integer; var Mas:TMasRe);
var
  left,right,middle,sought,tmpindx :integer;
begin
  left:=1;
  right:=N;
  sought:=-1;
  while (left <= right) do
  begin
    middle := (left + right) div 2;
    Mas[middle].BoolF := true;
    if ((Mas[middle].numb) = elem) then
    begin
    sought:= middle;
    left := right + 1;
    end
    else
    begin
    if (Mas[middle].numb > elem) then
	begin
      right := middle - 1
	end
    else
	begin
      left := middle +1;
	end;
    end;
  end;
  if (sought = -1) then
	begin
    writeln('Not found')
	end
  else
  begin
    tmpindx := sought;
    while (Mas[tmpindx].numb = elem) and (tmpindx>0) do
    begin
      Dec(tmpindx);
    end;
    Mas[tmpindx].BoolF := true;
    inc(tmpindx);
    while (Mas[tmpindx].numb = elem) do
    begin
      Mas[tmpindx].BoolF:= true;
      Write(Mas[tmpindx].numb:5);
      Write(Mas[tmpindx].st:16);
      writeln(Mas[tmpindx].BoolF:8);
      inc(tmpindx);
    end;
  end;
end;

begin
boolin:=False;
InputBinaryIntEr:=0;
generateArrayOfRecord(N,Mas);
writeln('Task 1 completed');
saveArray(N,Mas, 'rawArray.txt', 2);
SortStr(N,Mas);
writeln('Task 3 completed');
saveArray(N,Mas, 'sortF2Array.txt', 4);
Writeln('Enter data string binary search');
readln(InputBinaryStr);
stringBinSearch(N,InputBinaryStr, Mas);
writeln('Task 5 completed');
saveArray(N,Mas, 'searchF2Array.txt',6);
Writeln('Field with "true" : ', numberOfTrue(N,Mas));
FlagsToFalse(N,Mas);
writeln('Task 7 completed');
SortInt(N,Mas);
writeln('Task 8 completed');
saveArray(N,Mas, 'sortF1Array.txt',9);
  Writeln('Enter data integer binary search');
  while not(BoolIn) do
    begin
    Readln(InputBinaryIntS);
    val(InputBinaryIntS, InputBinaryInt, InputBinaryIntEr);
    if (InputBinaryIntEr = 0) then
      begin
      intBinSearch(N,InputBinaryInt, Mas);
      BoolIn:= True;
      end
    else
    writeln('Incorrect input, try again');
    end;
writeln('Task 10 completed');
saveArray(N,Mas, 'searchF1Array.txt',11);
Writeln('Field with "true" : ', numberOfTrue(N,Mas));
writeln('All taskes are completed!');


Readln;
end.
