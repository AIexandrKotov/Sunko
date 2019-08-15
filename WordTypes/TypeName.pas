namespace Sunko;

type
  TypeName = class(WordType)
    private static ftypenames := new string[]('int', 'real', 'string', 'date', 'KTX.File');
    
    public static function IsTypeName(s: string) := ftypenames.Contains(s);
  end;

end.