unit CPGENERICO;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, VP240W, funcoes,dialogs, log;

type
  TTypeCP = (TypeCP_VP240W);

type
  TGenericResponseFunction = procedure(posicao : integer; BarCode : String);



TYPE

{ TCPGENERICO }
 TCPGENERICO = class(TOBJECT)
  FTypeCP : TTypeCP;
  //FVP240W :TVP240W;
  FVERSAO : String;
  //FlstEquipamento : TStringlist;
  private
   FGenericResponseFunction: TGenericResponseFunction;

   procedure CarregaLib(PathLib: string);
   function GetVersao : string;

   procedure setGenericResponseFunction(AValue: TGenericResponseFunction);

  public
    constructor Create(Tipo : TTypeCP; pathlib : string);
    function getASK(): integer;
    function getcountEquipamentos: integer;
    Function GetIDEquipamento(ip : string) : integer;
    function GetIpEquipamento(posicao : integer) : Ansistring;
    function AtualizaEquipamentos(): integer;
    function GetBarcode(Posicao: integer) : AnsiString;
    function GetNBR(Posicao: integer) : Integer;


    //procedure   CallBackVP240V(ID_Ip: dword; BarCode : String);
    property countEquipamentos : integer read getcountEquipamentos;
    property VERSAO : String read GetVersao;
    procedure SendMsg(IP : string; port : integer; Linha1, Linha2: string; Time : integer);
    procedure SendAllMsg( Linha1, Linha2 : string; Time : integer);
    procedure SendPrice( Ip: string; NameProd: String; PriceProd : String);
    procedure SendPrice( id_ip: dword; NameProd: String; PriceProd : String);
    procedure SendPrice(posicao: integer; NameProd: String; PriceProd: String ); (*sobrecarga de metodos*)
    procedure SendNotPrice(id_IP: dword; NameProd: String);
    procedure SendNotPrice( Ip: string; NameProd: String);
    procedure SendNotPrice( posicao: integer; NameProd: String);
    property GenericResponseFunction : TGenericResponseFunction read FGenericResponseFunction write setGenericResponseFunction;

end;

//procedure CallBackVP240V(ID_Ip: dword; BarCode: String);

var
  FCPGENERICO : TCPGENERICO;

implementation

{ TCPGENERICO }

constructor TCPGENERICO.Create(Tipo: TTypeCP; pathlib : string);
begin
  FTypeCP := tipo;
  FGenericResponseFunction := nil;
  //FlstEquipamento := TStringList.create();
  //FlstEquipamento.Clear;
  CarregaLIB(pathlib);
end;

function TCPGENERICO.getASK(): integer;
var
 stBarCode: stAddress;
 BarCode: PChar;
 posicao : integer;
begin
  if (FTypeCP = TypeCP_VP240W) then
  begin
       posicao := FVP240W.getASK();
  end;


end;

function TCPGENERICO.AtualizaEquipamentos(): integer;
var
  posicao: integer;
  itemAtualizados : integer;
  total : integer;
begin
  total := -1;
  if (FTypeCP = TypeCP_VP240W) then
  begin
     itemAtualizados := FVP240W.AtualizaEquipamentos(); (*Captura a relação de itens*)
     total := itemAtualizados;
     //FlstEquipamento.Clear;
     (*
     for posicao := 0 to itemAtualizados-1 do
     begin
         FlstEquipamento.AddObject(FVP240W.GetIP(posicao),TObject(posicao));  (*Adiciona o ip e sua posicao*)
     end;
     *)
  end;
  result := total;

end;

function TCPGENERICO.GetBarcode(Posicao: integer): AnsiString;
var
  barcode : ansistring;
begin
  barcode := '';
  if (FTypeCP = TypeCP_VP240W) then
  begin
       barcode := FVP240W.GetLastBarcode(posicao);
  end;
  result := Barcode;

end;

function TCPGENERICO.GetNBR(Posicao: integer): Integer;
var
  Nbr : integer;
begin
  NBr := 0;
  if (FTypeCP = TypeCP_VP240W) then
  begin
       Nbr := FVP240W.GetLastNbr(posicao);
  end;

  result := Nbr;
end;

procedure TCPGENERICO.SendMsg(IP: string; port: integer; Linha1,
  Linha2: string; Time: integer);
begin
  if (FTypeCP = TypeCP_VP240W) then
  begin
     FVP240W.SendMsg(IP,port,Linha1,Linha2,Time);
  end;

end;

procedure TCPGENERICO.SendAllMsg(Linha1, Linha2: string; Time: integer);
begin
  if (FTypeCP = TypeCP_VP240W) then
  begin
      FVP240W.SendAllMsg(Linha1,Linha2,Time);
  end;

end;

procedure TCPGENERICO.SendPrice(Ip: string; NameProd: String; PriceProd: String
  );
var
 ID_Ip : dword;
 posicao : integer;
begin
  if (FTypeCP = TypeCP_VP240W) then
  begin
     posicao := FVP240W.GetID_IP2IP(IP,ID_Ip);
     FVP240W.SendPrice(ID_Ip,NameProd, priceprod);
  end;
end;

procedure TCPGENERICO.SendPrice(posicao: integer; NameProd: String; PriceProd: String );
//var
// ID_Ip : dword;
begin
  if (posicao<>-1) then
  begin
    if (FTypeCP = TypeCP_VP240W) then
    begin
       frmLog.Log('SendPrice - Erro: Posicao -1');
       //ID_Ip := FVP240W.GetID_IP(posicao);
       //FVP240W.SendPrice(ID_Ip,NameProd, priceprod);
       FVP240W.SendPrice(posicao,NameProd, priceprod);
    end;
  end
  else
  begin
    frmLog.Log('SendPrice - Erro: Posicao -1');
  end;
end;

procedure TCPGENERICO.SendPrice(id_ip: dword; NameProd: String; PriceProd: String );
//var
// ID_Ip : dword;
begin
  if (id_ip<>0) then
  begin
    if (FTypeCP = TypeCP_VP240W) then
    begin
       frmLog.Log('SendPrice - Erro: Posicao -1');
       FVP240W.SendPrice(id_ip,NameProd, priceprod);
    end;
  end
  else
  begin
    frmLog.Log('SendPrice - Erro: Posicao -1');
  end;
end;


procedure TCPGENERICO.SendNotPrice(Ip: string; NameProd: String);
var
 ID_Ip : dword;
 posicao : integer;
begin
  if (FTypeCP = TypeCP_VP240W) then
  begin
     posicao := FVP240W.GetID_IP2IP(IP,ID_Ip);
     if (posicao<>-1) then
     begin
       frmLog.log('SendNotPrice - IP:'+IP+' - Posicao:'+inttostr(posicao));
       if(posicao<>-1) then
            FVP240W.SendNotPrice(ID_Ip,NameProd);

     end
     else
     begin
       frmLog.log('SendNotPrice - Erro: Nao achou posicao. Posicao:'+inttostr(posicao));
     end;
  end;
end;

procedure TCPGENERICO.SendNotPrice(posicao: integer; NameProd: String);
var
 ID_Ip : dword;
begin
  if (FTypeCP = TypeCP_VP240W) then
  begin

     ID_Ip := FVP240W.GetID_IP(posicao);
     FVP240W.SendNotPrice(ID_Ip,NameProd);
  end;
end;

procedure TCPGENERICO.SendNotPrice(id_IP: dword; NameProd: String);
begin
  if (FTypeCP = TypeCP_VP240W) then
  begin
    if(id_IP<>0) then
    begin
     FVP240W.SendNotPrice(ID_Ip,NameProd);
    end
    else
    begin
      frmLog.log('SendNotPrice - IDZerado:');
    end;
  end;
end;


procedure TCPGENERICO.CarregaLib(PathLib: string);
begin
  if (FTypeCP = TypeCP_VP240W) then
  begin
   FVP240W := TVP240W.Create(PathLib);
   FVERSAO:= inttostr(FVP240W.VERSAO);
  end;
end;




function TCPGENERICO.GetVersao: string;
var info : string;
begin
  info := ' not defined';
  if (FTypeCP = TypeCP_VP240W) then
  begin
       info :=
          copy(IntToHex(FVP240W.VERSAO,8),1,2) + '.' +
          copy(IntToHex(FVP240W.VERSAO,8),3,2) + '.' +
          copy(IntToHex(FVP240W.VERSAO,8),5,2) + '.' +
          copy(IntToHex(FVP240W.VERSAO,8),7,2) ;
       frmLog.log('GetVersao - versao:'+info);

  end;
  result := info;
end;


//TResponseFunction = procedure(ID_Ip: dword; BarCode : String);
procedure CallBackVP240V(posicao: integer; BarCode: String);
//var
  //ip : ansistring;
  //posicao : integer;
begin
//ip :=  '';
if (FCPGENERICO.FTypeCP = TypeCP_VP240W) then
begin
   //FVP240W.FindIP(ID_IP,posicao);
   //if (posicao<>-1) then
   //  IP := FVP240W.GetIP(posicao);
end;
  if (posicao<>-1) then
  begin
   FCPGENERICO.GenericResponseFunction(posicao,barcode);
   frmLog.log('CallBackVP240V - Barcode:'+barcode+ 'Posicao:'+inttostr(posicao));
  end;
end;

procedure TCPGENERICO.setGenericResponseFunction(
  AValue: TGenericResponseFunction);
begin
  if FGenericResponseFunction=AValue then Exit;
     FGenericResponseFunction:=AValue;
  if (FTypeCP = TypeCP_VP240W) then
  begin
     //FVP240W.ResponseFunction:= FGenericResponseFunction;
     FVP240W.ResponseFunction:= @CallBackVP240V;
     frmlog.log('setGenericResponseFunction - CallbackVP240V:');
  end;
end;





function TCPGENERICO.GetIDEquipamento(ip: string): integer;
var
  indice: integer;
begin
  //indice := FlstEquipamento.IndexOf(ip);
  indice := -1;
  if (FTypeCP = TypeCP_VP240W) then
  begin
     indice :=  FVP240W.GetPosicao(IP);
     frmlog.log('GetIDEquipamento - indice:'+inttostr(indice));
  end;
  //FindIP(;
  result := indice;
end;

function TCPGENERICO.GetIpEquipamento(posicao: integer): Ansistring;
var
  ip: ansistring;
begin
  ip := '';
  //result := FlstEquipamento[posicao];
  if (FTypeCP = TypeCP_VP240W) then
  begin
     ip := FVP240W.GetIP(posicao);
     frmlog.log('GetIpEquipamento - IP:'+IP);
     //ShowMessage(IP);
  end;
  result := IP;
end;

function TCPGENERICO.getcountEquipamentos: integer;
var
  total : integer;
begin
  total := -1;
  // result := FlstEquipamento.Count;
  if (FTypeCP = TypeCP_VP240W) then
  begin
       total := FVP240W.GetCountItens;
       frmlog.log('getcountEquipamentos - total:'+inttostr(total));
  end;

  result := total;
end;



end.

