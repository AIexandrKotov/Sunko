
program Sunko;
uses System;
{$resource 'ru.lng'}
{$resource 'en.lng'}

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

function NonCommand(s: string): boolean := (not s.StartsWith('!')) and (s <> '.') and (s <> '/') and (s <> '\');

function ExecuteCommand(s: string): boolean;
begin
  if s.ToLower = '!exit' then System.Environment.Exit(0);
  Result := false;
end;

procedure Run(s: string);
begin
  try
    if not string.IsNullOrWhiteSpace(s) then
    if NonCommand(s) then
    begin
      var x := Compiler.Compile(Parser.GetString(s));
      writelncolor(ConsoleColor.Green, ErrorResources.GetErrorResourceString(false, 'SUCCESS_COMPILATION', System.IO.Path.GetFileName(s), x.ToString));
    end else
    begin
      if not ExecuteCommand(s) then raise new System.NullReferenceException($'Command {s} not found');
    end;
  except
    on e: System.ArgumentException do WriteLnColor(ConsoleColor.Yellow, 'Compiler: Path contains invalid chars');
    on e: System.NullReferenceException do WritelnColor(ConsoleColor.Yellow, 'Compiler: Wrong command!');
    on e: System.IO.FileNotFoundException do WritelnColor(ConsoleColor.Yellow, $'Compiler: File "{s}" not found');
    on e: SemanticError do WritelnColor(ConsoleColor.Yellow, $'[{e.Source}]Error: {e.GetErrorMessage}');
    on e: SyntaxError do writelnColor(ConsoleColor.Yellow, $'[{e.Source}]Error: {e.GetErrorMessage}');
    on e: SunkoError do writelnColor(ConsoleColor.Red, $'[{e.Source}]Undefined Compiler Error: {e}');
    on e: System.Exception do writelnColor(ConsoleColor.Red, $'Internal Compiler Error: {e}');
  end;
end;

begin
  ErrorResources.Init;
  if (PABCSystem.CommandLineArgs <> nil) and (PABCSystem.CommandLineArgs.Length > 0) then
  begin
    foreach var cla in CommandLineArgs do Run(cla);
    writeln('Для выхода нажмите любую клавишу...');
    Console.ReadKey;
  end
  else
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
    ___x.ToString;
    WriteLogo;
    while true do
    begin
      var s := ReadlnString;
      Run(s);
    end;
  end;
end.