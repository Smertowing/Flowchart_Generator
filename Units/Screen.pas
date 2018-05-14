unit Screen;

interface
  uses TypesAndVars,
       Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
       Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls,
       Vcl.ExtCtrls;

procedure clearScreen(Form: TForm; paintBox: TPaintBox);

implementation

procedure clearScreen(Form: TForm; paintBox: TPaintBox);
begin
  with paintBox do
    begin
      Canvas.Rectangle(0,0, Form.Width, form.Height);
    end;
end;


end.
