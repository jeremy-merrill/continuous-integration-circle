unit Unit1;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, IdHTTPServer, IdCustomHTTPServer,
  REST.Authenticator.OAuth, REST.Client, REST.Types, IdContext, IdHTTP, System.JSON,
  REST.Authenticator.Basic, REST.Authenticator.Simple, Vcl.Controls,
  Vcl.StdCtrls, Vcl.AppEvnts;

type
  TForm1 = class(TForm)
    ApplicationEvents1: TApplicationEvents;
    EditPort: TEdit;
    ButtonStop: TButton;
    ButtonStart: TButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
  private
    IdHTTPServer1: TIdHTTPServer;
    OAuth1Authenticator: TOAuth1Authenticator;
    OAuth2Authenticator: TOAuth2Authenticator;
    BasicAuthenticator: THTTPBasicAuthenticator;
    SimpleAuthenticator: TSimpleAuthenticator;
    procedure IdHTTPServer1CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure HandleOAuth1(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure HandleOAuth2(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure HandleBasicAuth(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure HandleSimpleAuth(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure ReturnDummyJSON(AResponseInfo: TIdHTTPResponseInfo);
    function ValidateOAuth1(ARequestInfo: TIdHTTPRequestInfo): Boolean;
    function ValidateOAuth2(ARequestInfo: TIdHTTPRequestInfo): Boolean;
    procedure StartServer;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not IdHTTPServer1.Active;
  ButtonStop.Enabled := IdHTTPServer1.Active;
  EditPort.Enabled := not IdHTTPServer1.Active;
end;

procedure TForm1.ButtonStartClick(Sender: TObject);
begin
  StartServer;
end;

procedure TForm1.ButtonStopClick(Sender: TObject);
begin
  IdHTTPServer1.Active := False;
  IdHTTPServer1.Bindings.Clear;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Create and configure IdHTTPServer1
  IdHTTPServer1 := TIdHTTPServer.Create(Self);
//  IdHTTPServer1.DefaultPort := 8080;
  IdHTTPServer1.OnCommandGet := IdHTTPServer1CommandGet;
//  IdHTTPServer1.Active := True;

  // Create and configure OAuth1Authenticator
  OAuth1Authenticator := TOAuth1Authenticator.Create(Self);
  OAuth1Authenticator.ConsumerKey := 'your_consumer_key';
  OAuth1Authenticator.ConsumerSecret := 'your_consumer_secret';
  OAuth1Authenticator.AccessToken := 'your_access_token';
  OAuth1Authenticator.AccessTokenSecret := 'your_access_token_secret';

  // Create and configure OAuth2Authenticator
  OAuth2Authenticator := TOAuth2Authenticator.Create(Self);
  OAuth2Authenticator.ClientID := 'your_client_id';
  OAuth2Authenticator.ClientSecret := 'your_client_secret';
  OAuth2Authenticator.AccessToken := 'your_access_token';
  OAuth2Authenticator.RefreshToken := 'your_refresh_token';

  // Create and configure BasicAuthenticator
  BasicAuthenticator := THTTPBasicAuthenticator.Create(Self);
  BasicAuthenticator.Username := 'your_username';
  BasicAuthenticator.Password := 'your_password';

  // Create and configure SimpleAuthenticator
  SimpleAuthenticator := TSimpleAuthenticator.Create(Self);
  SimpleAuthenticator.Username := 'your_username';
  SimpleAuthenticator.Password := 'your_password';
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  IdHTTPServer1.Free;
  OAuth1Authenticator.Free;
  OAuth2Authenticator.Free;
  BasicAuthenticator.Free;
  SimpleAuthenticator.Free;
end;

procedure TForm1.IdHTTPServer1CommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  if ARequestInfo.Document = '/testing/oauth1' then
    HandleOAuth1(ARequestInfo, AResponseInfo)
  else if ARequestInfo.Document = '/testing/oauth2' then
    HandleOAuth2(ARequestInfo, AResponseInfo)
  else if ARequestInfo.Document = '/testing/basic' then
    HandleBasicAuth(ARequestInfo, AResponseInfo)
  else if ARequestInfo.Document = '/testing/simple' then
    HandleSimpleAuth(ARequestInfo, AResponseInfo)
  else
    AResponseInfo.ContentText := 'Invalid request';
end;

procedure TForm1.HandleOAuth1(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
//  if OAuth1Authenticator.ValidateRequest(ARequestInfo.RawHTTPCommand) then
  if ValidateOAuth1(ARequestInfo) then
    ReturnDummyJSON(AResponseInfo)
  else
    AResponseInfo.ContentText := 'OAuth1 authentication failed';
end;

procedure TForm1.HandleOAuth2(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
//var
//  AccessToken: string;
begin
//  AccessToken := ARequestInfo.Params.Values['access_token'];
//  if validOAuth2Authenticator.ValidateToken(AccessToken) then
  if ValidateOAuth2(ARequestInfo) then
    ReturnDummyJSON(AResponseInfo)
  else
    AResponseInfo.ContentText := 'OAuth2 authentication failed';
end;

procedure TForm1.HandleBasicAuth(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  if (ARequestInfo.AuthUsername = BasicAuthenticator.Username) and
     (ARequestInfo.AuthPassword = BasicAuthenticator.Password) then
    ReturnDummyJSON(AResponseInfo)
  else
    AResponseInfo.ContentText := 'Basic authentication failed';
end;

procedure TForm1.HandleSimpleAuth(ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
begin
  if (ARequestInfo.Params.Values['username'] = SimpleAuthenticator.Username) and
     (ARequestInfo.Params.Values['password'] = SimpleAuthenticator.Password) then
    ReturnDummyJSON(AResponseInfo)
  else
    AResponseInfo.ContentText := 'Simple authentication failed';
end;

procedure TForm1.ReturnDummyJSON(AResponseInfo: TIdHTTPResponseInfo);
var
  JSONObj: TJSONObject;
begin
  JSONObj := TJSONObject.Create;
  try
    JSONObj.AddPair('status', 'success');
    JSONObj.AddPair('message', 'This is a dummy JSON response');
    JSONObj.AddPair('data', 'Sample data here');

    AResponseInfo.ContentType := 'application/json';
    AResponseInfo.ContentText := JSONObj.ToString;
  finally
    JSONObj.Free;
  end;
end;

procedure TForm1.StartServer;
begin
  if not IdHTTPServer1.Active then
  begin
    IdHTTPServer1.Bindings.Clear;
    IdHTTPServer1.DefaultPort := StrToInt(EditPort.Text);
    IdHTTPServer1.Active := True;
  end;
end;

function TForm1.ValidateOAuth1(ARequestInfo: TIdHTTPRequestInfo): Boolean;
begin
  // Implement your OAuth1 validation logic here
  Result := (ARequestInfo.Params.Values['oauth_consumer_key'] = OAuth1Authenticator.ConsumerKey) and
            (ARequestInfo.Params.Values['oauth_token'] = OAuth1Authenticator.AccessToken);
end;

function TForm1.ValidateOAuth2(ARequestInfo: TIdHTTPRequestInfo): Boolean;
begin
  // Implement your OAuth2 validation logic here
  Result := (ARequestInfo.Params.Values['access_token'] = OAuth2Authenticator.AccessToken);
end;

end.



