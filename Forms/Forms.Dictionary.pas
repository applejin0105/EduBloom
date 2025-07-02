unit Forms.Dictionary;

interface

uses
  // 시스템 기본 유닛
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.StrUtils,

  // FMX 기본 UI 유닛
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Edit, FMX.Media,
  FMX.Ani,

  // Skia 그래픽 유닛
  System.Skia, FMX.Skia,

  // DB 관련
  FireDAC.Stan.Param,

  // 프로젝트 모듈
  DM.AppData,
  Frames.WordData,

  // 사용자 정의 폼
  Forms.BaseForm;

type
  TDictionaryForm = class(TBaseForm)
    // 전체 레이아웃
    MainLayout: TScaledLayout;

    // 상단 검색 및 타이틀 영역
    SearchBoxLayout: TLayout;
    TitleLayout: TLayout;
    TitleLabel: TLabel;
    HomeIconSvgLayout: TLayout;
    HomeIconSvg: TSkSvg;
    SearchFieldRect: TRectangle;
    SearchIconLayout: TLayout;
    SearchIconSvg: TSkSvg;
    SearchEditLayout: TLayout;
    WordSearchEdit: TEdit;

    // 단어 목록 콘텐츠 영역
    ContentLayout: TLayout;
    WordListScrollBox: TScrollBox;

    // 미디어 플레이어
    WordSoundPlayer: TMediaPlayer;

    // 이벤트 핸들러
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure HomeIconSvgClick(Sender: TObject);
    procedure WordSearchEditChange(Sender: TObject);
  private
    { Private declarations }
    procedure LoadWords(const Keyword: string);
    procedure PlayWordSound(Sender: TObject);
    procedure PlayExampleSound(Sender: TObject);
  public
    { Public declarations }
  end;

var
  DictionaryForm: TDictionaryForm;

implementation

{$R *.fmx}

{-------------------------------------------------------------------------------
  폼 생성 시 컴포넌트 초기화 및 전체 단어 로딩
-------------------------------------------------------------------------------}
procedure TDictionaryForm.FormCreate(Sender: TObject);
begin
  inherited;
  if not Assigned(AppDataModule) then
    AppDataModule := TAppDataModule.Create(nil);

  // 검색 에디트 이벤트 연결
  WordSearchEdit.OnChange := WordSearchEditChange;
  // 폼 숨김시 이벤트
  Self.OnHide := FormHide;

  // 처음에는 전체 단어 로드
  LoadWords('');
end;

{-------------------------------------------------------------------------------
  폼 표시 시 메인 폼 위치에 맞춰 창 위치 조정 (Windows 전용)
-------------------------------------------------------------------------------}
procedure TDictionaryForm.FormShow(Sender: TObject);
begin
  inherited;
  {$IFDEF MSWINDOWS}
  if Assigned(Application.MainForm) then
  begin
    Position := TFormPosition.Designed;
    SetBounds(
      Application.MainForm.Left,
      Application.MainForm.Top,
      Width, Height
    );
  end;
  {$ENDIF}
end;

{-------------------------------------------------------------------------------
  폼 숨김 시 메인 폼을 다시 표시
-------------------------------------------------------------------------------}
procedure TDictionaryForm.FormHide(Sender: TObject);
begin
  if Assigned(Application.MainForm) and (Application.MainForm <> Self) then
    (Application.MainForm as TBaseForm).ShowWithFade;
end;

{-------------------------------------------------------------------------------
  홈 아이콘 클릭 시 현재 폼 닫고 메인으로 복귀
-------------------------------------------------------------------------------}
procedure TDictionaryForm.HomeIconSvgClick(Sender: TObject);
begin
  HideWithFade;
end;

{-------------------------------------------------------------------------------
  검색어 변경 시 실시간 필터링
-------------------------------------------------------------------------------}
procedure TDictionaryForm.WordSearchEditChange(Sender: TObject);
begin
  LoadWords(Trim(WordSearchEdit.Text));
end;

{-------------------------------------------------------------------------------
  DB에서 단어 조회 후 UI에 표시
-------------------------------------------------------------------------------}
procedure TDictionaryForm.LoadWords(const Keyword: string);
var
  Frame: TWordDataFrame;
  sqlText: string;
begin
  // 동적 SQL 생성
  sqlText := 'SELECT * FROM WORDS ' +
             IfThen(Keyword <> '', 'WHERE word LIKE :kw ', '') +
             'ORDER BY word';

  // 단일 Query 컴포넌트 사용
  with AppDataModule.Query do
  begin
    Close;
    SQL.Text := sqlText;
    if Keyword <> '' then
      ParamByName('kw').AsString := '%' + Keyword + '%';
    Open;

    // 기존 프레임 모두 제거
    WordListScrollBox.BeginUpdate;
    try
      while WordListScrollBox.Content.ControlsCount > 0 do
        WordListScrollBox.Content.Controls[0].Free;
    finally
      WordListScrollBox.EndUpdate;
    end;

    // 결과를 순회하며 프레임 생성
    First;
    while not Eof do
    begin
      Frame := TWordDataFrame.Create(WordListScrollBox);
      Frame.Name := '';
      WordListScrollBox.AddObject(Frame);
      Frame.Align := TAlignLayout.Top;
      Frame.Margins.Bottom := 5;

      // 데이터 바인딩
      Frame.WordLabel.Text          := FieldByName('word').AsString;
      Frame.PartofspeechLabel.Text  := FieldByName('part_of_speech').AsString;
      Frame.MeaningLabel.Text       := FieldByName('meaning_korean').AsString;
      Frame.EngExampleLabel.Text    := FieldByName('example').AsString;
      Frame.KrExampleLabel.Text     := FieldByName('example_korean').AsString;

      // 클릭 시 사운드 재생
      Frame.WordLabel.HitTest       := True;
      Frame.WordLabel.OnClick       := PlayWordSound;
      Frame.EngExampleLabel.HitTest := True;
      Frame.EngExampleLabel.OnClick := PlayExampleSound;

      Next;
    end;

    Close;
  end;
end;

{-------------------------------------------------------------------------------
  단어 클릭 시 발음 재생
-------------------------------------------------------------------------------}
procedure TDictionaryForm.PlayWordSound(Sender: TObject);
var
  Obj: TFmxObject;
  Frame: TWordDataFrame;
  URI: string;
begin
  Obj := Sender as TFmxObject;
  while Assigned(Obj) and not (Obj is TWordDataFrame) do
    Obj := Obj.Parent;

  if Obj is TWordDataFrame then
  begin
    Frame := TWordDataFrame(Obj);
    URI := AppDataModule.GetWordSoundURI(Frame.WordLabel.Text + '.wav');
    WordSoundPlayer.FileName := URI;
    WordSoundPlayer.Play;
  end;
end;

{-------------------------------------------------------------------------------
  예문 클릭 시 예문 발음 재생
-------------------------------------------------------------------------------}
procedure TDictionaryForm.PlayExampleSound(Sender: TObject);
var
  Obj: TFmxObject;
  Frame: TWordDataFrame;
  URI: string;
begin
  Obj := Sender as TFmxObject;
  while Assigned(Obj) and not (Obj is TWordDataFrame) do
    Obj := Obj.Parent;

  if Obj is TWordDataFrame then
  begin
    Frame := TWordDataFrame(Obj);
    URI := AppDataModule.GetExampleSoundURI(Frame.WordLabel.Text + '_example.wav');
    WordSoundPlayer.FileName := URI;
    WordSoundPlayer.Play;
  end;
end;

end.
