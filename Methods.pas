namespace Sunko;

type
  Methods = static class
    public static function GetFunc0(var t: Tree; funcname: string): object;
    begin
      funcname := funcname.ToLower;
      if funcname.StartsWith('ktx.') then
      begin
        try
          Result := KTX.KTX.FunctionCall(funcname);
        except
          on e: NullReferenceException do raise new SemanticError('FUNCTION_NOT_FOUND', t.Source, funcname);
        end;
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
        try
          Result := KTX.KTX.FunctionCall(funcname, param);
        except
          on e: ArgumentException do raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
          on e: NullReferenceException do raise new SemanticError('FUNCTION_NOT_FOUND', t.Source, funcname);
        end;
      end
      else if funcname.StartsWith('gc5a.') then
      begin
        raise new SemanticError('NOT_INCLUDED', t.Source, 'GC5A');
      end
      else
      begin
        case funcname of
          'equals':
          begin
            if param.Length <> 2 then raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
            if param[0].Item1 <> param[1].Item1 then raise new SemanticError('FUNCTION_WRONG_ARGUMENTS', t.Source, funcname);
            case param[0].Item1 of
              'int': Result := (param[0].Item2.ToInteger = param[1].Item2.ToInteger) ? 1 : 0;
              'string': Result := (param[0].Item2 = param[1].Item2) ? 1 : 0;
              'date': Result := (DateTime.Parse(param[0].Item2).Ticks = DateTime.Parse(param[1].Item2).Ticks) ? 1 : 0;
              'real': Result := (param[0].Item2.ToReal = param[1].Item2.ToReal) ? 1 : 0;
            end;
          end;
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
                exit;
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
            exit;
          end;
        else
          begin
            raise new SemanticError('FUNCTION_NOT_FOUND', t.Source, funcname);
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
            ParsedParams.Add((Compiler.GetObjectType(fc), fc.ToString));
          end
          else if ParsedParam.WordTypes[i] is Expression then
          begin
            var expr := Compiler.GetExpressionValue(t, ParsedParam.Strings[i]);
            ParsedParams.Add((Compiler.GetObjectType(expr), expr.ToString));
          end
          else if ParsedParam.WordTypes[i] is VariableName then
          begin
            var vname := ParsedParam.Strings[i];
            if not t.Variables.ContainsKey(vname) then raise new SemanticError('VARIABLE_NOT_DECLARED', t.Source, vname);
            ParsedParams.Add((Compiler.GetObjectType(t.Variables[vname].Value), t.Variables[vname].Value.ToString));
          end
          else if Compiler.Isliteral(ParsedParam.WordTypes[i]) then
          begin
            ParsedParams.Add((Compiler.GetLiteralType(ParsedParam.WordTypes[i]), Compiler.GetLiteralValue(ParsedParam.WordTypes[i], ParsedParam.Strings[i]).ToString));
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
  end;

end.