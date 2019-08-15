namespace Sunko;

type
  OparationType = (
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
  end;

end.