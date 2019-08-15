namespace Sunko;

type
  Splitter =  class(WordType)
    private static fsplitters := new char[]('=', ':');
    
    public static function IsSplitter(s: string) := fsplitters.Contains(s[1]);
  end;
  
end.