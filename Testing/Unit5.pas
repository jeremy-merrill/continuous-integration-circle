unit Unit5;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm5 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.FormCreate(Sender: TObject);
const
  Colors: Array [0 .. 24] of string =
//  ('clBlack', 'clMaroon', 'clGreen',
//    'clOlive', 'clNavy', 'clPurple', 'clTeal', 'clGray', 'clSilver', 'clRed',
//    'clLime', 'clYellow', 'clBlue', 'clFuchsia', 'clAqua', 'clWhite',
//    'clMoneyGreen', 'clSkyBlue', 'clCream', 'clMedGray', 'clActiveBorder',
//    'clActiveCaption', 'clAppWorkSpace', 'clBackground', 'clBtnFace',
//    'clBtnHighlight', 'clBtnShadow', 'clBtnText', 'clCaptionText', 'clDefault',
//    'clGradientActiveCaption', 'clGradientInactiveCaption', 'clGrayText',
//    'clHighlight', 'clHighlightText', 'clHotLight', 'clInactiveBorder',
//    'clInactiveCaption', 'clInactiveCaptionText', 'clInfoBk', 'clInfoText',
//    'clMenu', 'clMenuBar', 'clMenuHighlight', 'clMenuText', 'clNone',
//    'clScrollBar', 'cl3DDkShadow', 'cl3DLight', 'clWindow', 'clWindowFrame',
//    'clWindowText');
('clActiveBorder',
'clActiveCaption',
'clAppWorkSpace',
'clAqua',
'clBtnFace',
'clBtnHighlight',
'clCream',
'clFuchsia',
'clGradientActiveCaption',
'clGradientInactiveCaption',
'clHighlightText',
'clInactiveBorder',
'clInactiveCaption',
'clInfoBk',
'clMenu',
'clLime',
'clMenuBar',
'clMoneyGreen',
'clOlive',
'clRed',
'clSilver',
'clSkyBlue',
'clWhite',
'clWindow',
'clYellow') ;

var
  i: Integer;
  pnl: TPanel;
  lbl: TLabel;
begin
  for i := High(Colors) downto 0 do
  begin
    pnl := TPanel.Create(Self);
    pnl.Parent := Self;
    pnl.Align := alTop;
    pnl.Caption := '';//Colors[i];
    pnl.Color := StringToColor(Colors[i]);
    pnl.Height := 19;
    pnl.StyleElements := [];
    lbl := TLabel.Create(Self);
    lbl.Parent := pnl;
    lbl.Align := alLeft;
//    lbl.Font.Color := clWhite;
    lbl.Caption := '  ' + Colors[i];
    lbl := TLabel.Create(Self);
    lbl.Parent := pnl;
    lbl.Align := alRight;
    lbl.Caption := Colors[i] + '  ';
    lbl.Enabled := False;
  end;
end;

end.
