namespace WordType;

type
  ///Типы слов
  WordType = (
    ///Ключевое слово
    Keyword,
    ///Имя процедуры
    ProcedureName,
    ///Имя функции
    FunctionName,
    ///Вызов функции
    FunctionCall,
    ///Имя константы
    ConstantName,
    ///Имя переменной
    VariableName,
    ///Имя типа
    TypeName,
    ///Целочиселнная константа
    IntegerLiteral,
    ///Строковая константа
    StringLiteral,
    ///Вещественная константа
    RealLiteral,
    ///Временная константа
    DateLiteral,
    ///Выражение
    Expression,
    ///Разделитель
    ///Примером разделителя является =
    Splitter
  );

end.