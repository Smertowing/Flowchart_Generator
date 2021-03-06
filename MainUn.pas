unit MainUn;

interface

uses
  TypesAndVars, data.Model, draw.Structures, draw.Model, View, Screen,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, System.Actions, Vcl.ActnList, Vcl.Imaging.pngimage, Vcl.DBCtrls;

type
  TFFlowChart_Manager = class(TForm)
    pnlMemoTree: TPanel;
    trMainTree: TTreeView;
    splMemoTree: TSplitter;
    MainMenu: TMainMenu;
    scrMain: TScrollBox;
    pbMain: TPaintBox;
    dlgOpenFile: TOpenDialog;
    alMain: TActionList;
    fileOpen: TAction;
    fileSavePNG: TAction;
    fileSaveBMP: TAction;
    File1: TMenuItem;
    fileOpen1: TMenuItem;
    fileSavePNG1: TMenuItem;
    fileSaveBMP1: TMenuItem;
    dlgSaveFlowchart: TSaveDialog;
    mmoInput: TMemo;
    reMainEdit: TRichEdit;
    N1: TMenuItem;
    chkMode: TCheckBox;
    procedure StartRoutine();
    procedure createtree();
    procedure FormDestroy(Sender: TObject);
    procedure RecTreeConstructor(const shift: Integer; TempTreeStructure: PTreeStructure);
    procedure pbMainPaint(Sender: TObject);
    procedure scrMainMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure scrMainMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure fileOpenExecute(Sender: TObject);
    function saveFile(mode: TFileMode):string;
 //   procedure CheckBlockHint();
    procedure savePNGFile;
    procedure saveBMPFile;
    procedure fileSavePNGExecute(Sender: TObject);
    procedure fileSaveBMPExecute(Sender: TObject);
    procedure pbMainDblClick(Sender: TObject);
    procedure pbMainClick(Sender: TObject);
    procedure keyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure chkModeClick(Sender: TObject);
{    procedure pbMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbMainMouseLeave(Sender: TObject);          }
  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  FFlowChart_Manager: TFFlowChart_Manager;
  FileUsed: TextFile;
  TempNode: TTreeNode;
  CurrentMaxNode: Integer;

implementation

{$R *.dfm}

procedure TFFlowChart_Manager.FormDestroy(Sender: TObject);
begin
//strList.Free;
if TreeStructure <> nil then
  EraseTree(TreeStructure);
TreeStructure:=nil;
if DrawList <> nil then
  EraseDrawList(DrawList);
Drawlist:=nil;
end;

procedure TFFlowChart_Manager.pbMainClick(Sender: TObject);
var
  a,b, temp:integer;
  i: Integer;
  foo: TPoint;
  X,Y:integer;
begin
  foo.X := (pbMain.Left + scrMain.Left + FFlowchart_Manager.Left);
  foo.Y := (pbMain.Top + scrMain.Top + FFlowchart_Manager.Top + 100);
  X:= Mouse.CursorPos.X - foo.x;
  Y:= Mouse.CursorPos.Y - foo.y;

  if chkMode.checked then
    begin
      changeTheirMind(x,y);
    end
  else
    begin
      RestoreDafault();
    {  reMainEdit.SelStart:=0;
      reMainEdit.SelLength:=0;
      for i := 0 to reMainEdit.Lines.Count - 1 do
        begin
          reMainEdit.SelLength:=reMainEdit.SelLength + Length(reMainEdit.Lines[i]);
        end;
      reMainEdit.SelAttributes.Color := clBlack;       }
      reMainEdit.SelectAll;
      reMainEdit.SelAttributes.Color := clBlack;
      a:=-1;
      b:=-1;

      FindAndBlue(X,Y,a,b);


      if (a <> -1) and (b<>-1) then
      begin
        temp:=0;
        for i := 0 to a-1 do
          begin
            temp:=temp+length(StrList[i]);
          end;
        reMainEdit.SelStart:=temp+a;
        reMainEdit.SelLength:=0;
        for i := a to b do
          begin
            reMainEdit.SelLength:=reMainEdit.SelLength + Length(StrList[i]);
          end;
        reMainEdit.SelLength:=reMainEdit.SelLength+b-a;
        reMainEdit.SelAttributes.Color := clBlue;
      end;
    end;

  pbMain.Repaint;
end;

procedure TFFlowChart_Manager.keyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  S:string;
  i: Integer;
begin 
  if (Key = VK_ESCAPE) or ((key = VK_RETURN) and not(ssShift in Shift)) then
    begin
      S:='';
      for i := 0 to CurrMemo.Lines.Count do
        S:=S+CurrMemo.Lines[i];

      FindBranchAndResetCaption(CurrMemoX,CurrMemoY,S);
      CurrMemo.Visible:=false;
      pbMain.Repaint;
    end;
end;

procedure TFFlowChart_Manager.pbMainDblClick(Sender: TObject);
var
  a,b, temp:integer;
  i: Integer;
  foo: TPoint;
  X,Y:integer;
  S:string;
begin
  foo.X := (pbMain.Left + scrMain.Left + FFlowchart_Manager.Left);
  foo.Y := (pbMain.Top + scrMain.Top + FFlowchart_Manager.Top + 100);
  X:= Mouse.CursorPos.X - foo.x;
  Y:= Mouse.CursorPos.Y - foo.y;

  if chkMode.checked then
    begin
      a:=-1;
      b:=-1;
      S:='';
      FindBranch(x,y,a,b,S);
      if a>=0 then
        begin
          if CurrMemo <> nil then
            freeandnil(CurrMemo);
          CurrMemoX := a;
          CurrMemoY := b;
          CurrMemo := TMemo.Create(Self);
          with CurrMemo do
            begin
              Parent:=scrMain;
              currmemo.OnKeyDown := keyDown;
              visible := true;
              Left := a+pbMain.Left;
              Top := b+pbMain.Top;
              Width := basicWidth;
              Height := basicHeight;
              lines[0] := S;
              SetFocus;
            end;
          Self.Invalidate;
        end;
    end
  else
    begin
    ChangeChildrenState(X,Y);
    pbMain.Repaint;
    end;

end;

{procedure TFlowchart_Manager.CheckBlockHint();
var
  foo: TPoint;
  X,Y,a,b:integer;
  str:string;
begin
  foo.X := (pbMain.Left + scrMain.Left + Flowchart_Manager.Left);
  foo.Y := (pbMain.Top + scrMain.Top + Flowchart_Manager.Top + 100);
  X:= Mouse.CursorPos.X - foo.x;
  Y:= Mouse.CursorPos.Y - foo.y;

  a:=-1;
  b:=-1;
  str:='';

  if DrawList <> nil then
    FindBranch(X,Y,a,b,Str);
  if str <> '' then
    begin
    pbMain.Hint := str;
    pbMain.ShowHint := true;
    application.HintPause := 1;
    end
  else
    if OnMouseProc then
      CheckBlockHint;
end;

procedure TFlowchart_Manager.pbMainMouseLeave(Sender: TObject);
begin
  OnMouseProc:=False;
end;

procedure TFlowchart_Manager.pbMainMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  OnMouseProc:=True;
  CheckBlockHint;
end;
                                         }
procedure TFFlowChart_Manager.pbMainPaint(Sender: TObject);
begin
  if DrawList <> nil then
    screenUpdate(FFlowchart_Manager,pbMain);
end;

procedure TFFlowChart_Manager.RecTreeConstructor(const shift: Integer; TempTreeStructure: PTreeStructure);
var
  i: Integer;
  tempI: Integer;
begin
  i := 1;
  while i <= TempTreeStructure^.NumberOfChildren do
    begin
    inc(currentMaxNode);
    trMainTree.Items.AddChild(trMainTree.Items[shift], TempTreeStructure^.Children[i-1]^.BlockName);

    if TempTreeStructure^.Children[i-1]^.NumberOfChildren > 0 then
      begin
      tempI := CurrentMaxNode;
      RecTreeConstructor(tempI, TempTreeStructure^.Children[i-1]);
      end;
    inc(i);
    end;
end;

procedure TFFlowChart_Manager.scrMainMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  (Sender as TScrollBox).VertScrollBar.Position := (Sender as TScrollBox).VertScrollBar.Position - (Sender as TScrollBox).VertScrollBar.Increment;
end;

procedure TFFlowChart_Manager.scrMainMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  (Sender as TScrollBox).VertScrollBar.Position := (Sender as TScrollBox).VertScrollBar.Position + (Sender as TScrollBox).VertScrollBar.Increment;
end;

procedure TFFlowChart_Manager.chkModeClick(Sender: TObject);
begin
  if CurrMemo<>nil then
    if CurrMemo.Visible then
      CurrMemo.Visible:=false;
end;

procedure TFFlowChart_Manager.CreateTree();
begin
trMainTree.Items.Clear;
trMainTree.Items.Add(nil, StrList[0]);
CurrentMaxNode := 0;
RecTreeConstructor(0, TreeStructure);
end;

procedure TFFlowChart_Manager.fileOpenExecute(Sender: TObject);
var
  buttonSelect: Integer;
begin

  dlgOpenFile.Filter := 'Pascal files (*.pas, *.dpr)|*.PAS;*.DPR| Text files (*.txt)|*.TXT|';
  if dlgOpenFile.Execute then
  begin
    try
    CurrentFile := dlgOpenFile.FileName;
    clearScreen(FFlowchart_Manager,pbMain);
    TreeStructure := nil;
    StartRoutine();

    CreatingDataModel();
    createtree;

    clearScreen(FFlowchart_Manager,pbMain);
    if TreeStructure <> nil then
      CreatingDrawModel(FFlowchart_Manager, pbMain);
    Screen.screenUpdate(FFlowChart_Manager,pbMain);
    fileSavePNG.Enabled:=true;
    fileSaveBMP.Enabled:=true;

    except
      pbMain.Height := FFlowChart_Manager.ClientHeight;
      pbMain.Width := FFlowChart_Manager.ClientWidth;
      clearScreen(FFlowchart_Manager,pbMain);
       strList.Free;
      if TreeStructure <> nil then
        EraseTree(TreeStructure);
      TreeStructure := nil;
      if DrawList <> nil then
        EraseDrawList(DrawList);
      trMainTree.Items.Clear;
      DrawList:=nil;
      reMainEdit.Lines.Clear;
      pbMain.Height := 0;
      pbMain.Width := 0;
      buttonSelect := MessageDlg('File could not be processed, please, try valid code file',mtWarning,[mbRetry, mbOk], 0);
      if buttonSelect = 4 then
        fileOpenExecute(Sender);

    end;
  end;
end;

procedure TFFlowChart_Manager.fileSaveBMPExecute(Sender: TObject);
begin
  saveBMPFile;
end;

procedure TFFlowChart_Manager.fileSavePNGExecute(Sender: TObject);
begin
  savePNGFile;
end;

procedure TFFlowChart_Manager.StartRoutine();
var
  S,tmpS:string;
  Posit:Integer;
begin
reMainEdit.Lines.Clear;
//if FileExists(currentFile) then
//  reMainEdit.Lines. LoadFromFile(currentFile);

AssignFile(FileUsed, currentFile);
Reset(FileUsed);

StrList:=TStringList.Create;
StrList.Sorted:=False;
StrList.Duplicates:=dupAccept;

while not Eof(FileUsed) do
  begin
  repeat
  Readln(FileUsed, S);
  until (Trim(s) <>'') or eof(FileUsed);
{  if checkStr(S,'exit') or checkStr(S,'break') or checkStr(S,'continue') or checkStr(S,'case')then
    begin
    ShowMessage('Warning! Non-structural algorithm');
    end;                        }
  Posit:=AnsiPos('//', S);
  Delete(S,Posit,length(s)-Posit+1);

  if AnsiPos('{', S) <> 0 then
    begin
      Posit:=AnsiPos('{', S);
      Delete(S,Posit,length(s)-Posit+1);
 //     if Trim(s) <> '' then
        StrList.Add(S);
      repeat
      Readln(FileUsed,S)
      until  (AnsiPos('', S) = 0) or Eof(FileUsed);
      Posit:=AnsiPos('', S);
      Delete(S,1,Posit);
    end;

  Posit:=AnsiPos('//', S);
  Delete(S,Posit,length(s)-Posit+1);
 // if Trim(s) <> '' then
    StrList.Add(S);
  end;
    reMainEdit.Lines.AddStrings(StrList);
CloseFile(FileUsed);
end;

function TFFlowChart_Manager.saveFile(mode: TFileMode):string;
begin
  Result := '';
  case mode of
    FBrakh:
    begin
      dlgSaveFlowchart.FileName := 'FlowChart.brakh';
      dlgSaveFlowchart.Filter := 'Source-File|*.brakh';
      dlgSaveFlowchart.DefaultExt := 'brakh';
    end;
    FBmp:
    begin
      dlgSaveFlowchart.FileName := 'FlowChart.bmp';
      dlgSaveFlowchart.Filter := 'Bitmap Picture|*.bmp';
      dlgSaveFlowchart.DefaultExt := 'bmp';
    end;
    FPng:
     begin
      dlgSaveFlowchart.FileName := 'FlowChart.png';
      dlgSaveFlowchart.Filter := 'PNG|*.png';
      dlgSaveFlowchart.DefaultExt := 'png';
    end;
  end;
  if dlgSaveFlowchart.Execute then
  begin
    Result := dlgSaveFlowchart.FileName;
  end;

end;

procedure TFFlowChart_Manager.saveBMPFile;
var
  path: string;
  tempWidth, tempHeight: Integer;
const
  ExportScale = 4;
begin
//  oldScale := FScale;
  path := saveFile(FBmp);
  if path <> '' then
  begin
 //   ClickFigure := nil;
    with TBitMap.Create do
    begin
      Height := maxBit;
      Width := maxBit;
//      FScale := ExportScale;
      tempWidth := 0;
      tempHeight := 0;
      drawModel(Canvas, tempWidth, tempHeight);
      Width := tempWidth;
      Height := tempHeight;
//      FScale := oldScale;
      SaveToFile(path);
      free;
    end;
  end;
end;

procedure TFFlowChart_Manager.savePNGFile;
var
  path: string;
  png : TPngImage;
  bitmap: TBitmap;
  tempWidth, tempHeight: Integer;
const
  ExportScale = 4;
begin
  path := saveFile(FPng);
  if path <> '' then
  begin
//    ClickFigure := nil;
    try
      bitmap := TBitMap.Create;
      bitmap.Height := maxBit;
      bitmap.Width := maxBit;
      with bitmap do
      begin
        png := TPNGImage.Create;
   //     FScale := ExportScale;
        tempWidth := 0;
        tempHeight := 0;
        drawModel(Canvas, tempWidth, tempHeight);
        Width := tempWidth;
        Height := tempHeight;
   //     FScale := oldScale;
      end;
        png.Assign(bitmap);
        png.Draw(bitmap.Canvas, Rect(0, 0, bitmap.Width, bitmap.Height));
        png.SaveToFile(path)
     finally
        bitmap.free;
        png.free;
    end;
  end;
end;


end.
