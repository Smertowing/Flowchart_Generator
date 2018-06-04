program laba4_binom;
var n,k:integer;

function Recursion(k,n : integer) : int64;
begin
  if (k=0)or(k=n) then
	begin
    Result:=1
	end
  else
	begin
    Result:=Recursion(k,n-1) + Recursion(k-1,n-1);
	end;
end;

begin
Writeln('Please, enter binomial coefficient');
repeat
Write('n = ');
Readln(n);
if n<0 then
	begin
  writeln('Invalid value');
	end;
until n>=0;
Write('Reuslt: ');
for k := 0 to n do
  Write( Recursion(k,n), ' ');
readln;
end.
