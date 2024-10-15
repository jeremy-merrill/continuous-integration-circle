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
  ORFn,
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
CHTML2 = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Long List Example</title>
  <style>
    /* Your CSS here */
  </style>
</head>
<body>
  <div class="long-list"> <!-- Container for the input field and dropdown -->
    <form id="myForm">
      <input type="text" id="searchBox" class="long-list-input" name="search" data-rpc="YourRPCName" placeholder="Start typing...">
      <button type="submit">Submit</button>
    </form>
    <div class="dropdown-list" id="dropdown"> <!-- Dropdown list -->
      <!-- Dropdown options will be populated here -->
    </div>
  </div>
  <script>
    // Your JavaScript here
  </script>
</body>
</html>
''';
CHTML = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Long List Example</title>
</head>
<body>
  <form id="myForm">
    <input type="text" id="searchBox" class="long-list" name="search" data-rpc="YourRPCName" placeholder="Start typing...">
    <button type="submit">Submit</button>
  </form>
</body>
</html>
''';

CJS = '''
document.addEventListener('DOMContentLoaded', function() {
  var input = document.getElementById('searchBox');
  var dropdown = document.createElement('div');
  dropdown.className = 'dropdown-list';
  input.parentNode.insertBefore(dropdown, input.nextSibling);

  input.addEventListener('focus', function() {
    dropdown.classList.add('show');
  });

  input.addEventListener('blur', function() {
    setTimeout(function() {
      dropdown.classList.remove('show');
    }, 200);
  });

  // For testing, let's add some dummy data to the dropdown
  var dummyData = ['Option 1', 'Option 2', 'Option 3'];
  dummyData.forEach(function(item) {
    var div = document.createElement('div');
    div.textContent = item;
    dropdown.appendChild(div);
  });
});

class LongList {
  constructor(id, rpc) {
    console.log('Creating LongList instance for:', id);
    this.input = document.getElementById(id);
    if (!this.input) {
      console.error('Input element with id "' + id + '" not found');
      return;
    }
    this.rpc = rpc;
    this.createDropdownList();
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
      id: this.input.id,
      rpc: this.rpc,
      search: searchTerm,
      limit: 44
    };
    window.chrome.webview.postMessage(JSON.stringify(data));
  }

  updateEntries(entries) {
    this.dropdownList.innerHTML = '';
   // this.dropdownList.classList.add('show');
    entries.forEach((entry) => {
      const div = document.createElement('div');
      div.textContent = entry;
      div.addEventListener('click', () => {
        this.input.value = entry;
        this.dropdownList.classList.remove('show');
      });
      this.dropdownList.appendChild(div);
    });
    if (entries.length > 0) {
      this.dropdownList.classList.add('show');
    } else {
      this.dropdownList.classList.remove('show');
    }
    console.log('Dropdown list updated:', this.dropdownList.innerHTML);
  }
  createDropdownList() {
    this.dropdownList = document.createElement('div');
    this.dropdownList.className = 'dropdown-list';
    // Insert the dropdown list directly after the input element
    this.input.insertAdjacentElement('afterend', this.dropdownList);
  }
}

function updateLongListEntries(id, entries) {
  const longList = document.longListInstances[id];
  if (longList) {
    longList.updateEntries(entries);
  }
}
''';
CJS2 = '''
// Function to handle form submission
function handleFormSubmit(event) {
  event.preventDefault(); // Prevent the default form submission
  var form = event.target;
  var formData = new FormData(form);

  // Convert form data to a JSON object
  var formObj = {};
  formData.forEach(function(value, key) {
    formObj[key] = value;
  });

  // Add the messageType property
  formObj['type'] = 'submit';

  // Send the message to Delphi
  window.chrome.webview.postMessage(JSON.stringify(formObj));
}

// Event listener for the form's submit event
document.addEventListener('DOMContentLoaded', function() {
  var form = document.getElementById('myForm');
  form.addEventListener('submit', handleFormSubmit);
});
''';
ccss = '''
.long-list {
  position: relative;
  width: 200px;
}

.long-list {
  width: 100%;
  box-sizing: border-box;
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.dropdown-list {
  position: absolute;
  left: 0;
  right: 0;
  top: 100%;
  border: 1px solid #ccc;
  background-color: #fff;
  z-index: 10000;
  display: none;
}

.dropdown-list.show {
  display: block;
}

.dropdown-list div {
  padding: 8px;
  border-bottom: 1px solid #eee;
}

.dropdown-list div:hover {
  background-color: #f0f0f0;
}
''';

fetchdata = '''
520824667^Merrill,Jeremy^- Systems Administrator
520824705^Michael,David R^- Systems Administrator
520824704^Napoliello,Gregory S^- Systems Administrator
20171^Nurse,Eight^- Nurse
20181^Nurse,Eighteen^- Nurse
20174^Nurse,Eleven^- Nurse
20178^Nurse,Fifteen^- Nurse
20213^Nurse,Fifty^- Nurse
20214^Nurse,Fifty-One^- Nurse
20168^Nurse,Five^- Nurse
20203^Nurse,Forty^- Nurse
20211^Nurse,Forty-Eight^- Nurse
20208^Nurse,Forty-Five^- Nurse
20207^Nurse,Forty-Four^- Nurse
20212^Nurse,Forty-Nine^- Nurse
20204^Nurse,Forty-One^- Nurse
20210^Nurse,Forty-Seven^- Nurse
20209^Nurse,Forty-Six^- Nurse
20206^Nurse,Forty-Three^- Nurse
20205^Nurse,Forty-Two^- Nurse
20167^Nurse,Four^- Nurse
20177^Nurse,Fourteen^- Nurse
520824700^Nurse,Jeremy^- Nurse
20172^Nurse,Nine^- Nurse
20182^Nurse,Nineteen^- Nurse
20112^Nurse,One^- Nurse
20170^Nurse,Seven^- Nurse
20180^Nurse,Seventeen^- Nurse
20169^Nurse,Six^- Nurse
20179^Nurse,Sixteen^- Nurse
20173^Nurse,Ten^- Nurse
20176^Nurse,Thirteen^- Nurse
20193^Nurse,Thirty^- Nurse
20201^Nurse,Thirty-Eight^- Nurse
20198^Nurse,Thirty-Five^- Nurse
20197^Nurse,Thirty-Four^- Nurse
20202^Nurse,Thirty-Nine^- Nurse
20194^Nurse,Thirty-One^- Nurse
20200^Nurse,Thirty-Seven^- Nurse
20199^Nurse,Thirty-Six^- Nurse
20196^Nurse,Thirty-Three^- Nurse
20195^Nurse,Thirty-Two^- Nurse
20115^Nurse,Three^- Nurse
20175^Nurse,Twelve^- Nurse
''';

procedure TfrmMain.btnLoadClick(Sender: TObject);
var
  sl: TStringList;
  name, data, html, js, css, js2: string;
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
  js2 := '<script>' + cjs2 + '</script>';
  html :=  StringReplace(html, '</head>', css + '</head>', []);
  html :=  StringReplace(html, '</body>', js2 + '</body>', []);
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
var
  JSonStr: PWideChar;
  JSON: TJSONValue;
  typ, id, data, name, rec, fetch: string;
  p, i: integer;
begin
  if Args.ArgsInterface.TryGetWebMessageAsString(JSonStr) = S_OK then
  begin
    JSON := TJSONValue.ParseJSONValue(JSonStr);
    typ := JSON.AsTypeDef<string>('type','');
    id := JSON.AsTypeDef<string>('id','');
    if typ = 'rpc' then
    begin
      fetch := fetchdata;
      data := '';
      i := 0;

      while fetch <> '' do
      begin
        rec := piece(fetch,#13,1);
        name := Piece(rec,u,2);
        if Data <> '' then
          Data := Data + ',';
        Data := Data + '"' + name + '"';
        p := pos(#13, fetch);
        if p = 0 then
          fetch := ''
        else
          fetch := copy(fetch, p + 1, MaxInt);
      end;
      Data := '[' + Data + ']';
      eb.ExecuteScript(Format('updateLongListEntries("%s", %s);', [id, Data]));
    end
    else
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
