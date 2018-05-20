unit draw.Structures;

interface
  uses TypesAndVars,
       Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
       Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls,
       Vcl.ExtCtrls, System.Actions, Vcl.ActnList;

  procedure drawTerminator(Canv:TCanvas; x,y,width,height, space:Integer; caption:string; color:TColor);
  procedure drawFunctionalBlock(Canv:TCanvas; x,y,width,height,space:Integer; caption:string; color:TColor);
  procedure drawPredefinedBlock(Canv:TCanvas; x,y,width,height,space:Integer; caption:string; color:TColor);
  procedure drawBinaryChoice(Canv:TCanvas; x,y,width,height,space:Integer; caption:string; color:TColor);
  procedure drawDataBlock(Canv:TCanvas; x,y,width,height,space:Integer; caption:string; color:TColor);
  procedure drawLoop(Canv:TCanvas; x,y,width,height, space:Integer; caption:string; color:TColor);
  procedure drawLine(Canv:TCanvas; x1,y1,x2,y2:Integer);

implementation

procedure drawTerminator(Canv:TCanvas; x,y,width,height, space:Integer; caption:string; color:TColor);
var R:Integer;
    S:string;
    i:integer;
begin
  if Canv.TextWidth(caption) > Round(Width*0.9) then
    begin
      S:='';
      i:=1;
      while Canv.TextWidth(s) < Round(Width*0.9) do
        begin
          S:=S+caption[i];
          Inc(i);
        end;
      for i := Length(S) downto Length(s)-2 do
        S[i]:='.';
      Caption:=S;
    end;

  R:=round(height/2);
  with Canv do
    begin
      Pen.Width := 2;
      Pen.Color := color;
      Arc(x,y,x+height,y+height,x+R,y,x+R,y+height);
      Arc(x+width-height,y,x+width,y+height,x+width-R,y+height,x+width-R,y);
      MoveTo(x+r,y);
      LineTo(x+width-r,y);
      MoveTo(x+r,y+height);
      LineTo(x+width-r,y+height);
      TextOut((x + Width div 2)-(canv.TextWidth('begin') div 2), y+(height div 2)-20, 'begin');
      TextOut((x + Width div 2)-(canv.TextWidth(caption) div 2), y+(height div 2)-10, caption);
    end;
  y := y+space;
  with Canv do
    begin
      Pen.Width := 2;
      Pen.Color := color;
      Arc(x,y,x+height,y+height,x+R,y,x+R,y+height);
      Arc(x+width-height,y,x+width,y+height,x+width-R,y+height,x+width-R,y);
      MoveTo(x+r,y);
      LineTo(x+width-r,y);
      MoveTo(x+r,y+height);
      LineTo(x+width-r,y+height);
      TextOut((x + Width div 2)-(canv.TextWidth('end') div 2), y+(height div 2)-10, 'end');
    end;
end;

procedure drawFunctionalBlock(Canv:TCanvas; x,y,width,height, space:Integer; caption:string; color:TColor);
var
  S:string;
  i:Integer;
begin
  if Canv.TextWidth(caption) > Round(Width*0.9) then
    begin
      S:='';
      i:=1;
      while Canv.TextWidth(s) < Round(Width*0.9) do
        begin
          S:=S+caption[i];
          Inc(i);
        end;
      for i := Length(S) downto Length(s)-2 do
        S[i]:='.';
      Caption:=S;
    end;

  y := y+space;
  with Canv do
    begin
      Pen.Width := 2;
      Pen.Color := color;
      MoveTo(x,y);
      LineTo(x+width,y);
      LineTo(x+width,y+height);
      LineTo(x,y+height);
      LineTo(x,y);
      TextOut((x + Width div 2)-(canv.TextWidth(caption) div 2), y+(height div 2)-10, caption);
    end;
end;

procedure drawPredefinedBlock(Canv:TCanvas; x,y,width,height, space:Integer; caption:string; color:TColor);
var
  S:string;
  i:Integer;
begin
  if Canv.TextWidth(caption) > Round(Width*0.7) then
    begin
      S:='';
      i:=1;
      while Canv.TextWidth(s) < Round(Width*0.7) do
        begin
          S:=S+caption[i];
          Inc(i);
        end;
      for i := Length(S) downto Length(s)-2 do
        S[i]:='.';
      Caption:=S;
    end;

  y := y+space;
  with Canv do
    begin
      Pen.Width := 2;
      Pen.Color := color;
      MoveTo(x,y);
      LineTo(x+width,y);
      LineTo(x+width,y+height);
      LineTo(x,y+height);
      LineTo(x,y);
      MoveTo(x+Width div 6,y);
      LineTo(x+Width div 6,y+height);
      MoveTo(x-Width div 6+width,y);
      LineTo(x-Width div 6+width,y+height);
      TextOut((x + Width div 2)-(canv.TextWidth(caption) div 2), y+(height div 2)-10, caption);
    end;
end;

procedure drawBinaryChoice(Canv:TCanvas; x,y,width,height,space:Integer; caption:string; color:TColor);
var R1,R2:Integer;
  s:string;
  i:integer;
begin
  if Canv.TextWidth(caption) > Round(Width/2.5) then
    begin
      S:='';
      i:=1;
      while Canv.TextWidth(s) < Round(Width/2.5) do
        begin
          S:=S+caption[i];
          Inc(i);
        end;
      for i := Length(S) downto Length(s)-2 do
        S[i]:='.';
      Caption:=S;
    end;

  R1:=Round(height/2);
  R2:=Round(width/2);
  with Canv do
    begin
      Pen.Width := 2;
      Pen.Color := color;
      MoveTo(x+R2,y);
      LineTo(x+width,y+R1);
      LineTo(x+R2,y+height);
      LineTo(x,y+R1);
      LineTo(x+R2,y);
//      TextOut((x + Width div 2)-(canv.TextWidth(caption) div 2), y+(height div 2)-10, caption);
      TextOut((x + Width div 2)-(canv.TextWidth(caption) div 2), y+(height div 2)-10, caption);
      TextOut(x-(canv.TextWidth('Yes') div 2), y+height+20, 'Yes');
      TextOut(x+width+20-(canv.TextWidth('No') div 2), y, 'No');
    end;
end;

procedure drawDataBlock(Canv:TCanvas; x,y,width,height,space:Integer; caption:string; color:TColor);
var R:Integer;
    S:string;
    i:integer;
begin
  if Canv.TextWidth(caption) > Round(Width*0.7) then
    begin
      S:='';
      i:=1;
      while Canv.TextWidth(s) < Round(Width*0.7) do
        begin
          S:=S+caption[i];
          Inc(i);
        end;
      for i := Length(S) downto Length(s)-2 do
        S[i]:='.';
      Caption:=S;
    end;

  y := y+space;
  R:=Round(width/4);
  with Canv do
    begin
      Pen.Width := 2;
      Pen.Color := color;
      MoveTo(x+R,y);
      LineTo(x+width,y);
      LineTo(x+width-R,y+height);
      LineTo(x,y+height);
      LineTo(x+R,y);
      TextOut((x + Width div 2)-(canv.TextWidth(caption) div 2), y+(height div 2)-10, caption);
    end;
end;

procedure drawLoop(Canv:TCanvas; x,y,width,height, space:Integer; caption:string; color:TColor);
var R1,R2:Integer;
    S:string;
    i:integer;
begin
  if Canv.TextWidth(caption) > Round(Width*0.9) then
    begin
      S:='';
      i:=1;
      while Canv.TextWidth(s) < Round(Width*0.9) do
        begin
          S:=S+caption[i];
          Inc(i);
        end;
      for i := Length(S) downto Length(s)-2 do
        S[i]:='.';
      Caption:=S;
    end;

  R1:=Round(height/4);
  R2:=Round(width/4);
  with Canv do
    begin
      Pen.Width := 2;
      Pen.Color := color;
      MoveTo(x+R2,y);
      LineTo(x+width-R2,y);
      LineTo(x+width,y+R1);
      LineTo(x+width,y+height);
      LineTo(x,y+height);
      LineTo(x,y+R1);
      LineTo(x+R2,y);
      TextOut((x + Width div 2)-(canv.TextWidth('start loop') div 2), y+(height div 2)-40, 'start loop');
      TextOut((x + Width div 2)-(canv.TextWidth(caption) div 2), y+(height div 2), caption);
    end;
  y:= y + space;
  with Canv do
    begin
      Pen.Width := 2;
      Pen.Color := color;
      MoveTo(x,y);
      LineTo(x+width,y);
      LineTo(x+width,y+height-R1);
      LineTo(x+width-R2,y+height);
      LineTo(x+R2,y+height);
      LineTo(x,y+height-R1);
      LineTo(x,y);
      TextOut((x + Width div 2)-(canv.TextWidth('end loop') div 2), y+(height div 2)+10, 'end loop');
    end;
end;

procedure drawLine(Canv:TCanvas; x1,y1,x2,y2:Integer);
begin
  Canv.Pen.Color := clBlack;
  Canv.Pen.Width := 2;
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
