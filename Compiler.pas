namespace Sunko;

type
  Compiler = static class
    public static function GetDefaultValue(typename: string): object;
    begin
      case typename of
        'int': Result := 0;
        'string': Result := string.Empty;
        'real': Result := 0.0;
        'date': Result := DateTime.MinValue;
      end;
    end;
    
    private static fliterals := new System.Type[](typeof(IntegerLiteral), typeof(StringLiteral), typeof(RealLiteral), typeof(DateLiteral));
    
    public static function Isliteral(o: WordType) := fliterals.Contains(o.GetType);
    
    public static function GetLiteralValue(lt: WordType; literal: string): object;
    begin
      var str := Parser.GetString(literal);
      if lt is IntegerLiteral then
      begin
        Result := str.ToInteger;
        exit;
      end;
      if lt is RealLiteral then
      begin
        Result := str.ToReal;
        exit;
      end;
      if lt is DateLiteral then
      begin
        Result := DateTime.Parse(str);
        exit;
      end;
      if lt is StringLiteral then
      begin
        Result := str;
        exit;
      end;
    end;
    
    public static function GetLiteralType(lt: WordType): string;
    begin
      if lt is IntegerLiteral then
      begin
        Result := 'int';
        exit;
      end;
      if lt is RealLiteral then
      begin
        Result := 'real';
        exit;
      end;
      if lt is DateLiteral then
      begin
        Result := 'date';
        exit;
      end;
      if lt is StringLiteral then
      begin
        Result := 'string';
        exit;
      end;
    end;
    
    public static function GetObjectType(o: object): string;
    begin
      if o is integer then
      begin
        Result := 'int';
        exit;
      end;
      if o is real then
      begin
        Result := 'real';
        exit;
      end;
      if o is string then
      begin
        Result := 'string';
        exit;
      end;
      if o is DateTime then
      begin
        Result := 'date';
        exit;
      end;
      if o is boolean then
      begin
        Result := 'bool';
        exit;
      end;
    end;
    
    public static function IncludeVariablesIntoExpression(t: Tree; expression: string): string;
    begin
      Result := expression;
      var s := t.Variables.Keys.OrderBy(x -> - x.Length);
      foreach var x in s do Result := Result.Replace(x, t.Variables[x].Value.ToString);
    end;
    
    public static function GetExpressionValue(t: Tree; expression: string): object;
    begin
      var table := new System.Data.DataTable;
      Result := table.Compute(expression, '');
    end;
    
    public static procedure DeclarationDefinition(var t: Tree; varname, typename: string; nestedlevel: integer);
    begin
      t.Variables.Add(varname, new SunkoVariable(GetDefaultValue(typename), typename, nestedlevel));
    end;
    
    public static procedure AssignmentDefinitionValue(var t: Tree; varname: string; value: object);
    begin
      t.Variables[varname].Value := value;
    end;
    
    public static procedure AssignmentDefinitionLiteral(var t: Tree; varname: string; literal: string; literaltype: WordType);
    begin
      var littypestr := GetLiteralType(literaltype);
      if t.Variables[varname].SunkoType <> littypestr then raise new SemanticError($'CANNOT_CONVERT_TYPES', t.Source, littypestr, t.Variables[varname].SunkoType);
      t.Variables[varname].Value := GetLiteralValue(literaltype, literal);
    end;
    
    public static procedure DeclarationAndAssignment(var t: Tree; o: Operation; nested: integer);
    begin
      case o.OperationType of
        DeclareVariable:
        begin
          var typename := o.Strings[0];
          var vname := o.Strings[1];
          
          if t.Variables.ContainsKey(vname) then raise new SemanticError($'VARIABLE_ALREADY_DECLARED', t.Source, vname);
          
          DeclarationDefinition(t, vname, typename, nested);
        end;
        
        AssignmentVariable:
        begin
          var vname := o.Strings[0];
          if not t.Variables.ContainsKey(vname) then raise new SemanticError('VARIABLE_NOT_DECLARED', t.Source, vname);
          if Isliteral(o.WordTypes[2]) then
          begin
            AssignmentDefinitionLiteral(t, vname, o.Strings[2], o.WordTypes[2]);
          end
          else
          match o.WordTypes[2] with
            VariableName(var rightvar):
            begin
              var vname2 := o.Strings[2];
              if not t.Variables.ContainsKey(vname2) then raise new SemanticError('VARIABLE_NOT_FOUND', t.Source, vname2);
              var type1 := GetObjectType(t.Variables[vname2].Value);
              var type2 := GetObjectType(t.Variables[vname2].Value);
              if type1 <> type2 then raise new SemanticError($'CANNOT_CONVERT_TYPES', t.Source, type1, type2);
              AssignmentDefinitionValue(t, vname, t.Variables[vname2].Value);
            end;
            Expression(var exp):
            begin
              var expr := GetExpressionValue(t, IncludeVariablesIntoExpression(t, o.Strings[2]));
              var exprtype := GetObjectType(expr);
              if exprtype = 'bool' then
              begin
                expr := object(integer(boolean(expr) ? 1 : 0));
                exprtype := 'int';
              end;
              if exprtype <> t.Variables[vname].SunkoType then raise new SemanticError($'CANNOT_CONVERT_TYPES', t.Source, exprtype, t.Variables[vname].SunkoType);
              AssignmentDefinitionValue(t, vname, expr);
            end;
          end;
        end;
        
        DeclareWithAssignment:
        begin
          var vtype := o.Strings[0];
          var vname := o.Strings[1];
          
          if t.Variables.ContainsKey(vname) then raise new SemanticError('VARIABLE_ALREADY_DECLARED', t.Source, vname);
          
          if Isliteral(o.WordTypes[3]) then
          begin
            DeclarationDefinition(t, vname, vtype, nested);
            AssignmentDefinitionLiteral(t, vname, o.Strings[3], o.WordTypes[3]);
          end
          else
          match o.WordTypes[3] with
            VariableName(var rightvar):
            begin
              DeclarationDefinition(t, vname, vtype, nested);
              var vname2 := o.Strings[3];
              if not t.Variables.ContainsKey(vname2) then raise new SemanticError('VARIABLE_NOT_FOUND', t.Source, vname2);
              var type1 := GetObjectType(t.Variables[vname2].Value);
              var type2 := GetObjectType(t.Variables[vname2].Value);
              if type1 <> type2 then raise new SemanticError('CANNOT_CONVERT_TYPES', t.Source, type1, type2);
              AssignmentDefinitionValue(t, vname, t.Variables[vname2].Value);
            end;
            Expression(var exp):
            begin
              DeclarationDefinition(t, vname, vtype, nested);
              var expr := GetExpressionValue(t, IncludeVariablesIntoExpression(t, o.Strings[3]));
              var exprtype := GetObjectType(expr);
              if exprtype = 'bool' then
              begin
                expr := object(integer(boolean(expr) ? 1 : 0));
                exprtype := 'int';
              end;
              if exprtype <> t.Variables[vname].SunkoType then raise new SemanticError('CANNOT_CONVERT_TYPES', t.Source, exprtype, t.Variables[vname].SunkoType);
              AssignmentDefinitionValue(t, vname, expr);
            end;
            else raise new SemanticError('NOT_SUPPORTED', t.Source);
          end;
        end;
        
        DestructionVariable:
        begin
          if not t.Variables.ContainsKey(o.Strings[1]) then raise new SemanticError('DESTRUCTION_NONDECLARED_VARIABLE', t.Source, o.Strings[1]);
          t.Variables.Remove(o.Strings[1]);
        end;
      end;
    end;
    
    public static procedure RecalculateNestedBetween(var t: Tree; var nested: integer; _sunko, _end: integer);
    begin
      if _sunko < _end then
      begin
        for var i := _sunko + 1 to _end - 1 do
        begin
          if Tree.increments.Contains(t.Operations[i].OperationType) then nested += 1;
          if Tree.decrements.Contains(t.Operations[i].OperationType) then nested -= 1;
          DeclarationAndAssignment(t, t.Operations[i], nested);
        end;
      end
      else
      begin
        for var i := _end - 1 downto _sunko + 1 do
        begin
          if Tree.increments.Contains(t.Operations[i].OperationType) then nested += 1;
          if Tree.decrements.Contains(t.Operations[i].OperationType) then nested -= 1;
          DeclarationAndAssignment(t, t.Operations[i], nested);
        end;
      end;
      foreach var x in t.Variables.Keys.ToArray do
      begin
        if t.Variables[x].NestedLevel > nested then t.Variables.Remove(x);
      end;
    end;
    
    public static function FindNextElseOnThisNestedLevel(var t: Tree; from: integer; nested: integer): integer;
    begin
      Result := 0;
      var curnested := nested;
      for var i := from + 1 to t.Operations.Length - 1 do
      begin
        if t.Operations[i].OperationType = ElseOperator then
          if curnested = nested then
          begin
            Result := i;
            break;
          end;
        if Tree.decrements.Contains(t.Operations[i].OperationType) then curnested -= 1;
        if Tree.increments.Contains(t.Operations[i].OperationType) then curnested += 1;
      end;
    end;
    
    public static function FindNextEndOnThisNestedLevel(var t: Tree; from: integer; nested: integer): integer;
    begin
      var curnested := nested;
      for var i := from + 1 to t.Operations.Length - 1 do
      begin
        if t.Operations[i].OperationType = EndOperator then
          if curnested = nested then
          begin
            Result := i;
            break;
          end;
        if Tree.decrements.Contains(t.Operations[i].OperationType) then curnested -= 1;
        if Tree.increments.Contains(t.Operations[i].OperationType) then curnested += 1;
      end;
    end;
    
    public static procedure Compile(t: Tree);
    begin
      var currentnestedlevel := -1;
      var i := 0;
      var elseskipstack := new Stack<integer>;
      var elsereturnstack := new Stack<integer>;
      while i < t.Operations.Length - 1 do
      begin
        t.CurrentOperation(i);
        case t.Operations[i].OperationType of
          
          SunkoOperator:
          begin
            currentnestedlevel += 1;
            i += 1;
          end;
          
          EndOperator:
          begin
            currentnestedlevel -= 1;
            foreach var x in t.Variables.Keys.ToArray do
            begin
              if t.Variables[x].NestedLevel > currentnestedlevel then t.Variables.Remove(x);
            end;
            i += 1;
          end;
          
          DeclareVariable, AssignmentVariable, DeclareWithAssignment, DestructionVariable:
          begin
            DeclarationAndAssignment(t, t.Operations[i], currentnestedlevel);
            i += 1;
          end;
          
          GotoDefinition:
          begin
            var labelkey := t.Operations[i].Strings[1].ToInteger;
            if not t.Labels.ContainsKey(labelkey) then raise new SemanticError('LABEL_NOT_DECLARED', t.Source, labelkey.ToString);
            RecalculateNestedBetween(t, currentnestedlevel, i, t.Labels[labelkey]);
            i := t.Labels[labelkey];
          end;
          
          ConditionOperator:
          begin
            currentnestedlevel += 1;
            var elselabel := FindNextElseOnThisNestedLevel(t, i, currentnestedlevel);
            var endlabel := FindNextEndOnThisNestedLevel(t, i, currentnestedlevel);
            var bool := false;
            
            match t.Operations[i].WordTypes[1] with
              Expression(var exp):
              begin
                var expr := GetExpressionValue(t, IncludeVariablesIntoExpression(t, t.Operations[i].Strings[1]));
                var exprtype := GetObjectType(expr);
                if exprtype = 'bool' then
                begin
                  bool := boolean(expr);
                end
                else if exprtype <> 'int' then
                begin
                  bool := integer(expr) <> 0;
                end
                else raise new SemanticError($'CANNOT_CONVERT_TYPES', t.Source, exprtype, 'int');
              end;
              VariableName(var __vname):
              begin
                var vname := t.Operations[i].Strings[1];
                if not t.Variables.ContainsKey(vname) then raise new SemanticError('VARIABLE_NOT_DECLARED', t.Source, vname);
                var tp := GetObjectType(t.Variables[vname].Value);
                if not (tp = 'int') then raise new SemanticError('CANNOT_CONVERT_TYPE', t.Source, tp, 'int');
                bool := integer(t.Variables[vname].Value) <> 0;
              end;
              IntegerLiteral(var int):
              begin
                bool := t.Operations[i].Strings[1].ToInteger <> 0;
              end;
              FunctionCall(var fcall):
              begin
                raise new SemanticError('NOT_SUPPORTED', t.Source);
              end;
            end;
            if elselabel <> 0 then
            begin
              if not bool then i := elselabel else
              begin
                elseskipstack += elselabel;
                elsereturnstack += endlabel;
              end;
            end
            else if not bool then i := endlabel;
            if bool then i += 1;
          end;
          
          ProcedureCall:
          begin
            if t.Operations[i].Strings[0] = '!write' then
            begin
              if Isliteral(t.Operations[i].WordTypes[1]) then
              begin
                if t.Operations[i].WordTypes[1] is StringLiteral then write(Parser.GetString(t.Operations[i].Strings[1])) else write(t.Operations[i].Strings[1]);
              end else
              match t.Operations[i].WordTypes[1] with
                VariableName(var __vname):
                begin
                  var vname := t.Operations[i].Strings[1];
                  if not t.Variables.ContainsKey(vname) then raise new SemanticError('VARIABLE_NOT_DECLARED', t.Source, vname);
                  write(t.Variables[vname].Value.ToString);
                end;
                Expression(var exp):
                begin
                  var expr := GetExpressionValue(t, IncludeVariablesIntoExpression(t, t.Operations[i].Strings[1]));
                  write(expr.ToString);
                end;
              end;
            end;
            
            if t.Operations[i].Strings[0] = '!writeln' then
            begin
              if t.Operations[i].WordTypes.Length > 1 then
              begin
                if Isliteral(t.Operations[i].WordTypes[1]) then
                begin
                  if t.Operations[i].WordTypes[1] is StringLiteral then write(Parser.GetString(t.Operations[i].Strings[1])) else writeln(t.Operations[i].Strings[1]);
                end else
                match t.Operations[i].WordTypes[1] with
                  VariableName(var __vname):
                  begin
                    var vname := t.Operations[i].Strings[1];
                    if not t.Variables.ContainsKey(vname) then raise new SemanticError('VARIABLE_NOT_DECLARED', t.Source, vname);
                    writeln(t.Variables[vname].Value.ToString);
                  end;
                  Expression(var exp):
                  begin
                    var expr := GetExpressionValue(t, IncludeVariablesIntoExpression(t, t.Operations[i].Strings[1]));
                    writeln(expr.ToString);
                  end;
                end;
              end
              else writeln;
            end;
              
            if t.Operations[i].Strings[0] = '!stopkey' then
            begin
              System.Console.ReadKey(true);
            end;
            i += 1;
          end;
          
          ElseOperator:
          begin
            if (elseskipstack.Count > 0) and (i = elseskipstack.Peek) then
            begin
              elseskipstack.Pop;
              i := elsereturnstack.Pop;
            end
            else
            begin
              foreach var x in t.Variables.Keys.ToArray do
              begin
                if t.Variables[x].NestedLevel > currentnestedlevel then t.Variables.Remove(x);
              end;
              i += 1;
            end;
            
          end;
          
          else i += 1;
        end;
      end;
    end;
    
    public static function Compile(fname: string): integer;
    begin
      var t := ReadAllLines(fname);
      var tr := new Tree(t);
      Tree.SyntaxVisitor(tr);
      Compile(tr);
      Result := t.Length;
    end;
  end;

end.