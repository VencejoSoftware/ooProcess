{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Interface to define a runnable object with notifications
  @created(08/04/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooRunnable.Notify.Intf;

interface

uses
  ooRunnable.Intf,
  ooExecution.Notifier;

type
{$REGION 'documentation'}
{
  @abstract(Interface to define a runnable object with notification events)
  @member(
    ChangeNotifier Change the current notifier
    @param(Notifier Notifier object)
  )
}
{$ENDREGION}
  IRunnableNotify = interface(IRunnable)
    ['{D5D89FC5-5FE3-4EC8-ADFB-77173FFF8A76}']
    function RunTask(const Task: IRunnableNotify): Boolean;
    procedure ChangeNotifier(const Notifier: IExecutionNotifier);
  end;

implementation

end.
