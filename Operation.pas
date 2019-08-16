namespace Sunko;

type
  OperationType = (
    DeclareVariable = 2,
    AssignmentVariable = 4,
    DeclareWithAssignment = 8,
    DestructionVariable = 16,
    ConditionOperator = 32,
    ElseOperator = 64,
    ForCycleOpeator = 128,
    WhileOperator = 256,
    RepeatOperator = 512,
    UntilOperator = 1024,
    EndOperator = 2048,
    ProcedureCall = 4096
  );
  
  Operation = class
    private fStrings: array of string;
    private fWordsTypes: array of WordType;
    
    public property Strings: array of string read fStrings write fStrings;
    public property WordTypes: array of WordType read fWordsTypes write fWordsTypes;
    
    private static assignmenttypes := Arr(typeof(IntegerLiteral), typeof(StringLiteral), typeof(RealLiteral), typeof(DateLiteral), typeof(Expression), typeof(FunctionCall));
    
    public function GetOperationType: OperationType;
    begin
      //DeclareVariable
      if Strings.Length = 2 then
      begin
        if WordTypes[0] is TypeName then
          if WordTypes[1] is VariableName then
          begin
            Result := DeclareVariable;
            exit;
          end;
      end;
      
      //AssignmentVariable
      if Strings.Length = 3 then
      begin
        if WordTypes[0] is VariableName then
          if WordTypes[1] is Splitter then
          begin
            if assignmenttypes.Contains(WordTypes[2].GetType) then
            begin
              Result := AssignmentVariable;
              exit;
            end;
          end;
      end;
      
      //DeclareWithAssignment
      if Strings.Length = 4 then
      begin
        if WordTypes[0] is TypeName then
          if WordTypes[1] is VariableName then
            if WordTypes[2] is Splitter then
            begin
              if assignmenttypes.Contains(WordTypes[3].GetType) then
              begin
                Result := DeclareWithAssignment;
                exit;
              end;
            end;
      end;
      
      //DestructionVariable
      if Strings.Length = 2 then
      begin
        if WordTypes[0] is KeyWord then
          if Strings[0] = 'destruct' then
            if WordTypes[1] is VariableName then
            begin
              Result := DestructionVariable;
              exit;
            end;
      end;
      
      //ConditionOperator
      if Strings.Length = 3 then
      begin
        if WordTypes[0] is KeyWord then
          if Strings[0] = 'if' then
            if (WordTypes[2] is Keyword) and (Strings[2] = 'then') then
              if WordTypes[1] is Expression then
              begin
                Result := ConditionOperator;
                exit;
              end;
      end;
      
      //ElseOperator
      if Strings.Length = 1 then
      begin
        if (WordTypes[0] is Keyword) and (Strings[0] = 'else') then
        begin
          Result := ElseOperator;
          exit;
        end;
      end;
    end;
  end;

end.