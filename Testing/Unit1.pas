unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.WinXPanels,
  Vcl.TitleBarCtrls, Vcl.WinXCtrls, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons,
  System.ImageList, Vcl.ImgList, Vcl.Imaging.pngimage, System.Actions,
  Vcl.ActnList, Vcl.BaseImageCollection, Vcl.ImageCollection, Trpcb, TypInfo,
  ORCtrls;

type
  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    re: TRichEdit;
    Button1: TButton;
    ComboBox1: TComboBox;
    Panel1: TPanel;
    rgInner: TRadioGroup;
    GridPanel1: TGridPanel;
    rgKind: TRadioGroup;
    rgOuter: TRadioGroup;
    cb3D: TCheckBox;
    Panel2: TKeyClickPanel;
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure rgInnerClick(Sender: TObject);
    procedure rgKindClick(Sender: TObject);
    procedure rgOuterClick(Sender: TObject);
    procedure cb3DClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  published
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  re.Lines.Add(ComboBox1.Text);
end;

procedure TForm1.cb3DClick(Sender: TObject);
begin
  Panel2.Ctl3D := cb3D.Checked;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  Panel1.Color := StringToColor(ComboBox1.Text);
end;
procedure TForm1.rgInnerClick(Sender: TObject);
begin
  Panel2.BevelInner := TPanelBevel((Sender as TRadioGroup).ItemIndex);
end;

procedure TForm1.rgKindClick(Sender: TObject);
begin
  Panel2.BevelKind := TBevelKind((Sender as TRadioGroup).ItemIndex);
end;

procedure TForm1.rgOuterClick(Sender: TObject);
begin
  Panel2.BevelOuter := TPanelBevel((Sender as TRadioGroup).ItemIndex);
end;

{

A:clAqua;B:clSkyBlue;C:clCream;F:clBtnFace;G:clLime;I:clInfoBk;M:clMoneyGreen;P:clFuchsia;R:clRed;S:clBtnShadow;W:clWhite;Y:clYellow

A	clAqua
B	clSkyBlue
C	clCream
F	clBtnFace
G	clLime
I	clInfoBk
M	clMoneyGreen
P	clFuchsia
R	clRed
S	clBtnShadow
W	clWhite
Y	clYellow

}
end.
