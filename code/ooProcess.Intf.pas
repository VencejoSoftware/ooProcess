{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Interface to define a process object
  @created(08/04/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
{$ENDREGION}
unit ooProcess.Intf;

interface

uses
  ooRunnable.Intf, ooRunnable.Notify.Intf;

type
{$REGION 'documentation'}
{
  @abstract(Interface to define a process)
  @member(
    RunID Return the process unique identifier when run/execute
    @return(Process run identifier)
  )
}
{$ENDREGION}
  TProcessRunID = Cardinal;

  IProcess = interface(IRunnableNotify)
    ['{7248F091-B271-46C7-AA4C-044A08635FCB}']
    function RunID: TProcessRunID;
  end;

implementation

end.
