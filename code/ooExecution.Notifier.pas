{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to define a execution notifier
  @created(08/04/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooExecution.Notifier;

interface

uses
  ooExecution.Status,
  ooRunnable.Intf;

type
{$REGION 'documentation'}
{
  @abstract(Object to define a execution notifier)
  @member(
    StatusChanged Notify changes in status
    @param(Runnable Sender of notification)
    @param(Status Current execution status)
  )
}
{$ENDREGION}
  IExecutionNotifier = interface
    ['{38E8F295-7F84-4881-8855-02D81B3E9047}']
    procedure StatusChanged(const Runnable: IRunnable; const Status: IExecutionStatus);
  end;

implementation

end.
