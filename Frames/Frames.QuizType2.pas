unit Frames.QuizType2;

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
  /// 사용자가 답을 선택했을 때 정답 여부를 전달하는 콜백 이벤트
  /// </summary>
  /// <param name="IsCorrect">정답 여부</param>
  TAnswerCallback = procedure(IsCorrect: Boolean) of object;

  /// <summary>
  /// 객관식 퀴즈 유형 2 (한글 뜻 → 영단어 맞히기) 프레임
  /// </summary>
  TQuizType2Frame = class(TFrame)
    MainLayout: TLayout;
    ContentSectionLayout: TLayout;

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
    /// <summary>보기 선택 시 호출될 이벤트</summary>
    OnAnswered: TAnswerCallback;

    /// <summary>단어 데이터를 바탕으로 질문 및 보기를 구성</summary>
    procedure BindQuestion(const AWord: TWordRecord);
  end;

implementation

{$R *.fmx}

uses
  System.Math; // Randomize, Random

{-------------------------------------------------------------------------------
  BindQuestion
-------------------------------------------------------------------------------}
procedure TQuizType2Frame.BindQuestion(const AWord: TWordRecord);
var
  Labels: array[0..3] of TLabel;
  i, CorrectIndex, TotalCount, RandomIndex: Integer;
  UsedIDs: TList<Integer>;
begin
  Labels[0] := Option1TextLabel;
  Labels[1] := Option2TextLabel;
  Labels[2] := Option3TextLabel;
  Labels[3] := Option4TextLabel;

  // 질문(한글 뜻) 및 정답(영단어) 설정
  QuestionTextLabel.Text := AWord.WordKR;
  FAnswer := AWord.WordEng;

  // 정답 위치 무작위 선택
  Randomize;
  CorrectIndex := Random(4);
  Labels[CorrectIndex].Text := FAnswer;

  // 나머지 보기에 랜덤 영단어 할당
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

          // 아직 사용되지 않은 단어 선택
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

{-------------------------------------------------------------------------------
  AnswerCheck
-------------------------------------------------------------------------------}
procedure TQuizType2Frame.AnswerCheck(Sender: TObject);
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
