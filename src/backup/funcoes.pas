unit funcoes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

Function RetiraInfo(Value : string): string;
function BuscaChave( lista : TStringList; Ref: String; var posicao:integer): boolean;
function iif(condicao : boolean; verdade : variant; falso: variant):variant;
function CaptINET( nro : DWORD) : String;

implementation

function iif(condicao : boolean; verdade : variant; falso: variant):variant;
begin
     if condicao then
     begin
          result := verdade;
     end
     else
     begin
       result := falso
     end;
end;

//Retira o bloco de informação
Function RetiraInfo(Value : string): string;
var
  posicao : integer;
  resultado : string;
begin
     resultado := '';
     posicao := pos(':',value);
     if(posicao >-1) then
     begin
          resultado := copy(value,posicao+1,length(value));
     end;
     result := resultado;
end;

function BuscaChave( lista : TStringList; Ref: String; var posicao:integer): boolean;
var
  contador : integer;
  maximo : integer;
  item : string;
  indo : integer;
  resultado : boolean;
begin
     maximo := lista.Count-1;
     resultado := false;
     for contador := 0 to maximo do
     begin
       item := lista.Strings[contador];
       indo := pos(Ref,item);
       if (indo > 0) then
       begin
            posicao := contador;
            resultado := true;
            break;
       end;
     end;
     result := resultado;
end;

function CaptINET( nro : DWORD) : String;
var
  ip01, ip02, ip03, ip04  : byte;
begin
  ip01 := ($FF and nro);
  ip02 := ($FF00 and nro)  shr 8;
  ip03 := ($FF0000 and nro)  shr 16;
  ip04 := ($FF000000 and nro)  shr 32;
  result := inttostr(ip01) + '.' + inttostr(ip02) + '.' + inttostr(ip03) + '.' + inttostr(ip04)
end;

end.


