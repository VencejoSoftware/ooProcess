{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Interface to define a work definition object
  @created(08/04/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooWork;

interface

type
{$REGION 'documentation'}
{
  @abstract(Interface to define a work object)
  @member(Code Work code)
  @member(Description Work description)
}
{$ENDREGION}
  IWork = interface
    ['{4409AC2D-DC89-447A-B5E6-F08997AFDE6C}']
    function Code: String;
    function Description: String;
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IWork))
  @member(Code @seealso(IWork.Code));
  @member(Description @seealso(IWork.Description));
  @member(
    Create Object constructor
    @param(Code Code to identify the work)
    @param(Description work description)
  )
  @member(
    New Create a new @classname as interface
    @param(Code Code to identify the work)
    @param(Description Work description)
  )
}
{$ENDREGION}

  TWork = class sealed(TInterfacedObject, IWork)
  strict private
    _Code, _Description: String;
  public
    function Code: String;
    function Description: String;
    constructor Create(const Code, Description: String);
    class function New(const Code, Description: String): IWork;
  end;

implementation

function TWork.Code: String;
begin
  Result := _Code;
end;

function TWork.Description: String;
begin
  Result := _Description;
end;

constructor TWork.Create(const Code, Description: String);
begin
  _Code := Code;
  _Description := Description;
end;

class function TWork.New(const Code, Description: String): IWork;
begin
  Result := TWork.Create(Code, Description);
end;

end.
