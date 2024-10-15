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
  Winapi.WebView2,
  Winapi.ActiveX,
  Vcl.Edge,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  VAShared.UWebUtils,
  VAShared.UVarManager,
  Vcl.ExtCtrls;

type
  TForm14 = class(TForm)
    Button1: TButton;
    Label1js: TLabel;
    re: TRichEdit;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Button2: TButton;
    reREST: TRichEdit;
    Label2: TLabel;
    Label1: TLabel;
    Splitter2: TSplitter;
    Label4: TLabel;
    reJSON: TRichEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FRunner: TJavaScriptRunner;
    procedure ExecuteScriptEvent(Sender: TCustomEdgeBrowser; AResult: HResult;
      const AResultObjectAsJson: string);
  public
    { Public declarations }
  end;

var
  Form14: TForm14;

implementation

{$R *.dfm}
{ TForm14 }

procedure TForm14.Button1Click(Sender: TObject);
begin
  if not assigned(FRunner) then
    FRunner := TJavaScriptRunner.Create(ExecuteScriptEvent);
  Label1.Caption := '';
  Label1.Repaint;
  if not FRunner.Execute(re.Lines.Text) then
    Label1.Caption := 'Timeout';
end;

procedure TForm14.Button2Click(Sender: TObject);
var
  Engine: TRESTAPIEngine;
begin
  Engine := TRESTAPIEngine.Create(reJSON.Lines.Text);
  try
    Label4.Caption := 'JSON for ' + Engine.RESTApi.name;
  finally
    FreeAndNil(Engine);
  end;
end;

procedure TForm14.ExecuteScriptEvent(Sender: TCustomEdgeBrowser;
  AResult: HResult; const AResultObjectAsJson: string);
begin
  Label1.Caption := IntToStr(AResult) + ' ' + AResultObjectAsJson;
end;

procedure TForm14.FormCreate(Sender: TObject);
begin
  FRunner := TJavaScriptRunner.Create(ExecuteScriptEvent);
  // FRunner.Timeout := 1;
  reJSON.Lines.LoadFromFile('C:\Jeremy\Embarcadero\REST\AIGenerated\REST.json');
end;

procedure TForm14.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FRunner);
end;


// System.Classes,
// System.Generics.Collections,
// System.JSON,
// System.TypInfo,
// REST.Client,
// REST.Types,
// VAShared.UJSONValueHelper,

end.
