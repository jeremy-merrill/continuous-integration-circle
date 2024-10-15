program RESTClient;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  RestUtils in 'RestUtils.pas';

{$R *.res}

procedure testing;
begin

end;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
