unit database;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  DBGrids, DBCtrls, StdCtrls, Menus, udmbase, DB, TemSolucao;

type

  { TfrmDatabase }

  TfrmDatabase = class(TForm)
    btImportar: TButton;
    cbImportacao: TComboBox;
    dsTerminais: TDataSource;
    DBGrid2: TDBGrid;
    DBNavigator2: TDBNavigator;
    dsProdutos: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Label1: TLabel;
    miClearAll: TMenuItem;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    pmgrid: TPopupMenu;
    tbProducts: TTabSheet;
    tbTerms: TTabSheet;
    tbImport: TTabSheet;
    procedure btImportarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miClearAllClick(Sender: TObject);
  private
    procedure FecharTabelas;
    procedure AbrirTabelas;
    procedure ImportaTemSolucao;
  public

  end;

var
  frmDatabase: TfrmDatabase;

implementation

{$R *.lfm}

{ TfrmDatabase }

procedure TfrmDatabase.FormCreate(Sender: TObject);
begin
  AbrirTabelas();
end;

procedure TfrmDatabase.btImportarClick(Sender: TObject);
begin
  if (cbImportacao.ItemIndex = 0) then (*Importação tem solucao*)
  begin
       ShowMessage('No item selected!');
  end;
  if (cbImportacao.ItemIndex = 1) then (*Importação tem solucao*)
  begin
       ImportaTemSolucao();
  end;
end;

procedure TfrmDatabase.FormDestroy(Sender: TObject);
begin
  FecharTabelas();
end;

procedure TfrmDatabase.miClearAllClick(Sender: TObject);
begin
   case QuestionDlg('Delete All', 'Confirm, all data destroy?', mtConfirmation, [mrNo, '&No','IsDefault',
                   mrYes,'&Yes'],0) of
  mrYES :
    begin
      dmBase.DeleteAllProdutos();

    end;
  mrNo :
    begin
      ShowMessage('Canceled Operation!');
    end;
  end;

end;




procedure TfrmDatabase.FecharTabelas;
begin
    dmBase.DesativaTabelas();
end;

procedure TfrmDatabase.AbrirTabelas;
begin
  dmBase.AtivaTabelas();
end;

procedure TfrmDatabase.ImportaTemSolucao;
begin
   frmTemsolucao := TfrmTemsolucao.create(self);
   frmTemsolucao.showmodal();
   frmTemsolucao.free();
end;

end.

