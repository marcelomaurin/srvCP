unit TEMSOLUCAO;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, EditBtn,
  ComCtrls, ExtCtrls;

type

  { TfrmTemsolucao }

  TfrmTemsolucao = class(TForm)
    btImport: TButton;
    btCancel: TButton;
    edFileImport: TFileNameEdit;
    Label1: TLabel;
    Label2: TLabel;
    pnImport: TPanel;
    ProgressBar1: TProgressBar;
    procedure btCancelClick(Sender: TObject);
    procedure btImportClick(Sender: TObject);
  private
    procedure ImportaDatabase();
    procedure DeleteAll();
  public

  end;

var
  frmTemsolucao: TfrmTemsolucao;

implementation

{$R *.lfm}

{ TfrmTemsolucao }
uses udmbase, database;

procedure TfrmTemsolucao.btImportClick(Sender: TObject);
begin
  ImportaDatabase();
  close;
end;

procedure TfrmTemsolucao.ImportaDatabase;
begin
  case QuestionDlg('Import', 'Confirm, all data destroy?', mtConfirmation, [mrNo, '&No','IsDefault',
                   mrYes,'&Yes'],0) of
  mrYES :
    begin
      (*Delete all datas*)
      DeleteAll();

      ShowMessage('Finished!');
    end;
  mrNo :
    begin
      ShowMessage('Canceled Operation!');
    end;
  end;
end;

procedure TfrmTemsolucao.DeleteAll;
begin
     dmBase.DeleteAllProdutos();
end;

procedure TfrmTemsolucao.btCancelClick(Sender: TObject);
begin
  close;
end;

end.

