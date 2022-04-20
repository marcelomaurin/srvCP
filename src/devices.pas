unit devices;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { Tfrmdevices }

  Tfrmdevices = class(TForm)
    lbDevices: TListBox;
  private

  public

  end;

var
  frmdevices: Tfrmdevices;

implementation

{$R *.lfm}

end.

