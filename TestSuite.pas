namespace Sunko;

type
  TestSuite = static class
    public static procedure Test;
    begin
      writeln('Start testing parser');
      var sss := '      !pcall $fname $fcall$ while   int #version x 28 0.4 22:03 ''тест test'' (2 * 3) =';
      var ptest0 := Parser.Parse(sss).WordTypes;
      //writeln(sss);
      //writeln(Parser.Parse(sss).Strings);
      //writeln(Parser.Parse(sss).WordTypes);
      var ptest1 := new WordType[](new ProcedureName, new FunctionName, new FunctionCall, new Keyword, new TypeName, new ConstantName, new VariableName, new IntegerLiteral, new RealLiteral, new DateLiteral, new StringLiteral, new Expression, new Splitter);
      for var i := 0 to ptest1.Length - 1 do
        if (ptest0 = nil) or (ptest0.Length < i) or (ptest0[i].GetType <> ptest1[i].GetType) then writeln($'Parser test is failed with {ptest1[i]}')
          else writeln($'Parser test with {ptest1[i]} is successfull');
      writeln('End testing parser');
    end;
  end;

end.