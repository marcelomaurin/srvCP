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


type
  TResponseFunction = procedure(IP : String; BarCode : String);


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
  FlstEquipamentos : TStrings;
  LibHandle : THandle;


private
  TabTerms: TTABSOCK;
  FResponseFunction: TResponseFunction;
  function getListEquipamentos: TStrings;
  procedure setResponseFunction(AValue: TResponseFunction);
public
  constructor Create();
  destructor destroy();
  procedure LoadLib();
  procedure AtualizaEquipamentos();
  function getASK(): string;
  procedure SendMsg(IP : string; port : integer; Linha1, Linha2: string; Time : integer);
  procedure SendAllMsg( Linha1, Linha2 : string; Time : integer);
  PROPERTY VERSAO : DWORD read FVersion;
  property lstEquipamentos : TStrings read getListEquipamentos;
  property ResponseFunction : TResponseFunction read FResponseFunction write setResponseFunction;


end;

//------------------------------------------------------------------------------
//function  GetTabConectados(nada: Integer): TTABSOCK; stdcall; far; external 'VP.dll';
TGetTabConectados = function(nada: Integer): TTABSOCK; stdcall;   far;
//function Inet_NtoA(nIP: DWORD): PChar ; far; stdcall; external 'VP.dll';
TInet_NtoA = function(nIP: DWORD): PChar ; far; stdcall; far;
//procedure vInitialize; stdcall; far; external 'VP.dll';
TvInitialize = procedure(); stdcall;   far;
//function tc_startserver: Integer; stdcall; far; external 'VP.dll';
Ttc_startserver = function(): Integer; stdcall;  far;
//function dll_version: DWORD; stdcall; far; external 'VP.dll';
Tdll_version = function() : DWORD; stdcall;  far;
//function bTerminate: Boolean; far; stdcall; external 'VP.dll';
TbTerminate = function() : Boolean; stdcall;  far;
//function bSendDisplayMsg(ID: Integer; Linha1: PChar; Linha2: Pchar; Tempo: Integer): Boolean; stdcall; far; external 'VP.dll';
TbSendDisplayMsg = function(ID: Integer; Linha1: PChar; Linha2: Pchar; Tempo: Integer): Boolean; stdcall;  far;
//function bSendProdNotFound(ID: Integer): Boolean; stdcall; far; external 'VP.dll';
TbSendProdNotFound = function(ID: Integer): Boolean; stdcall; far;
//function bSendProdPrice(ID: Integer; var NameProd: PChar; var PriceProd : PChar): Boolean; stdcall; far; external 'VP.dll';
TbSendProdPrice = function(ID: Integer; var NameProd: PChar; var PriceProd : PChar): Boolean; stdcall; far;
//function bReceiveBarcode(var stAddress; var BarCode: PChar): Boolean; stdcall; far; external 'VP.dll';
TbReceiveBarcode = function(var stAddress; var BarCode: PChar): Boolean; stdcall; far;

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
  FResponseFunction := nil;
  LoadLib();
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

procedure TVP240W.LoadLib();
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
var
  i : integer;
  IdxLista: integer;
  sIP : PChar;
  info : string;
begin
  if (@GetTabConectados <> nil) then
  begin
    TabTerms := GetTabConectados(1); (*Atualiza listagem de equipamentos*)
    FlstEquipamentos.Clear;
    //showmessage(inttostr(TabTerms.NumSockConec));

    for i:= 0 to TabTerms.NumSockConec-1 do
    begin
      if(TabTerms.TabIP[i] <> 0) then
      begin
        //sIP:= Inet_NtoA(TabTerms.TabIP[i]);
        info := CaptINET(TabTerms.TabIP[i]);
        //showmessage(String(sIP));
        //FlstEquipamentos.AddObject(String(sIP),TObject(TabTerms.TabSock[i]));
        FlstEquipamentos.AddObject(info,TObject(TabTerms.TabSock[i]));
      end;
    end;
  end;

end;

function TVP240W.getASK(): string;
var
 stBarCode: stAddress;
 BarCode: PChar;
 info : string;
begin
  //BarCode := pchar(info);
  //stBarCode := stAddress;
  IF (@bReceiveBarcode <> NIL) THEN
  BEGIN
    if ( bReceiveBarcode(stBarCode.Socket, BarCode ))  then
    begin
       if(@FResponseFunction<> nil) then  (*Callback*)
       begin
            stBarCode.Socket.ToString;
            FResponseFunction(stBarCode.ip+':'+inttostr(stBarCode.Socket),String(BarCode));
       end;
    end;

  end;

end;

procedure TVP240W.SendMsg(IP : string; port : integer; Linha1, Linha2: string; Time : integer);
var
 ID: stAddress;
begin
  id.Ip :=IP;
  id.Socket := port;
  bSendDisplayMsg(ID.Socket,
                  PChar(Linha1),
                  PChar(Linha2),
                  Time
                  );

end;

procedure TVP240W.SendAllMsg(Linha1, Linha2: string; Time: integer);
var
 a : integer;
 ID: stAddress;
begin

  for a:= 0 to FlstEquipamentos.Count-1 do
  begin
    ID.IP := FlstEquipamentos.Strings[a];
    ID.Socket:= Integer(FlstEquipamentos.Objects[a]);
    bSendDisplayMsg(ID.Socket,
                    PChar(Linha1),
                    PChar(Linha2),
                    Time
                    );
  end;

end;



function TVP240W.getListEquipamentos: TStrings;
begin
  AtualizaEquipamentos();
  result :=  FlstEquipamentos;
end;



procedure TVP240W.setResponseFunction(AValue: TResponseFunction);
begin
  if FResponseFunction=AValue then Exit;
     FResponseFunction:=AValue;
end;

//------------------------------------------------------------------------------




end.

