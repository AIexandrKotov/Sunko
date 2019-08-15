namespace Sunko;

type
  ///Типы слов
  WordType = abstract class
    public function ToString: string; override;
    begin
      Result := self.GetType.Name;
    end;
  end;
  
  {WordType = (
    ///Разделитель
    ///Примером разделителя является =
    Splitter
  );}

end.