unit udmbase;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, ZConnection, ZDataset;

type

  { TdmBase }

  TdmBase = class(TDataModule)
    tbProdutosidProdutos: TLargeintField;
    tbProdutosPROCAtivo: TBooleanField;
    tbProdutosProdBARCODE: TStringField;
    tbProdutosProdNome: TStringField;
    tbProdutosPRODPRECO: TFloatField;
    zcon: TZConnection;
    tbProdutos: TZTable;
  private

  public

  end;

var
  dmBase: TdmBase;

implementation

{$R *.lfm}

end.

