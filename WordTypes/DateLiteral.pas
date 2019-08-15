namespace Sunko;

type
  DateLiteral = class(WordType)
    public static function IsDateLiteral(s: string) := s.All(x -> x.IsDigit or (x = '.') or (x = ':'));
  end;

end.