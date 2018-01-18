{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Interface to define a task
  @created(08/04/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooTask;

interface

uses
  SysUtils,
  ooExecution.Status,
  ooExecution.Return,
  ooExecution.Notifier,
  ooRunnable.Intf, ooRunnable.Notify.Intf;

type
{$REGION 'documentation'}
{
  @abstract(Interface to define a task)
  @member(
    LastReturn Execution last return
    @returns(@link(IExecutionReturn return with generic value))
  )
}
{$ENDREGION}
  ITask<T> = interface(IRunnableNotify)
    ['{D94EECFE-EB0C-43F3-9EBF-5DD4F61AA30D}']
    function LastReturn: IExecutionReturn<T>;
  end;
{$REGION 'documentation'}
{
  Class for task exceptions
}
{$ENDREGION}

  ETask = class sealed(Exception)
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ITask))
  Parent class to save code lines
  @member(Code @seealso(IRunnable.Code));
  @member(Description @seealso(IRunnable.Description))
  @member(Execute @seealso(IRunnable.Execute))
  @member(Status @seealso(IRunnable.Status))
  @member(ChangeNotifier @seealso(IRunnableNotify.ChangeNotifier))
  @member(LastReturn @seealso(ITask.LastReturn))
  @member(
    RunTask Execute a runnable object
    @param(Task Runnable object to execute)
    @return(@true is success, @false is fail)
  )
  @member(
    RunTaskRaisingError Execute a runnable object. If exception is generated then raise
    @param(Task Runnable object to execute)
    @return(@true is success, @false is fail)
  )
  @member(
    NewSuccessReturn Build a new successed execution return
    @param(Value Generic value)
    @return(Execution return object)
  )
  @member(
    NewFailReturn Build a new failed execution return
    @param(Error Exception error)
    @return(Execution return object)
  )
  @member(
    ChangeStatus Change the current execution status
    @param(Status New execution status)
  )
  @member(
    NewExecutionValue Must be implemented in inheritence
    @return(Must return a generic value)
  )
  @member(
    NotifyStatusChanged Send notify to the event callback
    @param(Runnable Sender of notification)
    @param(Status Current execution status)
  )
  @member(
    Create Object constructor
    @param(Code Code to identify this task)
    @param(Description Task description)
  )
}
{$ENDREGION}

  TTask<T> = class(TInterfacedObject, ITask<T>, IRunnableNotify, IRunnable)
  strict private
    _Code: String;
    _Description: String;
    _Status: IExecutionStatus;
    _LastReturn: IExecutionReturn<T>;
    _Notifier: IExecutionNotifier;
    function NewSuccessReturn(const Value: T): IExecutionReturn<T>;
    function NewFailReturn(const Error: Exception): IExecutionReturn<T>;
    procedure ChangeStatus(const Status: IExecutionStatus);
  protected
    function NewExecutionValue: T; virtual; abstract;
    procedure NotifyStatusChanged(const Runnable: IRunnable; const Status: IExecutionStatus);
  public
    function Code: String;
    function Description: String;
    function Execute: Boolean;
    function LastReturn: IExecutionReturn<T>;
    function Status: IExecutionStatus;
    function RunTask(const Task: IRunnableNotify): Boolean;
    function RunTaskRaisingError<TTask>(const Task: ITask<TTask>): Boolean;
    procedure ChangeNotifier(const Notifier: IExecutionNotifier);
    constructor Create(const Code, Description: String);
  end;

implementation

function TTask<T>.Code: String;
begin
  Result := _Code;
end;

function TTask<T>.Description: String;
begin
  Result := _Description;
end;

function TTask<T>.Status: IExecutionStatus;
begin
  Result := _Status;
end;

procedure TTask<T>.ChangeStatus(const Status: IExecutionStatus);
begin
  _Status := Status;
  NotifyStatusChanged(Self, Status);
end;

procedure TTask<T>.NotifyStatusChanged(const Runnable: IRunnable; const Status: IExecutionStatus);
begin
  if Assigned(_Notifier) then
    _Notifier.StatusChanged(Runnable, Status);
end;

function TTask<T>.RunTask(const Task: IRunnableNotify): Boolean;
begin
  Task.ChangeNotifier(_Notifier);
  Result := Task.Execute;
end;

function TTask<T>.RunTaskRaisingError<TTask>(const Task: ITask<TTask>): Boolean;
begin
  Result := RunTask(Task);
  if not Task.LastReturn.IsSuccess then
    raise ETask.Create(Task.LastReturn.Error.Message);
end;

function TTask<T>.NewFailReturn(const Error: Exception): IExecutionReturn<T>;
begin
  Result := TExecutionReturn<T>.New;
  Result.Fail(Error);
  ChangeStatus(TExecutionStatus.New(Fail, 'Failed=[' + Error.Message + ']'));
end;

function TTask<T>.NewSuccessReturn(const Value: T): IExecutionReturn<T>;
begin
  Result := TExecutionReturn<T>.New;
  Result.Success(Value);
  ChangeStatus(TExecutionStatus.New(Success, 'Successed'));
end;

procedure TTask<T>.ChangeNotifier(const Notifier: IExecutionNotifier);
begin
  _Notifier := Notifier;
end;

function TTask<T>.Execute: Boolean;
var
  Value: T;
begin
  Result := False;
  ChangeStatus(TExecutionStatus.New(Running, 'Started'));
  try
    Value := NewExecutionValue;
    _LastReturn := NewSuccessReturn(Value);
    Result := True;
  except
    on E: Exception do
      _LastReturn := NewFailReturn(E);
  end;
  ChangeStatus(TExecutionStatus.New(Stopped, 'Stopped'));
end;

function TTask<T>.LastReturn: IExecutionReturn<T>;
begin
  Result := _LastReturn;
end;

constructor TTask<T>.Create(const Code, Description: String);
begin
  _Code := Code;
  _Description := Description;
  ChangeStatus(TExecutionStatus.New(Stopped, 'Idle'));
end;

end.
