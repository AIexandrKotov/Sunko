namespace Sunko;

uses System;
uses System.IO;

type
  TreeReader = static class
    public static function GetWordType(caser: byte): WordType;
    begin
      case caser of
        1: Result := new ConstantName;
        2: Result := new DateLiteral;
        3: Result := new Expression;
        4: Result := new FunctionCall;
        5: Result := new IntegerLiteral;
        6: Result := new Keyword;
        7: Result := new LibraryName;
        8: Result := new ProcedureName;
        9: Result := new RealLiteral;
        10: Result := new Splitter;
        11: Result := new TypeName;
        12: Result := new VariableName;
        13: Result := new StringLiteral;
      end;
    end;
    
    public static function ReadString(var sr: BinaryReader): string;
    begin
      var sb := new StringBuilder(sr.ReadInt32);
      loop sb.Capacity do sb += sr.ReadChar;
      Result := sb.ToString;
    end;
    
    public static function ReadOperation(var sr: BinaryReader): Operation;
    begin
      Result := new Operation();
//      sw.Write(integer(op.OperationType));
//      sw.Write(op.Strings.Length);
//      for var i := 0 to op.Strings.Length - 1 do
//      begin
//        sw.Write(op.Strings[i].Length);
//        sw.Write(op.Strings[i]);
//        sw.Write(GetWordType(op.WordTypes[i]));
//      end;
      Result.OperationType := OperationType(sr.ReadInt32);
      Result.Strings := new string[sr.ReadInt32];
      Result.WordTypes := new WordType[Result.Strings.Length];
      for var i := 0 to Result.Strings.Length - 1 do
      begin
        Result.Strings[i] := ReadString(sr);
        Result.WordTypes[i] := GetWordType(sr.ReadByte);
      end;
    end;
    
    public static function Read(var sr: BinaryReader): Tree;
    begin
      Result := new Tree();
      Result.Operations := new Operation[sr.ReadInt32];
      for var i := 0 to Result.Operations.Length - 1 do
      begin
        Result.Operations[i] := ReadOperation(sr);
      end;
    end;
  end;

end.