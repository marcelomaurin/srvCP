unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Menus, CPGENERICO, Setup, udmbase, setmain, registro, database, devices,
  split, log;

Const
  Version : double = 0.4;

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
    miLog: TMenuItem;
    Separator1: TMenuItem;
    pmMenu: TPopupMenu;
    tmMonitor: TTimer;
    tmLeituras: TTimer;
    TrayIcon1: TTrayIcon;


    procedure btDataBaseClick(Sender: TObject);
    procedure btsetupClick(Sender: TObject);
    procedure btStartClick(Sender: TObject);
    procedure btStopClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure miLogClick(Sender: TObject);
    procedure tmLeiturasStopTimer(Sender: TObject);
    procedure tmLeiturasTimer(Sender: TObject);
    procedure tmMonitorTimer(Sender: TObject);
  private
    //FCPGENERICO : TCPGENERICO;
    F32bits : boolean; (*Aplicacao 32bits*)
    FActive : boolean;
    FProduto : String;
    FPreco : String;
    FBarcode : string;
    procedure SalvarContexto();
    procedure Versao();
    procedure AtivasrvCP();
    procedure DesativarsrvCP();
    procedure AtualizaListaTerminais();
    procedure VerificaBaseTerminal();


  public
    procedure LerBarcode(IP : String; BarCode : String);
    property Active : boolean read Factive;
    property Produto : String read FProduto;
    property Preco : string read FPreco;
    property Barcode : string read FBarcode;

  end;

var
  frmmain: Tfrmmain;

procedure LerBC(posicao : integer; BarCode : String);

implementation

{$R *.lfm}

{ Tfrmmain }

procedure Tfrmmain.btStartClick(Sender: TObject);
begin
  frmLog.Log('Start server');
  if (FSETMAIN.ModeloCP = integer(CVP240W)) then
  begin
       if F32bits then
       begin
          FCPGENERICO := TCPGENERICO.create(TypeCP_VP240W, FSETMAIN.PATHVP240W);
          FCPGENERICO.GenericResponseFunction:= @LerBC; (*CallBack*)
          //FCPGENERICO.SendAllMsg(FSETMAIN.Label1,FSETMAIN.Label2,2);
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
  frmSetup.edFileDatabase.text := FSETMAIN.Database;
  frmSetup.edDllDatabase.text := FSETMAIN.BancoDLL;
  frmSetup.edLabel1.text := FSETMAIN.Label1;
  frmSetup.edLabel2.text := FSETMAIN.Label2;

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
       frmLog.Log('Stop server');
  end;
end;

procedure Tfrmmain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if (FActive) then
  begin
       CanClose:= false;
       hide;
  end;
end;

procedure Tfrmmain.FormCreate(Sender: TObject);
begin
  frmSplit := TfrmSplit.create(self);
  FActive := false;
  Versao();
  frmSplit.show;
  frmLog := TfrmLog.Create(self);
  frmLog.Carregar();

  Application.ProcessMessages;
  sleep(2000);
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

  frmSplit.hide;

end;

procedure Tfrmmain.FormDestroy(Sender: TObject);
begin
  frmSplit.free();
  SalvarContexto();
  frmLog.Salvar();
  frmLog.Free;
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

procedure Tfrmmain.MenuItem2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure Tfrmmain.miLogClick(Sender: TObject);
begin
  frmLog.show();
end;

procedure Tfrmmain.tmLeiturasStopTimer(Sender: TObject);
begin

end;

procedure Tfrmmain.tmLeiturasTimer(Sender: TObject);
begin
  //Application.ProcessMessages;
  if (FSETMAIN.ModeloCP = integer(CVP240W)) then
  begin
    if(FCPGENERICO <> nil) then
    begin
       FCPGENERICO.getASK();
    end;

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
  frmSplit.lbversion.Caption:= FloatToStrF(Version, fffixed, 1,2);
end;

procedure Tfrmmain.AtivasrvCP();
begin

  tmMonitor.Enabled:= true;
  Sleep(4000); (*Aguarda inicializacao*)
  Application.ProcessMessages;
  (*Atualização de Lista de terminal*)
  AtualizaListaTerminais();
  tmLeituras.Enabled:=true;
  FActive:=true;
  TrayIcon1.Visible:=true;

end;

procedure Tfrmmain.DesativarsrvCP();
begin
  FActive:=false;
  tmLeituras.Enabled:=false;
  tmMonitor.Enabled:=False;
  TrayIcon1.Visible:=False;

end;

(*Atualiza a lista de equipamentos*)
procedure Tfrmmain.AtualizaListaTerminais();
var
  posicao: integer;
begin

   frmdevices.lbDevices.clear;
   if(FCPGENERICO<> nil) then
   begin
     FCPGENERICO.AtualizaEquipamentos();
     for posicao := 0 to FCPGENERICO.getcountEquipamentos-1 do
     begin
       frmdevices.lbDevices.AddItem(FCPGENERICO.GetIpEquipamento(posicao),tobject(posicao));
     end;
     frmLog.Log('Atualiza Terminais com '+ inttostr(FCPGENERICO.getcountEquipamentos)+ ' equipamento(s) encontrado(s).');
   end;
   VerificaBaseTerminal();

end;

(*Consulta  a base de terminais, verificando se existe alguma diferença*)
procedure Tfrmmain.VerificaBaseTerminal();
begin
    dmbase.VerificaBaseTerminal(frmdevices.lbDevices.Items);
end;


procedure Tfrmmain.LerBarcode(IP: String; BarCode: String);
var
  equipamento: integer;
  ID_Ip: DWORD;
begin
  //ShowMessage(ip);
  frmlog.Log('LerBarcode - IP:'+IP+ ' - Barcode:'+Barcode);
  if(FCPGENERICO <> nil) then
  begin
    if (FCPGENERICO.getcountEquipamentos()<>0)  then
    begin
      equipamento := FCPGENERICO.GetIDEquipamento(ip);

      frmlog.Log('LerBarcode - equipamento:'+inttostr(equipamento));

      if (equipamento <>-1) then (*Busca Equipamento*)
      begin
        if(dmBase.BuscaProduto(Barcode) = true) then (*Busca Produto*)
        begin
           FBarcode := dmBase.tbProdutos.FieldByName('ProdBARCODE').value;
           Fproduto := dmBase.tbProdutos.FieldByName('ProdNome').value;
           FPreco := dmBase.tbProdutos.FieldByName('PRODPRECO').value;

           frmlog.Log('LerBarcode - equipamento:'+Fproduto+ ' - Preco:'+FPreco);

           id_ip := FCPGENERICO.GetIDEquipamento(ip);

           frmlog.Log('LerBarcode - Produto:'+inttostr(equipamento));
           FCPGENERICO.SendPrice(ip, Fproduto , FPreco);
       end
       else
       begin
           FCPGENERICO.SendNotPrice(ip, 'Produto não encontrado');
       end;



      end;
    end;
  end;
end;


procedure LerBC(posicao: integer; BarCode: String);
var
  ip : ansistring;
begin
  ip := FCPGENERICO.GetIpEquipamento(posicao);
  frmlog.Log('LerBC - posicao:'+inttostr(posicao)+ ' - Barcode:'+Barcode);
  frmmain.LerBarcode(ip, BarCode);

end;


end.

