unit Forms.Main;

interface

uses
  // 시스템 기본 유닛
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.Permissions,
  System.IOUtils,

  // FMX 기본 UI 유닛
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Media, FMX.Ani, FMX.DialogService,

  // Skia 그래픽 유닛
  System.Skia, FMX.Skia,

  // DB 관련
  Data.DB, FireDAC.Stan.Param,

  // 프로젝트 모듈
  DM.AppData, QuizTypes,

  // 사용자 정의 폼들
  Forms.BaseForm, Forms.Log, Forms.Dictionary, Forms.Exit, Forms.Quiz, Frames.Warning, Frames.Setting

  {$IFDEF ANDROID}
  , Androidapi.Helpers, Androidapi.JNI.JavaTypes, Androidapi.JNI.Os
  {$ENDIF}
  {$IFDEF IOS}
  , iOSapi.MediaPlayer
  {$ENDIF}
  ;

type
  TMainForm = class(TBaseForm)
    // Header 및 네비게이션 영역
    HeaderLayout: TLayout;
    MenuSectionLayout: TLayout;
    NavSectionLayout: TLayout;
    HeaderLogoLayout: TLayout;
    LogoIconLayout: TLayout;
    LogoIconSvg: TSkSvg;
    AppNameLabel: TLabel;
    NavBackRect: TRectangle;

    // Word of the Day 관련
    WordOfTheDayRectangle: TRectangle;
    WODLayout: TLayout;
    WODLogoLayout: TLayout;
    WODSVG: TSkSvg;
    WODLabel: TLabel;
    WordLayout: TLayout;
    WordLabel: TLabel;
    MeaningLayout: TLayout;
    MeaningLabel: TLabel;
    ExampleLayout: TLayout;
    ExampleEngLabel: TLabel;
    ExampleKrLabel: TLabel;
    WODMediaPlayer: TMediaPlayer;

    // 메뉴 버튼 영역
    MenuButtonsLayout: TLayout;

    QuizButtonLayout: TLayout;
    QuizButtonBackRect: TRectangle;
    QuizIconSvg: TSkSvg;
    QuizButtonLabel: TLabel;

    WrongNoteButtonLayout: TLayout;
    WrongNoteButtonBackRect: TRectangle;
    WrongNoteIconSvg: TSkSvg;
    WrongNoteButtonLabel: TLabel;

    LogButtonLayout: TLayout;
    LogIconSvg: TSkSvg;
    LogButtonLabel: TLabel;

    DictionaryButtonLayout: TLayout;
    DictionaryIconSvg: TSkSvg;
    DictionaryButtonLabel: TLabel;

    SettingButtonLayout: TLayout;
    SettingIconSvg: TSkSvg;
    SettingButtonLabel: TLabel;

    // 전체 레이아웃
    MainLayout: TScaledLayout;
    PopupLayout: TLayout;

    // 이벤트 핸들러
    procedure FormCreate(Sender: TObject);
    procedure LoadWordOfTheDay;
    procedure QuizButtonBackRectClick(Sender: TObject);
    procedure WrongNoteButtonBackRectClick(Sender: TObject);
    procedure DictionaryButtonLayoutClick(Sender: TObject);
    procedure LogButtonLayoutClick(Sender: TObject);
    procedure SettingButtonLayoutClick(Sender: TObject);
    procedure SettingCountChanged(Sender: TObject; NewCount: Integer);
    procedure ShowPopupFrame(const AMessage: string);
    procedure FadeOutAnimationFinished(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HandleSettingFrameClose(Sender: TObject);
    procedure WordLabelClick(Sender: TObject);
    procedure ExampleEngLabelClick(Sender: TObject);
  public
    procedure HandleGlobalException(Sender: TObject; E: Exception);

  private
    FWarningFrame: TWarningFrame;
    FSettingFrame: TSettingFrame;
    procedure RequestAudioPermission;
  {$IFDEF ANDROID}
    procedure DisplayRationale(Sender: TObject; const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
    procedure AudioPermissionResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
  {$ENDIF}
  {$IFDEF IOS}
    procedure HandleMediaLibraryAccess(Status: MPMediaLibraryAuthorizationStatus);
  {$ENDIF}
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

/// <summary>
/// 폼 생성 시 초기화 및 오늘의 단어 로딩
/// </summary>
procedure TMainForm.FormCreate(Sender: TObject);
begin
  inherited;
  if not Assigned(AppDataModule) then
    AppDataModule := TAppDataModule.Create(nil);

  // Daily words 테이블 생성
  AppDataModule.Connection.ExecSQL(
    'CREATE TABLE IF NOT EXISTS DAILY_WORDS (' +
    '  date TEXT PRIMARY KEY, ' +
    '  word_id INTEGER NOT NULL' +
    ');'
  );

  // 네비게이션 등 이벤트 연결
  QuizButtonBackRect.OnClick := QuizButtonBackRectClick;
  WrongNoteButtonBackRect.OnClick := WrongNoteButtonBackRectClick;
  DictionaryButtonLayout.OnClick := DictionaryButtonLayoutClick;
  LogButtonLayout.OnClick := LogButtonLayoutClick;
  SettingButtonLayout.OnClick := SettingButtonLayoutClick;

  // 바로 Word of the Day 로드 (윈도우/맥 등 데스크탑용)
  LoadWordOfTheDay;

  ShowWithFade;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  inherited;
  // 모바일에서는 권한 요청, 데스크탑은 곧바로 워드 로드
  RequestAudioPermission;
end;

procedure TMainForm.LoadWordOfTheDay;
var
  todayStr: string;
  wordID: Integer;
begin
  todayStr := FormatDateTime('yyyy-MM-dd', Date);

  // 1) 오늘 저장된 단어 ID 조회
  with AppDataModule.Query do
  begin
    Close;
    SQL.Text := 'SELECT word_id FROM DAILY_WORDS WHERE date = :date';
    ParamByName('date').AsString := todayStr;
    Open;
  end;

  if not AppDataModule.Query.IsEmpty then
    wordID := AppDataModule.Query.FieldByName('word_id').AsInteger
  else
  begin
    // 2) 없으면 랜덤 선택 후 저장
    with AppDataModule.Query do
    begin
      Close;
      SQL.Text := 'SELECT id FROM Words ORDER BY RANDOM() LIMIT 1';
      Open;
      wordID := FieldByName('id').AsInteger;
    end;
    AppDataModule.Connection.ExecSQL(
      'INSERT INTO DAILY_WORDS(date, word_id) VALUES(:d, :w)',
      [todayStr, wordID]
    );
  end;

  // 3) 실제 단어 정보 로드
  with AppDataModule.Query do
  begin
    Close;
    SQL.Text :=
      'SELECT word, meaning_korean, example, example_korean ' +
      'FROM Words WHERE id = :id';
    ParamByName('id').AsInteger := wordID;
    Open;
  end;

  // 4) UI 반영
  WordLabel.Text       := AppDataModule.Query.FieldByName('word').AsString;
  MeaningLabel.Text    := AppDataModule.Query.FieldByName('meaning_korean').AsString;
  ExampleEngLabel.Text := AppDataModule.Query.FieldByName('example').AsString;
  ExampleKrLabel.Text  := AppDataModule.Query.FieldByName('example_korean').AsString;
end;

procedure TMainForm.WordLabelClick(Sender: TObject);
var
  FileName, FilePath: string;
begin
  FileName := WordLabel.Text + '.wav';
  FilePath := AppDataModule.GetWordSoundURI(FileName);

  if TFile.Exists(FilePath) then
  begin
    WODMediaPlayer.FileName := FilePath;
    WODMediaPlayer.Play;
  end
  else
    TDialogService.ShowMessage(
      '사운드 파일을 찾을 수 없습니다:'#13#10 + FilePath
    );
end;

procedure TMainForm.QuizButtonBackRectClick(Sender: TObject);
begin
  HideWithFade(
    procedure
    begin
      QuizForm.ReviewMode := False;
      QuizForm.ShowWithFade;
    end
  );
end;

procedure TMainForm.WrongNoteButtonBackRectClick(Sender: TObject);
var
  WrongWords: TArray<TWordRecord>;
begin
  WrongWords := AppDataModule.LoadWrongWords;
  if Length(WrongWords) = 0 then
    ShowPopupFrame('오답노트에 복습할 단어가 없습니다.')
  else
    HideWithFade(
      procedure
      begin
        QuizForm.ReviewMode := True;
        QuizForm.LoadReviewWords(WrongWords);
        QuizForm.ShowWithFade;
      end
    );
end;

procedure TMainForm.DictionaryButtonLayoutClick(Sender: TObject);
begin
  HideWithFade(
    procedure
    begin
      DictionaryForm.ShowWithFade;
    end
  );
end;

procedure TMainForm.LogButtonLayoutClick(Sender: TObject);
begin
  HideWithFade(
    procedure
    begin
      LogForm.ShowWithFade;
    end
  );
end;

procedure TMainForm.SettingButtonLayoutClick(Sender: TObject);
begin

  if Assigned(FSettingFrame) then
    Exit;

  // 1) 이전에 남아 있던 팝업 컨트롤이 있으면 지운다 (옵션)
  while PopupLayout.ControlsCount > 0 do
    PopupLayout.Controls[0].Free;

  // 2) 프레임 생성
  FSettingFrame := TSettingFrame.Create(Self);
  FSettingFrame.Parent := PopupLayout;
  FSettingFrame.Align := TAlignLayout.Client;
  FSettingFrame.OnCountChanged := SettingCountChanged;
  FSettingFrame.OnClose := HandleSettingFrameClose;
  FSettingFrame.QuizCount := AppDataModule.DefaultCount;

  // 3) PopupLayout 보이기
  PopupLayout.Opacity := 0;
  PopupLayout.Visible := True;
  PopupLayout.BringToFront;

  var AnimIn := TFloatAnimation.Create(PopupLayout);
  AnimIn.Parent := PopupLayout;
  AnimIn.PropertyName := 'Opacity';
  AnimIn.StartValue := 0;
  AnimIn.StopValue := 1;
  AnimIn.Duration := 0.15;
  AnimIn.Start;
end;

procedure TMainForm.SettingCountChanged(Sender: TObject; NewCount: Integer);
begin
  AppDataModule.DefaultCount := NewCount;
end;

procedure TMainForm.HandleSettingFrameClose(Sender: TObject);
begin
  if Assigned(FSettingFrame) then
  begin
    FSettingFrame.Free;
    FSettingFrame := nil;
  end;
end;

procedure TMainForm.ShowPopupFrame(const AMessage: string);
var
  AnimIn, AnimOut: TFloatAnimation;
begin
  while PopupLayout.ControlsCount > 0 do
    PopupLayout.Controls[0].Free;
  FWarningFrame := nil;

  FWarningFrame := TWarningFrame.Create(PopupLayout);
  FWarningFrame.Parent := PopupLayout;
  FWarningFrame.Align := TAlignLayout.Center;
  FWarningFrame.WarningLabel.Text := AMessage;

  PopupLayout.Opacity := 0;
  PopupLayout.Visible := True;

  AnimIn := TFloatAnimation.Create(PopupLayout);
  AnimIn.Parent := PopupLayout;
  AnimIn.PropertyName := 'Opacity';
  AnimIn.StopValue := 1;
  AnimIn.Duration := 0.1;
  AnimIn.Start;

  AnimOut := TFloatAnimation.Create(PopupLayout);
  AnimOut.Parent := PopupLayout;
  AnimOut.PropertyName := 'Opacity';
  AnimOut.StopValue := 0;
  AnimOut.Duration := 0.3;
  AnimOut.Delay := 1.0;
  AnimOut.OnFinish := FadeOutAnimationFinished;
  AnimOut.Start;
end;

procedure TMainForm.ExampleEngLabelClick(Sender: TObject);
var
  FileName, FilePath: string;
begin
  FileName := WordLabel.Text + '_example.wav';
  FilePath := AppDataModule.GetExampleSoundURI(FileName);

  if TFile.Exists(FilePath) then
  begin
    WODMediaPlayer.FileName := FilePath;
    WODMediaPlayer.Play;
  end
  else
    TDialogService.ShowMessage(
      '사운드 파일을 찾을 수 없습니다:'#13#10 + FilePath
    );
end;

procedure TMainForm.FadeOutAnimationFinished(Sender: TObject);
begin
  PopupLayout.Visible := False;
end;

procedure TMainForm.RequestAudioPermission;
{$IFDEF ANDROID}
var
  PermissionStr: string;
begin
  if TOSVersion.Check(13) then
    PermissionStr := JStringToString(TJManifest_permission.JavaClass.READ_MEDIA_AUDIO)
  else
    PermissionStr := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);

  PermissionsService.RequestPermissions([PermissionStr], AudioPermissionResult, DisplayRationale);
end;
{$ELSEIF defined(IOS)}
begin
  TMPMediaLibrary.OCClass.requestAuthorization(HandleMediaLibraryAccess);
end;
{$ELSE}
begin
  // 데스크탑: 권한 개념 없으므로 바로 Word of the Day 로드
  LoadWordOfTheDay;
end;
{$ENDIF}

{$IFDEF ANDROID}
procedure TMainForm.DisplayRationale(Sender: TObject; const APermissions: TClassicStringDynArray; const APostRationaleProc: TProc);
begin
  TDialogService.ShowMessage('사운드 파일 재생을 위해 저장소 접근 권한이 필요합니다.',
    procedure(const AResult: TModalResult) begin
      APostRationaleProc();
    end);
end;

procedure TMainForm.AudioPermissionResult(Sender: TObject; const APermissions: TClassicStringDynArray; const AGrantResults: TClassicPermissionStatusDynArray);
begin
  if (Length(AGrantResults)>0) and (AGrantResults[0]=TPermissionStatus.Granted) then
    LoadWordOfTheDay
  else
    TDialogService.ShowMessage('권한이 거부되어 사운드를 재생할 수 없습니다.');
end;
{$ENDIF}

{$IFDEF IOS}
procedure TMainForm.HandleMediaLibraryAccess(Status: MPMediaLibraryAuthorizationStatus);
begin
  TThread.ForceQueue(nil,
    procedure
    begin
      if Status=MPMediaLibraryAuthorizationStatusAuthorized then
        LoadWordOfTheDay
      else
        TDialogService.ShowMessage('미디어 접근 권한이 필요합니다.');
    end);
end;
{$ENDIF}

procedure TMainForm.HandleGlobalException(Sender: TObject; E: Exception);
var
  logFile: string;
begin
  TDialogService.ShowMessage(
    '전역 예외 발생!' + sLineBreak +
    E.ClassName + ': ' + E.Message,
    // ← 익명 프로시저에 begin…end 를 반드시 넣어야 합니다
    procedure(const AResult: TModalResult)
    begin
      // (원하면 이 안에 종료 로직 등 추가)
    end
  );

  // 1) 로그 경로 조합
  logFile := System.IOUtils.TPath.Combine(
    System.IOUtils.TPath.GetDocumentsPath,  // ← 반드시 TPath. 을 붙입니다
    'CrashLog.txt'
  );

  // 2) 로그 남기기 (UTF-8)
  TFile.AppendAllText(
    logFile,
    FormatDateTime('yyyy-MM-dd hh:nn:ss', Now) + ' - ' +
    E.ClassName + ': ' + E.Message + sLineBreak,
    TEncoding.UTF8
  );
end;

end.
