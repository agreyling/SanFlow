unit GraphForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TeEngine, Series, ExtCtrls, TeeProcs, Chart, StdCtrls, TeeFunci;

type
  TGraphFm = class(TForm)
    LeakageChart: TChart;
    Series1: TAreaSeries;
    Series2: TAreaSeries;
    Series3: TAreaSeries;
    Panel1: TPanel;
    SaveBtn: TButton;
    CancelBtn: TButton;
    TeeFunction1: TAddTeeFunction;
    Series4: TLineSeries;
    NextBtn: TButton;
    PrevBtn: TButton;
    PrintBtn: TButton;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure PrevBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GraphFm: TGraphFm;

implementation

uses uGlobals;

{$R *.DFM}

procedure TGraphFm.CancelBtnClick(Sender: TObject);
begin
  GraphFm.Close;
end;

procedure TGraphFm.FormShow(Sender: TObject);
var
  APtr    : ZonePointer;
  DateFormat : string;
begin
//should ideally update values as they are processaed in the main screen
  LeakageChart.Title.Text.Clear;
  LeakageChart.Title.Text.Add(ZoneName);
  LeakageChart.Series[0].Clear;
  LeakageChart.Series[1].Clear;
  LeakageChart.Series[2].Clear;
  LeakageChart.Series[3].Clear;
  APtr := ZoneHeadPtr;
  While APtr <> nil do
  begin
    if APtr.MeasureDate <> '' then
    begin
      DateFormat := ShortDateFormat;
      ShortDateFormat := 'd/m/y';
      LeakageChart.Series[0].AddXY(StrToDate(APtr.MeasureDate),APtr.ExcessNF+APtr.CalcBackLoss+APtr.NormNightUse,'',clTeeColor);
      LeakageChart.Series[1].AddXY(StrToDate(APtr.MeasureDate),APtr.CalcBackLoss+APtr.NormNightUse,'',clTeeColor);
      LeakageChart.Series[2].AddXY(StrToDate(APtr.MeasureDate),APtr.NormNightUse,'',clTeeColor);
      LeakageChart.Series[3].AddXY(StrToDate(APtr.MeasureDate),APtr.ESPB,'',clTeeColor);
      ShortDateFormat := DateFormat;
    end;//if
    APtr := APtr.Next;
  end;//while
end;

procedure TGraphFm.SaveBtnClick(Sender: TObject);
begin
  GraphFm.Close;
end;

procedure TGraphFm.Panel1Resize(Sender: TObject);
begin
  CancelBtn.Left := Panel1.Width - 66;
end;

procedure TGraphFm.NextBtnClick(Sender: TObject);
begin
  PrevBtn.Enabled := true;
  LeakageChart.Page := LeakageChart.Page+1;
  If LeakageChart.Page = LeakageChart.NumPages then
    NextBtn.Enabled := false;
end;

procedure TGraphFm.PrevBtnClick(Sender: TObject);
begin
  NextBtn.Enabled := true;
  LeakageChart.Page := LeakageChart.Page-1;
  If LeakageChart.Page = 1 then
    PrevBtn.Enabled := false;
end;


procedure TGraphFm.PrintBtnClick(Sender: TObject);
begin
  LeakageChart.PrintLandscape;
end;

end.
