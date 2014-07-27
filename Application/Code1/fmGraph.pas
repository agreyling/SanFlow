unit fmGraph;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TeEngine, Series, ExtCtrls, TeeProcs, Chart, StdCtrls, TeeFunci,
  VclTee.TeeGDIPlus;

type
  TfrmGraph = class(TForm)
    LeakageChart: TChart;
    Series1: TAreaSeries;
    Series2: TAreaSeries;
    Series3: TAreaSeries;
    Panel1: TPanel;
    CloseBtn: TButton;
    TeeFunction1: TAddTeeFunction;
    Series4: TLineSeries;
    NextBtn: TButton;
    PrevBtn: TButton;
    PrintBtn: TButton;
    procedure CloseBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure PrevBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGraph: TfrmGraph;
{------------------------------------------------------------------------------}
implementation
uses
  uGlobals;
{$R *.DFM}
{------------------------------------------------------------------------------}
{   Create, show
{------------------------------------------------------------------------------}
procedure TfrmGraph.FormShow(Sender: TObject);
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
  While APtr <> nil do begin
    if APtr.MeasureDate <> '' then begin
      DateFormat := FormatSettings.ShortDateFormat;
      FormatSettings.ShortDateFormat := 'd/m/y';
      LeakageChart.Series[0].AddXY(StrToDate(APtr.MeasureDate),APtr.ExcessNF+APtr.CalcBackLoss+APtr.NormNightUse,'',clTeeColor);
      LeakageChart.Series[1].AddXY(StrToDate(APtr.MeasureDate),APtr.CalcBackLoss+APtr.NormNightUse,'',clTeeColor);
      LeakageChart.Series[2].AddXY(StrToDate(APtr.MeasureDate),APtr.NormNightUse,'',clTeeColor);
      LeakageChart.Series[3].AddXY(StrToDate(APtr.MeasureDate),APtr.ESPB,'',clTeeColor);
      FormatSettings.ShortDateFormat := DateFormat;
    end;//if
    APtr := APtr.Next;
  end;//while
end;
{------------------------------------------------------------------------------}
{   Save, Cancel
{------------------------------------------------------------------------------}
procedure TfrmGraph.SaveBtnClick(Sender: TObject);
begin
  frmGraph.Close;
end;

procedure TfrmGraph.CloseBtnClick(Sender: TObject);
begin
  frmGraph.Close;
end;
{------------------------------------------------------------------------------}
{   Buttons
{------------------------------------------------------------------------------}
procedure TfrmGraph.NextBtnClick(Sender: TObject);
begin
  PrevBtn.Enabled := true;
  LeakageChart.Page := LeakageChart.Page+1;
  If LeakageChart.Page = LeakageChart.NumPages then
    NextBtn.Enabled := false;
end;

procedure TfrmGraph.PrevBtnClick(Sender: TObject);
begin
  NextBtn.Enabled := true;
  LeakageChart.Page := LeakageChart.Page-1;
  If LeakageChart.Page = 1 then
    PrevBtn.Enabled := false;
end;

procedure TfrmGraph.PrintBtnClick(Sender: TObject);
begin
  LeakageChart.PrintLandscape;
end;
{------------------------------------------------------------------------------}
end.
