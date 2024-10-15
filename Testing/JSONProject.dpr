program JSONProject;

uses
  Vcl.Forms,
  Unit4 in 'Unit4.pas',
  Unit6 in 'Unit6.pas',
  Unit3 in 'Unit3.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
