unit ZoneVariablesForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Globals, ExtCtrls;

type
  TZoneVariablesFm = class(TForm)
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
    Date: TEdit;
    Label7: TLabel;
    AZNP: TEdit;
    Label8: TLabel;
    MeasuredMinNF: TEdit;
    procedure CancelBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure DateEnter(Sender: TObject);
    procedure DateExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure WMMove(var message : TMessage); message WM_Move;
    procedure WMClose(var message : TMessage); message WM_Close;
  public
    DateChanged : boolean;
    { Public declarations }
  end;

var
  ZoneVariablesFm: TZoneVariablesFm;

implementation

uses DateForm, fmMain;

{$R *.DFM}

//***************** MESSAGE HANDLERS ******************

procedure TZoneVariablesFm.WMMove(var message : TMessage);
begin
  if DateFm.Visible then
  begin
    DateEnter(Self);    //move date form in sympathy
  end;
end;

procedure TZoneVariablesFm.WMClose(var message : TMessage);
begin
  DateFm.Hide;
  Self.Hide;
end;

procedure TZoneVariablesFm.CancelBtnClick(Sender: TObject);
begin
  DateFm.Hide;
  ZoneVariablesFm.Hide;
end;

procedure TZoneVariablesFm.SaveBtnClick(Sender: TObject);
begin
  //store items in the list and close
  CurrentZone.NightFlowReference := Reference.Text;
  CurrentZone.MeasureDate := Date.Text;
  CurrentZone.AZNP := StrToReal(CheckText(AZNP.Text));
  CurrentZone.MeasuredMinNF := StrToReal(CheckText(MeasuredMinNF.Text));
  CurrentZone.MainsLength := StrToReal(CheckText(MainLength.Text));
  CurrentZone.NumConnections := StrToInt(CheckText(Connections.Text));
  CurrentZone.NumProperties := StrToInt(CheckText(Properties.Text));
  CurrentZone.Population := StrToInt(CheckText(Pop.Text));
  ChangesSaved := false;
  ZoneVariablesFm.Hide;
end;

procedure TZoneVariablesFm.DateEnter(Sender: TObject);
var
  APoint : TPoint;
begin//set coordinates to just below the date box
  APoint.x := ZoneVariablesFm.Date.Left;
  APoint.y := ZoneVariablesFm.Date.Top;

  DateFm.Top := APoint.Y + ZoneVariablesFm.Date.Height + ZoneVariablesFm.Top + 30;
  DateFm.Left := APoint.X + ZoneVariablesFm.Left + 4;

  DateChanged := false;
  DateFm.Show;
end;

procedure TZoneVariablesFm.DateExit(Sender: TObject);
begin
  DateFm.Hide;
end;

procedure TZoneVariablesFm.FormActivate(Sender: TObject);
begin
  if (CurrentZone <> nil) and NOT(DateChanged) then
  begin
    Reference.Text := CurrentZone.NightFlowReference;
    if NOT(DateChanged) then //flag to ensure date updated
      Date.Text := CurrentZone.MeasureDate;
    AZNP.Text := RealToStr(CurrentZone.AZNP,3);
    MeasuredMinNF.Text := RealToStr(CurrentZone.MeasuredMinNF,3);
    MainLength.Text := RealToStr(CurrentZone.MainsLength,3);
    Connections.Text := IntToStr(CurrentZone.NumConnections);
    Properties.Text := IntToStr(CurrentZone.NumProperties);
    Pop.Text := IntToStr(CurrentZone.Population);
  end;
end;

procedure TZoneVariablesFm.FormCreate(Sender: TObject);
begin
  DateChanged := false;
end;

procedure TZoneVariablesFm.FormDeactivate(Sender: TObject);
begin
  DateChanged := false;
end;

end.
