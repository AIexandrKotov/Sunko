namespace Sunko;

type
  OperationType = (
    DeclareVariable = 2,
    AssignmentVariable = 4,
    DeclareWithAssignment = 8,
    DestructionVariable = 16,
    ConditionOperator = 32,
    ElseOperator = 64,
    ForCycleOperator = 128,
    LoopCycleOperator = 129,
    WhileOperator = 256,
    RepeatOperator = 512,
    UntilOperator = 1024,
    EndOperator = 2048,
    ProcedureCall = 4096,
    SunkoOperator = 0,
    ExitOperator = -2,
    LabelDefinition = -4,
    GotoDefinition = -8
  );
  
  Operation = class
    private fStrings: array of string;
    private fWordsTypes: array of WordType;
    internal fOperationType: OperationType;
    
    internal fSource: integer;
    
    public property Source: integer read fSource write fSource;
    
    public property Strings: array of string read fStrings write fStrings;
    public property WordTypes: array of WordType read fWordsTypes write fWordsTypes;
    public property OperationType: Sunko.OperationType read fOperationType write fOperationType;
    
    private static assignmenttypes := Arr(typeof(IntegerLiteral), typeof(StringLiteral), typeof(RealLiteral), typeof(DateLiteral), typeof(Expression), typeof(Sunko.FunctionCall), typeof(VariableName));
    private static conditiontypes := Arr(typeof(IntegerLiteral), typeof(Expression), typeof(Sunko.FunctionCall), typeof(VariableName));
    
    public static function GetOperationType(x: Operation; disable: boolean): Sunko.OperationType;
    begin
      if (x.WordTypes = nil) or (x.WordTypes.Length = 0) or (x.Strings = nil) or (x.Strings.Length = 0) then raise new SyntaxError('Empty string', x.source);
      if (x.WordTypes[0] is Keyword) and (x.Strings[0] = 'sunko') then
      begin
        Result := SunkoOperator;
        exit;
      end;
      
      //AssignmentVariable
      if x.Strings.Length = 3 then
      begin
        if x.WordTypes[0] is VariableName then
          if x.WordTypes[1] is Splitter then
          begin
            if assignmenttypes.Contains(x.WordTypes[2].GetType) then
            begin
              Result := AssignmentVariable;
              exit;
            end;
          end;
      end;
      
      //DeclareWithAssignment
      if x.Strings.Length = 4 then
      begin
        if x.WordTypes[0] is TypeName then
        begin
          if x.WordTypes[1] is VariableName then
            if x.WordTypes[2] is Splitter then
            begin
              if assignmenttypes.Contains(x.WordTypes[3].GetType) then
              begin
                Result := DeclareWithAssignment;
                exit;
              end;
            end;
        end
        else if x.WordTypes[0] is Keyword then
        begin
          if x.Strings[0] = 'for' then
          begin
            Result := ForCycleOperator;
            exit;
          end;
        end;
      end;
      
      //DestructionVariable
      if x.Strings.Length = 2 then
      begin
        if x.WordTypes[0] is TypeName then
          if x.WordTypes[1] is VariableName then
          begin
            Result := DeclareVariable;
            exit;
          end;
        if x.WordTypes[0] is KeyWord then
          if x.Strings[0] = 'null' then
          begin
            if x.WordTypes[1] is VariableName then
            begin
              Result := DestructionVariable;
              exit;
            end;
          end
          else
          if x.Strings[0] = 'until' then
          begin
            Result := UntilOperator;
            exit;
          end
          else
          if x.Strings[0] = 'label' then
          begin
            if x.WordTypes[1] is IntegerLiteral then
            begin
              Result := LabelDefinition;
              exit;
            end
            else new SyntaxError('WRONG_LABEL_DEFINE', x.fSource);
          end
          else
          if x.Strings[0] = 'goto' then
          begin
            Result := GotoDefinition;
            exit;
          end;
      end;
      
      //ConditionOperator
      if x.Strings.Length = 3 then
      begin
        if x.WordTypes[0] is KeyWord then
          if x.Strings[0] = 'if' then
            if (x.WordTypes[2] is Keyword) and (x.Strings[2] = 'then') then
              if conditiontypes.Contains(x.WordTypes[1].GetType) then
              begin
                Result := ConditionOperator;
                exit;
              end;
      end;
      
      //ElseOperator
      if x.Strings.Length = 1 then
      begin
        if (x.WordTypes[0] is Keyword) and (x.Strings[0] = 'else') then
        begin
          Result := ElseOperator;
          exit;
        end;
        
        if (x.WordTypes[0] is Keyword) then
        begin
          if x.Strings[0] = 'end' then
          begin
            Result := EndOperator;
            exit;
          end;
          if x.Strings[0] = 'exit' then
          begin
            Result := ExitOperator;
            exit;
          end;
          if x.Strings[0] = 'repeat' then
          begin
            Result := RepeatOperator;
            exit;
          end;
        end;
      end;
      
      //LoopOperator
      if x.Strings.Length = 3 then
      begin
        if (x.WordTypes[0] is KeyWord) and (x.WordTypes[2] is KeyWord) then
        begin
          if (x.Strings[0] = 'loop') and (x.Strings[2] = 'do') then
          begin
            Result := LoopCycleOperator;
            exit;
          end;
          if (x.Strings[0] = 'while') and (x.Strings[2] = 'do') then
          begin
            Result := WhileOperator;
            exit;
          end;
        end;
      end;
      
      //ForCycleOperator
      if x.Strings.Length = 7 then
      begin
        if (x.WordTypes[0] is KeyWord) and (x.WordTypes[2] is Splitter) and (x.WordTypes[4] is Keyword) and (x.WordTypes[6] is KeyWord) then
        begin
          if (x.Strings[0] = 'for') and (x.Strings[2] = '=') and (x.Strings[4] = 'to') and (x.Strings[6] = 'do') then
          begin
            if (x.WordTypes[1] is VariableName) and (conditiontypes.Contains(x.WordTypes[3].GetType)) and (conditiontypes.Contains(x.WordTypes[5].GetType)) then
            begin
              Result := ForCycleOperator;
              exit;
            end;
          end;
        end;
      end;
      
      if x.WordTypes[0] is ProcedureName then
      begin
        Result := ProcedureCall;
        exit;
      end;
      
      if not disable then raise new SyntaxError('CONSTRUCTION_NOT_FOUND', x.fSource);
    end;
    
    public static function GetOperationType(x: Operation) := GetOperationType(x, false);
  end;

end.