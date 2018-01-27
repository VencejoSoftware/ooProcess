{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to define a execution notifier with log actor insede
  @created(08/04/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooExecution.Log.Notifier;

interface

uses
  SysUtils,
  ooLogger.Intf, ooLog.Actor,
  ooExecution.Status,
  ooExecution.Notifier,
  ooWork;

type
{$REGION 'documentation'}
{
  @abstract(Implementation of @link(IExecutionNotifier))
  @member(
    NotifyStatus Write in logger the notification
    @param(Runnable Execution owner)
    @param(Status Current execution status)
    @seealso(IExecutionNotifier.Parse)
  )
  @member(
    Create Object constructor
    @param(Logger Logger object)
  )
  @member(
    New Create a new @classname as interface
    @param(Logger Logger object)
  )
}
{$ENDREGION}
  TExecutionLogNotifier = class sealed(TInterfacedObject, IExecutionNotifier)
  strict private
    _LogActor: ILogActor;
  public
    procedure StatusChanged(const Work: IWork; const Status: IExecutionStatus);
    constructor Create(const Logger: ILogger);
    class function New(const Logger: ILogger): IExecutionNotifier;
  end;

implementation

procedure TExecutionLogNotifier.StatusChanged(const Work: IWork; const Status: IExecutionStatus);
begin
  _LogActor.LogDebug(Work.Code + '>>' + Status.Text);
  case Status.Code of
    Running, Stopped:
      _LogActor.LogInfo(Work.Description + ': ' + Status.Text);
    Fail:
      _LogActor.LogErrorText(Work.Code + '>>' + Work.Description + ': ' + Status.Text);
    Warning:
      _LogActor.LogWarning(Work.Description + ': ' + Status.Text);
  end;
end;

constructor TExecutionLogNotifier.Create(const Logger: ILogger);
begin
  _LogActor := TLogActor.New(Logger);
end;

class function TExecutionLogNotifier.New(const Logger: ILogger): IExecutionNotifier;
begin
  Result := TExecutionLogNotifier.Create(Logger);
end;

end.
