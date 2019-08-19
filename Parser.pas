namespace Sunko;

type
  Parser = static class
    public static procedure WhiteSpacesVisitor(var s: string);
    begin
      s := s.Trim(' ', #9, #10, #13);
    end;
    
    public static procedure WhiteSpacesVisitor(var s: array of string);
    begin
      for var i := 0 to s.Length - 1 do
        WhiteSpacesVisitor(s[i]);
    end;
    
    public static procedure CommentVisitor(var s: string);
    begin
      if '//' in s then
      begin
        var c := 0;
        var sb := new StringBuilder;
        for var i := 1 to s.Length do
        begin
          if s[i] = '/' then
          begin
            if c = 1 then
            begin
              break;
            end else
            begin
              c += 1;
              if s[i + 1] <> '/' then sb += s[i];
            end;
          end
          else
          begin
            c := 0;
            sb += s[i];
          end;
        end;
        s := sb.ToString;
      end;
    end;
    
    public static procedure CommentVisitor(var s: array of string);
    begin
      for var i := 0 to s.Length - 1 do
        CommentVisitor(s[i]);
    end;
    
    public static function GetString(self: string; delim: char): string;
    begin
      if self.Contains(delim) then
      begin
        var a, b: integer;
        a := self.IndexOf(delim);
        b := self.LastIndexOf(delim);
        Result := Copy(self, a+2, b-a-1);
      end else Result := self;
    end;
    
    public static function GetString(self: string; delim1, delim2: char): string;
    begin
      if (self.Contains(delim1)) and (self.Contains(delim2)) then
      begin
        var a, b: integer;
        a := self.IndexOf(delim1);
        b := self.LastIndexOf(delim2);
        Result := Copy(self, a+2, b-a-1);
      end else Result := self;
    end;
    
    public static function GetString(self: string) := GetString(self, '''');
    
    public static function GetFunction(self: string) := GetString(self, '{', '}');
    
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
    
    private static fsymbolsinexpresionnames := Range('a', 'z').ToArray + Range('0', '9').ToArray + '#';
    private static prohibitedwordsinexpressions := new string[]('and', 'or', 'not', 'mod', 'div');
    
    public static function IsName(s: string): boolean;
    begin
      if (string.IsNullOrWhiteSpace(s)) or (s[1].IsDigit) then Result := false
      else
      begin
        Result := (not prohibitedwordsinexpressions.Contains(s.ToLower)) and (s.All(x -> fsymbolsinexpresionnames.Contains(x)));
      end;
    end;
    
    public static function IncludeVariablesIntoExpression(t: Tree; expr: string): string;
    begin
      WhiteSpacesVisitor(expr);
      var lst := new List<string>;
      var current := new StringBuilder;
      var nestedfunc := 0;
      var lastfunc := false;
      for var i := 1 to expr.Length do
      begin
        if expr[i] = '{' then
        begin
          if nestedfunc = 0 then
          begin
            lst += current.ToString;
            current.Clear;
          end;
          nestedfunc += 1;
          lastfunc := true;
          current += '{';
        end
        else
        if expr[i] = '}' then
        begin
          nestedfunc -= 1;
          current += '}';
        end
        else
        if nestedfunc > 0 then current += expr[i] else
        begin
          if lastfunc then
          begin
            lst += current.ToString;
            current.Clear;
            lastfunc := false;
          end;
          if fsymbolsinexpresionnames.Contains(expr[i]) then
          begin
            if current.Length > 0 then
            begin
              if IsName(current.ToString) then current += expr[i] else
              begin
                if RealLiteral.IsRealLiteral(current.ToString) then
                begin
                  current += expr[i]
                end
                else
                begin
                  lst += current.ToString;
                  current.Clear;
                  current += expr[i];
                end;
              end;
            end else current += expr[i];
          end else if expr[i] = ' ' then
          begin
            if current.Length > 0 then
            begin
              lst += current.ToString;
              current.Clear;
            end;
          end else
          begin
            if IsName(current.ToString) then
            begin
              lst += current.ToString;
              current.Clear;
            end;
            current += expr[i];
          end;
        end;
      end;
      if current.Length > 0 then
      begin
        lst += current.ToString;
        current.Clear;
      end;
      for var i := 0 to lst.Count - 1 do
      begin
        lst[i] := lst[i].ToLower;
        if (VariableName.IsVariableName(lst[i])) and (not prohibitedwordsinexpressions.Contains(lst[i])) then
        begin
          if not t.Variables.ContainsKey(lst[i]) then raise new SemanticError('VARIABLE_NOT_DECLARED', t.Source, lst[i]);
          if t.Variables[lst[i]].IsArray then raise new SemanticError('USING_ARRAY_WITHOUT_INDEX', t.Source);
          var xx := t.Variables[lst[i]].Value;
          var tx := Compiler.GetObjectType(xx);
          if tx = 'string' then raise new SemanticError('NOT_SUPPORTED', t.Source);
          if tx = 'date' then xx := DateTime(xx).Ticks;
          lst[i] := xx.ToString;
        end
        else if ConstantName.IsConstantName(lst[i]) then raise new SemanticError('NOT_SUPPORTER', t.Source)
        else if FunctionCall.IsFunctionCall(lst[i]) then
        begin
          var xx := Compiler.FunctionCall(t, lst[i]);
          var tx := Compiler.GetObjectType(xx);
          if tx.EndsWith('[]') then raise new SemanticError('USING_ARRAY_WITHOUT_INDEX', t.Source);
          if tx = 'string' then raise new SemanticError('NOT_SUPPORTED', t.Source);
          if tx = 'date' then xx := DateTime(xx).Ticks;
          lst[i] := xx.ToString;
        end;
        //else raise new ArgumentException;
      end;
      Result := lst.JoinIntoString(' ');
    end;
    
    public static function Parse(s: string; disable: boolean; source: integer): Operation;
    begin
      WhiteSpacesVisitor(s);
      Result := new Operation;
      Result.Source := source;
      var words := new List<string>;
      var current := new StringBuilder;
      var nested := false;
      var nestedfunclevel := 0;
      var nestedbracket := 0;
      for var i := 1 to s.Length do
      begin
        if nestedfunclevel > 0 then current += s[i]
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
        if (not nested) then
        begin
          if (s[i] = '{') then nestedfunclevel += 1
            else if (s[i] = '}') then nestedfunclevel -= 1;
        end;
        if s[i] = '(' then nestedbracket += 1;
        if s[i] = ')' then nestedbracket -= 1;
      end;
      if (current.Length <> 0) and (not string.IsNullOrWhiteSpace(current.ToString)) then words += current.ToString;
      
      Result.Strings := words.ToArray;
      Result.WordTypes := WordTypes(Result.Strings);
      Result.fOperationType := Operation.GetOperationType(Result, disable);
    end;
    
    public static function Parse(s: string; source: integer) := Parse(s, false, source);
    
    public static function Parse(s: string) := Parse(s, 0);
  end;

end.