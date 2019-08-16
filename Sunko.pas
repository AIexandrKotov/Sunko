

program Sunko;
{$includenamespace SunkoError.pas}



{$includenamespace WordTypes\WordType.pas}
{$includenamespace WordTypes\Keyword.pas}
{$includenamespace WordTypes\ProcedureName.pas}
{$includenamespace WordTypes\FunctionCall.pas}
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
begin
  TestSuite.Test;
  var x := new Tree(ReadAllLines('All.snc'));
end.