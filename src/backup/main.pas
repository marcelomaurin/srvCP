unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Menus, CPGENERICO, Setup, udmbase, setmain, registro, database, devices;

Const
  Version : double = 0.2;

type

  { Tfrmmain }

  Tfrmmain = class(TForm)

    btStart: TButton;
    btStop: TButton;
    btsetup: TButton;
    btDataBase: TButton;
    cbType: TComboBox;
    lbVersao: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Separator1: TMenuItem;
    pmMenu: TPopupMenu;
    tmMonitor: TTimer;
    tmLeituras: TTimer;
    TrayIcon1: TTrayIcon;

    procedure btDataBaseClick(Sender: TObject);
    procedure btsetupClick(Sender: TObject);
    procedure btStartClick(Sender: TObject);
    procedure btStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure tmLeiturasStopTimer(Sender: TObject);
    procedure tmMonitorTimer(Sender: TObject);
  private
    FCPGENERICO : TCPGENERICO;
    F32bits : boolean; (*Aplicacao 32bits*)
    procedure SalvarContexto();
    procedure Versao();
    procedure AtivasrvCP();
    procedure DesativarsrvCP();
    procedure AtualizaListaTerminais();
    procedure VerificaBaseTerminal();
    procedure LerBarcode(IP : String; BarCode : String);
  public

  end;

var
  frmmain: Tfrmmain;

implementation

{$R *.lfm}

{ Tfrmmain }

procedure Tfrmmain.btStartClick(Sender: TObject);
begin
  if (FSETMAIN.ModeloCP = integer(CVP240W)) then
  begin
       if F32bits then
       begin
          FCPGENERICO := TCPGENERICO.create(TypeCP_VP240W);
          FCPGENERICO.ResponseFunction:= pointer(LerBarcode); (*CallBack*)
          TrayIcon1.Visible:=true;
          lbVersao.Caption:= 'LIB:'+ FCPGENERICO.VERSAO;
          AtivasrvCP();
       end
       else
       begin
          ShowMessage('This device not run in 64 bits system');
       end;
  end;
end;

procedure Tfrmmain.btsetupClick(Sender: TObject);
begin
  frmSetup := TfrmSetup.Create(self);
  (* Transfere dados *)
  frmSetup.cbTipo.ItemIndex :=  FSETMAIN.TipoCP;
  frmSetup.cbModelo.ItemIndex :=  FSETMAIN.ModeloCP;
  frmSetup.edFileVP240W.Text:= FSETMAIN.PATHVP240W;

  frmSetup.showmodal();
  frmSetup := nil;
end;

procedure Tfrmmain.btDataBaseClick(Sender: TObject);
begin

  frmDatabase.Showmodal();

end;

procedure Tfrmmain.btStopClick(Sender: TObject);
begin
  if (FCPGENERICO <> nil) then
  begin
       FCPGENERICO.Destroy;
       FCPGENERICO := nil;
       TrayIcon1.Visible:=false;
       Versao();
       DesativarsrvCP();
  end;
end;

procedure Tfrmmain.FormCreate(Sender: TObject);
begin
  Versao();
  {$ifdef CPU32}
  F32bits := true;
  {$endif}
  {$ifdef CPU64}
  F32bits := false;
  {$endif}
  FCPGENERICO := nil;
  Fsetmain := TSetmain.create();
  self.left := Fsetmain.posx;
  self.top := fsetmain.posy;
  frmRegistrar := TfrmRegistrar.Create(self);
  frmRegistrar.Identifica();
  dmbase := Tdmbase.create(self);
  dmbase.conectar();
  frmDatabase := TfrmDatabase.create(Self);
  frmdevices := Tfrmdevices.create(Self);

end;

procedure Tfrmmain.FormDestroy(Sender: TObject);
begin
  SalvarContexto();
  TrayIcon1.Visible:=false;
  frmRegistrar.free;
  Fsetmain.free();
  frmDatabase.free;
  dmbase.Desconectar();
  dmbase.free;

end;

procedure Tfrmmain.MenuItem1Click(Sender: TObject);
begin
  frmdevices.show();
end;

procedure Tfrmmain.tmLeiturasStopTimer(Sender: TObject);
begin
  if (FCPGENERICO <> nil) then
  begin
       FCPGENERICO.getASK();

  end;
end;

procedure Tfrmmain.tmMonitorTimer(Sender: TObject);
begin
    (*Atualização de Lista de terminal*)
    AtualizaListaTerminais();

end;

procedure Tfrmmain.SalvarContexto();
begin
    FSETMAIN.posx := self.left;
    FSetMain.posy := self.top;
    FSETMAIN.SalvaContexto();
end;

procedure Tfrmmain.Versao();
begin
  lbVersao.Caption:= 'Prd:'+FloatToStrF(Version, fffixed, 1,2);
end;

procedure Tfrmmain.AtivasrvCP();
begin
  tmMonitor.Enabled:= true;
  Sleep(4000); (*Aguarda inicializacao*)
  Application.ProcessMessages;
  tmLeituras.Enabled:=true;
end;

procedure Tfrmmain.DesativarsrvCP();
begin
  tmLeituras.Enabled:=false;
  tmMonitor.Enabled:=False;
end;

procedure Tfrmmain.AtualizaListaTerminais();
begin
   frmdevices.lbDevices.clear;
   frmdevices.lbDevices.Items := FCPGENERICO.lstEquipamento;
   VerificaBaseTerminal();

end;

(*Consulta  a base de terminais, verificando se existe alguma diferença*)
procedure Tfrmmain.VerificaBaseTerminal();
begin
    dmbase.VerificaBaseTerminal(frmdevices.lbDevices.Items);
end;

procedure Tfrmmain.LerBarcode(IP: String; BarCode: String);
begin
  ShowMessage(IP);

end;



end.

