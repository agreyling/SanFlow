unit fmReport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ToolWin, ComCtrls, StdCtrls, Buttons, ExtCtrls;

type
  TfrmReport = class(TForm)
    ReportRichEdit: TRichEdit;
    Panel1: TPanel;
    CloseBtn: TBitBtn;
    PrintBtn: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  public
    Start,Finish : integer;  
    { Public declarations }
  end;

var
  frmReport: TfrmReport;

implementation

uses uGlobals;

{$R *.DFM}

procedure TfrmReport.FormShow(Sender: TObject);
var
  APtr : ZonePointer;
  Loop : integer;
begin
  //create the report at this stage
  //need to check selection range and only report on those
  ReportRichEdit.Clear;
  APtr := ZoneHeadPtr;
  //loop forward to first item - for selection purposes
  for loop := 1 to Start do
    APtr := APtr.Next;
  loop := start;
  ReportRichEdit.Paragraph.Tab[0] := 250;
  ReportRichEdit.Font.Size := 9;
  ReportRichEdit.Font.Style := [fsBold];
  ReportRichEdit.Font.Color := clRed;
  ReportRichEdit.Lines.Add('REPORT FOR ZONE:                   '+#9+ZoneName);
  while APtr <> nil do
  begin
    with ReportRichEdit do
    begin
      SelAttributes.Size := 9;
      SelAttributes.Color := clGreen;
      SelAttributes.Style := [fsBold];
      Lines.Add('Reference Number:                   '+#9+APtr.NightFlowReference);
      SelAttributes.Color := clBlack;      
      SelAttributes.Style := [];
      Lines.Add('Measurement Date:                   '+#9+APtr.MeasureDate);
      Lines.Add('Mains Length (km):                  '+#9+RealToStr(APtr.MainsLength,1));
      Lines.Add('Number of Connections:              '+#9+IntToStr(APtr.NumConnections));
      Lines.Add('Number of Properties:               '+#9+IntToStr(APtr.NumProperties));
      Lines.Add('Population:                         '+#9+IntToStr(APtr.Population));
      Lines.Add('Average Night Zone Pressure (m):    '+#9+RealToStr(APtr.AZNP,1));
      Lines.Add('Measured Minimum Night Flow (m³/hr): '+#9+RealToStr(APtr.MeasuredMinNF,1));
      Lines.Add('Estimated Background Losses (m³/hr): '+#9+RealToStr(APtr.CalcBackLoss,1));
      Lines.Add('Estimated Normal Night Use (m³/hr):  '+#9+RealToStr(APtr.NormNightUse,1));
      Lines.Add('Expected Night Flow (m³/hr):         '+#9+RealToStr(APtr.ExpectNF,1));
      Lines.Add('Excess Night Flow (m³/hr):           '+#9+RealToStr(APtr.ExcessNF,1));
      Lines.Add('Estimated Service Pipe Bursts:      '+#9+RealToStr(APtr.ESPB,1));
      Lines.Add('');
    end;//with
    APtr := APtr.Next;
    inc(loop);
    if loop > Finish then
      break;
  end;//while
  ReportRichEdit.SelLength := 0;
  ReportRichEdit.SelStart := 0;

end;

procedure TfrmReport.PrintBtnClick(Sender: TObject);
begin
  ReportRichEdit.Print(ZoneName);
end;

procedure TfrmReport.CloseBtnClick(Sender: TObject);
begin
  frmReport.Close;
end;



procedure TfrmReport.Button1Click(Sender: TObject);
begin
  frmReport.Close;
end;

end.
