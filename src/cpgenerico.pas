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
  public
    constructor Create(Tipo : TTypeCP);
    procedure AtualizaEquipamentos();

    property lstEquipamento : TStringList read FlstEquipamento;
    property countEquipamentos : integer read getcountEquipamentos;



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

function TCPGENERICO.getcountEquipamentos: integer;
begin
    result := FlstEquipamento.Count;
end;

end.

