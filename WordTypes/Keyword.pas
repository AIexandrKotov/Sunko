namespace Sunko;

type
  ///Ключевое слово
  Keyword = class(WordType)
    private static fKeyWords := new string[]('delete', 'loop', 'do', 'while', 'repeat', 'until', 'for', 'if', 'then', 'else', 'end');
    
    public static function Contains(value: string) := fKeyWords.Contains(value);
  end;

end.