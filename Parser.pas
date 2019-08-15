namespace Sunko;

type
  Parser = static class
    
    public static function Parse(s: string): Operation;
    begin
      Result := new Operation;
      var words := new List<string>;
      var current := new StringBuilder;
      var nested := false;
      for var i := 1 to s.Length do
      begin
        
      end;
    end;
  end;

end.