{$includenamespace Synonims.pas}
{$includenamespace KTXPixel.pas}
{$includenamespace KTXFile.pas}
library KTX;
uses System;

type
  Version = static class
    private static fversion := new System.Version(2, 0);
    
    public static property Version: System.Version read fversion;
  end;

function FunctionCall(funcname: string): object;
begin
  raise new NullReferenceException;
end;

function FunctionCall(funcname: string; param: array of (string, string)): object;
begin
  raise new NullReferenceException;
end;

end.