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
    edWhere: TEdit;
    edPreco: TEdit;
    edFileImport: TFileNameEdit;
    edEAN: TEdit;
    edTabela: TEdit;
    edDescProd: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    pnImport: TPanel;
    ProgressBar1: TProgressBar;
    procedure btCancelClick(Sender: TObject);
    procedure btImportClick(Sender: TObject);
  private
    procedure ImportaDatabase();
    procedure DeleteAll();
    function OpenFIle(arquivo : string): boolean;
    function OpenRecords() : boolean;
    procedure ImportRecord();
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

procedure TfrmTemsolucao.ImportaDatabase();
begin
  case QuestionDlg('Import', 'Confirm, all data destroy?', mtConfirmation, [mrNo, '&No','IsDefault',
                   mrYes,'&Yes'],0) of
  mrYES :
    begin
      if OpenFile(edFileImport.FileName) then
      begin
         if(OpenRecords()) then
         begin
           (*Delete all datas*)
           DeleteAll();
           ImportRecord();
           ShowMessage('Finished!');
         end;
      end
      else
      begin
      end;
    end;
  mrNo :
    begin
      ShowMessage('Canceled Operation!');
    end;
  end;
end;

procedure TfrmTemsolucao.DeleteAll();
begin
     dmBase.DeleteAllProdutos();
end;

function TfrmTemsolucao.OpenFIle(arquivo: string): boolean;
var
  resultado : boolean;
begin
  resultado := false;
  dmBase.zconImport.Disconnect;
  dmBase.zconImport.database := arquivo;
  dmBase.zconImport.Connect;
  if dmBase.zconImport.Connected then
  begin
       resultado := true;
  end;
  result := resultado;
end;

function TfrmTemsolucao.OpenRecords(): boolean;
begin
  dmBase.qryauximport.close;
  dmBase.qryauximport.sql.Text :=
     'select * from '+edTabela.Text+' '+
     edWhere.Text;
  dmbase.qryauximport.Open;
  ProgressBar1.Max := dmBase.qryauximport.RecordCount;
  result := true;
end;

procedure TfrmTemsolucao.ImportRecord();
var
  Produto : string;
  Preco: string;
  EAN: string;
  contador : integer;
begin
  dmBase.qryauximport.first;
  contador := 0;
  pnImport.Visible:=true;
  Application.ProcessMessages;
  while not dmBase.qryauximport.EOF do
  begin
    Produto := dmBase.qryauximport.fieldbyname(edDescProd.text).asstring;
    Preco := dmBase.qryauximport.fieldbyname(edPreco.text).asstring;
    EAN := dmBase.qryauximport.fieldbyname(edEAN.text).asstring;
    dmBase.tbProdutos.Append();
    dmBase.tbProdutos.FieldByName('ProdNome').value := Produto;
    dmBase.tbProdutos.FieldByName('ProdPreco').value := Preco;
    dmBase.tbProdutos.FieldByName('ProdBarcode').value := EAN;
    dmBase.tbProdutos.FieldByName('ProcAtivo').value := 1;
    contador := contador + 1;
    ProgressBar1.Position:= contador;
    Application.ProcessMessages;
    dmBase.tbProdutos.Post;
    dmBase.qryauximport.Next;
  end;
  pnImport.Visible:=false;
  Application.ProcessMessages;
end;

procedure TfrmTemsolucao.btCancelClick(Sender: TObject);
begin
  close;
end;

end.

