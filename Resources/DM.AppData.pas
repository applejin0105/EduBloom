unit DM.AppData;

interface

uses
  // 시스템 기본 유닛
  System.SysUtils, System.Classes, System.IOUtils, System.Generics.Collections,

  // FMX 기본 UI 유닛
  FMX.Types, FMX.Controls, FMX.Dialogs, FMX.DialogService,

  // FireDAC 및 DB 관련 유닛
  Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.DApt, FireDAC.DApt.Intf,
  FireDAC.DatS,
  FireDAC.Stan.Async, FireDAC.Stan.Def, FireDAC.Stan.Error, FireDAC.Stan.ExprFuncs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.Phys.Intf, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.UI.Intf, FireDAC.FMXUI.Wait,

  // 프로젝트 모듈 및 타입
  QuizTypes,
  AppPaths;

type
  /// <summary>
  /// 단일 학습 기록을 나타내는 레코드
  /// </summary>
  TLogEntry = record
    LogDate      : TDateTime;
    TotalCount   : Integer;
    CorrectCount : Integer;
    Hours        : Integer;
    Minutes      : Integer;
  end;

  /// <summary>
  /// 중앙 데이터 모듈: 하나의 DB, 하나의 Connection, 하나의 Query
  /// </summary>
  TAppDataModule = class(TDataModule)
    Connection: TFDConnection;
    Query: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    FDefaultCount: Integer;
  public
    /// <summary>퀴즈 기본 문항 수</summary>
    property DefaultCount: Integer read FDefaultCount write FDefaultCount;

    procedure SaveLog(const ADate: TDateTime;
      const ATotalCount, ACorrectCount, AHours, AMinutes: Integer);
    function  LoadAllLogs: TArray<TLogEntry>;

    procedure SaveWrongWord(const AWordID: Integer);
    function  LoadWrongWords: TArray<TWordRecord>;

    function GetWordSoundURI(const FileName: string): string;
    function GetExampleSoundURI(const FileName: string): string;
  end;

var
  AppDataModule: TAppDataModule;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

procedure TAppDataModule.DataModuleCreate(Sender: TObject);
begin
  // 1) 기본값
  FDefaultCount := 20;

  // 2) 하나의 SQLite DB 파일만 사용
  Connection.Params.DriverID  := 'SQLite';
  Connection.Params.Database  := GetWordsDBPath;
  // 폴더 없으면 생성

  Connection.Open;
  ForceDirectories(ExtractFilePath(Connection.Params.Database));
  Connection.Open;

  // 3) 외래키 활성화 (필요 시)
  Connection.ExecSQL('PRAGMA foreign_keys = ON;');

  // 4) 통합 테이블 생성
  Connection.ExecSQL(
    'CREATE TABLE IF NOT EXISTS WrongWords (' +
    '  WordID INTEGER PRIMARY KEY' +
    ');'
  );
  Connection.ExecSQL(
    'CREATE TABLE IF NOT EXISTS Log (' +
    '  LogDate    DATETIME PRIMARY KEY,' +
    '  TotalCount INTEGER,' +
    '  CorrectCount INTEGER,' +
    '  Hours      INTEGER,' +
    '  Minutes    INTEGER' +
    ');'
  );
  // Words 테이블은 이미 존재한다고 가정

  // 5) 단일 Query에 커넥션 연결
  Query.Connection := Connection;

  // 6) 초기 단어 목록 로드 (옵션)
  Query.SQL.Text :=
    'SELECT id, word, part_of_speech, example, example_korean, meaning_korean ' +
    'FROM Words';
  Query.Open;
end;

procedure TAppDataModule.SaveLog(const ADate: TDateTime;
  const ATotalCount, ACorrectCount, AHours, AMinutes: Integer);
var
  DateOnly: TDateTime;
begin
  DateOnly := Trunc(ADate);

  Query.Close;
  Query.SQL.Text :=
    'INSERT OR REPLACE INTO Log ' +
    '(LogDate, TotalCount, CorrectCount, Hours, Minutes) ' +
    'VALUES (:LogDate, :Total, :Correct, :Hrs, :Min)';
  // DATE 타입으로 바인딩
  Query.ParamByName('LogDate').AsDate    := DateOnly;
  Query.ParamByName('Total').AsInteger   := ATotalCount;
  Query.ParamByName('Correct').AsInteger := ACorrectCount;
  Query.ParamByName('Hrs').AsInteger     := AHours;
  Query.ParamByName('Min').AsInteger     := AMinutes;
  Query.ExecSQL;
end;

function TAppDataModule.LoadAllLogs: TArray<TLogEntry>;
var
  rec  : TLogEntry;
  list : TList<TLogEntry>;
begin
  list := TList<TLogEntry>.Create;
  try
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM Log ORDER BY LogDate';
    Query.Open;
    while not Query.EOF do
    begin
      rec.LogDate      := Query.FieldByName('LogDate').AsDateTime;
      rec.TotalCount   := Query.FieldByName('TotalCount').AsInteger;
      rec.CorrectCount := Query.FieldByName('CorrectCount').AsInteger;
      rec.Hours        := Query.FieldByName('Hours').AsInteger;
      rec.Minutes      := Query.FieldByName('Minutes').AsInteger;
      list.Add(rec);
      Query.Next;
    end;
    Result := list.ToArray;
  finally
    list.Free;
  end;
end;

procedure TAppDataModule.SaveWrongWord(const AWordID: Integer);
begin
  Query.Close;
  Query.SQL.Text := 'INSERT OR IGNORE INTO WrongWords (WordID) VALUES (:id)';
  Query.ParamByName('id').AsInteger := AWordID;
  Query.ExecSQL;
end;

function TAppDataModule.LoadWrongWords: TArray<TWordRecord>;
var
  idList   : TStringList;
  wordList : TList<TWordRecord>;
  rec      : TWordRecord;
begin
  idList   := TStringList.Create;
  wordList := TList<TWordRecord>.Create;
  try
    // 1) 오답 ID 수집
    Query.Close;
    Query.SQL.Text := 'SELECT WordID FROM WrongWords';
    Query.Open;
    while not Query.EOF do
    begin
      idList.Add(Query.FieldByName('WordID').AsString);
      Query.Next;
    end;

    if idList.Count = 0 then
      Exit(nil);

    // 2) 단어 정보 조회
    Query.Close;
    Query.SQL.Text := Format(
      'SELECT * FROM Words WHERE id IN (%s) ORDER BY word',
      [ idList.CommaText ]
    );
    Query.Open;
    while not Query.EOF do
    begin
      rec.ID           := Query.FieldByName('id').AsInteger;
      rec.WordEng      := Query.FieldByName('word').AsString;
      rec.PartOfSpeech := Query.FieldByName('part_of_speech').AsString;
      rec.ExampleEng   := Query.FieldByName('example').AsString;
      rec.ExampleKR    := Query.FieldByName('example_korean').AsString;
      rec.WordKR       := Query.FieldByName('meaning_korean').AsString;
      wordList.Add(rec);
      Query.Next;
    end;
    Result := wordList.ToArray;
  finally
    idList.Free;
    wordList.Free;
  end;
end;

function TAppDataModule.GetWordSoundURI(const FileName: string): string;
begin
  Result := TPath.Combine(GetWordsSoundsFolder, FileName);
end;

function TAppDataModule.GetExampleSoundURI(const FileName: string): string;
begin
  Result := TPath.Combine(GetExamplesSoundsFolder, FileName);
end;

end.
