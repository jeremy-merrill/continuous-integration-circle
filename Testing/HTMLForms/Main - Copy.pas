unit Main;

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
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Edge,
  System.JSON,
  VAShared.UJSONValueHelper,
  Trpcb,
  Vcl.ComCtrls;

type
  TfrmMain = class(TForm)
    eb: TEdgeBrowser;
    Panel1: TPanel;
    btnLoad: TButton;
    broker: TRPCBroker;
    re: TRichEdit;
    procedure btnLoadClick(Sender: TObject);
    procedure ebNavigationCompleted(Sender: TCustomEdgeBrowser;
      IsSuccess: Boolean; WebErrorStatus: COREWEBVIEW2_WEB_ERROR_STATUS);
    procedure ebWebMessageReceived(Sender: TCustomEdgeBrowser;
      Args: TWebMessageReceivedEventArgs);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ebExecuteScript(Sender: TCustomEdgeBrowser; AResult: HRESULT;
      const AResultObjectAsJson: string);
  private
    // FJSON: TJSONObject;
    // FList: TJSONArray;
    // FJSONIndex: Integer;
    Started: Boolean;
    // procedure InjectCSSandJavaScript;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

const
CHTML = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Long List Example</title>
  <style>
    /* Your CSS content here */
  </style>
</head>
<body>
  <div class="long-list">
    <input type="text" id="searchBox" class="long-list-input" data-rpc="YourRPCName" placeholder="Start typing...">
    <!-- The dropdown list will be created by the LongList class -->
  </div>
</body>
</html>
''';

CJS = '''
class LongList {
  constructor(id, rpc) {
    this.input = document.getElementById(id);
    this.rpc = rpc;
    this.dropdownList = document.createElement('div');
    this.dropdownList.className = 'dropdown-list';
    this.input.parentNode.insertBefore(this.dropdownList, this.input.nextSibling);
    this.setupInputListener();
    document.longListInstances[id] = this;
  }

  setupInputListener() {
    this.input.addEventListener('input', (event) => {
      const searchTerm = event.target.value;
      if (searchTerm.length >= 3) {
        this.fetchEntries(searchTerm);
      }
    });

    this.input.addEventListener('focus', () => {
      this.dropdownList.classList.add('show');
    });

    this.input.addEventListener('blur', () => {
      setTimeout(() => {
        this.dropdownList.classList.remove('show');
      }, 200);
    });
  }

  fetchEntries(searchTerm) {
    const data = {
      type: 'rpc',
      rpc: this.rpc,
      search: searchTerm,
      limit: 44
    };
    window.chrome.webview.postMessage(JSON.stringify(data));
  }

  updateEntries(entries) {
    this.dropdownList.innerHTML = '';
    entries.forEach((entry) => {
      const div = document.createElement('div');
      div.textContent = entry;
      div.addEventListener('click', () => {
        this.input.value = entry;
        this.dropdownList.classList.remove('show');
      });
      this.dropdownList.appendChild(div);
    });
  }
}

function updateLongListEntries(id, entries) {
  const longList = document.longListInstances[id];
  if (longList) {
    longList.updateEntries(entries);
  }
}

document.longListInstances = {};
window.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.long-list-input').forEach((input) => {
    const rpc = input.getAttribute('data-rpc');
    new LongList(input.id, rpc);
  });
});
''';

CCSS = '''
.long-list {
  position: relative;
  width: 200px; /* Adjust width as needed */
}

.long-list input[type="text"] {
  width: 100%;
  box-sizing: border-box;
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.long-list .dropdown-list {
  position: absolute;
  width: 100%;
  max-height: 200px; /* Adjust height as needed */
  overflow-y: auto; /* Enables scrollbar */
  border: 1px solid #ccc;
  border-top: none; /* Seamless transition from input to dropdown */
  box-sizing: border-box;
  display: none; /* Hide dropdown initially */
  background-color: #fff;
  z-index: 1000; /* Ensure dropdown is above other content */
}

.long-list .dropdown-list.show {
  display: block; /* Show dropdown */
}

.long-list .dropdown-list div {
  padding: 8px;
  cursor: pointer;
  border-bottom: 1px solid #eee; /* Separate options visually */
}

.long-list .dropdown-list div:hover {
  background-color: #f0f0f0;
}
''';
procedure TfrmMain.btnLoadClick(Sender: TObject);
var
  sl: TStringList;
  name, data, html, js, css: string;
  JSON: TJSONObject;
  list: TJSONArray;
begin
  btnLoad.Enabled := False;
 { broker.Connected := True;
  broker.RemoteProcedure := 'ORWEB GETWEBDATA';
  broker.Param[0].PType := literal;
  broker.Param[0].value := 'LongList';
  broker.Call;
  JSON := nil;
  sl := TStringList.Create;
  try
    sl.LineBreak := '';
    sl.Assign(broker.Results);
    JSON := TJSONValue.ParseJSONValue(sl.text) as TJSONObject;
    re.Clear;
    re.Lines.Add(JSON.Format);
    js := '';
    css := '';
    list := JSON.AsTypeDef<TJSONArray>('files', nil);
    if Assigned(list) then
      for var i := 0 to list.Count - 1 do
      begin
        name := list[i].AsTypeDef<string>('name', '');
        data := list[i].AsTypeDef<string>('data', '');
        if name.EndsWith('.css') then
          css := css + '<style>' + data + '</style>'
        else if name.EndsWith('.js') then
          js := js + '<script>' + data + '</script>';
      end;
    name := JSON.AsTypeDef<string>('name', '');
    html := JSON.AsTypeDef<string>('data', '');
    if name.EndsWith('.html') then
    begin
      html :=  StringReplace(html, '</head>', css + '</head>', []);
      html :=  StringReplace(html, '</body>', js + '</body>', []);
      eb.NavigateToString(html);
    end;
  finally
    FreeAndNil(JSON);
    FreeAndNil(sl);
  end;   }
  html :=chtml;
  css := '<style>' + ccss + '</style>';
  js := '<script>' + cjs + '</script>';
  html :=  StringReplace(html, '</head>', css + '</head>', []);
  html :=  StringReplace(html, '</body>', js + '</body>', []);
  re.Lines.Clear;
  re.Lines.Add(html);
  eb.NavigateToString(html);
end;

procedure TfrmMain.ebExecuteScript(Sender: TCustomEdgeBrowser; AResult: HRESULT;
  const AResultObjectAsJson: string);
begin
  // if AResult = 0 then
  // InjectCSSandJavaScript;
end;

procedure TfrmMain.ebNavigationCompleted(Sender: TCustomEdgeBrowser;
  IsSuccess: Boolean; WebErrorStatus: COREWEBVIEW2_WEB_ERROR_STATUS);
begin
  // if IsSuccess then
  // InjectCSSandJavaScript;
  // eb.ExecuteScript('console.log(''Terstingt'')');
end;

procedure TfrmMain.ebWebMessageReceived(Sender: TCustomEdgeBrowser;
  Args: TWebMessageReceivedEventArgs);
var JSonStr: PWideChar; JSON: TJSONValue;
begin
  if Args.ArgsInterface.TryGetWebMessageAsString(JSonStr) = S_OK then
  begin
    JSON := TJSONValue.ParseJSONValue(JSonStr);
    ShowMessage(JSON.Format);
  end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  // FreeAndNil(FJSON);
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  if not Started then
  begin
    eb.CreateWebView;
    Started := True;
  end;
end;

{
  procedure TfrmMain.InjectCSSandJavaScript;
  var
  name, data: string;
  scriptContent: string;
  begin
  if assigned(FList) then
  begin
  if FJSONIndex < FList.Count then
  begin
  name := FList[FJSONIndex].AsTypeDef<string>('name', '');
  data := FList[FJSONIndex].AsTypeDef<string>('data', '');
  ShowMessage(data);
  if (name <> '') and (data <> '') then
  begin
  if name.EndsWith('.css') then
  begin
  data := StringReplace(data, sLineBreak, ' ', [rfReplaceAll]);
  data := StringReplace(data, '''', '\''', [rfReplaceAll]);

  scriptContent := Format(
  'var styleElement = document.createElement("style");' +
  'styleElement.type = "text/css";' +
  'styleElement.innerHTML = ''%s'';' +
  'document.head.appendChild(styleElement);', [data]);
  eb.ExecuteScript(scriptContent);
  inc(FJSONIndex);
  end else if name.EndsWith('.js') then
  begin
  data := StringReplace(data, sLineBreak, ' ', [rfReplaceAll]);
  eb.ExecuteScript(data);
  inc(FJSONIndex);
  end;
  end;
  end;
  end;
  end;
}
end.
