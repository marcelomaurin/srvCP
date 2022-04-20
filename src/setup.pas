unit Setup;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, setmain;

type

  { TfrmSetup }

  TfrmSetup = class(TForm)
    btSave: TButton;
    btCancel: TButton;
    cbTipo: TComboBox;
    cbModelo: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure btCancelClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
  private

  public

  end;

var
  frmSetup: TfrmSetup;

implementation

{$R *.lfm}

{ TfrmSetup }

procedure TfrmSetup.btCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmSetup.btSaveClick(Sender: TObject);
begin
  FSETMAIN.TipoCP:= cbTipo.ItemIndex;
  FSETMAIN.ModeloCP:=cbModelo.ItemIndex;
  close;
end;

end.

