namespace KTX;

type
  KTXFile = class
    public SizeX, SizeY: integer;
    public BackgroundColor: Color;
    public Pixels: array of KTXPixel;
  end;

end.