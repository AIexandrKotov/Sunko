namespace Sunko;

type
  Tree = class
    internal static fAllsnc := false;
    
    private fVariables: Dictionary<string, SunkoVariable>;
    
    private fOperations: array of Operation;
    
    private fSource: integer;
    
    private fLibraries: array of string;
    
    private fLabels: Dictionary<integer, integer>;
    
    public property Labels: Dictionary<integer, integer> read fLabels;
    public property Variables: Dictionary<string, SunkoVariable> read fVariables write fVariables;
    public property Operations: array of Operation read fOperations write fOperations;
    public property Libraries: array of string read fLibraries write fLibraries;
    public property Source: integer read fSource;
    
    public procedure CurrentOperation(op: integer) := fSource := Operations[op].Source;
    
    public static increments := new OperationType[](SunkoOperator, WhileOperator, ForCycleOperator, LoopCycleOperator, RepeatOperator, ConditionOperator);
    public static decrements := new OperationType[](EndOperator, UntilOperator);
    
    public static procedure NestedsVisitor(var t: Tree);
    begin
      var nested := 0;
      for var i := 0 to t.fOperations.Length - 1 do
      begin
        if increments.Contains(t.fOperations[i].OperationType) then nested += 1;
        if decrements.Contains(t.fOperations[i].OperationType) then nested -= 1;
      end;
      if nested <> 0 then raise new SyntaxError('WRONG_STRUCTURE', 0);
    end;
    
    public static procedure SyntaxVisitor(var t: Tree);
    begin
      NestedsVisitor(t);
    end;
    
    public constructor(ss: array of string);
    begin
      var ops := new List<Operation>;
      fVariables := new Dictionary<string, SunkoVariable>;
      fLabels := new Dictionary<integer, integer>;
      
      Parser.CommentVisitor(ss);
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
      for var i := 0 to ops.Count - 1 do
      begin
        if ops[i].OperationType = LabelDefinition then fLabels.Add(ops[i].Strings[1].ToInteger, i);
      end;
      {$ifdef DEBUG} fAllsnc := false; {$endif}
      fOperations := ops.ToArray;
    end;
  end;

end.