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
  ooExecution.Status,
  ooExecution.Return,
  ooExecution.Notifier,
  ooExecution.Error,
  ooWork, ooWork.Runnable;

type
{$REGION 'documentation'}
{
  @abstract(Interface to define a task object)
  @member(
    LastReturn Execution last return value
    @returns(@link(IExecutionReturn return with generic value))
  )
}
{$ENDREGION}
  ITask<T> = interface(IWorkRunnable)
    ['{BE2CD566-D53C-47FA-AA9F-58494C239E1C}']
    function LastReturn: IExecutionReturn<T>;
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(ITask))
  @member(Code @seealso(IWork.Code))
  @member(Description @seealso(IWork.Description))
  @member(Status @seealso(IWorkRunnable.Status))
  @member(Execute @seealso(IWorkRunnable.Execute))
  @member(ExecuteChildWork @seealso(IWorkRunnable.ExecuteChildWork))
  @member(ChangeStatus @seealso(IWorkRunnable.ChangeStatus))
  @member(ChangeNotifier @seealso(IWorkRunnable.ChangeNotifier))
  @member(LastReturn @seealso(ITask.LastReturn))
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
    NewExecutionValue Must be implemented in inheritence class
    @return(Must return a generic value)
  )
  @member(
    Create Object constructor
    @param(Code Code to identify the task)
    @param(Description Task description)
  )
}
{$ENDREGION}

  TTask<T> = class(TInterfacedObject, ITask<T>)
  strict private
    _Work: IWorkRunnable;
    _LastReturn: IExecutionReturn<T>;
    function NewSuccessReturn(const Value: T): IExecutionReturn<T>;
    function NewFailReturn(const Error: IExecutionError): IExecutionReturn<T>;
    function ExecuteCallback: Boolean;
    procedure ExecuteFailback(const Error: IExecutionError);
  protected
    function NewExecutionValue: T; virtual; abstract;
  public
    function Code: String;
    function Description: String;
    function Execute(const RaiseOnFail: Boolean = False): Boolean;
    function LastReturn: IExecutionReturn<T>;
    function Status: IExecutionStatus;
    function ExecuteChildWork(const Task: IWorkRunnable; const RaiseOnFail: Boolean = False): Boolean;
    procedure ChangeStatus(const Status: IExecutionStatus);
    procedure ChangeNotifier(const Notifier: IExecutionNotifier);
    constructor Create(const Code, Description: String);
  end;

implementation

function TTask<T>.Code: String;
begin
  Result := _Work.Code;
end;

function TTask<T>.Description: String;
begin
  Result := _Work.Description;
end;

function TTask<T>.Status: IExecutionStatus;
begin
  Result := _Work.Status;
end;

procedure TTask<T>.ChangeStatus(const Status: IExecutionStatus);
begin
  _Work.ChangeStatus(Status);
end;

procedure TTask<T>.ChangeNotifier(const Notifier: IExecutionNotifier);
begin
  _Work.ChangeNotifier(Notifier);
end;

function TTask<T>.ExecuteChildWork(const Task: IWorkRunnable; const RaiseOnFail: Boolean = False): Boolean;
begin
  Result := _Work.ExecuteChildWork(Task, RaiseOnFail);
end;

function TTask<T>.NewFailReturn(const Error: IExecutionError): IExecutionReturn<T>;
begin
  Result := TExecutionReturn<T>.New;
  Result.Fail(Error);
end;

function TTask<T>.NewSuccessReturn(const Value: T): IExecutionReturn<T>;
begin
  Result := TExecutionReturn<T>.New;
  Result.Success(Value);
end;

function TTask<T>.LastReturn: IExecutionReturn<T>;
begin
  Result := _LastReturn;
end;

function TTask<T>.ExecuteCallback: Boolean;
var
  Value: T;
begin
  Value := NewExecutionValue;
  _LastReturn := NewSuccessReturn(Value);
  Result := True;
end;

procedure TTask<T>.ExecuteFailback(const Error: IExecutionError);
begin
  _LastReturn := NewFailReturn(Error);
end;

function TTask<T>.Execute(const RaiseOnFail: Boolean = False): Boolean;
begin
  Result := _Work.Execute(RaiseOnFail);
end;

constructor TTask<T>.Create(const Code, Description: String);
begin
  _Work := TWorkRunnable.New(TWork.New(Code, Description), ExecuteCallback, ExecuteFailback);
end;

end.
