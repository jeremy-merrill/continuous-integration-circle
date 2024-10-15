unit RestUtilsold;

interface

uses
  System.Generics.Collections,
  System.TypInfo,
  System.JSON,
  System.SysUtils,
  System.Classes,
  Vcl.Edge,
  REST.Client,
  REST.Types;

type
  TRestAPI = class
  private
    FEdgeBrowser: TEdgeBrowser;
    FJSON: TJSONObject;
    FRESTClient: TRESTClient;
    FRESTRequest: TRESTRequest;
    FRESTResponse: TRESTResponse;
    FPlaceholders: TDictionary<string, string>;
    procedure LoadFlowConfig(const FileName: string);
    procedure ReplacePlaceholders(var Value: string);
    procedure ExecuteJavaScriptCondition(const Condition: TJSONObject;
      const IfTrueStep: string);
    procedure ExecuteStep(const StepConfig: TJSONObject);
  public
    constructor Create(JSON: TJSONObject; AOwnsJSON: Boolean = True);
    destructor Destroy; override;
    function ExecuteStep(StepName: string): TJSONValue;
  end;

implementation

procedure LoadFlowConfig(const FileName: string; out FlowConfig: TJSONArray);
var
  JSONString: string;
  JSONValue: TJSONValue;
begin
  JSONString := TFile.ReadAllText(FileName);
  JSONValue := TJSONObject.ParseJSONValue(JSONString);
  if JSONValue is TJSONObject then
    FlowConfig := TJSONObject(JSONValue).GetValue<TJSONArray>('Steps')
  else
    raise Exception.Create('Invalid JSON configuration.');
end;

procedure ReplacePlaceholders(var Value: string;
  const Placeholders: TDictionary<string, string>);
var
  Placeholder, ActualValue: string;
begin
  for Placeholder in Placeholders.Keys do
  begin
    if Placeholders.TryGetValue(Placeholder, ActualValue) then
      Value := StringReplace(Value, '{' + Placeholder + '}', ActualValue,
        [rfReplaceAll, rfIgnoreCase]);
  end;
end;

procedure ExecuteJavaScriptCondition(const Condition: TJSONObject;
  const EdgeBrowser: TEdgeBrowser;
  const Placeholders: TDictionary<string, string>; const IfTrueStep: string;
  const FlowConfig: TJSONArray; const RESTClient: TRESTClient;
  const RESTRequest: TRESTRequest; const RESTResponse: TRESTResponse;
  var ResponseData: TJSONObject);
var
  Script, FunctionName, Args, ArgValue: string;
  I: Integer;
begin
  Script := Condition.GetValue<string>('Script');
  FunctionName := Condition.GetValue<string>('FunctionName');
  Args := '[';
  for ArgValue in Condition.GetValue<TJSONArray>('Arguments') do
  begin
    ReplacePlaceholders(ArgValue, Placeholders);
    Args := Args + '"' + ArgValue + '",';
  end;
  Args := Args.TrimRight([',']) + ']';
  // Remove trailing comma and close the array

  // Execute the JavaScript function
  EdgeBrowser.ExecuteScript(Script + '; ' + FunctionName + '.apply(null, ' +
    Args + ');',
    procedure(const AResult: JSONValue)
    begin
      var ResultBool: Boolean;
      if TryStrToBool(AResult.ToString, ResultBool) and ResultBool then
      begin
        // If the JavaScript function returns true, execute the specified step
        for I := 0 to FlowConfig.Count - 1 do
        begin
          if (FlowConfig.Items[I] as TJSONObject).GetValue<string>('StepName') = IfTrueStep
          then
          begin
            ExecuteStep(FlowConfig.Items[I] as TJSONObject, RESTClient,
              RESTRequest, RESTResponse, Placeholders, ResponseData);
            Break;
          end;
        end;
      end;
    end);
end;

procedure ExecuteStep(const StepConfig: TJSONObject;
const RESTClient: TRESTClient; const RESTRequest: TRESTRequest;
const RESTResponse: TRESTResponse;
const Placeholders: TDictionary<string, string>; var ResponseData: TJSONObject);
var
  Param: TJSONPair;
  ParamName, ParamValue: string;
  PreConditions, PostConditions: TJSONArray;
  Condition: TJSONObject;
  I: Integer;
begin
  RESTClient.BaseURL := StepConfig.GetValue<string>('URL');
  RESTRequest.Method := TRESTRequestMethod
    (GetEnumValue(TypeInfo(TRESTRequestMethod),
    'rm' + StepConfig.GetValue<string>('Method')));
  RESTRequest.Params.Clear;
  RESTRequest.ClearBody;

  // Set headers
  for Param in StepConfig.GetValue<TJSONObject>('Headers') do
  begin
    ParamName := Param.JSONString.Value;
    ParamValue := Param.JSONValue.Value;
    ReplacePlaceholders(ParamValue, Placeholders);
    RESTRequest.Params.AddHeader(ParamName, ParamValue);
  end;

  // Set query parameters or body
  if RESTRequest.Method in [rmGET, rmDELETE] then
  begin
    for Param in StepConfig.GetValue<TJSONObject>('Params') do
    begin
      ParamName := Param.JSONString.Value;
      ParamValue := Param.JSONValue.Value;
      ReplacePlaceholders(ParamValue, Placeholders);
      RESTRequest.AddParameter(ParamName, ParamValue, pkGETorPOST);
    end;
  end
  else if RESTRequest.Method in [rmPOST, rmPUT, rmPATCH] then
  begin
    for Param in StepConfig.GetValue<TJSONObject>('Body') do
    begin
      ParamName := Param.JSONString.Value;
      ParamValue := Param.JSONValue.Value;
      ReplacePlaceholders(ParamValue, Placeholders);
      RESTRequest.AddParameter(ParamName, ParamValue, pkREQUESTBODY);
    end;
  end;

  // Check pre-conditions
  if StepConfig.TryGetValue<TJSONArray>('PreConditions', PreConditions) then
  begin
    for I := 0 to PreConditions.Count - 1 do
    begin
      Condition := PreConditions.Items[I] as TJSONObject;
      if Condition.GetValue<string>('ConditionType') = 'ExecuteJavaScript' then
      begin
        ExecuteJavaScriptCondition(Condition, EdgeBrowser, Placeholders,
          Condition.GetValue<string>('IfTrueStep'), FlowConfig, RESTClient,
          RESTRequest, RESTResponse, ResponseData);
      end;
    end;
  end;

  // Execute the request
  RESTRequest.Execute;

  // Parse the response
  ResponseData := TJSONObject.ParseJSONValue(RESTResponse.Content)
    as TJSONObject;

  // Handle the response
  if RESTResponse.StatusCode <> 200 then
  begin
    // Handle error
    raise Exception.Create('Error: ' + IntToStr(RESTResponse.StatusCode) + ' - '
      + RESTResponse.Content);
  end;

  // Check post-conditions
  if StepConfig.TryGetValue<TJSONArray>('PostConditions', PostConditions) then
  begin
    for I := 0 to PostConditions.Count - 1 do
    begin
      Condition := PostConditions.Items[I] as TJSONObject;
      // Handle post-conditions (e.g., storing values)
    end;
  end;
end;

var
  EdgeBrowser: TEdgeBrowser;
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  FlowConfig: TJSONArray;
  ResponseData: TJSONObject;
  Placeholders: TDictionary<string, string>;
  I: Integer;
begin
  EdgeBrowser := TEdgeBrowser.Create(nil);
  RESTClient := TRESTClient.Create(nil);
  RESTRequest := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  RESTRequest.Client := RESTClient;
  RESTRequest.Response := RESTResponse;
  Placeholders := TDictionary<string, string>.Create;

  try
    // Load the flow configuration
    LoadFlowConfig('oauth_flow.json', FlowConfig);

    // Execute each step in the flow
    for I := 0 to FlowConfig.Count - 1 do
    begin
      // Assume that the current time and expiry time are calculated and added to placeholders
      // For example, you might calculate the expiry time when you receive the token and store it
      // CurrentTimePlusExpiresIn should be calculated based on the current time and the expires_in value
      Placeholders.AddOrSetValue('CurrentTime', DateTimeToStr(Now));
      // Current time placeholder
      // TokenExpiryTime would be set when the token is received and stored in the placeholders

      // Execute the current step
      ExecuteStep(FlowConfig.Items[I] as TJSONObject, RESTClient, RESTRequest,
        RESTResponse, Placeholders, ResponseData);

      // In a real-world scenario, you would likely need to extract data from the response
      // and use it in subsequent steps, such as using an authorization code to get a token.
    end;

  finally
    EdgeBrowser.Free;
    RESTClient.Free;
    RESTRequest.Free;
    RESTResponse.Free;
    FlowConfig.Free;
    Placeholders.Free;
  end;

end.
