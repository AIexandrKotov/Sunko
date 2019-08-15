namespace Sunko;

type
  VariableName = class(WordType)
    internal static lc := Range('a', 'z').ToArray;
    
    public static function IsVariableName(s: string): boolean;
    begin
      Result := s.All(x -> lc.Contains(x));
    end;
  end;

end.