program Sunko;
uses System;
uses System.IO;
{$reference 'KTX.dll'}
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
{$includenamespace SyntaxVisitor.pas}
{$includenamespace TestSuite.pas}
{$includenamespace CompiledTree.pas}
{$includenamespace TreeReader.pas}
{$includenamespace TreeWriter.pas}
{$includenamespace Methods.pas}
{$includenamespace Compiler.pas}

var
  CompileNotRun := false;

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
  WritelnColor(ConsoleColor.Yellow, $'KTX  {KTX.Version.Version}');
  WritelnColor(ConsoleColor.Cyan, $'GC5A <not included>');
  WritelnColor(ConsoleColor.Magenta, 'Insert the command and press Enter!');
end;

function NonCommand(s: string): boolean := (not s.StartsWith('!')) and (s <> '.') and (s <> '/') and (s <> '\');

function ExecuteCommand(s: string): boolean;
begin
  Result := false;
  if s.ToLower = '!exit' then System.Environment.Exit(0);
  if s.ToLower = '!notrun' then
  begin
    Result := true;
    CompileNotRun := true;
  end;
end;

procedure Run(s: string);
begin
  try
    if not string.IsNullOrWhiteSpace(s) then
    if NonCommand(s) then
    begin
      var pth := Parser.GetString(s);
      var x := -1;
      if CompileNotRun then
      begin
        Compiler.CompileSunko(pth);
      end
      else
      begin
        if pth.EndsWith('.sunko') then x := Compiler.Runsunko(pth) else x := Compiler.Compile(pth);
      end;
      if x > 0 then writelncolor(ConsoleColor.Green, ErrorResources.GetErrorResourceString(false, 'SUCCESS_COMPILATION', System.IO.Path.GetFileName(pth), x.ToString))
      else writelncolor(ConsoleColor.Green, ErrorResources.GetErrorResourceString(false, 'SUCCESS_COMPILATION_SUNKO', System.IO.Path.GetFileName(pth)));
    end else 
    begin
      if not ExecuteCommand(s) then raise new System.NullReferenceException($'Command {s} not found');
    end;
  except
    {$ifndef EXTREMEDEBUG}
    on e: System.ArgumentException do WriteLnColor(ConsoleColor.Yellow, 'Compiler: Path contains invalid chars');
    on e: System.NullReferenceException do WritelnColor(ConsoleColor.Yellow, 'Compiler: Wrong command!');
    on e: System.IO.FileNotFoundException do WritelnColor(ConsoleColor.Yellow, $'Compiler: File "{s}" not found');
    on e: SemanticError do WritelnColor(ConsoleColor.Yellow, $'[{Path.GetFileName(s)}, {e.Source}]Error: {e.GetErrorMessage}');
    on e: SyntaxError do writelnColor(ConsoleColor.White, $'[{Path.GetFileName(s)}, {e.Source}]Error: {e.GetErrorMessage}');
    on e: SunkoError do writelnColor(ConsoleColor.Red, $'[{Path.GetFileName(s)}, {e.Source}]Undefined Compiler Error: {e.GetErrorMessage}');
    {$endif}
    on e: System.Exception do writelnColor(ConsoleColor.Red, $'Internal Compiler Error: {e}');
  end;
end;

begin
  Console.Title := 'Sunko Script';
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
    begin
      var sw := new BinaryWriter(System.IO.File.Create('All.sunko'));
      TreeWriter.Write(sw, ___x);
      sw.Close;
    end;
    WriteLogo;
    while true do
    begin
      var s := ReadlnString;
      Run(s);
    end;
  end;
end.