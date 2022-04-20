unit vp240W;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, windows;

const
  //ALERTAS
  ERRO_SRV    = 'Erro inicializando servidor.';
  START_SRV   = 'Servidor inicializado com sucesso.';
  STOP_SRV    = 'Servidor interrompido.';




type TIPV4 = record
  d,c,b,a: byte;
end;

type stAddress = record
  Ip: string;
  Socket: Word;
end;

type
  TTABSOCK = record
    TabSock: array[0..1023] of integer;
    TabIP: array[0..1023] of DWORD;
    NumSockConec: integer;
end;


type

{ TVP240W }

TVP240W = class(TObject)
  FVersion : DWORD;
  FTabTerms: TTABSOCK;
  FlstEquipamentos : TStringList;
  LibHandle : THandle;
private
  TabTerms: TTABSOCK;
  function getListEquipamentos(): TStringlist;
public
  constructor Create();
  destructor destroy();
  procedure LoadLib();
  procedure AtualizaEquipamentos();
  PROPERTY VERSAO : DWORD read FVersion;
  property lstEquipamentos : TStringList read getListEquipamentos;
end;

//------------------------------------------------------------------------------
//function  GetTabConectados(nada: Integer): TTABSOCK; stdcall; far; external 'VP.dll';
TGetTabConectados = function(nada: Integer): TTABSOCK; stdcall;
//function Inet_NtoA(nIP: DWORD): PChar ; far; stdcall; external 'VP.dll';
TInet_NtoA = function(nIP: DWORD): PChar ; far; stdcall;
//procedure vInitialize; stdcall; far; external 'VP.dll';
TvInitialize = procedure(); stdcall;
//function tc_startserver: Integer; stdcall; far; external 'VP.dll';
Ttc_startserver = function(): Integer; stdcall;
//function dll_version: DWORD; stdcall; far; external 'VP.dll';
Tdll_version = function() : DWORD; stdcall;
//function bTerminate: Boolean; far; stdcall; external 'VP.dll';
TbTerminate = function() : Boolean; stdcall;
//function bSendDisplayMsg(ID: Integer; Linha1: PChar; Linha2: Pchar; Tempo: Integer): Boolean; stdcall; far; external 'VP.dll';
TbSendDisplayMsg = function(ID: Integer; Linha1: PChar; Linha2: Pchar; Tempo: Integer): Boolean; stdcall;
//function bSendProdNotFound(ID: Integer): Boolean; stdcall; far; external 'VP.dll';
TbSendProdNotFound = function(ID: Integer): Boolean; stdcall;
//function bSendProdPrice(ID: Integer; var NameProd: PChar; var PriceProd : PChar): Boolean; stdcall; far; external 'VP.dll';
TbSendProdPrice = function(ID: Integer; var NameProd: PChar; var PriceProd : PChar): Boolean; stdcall;
//function bReceiveBarcode(var stAddress; var BarCode: PChar): Boolean; stdcall; far; external 'VP.dll';
TbReceiveBarcode = function(var stAddress; var BarCode: PChar): Boolean; stdcall;

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


implementation


{ TVP240W }

constructor TVP240W.Create();
begin
  LoadLib();
  if @vInitialize <> nil then
     vInitialize;
  if @dll_version <> nil then
     FVersion := dll_version();
  FlstEquipamentos := TStringList.create();
  FlstEquipamentos.Clear;

end;

destructor TVP240W.destroy();
begin

end;

procedure TVP240W.LoadLib;
begin

  // Get the handle of the library to be used
  LibHandle := LoadLibrary(PChar(ExtractFilePath(ApplicationName)+'VP.dll'));
  // Checks whether loading the DLL was successful
  if LibHandle <> 0 then
  begin
       Pointer(GetTabConectados) := GetProcAddress(LibHandle, 'GetTabConectados');
       Pointer(Inet_NtoA) := GetProcAddress(LibHandle, 'Inet_NtoA');
       Pointer(vInitialize) := GetProcAddress(LibHandle, 'vInitialize');
       Pointer(tc_startserver) := GetProcAddress(LibHandle, 'tc_startserver');
       Pointer(dll_version) := GetProcAddress(LibHandle, 'dll_version');
       Pointer(bTerminate) := GetProcAddress(LibHandle, 'bTerminate');
       Pointer(bSendDisplayMsg) := GetProcAddress(LibHandle, 'bSendDisplayMsg');
       Pointer(bSendProdNotFound) := GetProcAddress(LibHandle, 'bSendProdNotFound');
       Pointer(bSendProdPrice) := GetProcAddress(LibHandle, 'bSendProdPrice');
       Pointer(bReceiveBarcode) := GetProcAddress(LibHandle, 'bReceiveBarcode');
  end;
end;



procedure TVP240W.AtualizaEquipamentos();
begin

end;

function TVP240W.getListEquipamentos: TStringlist;
var
  i : integer;
  IdxLista: integer;
  sIP : string;
begin
  if (@GetTabConectados <> nil) then
  begin
    TabTerms := GetTabConectados(1); (*Atualiza listagem de equipamentos*)
    FlstEquipamentos.Clear;

    for i:= 0 to TabTerms.NumSockConec-1 do
    begin
      if TabTerms.TabIP[i] <> 0 then
      begin
        sIP:= Inet_NtoA(TabTerms.TabIP[i]);
        FlstEquipamentos.AddObject(String(sIP),TObject(TabTerms.TabSock[i]));
      end;
    end;
  end;
  result :=  FlstEquipamentos;
end;

//------------------------------------------------------------------------------




end.

