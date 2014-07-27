unit SplashForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, jpeg;

type
  TSplashFm = class(TForm)
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
  SplashFm: TSplashFm;
{------------------------------------------------------------------------------}
implementation
uses
  uVersion;
{$R *.DFM}
{------------------------------------------------------------------------------}
procedure TSplashFm.FormCreate(Sender: TObject);
var
  JPEG : TJPEGImage;
begin
  // version
  labVersion.Caption := 'Version '+ uVersion.Version+', '+uVersion.Date;
  // logo
  JPEG := TJPEGImage.Create;
  if fileexists('WRC.jpg') then begin
    JPEG.LoadFromFile('WRC.jpg');
    WRCImage.Picture.Graphic := JPEG;//copy jpeg image to TImage object
  end;
  JPEG.Destroy;
  Timer1.Enabled := true;
end;

procedure TSplashFm.Timer1Timer(Sender: TObject);
begin
  SplashFm.Hide;
end;

procedure TSplashFm.AnyWhereClick(Sender: TObject);
//click anywhere on form to hide before the time is complete
begin
  Timer1Timer(self);
end;

procedure TSplashFm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;
{------------------------------------------------------------------------------}
end.
