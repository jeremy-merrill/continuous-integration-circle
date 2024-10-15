unit RestUtils;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  // System.TypInfo,
  System.JSON,
  Vcl.Controls,
  Vcl.Edge,
  REST.Client,

  // REST.Types,
  VAShared.UJSONValueHelper;

type
  TJavaScriptRunner = class(TWinControl)
  private
    FEdgeBrowser: TEdgeBrowser;
    function GetOnExecuteScript: TExecuteScriptEvent;
    procedure SetOnExecuteScript(const Value: TExecuteScriptEvent);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ExecuteJavaScript(JavaScript: string);
    property OnExecute: TExecuteScriptEvent read GetOnExecuteScript
      write SetOnExecuteScript;
  end;

  TRestAPI = class
  private
    FEdgeBrowser: TEdgeBrowser;
    FJSON: TJSONObject;
    FOwnsJSON: Boolean;
    FRESTClient: TRESTClient;
    FRESTRequest: TRESTRequest;
    FRESTResponse: TRESTResponse;
    FSteps: TJSONArray;
    FVariables: TDictionary<string, string>;
  public
    constructor Create(AJSON: string; AAutoExecute: Boolean = True); overload;
    constructor Create(AJSON: TJSONObject; AAutoExecute: Boolean = True;
      AOwnsJSON: Boolean = True); overload;
    destructor Destroy; override;
    function ExecuteStep(StepName: string): TJSONValue;
    property OwnsJSON: Boolean read FOwnsJSON write FOwnsJSON;
  end;

implementation

{ TJavaScriptRunner }

constructor TJavaScriptRunner.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Visible := True;
  FEdgeBrowser := TEdgeBrowser.Create(AOwner);
  FEdgeBrowser.Parent := AOwner as TWinControl;
  FEdgeBrowser.CreateWebView;
end;

destructor TJavaScriptRunner.Destroy;
begin
  FreeAndNil(FEdgeBrowser);
  inherited;
end;

procedure TJavaScriptRunner.ExecuteJavaScript(JavaScript: string);
begin
  FEdgeBrowser.ExecuteScript(JavaScript);
end;

function TJavaScriptRunner.GetOnExecuteScript: TExecuteScriptEvent;
begin
  Result := FEdgeBrowser.OnExecuteScript;
end;

procedure TJavaScriptRunner.SetOnExecuteScript(const Value
  : TExecuteScriptEvent);
begin
  FEdgeBrowser.OnExecuteScript := Value;
end;

{ TRestAPI }

constructor TRestAPI.Create(AJSON: TJSONObject;
  AAutoExecute, AOwnsJSON: Boolean);
begin
  FJSON := AJSON;
  FSteps := AJSON.AsTypeDef<TJSONArray>('steps', nil);
  FOwnsJSON := AOwnsJSON;
  FRESTClient := TRESTClient.Create(nil);
  FRESTRequest := TRESTRequest.Create(nil);
  FRESTResponse := TRESTResponse.Create(nil);
  FVariables := TDictionary<string, string>.Create;
  // if AAutoExecute then

end;

constructor TRestAPI.Create(AJSON: string; AAutoExecute: Boolean);
begin
  Create(TJSONValue.ParseJSONValue(AJSON) as TJSONObject, AAutoExecute, True);
end;

destructor TRestAPI.Destroy;
begin
  FreeAndNil(FEdgeBrowser);
  FreeAndNil(FVariables);
  FreeAndNil(FRESTResponse);
  FreeAndNil(FRESTRequest);
  FreeAndNil(FRESTClient);
  inherited;
end;

function TRestAPI.ExecuteStep(StepName: string): TJSONValue;
begin

end;

end.
