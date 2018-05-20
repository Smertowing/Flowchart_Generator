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
if (tempI > 1) and ((Str[tempI-1] = ' ') or (Str[tempI-1] = #9)) then
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
var   NextTreeNode, TempTreeNode: PTreeStructure;
   //   i: Integer;
      DT1, DT2: boolean;
   //   tempS1, tempS2: string;
begin
  if CurrentTreeNode^.BlockName <> '' then
  if not (checkStr(CurrentTreeNode^.BlockName, 'procedure')) and not (checkStr(CurrentTreeNode^.BlockName, 'function')) and not (checkStr(CurrentTreeNode^.BlockName, 'implementation')) then
  if (CurrentTreeNode^.NumberOfChildren <> 0) then
    begin
      if (CurrentLine - CurrentTreeNode^.Children[CurrentTreeNode^.NumberOfChildren-1]^.EndLine > 1) then
        begin
        Inc(CurrentTreeNode^.NumberOfChildren);
        SetLength(CurrentTreeNode^.Children, CurrentTreeNode^.NumberOfChildren);
        NextTreeNode := CreateNode;



        NextTreeNode^.DeclarationLine := CurrentTreeNode^.Children[CurrentTreeNode^.NumberOfChildren-2]^.EndLine + 1;
        NextTreeNode^.EndLine := CurrentLine-1;
        if checkStr(StrList[NextTreeNode^.DeclarationLine], 'else') then
          NextTreeNode^.BlockName := 'else'
        else
          NextTreeNode^.BlockName := 'code';
        NextTreeNode^.NumberOfChildren := 0;
        SetLength(NextTreeNode^.Children, 0);
        CurrentTreeNode^.Children[CurrentTreeNode^.NumberOfChildren - 1] := NextTreeNode;
        end;
    end;

  if CurrentTreeNode^.BlockName <> '' then
  if not (checkStr(CurrentTreeNode^.BlockName, 'procedure')) and not (checkStr(CurrentTreeNode^.BlockName, 'function')) and not (checkStr(CurrentTreeNode^.BlockName, 'implementation')) then
  if (CurrentTreeNode^.NumberOfChildren = 0) and (CurrentLine - CurrentTreeNode^.DeclarationLine > 1) then
    begin
      Inc(CurrentTreeNode^.NumberOfChildren);
      SetLength(CurrentTreeNode^.Children, CurrentTreeNode^.NumberOfChildren);
      NextTreeNode := CreateNode;
      NextTreeNode^.BlockName := 'code';
      NextTreeNode^.DeclarationLine := CurrentTreeNode^.DeclarationLine + 1;
      NextTreeNode^.EndLine := CurrentLine-1;
      NextTreeNode^.NumberOfChildren := 0;
      SetLength(NextTreeNode^.Children, 0);
      CurrentTreeNode^.Children[CurrentTreeNode^.NumberOfChildren - 1] := NextTreeNode;
    end;

  Inc(CurrentTreeNode^.NumberOfChildren);
  SetLength(CurrentTreeNode^.Children, CurrentTreeNode^.NumberOfChildren);

  NextTreeNode := CreateNode;
  NextTreeNode^.BlockName := Trim(str);
  NextTreeNode^.DeclarationLine := CurrentLine;

  DT1 := false;
  DT2 := false;
  if checkStr(Str, 'begin')  or checkStr(str, 'implementation') then  inc(DT1);
  if checkStr(Str, 'repeat')  then  inc(DT2);

  Inc(CurrentLine);
if checkStr(Str, 'procedure') or checkStr(Str,'function')  then  skipToAfterFP(CurrentLine);



  StringListSeek(NextTreeNode, DT1, DT2);
  if checkStr(NextTreeNode^.BlockName, 'begin') then
    begin
      NextTreeNode^.EndLine := CurrentLine;

      if (NextTreeNode^.NumberOfChildren <> 0) and (CurrentLine - NextTreeNode^.Children[NextTreeNode^.NumberOfChildren-1]^.EndLine > 1) then
        begin
          Inc(NextTreeNode^.NumberOfChildren);
          SetLength(NextTreeNode^.Children, NextTreeNode^.NumberOfChildren);
          TempTreeNode := CreateNode;
          TempTreeNode^.BlockName := 'code';
          TempTreeNode^.DeclarationLine := NextTreeNode^.Children[NextTreeNode^.NumberOfChildren-2]^.EndLine + 1;
          TempTreeNode^.EndLine := CurrentLine-1;
          TempTreeNode^.NumberOfChildren := 0;
          SetLength(TempTreeNode^.Children, 0);
          NextTreeNode^.Children[NextTreeNode^.NumberOfChildren - 1] := TempTreeNode;
        end;

      if (NextTreeNode^.NumberOfChildren = 0) and (CurrentLine - NextTreeNode^.DeclarationLine > 1) then
        begin
          Inc(NextTreeNode^.NumberOfChildren);
          SetLength(NextTreeNode^.Children, NextTreeNode^.NumberOfChildren);
          TempTreeNode := CreateNode;
          TempTreeNode^.BlockName := 'code';
          TempTreeNode^.DeclarationLine := NextTreeNode^.DeclarationLine + 1;
          TempTreeNode^.EndLine := CurrentLine-1;
          TempTreeNode^.NumberOfChildren := 0;
          SetLength(TempTreeNode^.Children, 0);
          NextTreeNode^.Children[NextTreeNode^.NumberOfChildren - 1] := TempTreeNode;
        end;

    end
  else
    begin
      if (checkStr(NextTreeNode^.BlockName, 'for') or checkStr(NextTreeNode^.BlockName, 'while')) and (NextTreeNode^.NumberOfChildren = 0)  then
      begin
        NextTreeNode^.EndLine := CurrentLine-1;

        Inc(NextTreeNode^.NumberOfChildren);
        SetLength(NextTreeNode^.Children, NextTreeNode^.NumberOfChildren);
        TempTreeNode := CreateNode;
        TempTreeNode^.BlockName := 'code';
        TempTreeNode^.DeclarationLine := NextTreeNode^.DeclarationLine + 1;
        TempTreeNode^.EndLine := CurrentLine-1;
        TempTreeNode^.NumberOfChildren := 0;
        SetLength(TempTreeNode^.Children, 0);
        NextTreeNode^.Children[NextTreeNode^.NumberOfChildren - 1] := TempTreeNode;
      end
      else
      NextTreeNode^.EndLine := CurrentLine-1;
    end;
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
    if (checkStr(CurrentTreeNode^.BlockName,'for') or checkStr(CurrentTreeNode^.BlockName,'while')) and (CurrentTreeNode^.DeclarationLine = CurrentLine-1) and checkEnd(StrList[currentLine], CurrentTreeNode) then
      begin
      canILeave:=True;
      inc(currentLine);
      end
    else
      begin

      if checkStr(CurrentTreeNode^.BlockName,'if') and (CurrentTreeNode^.NumberOfChildren = 3) then
        canILeave:=True
      else
        begin

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
              if not(checkStr(StrList[CurrentLine+1], 'else')) then
                begin
                if checkEnd(StrList[CurrentLine], CurrentTreeNode)then
                  CanILeave := True;
                end;

                Inc(CurrentLine);
                if (checkStr(StrList[CurrentLine], 'else')) then
                  CanILeave := True;

              end;
            end;
          end;
        end;
      end;

    end;
end;

procedure HealTreeStructure(var HeadTree: PTreeStructure);
var
  tempTree: PTreeStructure;
  i: Integer;
begin
  if (HeadTree^.NumberOfChildren = 1) then
    if (checkStr(HeadTree^.Children[0]^.BlockName, 'implementation')) then
    begin
      tempTree := HeadTree^.Children[0];
      HeadTree^.NumberOfChildren :=  tempTree^.NumberOfChildren;
      SetLength(HeadTree^.Children, HeadTree^.NumberOfChildren);
      for i := 0 to HeadTree^.NumberOfChildren - 1 do
        begin
          HeadTree^.Children[i] := tempTree^.Children[i];
        end;
    Dispose(tempTree);
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
  HealTreeStructure(TempTreeStructure);
  TreeStructure := TempTreeStructure;
end;

end.



