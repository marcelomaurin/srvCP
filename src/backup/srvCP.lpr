program srvCP;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, main, vp240W, CPGENERICO, udmbase, Setup, database, funcoes, setmain,
  registro, zcomponent, lnetbase, lnetvisual, TEMSOLUCAO, devices, split
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(Tfrmmain, frmmain);
  Application.CreateForm(TfrmSplit, frmSplit);
  Application.Run;
end.

