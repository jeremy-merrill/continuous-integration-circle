unit Unit2;
// orsInPrivate
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.TypInfo,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ComCtrls, ORSymbolLabel, VA508AccessibilityManager, System.ImageList,
  Vcl.ImgList, JvExStdCtrls, JvListComb;

type
  TForm3 = class(TForm)
    re: TRichEdit;
    Label1: TLabel;
    Panel1: TPanel;
    Label2: TLabel;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    ORSymbolLabel1: TORSymbolLabel;
    ORSymbolLabel2: TORSymbolLabel;
    Panel2: TPanel;
    rgSSize: TRadioGroup;
    lblSSize: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure rgSSizeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

uses
  Winapi.UI.Xaml.ControlsRT,
  ORFn,
  VAUtils,
  ORSymbolLabelPE;

procedure TForm3.FormCreate(Sender: TObject);
var
  i, j: Integer;
  sl: TStringList;
  Found: Boolean;
begin
(*
  sl := TStringList.Create;
  try
    for j := 0 to High(ORSymbolTable3) do
      sl.AddObject(ORSymbolTable3[j].Name, TObject(ORSymbolTable3[j].Value));
    for i := 0 to High(ORSymbolTable4) do
    begin
      Found := False;
      for j := 0 to High(ORSymbolTable3) do
      begin
        if ORSymbolTable4[i].Value = ORSymbolTable3[j].Value then
        begin
          Found := True;
          break;
        end;
      end;
      if not Found then
      begin
        sl.AddObject(ORSymbolTable4[i].Name, TObject(ORSymbolTable4[i].Value));
//        SetLength(ORSymbolTable, length(ORSymbolTable) + 1);
//        ORSymbolTable4[i];
//        re.Font.Name := 'Segoe MDL2 Assets';
//        re.Lines.Add(Char(ORSymbolTable2[i].Value) + #9 +
//          ORSymbolTable2[i].Value.ToString + #9 + ORSymbolTable2[i].Name);
      end;
    end;
    sl.Sort;
    for i := 0 to High(ORSymbolTable2) do
      sl.InsertObject(i, ORSymbolTable2[i].Name, TObject(ORSymbolTable2[i].Value));
    for i := 0 to sl.Count-1 do
      re.Lines.Add(Format('(Name: ''%s''; Value: $%s),',[sl[i], IntToHex(Integer(sl.Objects[i]), 4)]));
  finally
    sl.Free;
  end;   *)
end;
(*
var
  sl: TStringList;
  i, p: Integer;
  hex, line: string;
begin
  sl := TStringList.Create;
  try
    sl.LoadFromFile('C:\Jeremy\Embarcadero\Unit2.pas');
    for i := 42 to 1427 do
    begin
      line := sl[i];
      p := pos(#9, line);
      if p > 0 then
      begin
        line := copy(line, p, MaxInt).Trim;
        p := pos(#9, line);
        if p > 0 then
        begin
          hex := copy(line,1, p-1);
          line := copy(line,p,MaxInt).Trim;
          re.Lines.Add(Format('    (Name: ''%s''; Value: $%s),', [line, hex]));
        end;
      end;
    end;
  finally
    sl.Free;
  end;
end;
  *)
procedure TForm3.Panel1Click(Sender: TObject);
var
  Dlg: TfrmORSymbolLabelPE;
begin
  Dlg := TfrmORSymbolLabelPE.Create(Application);
  try
    Dlg.symMain.Symbol := ORSymbolLabel1.Symbol;
    Dlg.UpdateCtrls;
    if Dlg.ShowModal = mrOK then
      ORSymbolLabel1.Symbol := Dlg.symMain.Symbol;
  finally
    Dlg.Free;
  end;
end;

procedure TForm3.rgSSizeClick(Sender: TObject);
begin
  ORSymbolLabel1.Font.Size := rgSSize.ItemIndex * 2 + 8;
  lblSSize.Caption := 'Size: ' + IntToStr(ORSymbolLabel1.SymbolSize);
end;

end.
