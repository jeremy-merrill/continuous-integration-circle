unit Unit1;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  System.JSON,
  System.Generics.Collections,
  System.Net.URLClient,
  System.Net.HttpClient.Win,
  REST.Types,
  REST.Authenticator.OAuth.WebForm.Win,
  REST.Authenticator.OAuth,
  REST.Authenticator.Basic,
  System.NetEncoding,
  REST.Client,
  REST.Consts,
  REST.Authenticator.Simple,
  Data.Bind.Components,
  Data.Bind.ObjectScope,
  ORFn;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Splitter1: TSplitter;
    reJSON: TRichEdit;
    gpMain: TGridPanel;
    btnLoadJSON: TButton;
    btnExecute: TButton;
    Panel2: TPanel;
    lblRequest: TLabel;
    reRequest: TRichEdit;
    Splitter2: TSplitter;
    Panel3: TPanel;
    lblResponse: TLabel;
    reResponse: TRichEdit;
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    rg: TRadioGroup;
    btnStep: TButton;
    procedure btnLoadJSONClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rgClick(Sender: TObject);
    procedure btnStepClick(Sender: TObject);
    procedure RESTClientReceiveData(const Sender: TObject;
      AContentLength, AReadCount: Int64; var AAbort: Boolean);
    procedure RESTClientReceiveDataEx(const Sender: TObject;
      AContentLength, AReadCount: Int64; AChunk: Pointer;
      AChunkLength: Cardinal; var AAbort: Boolean);
    procedure RESTClientSendData(const Sender: TObject;
      AContentLength, AWriteCount: Int64; var AAbort: Boolean);
    procedure RESTClientAuthEvent(const Sender: TObject;
      AnAuthTarget: TAuthTargetType; const ARealm, AURL: string;
      var AUserName, APassword: string; var AbortAuth: Boolean;
      var Persistence: TAuthPersistenceType);
    procedure RESTRequestBeforeExecute(Sender: TCustomRESTRequest);
  private
    { Private declarations }
    FJSON: TJSONValue;
    FList: TJSONArray;
    FSecurity: TRESTSecurity;
    FSteps: TJSONArray;
    FIndex: Integer;
    FStep: Integer;
    procedure SetupSimpleAuth(AuthDetails: TJSONObject);
    procedure SetupBasicAuth(AuthDetails: TJSONObject);
    procedure SetupOAuth1(AuthDetails: TJSONObject);
    procedure SetupOAuth2(AuthDetails: TJSONObject);

    procedure UpdateButtons;
    procedure DoStep;
    procedure Error(txt: string);
    procedure UpdateRE(re: TRichEdit; Data: string);
    procedure UpdateParams(Params: TRESTRequestParameterList; JSON: TJSONValue);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  System.TypInfo,
  System.Rtti,
  VAShared.UJSONValueHelper;

const
  Line = '------------------------------';

type
  TMisc = class
  public
    class function GetEnumValueFromString<T>(const AName: string;
      const Prefix: string = ''): T;
  end;

  { TMisc }

class function TMisc.GetEnumValueFromString<T>(const AName, Prefix: string): T;
var
  IValue: Integer;
  ATypeInf: PTypeInfo;
  TypeData: PTypeData;
  Value: TValue;
begin
  ATypeInf := TypeInfo(T);
  IValue := GetEnumValue(ATypeInf, AName);
  if (IValue < 0) and (Prefix <> '') then
    IValue := GetEnumValue(ATypeInf, Prefix + AName);
  TypeData := ATypeInf^.TypeData;
  if (IValue < TypeData^.MinValue) or (IValue > TypeData^.MaxValue) then
    IValue := TypeData^.MinValue;
  TValue.Make(@IValue, ATypeInf, Value);
  Result := Value.AsType<T>;
end;

const
  FileName = 'C:\Jeremy\Embarcadero\REST\Client\test.json';

procedure TForm1.btnExecuteClick(Sender: TObject);
begin
  reRequest.Clear;
  reResponse.Clear;
  FStep := 0;
  repeat
    DoStep;
  until FStep = 0;
end;

procedure TForm1.btnLoadJSONClick(Sender: TObject);
var
  sl: TStringList;
  Max: Integer;
begin
  sl := TStringList.Create;
  try
    FreeAndNil(FJSON);
    FList := nil;
    FSteps := nil;
    FStep := -1;
    FIndex := -1;
    sl.LoadFromFile(FileName);
    FJSON := TJSONValue.ParseJSONValue(sl.Text);
    reJSON.Lines.Text := FJSON.Format(3);
    FList := FJSON.AsType<TJSONArray>;
  finally
    FreeAndNil(sl);
  end;
  rg.Items.Clear;
  if Assigned(FList) then
  begin
    Max := gpMain.RowCollection.Count * 2 - 1;
    rg.Columns := (FList.Count + Max - 1) div Max;
    for var i := 0 to FList.Count - 1 do
      rg.Items.Add(FList[i].AsTypeDef<string>('name', IntToStr(i + 1)));
  end;
  UpdateButtons;
end;

procedure TForm1.btnStepClick(Sender: TObject);
begin
  DoStep;
end;

procedure TForm1.DoStep;
var
  LStep: TJSONObject;
  Output: string;
begin
  if Assigned(FSteps) and (FStep >= 0) and (FStep < FSteps.Count) then
  begin
    LStep := FSteps[FStep] as TJSONObject;
    inc(FStep);
    if FStep >= FSteps.Count then
    begin
      FStep := 0;
      rg.ItemIndex := -1;
    end;
    RESTRequest.Method := TMisc.GetEnumValueFromString<TRESTRequestMethod>
      (LStep.AsTypeDef<string>('method', 'get'), 'rm');
    UpdateParams(RESTRequest.Params, FSteps[FStep]);
    RESTRequest.Execute;
    Output := RESTResponse.Content;
    if RESTResponse.StatusCode = 200 then
      try
        Output := RESTResponse.JSONValue.Format(3);
      except
      end;
    if Output = RESTResponse.StatusText then
      Output := ''
    else
      Output := CRLF + Output;
    UpdateRE(reResponse, RESTResponse.StatusCode.ToString + '  ' +
      RESTResponse.StatusText + Output);
  end
  else
    FStep := 0;
  UpdateButtons;
end;

procedure TForm1.Error(txt: string);
const
  ErrorStr = '*********************************';
begin
  reRequest.Lines.Add(ErrorStr);
  reRequest.Lines.Add(txt);
  reRequest.Lines.Add(ErrorStr);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  btnLoadJSONClick(Self);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FJSON);
end;

procedure TForm1.RESTClientAuthEvent(const Sender: TObject;
  AnAuthTarget: TAuthTargetType; const ARealm, AURL: string;
  var AUserName, APassword: string; var AbortAuth: Boolean;
  var Persistence: TAuthPersistenceType);
begin
  reJSON.Lines.Add('RESTClientAuthEvent sent ' + Sender.ClassName);
end;

procedure TForm1.RESTClientReceiveData(const Sender: TObject;
  AContentLength, AReadCount: Int64; var AAbort: Boolean);
begin
  reJSON.Lines.Add('RESTClientReceiveData sent ' + Sender.ClassName);
end;

procedure TForm1.RESTClientReceiveDataEx(const Sender: TObject;
  AContentLength, AReadCount: Int64; AChunk: Pointer; AChunkLength: Cardinal;
  var AAbort: Boolean);
begin
  reJSON.Lines.Add('RESTClientReceiveDataEx sent ' + Sender.ClassName);
end;

procedure TForm1.RESTClientSendData(const Sender: TObject;
  AContentLength, AWriteCount: Int64; var AAbort: Boolean);
begin
  reJSON.Lines.Add('RESTClientSendData sent ' + Sender.ClassName);
end;

procedure TForm1.RESTRequestBeforeExecute(Sender: TCustomRESTRequest);
begin
  reRequest.Lines.Add('URL:  ' + Sender.GetFullRequestURL);
  reRequest.Lines.Add('Body: ' + Sender.GetFullRequestBody);
  for var i := 0 to Sender.Params.Count - 1 do
    reRequest.Lines.Add(Sender.Params[i].ToString);
  for var i := 0 to Sender.TransientParams.Count - 1 do
    reRequest.Lines.Add(Sender.TransientParams[i].ToString);
  reRequest.Lines.Add(Line);
end;

procedure TForm1.rgClick(Sender: TObject);
begin
  reRequest.Clear;
  reResponse.Clear;
  RESTClient.ResetToDefaults;
  RESTRequest.ResetToDefaults;
  RESTResponse.ResetToDefaults;
  FIndex := rg.ItemIndex;
  if FIndex >= 0 then
  begin
    if not Assigned(FList) then
    begin
      Error('No JSON');
      Exit;
    end;
    FSteps := FList[FIndex].AsTypeDef<TJSONArray>('steps', nil);
    FStep := 0;
    FSecurity := TMisc.GetEnumValueFromString<TRESTSecurity>
      (FList[FIndex].AsTypeDef<string>('authorization', 'none'), 'rs');
    case FSecurity of
      rsSimple:
        begin
          RESTClient.Authenticator := SimpleAuthenticator;
        end;
      rsBasic:
        begin
          RESTClient.Authenticator := nil;
          var Username := FList[FIndex].AsTypeDef<string>
            ('username', '');
          var Password := FList[FIndex].AsTypeDef<string>
            ('password', '');
          var LAuthValue := 'Basic ' + TNetEncoding.Base64String.Encode(Username + ':' + Password);  // do not translate
          RESTRequest.Params.AddHeader(HTTP_HEADERFIELD_AUTH, LAuthValue);
//          RESTClient.Authenticator := BasicAuthenticator;
//          BasicAuthenticator.Username := FList[FIndex].AsTypeDef<string>
//            ('username', '');
//          BasicAuthenticator.Password := FList[FIndex].AsTypeDef<string>
//            ('password', '');
//          BasicAuthenticator.Authenticate(RESTRequest);
        end;
      rsOAuth1:
        begin
          RESTClient.Authenticator := OAuth1Authenticator;
        end;
      rsOAuth2:
        begin
          RESTClient.Authenticator := OAuth2Authenticator;
          OAuth2Authenticator.AuthorizationEndpoint := FList[FIndex].AsTypeDef<string>('authorization_endpoint', '');
          OAuth2Authenticator.ClientID := FList[FIndex].AsTypeDef<string>('client_id', '');
          OAuth2Authenticator.ClientSecret := FList[FIndex].AsTypeDef<string>('client_secret', '');
          OAuth2Authenticator.LocalState := random(99999999).ToString;
          OAuth2Authenticator.RedirectionEndpoint := FList[FIndex].AsTypeDef<string>('redirect_endpoint', '');
          OAuth2Authenticator.Scope := FList[FIndex].AsTypeDef<string>('scope', '');
        end
    else
      { rsNone: } RESTClient.Authenticator := nil;
    end;
    RESTClient.BaseURL := FList[FIndex].AsTypeDef<string>('baseURL', '');
    RESTRequest.Resource := FList[FIndex].AsTypeDef<string>('resource', '');
    UpdateParams(RESTClient.Params, FList[FIndex]);
    if Assigned(RESTClient.Authenticator) then
      RESTClient.Authenticator.Authenticate(RESTRequest);
    reRequest.Lines.Add(reRequest.ToString);
    reResponse.Lines.Add(RESTResponse.ToString);
  end
  else
    FSteps := nil;
  UpdateButtons;
end;

procedure TForm1.SetupBasicAuth(AuthDetails: TJSONObject);
var
  Username, Password: string;
begin
  Username := AuthDetails.GetValue<string>('username');
  Password := AuthDetails.GetValue<string>('password');
  RESTClient.Authenticator := THTTPBasicAuthenticator.Create(Username, Password);
end;


procedure TForm1.SetupOAuth1(AuthDetails: TJSONObject);
begin
  OAuth1Authenticator.ConsumerKey := AuthDetails.GetValue<string>('consumer_key');
  OAuth1Authenticator.ConsumerSecret := AuthDetails.GetValue<string>('consumer_secret');
  OAuth1Authenticator.AccessToken := AuthDetails.GetValue<string>('token');
  OAuth1Authenticator.AccessTokenSecret := AuthDetails.GetValue<string>('token_secret');
  RESTClient.Authenticator := OAuth1Authenticator;
end;

procedure TForm1.SetupOAuth2(AuthDetails: TJSONObject);
var
  ClientID, ClientSecret, TokenURL: string;
  AccessToken, RefreshToken: string;
  ExpirationTime: TDateTime;
  CurrentTime: TDateTime;
begin
  ClientID := AuthDetails.GetValue<string>('client_id');
  ClientSecret := AuthDetails.GetValue<string>('client_secret');
  TokenURL := AuthDetails.GetValue<string>('token_url');

  AccessToken := AuthDetails.GetValue<string>('access_token');
  RefreshToken := AuthDetails.GetValue<string>('refresh_token');
  ExpirationTime := AuthDetails.GetValue<TDateTime>('expiration_time');
  CurrentTime := Now;

  if CurrentTime > ExpirationTime then
  begin
    // Token expired, request a new token using refresh token
    OAuth2Authenticator.RefreshToken := RefreshToken;
    OAuth2Authenticator.AccessTokenEndpoint := TokenURL;
    OAuth2Authenticator.ClientID := ClientID;
    OAuth2Authenticator.ClientSecret := ClientSecret;
//    OAuth2Authenticator.Authenticate;
  end
  else
  begin
    // Use the existing access token
    OAuth2Authenticator.AccessToken := AccessToken;
  end;

  RESTClient.Authenticator := OAuth2Authenticator;
end;


procedure TForm1.SetupSimpleAuth(AuthDetails: TJSONObject);
begin
  // No authentication required, just setup if needed
  RESTClient.Authenticator := nil;
end;

procedure TForm1.UpdateRE(re: TRichEdit; Data: string);
begin
  re.Lines.Add(Data);
  re.Lines.Add(Line);
end;

procedure TForm1.UpdateButtons;
var
  AStep, AName: string;
begin
  btnExecute.Enabled := FIndex >= 0;
  btnStep.Enabled := btnExecute.Enabled;
  if (FIndex < 0) or (FStep < 0) then
  begin
    AStep := '';
    AName := '';
  end
  else
  begin
    AStep := ' ' + (FStep + 1).ToString;
    AName := '  (' + rg.Items[FIndex] + ')';
  end;
  lblRequest.Caption := 'Request' + AName;
  lblResponse.Caption := 'Response' + AName;
  btnStep.Caption := 'Step' + AStep;
end;

procedure TForm1.UpdateParams(Params: TRESTRequestParameterList;
  JSON: TJSONValue);
var
  JSONArray: TJSONArray;
  AName, AValue: string;
  Kind: TRESTRequestParameterKind;
begin
  JSONArray := JSON.AsTypeDef<TJSONArray>('params', nil);
  if Assigned(JSONArray) then
  begin
    for var i := 0 to JSONArray.Count - 1 do
    begin
      AName := JSONArray[i].AsTypeDef<string>('name', '');
      if (AName <> '') then
      begin
        AValue := JSONArray[i].AsTypeDef<string>('value', '');
        Kind := TMisc.GetEnumValueFromString<TRESTRequestParameterKind>
          (JSONArray[i].AsTypeDef<string>('kind', 'GETorPOST'), 'pk');
        Params.AddItem(AName, AValue, Kind);
      end;
    end;
  end;
end;

end.
