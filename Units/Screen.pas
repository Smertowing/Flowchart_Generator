unit Screen;

interface
  uses TypesAndVars, draw.Model, View,
       Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
       Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls,
       Vcl.ExtCtrls;

procedure clearScreen(Form: TForm; paintBox: TPaintBox);
procedure screenUpdate(Form: TForm; paintBox: TPaintBox);

implementation

procedure clearScreen(Form: TForm; paintBox: TPaintBox);
begin
  with PaintBox.Canvas do begin
  //    Brush.Color:=Form.Color;
      FillRect(PaintBox.ClientRect);
  end;
end;

procedure screenUpdate(Form: TForm; paintBox: TPaintBox);
var
  tempWidth, tempHeight: Integer;
begin
  clearScreen(Form, paintBox);
  tempWidth := paintBox.Width;
  tempHeight := paintBox.Height;
  drawModel(paintBox.Canvas, tempWidth, tempHeight);
  paintBox.Width := tempWidth;
  paintBox.Height := tempHeight;
end;

end.
