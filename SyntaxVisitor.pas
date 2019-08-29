namespace Sunko;

type
  SyntaxTreeVisitor = static class
    public static procedure deletevariables(var t: Tree; nlevel: integer);
    begin
      foreach var x in t.Variables.Keys.ToArray do
        if t.Variables[x].NestedLevel > nlevel then t.Variables.Remove(x);
    end;
    
    public static procedure visit(t: Tree);
    begin
      var currentnested := -1;
      var i := 0;
      
      while (i <= t.Operations.Length - 1) do
      begin
        t.CurrentOperation(i);
        case t.Operations[i].OperationType of
          ProcedureCall, GotoDefinition, LabelDefinition, ExitOperator: i += 1;
          SunkoOperator, RepeatOperator:
          begin
            currentnested += 1;
            i += 1;
          end;
          WhileOperator, ConditionOperator, LoopCycleOperator:
          begin
            currentnested += 1;
            if t.Operations[i].WordTypes[1] is VariableName then
            begin
              var vname := t.Operations[i].Strings[1];
              if not t.Variables.ContainsKey(vname) then raise new SyntaxError('VARIABLE_NOT_DECLARED', t.Source, vname);
            end;
            i += 1;
          end;
          EndOperator, UntilOperator:
          begin
            currentnested -= 1;
            deletevariables(t, currentnested);
            i += 1;
          end;
          DeclareVariable:
          begin
            var typ := t.Operations[i].Strings[0];
            var vname := t.Operations[i].Strings[1];
            if t.Variables.ContainsKey(vname) then raise new SyntaxError('VARIABLE_ALREADY_DECLARED', t.Source, vname);
            t.Variables.Add(vname, new SunkoVariable(Compiler.GetDefaultValue(typ), typ, currentnested));
            i += 1;
          end;
          AssignmentVariable:
          begin
            var vname := t.Operations[i].Strings[0];
            if not t.Variables.ContainsKey(vname) then raise new SyntaxError('VARIABLE_NOT_DECLARED', t.Source, vname);
            i += 1;
          end;
          ForCycleOperator:
          begin
            currentnested += 1;
            var vname := t.Operations[i].Strings[1];
            if t.Variables.ContainsKey(vname) then raise new SyntaxError('VARIABLE_ALREADY_DECLARED', t.Source, vname);
            t.Variables.Add(vname, new SunkoVariable(0, 'int', currentnested));
            i += 1;
          end;
          DeclareWithAssignment:
          begin
            var typ := t.Operations[i].Strings[0];
            var vname := t.Operations[i].Strings[1];
            if t.Variables.ContainsKey(vname) then raise new SyntaxError('VARIABLE_ALREADY_DECLARED', t.Source, vname);
            match t.Operations[i].WordTypes[3] with
              VariableName(var xx):
              begin
                var vname2 := t.Operations[i].Strings[3];
                if t.Variables.ContainsKey(vname2) then
                begin
                  if typ <> t.Variables[vname2].SunkoType then raise new SyntaxError('CANNOT_CONVERT_TYPES', t.Source, t.Variables[vname2].SunkoType, typ);
                end
                else raise new SyntaxError('VARIABLE_NOT_DECLARED', t.Source, vname2);
              end;
            end;
            t.Variables.Add(vname, new SunkoVariable(Compiler.GetDefaultValue(typ), typ, currentnested));
            i += 1;
          end;
          DestructionVariable:
          begin
            var vname := t.Operations[i].Strings[1];
            if t.Variables.ContainsKey(vname) then t.Variables.Remove(vname) else raise new SyntaxError('DESTRUCTION_NONDECLARED_VARIABLE', t.Source, vname);
            i += 1;
          end;
          else i += 1;
        end;
      end;
    end;
  end;

end.