program Project5;

uses
  Vcl.Forms,
  Unit6 in 'Unit6.pas' {Form6},
  IDEUtils.JSONDescendantClassesCommon in '..\GitHub\CPRSv33conPkg\IDEUtils\Source\IDEUtils.JSONDescendantClassesCommon.pas',
  uPtInfoCommon in '..\GitHub\CPRSv33con\CPRS-chart\InfoPanel\uPtInfoCommon.pas',
  uPtInfoData in '..\GitHub\CPRSv33con\CPRS-chart\InfoPanel\uPtInfoData.pas',
  uPtInfoCore in '..\GitHub\CPRSv33con\CPRS-chart\infoPanel\uPtInfoCore.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm6, Form6);
  Application.Run;
end.
