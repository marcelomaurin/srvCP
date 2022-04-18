unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, CPGENERICO;

type

  { TForm1 }

  TForm1 = class(TForm)

    btStart: TButton;
    btStop: TButton;
    cbType: TComboBox;
    Label1: TLabel;

    procedure btStartClick(Sender: TObject);
    procedure btStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FCPGENERICO : TCPGENERICO;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btStartClick(Sender: TObject);
begin
  if (cbType.ItemIndex=1) then
  begin
       FCPGENERICO := TCPGENERICO.create(TypeCP_VP240W);

  end;
end;

procedure TForm1.btStopClick(Sender: TObject);
begin
  FCPGENERICO.Destroy;
  FCPGENERICO := nil;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FCPGENERICO := nil;
end;

end.

