unit AppPaths;

interface

uses
  System.SysUtils, System.IOUtils;

/// <summary>
/// 문서 폴더를 기준으로 'Sounds\words' 폴더의 전체 경로를 반환합니다.
/// </summary>
function GetWordsSoundsFolder: string;

/// <summary>
/// 문서 폴더를 기준으로 'Sounds\examples' 폴더의 전체 경로를 반환합니다.
/// </summary>
function GetExamplesSoundsFolder: string;

/// <summary>
/// 문서 폴더를 기준으로 데이터베이스 파일(.s3db 등)의 전체 경로를 반환합니다.
/// </summary>
/// <param name="FileName">기본값 'WordsDB.s3db'</param>
function GetDatabasePath(const FileName: string = 'WordsDB.s3db'): string;

/// <summary>
/// 문서 폴더를 기준으로 'WordsDB.s3db' 파일의 전체 경로를 반환합니다.
/// </summary>
function GetWordsDBPath: string;

implementation

function GetWordsSoundsFolder: string;
begin
  // Documents\Sounds\words
  Result := TPath.Combine(TPath.GetDocumentsPath, 'Sounds');
  Result := TPath.Combine(Result, 'words');
end;

function GetExamplesSoundsFolder: string;
begin
  // Documents\Sounds\examples
  Result := TPath.Combine(TPath.GetDocumentsPath, 'Sounds');
  Result := TPath.Combine(Result, 'examples');
end;

function GetDatabasePath(const FileName: string): string;
begin
  // Documents\<FileName>
  Result := TPath.Combine(TPath.GetDocumentsPath, FileName);
end;

function GetWordsDBPath: string;
begin
  // Documents\WordsDB.s3db
  Result := TPath.Combine(TPath.GetDocumentsPath, 'WordsDB.s3db');
end;

end.
