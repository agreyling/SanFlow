unit fmZoneVariables;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, uGlobals, ExtCtrls, Vcl.ComCtrls, variants;

type
  TfrmZoneVariables = class(TForm)
    Panel1: TPanel;
    SaveBtn: TButton;
    CancelBtn: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    MainLength: TEdit;
    Connections: TEdit;
    Properties: TEdit;
    Pop: TEdit;
    Reference: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    AZNP: TEdit;
    Label8: TLabel;
    MeasuredMinNF: TEdit;
    edDate: TDateTimePicker;
    procedure CancelBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  end;

var
  frmZoneVariables: TfrmZoneVariables;
{------------------------------------------------------------------------------}
implementation
uses
  fmMain;
{$R *.DFM}
{------------------------------------------------------------------------------}
{   Show
{------------------------------------------------------------------------------}
procedure TfrmZoneVariables.FormShow(Sender: TObject);
begin
  if Assigned(CurrentZone) then begin
    Reference.Text := CurrentZone.NightFlowReference;
    if (CurrentZone.MeasureDate <> '') then
      edDate.Date := VarToDateTime(CurrentZone.MeasureDate);
    AZNP.Text := RealToStr(CurrentZone.AZNP,3);
    MeasuredMinNF.Text := RealToStr(CurrentZone.MeasuredMinNF,3);
    MainLength.Text := RealToStr(CurrentZone.MainsLength,3);
    Connections.Text := IntToStr(CurrentZone.NumConnections);
    Properties.Text := IntToStr(CurrentZone.NumProperties);
    Pop.Text := IntToStr(CurrentZone.Population);
  end;
end;
{------------------------------------------------------------------------------}
{   Save, cancel
{------------------------------------------------------------------------------}
procedure TfrmZoneVariables.SaveBtnClick(Sender: TObject);
begin
  //store items in the list and close
  CurrentZone.NightFlowReference := Reference.Text;
  CurrentZone.MeasureDate := DateToStr(edDate.Date);
  CurrentZone.AZNP := StrToReal(CheckText(AZNP.Text));
  CurrentZone.MeasuredMinNF := StrToReal(CheckText(MeasuredMinNF.Text));
  CurrentZone.MainsLength := StrToReal(CheckText(MainLength.Text));
  CurrentZone.NumConnections := StrToInt(CheckText(Connections.Text));
  CurrentZone.NumProperties := StrToInt(CheckText(Properties.Text));
  CurrentZone.Population := StrToInt(CheckText(Pop.Text));
  ChangesSaved := false;
  frmZoneVariables.Close;
end;

procedure TfrmZoneVariables.CancelBtnClick(Sender: TObject);
begin
  frmZoneVariables.Close;
end;
{------------------------------------------------------------------------------}
end.
