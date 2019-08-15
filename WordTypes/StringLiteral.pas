namespace Sunko;

type
  StringLiteral = class(WordType)
    public static function IsStringLiteral(s: string) := s.StartsWith('''') and s.EndsWith('''');
  end;

end.