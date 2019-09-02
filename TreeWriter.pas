namespace Sunko;

uses System;
uses System.IO;

type
  TreeWriter = static class
    public static function GetBytes(self: string): array of byte;
    begin
      var id := 0;
      Result := new byte[self.Length + self.Length];
      foreach var x in self do
      begin
        foreach var y in BitConverter.GetBytes(x) do
        begin
          Result[id] := y;
          id += 1;
        end;
      end;
    end;
    
    public static function GetWordType(caser: WordType): byte;
    begin
      if caser is ConstantName then Result := 1
      else if caser is DateLiteral then Result := 2
      else if caser is Expression then Result := 3
      else if caser is FunctionCall then Result := 4
      else if caser is IntegerLiteral then Result := 5
      else if caser is Keyword then Result := 6
      else if caser is LibraryName then Result := 7
      else if caser is ProcedureName then Result := 8
      else if caser is RealLiteral then Result := 9
      else if caser is Splitter then Result := 10
      else if caser is TypeName then Result := 11
      else if caser is VariableName then Result := 12
      else if caser is StringLiteral then Result := 13;
    end;
    
    public static procedure WriteString(var sw: BinaryWriter; s: string);
    begin
      sw.Write(s.Length);
      for var i := 1 to s.Length do
      begin
        sw.Write(s[i]);
      end;
    end;
    
    public static procedure WriteOperation(var sw: BinaryWriter; op: Operation);
    begin
      sw.Write(integer(op.OperationType));
      sw.Write(op.Strings.Length);
      for var i := 0 to op.Strings.Length - 1 do
      begin
        WriteString(sw, op.Strings[i]);
        sw.Write(GetWordType(op.WordTypes[i]));
      end;
    end;
    
    public static procedure Write(var sw: BinaryWriter; t: Tree);
    begin
      sw.Write(t.Operations.Length);
      for var i := 0 to t.Operations.Length - 1 do
      begin
        WriteOperation(sw, t.Operations[i]);
      end;
    end;
    
    public static procedure FullWrite(t: Tree; var sw: BinaryWriter); //todo
    begin
//      public property Labels: Dictionary<integer, integer> read fLabels;
//      public property Variables: Dictionary<string, SunkoVariable> read fVariables write fVariables;
//      public property Operations: array of Operation read fOperations write fOperations;
//      public property Libraries: array of string read fLibraries write fLibraries;
//      public property Source: integer read fSource;
      sw.Write(t.Labels.Count);
      if t.Labels.Count > 0 then foreach var x in t.Labels.Keys.ToArray do
      begin
        sw.Write(x);
        sw.Write(t.Labels[x]);
      end;
      sw.Write(t.Variables.Count);
      if t.Variables.Count > 0 then foreach var x in t.Variables.Keys.ToArray do
      begin
        foreach var y in x do
        begin
          
        end;
      end;
    end;
  end;

end.