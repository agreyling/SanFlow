unit fmUnMeteredEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, uGlobals;

type
  TfrmUnMeteredEditor = class(TForm)
    Panel1: TPanel;
    CancelBtn: TButton;
    SaveBtn: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    Description: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Number: TEdit;
    Use: TEdit;
    Total: TEdit;
    procedure FormShow(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure UseChange(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmUnMeteredEditor: TfrmUnMeteredEditor;

implementation

{$R *.DFM}

procedure TfrmUnMeteredEditor.FormShow(Sender: TObject);
begin
  Description.Text := ZoneUnMetered.Description;
  Number.Text := InttoStr(ZoneUnMetered.NumOff);
  Use.Text := RealToStr(ZoneUnMetered.Use,3);
  Total.Text := RealToStr(StrToReal(Number.Text)*
                          StrToReal(Use.Text)/1000,3);
end;

procedure TfrmUnMeteredEditor.CancelBtnClick(Sender: TObject);
begin
  frmUnMeteredEditor.Hide;
end;

procedure TfrmUnMeteredEditor.UseChange(Sender: TObject);
begin
  Total.Text := RealToStr(StrToReal(Number.Text)*
                          StrToReal(Use.Text)/1000,3);
end;

procedure TfrmUnMeteredEditor.SaveBtnClick(Sender: TObject);
begin
  ZoneUnMetered.Description := Description.Text;
  ZoneUnMetered.NumOff := StrToInt(CheckText(Number.Text));
  ZoneUnMetered.Use := StrToReal(Use.Text);
  frmUnMeteredEditor.Hide;
end;

end.
