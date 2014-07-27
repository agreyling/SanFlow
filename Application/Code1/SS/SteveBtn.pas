unit SteveBtn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, extctrls;

type
  TSteveBtn = class(TSpeedButton)
  private
    FGlyphHot : TImage;
    FGlyphSpare : TImage;
    { Private declarations }
  protected
    procedure TCMMouseEnter(var Message : TMessage); message CM_MOUSEENTER;
    procedure TCMMouseLeave(var Message : TMessage); message CM_MOUSELEAVE;
  public
    constructor Create(AOwner : TComponent); override;
    property GlyphSpare : TImage read FGlyphSpare write FGlyphSpare;
    { Public declarations }
  published
    property GlyphHot : TImage read FGlyphHot write FGlyphHot;

    { Published declarations }
  end;

procedure Register;

implementation

constructor TSteveBtn.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  GlyphSpare := TImage.Create(self);
  GlyphSpare.Width := 32;
  GlyphSpare.Height := 32;
end;

procedure TSteveBtn.TCMMouseEnter(var Message : TMessage);
begin
  //display the "hot" image
  GlyphSpare.Picture.Bitmap := Glyph;
  Glyph := GlyphHot.Picture.Bitmap;
  inherited;
end;

procedure TSteveBtn.TCMMouseLeave(var Message : TMessage);
begin
  //display the "plain" image
  Glyph := GlyphSpare.Picture.Bitmap;
  inherited;
end;

procedure Register;
begin
  RegisterComponents('Standard', [TSteveBtn]);
end;

end.
