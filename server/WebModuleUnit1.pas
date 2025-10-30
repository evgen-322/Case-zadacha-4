unit WebModuleUnit1;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, Datasnap.DSHTTPCommon,
  Datasnap.DSHTTPWebBroker, Datasnap.DSServer, Datasnap.DSServerCommon,
  Datasnap.DSAuth, Data.DB, Datasnap.DBXDataSnap;

type
  TWebModule1 = class(TWebModule)
    DSHTTPWebDispatcher1: TDSHTTPWebDispatcher;
    DSServer1: TDSServer;
    DSDispatcher1: TDSServerClass;
    procedure WebModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WebModule1: TWebModule1;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

uses
  ServerMethodsUnit1;

{$R *.dfm}

procedure TWebModule1.WebModuleCreate(Sender: TObject);
begin
  DSServer1.Start;
end;

end.
