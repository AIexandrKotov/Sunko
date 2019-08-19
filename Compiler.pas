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
            Sunko.FunctionCall(var fcall):
            begin
              var ofunc := FunctionCall(t, o.Strings[2]);
              var otype := GetObjectType(ofunc);
              if otype = 'bool' then
              begin
                ofunc := object(integer(boolean(ofunc) ? 1 : 0));
                otype := 'int';
              end;
              if otype <> t.Variables[vname].SunkoType then raise new SemanticError('CANNOT_CONVERT_TYPES', t.Source, otype, t.Variables[vname].SunkoType);
              AssignmentDefinitionValue(t, vname, ofunc);
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
            Sunko.FunctionCall(var fcall):
            begin
              DeclarationDefinition(t, vname, vtype, nested);
              var ofunc := FunctionCall(t, o.Strings[3]);
              var otype := GetObjectType(ofunc);
              if otype = 'bool' then
              begin
                ofunc := object(integer(boolean(ofunc) ? 1 : 0));
                otype := 'int';
              end;
              if otype <> t.Variables[vname].SunkoType then raise new SemanticError('CANNOT_CONVERT_TYPES', t.Source, otype, t.Variables[vname].SunkoType);
              AssignmentDefinitionValue(t, vname, ofunc);
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
    
    public static function GetWordType(wt: WordType): string;
    begin
      Result := wt.ToString;
    end;
    
    public static function GetFunc0(var t: Tree; funcname: string): object;
    begin
      funcname := funcname.ToLower;
      if funcname.StartsWith('ktx.') then
      begin
        raise new SemanticError('NOT_INCLUDED', t.Source, 'KTX');
      end
      else if funcname.StartsWith('gc5a.') then
      begin
        raise new SemanticError('NOT_INCLUDED', t.Source, 'GC5A');
      end
      else
      begin
        case funcname of
          'sunkoversion': Result := $'Sunko {Version.Version}';
          'currenttime': Result := DateTime.Now;
          'random': Result := PABCSystem.Random;
        else raise new SemanticError('FUNCTION_NOT_FOUND', t.Source, funcname);
        end
      end;
    end;
    
    public static function GetFunc(var t: Tree; funcname: string; param: array of System.Tuple<string, string>): object;
    begin
      funcname := funcname.ToLower;
      if funcname.StartsWith('ktx.') then
      begin
        raise new SemanticError('NOT_INCLUDED', t.Source, 'KTX');
      end
      else if funcname.StartsWith('gc5a.') then
      begin
        raise new SemanticError('NOT_INCLUDED', t.Source, 'GC5A');
      end
      else
      begin
        case funcname of
          'gettype':
          begin
            if param.Length > 1 then raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
            Result := param[0].Item1;
            exit;
          end;
          'int64toint':
          begin
            if (param.Length = 1) and (param[0].Item1 = 'int64') then
            begin
              var out: integer;
              if not integer.TryParse(param[0].Item2, out) then out := integer.MaxValue;
              Result := out;
              exit;
            end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          'inttoreal':
          begin
            if (param.Length = 1) and (param[0].Item1 = 'int') then
            begin
              Result := real(param[0].Item2.ToInteger);
              exit;
            end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          ///
          ///Стандартные функции
          ///
          'degtorad':
          begin
            if (param.Length = 1) and ((param[0].Item1 = 'int') or (param[0].Item1 = 'real')) then
            begin
              Result := DegToRad(param[0].Item2.ToReal);
            end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          'radtodeg':
          begin
            if (param.Length = 1) and ((param[0].Item1 = 'int') or (param[0].Item1 = 'real')) then
            begin
              Result := RadToDeg(param[0].Item2.ToReal);
            end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          'abs':
          begin
            if (param.Length = 1) then
            begin
              if (param[0].Item1 = 'int') then
              begin
                Result := System.Math.Abs(param[0].Item2.ToInteger);
                exit;
              end else if (param[0].Item1 = 'real') then
              begin
                Result := System.Math.Abs(param[0].Item2.ToReal);
                exit;
              end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
            end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          'arctan':
          begin
            if (param.Length = 1) then
            begin
              if (param[0].Item1 = 'int') then
              begin
                Result := System.Math.Atan(param[0].Item2.ToInteger);
                exit;
              end else if (param[0].Item1 = 'real') then
              begin
                Result := System.Math.Atan(param[0].Item2.ToReal);
                exit;
              end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
            end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          'arcsin':
          begin
            if (param.Length = 1) then
            begin
              if (param[0].Item1 = 'int') then
              begin
                Result := System.Math.Asin(param[0].Item2.ToInteger);
                exit;
              end else if (param[0].Item1 = 'real') then
              begin
                Result := System.Math.Asin(param[0].Item2.ToReal);
                exit;
              end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
            end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          'arccos':
          begin
            if (param.Length = 1) then
            begin
              if (param[0].Item1 = 'int') then
              begin
                Result := System.Math.Acos(param[0].Item2.ToInteger);
                exit;
              end else if (param[0].Item1 = 'real') then
              begin
                Result := System.Math.Acos(param[0].Item2.ToReal);
                exit;
              end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
            end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          'cos':
          begin
            if (param.Length = 1) and ((param[0].Item1 = 'int') or (param[0].Item1 = 'real')) then
            begin
              Result := System.Math.Cos(param[0].Item2.ToReal);
              exit;
            end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          'exp':
          begin
            if (param.Length = 1) then
            begin
              if (param[0].Item1 = 'int') then
              begin
                Result := System.Math.Exp(param[0].Item2.ToInteger);
                exit;
              end else if (param[0].Item1 = 'real') then
              begin
                Result := System.Math.Exp(param[0].Item2.ToReal);
                exit;
              end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
            end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          'frac':
          begin
            if (param.Length = 1) and (param[0].Item1 = 'real') then
            begin
              Result := PABCSystem.Frac(param[0].Item2.ToReal);
              exit;
            end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          'int':
          begin
            if (param.Length = 1) then
            begin
              if (param[0].Item1 = 'int') then
              begin
                Result := PABCSystem.Int(param[0].Item2.ToInteger);
                exit;
              end else if (param[0].Item1 = 'real') then
              begin
                Result := PABCSystem.Int(param[0].Item2.ToReal);
                exit;
              end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
            end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          'ln':
          begin
            if (param.Length = 1) and (((param[0].Item1 = 'int') or (param[0].Item1 = 'real'))) then
            begin
              Result := System.Math.Log(param[0].Item2.ToReal);
              exit;
            end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          'log':
          begin
            if (param.Length = 2) and ((param[0].Item1 = 'int') or (param[0].Item1 = 'real')) and ((param[1].Item1 = 'int') or (param[1].Item1 = 'real')) then
            begin
              Result := System.Math.Log((param[0].Item2.ToReal), (param[1].Item2.ToReal));
              exit;
            end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          'log10':
          begin
            if (param.Length = 1) and ((param[0].Item1 = 'int') or (param[0].Item1 = 'real')) then
            begin
              Result := System.Math.Log10(param[0].Item2.ToReal);
              exit;
            end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          'sin':
          begin
            if (param.Length = 1) and ((param[0].Item1 = 'int') or (param[0].Item1 = 'real')) then
            begin
              Result := System.Math.Sin(param[0].Item2.ToReal);
              exit;
            end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          'sqr':
          begin
            if (param.Length = 1) then
            begin
              if (param[0].Item1 = 'int') then
              begin
                Result := param[0].Item2.ToInteger**2;
                exit;
              end else if (param[0].Item1 = 'real') then
              begin
                Result := param[0].Item2.ToReal**2;
                exit;
              end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
            end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          'sqrt':
          begin
            if (param.Length = 1) then
            begin
              if (param[0].Item1 = 'int') then
              begin
                Result := Sqrt(param[0].Item2.ToInteger);
                exit;
              end else if (param[0].Item1 = 'real') then
              begin
                Result := Sqrt(param[0].Item2.ToReal);
                exit;
              end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
            end else if (param.Length = 2) and ((param[0].Item1 = 'int') or (param[0].Item1 = 'real')) and ((param[1].Item1 = 'int') or (param[1].Item1 = 'real')) then
            begin
              if (param[0].Item1 = 'int') and (param[1].Item1 = 'int') then
              begin
                Result := param[0].Item2.ToInteger**(1/param[0].Item2.ToInteger);
                exit;
              end else if (param[0].Item1 = 'real') and (param[0].Item2 = 'real') then
              begin
                Result := param[0].Item2.ToReal**(1/param[0].Item2.ToReal);
                exit;
              end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
            end
            else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          'random':
          begin
            if (param.Length = 1) then
            begin
              if param[0].Item1 = 'int' then
              begin
                Result := PABCSystem.Random(param[0].Item2.ToInteger);
                exit;
              end
              else if param[0].Item1 = 'real' then
              begin
                Result := PABCSystem.Random*param[0].Item2.ToReal;
              end;
            end
            else if (param.Length = 2) then
            begin
              if (param[0].Item1 = 'int') and (param[1].Item1 = 'int') then
              begin
                Result := PABCSystem.Random(param[0].Item2.ToInteger, param[0].Item2.ToInteger);
                exit;
              end
              else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
            end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          'round':
          begin
            if (param.Length = 1) and (param[0].Item1 = 'real') then
            begin
              Result := Round(param[0].Item2.ToReal);
              exit;
            end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          'trunc':
          begin
            if (param.Length = 1) and (param[0].Item1 = 'real') then
            begin
              Result := Trunc(param[0].Item2.ToReal);
              exit;
            end else raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          end;
          'array':
          begin
            var rslt := new Object[param.Length];
            for var i := 0 to param.Length - 1 do
            begin
              if param[i].Item1 <> param[0].Item1 then raise new SemanticError('ARRAY_MUST_CONTAINS_SIMILAR_TYPES', t.Source);
              if param[0].Item1.EndsWith('[]') then raise new SemanticError('MULTI_ARRAYS', t.Source);
              case param[0].Item1 of
                'int64': rslt[i] := int64.Parse(param[i].Item2);
                'date': rslt[i] := DateTime.Parse(param[i].Item2);
                'int': rslt[i] := param[i].Item2.ToInteger;
                'string': rslt[i] := param[i].Item2;
                'real': rslt[i] := param[i].Item2.ToReal;
              end;
            end;
            case param[0].Item1 of
              'int64': Result := rslt.ConvertAll(x -> int64(x));
              'int': Result := rslt.ConvertAll(x -> integer(x));
              'date': Result := rslt.ConvertAll(x -> DateTime(x));
              'real': Result := rslt.ConvertAll(x -> real(x));
              'string': Result := rslt.ConvertAll(x -> string(x));
            end;
          end;
        else
          begin
            raise new SemanticError('FUNCTION_NOT_FOUND', t.Source);
          end;
        end
      end;
    end;
    
    public static function FunctionCall(var t: Tree; func: string): object;
    begin
      func := Parser.GetFunction(func);
      if string.IsNullOrWhiteSpace(func) then raise new SemanticError('EMPTY_FUNCTION_CALL', t.Source);
      var xtf := func.Split(' ');
      var funcname := xtf[0];
      var param := xtf.Length > 1 ? xtf[1:xtf.Length].JoinIntoString(' ') : '';
      if string.IsNullOrEmpty(param) then
      begin
        Result := GetFunc0(t, funcname);
      end
      else
      begin
        var ParsedParam := Parser.Parse(param, true, t.Source);
        //(type, string)
        var ParsedParams := new List<System.Tuple<string, string>>;
        for var i := 0 to ParsedParam.WordTypes.Length - 1 do
        begin
          if ParsedParam.WordTypes[i] is Sunko.FunctionCall then
          begin
            var fc := FunctionCall(t, Parser.GetFunction(ParsedParam.Strings[i]));
            ParsedParams.Add((GetObjectType(fc), fc.ToString));
          end
          else if ParsedParam.WordTypes[i] is Expression then
          begin
            var expr := GetExpressionValue(t, IncludeVariablesIntoExpression(t, ParsedParam.Strings[i]));
            ParsedParams.Add((GetObjectType(expr), expr.ToString));
          end
          else if ParsedParam.WordTypes[i] is VariableName then
          begin
            var vname := ParsedParam.Strings[i];
            if not t.Variables.ContainsKey(vname) then raise new SemanticError('VARIABLE_NOT_DECLARED', t.Source, vname);
            ParsedParams.Add((GetObjectType(t.Variables[vname].Value), t.Variables[vname].Value.ToString));
          end
          else if Isliteral(ParsedParam.WordTypes[i]) then
          begin
            ParsedParams.Add((GetLiteralType(ParsedParam.WordTypes[i]), GetLiteralValue(ParsedParam.WordTypes[i], ParsedParam.Strings[i]).ToString));
          end
          else raise new SemanticError('FUNCTION_NOT_SUPPORTED', t.Source, ParsedParam.WordTypes[i].ToString);
        end;
        try
          Result := GetFunc(t, funcname, ParsedParams.ToArray);
        except
          on e: System.NullReferenceException do raise new SemanticError('FUNCTION_NOT_FOUND', t.Source, funcname);
          on e: System.ArgumentException do raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
        end;
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
              Sunko.FunctionCall(var fcall):
              begin
                var fv := FunctionCall(t, t.Operations[i].Strings[1]);
                var ft := GetObjectType(fv);
                if ft = 'bool' then
                begin
                  bool := boolean(fv);
                end
                else if ft = 'int' then
                begin
                  bool := integer(fv) <> 0;
                end
                else raise new SemanticError($'CANNOT_CONVERT_TYPES', t.Source, ft, 'int');
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
                  write(t.Variables[vname].Value);
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
                    writeln(t.Variables[vname].Value);
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