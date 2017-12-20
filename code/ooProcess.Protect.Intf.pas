{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to protect process
  @created(08/04/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
unit ooProcess.Protect.Intf;

interface

uses
  SysUtils,
  ooProcess.Intf;

type
{$REGION 'documentation'}
// @abstract(Exception class for process @link(IProcess protected))
{$ENDREGION}
  EProcessProtect = class(Exception)
  end;
{$REGION 'documentation'}
{
  @abstract(Object to protect process)
  @member(
    Protect Start the process protection
    @param(Process Process to protect)
    @returns(@true if protect success, @false if fail)
  )
  @member(
    EndProtect End current process protection
    @returns(@True if protect finish ok, @false if not)
  )
}
{$ENDREGION}

  IProcessProtect = interface
    ['{6A82AA38-C008-405F-B573-2483BB3D822B}']
    function Protect(const Process: IProcess): Boolean;
    function EndProtect: Boolean;
  end;

implementation

end.
