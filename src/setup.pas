unit Setup;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, EditBtn,
  setmain;

type

  { TfrmSetup }

  TfrmSetup = class(TForm)
    btSave: TButton;
    btCancel: TButton;
    cbTipo: TComboBox;
    cbModelo: TComboBox;
    edFileVP240W: TFileNameEdit;
    edLabel1: TEdit;
    edLabel2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
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
  FSETMAIN.PATHVP240W:=edFileVP240W.Text;
  FSETMAIN.Label1:= edLabel1.Text;
  FSETMAIN.Label2:= edLabel2.Text;
  close;
end;

end.

