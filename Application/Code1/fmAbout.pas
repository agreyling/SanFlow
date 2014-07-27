unit fmAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, jpeg;

type
  TfrmAbout = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Bevel1: TBevel;
    CloseBtn: TButton;
    Bevel2: TBevel;
    labVersion: TLabel;
    Label7: TLabel;
    procedure CloseBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation
uses
  uVersion;

{$R *.DFM}

procedure TfrmAbout.FormCreate(Sender: TObject);
var
  JPEG : TJPEGImage;
begin
  // version
  labVersion.Caption := 'Version '+ uVersion.Version+', '+uVersion.Date;
  // logo
  JPEG := TJPEGImage.Create;
  if fileexists('Tap.jpg') then begin
    JPEG.LoadFromFile('tap.jpg');
    Image1.Picture.Graphic := JPEG;
  end;
  jpeg.destroy;
end;

procedure TfrmAbout.CloseBtnClick(Sender: TObject);
begin
  frmAbout.Close;
end;
end.
