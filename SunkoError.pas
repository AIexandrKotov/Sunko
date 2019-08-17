namespace Sunko;

type
  SunkoError = class(System.Exception)
    public constructor(msg: string) := inherited Create(msg);
    public constructor(msg: string; source: integer) := Create($'{msg} at {source}');
  end;
  
  SemanticError = class(SunkoError)
    
  end;
  
  SyntaxError = class(SunkoError)
  
  end;

end.