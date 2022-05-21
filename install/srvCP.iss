; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "srvCP"
#define MyAppVersion "0.5"
#define MyAppPublisher "maurinsoft"
#define MyAppURL "http://maurinsoft.com.br"
#define MyAppExeName "srvCP.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{15E35226-C1B9-4348-B173-8186F192F1D1}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DisableProgramGroupPage=yes
OutputBaseFilename=Install_srvSC_05
Compression=lzma
SolidCompression=yes

 

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked


[Types]
Name: "FULL"; Description:  {cm:T_FULL}
Name: "TANCA"; Description:  {cm:T_TANCA}
Name: "srvCP"; Description: {cm:T_srvCP}
Name: "sqlite32"; Description: {cm:T_sqlite32}
Name: "sqlite64"; Description: {cm:T_sqlite64}
Name: "tools"; Description: {cm:T_tools}
Name: "db"; Description: {cm:T_db}
Name: "import"; Description: {cm:T_import}

[Components]
Name: "Full"; Description: "Todos os arquivos do srvCP"; Types: FULL srvCP Tanca sqlite32 sqlite64 tools db import;
Name: "srvCP"; Description: "Arquivos do srvCP"; Types: FULL srvCP;
Name: "Tanca"; Description: "Instala��o dos componenentes do Tanca"; Types: FULL TANCA;
Name: "sqlite32"; Description: "Instala��o dos componenentes do sqlite32"; Types: FULL sqlite32;
Name: "sqlite64"; Description: "Instala��o dos componenentes do sqlite64"; Types: FULL sqlite64;
Name: "tools"; Description: "Instala��o dos componenentes do sqlite64"; Types: FULL tools;
Name: "db"; Description: "Instala��o dos componenentes do sqlite64"; Types: FULL db;
Name: "import"; Description: "Instala��o dos componenentes do sqlite64"; Types: FULL import;


[CustomMessages]
T_FULL=FULL
TD_FULL=INSTALACAO COM TUDO
T_Tanca=Tanca
TD_Tanca=Instala��o padr�o da dll com drivers do TANCA VP-240W 
T_srvCP=srvCP
TD_srvCP=Instala��o padr�o do srvCP sem drivers
T_sqlite32=sqlite32
TD_sqlite32=Instala��o dos componentes sqlite de conexao
T_sqlite64=sqlite64
TD_sqlite64=Instala��o dos componentes sqlite64 de conexao
T_tools=sqlite-tools-win32
TD_tools=Instala��o das ferramentas do Sqlite tools
T_db=database
TD_db=Banco de dados padr�o
T_import=import
TD_import=Espaco de banco de dados de importa��o de dados



; [Setup], [Files] etc sections go here
[Code]
#define MSIDT_CustomType "Whatever"
//include "DescriptiveTypes.isi"
//procedure InitializeWizard();
//begin
// InitializeDescriptiveTypes();
//end;



[Files]
Source: "D:\projetos\maurinsoft\srvCP\srvCP.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\projetos\maurinsoft\srvCP\VP_v3.dll"; DestDir: "{app}"; Components: Tanca ;
Source: "D:\projetos\maurinsoft\srvCP\sqlite32\sqlite3.dll"; DestDir: "{app}\sqlite32"; Components: sqlite32 ;
Source: "D:\projetos\maurinsoft\srvCP\sqlite32\sqlite3.def"; DestDir: "{app}\sqlite32"; Components: sqlite32 ;
Source: "D:\projetos\maurinsoft\srvCP\sqlite64\sqlite3.dll"; DestDir: "{app}\sqlite64"; Components: sqlite64 ;
Source: "D:\projetos\maurinsoft\srvCP\sqlite64\sqlite3.def"; DestDir: "{app}\sqlite64"; Components: sqlite64 ;
Source: "D:\projetos\maurinsoft\srvCP\sqlite-tools-win32\sqlite3.exe"; DestDir: "{app}\sqlite-tools-win32"; Components: tools ;
Source: "D:\projetos\maurinsoft\srvCP\sqlite-tools-win32\sqldiff.exe"; DestDir: "{app}\sqlite-tools-win32"; Components: tools ;
Source: "D:\projetos\maurinsoft\srvCP\sqlite-tools-win32\sqlite3_analyzer.exe"; DestDir: "{app}\sqlite-tools-win32"; Components: tools ;
Source: "D:\projetos\maurinsoft\srvCP\db\srvCP.db"; DestDir: "{app}\db"; Components: db;
Source: "D:\projetos\maurinsoft\srvCP\db\srvCP.db"; DestDir: "{app}\import"; Components: import;
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

