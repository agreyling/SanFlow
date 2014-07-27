unit fmMeteredEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, uGlobals;

type
  TMeteredEditorFm = class(TForm)
    Panel1: TPanel;
    CancelBtn: TButton;
    SaveBtn: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    Description: TEdit;
    Label4: TLabel;
    Use: TEdit;
    procedure FormShow(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMeteredEditor: TMeteredEditorFm;

implementation

{$R *.DFM}

procedure TMeteredEditorFm.FormShow(Sender: TObject);
begin
  Description.Text := ZoneMetered.Description;
  Use.Text := RealToStr(ZoneMetered.Use,3);
end;

procedure TMeteredEditorFm.CancelBtnClick(Sender: TObject);
begin
  frmMeteredEditor.Close;
end;

procedure TMeteredEditorFm.SaveBtnClick(Sender: TObject);
begin
  ZoneMetered.Description := Description.Text;
  ZoneMetered.Use := StrToReal(Use.Text);
  frmMeteredEditor.Close;
end;

end.
