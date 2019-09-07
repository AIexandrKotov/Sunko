# Sunko
Isekai Quartet! KTX, GC5A and KotovScript!! (hehe, not quartet)

# Syntax

### Blocks

```
sunko
  //...
end
```

### Commentaries

```
  //one line
  
  //multilinescommentaries not allowed!
```

### Variables

#### Declaring

```
<typename> <variablename>
<typename> <variablename> = <statement>
```

```
int x
string s = 'abc'
```

#### Types: int, real, string, date

Variables can be declared outside the block

#### Assignment
```
  <variablename> = <statement>
```

```
  int x
  x = 100
```

### Condition operator
```
sunko
  if <statement> then
  
  else //not obligatory
  
  end
end
```
```
sunko
  int x = (2 * 2)
  if (x = 5) then
    !writeln '2 * 2 = 5'
  else
    !writeln '2 * 2 = 4'
  end
end
```

### Labels
#### !! Labels may be unstable
```
sunko
  label 100 //supports only integers
  !write 1
  goto 100
end
```

### Cycles
#### Cycle for
```
  for <variablename> = <low> to <high> do
    //...
  end
```
```
  for i = 1 to 10 do
    !writeln i
  end
```

#### Cycle while
```
  while <statement> do
    //...
  end
```
```
  int x = 1
  while (x <= 10) do
    !writeln x
    x = (x + 1)
  end
```

#### Cycle loop
```
  loop <int> do
    //...
  end
```
```
  int x = 1
  loop 10 do
    !writeln x
    x = (x + 1)
  end
```

### Functions
#### Custom function not supported
```
  {<funcname> <arguments>}
```
```
  int x = {RealToInt 13.37}
  real y = {Random}
  string s = {GetType {RealToInt 0.25}}
```

## Samples
#### Multiple table (while cycles)
```
sunko
  int i = 1
  while (i < 10) do
    int j = 1
    while (j < 10) do
      !write i*j
      !write ' '
      j = j+1
    end
    i = i+1
    !writeln
  end
  !stopkey
end
```
#### Multiple table (for cycles)
```
sunko
  for i = 1 to 9 do
    for j = 1 to 9 do
      !write (i*j)
      !write ' '
    end
    !writeln
  end
  !stopkey
end
```
