program Project8;

uses
  Vcl.Forms,
  Unit12 in 'Unit12.pas' {Form12},
  uSpecialAuthority in '..\GitHub\CPRSv33con\CPRS-chart\SpecialAuthority\uSpecialAuthority.pas',
  Unit13 in 'Unit13.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm12, Form12);
  Application.Run;
end.
