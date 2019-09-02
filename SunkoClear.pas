program Sunko;
uses System;
uses System.IO;
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
{$includenamespace Compiler.pas}
{$includenamespace CompiledTree.pas}
{$includenamespace TreeReader.pas}
{$includenamespace TreeWriter.pas}
{$includenamespace Methods.pas}

var
  CompileNotRun := false;
  
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
      Compiler.CompileSunko(Parser.GetString(s));
    end else
    begin
      ExecuteCommand(s);
    end;
  finally
    
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
  else exit;
end.