namespace Sunko;

type
  FunctionName = class(WordType)
    public static function IsFunctionName(s: string) := s.StartsWith('$') and not s.EndsWith('$');
  end;

end.