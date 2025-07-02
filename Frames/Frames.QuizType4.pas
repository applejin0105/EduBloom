unit Frames.QuizType4;

interface

uses
  // 시스템 기본 유닛
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.StrUtils, System.Generics.Collections,

  // FMX 기본 UI 유닛
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,

  // Skia 그래픽 유닛
  System.Skia, FMX.Skia,

  // 프로젝트 모듈 및 타입
  QuizTypes,
  DM.AppData;

type
  /// <summary>
  /// 사용자가 답을 선택했을 때 정답 여부를 전달하는 콜백 이벤트
  /// </summary>
  /// <param name="IsCorrect">정답 여부 (True/False)</param>
  TAnswerCallback = procedure(IsCorrect: Boolean) of object;

  /// <summary>
  /// 객관식 퀴즈 유형 4 (예문 빈칸에 알맞은 단어 고르기) 프레임
  /// </summary>
  TQuizType4Frame = class(TFrame)
    MainLayout: TLayout;
    ContentSectionLayout: TLayout;
    QuestionSectionLayout: TLayout;
    AnswersSectionLayout: TLayout;
    AnswersLeftSectionLayout: TLayout;
    AnswersRightSectionLayout: TLayout;

    // 질문 섹션 (빈칸 있는 예문)
    QuestionCardBackRect: TRectangle;
    QuestionCardContentLayout: TLayout;
    QuestionBlankSectionLayout: TLayout;
    BlankDisplayLabel: TLabel;
    QuestionSentenceSectionLayout: TLayout;
    EngExampleLabel: TLabel;
    HintLabel: TLabel;
    KrExampleLabel: TLabel;

    // 보기 1
    Option1SectionLayout: TLayout;
    Option1CardBackRect: TRectangle;
    Option1TextLabel: TLabel;
    // 보기 2
    Option2SectionLayout: TLayout;
    Option2CardBackRect: TRectangle;
    Option2TextLabel: TLabel;
    // 보기 3
    Option3SectionLayout: TLayout;
    Option3CardBackRect: TRectangle;
    Option3TextLabel: TLabel;
    // 보기 4
    Option4SectionLayout: TLayout;
    Option4CardBackRect: TRectangle;
    Option4TextLabel: TLabel;
  private
    FAnswer: string;
    function MaskWord(const Sentence, Word: string): string;
    procedure AnswerCheck(Sender: TObject);
  public
    /// <summary>보기 선택 시 호출될 이벤트</summary>
    OnAnswered: TAnswerCallback;

    /// <summary>단어 데이터를 바탕으로 빈칸 예문과 보기를 구성</summary>
    procedure BindQuestion(const AWord: TWordRecord);
  end;

implementation

{$R *.fmx}

uses
  System.Math; // Randomize, Random

procedure TQuizType4Frame.BindQuestion(const AWord: TWordRecord);
var
  Labels: array[0..3] of TLabel;
  i, CorrectIndex, TotalCount, RandomIndex: Integer;
  UsedIDs: TList<Integer>;
begin
  Labels[0] := Option1TextLabel;
  Labels[1] := Option2TextLabel;
  Labels[2] := Option3TextLabel;
  Labels[3] := Option4TextLabel;

  // 질문 예문 표시
  BlankDisplayLabel.Text := StringOfChar('_', Length(AWord.WordEng));
  HintLabel.Text         := AWord.WordKR;
  EngExampleLabel.Text   := MaskWord(AWord.ExampleEng, AWord.WordEng);
  KrExampleLabel.Text    := AWord.ExampleKR;

  // 정답 설정
  FAnswer := AWord.WordEng;
  Randomize;
  CorrectIndex := Random(4);
  Labels[CorrectIndex].Text := FAnswer;

  // 나머지 보기 채우기
  UsedIDs := TList<Integer>.Create;
  try
    UsedIDs.Add(AWord.ID);

    with AppDataModule.Query do
    begin
      Close;
      SQL.Text := 'SELECT id, word FROM Words';
      Open;
      DisableControls;
      try
        TotalCount := RecordCount;
        for i := 0 to 3 do
        begin
          if i = CorrectIndex then
            Continue;
          repeat
            RandomIndex := Random(TotalCount);
            RecNo := RandomIndex + 1;
          until not UsedIDs.Contains(FieldByName('id').AsInteger);
          Labels[i].Text := FieldByName('word').AsString;
          UsedIDs.Add(FieldByName('id').AsInteger);
        end;
      finally
        EnableControls;
        Close;
      end;
    end;
  finally
    UsedIDs.Free;
  end;

  // 클릭 이벤트 연결
  Option1CardBackRect.OnClick := AnswerCheck;
  Option2CardBackRect.OnClick := AnswerCheck;
  Option3CardBackRect.OnClick := AnswerCheck;
  Option4CardBackRect.OnClick := AnswerCheck;
end;

function TQuizType4Frame.MaskWord(const Sentence, Word: string): string;
begin
  Result := StringReplace(
    Sentence,
    Word,
    StringOfChar('_', Length(Word)),
    [rfReplaceAll, rfIgnoreCase]
  );
end;

procedure TQuizType4Frame.AnswerCheck(Sender: TObject);
var
  Selected: string;
begin
  if Sender = Option1CardBackRect then
    Selected := Option1TextLabel.Text
  else if Sender = Option2CardBackRect then
    Selected := Option2TextLabel.Text
  else if Sender = Option3CardBackRect then
    Selected := Option3TextLabel.Text
  else
    Selected := Option4TextLabel.Text;

  if Assigned(OnAnswered) then
    OnAnswered(Selected = FAnswer);
end;

end.
