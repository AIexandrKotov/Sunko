namespace Sunko;

type
  ///Ключевое слово
  Keyword = class(WordType)
    private static fKeyWords := new string[]('sunko', 'destruct', 'loop', 'do', 'while', 'repeat', 'until', 'for', 'if', 'then', 'else', 'end', 'exit');
    
    public static function Contains(value: string) := fKeyWords.Contains(value);
  end;

end.