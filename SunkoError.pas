namespace Sunko;

type
  ErrorResources = static class
    private static files := Arr('ru.lng');
  end;
  
  SunkoError = class(System.Exception)
    private fSource: integer;
    public property Source: integer read fSource;
    
    public constructor(msg: string) := inherited Create(msg);
    public constructor(msg: string; source: integer);
    begin
      Create(msg);
      fSource := source;
    end;
  end;
  
  SemanticError = class(SunkoError)
    
  end;
  
  SyntaxError = class(SunkoError)
  
  end;

end.