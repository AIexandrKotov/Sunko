namespace Sunko;

type
  IntegerLiteral = class(WordType)
    public static function IsIntegerLiteral(s: string) := s.All(x -> x.IsDigit);
  end;

end.