unit Frames.QuizType1;

interface

uses
  // 시스템 기본 유닛
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Generics.Collections,

  // FMX 기본 UI 유닛
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation,

  // 프로젝트 모듈 및 타입
  QuizTypes,
  DM.AppData;

type
  /// <summary>
  /// 사용자가 답을 선택했을 때 정답 여부를 전달하는 콜백 이벤트를 정의합니다.
  /// </summary>
  /// <param name="IsCorrect">정답 여부 (True/False)</param>
  TAnswerCallback = procedure(IsCorrect: Boolean) of object;

  /// <summary>
  /// 객관식 퀴즈 유형 1 (영단어 → 한글 뜻 맞히기) 프레임
  /// </summary>
  TQuizType1Frame = class(TFrame)
    // 레이아웃
    MainLayout: TLayout;
    QuestionSectionLayout: TLayout;
    QuestionCardBackRect: TRectangle;
    QuestionTextLabel: TLabel;

    AnswersSectionLayout: TLayout;
    Option1SectionLayout: TLayout;
    Option1CardBackRect: TRectangle;
    Option1TextLabel: TLabel;
    Option2SectionLayout: TLayout;
    Option2CardBackRect: TRectangle;
    Option2TextLabel: TLabel;
    Option3SectionLayout: TLayout;
    Option3CardBackRect: TRectangle;
    Option3TextLabel: TLabel;
    Option4SectionLayout: TLayout;
    Option4CardBackRect: TRectangle;
    Option4TextLabel: TLabel;
  private
    FAnswer: string;
    procedure AnswerCheck(Sender: TObject);
  public
    /// <summary>
    /// 사용자가 보기를 선택했을 때 호출될 이벤트 핸들러
    /// </summary>
    OnAnswered: TAnswerCallback;

    /// <summary>
    /// 단어 데이터 바인딩: 질문/보기 세팅
    /// </summary>
    procedure BindQuestion(const AWord: TWordRecord);
  end;

implementation

{$R *.fmx}

uses
  // for Randomize, Random
  System.Math;

{-------------------------------------------------------------------------------
  BindQuestion: 단어를 받아 질문과 4개의 보기를 세팅합니다.
-------------------------------------------------------------------------------}
procedure TQuizType1Frame.BindQuestion(const AWord: TWordRecord);
var
  Labels: array[0..3] of TLabel;
  i, CorrectIndex, TotalCount, RandomIndex: Integer;
  UsedIDs: TList<Integer>;
begin
  Labels[0] := Option1TextLabel;
  Labels[1] := Option2TextLabel;
  Labels[2] := Option3TextLabel;
  Labels[3] := Option4TextLabel;

  // 질문 설정
  QuestionTextLabel.Text := AWord.WordEng;
  FAnswer := AWord.WordKR;

  // 보기에 정답 무작위 배치
  Randomize;
  CorrectIndex := Random(4);
  Labels[CorrectIndex].Text := FAnswer;

  // 나머지 보기 채우기 위해 전체 단어 로드
  with AppDataModule.Query do
  begin
    Close;
    SQL.Text := 'SELECT id, meaning_korean FROM Words';
    Open;
    DisableControls;
    try
      TotalCount := RecordCount;
      UsedIDs := TList<Integer>.Create;
      try
        // 정답 단어 ID는 오답 후보에서 제외
        UsedIDs.Add(AWord.ID);

        for i := 0 to 3 do
        begin
          if i = CorrectIndex then
            Continue;

          // 아직 사용되지 않은 랜덤 인덱스 찾기
          repeat
            RandomIndex := Random(TotalCount);
            RecNo := RandomIndex + 1;
          until not UsedIDs.Contains(FieldByName('id').AsInteger);

          // 선택된 단어의 뜻을 보기로 설정
          Labels[i].Text := FieldByName('meaning_korean').AsString;
          UsedIDs.Add(FieldByName('id').AsInteger);
        end;
      finally
        UsedIDs.Free;
      end;
    finally
      EnableControls;
      Close;
    end;
  end;

  // 클릭 이벤트 연결
  Option1CardBackRect.OnClick := AnswerCheck;
  Option2CardBackRect.OnClick := AnswerCheck;
  Option3CardBackRect.OnClick := AnswerCheck;
  Option4CardBackRect.OnClick := AnswerCheck;
end;

{-------------------------------------------------------------------------------
  AnswerCheck: 사용자가 클릭한 보기가 정답인지 판단 후 OnAnswered 호출
-------------------------------------------------------------------------------}
procedure TQuizType1Frame.AnswerCheck(Sender: TObject);
var
  SelectedText: string;
begin
  if Sender = Option1CardBackRect then
    SelectedText := Option1TextLabel.Text
  else if Sender = Option2CardBackRect then
    SelectedText := Option2TextLabel.Text
  else if Sender = Option3CardBackRect then
    SelectedText := Option3TextLabel.Text
  else if Sender = Option4CardBackRect then
    SelectedText := Option4TextLabel.Text
  else
    SelectedText := '';

  if Assigned(OnAnswered) then
    OnAnswered(SelectedText = FAnswer);
end;

end.
