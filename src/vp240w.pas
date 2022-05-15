unit vp240W;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, windows, dialogs, funcoes;

const
  //ALERTAS
  ERRO_SRV    = 'Erro inicializando servidor.';
  START_SRV   = 'Servidor inicializado com sucesso.';
  STOP_SRV    = 'Servidor interrompido.';
  maxequipamentos = 500;


type
  TResponseFunction = procedure(posicao: integer; BarCode : String);


type TIPV4 = record
  d,c,b,a: byte;
end;

type TConPreco = record
  ID_Ip: DWORD;
  Ip: AnsiString;
  Socket: Word;
  lastbarcode: string[20];
  Nbr : integer;
end;

type stAddress = record
  Ip: PAnsiChar;
  Socket: Word;
  Nbr: integer;
end;

type
  TTABSOCK = record
    TabSock: array[0..1023] of Word;
    TabIP: array[0..1023] of DWORD;
    NumSockConec: integer;
end;


type

{ TVP240W }

TVP240W = class(TObject)
  FVersion : DWORD;
  FTabTerms: TTABSOCK;
  LibHandle : THandle;


private
  TabTerms: TTABSOCK;
  FResponseFunction: TResponseFunction;
  FError : boolean;
  fMenssage : String;
  FvetEquipamentos: array[0..maxequipamentos] of TConPreco;
  FlstEquipamentos: TStringlist;
  function getListEquipamentos: integer;
  function FGetCountItens: integer;
  procedure setResponseFunction(AValue: TResponseFunction);
public

  constructor Create(pathlib: string);
  destructor destroy();
  procedure LoadLib(pathlib: string);
  function AtualizaEquipamentos() : integer;
  function FindIP(ID_IP : DWord; var posicao: integer):String;
  function getASK(): integer;
  procedure SendMsg(IP : string; port : integer; Linha1, Linha2: string; Time : integer);
  procedure SendAllMsg( Linha1, Linha2 : string; Time : integer);
  procedure SendPrice(ID_Ip: dword; NameProd: String; PriceProd : String);
  procedure SendPrice(posicao: integer; NameProd: String; PriceProd: String);
  procedure SendNotPrice( ID_Ip: dword; NameProd: String);
  function GetID_IP(indice : integer) : DWord;
  function GetIP(indice: integer) : AnsiString;
  function GetPort(indice: integer): integer;
  function GetLastBarcode(indice: integer): string;
  function GetLastNbr(indice : integer) : integer;
  function GetID_IP2IP(IP: String; var ID_IP : DWORD): integer;
  function GetPosicao(IP: String): Integer;
  PROPERTY VERSAO : DWORD read FVersion;
  property lstEquipamentos : integer read getListEquipamentos;
  property ResponseFunction : TResponseFunction read FResponseFunction write setResponseFunction;
  property GetCountItens : integer read fGetCountItens;


end;

//------------------------------------------------------------------------------
//function  GetTabConectados(nada: Integer): TTABSOCK; stdcall; far; external 'VP.dll';
TGetTabConectados = function(nada: Integer): TTABSOCK; stdcall;
//function Inet_NtoA(nIP: DWORD): PChar ; far; stdcall; external 'VP.dll';
TInet_NtoA = function(nIP: DWORD): PChar ; stdcall; far;
//procedure vInitialize; stdcall; far; external 'VP.dll';
TvInitialize = procedure(); stdcall;   far;
//function tc_startserver: Integer; stdcall; far; external 'VP.dll';
Ttc_startserver = function(): Integer; stdcall;  far;
//function dll_version: DWORD; stdcall; far; external 'VP.dll';
Tdll_version = function() : DWORD; stdcall;  far;
//function bTerminate: Boolean; far; stdcall; external 'VP.dll';
TbTerminate = function() : Boolean; stdcall;  far;
//function bSendDisplayMsg(ID: Integer; Linha1: PChar; Linha2: Pchar; Tempo: Integer): Boolean; stdcall; far; external 'VP.dll';
TbSendDisplayMsg = function(ID: DWORD; Linha1: PAnsiChar; Linha2: PAnsiChar; Tempo: Integer): Boolean; stdcall;  far;
//function bSendProdNotFound(ID: Integer): Boolean; stdcall; far; external 'VP.dll';
TbSendProdNotFound = function(ID: Integer): Boolean; stdcall; far;
//function bSendProdPrice(ID: Integer; var NameProd: PChar; var PriceProd : PChar): Boolean; stdcall; far; external 'VP.dll';
TbSendProdPrice = function(ID: DWORD; NameProd: PAnsiChar; PriceProd: PAnsiChar): Boolean; stdcall; far;
TbReceiveBarcode = function(out ID_IP: DWORD; out ID_Socket: Word; out Nbr: integer): PAnsiChar; stdcall;
//TInet_NtoA = function(nIP: DWORD): PAnsiChar;  stdcall;
TInet_Addr = function(sIP: PAnsiChar): DWORD; stdcall;

var
  GetTabConectados : TGetTabConectados;
  Inet_NtoA : TInet_NtoA;
  vInitialize : TvInitialize;
  tc_startserver : Ttc_startserver;
  dll_version : Tdll_version;
  bTerminate : TbTerminate;
  bSendDisplayMsg : TbSendDisplayMsg;
  bSendProdNotFound : TbSendProdNotFound;
  bSendProdPrice :TbSendProdPrice;
  bReceiveBarcode : TbReceiveBarcode;
  //Inet_NtoA : TInet_NtoA;
  Inet_Addr : TInet_Addr;
  FVP240W :TVP240W;



implementation


{ TVP240W }

constructor TVP240W.Create(pathlib: string);
begin
  FResponseFunction := nil;
  LoadLib(pathlib);
  if @vInitialize <> nil then
     vInitialize;
  if @dll_version <> nil then
     FVersion := dll_version();
  FlstEquipamentos := TStringList.create();
  FlstEquipamentos.Clear;
  if(tc_startserver() = 0) then
  begin
    ShowMessage('Erro ao parar');
  end;



end;

destructor TVP240W.destroy();
begin

end;

procedure TVP240W.LoadLib(pathlib: string);
begin

  // Get the handle of the library to be used
  LibHandle := LoadLibrary(PChar(pathlib));
  // Checks whether loading the DLL was successful
  if(LibHandle <> 0) then
  begin
    try
       Pointer(GetTabConectados) := GetProcAddress(LibHandle, 'GetTabConectados');
       Pointer(Inet_NtoA) := GetProcAddress(LibHandle, 'Inet_NtoA');
       Pointer(Inet_Addr) := GetProcAddress(LibHandle, 'Inet_Addr');
       Pointer(vInitialize) := GetProcAddress(LibHandle, 'vInitialize');
       Pointer(tc_startserver) := GetProcAddress(LibHandle, 'tc_startserver');
       Pointer(dll_version) := GetProcAddress(LibHandle, 'dll_version');
       Pointer(bTerminate) := GetProcAddress(LibHandle, 'bTerminate');
       Pointer(bSendDisplayMsg) := GetProcAddress(LibHandle, 'bSendDisplayMsg');
       Pointer(bSendProdNotFound) := GetProcAddress(LibHandle, 'bSendProdNotFound');
       Pointer(bSendProdPrice) := GetProcAddress(LibHandle, 'bSendProdPrice');
       Pointer(bReceiveBarcode) := GetProcedureAddress(LibHandle, 'bReceiveBarcode');

    except
      fError := true;
      fMenssage := 'Erro ao carregar lib';
    end;
  end;
end;



function TVP240W.AtualizaEquipamentos(): integer;
var
  posicao : integer;
  IdxLista: integer;
  sIP : PChar;
  IP : AnsiString;
  info : string;
  resultado : integer;
begin
  resultado := 0;
  if (@GetTabConectados <> nil) then
  begin
    TabTerms := GetTabConectados(1); (*Atualiza listagem de equipamentos*)
    FlstEquipamentos.Clear;

    for posicao:= 0 to TabTerms.NumSockConec -1 do
    begin
      if(TabTerms.TabIP[posicao] <> 0) then
      begin
        sIP := Inet_NtoA(TabTerms.TabIP[posicao]);
        IP := AnsiString(sIP);
        //ShowMessage(IP);
        FvetEquipamentos[posicao].ID_Ip := TabTerms.TabIP[posicao];
        //FvetEquipamentos[posicao].Ip := CaptINET(TabTerms.TabIP[posicao]);

        FvetEquipamentos[posicao].Ip := IP;
        FvetEquipamentos[posicao].Socket:= TabTerms.NumSockConec;
        FvetEquipamentos[posicao].Nbr:=0;
        FlstEquipamentos.AddObject(FvetEquipamentos[posicao].Ip,TObject(posicao));

      end;
    end;
    resultado := posicao;
  end;
  result := FlstEquipamentos.Count; (*Retorna a quantidade de elementos registrados*)


end;

function TVP240W.FindIP(ID_IP: DWord; var posicao: integer): String;
var
  fposicao : integer;
  resultado : string;
begin
  resultado := '';
  posicao := -1;
  for fposicao := 0 to FlstEquipamentos.Count-1 do
  begin
    if(FvetEquipamentos[fposicao].ID_Ip= ID_IP) then
    begin
      posicao := fposicao;
      resultado := FvetEquipamentos[fposicao].Ip;
    end;
  end;
  result := resultado;
end;

function TVP240W.getASK(): integer;
var
 //ID_Socket:  Word;
 //stBarCode: stAddress;
 ip : string;
 posicao : integer;
 BarCode: PAnsiChar;
 ID_Socket:  Word;
 resultado : integer;
 ID_IP : Dword;
 Nbr : integer;

begin
  IF(bReceiveBarcode <> NIL) THEN
  BEGIN
    (*Capturou o barcode*)
    BarCode := bReceiveBarcode(ID_Ip, ID_Socket,Nbr);
    if(BarCode<>'')  then
    begin
      ip := FindIP(ID_Ip, posicao);
      (*Acha o Indice*)
      if(posicao <> -1) then
      begin
         (*Captura dados solicitados*)
         FvetEquipamentos[posicao].lastbarcode:= AnsiString(Barcode);
         FvetEquipamentos[posicao].Nbr:=Nbr;
         if(@FResponseFunction<> nil) then  (*Chama Callback*)
         begin
              FResponseFunction(posicao,AnsiString(Barcode) );
         end;
      end;
      resultado := 1;
    end
    else
    begin
       resultado := 0;
    end;
    result := resultado;

  end;

end;

procedure TVP240W.SendMsg(IP : string; port : integer; Linha1, Linha2: string; Time : integer);
var
 ID: stAddress;
 posicao : integer;
begin
  (*Busca o Equipamento que gerou a chamada*)
  if (FlstEquipamentos.Find(IP,posicao)) then
  begin
    bSendDisplayMsg(FvetEquipamentos[posicao].ID_Ip,
                  PChar(Linha1),
                  PChar(Linha2),
                  Time
                  );


  end;
end;

procedure TVP240W.SendAllMsg(Linha1, Linha2: string; Time: integer);
var
 posicao : integer;
 ID: stAddress;
begin
  for posicao:= 0 to FlstEquipamentos.Count-1 do   (*Varre todos os devices*)
  begin
    (*Envia os dados para os devices*)
    bSendDisplayMsg(FvetEquipamentos[posicao].ID_Ip,
                    PChar(Linha1),
                    PChar(Linha2),
                    Time
                    );

  end;
end;

procedure TVP240W.SendPrice(ID_Ip: dword; NameProd: String; PriceProd: String);
begin
   bSendProdPrice(ID_Ip, PAnsiChar(NameProd) , pansichar(PriceProd));
end;

procedure TVP240W.SendPrice(posicao: integer; NameProd: String; PriceProd: String);
var
   ID_Ip : Dword;
begin
   ID_Ip:=GetID_IP(posicao);
   bSendProdPrice(ID_Ip, PAnsiChar(NameProd) , pansichar(PriceProd));
end;

procedure TVP240W.SendNotPrice(ID_Ip: dword; NameProd: String);
begin

    bSendProdNotFound(ID_Ip);
end;

function TVP240W.GetID_IP(indice: integer): DWord;
begin
  if (FlstEquipamentos.count >= indice+1) then
  begin
       result := FvetEquipamentos[indice].ID_Ip;

  end
  else
  begin
    result := -1;
  end;

end;

function TVP240W.GetIP(indice: integer): AnsiString;
begin
  if (FlstEquipamentos.count >= indice+1) then
  begin
       result := FvetEquipamentos[indice].Ip;
  end
  else
  begin
    result := '';
  end;
end;

function TVP240W.GetPort(indice: integer): integer;
begin
    result := FvetEquipamentos[indice].Socket;
end;

function TVP240W.GetLastBarcode(indice: integer): string;
begin
  result := FvetEquipamentos[indice].lastbarcode;
end;

function TVP240W.GetLastNbr(indice: integer): integer;
begin
  result := FvetEquipamentos[indice].Nbr;
end;

function TVP240W.GetID_IP2IP(IP: String; var ID_IP: DWORD): integer;
var
 posicao : integer;
 contador : integer;

begin
  posicao := -1;
  for contador:= 0 to FlstEquipamentos.Count-1 do   (*Varre todos os devices*)
  begin
    if(IP= FvetEquipamentos[contador].Ip) then
    begin
      ID_IP := FvetEquipamentos[contador].ID_Ip;
      posicao := contador;
    end;
  end;
  result := posicao;
end;

function TVP240W.GetPosicao(IP: String): Integer;
var
 posicao : integer;
 contador : integer;
begin
  posicao := -1;
  for contador:= 0 to FlstEquipamentos.Count-1 do   (*Varre todos os devices*)
  begin
    if(IP= FvetEquipamentos[contador].Ip) then
    begin
       posicao := contador;
    end;
  end;
  result := posicao;
end;



function TVP240W.getListEquipamentos: integer;
begin

  result := AtualizaEquipamentos();

end;

function TVP240W.FGetCountItens: integer;
begin
     result := FlstEquipamentos.Count;
end;





procedure TVP240W.setResponseFunction(AValue: TResponseFunction);
begin
  if FResponseFunction=AValue then Exit;
     FResponseFunction:=AValue;
end;

//------------------------------------------------------------------------------




end.

