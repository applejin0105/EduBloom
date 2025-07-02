unit Forms.Quiz;

interface

uses
  // 시스템 유닛
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.StrUtils, System.Generics.Collections,

  // FMX UI 유닛
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Layouts, FMX.Objects, FMX.Ani,

  // 프레임 유닛
  Frames.QuizStart, Frames.QuizResult,
  Frames.QuizType1, Frames.QuizType2, Frames.QuizType3, Frames.QuizType4,

  // 데이터 및 프로젝트 유닛
  QuizTypes, Forms.BaseForm, DM.AppData;

type
  TFrameClass = class of TFrame;

  // 퀴즈 결과 구조체
  TQuizResult = record
    Word: TWordRecord;
    IsCorrect: Boolean;
    class function Create(const AWord: TWordRecord; AIsCorrect: Boolean): TQuizResult; static;
  end;

  // 퀴즈 메인 폼 클래스
  TQuizForm = class(TBaseForm)
    // 레이아웃 구성
    ProgressBarSectionLayout: TLayout;
    QuizSectionLayout: TLayout;
    ProgressBarBackRect: TRectangle;
    ProgressBarFillRect: TRectangle;
    ProgressBarFillAnimation: TFloatAnimation;
    MainLayout: TScaledLayout;

    // 이벤트 핸들러
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure ProgressBarFillAnimationFinish(Sender: TObject);

  private
    // 퀴즈 진행 정보
    FTotalCount: Integer;
    FCurrentIndex: Integer;
    FIsRetry: Boolean;
    FReviewMode: Boolean;
    FStartTime: TDateTime;
    BarMaxWidth: Single;

    // 단어 및 결과
    FCurrentWord: TWordRecord;
    FResults: TList<TQuizResult>;
    FWrongWords: TList<TWordRecord>;

    // 프레임들
    FStartFrame: TQuizStartFrame;
    FResultFrame: TQuizResultFrame;
    FCurrentQuizFrame: TFrame;
    FFrameToDispose: TFrame;

    // 내부 처리 함수
    procedure AnimateProgress;
    procedure AnimateFrameTransition(const OldFrame, NewFrame: TFrame);
    procedure CleanupQuizFrames;
    procedure HandleSlideOutFinish(Sender: TObject);
    procedure ShowQuizType(FrameClass: TFrameClass);
    procedure ShowResults;

  public
    // 외부 호출 메서드
    property ReviewMode: Boolean read FReviewMode write FReviewMode;
    procedure LoadReviewWords(const AWrongWords: TArray<TWordRecord>);
    procedure StartQuiz;
    procedure HandleStartQuiz(Sender: TObject; Count: Integer);
    procedure StartNextQuiz;
    procedure OnCorrectAnswer(IsCorrect: Boolean);
    procedure RetryQuiz(Sender: TObject);
    procedure GoHome(Sender: TObject);
    procedure SlideOutAnimationFinished(Sender: TObject);
  end;

var
  QuizForm: TQuizForm;

implementation

{$R *.fmx}

uses
  System.Math;

{ TQuizResult }

class function TQuizResult.Create(const AWord: TWordRecord; AIsCorrect: Boolean): TQuizResult;
begin
  Result.Word := AWord;
  Result.IsCorrect := AIsCorrect;
end;

{ TQuizForm }

procedure TQuizForm.FormCreate(Sender: TObject);
begin
  Self.OnHide := FormHide;
end;

procedure TQuizForm.FormDestroy(Sender: TObject);
begin
  CleanupQuizFrames;
  FreeAndNil(FResults);
  FreeAndNil(FWrongWords);
end;

procedure TQuizForm.FormShow(Sender: TObject);
begin
  CleanupQuizFrames;

  {$IFDEF MSWINDOWS}
  Position := TFormPosition.Designed;
  SetBounds(Application.MainForm.Left, Application.MainForm.Top, Width, Height);
  {$ENDIF}

  BarMaxWidth := ProgressBarBackRect.Width;
  ProgressBarFillRect.Width := 0;

  // 단일 Query 사용
  AppDataModule.Query.Open;

  if FReviewMode then
  begin
    if not Assigned(FWrongWords) or (FWrongWords.Count = 0) then
    begin
      ShowMessage('오답노트에 복습할 단어가 없습니다.');
      GoHome(nil);
      Exit;
    end;

    FreeAndNil(FResults);
    FResults := TList<TQuizResult>.Create;
    FIsRetry := True;
    FTotalCount := FWrongWords.Count;
    FCurrentIndex := 0;
    FStartTime := Now;
    StartNextQuiz;
  end
  else
    StartQuiz;
end;

procedure TQuizForm.FormHide(Sender: TObject);
begin
  if Assigned(Application.MainForm) and (Application.MainForm <> Self) then
    (Application.MainForm as TBaseForm).ShowWithFade;
end;

procedure TQuizForm.ProgressBarFillAnimationFinish(Sender: TObject);
begin
  Inc(FCurrentIndex);
  StartNextQuiz;
end;

procedure TQuizForm.AnimateProgress;
var
  TargetW: Single;
  Anim: TFloatAnimation;
begin
  TargetW := BarMaxWidth * (FCurrentIndex + 1) / FTotalCount;
  Anim := TFloatAnimation.Create(ProgressBarFillRect);
  Anim.Parent := ProgressBarFillRect;
  Anim.PropertyName := 'Width';
  Anim.StartValue := ProgressBarFillRect.Width;
  Anim.StopValue := TargetW;
  Anim.Duration := 0.3;
  Anim.OnFinish := ProgressBarFillAnimationFinish;
  Anim.Start;
end;

procedure TQuizForm.AnimateFrameTransition(const OldFrame, NewFrame: TFrame);
var
  FadeIn, SlideIn, FadeOut, SlideOut: TFloatAnimation;
begin
  FadeIn := TFloatAnimation.Create(NewFrame);
  FadeIn.Parent := NewFrame;
  FadeIn.PropertyName := 'Opacity';
  FadeIn.StartValue := 0;
  FadeIn.StopValue := 1;
  FadeIn.Duration := 0.4;

  SlideIn := TFloatAnimation.Create(NewFrame);
  SlideIn.Parent := NewFrame;
  SlideIn.PropertyName := 'Position.X';
  SlideIn.StartValue := NewFrame.Position.X;
  SlideIn.StopValue := 0;
  SlideIn.Duration := 0.4;

  FadeIn.Start;
  SlideIn.Start;

  if Assigned(OldFrame) then
  begin
    FFrameToDispose := OldFrame;
    OldFrame.Visible := True;
    OldFrame.HitTest := False;
    OldFrame.Position.X := 0;

    FadeOut := TFloatAnimation.Create(OldFrame);
    FadeOut.Parent := OldFrame;
    FadeOut.PropertyName := 'Opacity';
    FadeOut.StartValue := 1;
    FadeOut.StopValue := 0;
    FadeOut.Duration := 0.4;

    SlideOut := TFloatAnimation.Create(OldFrame);
    SlideOut.Parent := OldFrame;
    SlideOut.PropertyName := 'Position.X';
    SlideOut.StartValue := 0;
    SlideOut.StopValue := -QuizSectionLayout.Width;
    SlideOut.Duration := 0.4;
    SlideOut.OnFinish := HandleSlideOutFinish;

    FadeOut.Start;
    SlideOut.Start;
  end;
end;

procedure TQuizForm.CleanupQuizFrames;
begin
  FreeAndNil(FCurrentQuizFrame);
  FreeAndNil(FResultFrame);
  FreeAndNil(FStartFrame);
end;

procedure TQuizForm.HandleSlideOutFinish(Sender: TObject);
begin
  if Assigned(FFrameToDispose) then
  begin
    FFrameToDispose.Free;
    FFrameToDispose := nil;
  end;
end;

procedure TQuizForm.ShowQuizType(FrameClass: TFrameClass);
var
  OldFrame, NewFrame: TFrame;
begin
  OldFrame := FCurrentQuizFrame;

  // 1) nil Owner 로 생성 → MainForm.Components 에 등록되지 않음
  NewFrame := FrameClass.Create(nil);
  // 2) Name 충돌 방지
  NewFrame.Name := '';

  // 3) 레이아웃에 붙이고 크기/위치/투명도 세팅
  NewFrame.Parent     := QuizSectionLayout;
  NewFrame.Align      := TAlignLayout.Client;
  NewFrame.Position.X := QuizSectionLayout.Width;
  NewFrame.Position.Y := 0;
  NewFrame.Opacity    := 0;

  // 4) 애니메이션으로 교체
  AnimateFrameTransition(OldFrame, NewFrame);
  FCurrentQuizFrame := NewFrame;

  // 5) 프레임별 바인딩
  if NewFrame is TQuizType1Frame then
    with TQuizType1Frame(NewFrame) do
    begin
      BindQuestion(FCurrentWord);
      OnAnswered := OnCorrectAnswer;
    end
  else if NewFrame is TQuizType2Frame then
    with TQuizType2Frame(NewFrame) do
    begin
      BindQuestion(FCurrentWord);
      OnAnswered := OnCorrectAnswer;
    end
  else if NewFrame is TQuizType3Frame then
    with TQuizType3Frame(NewFrame) do
    begin
      BindQuestion(FCurrentWord);
      OnAnswered := OnCorrectAnswer;
    end
  else // TQuizType4Frame
    with TQuizType4Frame(NewFrame) do
    begin
      BindQuestion(FCurrentWord);
      OnAnswered := OnCorrectAnswer;
    end;
end;

procedure TQuizForm.ShowResults;
var
  Total, Correct, Wrong, Percent: Integer;
  R: TQuizResult;
  D: TDateTime; H, M, S, MS, Sec, Min: Word;
begin
  CleanupQuizFrames;
  Total := FResults.Count;
  Correct := 0;
  for R in FResults do
    if R.IsCorrect then
      Inc(Correct);
  Wrong := Total - Correct;
  Percent := Round(Correct / Total * 100);

  D := Now - FStartTime;
  DecodeTime(D, H, M, S, MS);
  Sec := H * 3600 + M * 60 + S;
  Min := Sec div 60;

  if not FReviewMode then
    AppDataModule.SaveLog(Now, Total, Correct, Min, Sec mod 60);

  FResultFrame := TQuizResultFrame.Create(nil);
  FResultFrame.Parent := QuizSectionLayout;
  FResultFrame.Align := TAlignLayout.Contents;
  with FResultFrame do
  begin
    ResultTitleLabel.Text := IfThen(FReviewMode, '오답노트 복습 결과', '퀴즈 결과');
    SummaryCountValueLabel.Text := Format('%d/%d', [Correct, Total]);
    SummaryPercentageValueLabel.Text := Format('%d%%', [Percent]);
    TotalQuestionsValueLabel.Text := Total.ToString;
    CorrectAnswersValueLabel.Text := Correct.ToString;
    WrongAnswersValueLabel.Text := Wrong.ToString;

    RetryButtonLabel.Text := IfThen(FReviewMode, '다시 복습', '다시 풀기');
    RetryButtonBackRect.Enabled := Wrong > 0;
    RetryButtonBackRect.Visible := Wrong > 0;
    RetryButtonBackRect.OnClick := RetryQuiz;
    HomeButtonBackRect.OnClick := GoHome;
  end;
end;

procedure TQuizForm.LoadReviewWords(const AWrongWords: TArray<TWordRecord>);
var
  Word: TWordRecord;
begin
  FreeAndNil(FWrongWords);
  FWrongWords := TList<TWordRecord>.Create;
  for Word in AWrongWords do
    FWrongWords.Add(Word);
end;

procedure TQuizForm.StartQuiz;
var
  defaultCnt: Integer;
begin
  defaultCnt := AppDataModule.DefaultCount;

  CleanupQuizFrames;
  ProgressBarFillRect.Width := 0;
  FCurrentIndex := 0;
  FreeAndNil(FResults);
  FreeAndNil(FWrongWords);
  FResults := TList<TQuizResult>.Create;
  FWrongWords := TList<TWordRecord>.Create;
  FIsRetry := False;
  FReviewMode := False;

  FStartFrame := TQuizStartFrame.Create(nil);
  FStartFrame.Parent := MainLayout;
  FStartFrame.Align := TAlignLayout.Contents;
  FStartFrame.Init(defaultCnt);
  FStartFrame.OnStart := HandleStartQuiz;
end;

procedure TQuizForm.HandleStartQuiz(Sender: TObject; Count: Integer);
begin
  FreeAndNil(FStartFrame);
  FTotalCount := Count;
  FCurrentIndex := 0;
  FStartTime := Now;
  StartNextQuiz;
end;

procedure TQuizForm.StartNextQuiz;
begin
  if FCurrentIndex >= FTotalCount then
  begin
    ShowResults;
    Exit;
  end;

  if (FReviewMode or FIsRetry) and (FCurrentIndex >= FWrongWords.Count) then
  begin
    ShowResults;
    Exit;
  end;

  if FReviewMode or FIsRetry then
  begin
    // 복습 모드: 미리 수집된 리스트에서 꺼내 쓰므로 기존대로
    FCurrentWord := FWrongWords[FCurrentIndex];
    ShowQuizType(TQuizType4Frame);
  end
  else
  begin
    with AppDataModule.Query do
    begin
      Close;
      // 필드가 모두 포함되도록 SQL을 다시 지정
      SQL.Text :=
        'SELECT id, word, meaning_korean, part_of_speech, example, example_korean ' +
        'FROM Words';
      Open;

      // 랜덤하게 한 레코드로 이동
      First;
      MoveBy(Random(RecordCount));

      FCurrentWord.ID           := FieldByName('id').AsInteger;
      FCurrentWord.WordEng      := FieldByName('word').AsString;
      FCurrentWord.WordKR       := FieldByName('meaning_korean').AsString;
      FCurrentWord.PartOfSpeech := FieldByName('part_of_speech').AsString;
      FCurrentWord.ExampleEng   := FieldByName('example').AsString;
      FCurrentWord.ExampleKR    := FieldByName('example_korean').AsString;
    end;

    // 문제 유형 선택
    case Random(3) of
      0: ShowQuizType(TQuizType1Frame);
      1: ShowQuizType(TQuizType2Frame);
      2: ShowQuizType(TQuizType3Frame);
    end;
  end;
end;

procedure TQuizForm.OnCorrectAnswer(IsCorrect: Boolean);
begin
  FResults.Add(TQuizResult.Create(FCurrentWord, IsCorrect));
  if not IsCorrect then
  begin
    AppDataModule.SaveWrongWord(FCurrentWord.ID);
    FWrongWords.Add(FCurrentWord);
  end;
  AnimateProgress;
end;

procedure TQuizForm.RetryQuiz(Sender: TObject);
begin
  FreeAndNil(FResultFrame);
  ProgressBarFillRect.Width := 0;
  FreeAndNil(FCurrentQuizFrame);

  if not Assigned(FWrongWords) or (FWrongWords.Count = 0) then
  begin
    ShowMessage('틀린 문제가 없습니다.');
    Exit;
  end;
  FIsRetry := True;
  FTotalCount := FWrongWords.Count;
  FCurrentIndex := 0;
  FreeAndNil(FResults);
  FResults := TList<TQuizResult>.Create;
  StartNextQuiz;
end;

procedure TQuizForm.GoHome(Sender: TObject);
begin
  Hide;
  if Assigned(Application.MainForm) then
    Application.MainForm.Show;
end;

procedure TQuizForm.SlideOutAnimationFinished(Sender: TObject);
var
  Anim: TFloatAnimation;
  FrameToDispose: TFrame;
begin
  Anim := TFloatAnimation(Sender);
  if not Assigned(Anim) or not (Anim.Parent is TFrame) then
    Exit;

  FrameToDispose := TFrame(Anim.Parent);
  if (FrameToDispose.Parent <> QuizSectionLayout) then
    Exit;

  FrameToDispose.HitTest := False;
  FrameToDispose.Visible := False;

  TThread.Queue(nil,
    procedure
    begin
      if Assigned(FrameToDispose.Parent) and (FrameToDispose.Parent = QuizSectionLayout) then
        FrameToDispose.Free;
    end
  );
end;

end.
