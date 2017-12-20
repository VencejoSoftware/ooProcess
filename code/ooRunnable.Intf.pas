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
unit ooRunnable.Intf;

interface

uses
  SysUtils,
  Generics.Collections,
  ooExecution.Status,
  ooExecution.Return;

type
{$REGION 'documentation'}
{
  @abstract(Interface to define a runnable object)
  Generic way to create a runnable object
  @member(Code Execution code)
  @member(Description Execution description)
  @member(
    Status Current execution status
    @returns(@link(IExecutionStatus Status object))
  )
  @member(
    Execute Run execution
    @returns(@true if success, @false if not)
  )
}
{$ENDREGION}
  IRunnable = interface
    ['{D8CEE9DE-08D6-46E7-A89A-9F614E4AE48E}']
    function Code: String;
    function Description: String;
    function Status: IExecutionStatus;
    function Execute: Boolean;
  end;
{$REGION 'documentation'}
{
  @abstract(Runnable object list)
  @member(
    FindByCode Find execution by code
    @param(Code Code to search)
    @return(nil if not found, @link(IRunnable the object) if founded)
  )
  @member(
    IsEmpty Checks if the list is empty
    @return(@true if not has items, @false if has at least one item)
  )
}
{$ENDREGION}

  TRunnableList = class sealed(TList<IRunnable>)
  public
    function FindByCode(const Code: String): IRunnable;
    function IsEmpty: Boolean;
  end;

implementation

function TRunnableList.FindByCode(const Code: String): IRunnable;
var
  Runnable: IRunnable;
begin
  Result := nil;
  for Runnable in Self do
    if CompareText(Code, Runnable.Code) = 0 then
      Exit(Runnable);
end;

function TRunnableList.IsEmpty: Boolean;
begin
  Result := Count < 1;
end;

end.
