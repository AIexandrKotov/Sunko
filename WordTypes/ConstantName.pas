namespace Sunko;

type
  ConstantName = class(WordType)
    public static function IsConstantName(s: string) := s.StartsWith('#');
  end;

end.