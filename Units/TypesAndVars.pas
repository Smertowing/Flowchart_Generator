unit TypesAndVars;

interface
  uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls,
    Vcl.ExtCtrls;

  const
    numberOfStruc = 7;
    StrucNames: array[1..numberOfStruc] of string[15] = ('implementation', 'procedure', 'function', 'if', 'while', 'for', 'repeat');

  type
    TCoord = record
      x, y: Integer;
    end;

    PTreeStructure = ^TTreeStructure;
    TChilds = array of PTreeStructure;
    TTreeStructure = record
      BlockName : string[100];
  //    StartLine : integer;
      EndLine : Integer;
      DeclarationLine : integer;
      Coordinates : TCoord;
      NumberOfChildren : integer;
      Children : TChilds;
  //    NextOne : PTreeStructure;
    end;

  var
    StrList: TStringList;
    TreeStructure: PTreeStructure;
    currentFile: string;
implementation

end.
