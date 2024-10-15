program Project2;

uses
  Vcl.Forms,
  Unit2 in 'Unit2.pas' {Form3},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10');
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
