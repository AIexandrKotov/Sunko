namespace Sunko;

type
  VariableName = class(WordType)
    internal static lc := Range('a', 'z').ToArray + Range('0', '9').ToArray;
    
    public static function IsVariableName(s: string): boolean;
    begin
      Result := (not s[1].IsDigit) and (s.All(x -> lc.Contains(x)));
    end;
  end;

end.