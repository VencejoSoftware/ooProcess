{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to define a execution status
  @created(08/04/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooExecution.Status;

interface

type
{$REGION 'documentation'}
{
  Execution status code enum
  @value Stopped Execution is finished
  @value Success Execution successed
  @value Notifying Excution notificates something
  @value Warning Reports an anomaly to check
  @value Fail Execution failed
  @value Running Execution is currently running
}
{$ENDREGION}
  TExecutionStatusCode = (Stopped, Success, Notifying, Warning, Fail, Running);
{$REGION 'documentation'}
{
  @abstract(Object to define a execution status)
  Generic way to return status of any execution
  @member(
    Code Code of status
    @returns(Code of status)
  )
  @member(
    Text Status text
    @returns(String with status text)
  )
}
{$ENDREGION}

  IExecutionStatus = interface
    ['{ACCF136F-CA01-4F17-9D6D-DC0130E04C7C}']
    function Code: TExecutionStatusCode;
    function Text: String;
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IExecutionStatus))
  @member(Code @seealso(IExecutionStatus.Code))
  @member(Text @seealso(IExecutionStatus.Text))
  @member(
    Create Object constructor
    @param(Code Status code)
    @param(Text Status text)
  )
  @member(
    New Create a new @classname as interface
    @param(Code Status code)
    @param(Text Status text)
  )
}
{$ENDREGION}

  TExecutionStatus = class sealed(TInterfacedObject, IExecutionStatus)
  strict private
    _Code: TExecutionStatusCode;
    _Text: String;
  public
    function Code: TExecutionStatusCode;
    function Text: String;
    constructor Create(const Code: TExecutionStatusCode; const Text: String);
    class function New(const Code: TExecutionStatusCode; const Text: String): IExecutionStatus;
  end;

implementation

function TExecutionStatus.Code: TExecutionStatusCode;
begin
  Result := _Code;
end;

function TExecutionStatus.Text: String;
begin
  Result := _Text;
end;

constructor TExecutionStatus.Create(const Code: TExecutionStatusCode; const Text: String);
begin
  _Code := Code;
  _Text := Text;
end;

class function TExecutionStatus.New(const Code: TExecutionStatusCode; const Text: String): IExecutionStatus;
begin
  Result := TExecutionStatus.Create(Code, Text);
end;

end.

