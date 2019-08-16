namespace Sunko;

type
  Parser = static class
    public static procedure WhiteSpacesVisitor(var s: string);
    begin
      s := s.TrimStart(' ', #9, #10, #13);
    end;
    
    public static procedure WhiteSpacesVisitor(var s: array of string);
    begin
      for var i := 0 to s.Length - 1 do
        WhiteSpacesVisitor(s[i]);
    end;
    
    public static function WordTypes(s: array of string): array of WordType;
    begin
      Result := new WordType[s.Length];
      for var i := 0 to s.Length - 1 do
      begin
        if ProcedureName.IsProcedureName(s[i]) then Result[i] := new ProcedureName
        else if FunctionCall.IsFunctionCall(s[i]) then Result[i] := new FunctionCall
        else if LibraryName.IsLibraryName(s[i]) then Result[i] := new LibraryName
        else if ConstantName.IsConstantName(s[i]) then Result[i] := new ConstantName
        else if IntegerLiteral.IsIntegerLiteral(s[i]) then Result[i] := new IntegerLiteral
        else if RealLiteral.IsRealLiteral(s[i]) then Result[i] := new RealLiteral
        else if DateLiteral.IsDateLiteral(s[i]) then Result[i] := new DateLiteral
        else if StringLiteral.IsStringLiteral(s[i]) then Result[i] := new StringLiteral
        else if Splitter.IsSplitter(s[i]) then Result[i] := new Splitter
        else
        begin
          if KeyWord.Contains(s[i]) then Result[i] := new Keyword
          else if TypeName.IsTypeName(s[i]) then Result[i] := new TypeName
          else if VariableName.IsVariableName(s[i]) then Result[i] := new VariableName
          else Result[i] := new Expression;
        end;
      end;
    end;
    
    public static function Parse(s: string; disable: boolean; source: integer): Operation;
    begin
      WhiteSpacesVisitor(s);
      Result := new Operation;
      Result.Source := source;
      var words := new List<string>;
      var current := new StringBuilder;
      var nested := false;
      var nestedfunc := false;
      var nestedbracket := 0;
      for var i := 1 to s.Length do
      begin
        if nestedfunc then current += s[i]
        else if nested then current += s[i]
        else
        begin
          if nestedbracket > 0 then current += s[i] else
          if (s[i] = ' ') and (s[i - 1] <> ' ') then
          begin
            words += current.ToString;
            current.Clear;
          end
          else if s[i] <> ' ' then current += s[i].ToLower
          else if s[i] = '=' then
          begin
            if current.Length > 0 then
            begin
              words += current.ToString;
              current.Clear;
            end;
            current += '=';
            words += current.ToString;
            current.Clear;
          end;
        end;
        
        if s[i] = '''' then
        begin
          //if not nestedfunc then if (not nested) then current += '''';
          nested := not nested;
        end;
        if (not nested) and (s[i] = '$') then
        begin
          nestedfunc := not nestedfunc;
        end;
        if s[i] = '(' then nestedbracket += 1;
        if s[i] = ')' then nestedbracket -= 1;
      end;
      if current.Length <> 0 then words += current.ToString;
      
      Result.Strings := words.ToArray;
      Result.WordTypes := WordTypes(Result.Strings);
      Result.fOperationType := Operation.GetOperationType(Result, disable);
    end;
    
    public static function Parse(s: string; source: integer) := Parse(s, false, source);
    
    public static function Parse(s: string) := Parse(s, 0);
  end;

end.