namespace Sunko;

type
  FunctionCall = class(WordType)
    public static function IsFunctionCall(s: string) := s.StartsWith('{') and s.EndsWith('}');
  end;

end.