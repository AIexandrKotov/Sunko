namespace Sunko;

type
  SunkoVariable = class
    private fValue: object;
    private fNestedLevel: integer;
    
    private fArray: array of object;
    private fIsArray: boolean;
    
    public property Value: object read fValue write fValue;
    public property NestedLevel: integer read fNestedLevel write fNestedLevel;
  end;

end.