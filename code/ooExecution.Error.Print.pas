{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to print to text a execution error
  @created(08/04/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooExecution.Error.Print;

interface

uses
  SysUtils,
  ooExecution.Error;

type
{$REGION 'documentation'}
{
  @abstract(Object to print a error object to plain text)
  @member(
    ToText Transform error object to string
    @param(Error Error object)
    @return(Text with plain error data representation)
  )
}
{$ENDREGION}
  IExecutionErrorOutput = interface
    ['{28F1A7AF-6FEE-411D-A07C-91AB48DEE94C}']
    function ToText(const Error: IExecutionError): String;
  end;
{$REGION 'documentation'}
{
  @abstract(Object to ToText a error object stack to plain text)
  @member(
    ToText Transform all error object in list to string
    @param(ErrorStack Error stack object)
    @return(Text with plain error data stack representation)
  )
}
{$ENDREGION}

  IExecutionErrorStackOutput = interface
    ['{437DD280-2758-4057-A894-2AF33EB206C5}']
    function ToText(const ErrorStack: IExecutionErrorStack): String;
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IExecutionErrorStackOutput))
  @member(ToText @seealso(IExecutionErrorStackOutput.ToText))
  @member(
    Create Object constructor
    @param(ErrorStack Error stack object)
  )
  @member(
    New Create a new @classname as interface
    @param(ErrorStack Error stack object)
  )
}
{$ENDREGION}

  TExecutionErrorStackOutput = class sealed(TInterfacedObject, IExecutionErrorStackOutput)
  strict private
    _ErrorOutput: IExecutionErrorOutput;
  public
    function ToText(const ErrorStack: IExecutionErrorStack): String;
    constructor Create(const ErrorOutput: IExecutionErrorOutput);
    class function New(const ErrorOutput: IExecutionErrorOutput): IExecutionErrorStackOutput;
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IExecutionErrorOutput))
  @member(ToText @seealso(IExecutionErrorOutput.ToText))
  @member(New Create a new @classname as interface)
}
{$ENDREGION}

  TExecutionErrorOutputText = class sealed(TInterfacedObject, IExecutionErrorOutput)
  public
    function ToText(const Error: IExecutionError): String;
    class function New: IExecutionErrorOutput;
  end;

implementation

{ TExecutionErrorOutputText }

function TExecutionErrorOutputText.ToText(const Error: IExecutionError): String;
begin
  Result := Format('%s', [Error.Text]) + sLineBreak;
end;

class function TExecutionErrorOutputText.New: IExecutionErrorOutput;
begin
  Result := TExecutionErrorOutputText.Create;
end;

{ TExecutionErrorStackOutput }

function TExecutionErrorStackOutput.ToText(const ErrorStack: IExecutionErrorStack): String;
var
  Error: IExecutionError;
begin
  Result := EmptyStr;
  for Error in ErrorStack do
    Result := Result + _ErrorOutput.ToText(Error);
  Result := Trim(Result);
end;

constructor TExecutionErrorStackOutput.Create(const ErrorOutput: IExecutionErrorOutput);
begin
  _ErrorOutput := ErrorOutput;
end;

class function TExecutionErrorStackOutput.New(const ErrorOutput: IExecutionErrorOutput): IExecutionErrorStackOutput;
begin
  Result := TExecutionErrorStackOutput.Create(ErrorOutput);
end;

end.
