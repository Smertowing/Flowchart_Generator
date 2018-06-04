unit TypesAndVars;

interface
  uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls,
    Vcl.ExtCtrls;

  const
    numberOfStruc = 6;
    StrucNames: array[1..numberOfStruc] of string[15] = ({'implementation',} 'procedure', 'function', 'if', 'while', 'for', 'repeat');

    numberOfBlockDecl = 9;
    BlockDeclNames: array[1..numberOfBlockDecl] of string[10] = ('procedure', 'function', 'if', 'while', 'for', 'repeat', 'begin', 'code', 'else');

    maxBit = 15000;
    theEnd = 'End';
    basicHeight = 100;
    basicWidth = 200;
  type
    TFileMode  = (FBrakh, FBmp, FPng);

    PTreeStructure = ^TTreeStructure;
    TChilds = array of PTreeStructure;
    TTreeStructure = record
      BlockName : string[200];
      EndLine : Integer;
      DeclarationLine : integer;
      NumberOfChildren : integer;
      Children : TChilds;
    end;

    TStructuresList = (Terminator, Block, Choice, DataBlock, Loop, PredefinedBlock,Another);
    PDrawList = ^TDrawList;
    TChildsDraw = array of PDrawList;
    TDrawList = record
      x,y,space :inteGer;
  //    height,width: Integer;
      chAvailable : Boolean;
      numberOfChildren : integer;
      children : TChildsDraw;
      structure, hiddenstructure : TStructuresList;
      branch : PTreeStructure;
      caption : string;
      color : TColor;
    end;

  var
    StrList: TStringList;
    TreeStructure: PTreeStructure;
    DrawList: PDrawList;
    currentFile: string;
    FScale: Real;
    CurrMemo: TMemo;
    OnMouseProc: Boolean;
    CurrMemoX,CurrMemoY: integer;

implementation

end.
