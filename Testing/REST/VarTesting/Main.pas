unit Main;

{$RTTI EXPLICIT METHODS([vcPrivate, vcProtected, vcPublic, vcPublished])}
{$TYPEINFO ON}


interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, VAShared.UDataStore,
  Vcl.ComCtrls;

type
  TfrmMain = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    re: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  Trec = record
    FField: string;
    FField2: string;
  end;

var
  frmMain: TfrmMain;
  ivar: Integer = 765;
  irec: TRec = (FField: '123'; FField2: 'abc');
  iinf: IInterfaceComponentReference;
  DataStore: TDataStore;

implementation

{$R *.dfm}

uses
  System.Rtti;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  re.Clear;
  re.Lines.Add(DataStore.Data['label.caption'].ToString);
//  Re.Repaint;
  re.Lines.Add(DataStore.Data['label.name'].ToString);
//  Re.Repaint;
  re.Lines.Add(DataStore.Data['IVar'].ToString);
//  Re.Repaint;
  re.Lines.Add(DataStore.Data['frmmain.Caption'].ToString);
//  Re.Repaint;
  re.Lines.Add(DataStore.Data['frmMain.label2.caption'].ToString);
//  Re.Repaint;
  re.Lines.Add(DataStore.Data['irec.ffield'].ToString);
//  Re.Repaint;
  re.Lines.Add(DataStore.Data['irec.ffield2'].ToString);
//  Re.Repaint;
  re.Lines.Add(DataStore.Data['oops'].ToString);
//  Re.Repaint;
  re.Lines.Add(DataStore.Data['frmMain.oops'].ToString);
//  Re.Repaint;
  re.Lines.Add(DataStore.Data['frmMain.label1.oops'].ToString);
//  Re.Repaint;
  DataStore.Variable['testing'] := '12345';
  re.Lines.Add(DataStore.Variable['Testing']);
//  Re.Repaint;
  DataStore.Variable['tesTing'] := '67890';
  re.Lines.Add(DataStore.Variable['Testing']);
  re.Lines.Add('<' + DataStore.Variable['Oops'] + '>');
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  DataStore := TDataStore.Create;
  iinf := frmMain.Button1;
  DataStore.AddData('Label', @frmMain.Label1, TypeInfo(TLabel));
  DataStore.AddData('IVar', @IVar, TypeInfo(Integer));
  DataStore.AddData('frmMain', @frmMain, TypeInfo(TfrmMain));
  DataStore.AddData('IRec', @IRec, TypeInfo(TRec));
  DataStore.AddData('IInf', @frmMain, TypeInfo(IInterfaceComponentReference));
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(DataStore);
end;

end.
