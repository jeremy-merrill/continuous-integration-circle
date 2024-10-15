unit Unit12;

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
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  uSpecialAuthority,
  Unit13,
  System.JSON;

type
  TForm12 = class(TForm)
    Button1: TButton;
    re: TRichEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form12: TForm12;
  SA: TJMSpecialAuthorities;

implementation

{$R *.dfm}

procedure TForm12.Button1Click(Sender: TObject);
var
  sl: TStringList;
  jv: TJSONValue;
begin
  sl := TStringList.Create;
  try
    sl.LineBreak := '';
    sl.LoadFromFile
      ('C:\Jeremy\GitHub\CPRSv33con\CPRS-chart\SpecialAuthority\PXSPECAUTH SPECAUTHDEF.json');
    SA := TJMSpecialAuthoritiesConverter.
      ToObject<TJMSpecialAuthorities>(sl.Text);
    re.Clear;
    jv := TJSONValue.ParseJSONValue
      (TJMSpecialAuthoritiesConverter.ToJSON<TJMSpecialAuthorities>(SA));
    try
      re.Lines.Text := jv.Format(3);
    finally
      jv.Free;
    end;
  finally
    sl.Free;
    FreeAndNil(SA);
  end;
end;

end.
