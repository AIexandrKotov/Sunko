namespace Sunko;

type
  Version = static class
    private static fversion := new System.Version(1, 0, 0, 22);
    
    public static property Version: System.Version read fversion;
  end;

end.