unit AboutForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, jpeg;

type
  TAboutFm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Bevel1: TBevel;
    CloseBtn: TButton;
    Bevel2: TBevel;
    Label6: TLabel;
    Label7: TLabel;
    procedure CloseBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutFm: TAboutFm;

implementation

{$R *.DFM}

procedure TAboutFm.CloseBtnClick(Sender: TObject);
begin
  AboutFm.Hide;
end;

procedure TAboutFm.FormCreate(Sender: TObject);
var
  JPEG : TJPEGImage;
begin
  JPEG := TJPEGImage.Create;
  if fileexists('Tap.jpg') then
  begin
    JPEG.LoadFromFile('tap.jpg');
    Image1.Picture.Graphic := JPEG;
  end;
  jpeg.destroy;
end;



end.
