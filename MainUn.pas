unit MainUn;

interface

uses
  TypesAndVars, data.Model, draw.Structures, draw.Model, View, Screen,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, System.Actions, Vcl.ActnList, Vcl.Imaging.pngimage, Vcl.DBCtrls;

type
  TFlowchart_Manager = class(TForm)
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
    btnTemp: TButton;
    dlgSaveFlowchart: TSaveDialog;
    mmoInput: TMemo;
    reMainEdit: TRichEdit;
    N1: TMenuItem;
    chkMode: TCheckBox;
    procedure StartRoutine();
    procedure createtree();
    procedure FormDestroy(Sender: TObject);
    procedure RecTreeConstructor(const shift: Integer; TempTreeStructure: PTreeStructure);
    procedure btnTempClick(Sender: TObject);
    procedure pbMainPaint(Sender: TObject);
    procedure scrMainMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure scrMainMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure fileOpenExecute(Sender: TObject);
    function saveFile(mode: TFileMode):string;

    procedure savePNGFile;
    procedure saveBMPFile;
    procedure fileSavePNGExecute(Sender: TObject);
    procedure fileSaveBMPExecute(Sender: TObject);
    procedure pbMainDblClick(Sender: TObject);
    procedure pbMainClick(Sender: TObject);
    procedure keyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure chkModeClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  Flowchart_Manager: TFlowchart_Manager;
  FileUsed: TextFile;
  TempNode: TTreeNode;
  CurrentMaxNode: Integer;

implementation

{$R *.dfm}

procedure TFlowchart_Manager.FormDestroy(Sender: TObject);
begin
strList.Free;
if TreeStructure <> nil then
  EraseTree(TreeStructure);
if DrawList <> nil then
  EraseDrawList(DrawList);
end;

procedure TFlowchart_Manager.pbMainClick(Sender: TObject);
var
  a,b, temp:integer;
  i: Integer;
  foo: TPoint;
  X,Y:integer;
begin
  foo.X := (pbMain.Left + scrMain.Left + Flowchart_Manager.Left);
  foo.Y := (pbMain.Top + scrMain.Top + Flowchart_Manager.Top + 100);
  X:= Mouse.CursorPos.X - foo.x;
  Y:= Mouse.CursorPos.Y - foo.y;

  if chkMode.checked then
    begin
      changeTheirMind(x,y);
    end
  else
    begin
      RestoreDafault();
      reMainEdit.SelStart:=0;
      reMainEdit.SelLength:=0;
      for i := 0 to reMainEdit.Lines.Count - 1 do
        begin
          reMainEdit.SelLength:=reMainEdit.SelLength + Length(reMainEdit.Lines[i]);
        end;
      reMainEdit.SelAttributes.Color := clBlack;

      a:=-1;
      b:=-1;

      FindAndBlue(X,Y,a,b);


  
      temp:=0;
      for i := 0 to a do
        begin
          temp:=temp+length(reMainEdit.Lines[i]);
        end;
      reMainEdit.SelStart:=temp-length(reMainEdit.Lines[a-1]);
      reMainEdit.SelLength:=0;
      for i := a to b do
        begin
          reMainEdit.SelLength:=reMainEdit.SelLength + Length(reMainEdit.Lines[i]);
        end;
      reMainEdit.SelAttributes.Color := clBlue;
    end;

  pbMain.Repaint;
end;

procedure TFlowchart_Manager.keyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  S:string;
  i: Integer;
begin 
  if (Key = VK_ESCAPE) or ((key = VK_RETURN) and not(ssShift in Shift)) then
    begin
      S:='';
      for i := 0 to CurrMemo.Lines.Count do
        S:=S+CurrMemo.Lines[i];

      FindBranchAndResetCaption(CurrMemo.Left,CurrMemo.Top,S);
      CurrMemo.Visible:=false;
      pbMain.Repaint;
    end;
end;

procedure TFlowchart_Manager.pbMainDblClick(Sender: TObject);
var
  a,b, temp:integer;
  i: Integer;
  foo: TPoint;
  X,Y:integer;
  S:string;
begin
  foo.X := (pbMain.Left + scrMain.Left + Flowchart_Manager.Left);
  foo.Y := (pbMain.Top + scrMain.Top + Flowchart_Manager.Top + 100);
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

procedure TFlowchart_Manager.pbMainPaint(Sender: TObject);
begin
  if DrawList <> nil then
    screenUpdate(Flowchart_Manager,pbMain);
end;

procedure TFlowchart_Manager.RecTreeConstructor(const shift: Integer; TempTreeStructure: PTreeStructure);
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

procedure TFlowchart_Manager.scrMainMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  (Sender as TScrollBox).VertScrollBar.Position := (Sender as TScrollBox).VertScrollBar.Position - (Sender as TScrollBox).VertScrollBar.Increment;
end;

procedure TFlowchart_Manager.scrMainMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  (Sender as TScrollBox).VertScrollBar.Position := (Sender as TScrollBox).VertScrollBar.Position + (Sender as TScrollBox).VertScrollBar.Increment;
end;

procedure TFlowchart_Manager.btnTempClick(Sender: TObject);
begin
//  drawTerminator(pbMain,50,50,100,50);
//  drawFunctionalBlock(pbMain, 50,50,100,50);
//  drawBinaryChoice(pbMain,50,50,100,50);
//  drawLoop(pbMain,50,50,100,50,400)
//  drawDataBlock(pbMain,50,50,100,50);
end;

procedure TFlowchart_Manager.chkModeClick(Sender: TObject);
begin
  if CurrMemo<>nil then
    if CurrMemo.Visible then
      CurrMemo.Visible:=false;
end;

procedure TFlowchart_Manager.CreateTree();
begin
trMainTree.Items.Clear;
trMainTree.Items.Add(nil, StrList[0]);
CurrentMaxNode := 0;
RecTreeConstructor(0, TreeStructure);
end;

procedure TFlowchart_Manager.fileOpenExecute(Sender: TObject);
begin

  dlgOpenFile.Filter := 'Pascal files (*.pas, *.dpr)|*.PAS;*.DPR| Text files (*.txt)|*.TXT|';
  if dlgOpenFile.Execute then
  begin
    CurrentFile := dlgOpenFile.FileName;
    clearScreen(Flowchart_Manager,pbMain);
    TreeStructure := nil;
    StartRoutine();

    CreatingDataModel();
    createtree;

    clearScreen(Flowchart_Manager,pbMain);
    if TreeStructure <> nil then
      CreatingDrawModel(Flowchart_Manager, pbMain);

    fileSavePNG.Enabled:=true;
    fileSaveBMP.Enabled:=true;
  end;
end;

procedure TFlowchart_Manager.fileSaveBMPExecute(Sender: TObject);
begin
  saveBMPFile;
end;

procedure TFlowchart_Manager.fileSavePNGExecute(Sender: TObject);
begin
  savePNGFile;
end;

procedure TFlowchart_Manager.StartRoutine();
var
  S,tmpS:string;
  Posit:Integer;
begin
reMainEdit.Lines.Clear;
if FileExists(currentFile) then
  reMainEdit.Lines. LoadFromFile(currentFile);

AssignFile(FileUsed, currentFile);
Reset(FileUsed);

StrList:=TStringList.Create;
StrList.Sorted:=False;
StrList.Duplicates:=dupAccept;

while not Eof(FileUsed) do
  begin
  Readln(FileUsed, S);
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
      StrList.Add(S);
      repeat
      Readln(FileUsed,S)
      until  (AnsiPos('', S) = 0) or Eof(FileUsed);
      Posit:=AnsiPos('', S);
      Delete(S,1,Posit);
    end;

  Posit:=AnsiPos('//', S);
  Delete(S,Posit,length(s)-Posit+1);

  StrList.Add(S);
  end;

CloseFile(FileUsed);
end;

function TFlowchart_Manager.saveFile(mode: TFileMode):string;
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

procedure TFlowchart_Manager.saveBMPFile;
var
  path: string;
  oldScale: real;
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

procedure TFlowchart_Manager.savePNGFile;
var
  path: string;
  oldScale: real;
  png : TPngImage;
  bitmap: TBitmap;
  tempWidth, tempHeight: Integer;
const
  ExportScale = 4;
begin
  oldScale := FScale;
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
