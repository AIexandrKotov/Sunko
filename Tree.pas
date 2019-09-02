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
    
    public static procedure LabelVisitor(var t: Tree);
    begin
      for var i := 0 to t.Operations.Count - 1 do
      begin
        if t.Operations[i].OperationType = LabelDefinition then t.fLabels.Add(t.Operations[i].Strings[1].ToInteger, i);
      end;
    end;
    
    public static procedure SyntaxVisitor(var t: Tree);
    begin
      NestedsVisitor(t);
      SyntaxTreeVisitor.visit(t);
      LabelVisitor(t);
    end;
    
    public constructor;
    begin
      fVariables := new Dictionary<string, SunkoVariable>;
      fLabels := new Dictionary<integer, integer>;
    end;
    
    public constructor(ss: array of string);
    begin
      Create();
      var ops := new List<Operation>;
      
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
      {$ifdef DEBUG} fAllsnc := false; {$endif}
      fOperations := ops.ToArray;
    end;
  end;

end.