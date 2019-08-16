namespace Sunko;

type
  Tree = class
    internal static fAllsnc := false;
    
    private fVariables: Dictionary<string, SunkoVariable>;
    
    private fOperations: array of Operation;
    
    public property Operations: array of Operation read fOperations write fOperations;
    
    public constructor(ss: array of string);
    begin
      var ops := new List<Operation>;
      var fVariables := new Dictionary<string, SunkoVariable>;
      
      Parser.WhiteSpacesVisitor(ss);
      for var i := 0 to ss.Length - 1 do
      begin
        {$ifdef DEBUG}
        //writeln(ss[i]);
        if fAllsnc then
        begin
          var a: Operation;
          if (not string.IsNullOrWhiteSpace(ss[i])) and (not ss[i].StartsWith('//')) then a := Parser.Parse(ss[i], true, i + 1) else a := nil;
          if (a <> nil) and (a.Strings <> nil) then
          begin
            writeln(a.Strings.JoinIntoString(' '), ' ─── ', a.OperationType, a.WordTypes);
          end;
        end;
        {$endif}
        if (not string.IsNullOrWhiteSpace(ss[i])) and (not ss[i].StartsWith('//')) then ops += Parser.Parse(ss[i], i + 1);
      end;
      {$ifdef DEBUG} fAllsnc := false; {$endif}
      fOperations := ops.ToArray;
    end;
  end;

end.