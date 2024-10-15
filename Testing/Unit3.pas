unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ExtCtrls, System.Generics.Collections,
  System.TypInfo, System.Rtti,
  System.JSON.Types, System.JSON.Writers, System.JSON.Readers, Unit4;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Panel1: TPanel;
    re: TRichEdit;
    re2: TRichEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TMyRequiredData = class(TRequiredData)
  private
    FTestingAgain: string;
  public
    property testingAgain: string read FTestingAgain;
  end;

  TMyTestData = class(TMyData)
  private
    FTesting: string;
  public
    property testing: string read FTesting;
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses
  VAShared.UJSONValueHelper, Rest.JSON,
  System.JSONConsts, System.JSON.Converters, System.JSON,
  System.JSON.Serializers;

const
  // SName = 'System.JSON.Serializers';
  SName = 'Unit3';

type
  TMYDataConverter = class(TJsonCustomCreationConverter<TRequiredData>)
  protected
    function CreateInstance(ATypeInf: PTypeInfo): TValue; override;
  end;

  TMyDataHelper = class helper for TMyData
  private
    function GetColorValue: TColor;
    procedure SetColorValue(const Value: TColor);
  public
    property ColorValue: TColor read GetColorValue write SetColorValue;
  end;

  TJMJsonSerializer = class(TJsonSerializer)
  private
  public
    constructor Create;
    destructor Destroy; override;
  end;

var
  Ctx: TRttiContext;

procedure TForm3.Button1Click(Sender: TObject);

  function FormatJSON(JSON: String): String;
  var
    tmpJson: TJsonValue;
  begin
    tmpJson := TJsonObject.ParseJSONValue(JSON);
{$WARN SYMBOL_DEPRECATED OFF}
    if tmpJson <> nil then
      Result := TJson.Format(tmpJson)
    else
      Result := '';
{$WARN SYMBOL_DEPRECATED ON}
    FreeAndNil(tmpJson);
  end;

var
  JSONText, s: string;
  Data: TMyTestData;
  sl: TStringList;
begin
  sl := TStringList.Create;
  try
    sl.LoadFromFile('..\..\Unit3.json');
    JSONText := sl.Text;
  finally
    sl.Free;
  end;
  TJSONMapper<TMyTestData>.SetDefaultLibrary(SName);
  Data := TJSONMapper<TMyTestData>.Default.FromObject(JSONText);
  try
    s := TJSONMapper<TMyTestData>.Default.ToString(Data);
  finally
    Data.Free;
  end;
  s := FormatJSON(s);
  re.Lines.Text := s;
end;

var
  LRegistered: Boolean;

procedure TForm3.FormCreate(Sender: TObject);
begin
  re2.Lines.LoadFromFile('..\..\Unit3.json');

end;

{ TJMJsonSerializer }

constructor TJMJsonSerializer.Create;
var
  AResolver: TJsonDynamicContractResolver;
begin
  inherited Create;
  AResolver := TJsonDynamicContractResolver.Create
    (TJsonMemberSerialization.Public);
  AResolver.SetTypeConverter(TypeInfo(TRequiredData), TMYDataConverter);
  AResolver.SetPropertiesIgnored(TypeInfo(TMyRequiredData), ['testingAgain']);

  AResolver.SetPropertiesIgnored(TypeInfo(TMyTestData), ['testing']);

  // AResolver.SetFieldConverter(TypeInfo(TMyRequiredData), 'testingAgain', TEmptyConverter);
  ContractResolver := AResolver;
end;

destructor TJMJsonSerializer.Destroy;
begin
  inherited;
end;

{ TMYDataConverter }

function TMYDataConverter.CreateInstance(ATypeInf: PTypeInfo): TValue;
begin
  Result := TMyRequiredData.Create;
end;

{ TMyDataHelper }

function TMyDataHelper.GetColorValue: TColor;
begin
  Result := StringToColor(Color);
end;

procedure TMyDataHelper.SetColorValue(const Value: TColor);
begin
  Color := ColorToString(Value);
end;

initialization

Ctx := TRttiContext.Create;
LRegistered := TJSONMappers.RegisterLibrary(SName,
  TJSONMappers.TOptionality.DontCare, TJSONMappers.TOptionality.DontCare,
  TJSONMappers.TOptionality.DontCare,
  procedure(const AName: string; const ASerItems: TJSONMappers.TItem;
    var AIntro: string; var AReqUnit: string)
  const
    CSerItems: array [TJSONMappers.TItem] of string = ('Public', 'Fields');
  begin
    AIntro := '[JsonSerialize(TJsonMemberSerialization.' + CSerItems
      [ASerItems] + ')]';
    AReqUnit := SName;
  end,
  procedure(const AName, AOrigName: string; const AElem: TJSONMappers.TItem;
    var AIntro: string; var AReqUnit: string)
  begin
    if AnsiSameText(AName, AOrigName) and (AElem <> TJSONMappers.TItem.Field)
    then
      Exit;
    AIntro := '[JsonName(''' + AOrigName + ''')]';
    AReqUnit := SName;
  end,
  procedure(const AItemType: string; var AIntro, AReqUnit,
    AInstantiation: string)
  begin
    var
    LConv := StringReplace(AItemType, '<', '', [TReplaceFlag.rfReplaceAll]);
    LConv := 'TJsonListConverter' + StringReplace(LConv, '>', '',
      [TReplaceFlag.rfReplaceAll]);
    AIntro := '[JsonConverter(' + LConv + ')]';
    AReqUnit := SName;
    AInstantiation := LConv + ' = class(TJsonListConverter<' + AItemType + '>)';
  end,
  function(ApValue: Pointer; ApTypeInfo: PTypeInfo): TJsonObject
  var
    LSer: TJMJsonSerializer;
    LWrt: TJsonObjectWriter;
    V: TValue;
  begin
    LSer := TJMJsonSerializer.Create;
    LWrt := TJsonObjectWriter.Create(False);
    try
      TValue.Make(ApValue, ApTypeInfo, V);
      LSer.Serialize(LWrt, V);
      Result := LWrt.JSON as TJsonObject;
    finally
      LWrt.Free;
      LSer.Free;
    end;
  end,
  function(AValue: TJsonObject; ApTypeInfo: PTypeInfo): TValue
  var
    LSer: TJMJsonSerializer;
    LRdr: TJsonObjectReader;
  begin
    LSer := TJMJsonSerializer.Create;
    LRdr := TJsonObjectReader.Create(AValue);
    try
      Result := LSer.Deserialize(LRdr, ApTypeInfo);
    finally
      LRdr.Free;
      LSer.Free;
    end;
  end);

finalization

if LRegistered then
  TJSONMappers.UnRegisterLibrary(SName);

end.
