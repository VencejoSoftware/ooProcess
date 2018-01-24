{$REGION 'documentation'}
{
  Copyright (c) 2016, Vencejo Software
  Distributed under the terms of the Modified BSD License
  The full license is distributed with this software
}
{
  Object to protect any work object collision
  @created(08/04/2016)
  @author Vencejo Software <www.vencejosoft.com>
}
unit ooWork.Protect.Intf;

interface

uses
  SysUtils,
  ooWork;

type
{$REGION 'documentation'}
{
  @abstract(Object to protect any work obejct)
  @member(
    Protect Start the work protection
    @param(Work Work object to protect)
    @returns(@true if protect success, @false if fail)
  )
  @member(
    EndProtecteion End current work object protection
    @returns(@True if protect finish ok, @false if not)
  )
}
{$ENDREGION}
  IWorkProtect = interface
    ['{6A82AA38-C008-405F-B573-2483BB3D822B}']
    function Protect(const Work: IWork): Boolean;
    function EndProtecteion: Boolean;
  end;

implementation

end.
