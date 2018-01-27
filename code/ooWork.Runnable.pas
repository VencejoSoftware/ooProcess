{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Interface to define a runnable object
  @created(08/04/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooWork.Runnable;

interface

uses
  SysUtils,
  ooExecution.Status,
  ooExecution.Return,
  ooExecution.Error,
  ooExecution.Notifier,
  ooWork;

type
{$REGION 'documentation'}
{
  @abstract(Callback of execution)
  @return(@true if execution success, @false if fail)
}
{$ENDREGION}
{$IFDEF FPC}
  TExecuteCallback = function: Boolean;
{$ELSE}
  TExecuteCallback = reference to function: Boolean;
{$ENDIF}
{$REGION 'documentation'}
{
  @abstract(Faikback of execution)
  @param(Error Exception object)
}
{$ENDREGION}
{$IFDEF FPC}
  TExecuteFailback = procedure(const Error: IExecutionError);
{$ELSE}
  TExecuteFailback = reference to procedure(const Error: IExecutionError);
{$ENDIF}
{$REGION 'documentation'}
{
  @abstract(Interface to define a work runnable object)
  Generic way to create a work runnable object
  @member(
    Status Current execution status
    @returns(@link(IExecutionStatus Status object))
  )
  @member(
    Execute Run the work
    @param(RaiseOnFail If execution fail and this parameter is @true then raise the error to up)
    @returns(@true if success, @false if not)
  )
  @member(
    ExecuteChildWork Execute a child work object
    @param(Work Work object to execute)
    @param(RaiseOnFail If execution fail and this parameter is @true then raise the error to up)
    @return(@true is execution successed, @false if failed)
  )
  @member(
    ChangeStatus Change the current execution status
    @param(Status New execution status)
  )
  @member(
    ChangeNotifier Change the current notifier
    @param(Notifier Notifier object)
  )
}
{$ENDREGION}

  IWorkRunnable = interface(IWork)
    ['{0F88B5BB-6BA6-4389-90B4-5645CF19361A}']
    function Status: IExecutionStatus;
    function Execute(const RaiseOnFail: Boolean = False): Boolean;
    function ExecuteChildWork(const Work: IWorkRunnable; const RaiseOnFail: Boolean = False): Boolean;
    procedure ChangeStatus(const Status: IExecutionStatus);
    procedure ChangeNotifier(const Notifier: IExecutionNotifier);
  end;
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IWorkRunnable))
  @member(Code @seealso(IWork.Code))
  @member(Description @seealso(IWork.Description))
  @member(Status @seealso(IWorkRunnable.Status))
  @member(Execute @seealso(IWorkRunnable.Execute))
  @member(ExecuteChildWork @seealso(IWorkRunnable.ExecuteChildWork))
  @member(ChangeStatus @seealso(IWorkRunnable.ChangeStatus))
  @member(ChangeNotifier @seealso(IWorkRunnable.ChangeNotifier))
  @member(
    NotifyStatusChanged Send notify to the event callback
    @param(Status Current execution status)
  )
  @member(
    Create Object constructor
    @param(Work Work definition object)
    @param(Callback Execution callback)
    @param(Failback Execution failback)
  )
  @member(
    New Create a new @classname as interface
    @param(Work Work definition object)
    @param(Callback Execution callback)
    @param(Failback Execution failback)
  )
}
{$ENDREGION}

  TWorkRunnable = class sealed(TInterfacedObject, IWorkRunnable, IWork)
  strict private
    _Work: IWork;
    _Status: IExecutionStatus;
    _Callback: TExecuteCallback;
    _Failback: TExecuteFailback;
    _Notifier: IExecutionNotifier;
  private
    procedure NotifyStatusChanged(const Status: IExecutionStatus);
  public
    function Code: String;
    function Description: String;
    function Status: IExecutionStatus;
    function Execute(const RaiseOnFail: Boolean = False): Boolean;
    function ExecuteChildWork(const Work: IWorkRunnable; const RaiseOnFail: Boolean = False): Boolean;
    procedure ChangeStatus(const Status: IExecutionStatus);
    procedure ChangeNotifier(const Notifier: IExecutionNotifier);
    constructor Create(const Work: IWork; const Callback: TExecuteCallback; const Failback: TExecuteFailback);
    class function New(const Work: IWork; const Callback: TExecuteCallback;
      const Failback: TExecuteFailback): IWorkRunnable;
  end;

implementation

function TWorkRunnable.Code: String;
begin
  Result := _Work.Code;
end;

function TWorkRunnable.Description: String;
begin
  Result := _Work.Description;
end;

function TWorkRunnable.Status: IExecutionStatus;
begin
  Result := _Status;
end;

procedure TWorkRunnable.ChangeNotifier(const Notifier: IExecutionNotifier);
begin
  _Notifier := Notifier;
end;

procedure TWorkRunnable.NotifyStatusChanged(const Status: IExecutionStatus);
begin
  if Assigned(_Notifier) then
    _Notifier.StatusChanged(Self, Status);
end;

procedure TWorkRunnable.ChangeStatus(const Status: IExecutionStatus);
begin
  _Status := Status;
  NotifyStatusChanged(Status);
end;

function TWorkRunnable.Execute(const RaiseOnFail: Boolean = False): Boolean;
begin
  Result := False;
  ChangeStatus(TExecutionStatus.New(Running, 'Started'));
  try
    if Assigned(_Callback) then
      Result := _Callback;
    ChangeStatus(TExecutionStatus.New(Success, 'Successed'));
  except
    on E: Exception do
    begin
      if Assigned(_Failback) then
        _Failback(TExecutionError.New(Self, E.Message));
      if RaiseOnFail then
      begin
        ChangeStatus(TExecutionStatus.New(Notifying, 'Failed=[' + E.Message + ']'));
        raise ;
      end
      else
      begin
        ChangeStatus(TExecutionStatus.New(Fail, 'Failed=[' + E.Message + ']'));
      end;
    end;
  end;
  ChangeStatus(TExecutionStatus.New(Stopped, 'Stopped'));
end;

function TWorkRunnable.ExecuteChildWork(const Work: IWorkRunnable; const RaiseOnFail: Boolean = False): Boolean;
begin
  Work.ChangeNotifier(_Notifier);
  Result := Work.Execute(RaiseOnFail);
end;

constructor TWorkRunnable.Create(const Work: IWork; const Callback: TExecuteCallback; const Failback: TExecuteFailback);
begin
  _Work := Work;
  ChangeStatus(TExecutionStatus.New(Stopped, 'Idle'));
  _Callback := Callback;
  _Failback := Failback;
end;

class function TWorkRunnable.New(const Work: IWork; const Callback: TExecuteCallback;
  const Failback: TExecuteFailback): IWorkRunnable;
begin
  Result := TWorkRunnable.Create(Work, Callback, Failback);
end;

end.
