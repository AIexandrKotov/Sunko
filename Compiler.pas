namespace Sunko;

uses System.IO;

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
    
    public static StaticTypes := true;
    
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
    type
      ArrayOf<T> = array of T;
    begin
      if o is ArrayOf<integer> then Result := 'int[]' 
      else if o is integer then
      begin
        Result := 'int';
      end
      else if o is ArrayOf<int64> then Result := 'int64[]' 
      else if o is int64 then
      begin
        Result := 'int64';
      end
      else if o is ArrayOf<real> then Result := 'real[]' 
      else if o is real then
      begin
        Result := 'real';
      end
      else if o is ArrayOf<string> then Result := 'string[]' 
      else if o is string then
      begin
        Result := 'string';
      end
      else if o is ArrayOf<DateTime> then Result := 'date[]' 
      else if o is DateTime then
      begin
        Result := 'date';
      end
      else if o is ArrayOf<boolean> then Result := 'bool[]'
      else if o is boolean then
      begin
        Result := 'bool';
      end;
    end;
    
    public static function IncludeVariablesIntoExpression(t: Tree; expression: string): string;
    begin
      Result := expression;
      var s := t.Variables.Keys.OrderBy(x -> - x.Length);
      foreach var x in s do
      begin
        case t.Variables[x].SunkoType of
          'int', 'string', 'real': Result := Result.Replace(x, t.Variables[x].Value.ToString);
          'date': Result := Result.Replace(x, DateTime(t.Variables[x].Value).Ticks.ToString);
        end;
        
      end;
    end;
    
    public static function GetExpressionValue(t: Tree; expression: string): object;
    begin
      var table := new System.Data.DataTable;
      try
        Result := table.Compute(Parser.IncludeVariablesIntoExpression(t, expression), '');
      except
        on e: System.Data.SyntaxErrorException do raise new SemanticError('WRONG_EXPRESSION', t.Source);
        on e: System.DivideByZeroException do raise new SemanticError('WRONG_EXPRESSION', t.Source);
      end;
      if Result is decimal then Result := real(decimal(Result));
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
      if (StaticTypes) and (t.Variables[varname].SunkoType <> littypestr) then raise new SemanticError($'CANNOT_CONVERT_TYPES', t.Source, littypestr, t.Variables[varname].SunkoType);
      t.Variables[varname].Value := GetLiteralValue(literaltype, literal);
    end;
    
    public static procedure DeclarationAndAssignment(var t: Tree; o: Operation; nested: integer);
    begin
      case o.OperationType of
        DeclareVariable:
        begin
          var typename := o.Strings[0];
          var vname := o.Strings[1];
          
          if t.Variables.ContainsKey(vname) then
          begin
            t.Variables[vname].Value := GetDefaultValue(typename);
            exit;
          end;
          
          DeclarationDefinition(t, vname, typename, nested);
        end;
        
        AssignmentVariable:
        begin
          var vname := o.Strings[0];
          if Isliteral(o.WordTypes[2]) then
          begin
            AssignmentDefinitionLiteral(t, vname, o.Strings[2], o.WordTypes[2]);
          end
          else
          match o.WordTypes[2] with
            VariableName(var rightvar):
            begin
              var vname2 := o.Strings[2];
              var type1 := GetObjectType(t.Variables[vname2].Value);
              var type2 := GetObjectType(t.Variables[vname2].Value);
              if (StaticTypes) and (type1 <> type2) then raise new SemanticError($'CANNOT_CONVERT_TYPES', t.Source, type1, type2);
              AssignmentDefinitionValue(t, vname, t.Variables[vname2].Value);
            end;
            Expression(var exp):
            begin
              var expr := GetExpressionValue(t, o.Strings[2]);
              var exprtype := GetObjectType(expr);
              if exprtype = 'bool' then
              begin
                expr := object(integer(boolean(expr) ? 1 : 0));
                exprtype := 'int';
              end;
              if (StaticTypes) and (exprtype <> t.Variables[vname].SunkoType) then raise new SemanticError($'CANNOT_CONVERT_TYPES', t.Source, exprtype, t.Variables[vname].SunkoType);
              AssignmentDefinitionValue(t, vname, expr);
            end;
            Sunko.FunctionCall(var fcall):
            begin
              var ofunc := Methods.FunctionCall(t, o.Strings[2]);
              var otype := GetObjectType(ofunc);
              if otype = 'bool' then
              begin
                ofunc := object(integer(boolean(ofunc) ? 1 : 0));
                otype := 'int';
              end;
              if (StaticTypes) and (otype <> t.Variables[vname].SunkoType) then raise new SemanticError('CANNOT_CONVERT_TYPES', t.Source, otype, t.Variables[vname].SunkoType);
              AssignmentDefinitionValue(t, vname, ofunc);
            end;
          end;
        end;
        
        DeclareWithAssignment:
        begin
          var vtype := o.Strings[0];
          var vname := o.Strings[1];
          var cntns := false;
          
          if t.Variables.ContainsKey(vname) then
          begin
            t.Variables[vname].Value := GetDefaultValue(vtype);
            cntns := true;
          end;
          
          if Isliteral(o.WordTypes[3]) then
          begin
            if not cntns then DeclarationDefinition(t, vname, vtype, nested);
            AssignmentDefinitionLiteral(t, vname, o.Strings[3], o.WordTypes[3]);
          end
          else
          match o.WordTypes[3] with
            VariableName(var rightvar):
            begin
              if not cntns then DeclarationDefinition(t, vname, vtype, nested);
              var vname2 := o.Strings[3];
              var type1 := GetObjectType(t.Variables[vname2].Value);
              var type2 := GetObjectType(t.Variables[vname2].Value);
              if (StaticTypes) and (type1 <> type2) then raise new SemanticError('CANNOT_CONVERT_TYPES', t.Source, type1, type2);
              AssignmentDefinitionValue(t, vname, t.Variables[vname2].Value);
            end;
            Expression(var exp):
            begin
              if not cntns then DeclarationDefinition(t, vname, vtype, nested);
              var expr := GetExpressionValue(t, o.Strings[3]);
              var exprtype := GetObjectType(expr);
              if exprtype = 'bool' then
              begin
                expr := object(integer(boolean(expr) ? 1 : 0));
                exprtype := 'int';
              end;
              if (StaticTypes) and (exprtype <> t.Variables[vname].SunkoType) then raise new SemanticError('CANNOT_CONVERT_TYPES', t.Source, exprtype, t.Variables[vname].SunkoType);
              AssignmentDefinitionValue(t, vname, expr);
            end;
            Sunko.FunctionCall(var fcall):
            begin
              if not cntns then DeclarationDefinition(t, vname, vtype, nested);
              var ofunc := Methods.FunctionCall(t, o.Strings[3]);
              var otype := GetObjectType(ofunc);
              if otype = 'bool' then
              begin
                ofunc := object(integer(boolean(ofunc) ? 1 : 0));
                otype := 'int';
              end;
              if (StaticTypes) and (otype <> t.Variables[vname].SunkoType) then raise new SemanticError('CANNOT_CONVERT_TYPES', t.Source, otype, t.Variables[vname].SunkoType);
              AssignmentDefinitionValue(t, vname, ofunc);
            end;
            else raise new SemanticError('NOT_SUPPORTED', t.Source);
          end;
        end;
        
        AutotypeDeclare:
        begin
          var vname := o.Strings[1];
          var vtype := string.Empty;
          
          if t.Variables.ContainsKey(vname) then raise new SyntaxError('VARIABLE_ALREADY_DECLARED', t.Source, vname);
          
          if Isliteral(o.WordTypes[3]) then
          begin
            vtype := GetLiteralType(o.WordTypes[3]);
            DeclarationDefinition(t, vname, vtype, nested);
            AssignmentDefinitionLiteral(t, vname, o.Strings[3], o.WordTypes[3]);
          end
          else
          match o.WordTypes[3] with
            VariableName(var rightvar):
            begin
              var vname2 := o.Strings[3];
              var type2 := GetObjectType(t.Variables[vname2].Value);
              DeclarationDefinition(t, vname, type2, nested);
              AssignmentDefinitionValue(t, vname, t.Variables[vname2].Value);
            end;
            Expression(var exp):
            begin
              var expr := GetExpressionValue(t, o.Strings[3]);
              var exprtype := GetObjectType(expr);
              if exprtype = 'bool' then
              begin
                expr := object(integer(boolean(expr) ? 1 : 0));
                exprtype := 'int';
              end;
              DeclarationDefinition(t, vname, exprtype, nested);
              AssignmentDefinitionValue(t, vname, expr);
            end;
            Sunko.FunctionCall(var fcall):
            begin
              var ofunc := Methods.FunctionCall(t, o.Strings[3]);
              var otype := GetObjectType(ofunc);
              if otype = 'bool' then
              begin
                ofunc := object(integer(boolean(ofunc) ? 1 : 0));
                otype := 'int';
              end;
              DeclarationDefinition(t, vname, otype, nested);
              AssignmentDefinitionValue(t, vname, ofunc);
            end;
            else raise new SemanticError('NOT_SUPPORTED', t.Source);
          end;
        end;
        
        DestructionVariable:
        begin
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
          if Tree.increments.Contains(t.Operations[i].OperationType) then nested -= 1;
          if Tree.decrements.Contains(t.Operations[i].OperationType) then nested += 1;
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
    
    public static function GetWordType(wt: WordType): string;
    begin
      Result := wt.ToString;
    end;
    
    public static function GetConditionValue(var t: Tree; op: Operation; pos: integer): boolean;
    begin
      match op.WordTypes[pos] with
        Expression(var exp):
        begin
          var expr := GetExpressionValue(t, op.Strings[pos]);
          var exprtype := GetObjectType(expr);
          if exprtype = 'bool' then
          begin
            Result := boolean(expr);
          end
          else if exprtype <> 'int' then
          begin
            Result := integer(expr) <> 0;
          end
          else if (StaticTypes) then raise new SemanticError($'CANNOT_CONVERT_TYPES', t.Source, exprtype, 'int');
        end;
        VariableName(var __vname):
        begin
          var vname := op.Strings[pos];
          if not t.Variables.ContainsKey(vname) then raise new SemanticError('VARIABLE_NOT_DECLARED', t.Source, vname);
          var tp := GetObjectType(t.Variables[vname].Value);
          if (StaticTypes) and (not (tp = 'int')) then raise new SemanticError('CANNOT_CONVERT_TYPE', t.Source, tp, 'int');
          Result := integer(t.Variables[vname].Value) <> 0;
        end;
        IntegerLiteral(var int):
        begin
          Result := op.Strings[pos].ToInteger <> 0;
        end;
        Sunko.FunctionCall(var fcall):
        begin
          var fv := Methods.FunctionCall(t, op.Strings[pos]);
          var ft := GetObjectType(fv);
          if ft = 'bool' then
          begin
            Result := boolean(fv);
          end
          else if ft = 'int' then
          begin
            Result := integer(fv) <> 0;
          end
          else if (StaticTypes) then raise new SemanticError($'CANNOT_CONVERT_TYPES', t.Source, ft, 'int');
        end;
      end;
    end;
    
    public static function GetIntegerValue(var t: Tree; op: Operation; pos: integer): integer;
    begin
      match op.WordTypes[pos] with
        IntegerLiteral(var lit):
        begin
          Result := op.Strings[pos].ToInteger;
        end;
        VariableName(var o):
        begin
          var vname := op.Strings[pos];
          if not t.Variables.ContainsKey(vname) then raise new SemanticError('VARIABLE_NOT_DECLARED', t.Source, vname);
          var tp := GetObjectType(t.Variables[vname].Value);
          if (StaticTypes) and (not (tp = 'int')) then raise new SemanticError('CANNOT_CONVERT_TYPE', t.Source, tp, 'int');
          Result := integer(t.Variables[vname].Value);
        end;
        Expression(var o):
        begin
          var expr := GetExpressionValue(t, op.Strings[pos]);
          var exprtype := GetObjectType(expr);
          if exprtype = 'int' then
          begin
            Result := integer(expr);
          end
          else raise new SemanticError($'CANNOT_CONVERT_TYPES', t.Source, exprtype, 'int');
        end;
        Sunko.FunctionCall(var o):
        begin
          var fv := Methods.FunctionCall(t, op.Strings[pos]);
          var ft := GetObjectType(fv);
          if ft = 'int' then
          begin
            Result := integer(fv);
          end
          else raise new SemanticError($'CANNOT_CONVERT_TYPES', t.Source, ft, 'int');
        end;
      end;
    end;
    
    public static procedure AssignCycleVariable(var t: Tree; nlevel: integer; varname: string; value: integer);
    begin
      if t.Variables.ContainsKey(varname) then raise new SemanticError('VARIABLE_ALREADY_DECLARED', t.Source, varname);
      t.Variables.Add(varname, new SunkoVariable(value, 'int', nlevel));
    end;
    
    public static procedure Compile(t: Tree);
    begin
      var currentnestedlevel := -1;
      var i := 0;
      var cyclenested := new Stack<word>;
      //1 - while
      var cyclestack := new Stack<byte>;
      var cyclelables := new Stack<integer>;
      var cyclewhiles := new Stack<Operation>;
      
      var cycleloops := new Stack<integer>;
      
      var cycleforvariables := new Stack<string>;
      var cycleforleft := new Stack<integer>;
      var cycleforright := new Stack<integer>;
      var cycleforstep := new Stack<integer>;
      
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
            if (cyclenested.Count <> 0) and (cyclenested.Peek = currentnestedlevel) then
            begin
              case cyclestack.Peek of
                1:
                ///WHILE
                begin
                  if GetConditionValue(t, cyclewhiles.Peek, 1) then i := cyclelables.Peek + 1 else
                  begin
                    cyclenested.Pop; cyclelables.Pop; cyclestack.Pop; cyclewhiles.Pop;
                    i += 1;
                    currentnestedlevel -= 1;
                    foreach var x in t.Variables.Keys.ToArray do
                    begin
                      if t.Variables[x].NestedLevel > currentnestedlevel then t.Variables.Remove(x);
                    end;
                  end;
                end;
                2:
                ///LOOP
                begin
                  var cnt := cycleloops.Pop;
                  if cnt > 1 then
                  begin
                    i := cyclelables.Peek + 1;
                    cycleloops += cnt - 1;
                  end
                  else
                  begin
                    cyclenested.Pop; cyclelables.Pop; cyclestack.Pop;
                    i += 1;
                    currentnestedlevel -= 1;
                    foreach var x in t.Variables.Keys.ToArray do
                    begin
                      if t.Variables[x].NestedLevel > currentnestedlevel then t.Variables.Remove(x);
                    end;
                  end;
                end;
                3:
                ///FOR
                begin
                  var cur := integer(t.Variables[cycleforvariables.Peek].Value);
                  var step := cycleforstep.Peek;
                  var isexit := false;
                  if step > 0 then
                  begin
                    cur += step;
                    if cur <= cycleforright.Peek then
                    begin
                      i := cyclelables.Peek + 1;
                      t.Variables[cycleforvariables.Peek].Value := cur;
                    end
                    else isexit := true;
                  end
                  else
                  begin
                    cur += step;
                    if cur >= cycleforright.Peek then
                    begin
                      i := cyclelables.Peek + 1;
                      t.Variables[cycleforvariables.Peek].Value := cur;
                    end
                    else isexit := true;
                  end;
                  
                  if isexit then
                  begin
                    cyclenested.Pop; cyclelables.Pop; cyclestack.Pop; cycleforleft.Pop; cycleforright.Pop; cycleforstep.Pop;
                    t.Variables.Remove(cycleforvariables.Pop);
                    i += 1;
                    currentnestedlevel -= 1;
                    foreach var x in t.Variables.Keys.ToArray do
                    begin
                      if t.Variables[x].NestedLevel > currentnestedlevel then t.Variables.Remove(x);
                    end;
                  end;
                end;
              end;
            end
            else
            begin
              currentnestedlevel -= 1;
              foreach var x in t.Variables.Keys.ToArray do
              begin
                if t.Variables[x].NestedLevel > currentnestedlevel then t.Variables.Remove(x);
              end;
              i += 1;
            end;
          end;
          
          ExitOperator:
          begin
            if (cyclenested.Count > 0) then
            begin
              i := FindNextEndOnThisNestedLevel(t, i, currentnestedlevel);
              case cyclestack.Pop of
                1:
                begin
                  cyclenested.Pop; cyclewhiles.Pop;
                end;
                2:
                begin
                  cyclenested.Pop; cyclewhiles.Pop; cycleloops.Pop;
                end;
                3:
                begin
                  cyclenested.Pop; cycleforleft.Pop; cycleforright.Pop; cycleforstep.Pop; cycleforvariables.Pop;
                end;
              end;
              
            end else i := t.Operations.Length;
          end;
          
          DeclareVariable, AssignmentVariable, DeclareWithAssignment, DestructionVariable, AutotypeDeclare:
          begin
            DeclarationAndAssignment(t, t.Operations[i], currentnestedlevel);
            i += 1;
          end;
          
          GotoDefinition:
          begin
            if currentnestedlevel < 0 then raise new SemanticError('ONLY_DECLARATION_AND_ASSIGN', t.Source);
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
            var bool := GetConditionValue(t, t.Operations[i], 1);
            
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
          
          ForCycleOperator:
          begin
            currentnestedlevel += 1;
            var exitlevel := FindNextEndOnThisNestedLevel(t, i, currentnestedlevel);
            cyclelables += i;
            cycleforleft += GetIntegerValue(t, t.Operations[i], 3);
            AssignCycleVariable(t, currentnestedlevel, t.Operations[i].Strings[1], cycleforleft.Peek);
            cycleforvariables += t.Operations[i].Strings[1];
            cyclenested += word(currentnestedlevel);
            cyclestack += byte(3);
            cycleforright += GetIntegerValue(t, t.Operations[i], 5);
            if cycleforleft.Peek >= cycleforright.Peek then cycleforstep += -1 else cycleforstep += 1;
            
            i += 1;
          end;
          
          LoopCycleOperator:
          begin
            currentnestedlevel += 1;
            var exitlevel := FindNextEndOnThisNestedLevel(t, i, currentnestedlevel);
            var count := GetIntegerValue(t, t.Operations[i], 1);
            
            if count > 0 then
            begin
              cyclelables += i;
              cyclenested += word(currentnestedlevel);
              cyclestack += byte(2);
              cycleloops += count;
              i += 1;
            end
            else
            begin
              currentnestedlevel -= 1;
              i := exitlevel + 1;
            end;
          end;
          
          WhileOperator:
          begin
            currentnestedlevel += 1;
            var exitlevel := FindNextEndOnThisNestedLevel(t, i, currentnestedlevel);
            var bool := GetConditionValue(t, t.Operations[i], 1);
            
            if bool then
            begin
              cyclelables += i;
              cyclenested += word(currentnestedlevel);
              cyclestack += byte(1);
              cyclewhiles += t.Operations[i];
              i += 1;
            end else
            begin
              currentnestedlevel -= 1;
              i := exitlevel + 1;
            end;
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
                  write(t.Variables[vname].Value);
                end;
                Expression(var exp):
                begin
                  var expr := GetExpressionValue(t, t.Operations[i].Strings[1]);
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
                    writeln(t.Variables[vname].Value);
                  end;
                  Expression(var exp):
                  begin
                    var expr := GetExpressionValue(t, t.Operations[i].Strings[1]);
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
    
    public static procedure Compilesunko(fname: string);
    begin
      var t := ReadAllLines(fname);
      var tr := new Tree(t);
      var sw := new BinaryWriter(System.IO.File.Create(Path.ChangeExtension(fname, '.sunko')));
      TreeWriter.Write(sw, tr);
      sw.Close;
    end;
    
    public static function Runsunko(fname: string): integer;
    begin
      var sr := new BinaryReader(System.IO.File.OpenRead(fname));
      var tr := TreeReader.Read(sr);
      sr.Close;
      Tree.SyntaxVisitor(tr);
      Compile(tr);
      Result := -1;
    end;
  end;

end.