unit split;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TfrmSplit }

  TfrmSplit = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lbversion: TLabel;
  private

  public

  end;

var
  frmSplit: TfrmSplit;

implementation

{$R *.lfm}

end.

