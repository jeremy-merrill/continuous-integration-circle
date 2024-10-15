unit Unit6;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, System.JSON, Rest.JSON;

type
  TForm6 = class(TForm)
    re: TRichEdit;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    gpMain: TGridPanel;
    lblPrefix: TLabel;
    edtPrefix: TEdit;
    lblSuffix: TLabel;
    edtSuffix: TEdit;
    cbIncludeOwners: TCheckBox;
    lblOwnerName: TLabel;
    cboOwnerName: TComboBox;
    cbTopLevelOwner: TCheckBox;
    lblTopOwnerClass: TLabel;
    edtTopOwnerClass: TEdit;
    cboUnit: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

uses
  // Unit7, Unit8, // Unit9,
  uPtInfoCore, uPtInfoCommon,
  System.Rtti, System.TypInfo,
  IDEUtils.JSONDescendantClassesCommon;

type
  TObj = class
  private
    FClassName: string;
    // FOwnerClass: string;
    FDataClass: string;
    FPrivateSection: TStringList;
    FPublicSection: TStringList;
    FCreateSection1: TStringList;
    FCreateSection2: TStringList;
    FDestroySection: TStringList;
  public
    constructor Create(AClassName: string);
    destructor Destroy; override;
  end;

const
  Prop = 'property ';
  Mgr = 'Controller';
  ObjList = 'TObjectList<';
  ArrayList = 'TArray<';

procedure TForm6.Button1Click(Sender: TObject);
var
  sl: TStringList;
  UnitInfo: TUnitInfo;
begin
  UnitInfo := TUnitInfo.Create;
  sl := TStringList.Create;
  try
    UnitInfo.ProjectUnitName := 'Unit7';
    UnitInfo.ProjectFileName := 'C:\Jeremy\Embarcadero\Unit7.pas';
    UnitInfo.Prefix := edtPrefix.Text;
    UnitInfo.Suffix := edtSuffix.Text;
    UnitInfo.BuildOwners := cbIncludeOwners.Checked;
    UnitInfo.TopClassOwner := cbTopLevelOwner.Checked;
    UnitInfo.OwnerName := cboOwnerName.Text;
    UnitInfo.TopClassOwnerName := edtTopOwnerClass.Text;
    sl.LoadFromFile(UnitInfo.ProjectFileName);
    GatherUnitInfo(sl, UnitInfo);
    BuildDescendantUnit(sl, UnitInfo);
    re.Clear;
    re.Lines.AddStrings(sl);
  finally
    UnitInfo.Free;
    sl.Free;
  end;
end;

{ TObj }

constructor TObj.Create(AClassName: string);
begin
  FDataClass := AClassName;
  FClassName := AClassName + Mgr;
  FPrivateSection := TStringList.Create;
  FPublicSection := TStringList.Create;
  FCreateSection1 := TStringList.Create;
  FCreateSection2 := TStringList.Create;
  FDestroySection := TStringList.Create;
end;

destructor TObj.Destroy;
begin
  FPrivateSection.Free;
  FPublicSection.Free;
  FCreateSection1.Free;
  FCreateSection2.Free;
  FDestroySection.Free;
  inherited;
end;

procedure TForm6.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm6.Button3Click(Sender: TObject);

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

begin
  re.Lines.LoadFromFile
    ('C:\Jeremy\GitHub\CPRSv33con\CPRS-chart\InfoPanel\PtInfoData.json');
  var
  MyObj := TPtInfoDataConverter.ToObject<TPtInfoData, TPtInfoSplitViewBase>(re.Lines.Text, nil);
  try
    re.Lines.Clear;
    var
    s := TPtInfoDataConverter.ToJSON<TPtInfoData>(MyObj);
    s := FormatJSON(s);
    re.Clear;
    re.Lines.Add(s);
  finally
    MyObj.Free;
  end;
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
  cboOwnerName.Items.Add(OwnerNamePlusClass);
  cboOwnerName.Items.Add(OwnerNameFromClass);
  cboOwnerName.Items.Add(OwnerNameOwner);
  cboOwnerName.ItemIndex := 0;
end;

end.
