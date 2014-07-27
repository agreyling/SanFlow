unit StatsForm;
{This unit was written extremely hastily and without planning or consideration
 it is this poorly coded as a result. It is hoped that at a future stage a
 complete rewrite of the unit can occur.}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TeEngine, Series, ExtCtrls, TeeProcs, Chart, StdCtrls, ComCtrls, Math,
  uGlobals, Grids, Printers;

type
  recpointer = ^therec;
  therec = record
    Data : extended;
    next : recpointer;
  end;

  TStatsFm = class(TForm)
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
    Splitter1: TSplitter;
    Panel3: TPanel;
    Chart1: TChart;
    Panel4: TPanel;
    MeanLabel: TLabel;
    StdDevLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    StatDataGrid: TStringGrid;
    Panel2: TPanel;
    StartBtn: TButton;
    PrintBtn: TButton;
    CloseBtn: TButton;
    Series1: TLineSeries;
    procedure StartBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure CalcValues;
    function Z(Row : integer) : extended;
  end;

var
  StatsFm: TStatsFm;

implementation

//var
//  APtr : RecPointer;
//  ThePtr : RecPointer;
{$R *.DFM}


procedure TStatsFm.CalcValues;
const
  NumBin = 100;
  MaxValue = 50000;
var
  loop   : longint;
  bursts : extended;
  bin    : array[0..NumBin] of integer;
  MaxRange    : Integer;
  ValidValues        : Integer;
  Sum,SumofSquares : extended;
  BinNumber        : integer;
  BinTotal         : integer;
begin
//  MaxValue := 1000;
  ValidValues := MaxValue;
  MaxRange := Round(CurrentZone.ESPB*2);
  if MaxRange < 5 then
    MaxRange := 5;
  for loop := 0 to NumBin do
    bin[loop] := 0;

  Sum := 0.0;
  SumofSquares := 0.0;
  for loop := 1 to MaxValue do
  begin
//if an error occurs should ignore that value totally
    try
      bursts := ( Z(11) -
                ( Z(6)*Z(7)/100*Z(8)/1000 +
                  Z(15) +
                  Z(16) +
                  power(Z(10)/50,Z(4))*(Z(12)*Z(1)/1000+
                                                     Z(13)*Z(2)/1000+
                                                     Z(14)*Z(3)/1000) ) ) /
                  (Z(9)*power(Z(10)/50,Z(5)));
//description of above formula.
{    bursts := ( MeasuredMinNF -
              ( Population*PopNightActive/100*UnitNightUse/1000 +
                UnMeteredUse +
                MeteredUse +
                power(AZNP/50,BackPCF)*MainsLength*BackMainLoss/1000+
                                                   NumConnections*BackConnLoss/1000+
                                                   NumProperties*BackPropLoss/1000) ) ) /
                (UnitESPB*power(AZNP/50,BurstPCF));}
      BinNumber := round(bursts*NumBin/MaxRange);
      if (BinNumber >= 0) and (BinNumber <= NumBin) then
      begin
        inc(bin[BinNumber]);
        Sum := Sum + bursts;
        SumofSquares := SumofSquares + sqr(bursts);
      end;
    except
      on ERangeError do Dec(ValidValues);
      on EAccessViolation do Dec(ValidValues);//ouch !!!
      on EDivByZero do Dec(ValidValues);
      on EZeroDivide do Dec(ValidValues);//float div 0
      on EInvalidOp do Dec(ValidValues);
    end;

    if (loop mod (maxvalue div 10)) = 0 then
    begin
      ProgressBar1.Position := round(loop/MaxValue*100);
      Update;
    end;
  end;//for
  if ValidValues > 0 then
  begin
    BinTotal := 0;
    for loop := 1 to NumBin do
    begin
      BinTotal := BinTotal + bin[loop];
      series1.AddXY(MaxRange/NumBin*loop,round((ValidValues-BinTotal)/ValidValues*100),'',clBlack);
    end;
    MeanLabel.Caption := RealToStr(Sum/ValidValues,1);
    StdDevLabel.Caption := RealToStr(sqrt ((SumofSquares-ValidValues*sqr(Sum/ValidValues)) /(ValidValues-1)),1);
  end;
end;

function TStatsFm.Z(Row : integer) : extended;
//terrible name for a function to fit the normal distibution to the data
var
  U1,Aux,a,b          : Double;
  Min,Best,Max        : Double;
begin
  Min := StrToFloat(StatDataGrid.Cells[1,Row]);
  Best := StrToFloat(StatDataGrid.Cells[2,Row]);
  Max := StrToFloat(StatDataGrid.Cells[3,Row]);
  U1 := random(10000)/10000.0;
  a := Best - Min;
  b := Max - Min;
  if (b < 1e-10) then
    result := Best
  else
  begin
    try
      if U1 < (a/b) then
        Aux := sqrt(a*b*U1)
      else
      begin
        Aux := b - sqrt(b*(b-a)*(1-U1));
      end;
    except
      Aux := 0;
    end;
    result := Min + Aux;
  end;
end;

procedure TStatsFm.StartBtnClick(Sender: TObject);
begin
  Series1.Clear;
  ProgressBar1.Position := 0;
  MeanLabel.Caption := '';
  StdDevLabel.Caption := '';
  CalcValues;
end;

procedure TStatsFm.FormShow(Sender: TObject);
var
  Range          : real;
  MeteredUse,UnMeteredUse : real;
  MeteredSpare : MeteredPointer;
  UnMeteredSpare : UnMeteredPointer;
begin
  Self.Caption := 'Sensitivity Analysis - Zone: '+CurrentZone.NightFlowReference;
  MeteredUse := 0.0;
  MeteredSpare := CurrentZone.Metered;
  while MeteredSpare <> nil do
  begin
    MeteredUse := MeteredUse + MeteredSpare.Use;
    MeteredSpare := MeteredSpare.Next;
  end;//while

  UnMeteredUse := 0.0;
  UnMeteredSpare := CurrentZone.UnMetered;
  while UnMeteredSpare <> nil do
  begin
    UnMeteredUse := UnMeteredUse + UnMeteredSpare.Use/1000*
                                   UnMeteredSpare.NumOff;
    UnMeteredSpare := UnMeteredSpare.Next;
  end;//while
  Range := 0.2;
  StatDataGrid.Cells[1,11] := RealToStr(CurrentZone.MeasuredMinNF*(1-range),1);
  StatDataGrid.Cells[1,6] := RealToStr(CurrentZone.Population*(1-range),0);
  StatDataGrid.Cells[1,7] := RealToStr(PopNightActive*(1-range),1);
  StatDataGrid.Cells[1,8] := RealToStr(UnitNightUse*(1-range),1);
  StatDataGrid.Cells[1,15] := RealToStr(UnMeteredUse*(1-range),2);
  StatDataGrid.Cells[1,16] := RealToStr(MeteredUse*(1-range),2);
  StatDataGrid.Cells[1,10] := RealToStr(CurrentZone.AZNP*(1-range),1);
  StatDataGrid.Cells[1,4] := RealToStr(BackPCF*(1-range),1);
  StatDataGrid.Cells[1,12] := RealToStr(CurrentZone.MainsLength*(1-range),2);
  StatDataGrid.Cells[1,1] := RealToStr(BackMainLoss*(1-range),1);
  StatDataGrid.Cells[1,13] := RealToStr(CurrentZone.NumConnections*(1-range),0);
  StatDataGrid.Cells[1,2] := RealToStr(BackConnLoss*(1-range),1);
  StatDataGrid.Cells[1,14] := RealToStr(CurrentZone.NumProperties*(1-range),0);
  StatDataGrid.Cells[1,3] := RealToStr(BackPropLoss*(1-range),1);
  StatDataGrid.Cells[1,9] := RealToStr(UnitESPB*(1-range),2);
  StatDataGrid.Cells[1,5] := RealToStr(BurstPCF*(1-range),2);

  StatDataGrid.Cells[2,11] := RealToStr(CurrentZone.MeasuredMinNF,1);
  StatDataGrid.Cells[2,6] := RealToStr(CurrentZone.Population,0);
  StatDataGrid.Cells[2,7] := RealToStr(PopNightActive,1);
  StatDataGrid.Cells[2,8] := RealToStr(UnitNightUse,1);
  StatDataGrid.Cells[2,15] := RealToStr(UnMeteredUse,2);
  StatDataGrid.Cells[2,16] := RealToStr(MeteredUse,2);
  StatDataGrid.Cells[2,10] := RealToStr(CurrentZone.AZNP,1);
  StatDataGrid.Cells[2,4] := RealToStr(BackPCF,1);
  StatDataGrid.Cells[2,12] := RealToStr(CurrentZone.MainsLength,2);
  StatDataGrid.Cells[2,1] := RealToStr(BackMainLoss,1);
  StatDataGrid.Cells[2,13] := RealToStr(CurrentZone.NumConnections,0);
  StatDataGrid.Cells[2,2] := RealToStr(BackConnLoss,1);
  StatDataGrid.Cells[2,14] := RealToStr(CurrentZone.NumProperties,0);
  StatDataGrid.Cells[2,3] := RealToStr(BackPropLoss,1);
  StatDataGrid.Cells[2,9] := RealToStr(UnitESPB,2);
  StatDataGrid.Cells[2,5] := RealToStr(BurstPCF,2);

  StatDataGrid.Cells[3,11] := RealToStr(CurrentZone.MeasuredMinNF*(1+range),1);
  StatDataGrid.Cells[3,6] := RealToStr(CurrentZone.Population*(1+range),0);
  StatDataGrid.Cells[3,7] := RealToStr(PopNightActive*(1+range),1);
  StatDataGrid.Cells[3,8] := RealToStr(UnitNightUse*(1+range),1);
  StatDataGrid.Cells[3,15] := RealToStr(UnMeteredUse*(1+range),2);
  StatDataGrid.Cells[3,16] := RealToStr(MeteredUse*(1+range),2);
  StatDataGrid.Cells[3,10] := RealToStr(CurrentZone.AZNP*(1+range),1);
  StatDataGrid.Cells[3,4] := RealToStr(BackPCF*(1+range),1);
  StatDataGrid.Cells[3,12] := RealToStr(CurrentZone.MainsLength*(1+range),2);
  StatDataGrid.Cells[3,1] := RealToStr(BackMainLoss*(1+range),1);
  StatDataGrid.Cells[3,13] := RealToStr(CurrentZone.NumConnections*(1+range),0);
  StatDataGrid.Cells[3,2] := RealToStr(BackConnLoss*(1+range),1);
  StatDataGrid.Cells[3,14] := RealToStr(CurrentZone.NumProperties*(1+range),0);
  StatDataGrid.Cells[3,3] := RealToStr(BackPropLoss*(1+range),1);
  StatDataGrid.Cells[3,9] := RealToStr(UnitESPB*(1+range),2);
  StatDataGrid.Cells[3,5] := RealToStr(BurstPCF*(1+range),2);
end;

procedure TStatsFm.FormCreate(Sender: TObject);
begin
  StatDataGrid.ColWidths[0] := 80;
  
  StatDataGrid.Cells[0,0] := 'Variables';
  StatDataGrid.Cells[1,0] := 'Min';
  StatDataGrid.Cells[2,0] := 'Best Est.';
  StatDataGrid.Cells[3,0] := 'Max';

  StatDataGrid.Cells[0,11] := 'Measured Min NF';
  StatDataGrid.Cells[0,6] := 'Population';
  StatDataGrid.Cells[0,7] := '% Pop. Active';
  StatDataGrid.Cells[0,8] := 'Unit Night Use';
  StatDataGrid.Cells[0,15] := 'Unmetered Use';
  StatDataGrid.Cells[0,16] := 'Metered Use';
  StatDataGrid.Cells[0,10] := 'AZNP';
  StatDataGrid.Cells[0,4] := 'Background PCF';
  StatDataGrid.Cells[0,12] := 'Mains Length';
  StatDataGrid.Cells[0,1] := 'Mains Loss Coeff.';
  StatDataGrid.Cells[0,13] := 'No. Connections';
  StatDataGrid.Cells[0,2] := 'Conn. Loss Coeff.';
  StatDataGrid.Cells[0,14] := 'No. Properties';
  StatDataGrid.Cells[0,3] := 'Prop. Loss Coeff.';
  StatDataGrid.Cells[0,9] := 'Unit ESPB';
  StatDataGrid.Cells[0,5] := 'Burst PCF';
//  StatDataGrid.Cols[0].Wi
end;

procedure TStatsFm.PrintBtnClick(Sender: TObject);
var
  PrintRect : TRect;
  loop,YVal : integer;
  XVal      : integer;
  TextHt    : integer;
  LineSpace : single;
begin
  with Printer do
  begin
    BeginDoc;
    Canvas.Font.Name := 'Arial';
    Canvas.Font.Size := 10;
    Canvas.Pen.Width := 3;
    Canvas.Rectangle(0,round(Printer.PageHeight*7.5/100),Printer.PageWidth*95 div 100,Printer.PageHeight-round(Printer.PageHeight*7.5/100));
    XVal := round(Printer.PageWidth*2.5/100);//2.5% of page width
    YVal := round(Printer.PageHeight*8/100);
    TextHt := round(printer.canvas.Font.Size * printer.canvas.Font.PixelsPerInch / 72);
    canvas.TextOut(XVal,YVal,'BURST SENSITIVITY ANALYSIS FOR ZONE : '+Zonename);
    canvas.TextOut(XVal,YVal+TextHt*2,'Measurement Date : '+CurrentZone.MeasureDate);
    canvas.TextOut(XVal,YVal+TextHt*4,'MEAN : '+MeanLabel.Caption);
    canvas.TextOut(XVal,YVal+TextHt*6,'STD DEV : '+StdDevLabel.Caption);
    PrintRect := Rect(XVal,YVal+TextHt*8,Printer.PageWidth-XVal*2,Printer.PageHeight div 2);
    Chart1.PrintResolution := 0;
    Chart1.PrintPartialCanvas(Printer.Canvas,PrintRect);//dump chart
    YVal := Printer.PageHeight div 2;
    Canvas.TextOut(XVal,YVal,'SENSITIVITY PARAMETERS');
    YVal := YVal + TextHt*4;
    for loop := 0 To 16 do
    begin
    //should work in % of pagewidths
      LineSpace := (loop-1)*TextHt*1.5;
      Canvas.TextOut(XVal,round(YVal+LineSpace),StatDataGrid.Cells[0,loop]);
      Canvas.TextOut(XVal+Printer.PageWidth*3 div 10,round(YVal+LineSpace),StatDataGrid.Cells[1,loop]);
      Canvas.TextOut(XVal+Printer.PageWidth*5 div 10,round(YVal+LineSpace),StatDataGrid.Cells[2,loop]);
      Canvas.TextOut(XVal+Printer.PageWidth*7 div 10,round(YVal+LineSpace),StatDataGrid.Cells[3,loop]);
    end;
    EndDoc;
  end;
end;

procedure TStatsFm.CloseBtnClick(Sender: TObject);
begin
  StatsFm.Close;
end;

end.
