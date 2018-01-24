{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to define a execution error
  @created(08/04/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooExecution.Error;

interface

uses
  SysUtils,
  ooList.Filtrable,
  ooWork;

type
{$REGION 'documentation'}
{
  @abstract(Object to define a execution error)
  @member(DateTime Error date time)
  @member(Work Runnable work object)
  @member(Text Error message)
}
{$ENDREGION}
  IExecutionError = interface
    function DateTime: TDateTime;
    function Work: IWork;
    function Text: String;
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IExecutionError))
  @member(DateTime @seealso(IExecutionError.DateTime))
  @member(Work @seealso(IExecutionError.Work))
  @member(Text @seealso(IExecutionError.Text))
  @member(
    Create Object constructor
    @param(Work Runnable object)
    @param(Text Error message)
  )
  @member(
    New Create a new @classname as interface
    @param(Work Runnable object)
    @param(Text Error message)
  )
}
{$ENDREGION}

  TExecutionError = class sealed(TInterfacedObject, IExecutionError)
  strict private
    _DateTime: TDateTime;
    _Work: IWork;
    _Text: String;
  public
    function DateTime: TDateTime;
    function Work: IWork;
    function Text: String;
    constructor Create(const Work: IWork; const Text: String);
    class function New(const Work: IWork; const Text: String): IExecutionError;
  end;
{$REGION 'documentation'}
{
  @abstract(Object to define a execution error stack)
}
{$ENDREGION}

  IExecutionErrorStack = interface(IGenericListFiltrable<IExecutionError>)
    ['{C8F5D846-C3CE-416D-8E56-D10F2F6752BF}']
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IExecutionErrorStack))
}
{$ENDREGION}

  TExecutionErrorStack = class sealed(TListFiltrable<IExecutionError>, IExecutionErrorStack)
  public
    class function New: IExecutionErrorStack;
  end;

implementation

function TExecutionError.Work: IWork;
begin
  Result := _Work;
end;

function TExecutionError.Text: String;
begin
  Result := _Text;
end;

function TExecutionError.DateTime: TDateTime;
begin
  Result := _DateTime;
end;

constructor TExecutionError.Create(const Work: IWork; const Text: String);
begin
  _DateTime := Now;
  _Work := Work;
  _Text := Text;
end;

class function TExecutionError.New(const Work: IWork; const Text: String): IExecutionError;
begin
  Result := TExecutionError.Create(Work, Text);
end;

{ TExecutionErrorStack }

class function TExecutionErrorStack.New: IExecutionErrorStack;
begin
  Result := TExecutionErrorStack.Create(True);
end;

end.
