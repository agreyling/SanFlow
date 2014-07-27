unit fmSplash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, jpeg;

type
  TfrmSplash = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Timer1: TTimer;
    Label6: TLabel;
    Panel1: TPanel;
    WRCImage: TImage;
    labVersion: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label3: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure AnyWhereClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  end;

var
  frmSplash: TfrmSplash;
{------------------------------------------------------------------------------}
implementation
uses
  uVersion;
{$R *.DFM}
{------------------------------------------------------------------------------}
procedure TfrmSplash.FormCreate(Sender: TObject);
begin
  labVersion.Caption := 'Version '+ uVersion.Version+', '+uVersion.Date;
  Timer1.Enabled := true;
end;

procedure TfrmSplash.Timer1Timer(Sender: TObject);
begin
  frmSplash.Hide;
end;

procedure TfrmSplash.AnyWhereClick(Sender: TObject);
//click anywhere on form to hide before the time is complete
begin
  Timer1Timer(self);
end;

procedure TfrmSplash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;
{------------------------------------------------------------------------------}
end.
