{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to define a execution return
  @created(08/04/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooExecution.Return;

interface

uses
  SysUtils,
  ooExecution.Error;

type
{$REGION 'documentation'}
{
  @abstract(Object to define a execution return)
  Generic way to return some info of any execution
  @member(
    StartTime Execution start datetime
    @returns(Datetime when the execution started)
  )
  @member(
    FinishTime Execution finish datetime
    @returns(Datetime when the execution finished)
  )
  @member(
    Value Generic value to return
    @returns(<T> generic value is success or nil when fail)
  )
  @member(
    Error Exception object when fail
    @returns(Error when fail, nil when success)
  )
  @member(
    IsSuccess Checks if the execution run ok
    @return(@true if execution was successed, @false if not)
  )
  @member(
    Success Sets value on executation success
    @param(Return Generic value to set)
  )
  @member(
    Fail Sets error on executation not success
    @param(Error Error object)
  )
}
{$ENDREGION}
  IExecutionReturn<T> = interface
    ['{5FFF7BBA-AE84-438A-99A0-E478DFB318A1}']
    function StartTime: TDateTime;
    function FinishTime: TDateTime;
    function Value: T;
    function Error: IExecutionError;
    function IsSuccess: Boolean;
    procedure Success(const Return: T);
    procedure Fail(const Error: IExecutionError);
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IExecutionReturn))
  @member(StartTime @seealso(IExecutionReturn.StartTime))
  @member(FinishTime @seealso(IExecutionReturn.FinishTime))
  @member(Value @seealso(IExecutionReturn.Value))
  @member(Error @seealso(IExecutionReturn.Error))
  @member(Success @seealso(IExecutionReturn.Success))
  @member(Fail @seealso(IExecutionReturn.Fail))
  @member(IsSuccess @seealso(IExecutionReturn.IsSuccess))
  @member(Create Object constructor)
  @member(New Create a new @classname as interface)
}
{$ENDREGION}

  TExecutionReturn<T> = class sealed(TInterfacedObject, IExecutionReturn<T>)
  strict private
    _StartTime, _FinishTime: TDateTime;
    _Value: T;
    _Error: IExecutionError;
  public
    function StartTime: TDateTime;
    function FinishTime: TDateTime;
    function Value: T;
    function Error: IExecutionError;
    function IsSuccess: Boolean;
    procedure Success(const Return: T);
    procedure Fail(const Error: IExecutionError);
    constructor Create;
// destructor Destroy; override;
    class function New: IExecutionReturn<T>;
  end;

implementation

function TExecutionReturn<T>.StartTime: TDateTime;
begin
  Result := _StartTime;
end;

function TExecutionReturn<T>.FinishTime: TDateTime;
begin
  Result := _FinishTime;
end;

function TExecutionReturn<T>.Error: IExecutionError;
begin
  Result := _Error;
end;

function TExecutionReturn<T>.Value: T;
begin
  Result := _Value;
end;

function TExecutionReturn<T>.IsSuccess: Boolean;
begin
  Result := not Assigned(_Error);
end;

procedure TExecutionReturn<T>.Success(const Return: T);
begin
  _FinishTime := Now;
  _Value := Return;
end;

procedure TExecutionReturn<T>.Fail(const Error: IExecutionError);
begin
  _FinishTime := Now;
  _Error := Error; // Exception(AcquireExceptionObject);
end;

constructor TExecutionReturn<T>.Create;
begin
  _StartTime := Now;
end;

// destructor TExecutionReturn<T>.Destroy;
// begin
// if Assigned(_Error) then
// begin
// ReleaseExceptionObject;
// _Error.Free;
// end;
// inherited;
// end;

class function TExecutionReturn<T>.New: IExecutionReturn<T>;
begin
  Result := TExecutionReturn<T>.Create;
end;

end.
