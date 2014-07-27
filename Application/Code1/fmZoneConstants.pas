unit fmZoneConstants;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, uGlobals, ExtCtrls;

type
  TfrmZoneConstants = class(TForm)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    MainLoss: TEdit;
    Label9: TLabel;
    ConnLoss: TEdit;
    Label10: TLabel;
    PropLoss: TEdit;
    GroupBox2: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    ActivePop: TEdit;
    UnitConsumption: TEdit;
    GroupBox3: TGroupBox;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    PCFBack: TEdit;
    PCFBurst: TEdit;
    GroupBox4: TGroupBox;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    ESPB: TEdit;
    Panel1: TPanel;
    SaveBtn: TButton;
    CancelBtn: TButton;
    GroupBox5: TGroupBox;
    Label34: TLabel;
    Label1: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    ZoneEdit: TEdit;
    procedure CancelBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  end;

var
 frmZoneConstants : TfrmZoneConstants;
{------------------------------------------------------------------------------}
implementation
{$R *.DFM}
{------------------------------------------------------------------------------}
{   Create, Show
{------------------------------------------------------------------------------}
procedure TfrmZoneConstants.FormShow(Sender: TObject);
begin
  ZoneEdit.Text       := ZoneName;
  MainLoss.Text       := RealToStr(BackMainLoss,2);
  ConnLoss.Text       := RealToStr(BackConnLoss,2);
  PropLoss.Text       := RealToStr(BackPropLoss,2);
  ActivePop.Text      := RealToStr(PopNightActive,2);
  UnitConsumption.Text:= RealToStr(UnitNightUse,2);
  PCFBack.Text        := RealToStr(BackPCF,2);
  PCFBurst.Text       := RealToStr(BurstPCF,2);
  ESPB.Text           := RealToStr(UnitESPB,2);
end;
{------------------------------------------------------------------------------}
{   Save, cancel
{------------------------------------------------------------------------------}
procedure TfrmZoneConstants.SaveBtnClick(Sender: TObject);
begin
  //store variables at this point
  ZoneName        := ZoneEdit.Text;
  BackMainLoss    := StrToReal(MainLoss.Text);
  BackConnLoss    := StrToReal(ConnLoss.Text);
  BackPropLoss    := StrToReal(PropLoss.Text);
  PopNightActive  := StrToReal(ActivePop.Text);
  UnitNightUse    := StrToReal(UnitConsumption.Text);
  BackPCF         := StrToReal(PCFBack.Text);
  BurstPCF        := StrToReal(PCFBurst.Text);
  UnitESPB        := StrToReal(ESPB.Text);

  ChangesSaved    := false;
  frmZoneConstants.Close;
end;

procedure TfrmZoneConstants.CancelBtnClick(Sender: TObject);
begin
  frmZoneConstants.Close;
end;
{------------------------------------------------------------------------------}
end.
