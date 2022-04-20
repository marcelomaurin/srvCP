unit CPGENERICO;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, VP240W;

type
  TTypeCP = (TypeCP_VP240W);


TYPE

{ TCPGENERICO }
 TCPGENERICO = class(TOBJECT)
  FTypeCP : TTypeCP;
  FVP240W :TVP240W;
  FVERSAO : String;
  FlstEquipamento : TStringlist;
  private
   function getcountEquipamentos: integer;
   procedure CarregaLib();
   function GetVersao : string;
   function getlstEquipamento(): TStringlist;
  public
    constructor Create(Tipo : TTypeCP);
    procedure AtualizaEquipamentos();
    property lstEquipamento : TStringList read getlstEquipamento;
    property countEquipamentos : integer read getcountEquipamentos;
    property VERSAO : String read GetVersao;
end;

implementation

{ TCPGENERICO }

constructor TCPGENERICO.Create(Tipo: TTypeCP);
begin
  FTypeCP := tipo;
  FlstEquipamento := TStringList.create();
  FlstEquipamento.Clear;
  CarregaLIB();
end;

procedure TCPGENERICO.AtualizaEquipamentos();
begin
  if (FTypeCP = TypeCP_VP240W) then
  begin
     FVP240W.AtualizaEquipamentos();
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

function TCPGENERICO.getlstEquipamento: TStringlist;
begin

end;

function TCPGENERICO.getcountEquipamentos: integer;
begin
    result := FlstEquipamento.Count;
end;

end.

