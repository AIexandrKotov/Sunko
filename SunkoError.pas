namespace Sunko;

type
  ErrorResources = static class
    private static files := Arr('ru.lng', 'en.lng');
    private static fLang := 1;
    private static langs: array of Dictionary<string, string>;
    
    public static property Lang: integer read fLang write fLang;
    
    private static function GetKeyValue(s: string): KeyValuePair<string, string>;
    begin
      var ss := s.ToWords('=');
      Result := new KeyValuePair<string, string>(Parser.GetString(ss[0], '"'), Parser.GetString(ss[1], '"'));
    end;
    
    public static procedure Init;
    begin
      langs := new Dictionary<string, string>[2];
      langs[0] := new Dictionary<string, string>;
      langs[1] := new Dictionary<string, string>;
      var sr := new System.IO.StreamReader(GetResourceStream('ru.lng'));
      var a := sr.ReadToEnd;
      foreach var x in a.ToWords(newline.ToArray) do
      begin
        var xx := GetKeyValue(x);
        langs[0].Add(xx.Key, xx.Value);
      end;
      sr := new System.IO.StreamReader(GetResourceStream('en.lng'));
      var b := sr.ReadToEnd;
      foreach var x in b.ToWords(newline.ToArray) do
      begin
        var xx := GetKeyValue(x);
        langs[1].Add(xx.Key, xx.Value);
      end;
    end;
    
    public static function GetErrorResourceString(param: boolean; s: string; params a: array of string): string;
    begin
      {$ifdef DEBUG}try{$endif}
        if not param then Result := string.Format(langs[fLang][s], a.ConvertAll(x -> object(x))) else Result := langs[fLang][s];
      {$ifdef DEBUG}except
        on e: System.Exception do
        begin
          writeln(s, a, langs[fLang]);
          raise;
        end;
      end;{$endif}
    end;
  end;
  
  SunkoError = class(System.Exception)
    private fSource: integer;
    public property Source: integer read fSource;
    
    private msg: string;
    private fParams: array of string;
    
    public function GetErrorMessage: string;
    begin
      Result := ErrorResources.GetErrorResourceString(fParams = nil, msg, fParams)
    end;
    
    public constructor(msg: string) := inherited Create(msg);
    public constructor(msg: string; source: integer; params p: array of string);
    begin
      Create(msg);
      self.msg := msg;
      fSource := source;
      fParams := p;
    end;
  end;
  
  SemanticError = class(SunkoError)
    
  end;
  
  SyntaxError = class(SunkoError)
  
  end;

end.