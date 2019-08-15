namespace KTX;

uses System;

type
  ///Представляет клетку консоли
  KTXPixel = class
    public PosX, PosY: integer;
    public Back, Fore: Color;
    public Symbol: char;
    
    public static function FromBytes(value: array of byte; startindex: integer): KTXPixel;
    begin
      Result := new KTXPixel;
      Result.PosX := BitConverter.ToInt32(value, startindex); startindex += 4;
      Result.PosY := BitConverter.ToInt32(value, startindex); startindex += 4;
      Result.Back := Color(integer(value[startindex])); startindex += 1;
      Result.Fore := Color(integer(value[startindex])); startindex += 1;
      Result.Symbol := BitConverter.ToChar(value, startindex); startindex += 2;
    end;
    
    public function GetBytes: array of byte;
    begin
      var num := 0;
      Result := new byte[12];
      foreach var x in BitConverter.GetBytes(PosX) do
      begin
        Result[num] := x;
        num += 1;
      end;
      foreach var x in BitConverter.GetBytes(PosY) do
      begin
        Result[num] := x;
        num += 1;
      end;
      Result[num] := byte(integer(Back));
      num += 1;
      Result[num] := byte(integer(Fore));
      num += 1;
      foreach var x in BitConverter.GetBytes(Symbol) do
      begin
        Result[num] := x;
        num += 1;
      end;
    end;
  end;

end.