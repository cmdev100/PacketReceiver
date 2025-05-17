unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdBaseComponent, IdComponent, IdUDPBase,
  IdUDPServer, Vcl.StdCtrls, Math, IdGlobal, IdSocketHandle, IdCustomTCPServer,
  IdTCPServer, IdContext, Vcl.ComCtrls;

type
  TMainForm = class(TForm)
    btnListen: TButton;
    IdUDPServer: TIdUDPServer;
    edtPort: TEdit;
    btnClear: TButton;
    lblPortTxt: TLabel;
    lblMessagesTxt: TLabel;
    rbUDP: TRadioButton;
    rbTCP: TRadioButton;
    IdTCPServer: TIdTCPServer;
    lvMessages: TListView;
    procedure btnListenClick(Sender: TObject);
    procedure IdUDPServerUDPRead(AThread: TIdUDPListenerThread;
      const AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure FormCreate(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure ServerTypeClick(Sender: TObject);
    procedure IdTCPServerExecute(AContext: TIdContext);
    procedure FormDestroy(Sender: TObject);
  private
    procedure StartServer(APort: Integer);
    procedure StopServer;
    procedure SaveSettings;
    procedure LoadSettings;
    procedure WriteMessage(AData: TIdBytes; const ASourceIP, AProtocol: string);
  public
  end;

var
  MainForm: TMainForm;

implementation

uses
  System.IniFiles, System.IOUtils;

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  LoadSettings;
  btnListen.Enabled := False;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  SaveSettings;
  StopServer;
end;

procedure TMainForm.btnClearClick(Sender: TObject);
begin
  lvMessages.Items.Clear;
end;

procedure TMainForm.btnListenClick(Sender: TObject);
begin
  if IdUDPServer.Active or IdTCPServer.Active then
  begin
    StopServer;
    btnListen.Caption := 'Start listen';
    rbUDP.Enabled := True;
    rbTCP.Enabled := True;
    edtPort.Enabled := True;
  end
  else
  begin
    var LPort: Integer;
    if TryStrToInt(edtPort.Text, LPort) and InRange(LPort, 0, 65535) then
    begin
      StartServer(LPort);
      edtPort.Enabled := False;
      rbUDP.Enabled := False;
      rbTCP.Enabled := False;
      btnListen.Caption := 'Stop listen';
    end
    else
      ShowMessage('The port setting is incorrect.');
  end;
end;

procedure TMainForm.IdTCPServerExecute(AContext: TIdContext);
begin
  var LData: TIdBytes;
  AContext.Connection.IOHandler.CheckForDataOnSource(10);
  if not AContext.Connection.IOHandler.InputBufferIsEmpty then
  begin
    AContext.Connection.IOHandler.InputBuffer.ExtractToBytes(LData);
    WriteMessage(LData, AContext.Binding.PeerIP, 'TCP');
  end;
end;

procedure TMainForm.IdUDPServerUDPRead(AThread: TIdUDPListenerThread;
  const AData: TIdBytes; ABinding: TIdSocketHandle);
begin
  WriteMessage(AData, ABinding.PeerIP, 'UDP');
end;

procedure TMainForm.LoadSettings;
begin
  var LIni := TMemIniFile.Create(TPath.ChangeExtension(Application.ExeName, 'ini'));
  try
    edtPort.Text := LIni.ReadString('Setting', 'Port', '5540');
  finally
    LIni.Free;
  end;
end;

procedure TMainForm.SaveSettings;
begin
  var LIni := TMemIniFile.Create(TPath.ChangeExtension(Application.ExeName, 'ini'));
  try
    LIni.WriteString('Setting', 'Port', edtPort.Text);
    LIni.UpdateFile;
  finally
    LIni.Free;
  end;
end;

procedure TMainForm.ServerTypeClick(Sender: TObject);
begin
  btnListen.Enabled := rbUDP.Checked or rbTCP.Checked;
end;

procedure TMainForm.StartServer(APort: Integer);
begin
  if rbUDP.Checked then
  begin
    IdUDPServer.DefaultPort := APort;
    IdUDPServer.Active := True;
  end
  else if rbTCP.Checked then
  begin
    IdTCPServer.DefaultPort := APort;
    IdTCPServer.Active := True;
  end
  else
    ShowMessage('Please select server type before start.');
end;

procedure TMainForm.StopServer;
begin
  IdUDPServer.Active := False;
  IdUDPServer.Bindings.Clear;
  IdTCPServer.Active := False;
  IdTCPServer.Bindings.Clear;
end;

procedure TMainForm.WriteMessage(AData: TIdBytes; const ASourceIP, AProtocol: string);
begin
  var LItem := lvMessages.Items.Add;
  LItem.Caption := DateTimeToStr(Now);
  LItem.SubItems.Add(Format('%s (%s)', [ASourceIP, AProtocol]));
  LItem.SubItems.Add(TEncoding.UTF8.GetString(AData));
end;

end.
