namespace Sunko;

type
  IntegerLiteral = class(WordType)
    public static function IsIntegerLiteral(s: string): boolean;
    begin
      Result := true;
      if not ((s[1] = '-') or (s[1] = '+') or (s[1].IsDigit)) then
      begin
        result := false;
        exit;
      end;
      for var i := 2 to s.Length do
        if not (s[i].IsDigit) then
        begin
          result := false;
          break;
        end;
    end;
  end;

end.