type
  TServerMethods1 = class(TDataModule)
  public
    function GetTasks: TJSONArray;
    function AddTask(const Title, Description: string): Integer;
    procedure MarkTaskAsCompleted(TaskID: Integer);
  end;

implementation

uses
  System.JSON, Data.DB, Datasnap.DSHTTPCommon, Datasnap.DSServer,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.Stan.ExprFuncs;

var
  FDConn: TFDConnection;

procedure InitDB;
begin
  if not Assigned(FDConn) then
  begin
    FDConn := TFDConnection.Create(nil);
    FDConn.Params.DriverID := 'MSSQL';
    FDConn.Params.Database := 'TaskManagerDB';
    FDConn.Params.Server := 'localhost'; // или имя вашего сервера
    FDConn.Params.UserName := 'sa';      // или Windows Auth — уберите эти строки
    FDConn.Params.Password := 'ваш_пароль';
    FDConn.Connected := True;
  end;
end;

{ TServerMethods1 }

function TServerMethods1.GetTasks: TJSONArray;
var
  qry: TFDQuery;
  item: TJSONObject;
begin
  InitDB;
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FDConn;
    qry.SQL.Text := 'SELECT TaskID, Title, Description, IsCompleted, CreatedAt FROM Tasks ORDER BY CreatedAt DESC';
    qry.Open;
    Result := TJSONArray.Create;
    while not qry.Eof do
    begin
      item := TJSONObject.Create;
      item.AddPair('TaskID', qry.FieldByName('TaskID').AsInteger);
      item.AddPair('Title', qry.FieldByName('Title').AsString);
      item.AddPair('Description', qry.FieldByName('Description').AsString);
      item.AddPair('IsCompleted', qry.FieldByName('IsCompleted').AsBoolean);
      item.AddPair('CreatedAt', qry.FieldByName('CreatedAt').AsDateTime);
      Result.AddElement(item);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

function TServerMethods1.AddTask(const Title, Description: string): Integer;
var
  qry: TFDQuery;
begin
  InitDB;
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FDConn;
    qry.SQL.Text := 'INSERT INTO Tasks (Title, Description) VALUES (:Title, :Desc); SELECT SCOPE_IDENTITY() AS NewID';
    qry.ParamByName('Title').AsString := Title;
    qry.ParamByName('Desc').AsString := Description;
    qry.Open;
    Result := qry.FieldByName('NewID').AsInteger;
  finally
    qry.Free;
  end;
end;

procedure TServerMethods1.MarkTaskAsCompleted(TaskID: Integer);
var
  qry: TFDQuery;
begin
  InitDB;
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := FDConn;
    qry.SQL.Text := 'UPDATE Tasks SET IsCompleted = 1 WHERE TaskID = :ID';
    qry.ParamByName('ID').AsInteger := TaskID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;
