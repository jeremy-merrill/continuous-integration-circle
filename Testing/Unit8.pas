unit Unit8;

interface

uses
  System.Generics.Collections, System.JSON.Serializers,
  System.JSON.Converters, VAShared.JSONUtils,
  Unit7;

type
  TMyRequiredData = class;
  TMyGeneralParameters = class;
  TMyPresentation = class;
  TMyData = class;

  TRequiredType = (reqNo, reqOptional, reqRequired);

  [DefaultValues(Ord(reqNo), 'req')]
  TJsonRequiredTypeConverter = class(TJsonEnumNameWithDefaultConverter);

  TMyReturnData = class(TReturnData)
  private
    FOwnerMyRequiredData: TMyRequiredData;
    FMyRequired: TRequiredType;
  protected
    procedure PopulateOwner(AOwner: TMyRequiredData);
  public
    property OwnerMyRequiredData: TMyRequiredData read FOwnerMyRequiredData;
    [JsonConverter(TJsonRequiredTypeConverter)]
    property Required: TRequiredType read FMyRequired write FMyRequired;
  end;

  TMyTesting = class(TTesting)
  private
    FOwnerMyGeneralParameters: TMyGeneralParameters;
    FXYZ2: integer;
    FXYZ3: integer;
    FXYZ1: integer;
  protected
    procedure PopulateOwner(AOwner: TMyGeneralParameters);
  public
    property OwnerMyGeneralParameters: TMyGeneralParameters read FOwnerMyGeneralParameters;
    property XYZ1: integer read FXYZ1 write FXYZ1;
    [JSonIn]
    property XYZ2: integer read FXYZ2 write FXYZ2;
    property XYZ3: integer read FXYZ3 write FXYZ3;
  end;

  TMyRequiredData = class(TRequiredData)
  private
    FMyReturnData: TObjectList<TMyReturnData>;
    FOwnerMyPresentation: TMyPresentation;
  protected
    procedure PopulateOwner(AOwner: TMyPresentation);
  public
    constructor Create;
    destructor Destroy; override;
    property OwnerMyPresentation: TMyPresentation read FOwnerMyPresentation;
    property ReturnData: TObjectList<TMyReturnData> read FMyReturnData;
  end;

  TMyGeneralParameters = class(TGeneralParameters)
  private
    FMyTesting: TMyTesting;
    FOwnerMyData: TMyData;
  protected
    procedure PopulateOwner(AOwner: TMyData);
  public
    constructor Create;
    destructor Destroy; override;
    property OwnerMyData: TMyData read FOwnerMyData;
    property Testing: TMyTesting read FMyTesting;
  end;

  TMyPresentation = class(TPresentation)
  private
    FMyRequiredData: TObjectList<TMyRequiredData>;
    FOwnerMyData: TMyData;
  protected
    procedure PopulateOwner(AOwner: TMyData);
  public
    constructor Create;
    destructor Destroy; override;
    property OwnerMyData: TMyData read FOwnerMyData;
    property RequiredData: TObjectList<TMyRequiredData> read FMyRequiredData;
  end;

  TMySection = class(TSection)
  private
    FOwnerMyData: TMyData;
  protected
    procedure PopulateOwner(AOwner: TMyData);
  public
    property OwnerMyData: TMyData read FOwnerMyData;
  end;

  TMyData = class(TData)
  private
    FMyGeneralParameters: TMyGeneralParameters;
    FMyPresentation: TObjectList<TMyPresentation>;
    FMySections: TObjectList<TMySection>;
  protected
    procedure PopulateOwner;
  public
    constructor Create;
    destructor Destroy; override;
    function ToJSON: string;
    property GeneralParameters: TMyGeneralParameters read FMyGeneralParameters;
    property Presentation: TObjectList<TMyPresentation> read FMyPresentation;
    property Sections: TObjectList<TMySection> read FMySections;
  end;

function CreateMyData(JSON: string): TMyData;
function ToJSON(AObject: TObject): string;

implementation

uses
  System.SysUtils, System.JSON, System.JSON.Writers,
  System.JSON.Readers, System.Rtti, System.TypInfo, VAShared.RttiUtils;

procedure FreeAndNilOld(ATypeInf: PTypeInfo; Instance: TObject; FieldName: string);
var
  LField: TRttiField;
begin
  LField := GetRttiField(ATypeInf, FieldName);
  if Assigned(LField) then
  begin
    LField.GetValue(Instance).AsObject.Free;
    LField.SetValue(Instance, nil);
  end;
end;

{ TMyReturnData }

procedure TMyReturnData.PopulateOwner(AOwner: TMyRequiredData);
begin
    FOwnerMyRequiredData := AOwner;
end;

{ TMyTesting }

procedure TMyTesting.PopulateOwner(AOwner: TMyGeneralParameters);
begin
    FOwnerMyGeneralParameters := AOwner;
end;

{ TMyRequiredData }

constructor TMyRequiredData.Create;
begin
  inherited Create;
  FreeAndNilOld(TypeInfo(TObjectList<TReturnData>), Self, 'FReturnData');
  FMyReturnData := TObjectList<TMyReturnData>.Create(True);
end;

destructor TMyRequiredData.Destroy;
begin
  FreeAndNil(FMyReturnData);
  inherited;
end;

procedure TMyRequiredData.PopulateOwner(AOwner: TMyPresentation);
begin
    FOwnerMyPresentation := AOwner;
  for var I := 0 to FMyReturnData.Count - 1 do
    FMyReturnData[I].PopulateOwner(Self);
end;

{ TMyGeneralParameters }

constructor TMyGeneralParameters.Create;
begin
  inherited Create;
  FreeAndNilOld(TypeInfo(TTesting), Self, 'FTesting');
  FMyTesting := TMyTesting.Create;
end;

destructor TMyGeneralParameters.Destroy;
begin
  FreeAndNil(FMyTesting);
  inherited;
end;

procedure TMyGeneralParameters.PopulateOwner(AOwner: TMyData);
begin
    FOwnerMyData := AOwner;
  FMyTesting.PopulateOwner(Self);
end;

{ TMyPresentation }

constructor TMyPresentation.Create;
begin
  inherited Create;
  FreeAndNilOld(TypeInfo(TObjectList<TRequiredData>), Self, 'FRequiredData');
  FMyRequiredData := TObjectList<TMyRequiredData>.Create(True);
end;

destructor TMyPresentation.Destroy;
begin
  FreeAndNil(FMyRequiredData);
  inherited;
end;

procedure TMyPresentation.PopulateOwner(AOwner: TMyData);
begin
    FOwnerMyData := AOwner;
  for var I := 0 to FMyRequiredData.Count - 1 do
    FMyRequiredData[I].PopulateOwner(Self);
end;

{ TMySection }

procedure TMySection.PopulateOwner(AOwner: TMyData);
begin
    FOwnerMyData := AOwner;
end;

{ TMyData }

constructor TMyData.Create;
begin
  inherited Create;
  FreeAndNilOld(TypeInfo(TGeneralParameters), Self, 'FGeneralParameters');
  FMyGeneralParameters := TMyGeneralParameters.Create;
  FreeAndNilOld(TypeInfo(TObjectList<TPresentation>), Self, 'FPresentation');
  FMyPresentation := TObjectList<TMyPresentation>.Create(True);
  FreeAndNilOld(TypeInfo(TObjectList<TSection>), Self, 'FSections');
  FMySections := TObjectList<TMySection>.Create(True);
end;

destructor TMyData.Destroy;
begin
  FreeAndNil(FMySections);
  FreeAndNil(FMyPresentation);
  FreeAndNil(FMyGeneralParameters);
  inherited;
end;

procedure TMyData.PopulateOwner;
begin
  FMyGeneralParameters.PopulateOwner(Self);
  for var I := 0 to FMyPresentation.Count - 1 do
    FMyPresentation[I].PopulateOwner(Self);
  for var I := 0 to FMySections.Count - 1 do
    FMySections[I].PopulateOwner(Self);
end;

var
  MyDataJSONLibrary: string;
  MyDataJSONSerializerRegistered: Boolean = False;

function TMyData.ToJSON: string;
begin
  TJSONMapper<TMyData>.SetDefaultLibrary(MyDataJSONLibrary);
  Result := TJSONMapper<TMyData>.Default.ToString(Self);
end;

function CreateMyData(JSON: string): TMyData;
begin
  TJSONMapper<TMyData>.SetDefaultLibrary(MyDataJSONLibrary);
  Result := TJSONMapper<TMyData>.Default.FromObject(JSON);
end;

function ToJSON(AObject: TObject): string;
begin
  TJSONMapper<TMyData>.SetDefaultLibrary(MyDataJSONLibrary);
  Result := TJSONMapper<TObject>.Default.ToString(AObject);
end;

type
  TJsonListConverterMyReturnData = class(TJsonTypedListConverter<TMyReturnData>);
  TJsonListConverterMyRequiredData = class(TJsonTypedListConverter<TMyRequiredData>);
  TJsonListConverterMyPresentation = class(TJsonTypedListConverter<TMyPresentation>);
  TJsonListConverterMySection = class(TJsonTypedListConverter<TMySection>);

  TMyDataJSONSerializer = class(TJsonSerializer)
  public
    constructor Create;
  end;

{ TMyDataJSONSerializer }

constructor TMyDataJSONSerializer.Create;
var
  AAttributes: TJsonDynamicAttributes;
  AFieldType: TRttiType;
  AResolver: TJsonDynamicContractResolver;
  Ctx: TRttiContext;

  procedure Init;
  var
    LField: TRttiField;
  begin
    AResolver := TJsonDynamicContractResolver.Create(TJsonMemberSerialization.Public);
    ContractResolver := AResolver;
    LField := GetRttiField(TypeInfo(TJsonDynamicContractResolver), 'FDynamicAttributes');
    if Assigned(LField) then
      AAttributes := LField.GetValue(AResolver).AsType<TJsonDynamicAttributes>
    else
      AAttributes := nil;
    AFieldType := Ctx.GetType(TRttiType);
  end;

  procedure IgnoreProperties(AClass: TClass; ATypeInf: PTypeInfo);
  var
    I, J: Integer;
    PropList: TArray<string>;
    LProp: TRttiProperty;
    LType: TRttiType;
  begin
    LType := Ctx.GetType(ATypeInf);
    for LProp in LType.GetProperties do
    begin
      if LProp.HasAttribute<JsonInAttribute> then
        continue;
      if (not(LProp.Visibility in [mvPublic, mvPublished])) or
        (LProp.Parent.Name <> AClass.ClassName) then
      begin
        SetLength(PropList, Length(PropList) + 1);
        PropList[Length(PropList) - 1] := LProp.Name;
      end;
    end;
    for I := Length(PropList) - 1 downto 0 do
      for LProp in LType.GetProperties do
        if (CompareText(PropList[I], LProp.Name) = 0) and
          (LProp.Parent.Name = AClass.ClassName) then
        begin
          AResolver.SetPropertyName(ATypeInf, PropList[I], LProp.Name);
          for J := I to Length(PropList) - 2 do
            PropList[J] := PropList[J + 1];
          SetLength(PropList, Length(PropList) - 1);
          AAttributes.AddAttribute(LProp, JsonIgnoreAttribute.Create);
          break;
        end;
    AResolver.SetPropertiesIgnored(ATypeInf, PropList);
  end;

begin
  inherited Create;
  Ctx := TRttiContext.Create;
  try
    Init;
    IgnoreProperties(TReturnData, TypeInfo(TMyReturnData));
    IgnoreProperties(TTesting, TypeInfo(TMyTesting));
    IgnoreProperties(TRequiredData, TypeInfo(TMyRequiredData));
    IgnoreProperties(TGeneralParameters, TypeInfo(TMyGeneralParameters));
    IgnoreProperties(TPresentation, TypeInfo(TMyPresentation));
    IgnoreProperties(TSection, TypeInfo(TMySection));
    IgnoreProperties(TData, TypeInfo(TMyData));
    AResolver.SetPropertyConverter(TypeInfo(TMyRequiredData), 'ReturnData',
      TJsonListConverterMyReturnData);
    AResolver.SetPropertyConverter(TypeInfo(TMyPresentation), 'RequiredData',
      TJsonListConverterMyRequiredData);
    AResolver.SetPropertyConverter(TypeInfo(TMyData), 'Presentation',
      TJsonListConverterMyPresentation);
    AResolver.SetPropertyConverter(TypeInfo(TMyData), 'Sections',
      TJsonListConverterMySection);
  finally
    Ctx.Free;
  end;
end;

initialization
MyDataJSONLibrary := TMyDataJSONSerializer.QualifiedClassName;
if MyDataJSONLibrary.EndsWith('.' + TMyDataJSONSerializer.ClassName) then
  delete(MyDataJSONLibrary,
    Length(TMyDataJSONSerializer.QualifiedClassName) -
    Length(TMyDataJSONSerializer.ClassName) - 1, MaxInt);

MyDataJSONSerializerRegistered := TJSONMappers.RegisterLibrary
  (MyDataJSONLibrary, TJSONMappers.TOptionality.DontCare,
  TJSONMappers.TOptionality.DontCare, TJSONMappers.TOptionality.DontCare,
  procedure(const AName: string; const ASerItems: TJSONMappers.TItem;
    var AIntro: string; var AReqUnit: string)
  const
    CSerItems: array [TJSONMappers.TItem] of string = ('Public', 'Fields');
  begin
    AIntro := '[JsonSerialize(TJsonMemberSerialization.' + CSerItems
      [ASerItems] + ')]';
    AReqUnit := MyDataJSONLibrary;
  end,
  procedure(const AName, AOrigName: string; const AElem: TJSONMappers.TItem;
    var AIntro: string; var AReqUnit: string)
  begin
    if AnsiSameText(AName, AOrigName) and (AElem <> TJSONMappers.TItem.Field) then
      Exit;
    AIntro := '[JsonName(''' + AOrigName + ''')]';
    AReqUnit := MyDataJSONLibrary;
  end,
  procedure(const AItemType: string; var AIntro, AReqUnit,
    AInstantiation: string)
  begin
  var
    LConv := StringReplace(AItemType, '<', '', [TReplaceFlag.rfReplaceAll]);
    LConv := 'TJsonListConverter' + StringReplace(LConv, '>', '',
      [TReplaceFlag.rfReplaceAll]);
    AIntro := '[JsonConverter(' + LConv + ')]';
    AReqUnit := MyDataJSONLibrary;
    AInstantiation := LConv + ' = class(TJsonListConverter<' + AItemType + '>)';
  end,
  function(ApValue: Pointer; ApTypeInfo: PTypeInfo): TJSONObject
  var
    LSer: TMyDataJSONSerializer;
    LWrt: TJsonObjectWriter;
    V: TValue;
  begin
    LSer := TMyDataJSONSerializer.Create;
    LWrt := TJsonObjectWriter.Create(False);
    try
      TValue.Make(ApValue, ApTypeInfo, V);
      LSer.Serialize(LWrt, V);
      Result := LWrt.JSON as TJSONObject;
    finally
      LWrt.Free;
      LSer.Free;
    end;
  end,
  function(AValue: TJSONObject; ApTypeInfo: PTypeInfo): TValue
  var
    LSer: TMyDataJSONSerializer;
    LRdr: TJsonObjectReader;
  begin
    LSer := TMyDataJSONSerializer.Create;
    LRdr := TJsonObjectReader.Create(AValue);
    try
      Result := LSer.Deserialize(LRdr, ApTypeInfo);
    finally
      LRdr.Free;
      LSer.Free;
    end;
  end);

finalization

if MyDataJSONSerializerRegistered then
  TJSONMappers.UnRegisterLibrary(MyDataJSONLibrary);

end.

