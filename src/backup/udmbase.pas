unit udmbase;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, ZConnection, ZDataset, setmain, Dialogs;

type

  { TdmBase }

  TdmBase = class(TDataModule)
    tbProdutosidProdutos: TLargeintField;
    tbProdutosPROCAtivo: TBooleanField;
    tbProdutosProdBARCODE: TStringField;
    tbProdutosProdNome: TStringField;
    tbProdutosPRODPRECO: TFloatField;
    tbTerminaisDescricao: TStringField;
    tbTerminaisidTerminal: TLargeintField;
    tbTerminaisIP: TStringField;
    zcon: TZConnection;
    tbProdutos: TZTable;
    tbTerminais: TZTable;
    qryAux: TZQuery;
    procedure DataModuleDestroy(Sender: TObject);
  private

  public
    procedure Conectar();
    procedure Desconectar();
    procedure AtivaTabelas();
    procedure DesativaTabelas();
    procedure DeleteAllProdutos();


  end;

var
  dmBase: TdmBase;

implementation

{$R *.lfm}

{ TdmBase }

procedure TdmBase.DataModuleDestroy(Sender: TObject);
begin
  if zcon.Connected then
  begin
    Desconectar();
  end;
end;

procedure TdmBase.Conectar;
begin
    {$ifdef CPU32}
    zcon.LibraryLocation:= '.\..\sqlite32\sqlite3.dll';
    {$endif}
    {$ifdef CPU64}
    zcon.LibraryLocation:= '.\..\sqlite64\sqlite3.dll';
    {$endif}

    if FileExists(FSETMAIN.Database) then
    begin
      //zcon.Database:='.\..\db\srvCP.db';
      zcon.Database:= FSETMAIN.Database;
      zcon.Connect;
    end
    else
    begin
      ShowMessage('Database '+FSETMAIN.database + ' not exit ');
      exit();
    end;
end;

procedure TdmBase.Desconectar;
begin
  zcon.Disconnect;
end;

procedure TdmBase.AtivaTabelas;
begin
  tbProdutos.open;
  tbTerminais.open;
end;

procedure TdmBase.DesativaTabelas;
begin
  tbProdutos.close;
  tbTerminais.close;

end;

procedure TdmBase.DeleteAllProdutos;
begin
  DesativaTabelas(); (*Desativa tabelas para evitar lock de registro*)
  qryAux.close;
  qryAux.sql.text := 'delete from Produtos';
  qryAux.Prepare;
  qryAux.ExecSQL;
  AtivaTabelas();
end;

end.

