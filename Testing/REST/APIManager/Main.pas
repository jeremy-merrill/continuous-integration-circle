unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Winapi.WebView2, Winapi.ActiveX, Vcl.Edge,
  REST.Authenticator.OAuth.WebForm.Win, Data.Bind.Components,
  Data.Bind.ObjectScope, REST.Client, REST.Authenticator.OAuth, Vcl.OleCtrls,
  SHDocVw, System.SyncObjs;

type
  TForm1 = class(TForm)
    btnTest: TButton;
    re: TRichEdit;
    br2: TEdgeBrowser;
    OAuth: TOAuth2Authenticator;
    procedure btnTestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
//    FEvent: TEvent;
    FResult: string;
    FFlag: boolean;
    procedure CreateWebViewCompleted(Sender: TCustomEdgeBrowser;
      AResult: HRESULT);
    procedure EdgeBrowser1ExecuteScript(Sender: TCustomEdgeBrowser;
      AResult: HRESULT; const AResultObjectAsJson: string);
    procedure WaitForIt;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  ORFn;

{$R *.dfm}

procedure TForm1.CreateWebViewCompleted(Sender: TCustomEdgeBrowser;
  AResult: HRESULT);
begin
  FFlag := True;
//  FEvent.SetEvent;
//
end;

procedure TForm1.btnTestClick(Sender: TObject);
begin
{  var api := TAPIManager.Create('C:\Jeremy\Embarcadero\REST\APIManager\REST.json');
  try
    var res := api.ExecuteAPI(5);
//    br.ur1
    re.Lines.Add('***** Request:');
    re.Lines.Add(res.FullRequestURI);
    re.Lines.Add(#13#10+'***** Headers:');
    re.Lines.Add(res.Headers.Text);
    re.Lines.Add(#13#10+'***** Content:');
    re.Lines.Add(res.Content);
    re.Lines.Add(#13#10+'***** Status: '+ res.StatusCode.ToString + '  ' + res.StatusText);
  finally
    FreeAndNil(api);
  end;}

  var eb := TEdgeBrowser.Create(nil);
  try
    eb.Parent := Self;
    eb.Visible := False;
    eb.OnCreateWebViewCompleted := CreateWebViewCompleted;
    FFlag := False;
//    fevent.ResetEvent;
    eb.CreateWebView;
    WaitForit;
//    fevent.WaitFor(10000);
    eb.OnExecuteScript := EdgeBrowser1ExecuteScript;
//    fevent.ResetEvent;
    FFlag := False;
    eb.ExecuteScript('function test() { return {"aa":"bb","cc":"dd"};}; test();');
    WaitForIt;
//    fevent.WaitFor(10000);
    ShowMessage('Result: ' + FResult);

  finally
    FreeAndNil(eb);
  end;
end;

procedure TForm1.EdgeBrowser1ExecuteScript(Sender: TCustomEdgeBrowser;
  AResult: HRESULT; const AResultObjectAsJson: string);
begin
//  fevent.SetEvent;
  fflag := True;
  FResult := AResultObjectAsJson;
  ShowMessage('Result: ' + IntToStr(AResult) + CRLF + 'JSON: ' + AResultObjectAsJson);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
//  FEvent := TEvent.Create(nil, True, False, '');
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
//  FEvent.Free;
end;

procedure TForm1.WaitForIt;
begin
  while not fflag do
  begin
    Application.ProcessMessages;
    Sleep(10);
  end;

end;

end.
