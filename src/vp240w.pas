unit vp240W;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

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
private
  function getListEquipamentos(): TStringlist;
public
  constructor Create();
  destructor destroy();
  procedure AtualizaEquipamentos();
  PROPERTY VERSAO : DWORD read FVersion;
  property lstEquipamentos : TStringList read getListEquipamentos;




end;

implementation



//------------------------------------------------------------------------------
function  GetTabConectados(nada: Integer): TTABSOCK; stdcall; far; external 'VP.dll';
function Inet_NtoA(nIP: DWORD): PChar ; far; stdcall; external 'VP.dll';
procedure vInitialize; stdcall; far; external 'VP.dll';
function tc_startserver: Integer; stdcall; far; external 'VP.dll';
function dll_version: DWORD; stdcall; far; external 'VP.dll';
function bTerminate: Boolean; far; stdcall; external 'VP.dll';
function bSendDisplayMsg(ID: Integer; Linha1: PChar; Linha2: Pchar; Tempo: Integer): Boolean; stdcall; far; external 'VP.dll';
function bSendProdNotFound(ID: Integer): Boolean; stdcall; far; external 'VP.dll';
function bSendProdPrice(ID: Integer; var NameProd: PChar; var PriceProd : PChar): Boolean; stdcall; far; external 'VP.dll';
function bReceiveBarcode(var stAddress; var BarCode: PChar): Boolean; stdcall; far; external 'VP.dll';

{ TVP240W }

constructor TVP240W.Create();
begin
  vInitialize;
  FVersion := dll_version;
  FlstEquipamentos := TStringList.create();
  FlstEquipamentos.Clear;

end;

destructor TVP240W.destroy();
begin

end;

procedure TVP240W.AtualizaEquipamentos();
begin

end;

function TVP240W.getListEquipamentos: TStringlist;
begin
  result :=  FlstEquipamentos;
end;

//------------------------------------------------------------------------------




end.

