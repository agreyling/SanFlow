unit fmBackgroundLosses;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Math, uGlobals, ExtCtrls;

type
  TfrmBackgroundLosses = class(TForm)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    MainLength: TEdit;
    MainLoss: TEdit;
    MainsLosses: TEdit;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ConnNum: TEdit;
    ConnLoss: TEdit;
    ConnLosses: TEdit;
    GroupBox3: TGroupBox;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    PropNum: TEdit;
    PropLoss: TEdit;
    PropLosses: TEdit;
    GroupBox4: TGroupBox;
    Label14: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Total50m: TEdit;
    PCF: TEdit;
    AZNPLosses: TEdit;
    Panel1: TPanel;
    SaveBtn: TButton;
    CancelBtn: TButton;
    Panel2: TPanel;
    AZNP: TEdit;
    Label3: TLabel;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Label7: TLabel;
    ZoneLabel: TLabel;
    RefLabel: TLabel;
    procedure CancelBtnClick(Sender: TObject);
    procedure OnMainsLossChange(Sender: TObject);
    procedure OnConnLossChange(Sender: TObject);
    procedure OnPropLossChange(Sender: TObject);
    procedure OnTotalLossChange(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBackgroundLosses: TfrmBackgroundLosses;
{------------------------------------------------------------------------------}
implementation
{$R *.DFM}
{------------------------------------------------------------------------------}
{   Create, Show
{------------------------------------------------------------------------------}
procedure TfrmBackgroundLosses.FormShow(Sender: TObject);
begin
  if CurrentZone <> nil then begin
    ZoneLabel.Caption := ZoneName;
    RefLabel.Caption  := CurrentZone.NightFlowReference;
    AZNP.Text         := RealToStr(CurrentZone.AZNP,3);
    MainLength.Text   := RealToStr(CurrentZone.MainsLength,3);
    MainLoss.Text     := RealToStr(BackMainLoss,3);
    ConnNum.Text      := IntToStr(CurrentZone.NumConnections);
    ConnLoss.Text     := RealToStr(BackConnLoss,3);
    PropNum.Text      := IntToStr(CurrentZone.NumProperties);
    PropLoss.Text     := RealToStr(BackPropLoss,3);
  end;
end;
{------------------------------------------------------------------------------}
{   Save, cancel
{------------------------------------------------------------------------------}
procedure TfrmBackgroundLosses.SaveBtnClick(Sender: TObject);
begin
  //store variables in linked list
  CurrentZone.AZNP          := StrToReal(AZNP.Text);
  CurrentZone.MainsLength   := StrToReal(MainLength.Text);
  BackMainLoss              := StrToReal(MainLoss.Text);
  CurrentZone.NumConnections:= StrToInt(CheckText(ConnNum.Text));
  BackConnLoss              := StrToReal(ConnLoss.Text);
  CurrentZone.NumProperties := StrToInt(CheckText(PropNum.Text));
  BackPropLoss              := StrToReal(PropLoss.Text);
  ChangesSaved              := false;
  frmBackgroundLosses.Close;
end;

procedure TfrmBackgroundLosses.CancelBtnClick(Sender: TObject);
begin
  frmBackgroundLosses.Close;
end;
{------------------------------------------------------------------------------}
procedure TfrmBackgroundLosses.OnMainsLossChange(Sender: TObject);
//recalc for any mains loss changes
begin
  MainsLosses.Text := RealToStr(StrToReal(MainLength.Text)*
                                StrToReal(MainLoss.Text)/1000,3);
end;

procedure TfrmBackgroundLosses.OnConnLossChange(Sender: TObject);
//recalc for any connection loss changes
begin
  ConnLosses.Text := RealToStr(StrToReal(ConnNum.Text)*
                               StrToReal(ConnLoss.Text)/1000,3);
end;

procedure TfrmBackgroundLosses.OnPropLossChange(Sender: TObject);
//recalc for any property loss changes
begin
  PropLosses.Text := RealToStr(StrToReal(PropNum.Text)*
                               StrToReal(PropLoss.Text)/1000,3);
end;

procedure TfrmBackgroundLosses.OnTotalLossChange(Sender: TObject);
//when any values change, recalculate the grand totals
begin
  Total50m.Text := RealToStr(StrToReal(MainsLosses.Text)+
                             StrToReal(ConnLosses.Text)+
                             StrToReal(PropLosses.Text),3);
  PCF.Text := RealToStr(power((StrToReal(AZNP.Text)/50),BackPCF),3);
  AZNPLosses.Text := RealToStr(StrToReal(Total50m.Text)*
                               StrToReal(PCF.Text),3)
end;
{------------------------------------------------------------------------------}
end.
