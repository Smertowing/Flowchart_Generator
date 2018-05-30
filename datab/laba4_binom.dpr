program laba4_binom;
var n,k:integer;

function Recursion(k,n : integer) : int64;
begin
  if (k=0)or(k=n) then
    Result:=1
  else
    Result:=Recursion(k,n-1) + Recursion(k-1,n-1);
end;

begin
Writeln('Please, enter binomial coefficient');
repeat
Write('n = ');
Readln(n);
if n<0 then
  writeln('Invalid value');
until n>=0;
Write('Reuslt: ');
for k := 0 to n do
  Write( Recursion(k,n), ' ');
readln;
end.
