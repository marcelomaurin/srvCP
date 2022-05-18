unit udmbase;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, ZConnection, ZDataset, setmain, Dialogs, log;

type

  { TdmBase }

  TdmBase = class(TDataModule)
    qryauximport: TZQuery;
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
    zconImport: TZConnection;
    procedure DataModuleDestroy(Sender: TObject);
  private

  public
    function BuscaProduto(Barcode: string): boolean;
    procedure Conectar();
    procedure Desconectar();
    procedure AtivaTabelas();
    procedure DesativaTabelas();
    procedure DeleteAllProdutos();
    procedure VerificaBaseTerminal(lst :TStrings);


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

function TdmBase.BuscaProduto(Barcode: string): boolean;
var
  resultado : boolean;
begin
    resultado := tbProdutos.locate('prodbarcode',Barcode,[loCaseInsensitive] );
    frmlog.log('TdmBase.BuscaProduto - Barcode:'+barcode+' - Resultado:'+ booltostr(resultado));
    result := resultado;

end;

procedure TdmBase.Conectar();
begin
    {$ifdef CPU32}
    //zcon.LibraryLocation:= ExtractFilePath(ApplicationName)+'\sqlite32\sqlite3.dll';
    //zconImport.LibraryLocation:= ExtractFilePath(ApplicationName)+'\sqlite32\sqlite3.dll';
    {$endif}
    {$ifdef CPU64}
    //zcon.LibraryLocation:= ExtractFilePath(ApplicationName)+'\sqlite64\sqlite3.dll';
    //zconImport.LibraryLocation:= ExtractFilePath(ApplicationName)+'\sqlite64\sqlite3.dll';
    {$endif}
    if FileExists(FSETMAIN.BancoDLL) then
    begin
      zcon.LibraryLocation:= FSETMAIN.BancoDLL;
      zconImport.LibraryLocation:= FSETMAIN.BancoDLL;
    end
     else
    begin
      ShowMessage('DLL  '+FSETMAIN.BancoDLL + ' not exit ');
      exit();
    end;

    if FileExists(FSETMAIN.Database) then
    begin
      //zcon.Database:='.\..\db\srvCP.db';
      zcon.Database:= FSETMAIN.Database;
      zcon.Connect;
    end
    else
    begin
      ShowMessage('Database '+FSETMAIN.database + ' not exit ');
      //exit();
    end;
end;

procedure TdmBase.Desconectar();
begin
  zcon.Disconnect;
end;

procedure TdmBase.AtivaTabelas();
begin
  tbProdutos.open;
  tbTerminais.open;
end;

procedure TdmBase.DesativaTabelas();
begin
  tbProdutos.close;
  tbTerminais.close;

end;

procedure TdmBase.DeleteAllProdutos();
begin
  DesativaTabelas(); (*Desativa tabelas para evitar lock de registro*)
  qryAux.close;
  qryAux.sql.text := 'delete from Produtos';
  qryAux.Prepare;
  qryAux.ExecSQL;
  AtivaTabelas();
end;

procedure TdmBase.VerificaBaseTerminal(lst: TStrings);
var
  a : integer;
begin
  for a := 0 to lst.Count-1 do
  begin
      tbTerminais.Locate('descricao',lst[a], [loPartialKey]);
      if(tbTerminais.RecordCount=0) then
      begin
        tbTerminais.Append;
        tbTerminais.FieldByName('Descricao').asstring := lst[a];
        tbTerminais.FieldByName('IP').asstring := lst[a];
        tbTerminais.Post;
        tbTerminais.Refresh;
      end;
  end;
end;

end.

