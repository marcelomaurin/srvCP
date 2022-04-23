unit CPGENERICO;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, VP240W;

type
  TTypeCP = (TypeCP_VP240W);

type
  TGenericResponseFunction = procedure(IP : String; BarCode : String);

TYPE

{ TCPGENERICO }
 TCPGENERICO = class(TOBJECT)
  FTypeCP : TTypeCP;
  FVP240W :TVP240W;
  FVERSAO : String;
  FlstEquipamento : TStringlist;
  private
   FGenericResponseFunction: TResponseFunction;
   function getcountEquipamentos: integer;
   procedure CarregaLib();
   function GetVersao : string;
   function getlstEquipamento: TStrings;
   procedure setGenericResponseFunction(AValue: TGenericResponseFunction);
  public
    constructor Create(Tipo : TTypeCP);
    function getASK(): string;
    procedure AtualizaEquipamentos();
    property lstEquipamento : TStrings read getlstEquipamento;
    property countEquipamentos : integer read getcountEquipamentos;
    property VERSAO : String read GetVersao;
    procedure SendMsg(IP : string; port : integer; Linha1, Linha2: string; Time : integer);
    procedure SendAllMsg( Linha1, Linha2 : string; Time : integer);
    property ResponseFunction : TGenericResponseFunction read FGenericResponseFunction write setGenericResponseFunction;
end;

implementation

{ TCPGENERICO }

constructor TCPGENERICO.Create(Tipo: TTypeCP);
begin
  FTypeCP := tipo;
  FGenericResponseFunction := nil;
  FlstEquipamento := TStringList.create();
  FlstEquipamento.Clear;
  CarregaLIB();
end;

function TCPGENERICO.getASK(): string;
var
 stBarCode: stAddress;
 BarCode: PChar;
begin
  if (FTypeCP = TypeCP_VP240W) then
  begin
       FVP240W.getASK();
  end;


end;

procedure TCPGENERICO.AtualizaEquipamentos();
begin
  if (FTypeCP = TypeCP_VP240W) then
  begin
     FVP240W.AtualizaEquipamentos();
  end;

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

procedure TCPGENERICO.CarregaLib();
begin
  if (FTypeCP = TypeCP_VP240W) then
  begin
   FVP240W := TVP240W.Create();
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
  end;
  result := info;
end;

(*Retorna a lista de equipamentos*)
function TCPGENERICO.getlstEquipamento: TStrings;
var
  auxiliar : TStrings;
begin
  auxiliar := TStrings.create();
  if (FTypeCP = TypeCP_VP240W) then
  begin
       auxiliar := FVP240W.lstEquipamentos;
  end;
  result := auxiliar;

end;


procedure TCPGENERICO.setGenericResponseFunction(
  AValue: TGenericResponseFunction);
begin
  if FGenericResponseFunction=AValue then Exit;
     FGenericResponseFunction:=AValue;
  if (FTypeCP = TypeCP_VP240W) then
  begin
      FVP240W.ResponseFunction:= FGenericResponseFunction;
  end;
end;

function TCPGENERICO.getcountEquipamentos: integer;
begin
    result := FlstEquipamento.Count;
end;

end.

