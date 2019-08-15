namespace Sunko;

type
  RealLiteral = class(WordType)
    public static function IsRealLiteral(s: string): boolean;
    begin
      var points := 0;
      Result := true;
      for var i := 1 to s.Length do
      begin
        if s[i] = '.' then points += 1 else
          if not s[i].IsDigit then
          begin
            result := false;
            break;
          end;
        if points > 1 then break;
      end;
      
      if points > 1 then Result := false;
    end;
  end;

end.