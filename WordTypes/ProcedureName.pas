namespace Sunko;

type
  ProcedureName = class(WordType)
    public static function IsProcedureName(s: string): boolean;
    begin
      Result := s.StartsWith('!');
    end;
  end;

end.