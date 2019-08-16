namespace Sunko;

type
  LibraryName = class(WordType)
    private static flibs := new string[]('ktx');
    
    public static function IsLibraryName(s: string) := flibs.Contains(s);
  end;

end.