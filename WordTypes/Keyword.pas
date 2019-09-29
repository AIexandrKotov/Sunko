namespace Sunko;

type
  ///Ключевое слово
  Keyword = class(WordType)
    private static fKeyWords := new string[]('sunko', 'null', 'loop', 'do', 'while', 'repeat', 'until', 'for', 'if', 'then', 'else', 'end', 'exit', 'label', 'goto', 'to', 'var');
    
    public static function Contains(value: string) := fKeyWords.Contains(value);
  end;

end.