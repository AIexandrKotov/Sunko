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
      if t.Variables[varname].SunkoType <> littypestr then raise new SemanticError($'Cannot convert {littypestr} to {t.Variables[varname].SunkoType}', t.Source);
      t.Variables[varname].Value := GetLiteralValue(literaltype, literal);
    end;
    
    public static procedure Compile(t: Tree);
    begin
      var currentnestedlevel := -1;
      var i := 0;
      while i < t.Operations.Length - 1 do
      begin
        t.CurrentOperation(i);
        case t.Operations[i].OperationType of
          
          SunkoOperator:
          begin
            currentnestedlevel += 1;
            i += 1;
          end;
          
          DeclareVariable:
          begin
            var typename := t.Operations[i].Strings[0];
            var vname := t.Operations[i].Strings[1];
            
            if t.Variables.ContainsKey(vname) then raise new SemanticError($'The variable {vname} is already declared', t.Source);
            
            DeclarationDefinition(t, vname, typename, currentnestedlevel);
            i += 1;
          end;
          
          AssignmentVariable:
          begin
            var vname := t.Operations[i].Strings[0];
            if not t.Variables.ContainsKey(vname) then raise new SemanticError($'The variable ''{vname}'' is not declared', t.Source);
            if Isliteral(t.Operations[i].WordTypes[2]) then
            begin
              AssignmentDefinitionLiteral(t, vname, t.Operations[i].Strings[2], t.Operations[i].WordTypes[2]);
            end
            else
            match t.Operations[i].WordTypes[2] with
              VariableName(var rightvar):
              begin
                var vname2 := t.Operations[i].Strings[2];
                if not t.Variables.ContainsKey(vname2) then raise new SemanticError($'The variable ''{vname2}'' was not found', t.Source);
                var type1 := GetObjectType(t.Variables[vname2].Value);
                var type2 := GetObjectType(t.Variables[vname2].Value);
                if type1 <> type2 then raise new SemanticError($'Cannot convert {type1} to {type2}', t.Source);
                AssignmentDefinitionValue(t, vname, t.Variables[vname2].Value);
              end;
              Expression(var exp):
              begin
                var expr := GetExpressionValue(t, IncludeVariablesIntoExpression(t, t.Operations[i].Strings[2]));
                var exprtype := GetObjectType(expr);
                if exprtype = 'bool' then
                begin
                  expr := object(integer(boolean(expr) ? 1 : 0));
                  exprtype := 'int';
                end;
                if exprtype <> t.Variables[vname].SunkoType then raise new SemanticError($'Cannot convert {exprtype} to {t.Variables[vname].SunkoType}', t.Source);
                AssignmentDefinitionValue(t, vname, expr);
              end;
            end;
            
            i += 1;
          end;
          
          DeclareWithAssignment:
          begin
            var vtype := t.Operations[i].Strings[0];
            var vname := t.Operations[i].Strings[1];
            
            if t.Variables.ContainsKey(vname) then raise new SemanticError($'The variable {vname} is already declared', t.Source);
            
            if Isliteral(t.Operations[i].WordTypes[3]) then
            begin
              DeclarationDefinition(t, vname, vtype, currentnestedlevel);
              AssignmentDefinitionLiteral(t, vname, t.Operations[i].Strings[3], t.Operations[i].WordTypes[3]);
            end
            else
            match t.Operations[i].WordTypes[3] with
              VariableName(var rightvar):
              begin
                DeclarationDefinition(t, vname, vtype, currentnestedlevel);
                var vname2 := t.Operations[i].Strings[3];
                if not t.Variables.ContainsKey(vname2) then raise new SemanticError($'The variable ''{vname2}'' was not found', t.Source);
                var type1 := GetObjectType(t.Variables[vname2].Value);
                var type2 := GetObjectType(t.Variables[vname2].Value);
                if type1 <> type2 then raise new SemanticError($'Cannot convert {type1} to {type2}', t.Source);
                AssignmentDefinitionValue(t, vname, t.Variables[vname2].Value);
              end;
              Expression(var exp):
              begin
                DeclarationDefinition(t, vname, vtype, currentnestedlevel);
                var expr := GetExpressionValue(t, IncludeVariablesIntoExpression(t, t.Operations[i].Strings[3]));
                var exprtype := GetObjectType(expr);
                if exprtype = 'bool' then
                begin
                  expr := object(integer(boolean(expr) ? 1 : 0));
                  exprtype := 'int';
                end;
                if exprtype <> t.Variables[vname].SunkoType then raise new SemanticError($'Cannot convert {exprtype} to {vtype}', t.Source);
                AssignmentDefinitionValue(t, vname, expr);
              end;
              else raise new SemanticError('This construct is not supported by the current compiler version', t.Source);
            end;
            
            i += 1;
          end;
          
          else i += 1;
        end;
      end;
    end;
    
    public static procedure Compile(fname: string) := Compile(new Tree(ReadAllLines(fname)));
  end;

end.