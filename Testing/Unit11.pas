unit Unit11;

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
  Vcl.ExtCtrls,
  Vcl.WinXCtrls,
  Vcl.StdCtrls,
  Vcl.CheckLst,
  Vcl.ComCtrls,
  ORCtrls,
  System.Generics.Collections;

type
  TForm11 = class(TForm)
    RadioGroup1: TRadioGroup;
    re: TRichEdit;
    procedure RadioGroup1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form11: TForm11;

implementation

{$R *.dfm}

uses
  System.JSON;

procedure TForm11.FormCreate(Sender: TObject);
var
  list: TList<Single>;
begin
  list := TList<Single>.Create;
  try
    list.Add(123.456);
    list.Add(1.1);
    list.Add(1.14);
    list.Add(1.12);
    list.Add(10);
    list.Add(2);
    list.Add(1.18);
    list.Add(10000);
    list.Add(1.09);
    list.Sort;
    for var i := 0 to list.Count-1 do
      re.Lines.Add(list[i].ToString);
  finally
    list.Free;
  end;
end;

procedure TForm11.RadioGroup1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex >= 0 then
  begin
    Font.Size := (RadioGroup1.ItemIndex * 2) + 8;
  end;
end;

end.
