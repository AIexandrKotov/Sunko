
program Sunko;
uses System;
{$includenamespace Version.pas}
{$includenamespace SunkoError.pas}

{$includenamespace WordTypes\WordType.pas}
{$includenamespace WordTypes\Keyword.pas}
{$includenamespace WordTypes\ProcedureName.pas}
{$includenamespace WordTypes\FunctionCall.pas}
{$includenamespace WordTypes\LibraryName.pas}
{$includenamespace WordTypes\ConstantName.pas}
{$includenamespace WordTypes\VariableName.pas}
{$includenamespace WordTypes\TypeName.pas}
{$includenamespace WordTypes\IntegerLiteral.pas}
{$includenamespace WordTypes\RealLiteral.pas}
{$includenamespace WordTypes\StringLiteral.pas}
{$includenamespace WordTypes\DateLiteral.pas}
{$includenamespace WordTypes\Expression.pas}
{$includenamespace WordTypes\Splitter.pas}

{$includenamespace Operation.pas}
{$includenamespace Parser.pas}
{$includenamespace SunkoVariable.pas}
{$includenamespace Tree.pas}
{$includenamespace TestSuite.pas}
{$includenamespace Compiler.pas}

procedure WriteColor<T>(c: ConsoleColor; s: T);
begin
  var x: ConsoleColor := Console.ForegroundColor;
  Console.ForegroundColor := c;
  write(s);
  Console.ForegroundColor := x;
end;

procedure WriteColor(c: ConsoleColor; params o: array of object);
begin
  var x: ConsoleColor := Console.ForegroundColor;
  Console.ForegroundColor := c;
  foreach var ob in o do write(ob.ToString);
  Console.ForegroundColor := x;
end;

procedure WritelnColor<T>(c: ConsoleColor; s: T);
begin
  var x: ConsoleColor := Console.ForegroundColor;
  Console.ForegroundColor := c;
  writeln(s);
  Console.ForegroundColor := x;
end;

procedure WritelnColor(c: ConsoleColor; params o: array of object);
begin
  var x: ConsoleColor := Console.ForegroundColor;
  Console.ForegroundColor := c;
  foreach var ob in o do write(ob.ToString);
  writeln;
  Console.ForegroundColor := x;
end;

procedure WriteLogo;
begin
  WritelnColor(ConsoleColor.Green, $'Sunko {Version.Version}');
  WritelnColor(ConsoleColor.Yellow, $'KTX  <not included>');
  WritelnColor(ConsoleColor.Cyan, $'GC5A <not included>');
  WritelnColor(ConsoleColor.Magenta, 'Insert the command and press Enter!');
end;

begin
  if TestSuite.Test then writeln(TestSuite.Stack.JoinIntoString(newline))
  else
  begin
    {$ifdef DEBUG}
      Tree.fAllsnc := true;
      writeln(TestSuite.Stack.JoinIntoString(newline))
    {$endif}
  end;
  var ___x := new Tree(ReadAllLines('All.snc'));
  WriteLogo;
  while true do
  begin
    var s := ReadlnString;
    var x := new Tree(ReadAllLines(s));
  end;
end.