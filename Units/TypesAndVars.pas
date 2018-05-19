unit TypesAndVars;

interface
  uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls,
    Vcl.ExtCtrls;

  const
    numberOfStruc = 7;
    StrucNames: array[1..numberOfStruc] of string[15] = ('implementation', 'procedure', 'function', 'if', 'while', 'for', 'repeat');

    numberOfBlockDecl = 9;
    BlockDeclNames: array[1..numberOfBlockDecl] of string[10] = ('procedure', 'function', 'if', 'while', 'for', 'repeat', 'begin', 'code', 'else');

    maxBit = 17000;
  type
    TFileMode  = (FBrakh, FBmp, FPng);

    PTreeStructure = ^TTreeStructure;
    TChilds = array of PTreeStructure;
    TTreeStructure = record
      BlockName : string[200];
  //    StartLine : integer;
      EndLine : Integer;
      DeclarationLine : integer;
  //    Coordinates : TCoord;
      NumberOfChildren : integer;
      Children : TChilds;
  //    NextOne : PTreeStructure;
    end;

    TStructuresList = (Terminator, Block, Choice, DataBlock, Loop, Another);
    PDrawList = ^TDrawList;
    TChildsDraw = array of PDrawList;
    TDrawList = record
  //   x,y,space  :inteher;
  //   height,width: Integer;
      chAvailable : Boolean;
  //   next : PDrawList;
      numberOfChildren : integer;
      children : TChildsDraw;
      structure : TStructuresList;
      branch : PTreeStructure;
      caption : string;
    end;

  var
    StrList: TStringList;
    TreeStructure: PTreeStructure;
    DrawList: PDrawList;
    currentFile: string;
    FScale: Real;


implementation

end.
