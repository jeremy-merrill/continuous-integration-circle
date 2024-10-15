unit Unit10;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.WinXCtrls,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.NumberBox, System.ImageList, Vcl.ImgList,
  Vcl.AppEvnts;

type
  TBalloonHint2 = class(TBalloonHint);
  TForm10 = class(TForm)
    bHint: TBalloonHint;
    Button1: TButton;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    ApplicationEvents1: TApplicationEvents;
    procedure Button1Click(Sender: TObject);
  private
    FOldActiveControlChange: TNotifyEvent;
    procedure ResetOnChange;
    procedure ActiveControlChanged(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form10: TForm10;

implementation

{$R *.dfm}

procedure TForm10.ActiveControlChanged(Sender: TObject);
begin
  bHint.HideHint;
  if Assigned(FOldActiveControlChange) then
    FOldActiveControlChange(Sender);
  ResetOnChange;
end;

procedure TForm10.Button1Click(Sender: TObject);
begin
  TBalloonHint2(bHint).ShowHint(CheckBox1);
  ResetOnChange;
end;

procedure TForm10.ResetOnChange;
begin
  if Assigned(FOldActiveControlChange) and (not bHint.ShowingHint) then
  begin
    Screen.OnActiveControlChange := FOldActiveControlChange;
    FOldActiveControlChange := nil;
  end
  else if (not Assigned(FOldActiveControlChange)) or bHint.ShowingHint then
  begin
    FOldActiveControlChange := Screen.OnActiveControlChange;
    Screen.OnActiveControlChange := ActiveControlChanged;
  end;

end;

end.
