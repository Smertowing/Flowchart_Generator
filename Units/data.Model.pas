unit data.Model;

interface

  uses TypesAndVars,
       Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
       Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls,
       Vcl.ExtCtrls;


  function checkStr(const Str:string; const S:string):boolean;
  procedure CreatingDataModel();
  procedure EraseTree(var TreeNode: PTreeStructure);
  procedure StringListSeek(var CurrentTreeNode: PTreeStructure; var DT1, DT2: boolean);
//  procedure checkProcAndFunc(const Str: string; LineNumb: integer; var CurrentTreeNode: PTreeStructure);
//  procedure checkBegin(const Str: string; LineNumb: integer; var CurrentTreeNode: PTreeStructure);
//  function checkEnd(const Str: string; LineNumb: integer; var CurrentTreeNode: PTreeStructure): Boolean;

implementation

var
  TempTreeStructure: PTreeStructure;
  CurrentLine: integer;
  DN1, DN2: Boolean;


function CreateNode(): PTreeStructure;
begin
  New(Result);
  Result^.NumberOfChildren := 0;
//  Result^.NextOne := nil;
  SetLength(Result^.Children, 0);
end;

procedure EraseTree(var TreeNode: PTreeStructure);
var
  i: integer;
begin
  i:=0;
  while i <= TreeNode^.NumberOfChildren - 1 do
    begin
      EraseTree(TreeNode^.Children[i]);
      Inc(i);
    end;
 // if TreeNode^.NextOne <> nil then
 //   EraseTree(TreeNode^.NextOne);
  Dispose(TreeNode);
end;

function checkStr(const Str:string; const S:string):boolean;
var
  Valid : Boolean;
  tempI:Integer;
begin
if CurrentLine<=StrList.Count then
begin
Valid:=False;

TempI := AnsiPos(S, AnsiLowerCase(Str));
if (tempI = 1) and ((Str[tempI+length(S)] = ' ') or (Str[tempI+length(S)] = ';') or (Length(Str) = length(s))) then
  Valid := True;
if (tempI > 1) and (Str[tempI-1] = ' ') then
  begin
    if  length(Str) = (Length(s)+TempI-1)  then
      begin
        valid := true;
      end
    else
      begin
        if (Str[tempI+length(S)] = ' ') or (Str[tempI+length(S)] = ';') then
          Valid := True;
      end;
  end;

TempI := AnsiPos(' '+S, AnsiLowerCase(Str));
if tempI<>0 then
  begin
  if  length(Str) = (Length(s)+TempI) then
    begin
    valid := true;
    end
  else
    begin
    if (Str[tempI+length(S)+1] = ' ') or (Str[tempI+length(S)+1] = ';') then
      Valid := True;
    end;
  end;


TempI := AnsiPos(S+' ', AnsiLowerCase(Str));
if tempI > 1 then
  begin
  if  (Str[tempI-1] = ' ') then
    Valid := True;
  end;
if tempI = 1 then
  Valid := True;

Result:= Valid;
end
else
  Result:=False;
end;

function checkSemicolon(const Str: string):boolean;
var
  Valid : Boolean;
  tempI:Integer;
begin
Valid:=False;

TempI := AnsiPos(';', AnsiLowerCase(Str));
if TempI <> 0 then
  Valid := True;
tempI := AnsiPos('.', AnsiLowerCase(str));
  if TempI <> 0 then
  Valid := True;
Result:= Valid;
end;  

procedure SkipToAfterRC(var n:integer);
begin
  inc(n);
  while not checkStr(StrList[n], 'end') do
    begin
    if checkStr(StrList[n],'class') then
       SkipToAfterRC(n);
    if checkStr(StrList[n],'record') then
       SkipToAfterRC(n);
    Inc(n);
    end;
  inc(n);
end;

procedure SkipToImplement(var n:integer);
begin
  repeat
  Inc(n);
  until (checkStr(StrList[n], 'implementation'));
end;

procedure SkipToAfterFP(var n:integer);
begin
  while not checkStr(StrList[n], 'procedure') and not checkStr(StrList[n], 'function') and not (checkStr(StrList[n], 'begin')) do
    begin
    Inc(n);
    end;
end;

procedure SkipToStart(var n:integer);
var
  return:Boolean;
begin
return:=false;
  while not return and not checkStr(StrList[n], 'procedure') and not checkStr(StrList[n], 'function') and not (checkStr(StrList[n], 'begin')) do
    begin
    if checkStr(StrList[n], 'interface') then
      begin
      SkipToImplement(n);
      return:=true;
      Dec(n);
      end;
    Inc(n);
    end;
end;

procedure NewChild(const Str: string; var CurrentTreeNode: PTreeStructure);
var   NextTreeNode: PTreeStructure;
   //   i: Integer;
      DT1, DT2: boolean;
   //   tempS1, tempS2: string;
begin
  Inc(CurrentTreeNode^.NumberOfChildren);
  SetLength(CurrentTreeNode^.Children, CurrentTreeNode^.NumberOfChildren);

  NextTreeNode := CreateNode;

 { tempS1 := str;
  tempS2 := '';
  i:=1;
  while tempS1[i] = ' ' do
    Inc(i);
  while tempS1[i] <> ' ' do
    begin
    tempS2 := tempS2 + tempS1[i];
    Inc(i);
    end;                                      }

  NextTreeNode^.BlockName := Trim(str);
  NextTreeNode^.DeclarationLine := CurrentLine;

  DT1 := false;
  DT2 := false;
  if checkStr(Str, 'begin')  or checkStr(str, 'implementation') then  inc(DT1);
  if checkStr(Str, 'repeat')  then  inc(DT2);

  Inc(CurrentLine);
if checkStr(Str, 'procedure') or checkStr(Str,'function')  then  skipToAfterFP(CurrentLine);



  StringListSeek(NextTreeNode, DT1, DT2);
  NextTreeNode^.EndLine := CurrentLine-1;
  CurrentTreeNode^.Children[CurrentTreeNode^.NumberOfChildren - 1] := NextTreeNode;
end;

procedure checkBegin(const Str: string; var CurrentTreeNode: PTreeStructure);
begin
if checkStr(Str, 'begin') then
  begin
//    Inc(disreg);
    NewChild(Str, CurrentTreeNode);
  end;
end;

function checkTrueEnd (const Str: string; var CurrentTreeNode: PTreeStructure; var disreg:boolean):boolean;
begin
Result:=false;
if checkStr(Str, 'end') then
  begin
    dec(disreg);
    Result:=True;
  end;
end;

function checkEnd (const Str: string; var CurrentTreeNode: PTreeStructure):boolean;
begin
Result:=false;
if checkSemicolon(Str) then
   Result:=True;
end;

procedure StringListSeek(var CurrentTreeNode: PTreeStructure; var DT1, DT2: boolean);
var   tempCicle: Integer;
      CanILeave: Boolean;
begin
  CanILeave := False;
  while (CurrentLine <= StrList.Count-1) and not(CanILeave) do
    begin
{    if (checkStr(StrList[CurrentLine], 'interface')) then
      begin
        SkipToImplement(CurrentLine);
        SkipToAfterFP(CurrentLine);
      end;                                     }

    if (checkStr(StrList[CurrentLine], 'class')) or (checkStr(StrList[CurrentLine], 'record')) then
      begin
        SkipToAfterRC(CurrentLine);
      end;

    tempCicle:=1;
    while tempCicle<=numberOfStruc do
      begin
        if checkStr(StrList[CurrentLine], trim(StrucNames[tempCicle])) then
          begin
            NewChild(StrList[CurrentLine], CurrentTreeNode);
            tempCicle:=1;
          end;
      inc(tempCicle);
      end;


    checkBegin(StrList[CurrentLine], CurrentTreeNode);
    if DT1 then
      begin
      //if checkTrueEnd(StrList[CurrentLine], CurrentTreeNode, DT1) then
      if checkStr(StrList[CurrentLine], 'end') or checkStr(StrList[CurrentLine], 'end.') then
        begin
        canILeave := True;
        Dec(DT1);
        end
      else
        Inc(CurrentLine);
      end
    else
      begin
      if DT2 then
        begin
        if checkStr(StrList[CurrentLine],'until') then
          begin
          canILeave := True;
          Dec(DT2);
          end;
        Inc(CurrentLine);
        end
        else
        begin
        if CurrentLine = StrList.Count-1 then
          CanILeave := True
        else
          begin
          if not DT1 and not DT2 and not(checkStr(StrList[CurrentLine+1], 'else')) then
            if checkEnd(StrList[CurrentLine], CurrentTreeNode)then
              CanILeave := True;
          Inc(CurrentLine);
          end;
        end;
      end;

    end;
end;

procedure CreatingDataModel();
begin
  CurrentLine := 1;
  DN1 := false;
  DN2 := false;
  SkipToStart(CurrentLine);
  TempTreeStructure := CreateNode; 
  StringListSeek(TempTreeStructure, DN1, DN2);
  TreeStructure := TempTreeStructure;
end;

end.



