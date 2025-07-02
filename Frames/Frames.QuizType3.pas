unit Frames.QuizType3;

interface

uses
  // 시스템 기본 유닛
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  // FMX 기본 UI 유닛
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Layouts, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,

  // Skia 그래픽 유닛
  System.Skia, FMX.Skia,

  // 프로젝트 모듈 및 타입
  QuizTypes;

type
  /// <summary>
  /// 사용자가 답을 입력했을 때 정답 여부를 전달하는 콜백 이벤트를 정의합니다.
  /// </summary>
  /// <param name="IsCorrect">정답 여부 (True/False)</param>
  TAnswerCallback = procedure(IsCorrect: Boolean) of object;

  /// <summary>
  /// 주관식 퀴즈 유형 3 (예문 빈칸 채우기)을 위한 프레임입니다.
  /// </summary>
  TQuizType3Frame = class(TFrame)
    // 레이아웃
    MainLayout: TLayout;

    // 질문 섹션 (예문)
    QuestionCardBackRect: TRectangle;
    EngExampleTextLabel: TLabel;
    KrExampleTextLabel: TLabel;

    // 정답 입력 섹션
    InputCardBackRect: TRectangle;
    InputEdit: TEdit;
  private
    FAnswerEng: string;
    FAnswerKR: string;
    function MaskWord(const Sentence, Word: string): string;
    procedure InputEditKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
  public
    /// <summary>
    /// 사용자가 답을 입력하고 확인했을 때 호출할 이벤트 핸들러입니다.
    /// </summary>
    OnAnswered: TAnswerCallback;

    /// <summary>
    /// 주어진 단어 데이터로 예문을 구성하고 빈칸을 마스킹합니다.
    /// </summary>
    /// <param name="AWord">퀴즈 문제로 출제할 단어 레코드</param>
    procedure BindQuestion(const AWord: TWordRecord);

    /// <summary>
    /// 사용자 입력을 정답과 비교하고 OnAnswered 이벤트를 호출합니다.
    /// </summary>
    procedure AnswerCheck;
  end;

implementation

{$R *.fmx}

uses
  System.StrUtils; // StringReplace, StringOfChar

/// <summary>
/// 주어진 단어 데이터로 예문을 구성하고 빈칸을 마스킹합니다.
/// </summary>
/// <param name="AWord">퀴즈 문제로 출제할 단어 레코드</param>
procedure TQuizType3Frame.BindQuestion(const AWord: TWordRecord);
begin
  // 정답 단어 저장
  FAnswerEng := AWord.WordEng;
  FAnswerKR  := AWord.WordKR;

  // 예문에서 정답 단어를 '_'로 마스킹하여 표기
  EngExampleTextLabel.Text := MaskWord(AWord.ExampleEng, FAnswerEng);
  KrExampleTextLabel.Text  := AWord.ExampleKR;

  // 입력란 초기화, 포커스 설정 및 이벤트 핸들러 연결
  InputEdit.Text      := '';
  InputEdit.OnKeyDown := InputEditKeyDown;
  InputEdit.SetFocus;
end;

/// <summary>
/// 사용자 입력을 정답과 비교하고 OnAnswered 이벤트를 호출합니다.
/// </summary>
procedure TQuizType3Frame.AnswerCheck;
var
  UserInput: string;
begin
  UserInput := Trim(InputEdit.Text);

  // OnAnswered 이벤트가 할당되어 있으면, 정답 여부를 파라미터로 전달하여 호출
  if Assigned(OnAnswered) then
    OnAnswered(SameText(UserInput, FAnswerEng)); // 대소문자 무시하고 비교
end;

/// <summary>
/// 주어진 문장에서 특정 단어를 '_' 문자로 마스킹 처리합니다.
/// </summary>
function TQuizType3Frame.MaskWord(const Sentence, Word: string): string;
var
  Mask: string;
begin
  Mask := StringOfChar('_', Length(Word)); // 단어 길이만큼 '_' 생성
  Result := StringReplace(
    Sentence,
    Word,
    Mask,
    [rfReplaceAll, rfIgnoreCase] // 전체 일치, 대소문자 무시
  );
end;

/// <summary>
/// 입력란에서 엔터 키 입력을 감지하여 정답 확인을 트리거합니다.
/// </summary>
procedure TQuizType3Frame.InputEditKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: WideChar; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    AnswerCheck;
    Key := 0; // 키 입력을 처리했음을 알림
  end;
end;

end.
