unit draw.Structures;

interface
  uses TypesAndVars,
       Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
       Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls,
       Vcl.ExtCtrls, System.Actions, Vcl.ActnList;

  procedure drawTerminator(Canv:TCanvas; x,y,width,height,space:Integer);
  procedure drawFunctionalBlock(Canv:TCanvas; x,y,width,height,space:Integer);
  procedure drawBinaryChoice(Canv:TCanvas; x,y,width,height,space:Integer);
  procedure drawDataBlock(Canv:TCanvas; x,y,width,height,space:Integer);
  procedure drawLoop(Canv:TCanvas; x,y,width,height, space:Integer);
  procedure drawLine(Canv:TCanvas; x1,y1,x2,y2:Integer);

implementation

procedure drawTerminator(Canv:TCanvas; x,y,width,height, space:Integer);
var R:Integer;
begin
  R:=round(height/2);
  with Canv do
    begin
      Arc(x,y,x+height,y+height,x+R,y,x+R,y+height);
      Arc(x+width-height,y,x+width,y+height,x+width-R,y+height,x+width-R,y);
      MoveTo(x+r,y);
      LineTo(x+width-r,y);
      MoveTo(x+r,y+height);
      LineTo(x+width-r,y+height);
    end;
  y := y+space;
  with Canv do
    begin
      Arc(x,y,x+height,y+height,x+R,y,x+R,y+height);
      Arc(x+width-height,y,x+width,y+height,x+width-R,y+height,x+width-R,y);
      MoveTo(x+r,y);
      LineTo(x+width-r,y);
      MoveTo(x+r,y+height);
      LineTo(x+width-r,y+height);
    end;
end;

procedure drawFunctionalBlock(Canv:TCanvas; x,y,width,height, space:Integer);
begin
  y := y+space;
  with Canv do
    begin
      MoveTo(x,y);
      LineTo(x+width,y);
      LineTo(x+width,y+height);
      LineTo(x,y+height);
      LineTo(x,y);
    end;
end;

procedure drawBinaryChoice(Canv:TCanvas; x,y,width,height,space:Integer);
var R1,R2:Integer;
begin
  R1:=Round(height/2);
  R2:=Round(width/2);
  with Canv do
    begin
      MoveTo(x+R2,y);
      LineTo(x+width,y+R1);
      LineTo(x+R2,y+height);
      LineTo(x,y+R1);
      LineTo(x+R2,y);
    end;
end;

procedure drawDataBlock(Canv:TCanvas; x,y,width,height,space:Integer);
var R:Integer;
begin
  y := y+space;
  R:=Round(width/4);
  with Canv do
    begin
      MoveTo(x+R,y);
      LineTo(x+width,y);
      LineTo(x+width-R,y+height);
      LineTo(x,y+height);
      LineTo(x+R,y);
    end;
end;

procedure drawLoop(Canv:TCanvas; x,y,width,height, space:Integer);
var R1,R2:Integer;
begin
  R1:=Round(height/4);
  R2:=Round(width/4);
  with Canv do
    begin
      MoveTo(x+R2,y);
      LineTo(x+width-R2,y);
      LineTo(x+width,y+R1);
      LineTo(x+width,y+height);
      LineTo(x,y+height);
      LineTo(x,y+R1);
      LineTo(x+R2,y);
    end;
  y:= y + space;
  with Canv do
    begin
      MoveTo(x,y);
      LineTo(x+width,y);
      LineTo(x+width,y+height-R1);
      LineTo(x+width-R2,y+height);
      LineTo(x+R2,y+height);
      LineTo(x,y+height-R1);
      LineTo(x,y);
    end;
end;

procedure drawLine(Canv:TCanvas; x1,y1,x2,y2:Integer);
begin
  if (x1=x2) or (y1=y2) then
    with Canv do
      begin
        MoveTo(x1,y1);
        LineTo(x2,y2);
      end
   else
    begin   
      if x1>x2 then
        begin
          with Canv do
          begin
            MoveTo(x1,y1);
            LineTo(x1,y2);
            LineTo(x2,y2);
            LineTo(x2+10,y2+5);
            MoveTo(x2,y2);
            LineTo(x2+10,y2-5);
          end
        end
      else
        begin
          with Canv do
          begin
            MoveTo(x1,y1);
            LineTo(x2,y1);
            LineTo(x2,y2);
            LineTo(x2+5,y2-10);
            MoveTo(x2,y2);
            LineTo(x2-5,y2-10);
           end
        end;
    end;
end;

end.
