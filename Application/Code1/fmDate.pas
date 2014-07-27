unit fmDate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, Calendar, StdCtrls, Spin, ExtCtrls;

type
  TDateFm = class(TForm)
    Calendar: TCalendar;
    MonthCombo: TComboBox;
    Label1: TLabel;
    YearSpin: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    Shape1: TShape;
    procedure FormShow(Sender: TObject);
    procedure MonthComboChange(Sender: TObject);
    procedure YearSpinChange(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure CalendarChange(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }
    procedure CNKeyDown(var message : TWMKeyDown); message CN_KEYDOWN;
  end;

var
  DateFm: TDateFm;

implementation

uses fmZoneVariables;

{$R *.DFM}


procedure TDateFm.FormShow(Sender: TObject);
begin
  if frmZoneVariables.edDate.Text = '' then
    Calendar.UseCurrentDate := true
  else
  begin
    Calendar.UseCurrentDate := false;
    Calendar.Day   := StrToInt(Copy(frmZoneVariables.edDate.Text,1,2));
    Calendar.Month := StrToInt(Copy(frmZoneVariables.edDate.Text,4,2));
    Calendar.Year  := StrToInt(Copy(frmZoneVariables.edDate.Text,7,4));
  end;
  MonthCombo.ItemIndex := Calendar.Month-1;
  YearSpin.Value := Calendar.Year;
end;

procedure TDateFm.MonthComboChange(Sender: TObject);
begin
  Calendar.Month := MonthCombo.ItemIndex+1;
  DateFm.ActiveControl := nil;
end;

procedure TDateFm.YearSpinChange(Sender: TObject);
begin
  Calendar.Year := YearSpin.Value;
  DateFm.ActiveControl := nil;
end;

function AddZero(InValue : integer) : string;
begin
  if InValue < 10 then
    result := '0'+IntToStr(InValue)
  else
    result := IntToStr(InValue);
end;//AddZero

procedure TDateFm.FormHide(Sender: TObject);
begin
  frmZoneVariables.Date.Text := AddZero(Calendar.Day)+FormatSettings.DateSeparator+
                                AddZero(Calendar.Month)+FormatSettings.DateSeparator+
                                IntToStr(Calendar.Year);
end;

procedure TDateFm.CNKeyDown(var message : TWMKeyDown);
var
  ShiftState : TShiftState;
begin
  ShiftState := KeyDataToShiftState(message.KeyData);
  if message.CharCode = 9 then//tab
  begin
    frmZoneVariables.DateChanged := true;//ensures value updated
    DateFm.hide;
    if ShiftState = [ssShift] then
      frmZoneVariables.ActiveControl := frmZoneVariables.Reference
    else
      frmZoneVariables.ActiveControl := frmZoneVariables.AZNP;
  end
  else if message.CharCode = 27 then//esc
  begin
    //don't store the values
    DateFm.Hide;
    frmZoneVariables.ActiveControl := frmZoneVariables.Reference;
    frmZoneVariables.Hide;
  end;
end;

procedure TDateFm.CalendarChange(Sender: TObject);
begin
  DateFm.ActiveControl := nil;
end;

end.
