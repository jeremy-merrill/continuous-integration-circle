unit APIManager;

interface

uses
  System.SysUtils, System.Classes, System.JSON, REST.Client, REST.Types, System.IOUtils;

type
  TAPIManager = class
  private
    FRESTClient: TRESTClient;
    FRESTRequest: TRESTRequest;
    FRESTResponse: TRESTResponse;
    FAccessToken: string;
    FRefreshToken: string;
    FTokenExpiration: TDateTime;
    FConfigFilePath: string;
    function ExecuteSimpleAuth: string;
    function ExecuteBasicAuth(Username, Password: string): string;
    function ExecuteOAuth1(ConsumerKey, ConsumerSecret, Token, TokenSecret: string): string;
    function ExecuteOAuth2(AuthDetails: TJSONObject): string;
    function RefreshOAuth2Token(ClientID, ClientSecret, TokenURL, RefreshToken: string): string;
    function LoadAPIConfig(API_ID: Integer): TJSONObject;
  public
    constructor Create(const ConfigFilePath: string);
    destructor Destroy; override;
    function ExecuteAPI(API_ID: Integer): TRESTResponse;
  end;

implementation

uses
  System.DateUtils, System.NetEncoding, System.TypInfo, System.Generics.Collections;

constructor TAPIManager.Create(const ConfigFilePath: string);
begin
  FConfigFilePath := ConfigFilePath;
  FRESTClient := TRESTClient.Create(nil);
  FRESTRequest := TRESTRequest.Create(nil);
  FRESTResponse := TRESTResponse.Create(nil);

  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;

  FAccessToken := '';
  FRefreshToken := '';
  FTokenExpiration := 0;
end;

destructor TAPIManager.Destroy;
begin
  FRESTClient.Free;
  FRESTRequest.Free;
  FRESTResponse.Free;
  inherited;
end;

function TAPIManager.ExecuteSimpleAuth: string;
begin
  FRESTRequest.Execute;
  Result := FRESTResponse.Content;
end;

function TAPIManager.ExecuteBasicAuth(Username, Password: string): string;
var
  AuthHeader: string;
begin
  AuthHeader := 'Basic ' + TNetEncoding.Base64.Encode(Username + ':' + Password);
  FRESTRequest.Params.AddHeader('Authorization', AuthHeader);
  FRESTRequest.Execute;
  Result := FRESTResponse.Content;
end;

function TAPIManager.ExecuteOAuth1(ConsumerKey, ConsumerSecret, Token, TokenSecret: string): string;
var
  OAuthHeader: string;
begin
  OAuthHeader := Format('OAuth oauth_consumer_key="%s", oauth_token="%s", oauth_signature_method="HMAC-SHA1", oauth_version="1.0"',
                        [ConsumerKey, Token]);
  FRESTRequest.Params.AddHeader('Authorization', OAuthHeader);
  FRESTRequest.Execute;
  Result := FRESTResponse.Content;
end;

function TAPIManager.ExecuteOAuth2(AuthDetails: TJSONObject): string;
var
  AuthHeader: string;
begin
  if Now > FTokenExpiration then
  begin
    FRESTRequest.ResetToDefaults;
    for var i := 0 to AuthDetails.Count - 1 do
    begin
      var Pair := AuthDetails.Pairs[i];
      FRestRequest.AddParameter(Pair.JsonString.Value, PAIR.JsonValue.Value);
    end;
    FRESTRequest.Execute;
    Result := FRESTResponse.ToString;

    // Token is expired, refresh it
   // FAccessToken := RefreshOAuth2Token(ClientID, ClientSecret, TokenURL, FRefreshToken);
  end;

//  AuthHeader := 'Bearer ' + FAccessToken;
//  FRESTRequest.Params.AddHeader('Authorization', AuthHeader);
//  FRESTRequest.Execute;
//  Result := FRESTResponse.Content;
end;

function TAPIManager.RefreshOAuth2Token(ClientID, ClientSecret, TokenURL, RefreshToken: string): string;
var
  RefreshRequest: TRESTRequest;
  RefreshResponse: TRESTResponse;
  JSONResponse: TJSONObject;
  AccessToken: string;
  ExpiresIn: Integer;
begin
  RefreshRequest := TRESTRequest.Create(nil);
  RefreshResponse := TRESTResponse.Create(nil);
  try
    RefreshRequest.Client := TRESTClient.Create(TokenURL);
    RefreshRequest.Response := RefreshResponse;

    RefreshRequest.Method := TRESTRequestMethod.rmPOST;
    RefreshRequest.AddParameter('client_id', ClientID, pkGETorPOST);
    RefreshRequest.AddParameter('client_secret', ClientSecret, pkGETorPOST);
    RefreshRequest.AddParameter('refresh_token', RefreshToken, pkGETorPOST);
    RefreshRequest.AddParameter('grant_type', 'refresh_token', pkGETorPOST);

    RefreshRequest.Execute;

    JSONResponse := TJSONObject.ParseJSONValue(RefreshResponse.Content) as TJSONObject;
    try
      AccessToken := JSONResponse.GetValue<string>('access_token');
      ExpiresIn := JSONResponse.GetValue<Integer>('expires_in');
      FAccessToken := AccessToken;
      FTokenExpiration := IncSecond(Now, ExpiresIn);
      Result := FAccessToken;
    finally
      JSONResponse.Free;
    end;
  finally
    RefreshRequest.Free;
    RefreshResponse.Free;
  end;
end;

function TAPIManager.LoadAPIConfig(API_ID: Integer): TJSONObject;
var
  FileContent: string;
  JSONValue: TJSONValue;
  JSONArray: TJSONArray;
  Config: TJSONObject;
  i: Integer;
begin
  FileContent := TFile.ReadAllText(FConfigFilePath);
  JSONValue := TJSONObject.ParseJSONValue(FileContent);

  if not Assigned(JSONValue) then
    raise Exception.Create('Invalid JSON file format');

  JSONArray := JSONValue.GetValue<TJSONArray>('APIs');
  for i := 0 to JSONArray.Count - 1 do
  begin
    Config := JSONArray.Items[i] as TJSONObject;
    if Config.GetValue<Integer>('API_ID') = API_ID then
    begin
      Result := Config;
      Exit;
    end;
  end;

  raise Exception.CreateFmt('API configuration with ID %d not found', [API_ID]);
end;

function TAPIManager.ExecuteAPI(API_ID: Integer): TRESTResponse;
var
  APIConfig: TJSONObject;
  AuthType, BaseURL, Endpoint, Method: string;
  AuthDetails: TJSONObject;
  ResultStr: string;
begin
  APIConfig := LoadAPIConfig(API_ID);

  BaseURL := APIConfig.GetValue<string>('Base_URL');
  Endpoint := APIConfig.GetValue<string>('Endpoint');
  Method := APIConfig.GetValue<string>('Method');
  AuthType := APIConfig.GetValue<string>('Auth_Type');
  AuthDetails := APIConfig.GetValue<TJSONObject>('Auth_Details');

  FRESTClient.BaseURL := BaseURL;
  FRESTRequest.Resource := Endpoint;
  FRESTRequest.Method := TRESTRequestMethod(GetEnumValue(TypeInfo(TRESTRequestMethod), 'rm' + Method));

  if AuthType = 'Simple' then
    ResultStr := ExecuteSimpleAuth
  else if AuthType = 'Basic' then
    ResultStr := ExecuteBasicAuth(
                  AuthDetails.GetValue<string>('username'),
                  AuthDetails.GetValue<string>('password'))
  else if AuthType = 'OAuth1' then
    ResultStr := ExecuteOAuth1(
                  AuthDetails.GetValue<string>('consumer_key'),
                  AuthDetails.GetValue<string>('consumer_secret'),
                  AuthDetails.GetValue<string>('token'),
                  AuthDetails.GetValue<string>('token_secret'))
  else if AuthType = 'OAuth2' then
    ResultStr := ExecuteOAuth2(AuthDetails);
//                  AuthDetails.GetValue<string>('client_id'),
//                  AuthDetails.GetValue<string>('client_secret'),
//                  AuthDetails.GetValue<string>('token_url'));

  // Process the result here (log, save, or return)
//  Writeln(ResultStr);
  Result := FRESTResponse;
end;

end.

