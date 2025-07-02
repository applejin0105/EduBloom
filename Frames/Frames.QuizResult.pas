unit Frames.QuizResult;

interface

uses
  // 시스템 기본 유닛
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  // FMX 기본 UI 유닛
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation;

type
  /// <summary>
  /// 퀴즈 완료 후 점수 및 통계를 표시하는 결과 프레임입니다.
  /// </summary>
  TQuizResultFrame = class(TFrame)
    // 전체 레이아웃
    MainLayout: TLayout;

    // 섹션별 레이아웃
    ResultTitleSectionLayout: TLayout;
    SummaryCardSectionLayout: TLayout;
    DetailSectionLayout: TLayout;
    ButtonsSectionLayout: TLayout;

    // 결과 타이틀
    ResultTitleLabel: TLabel;

    // 요약 카드
    SummaryCardBackRect: TRectangle;
    SummaryValuesSectionLayout: TLayout;
    SummaryCountValueLabel: TLabel;
    SummaryPercentageValueLabel: TLabel;

    // 상세 결과 카드
    DetailCardBackRect: TRectangle;
    TotalQuestionsSectionLayout: TLayout;
    TotalQuestionsTitleLayout: TLayout;
    TotalQuestionsTitleLabel: TLabel;
    TotalQuestionsValueLayout: TLayout;
    TotalQuestionsValueLabel: TLabel;
    CorrectAnswersSectionLayout: TLayout;
    CorrectAnswersTitleLayout: TLayout;
    CorrectAnswersTitleLabel: TLabel;
    CorrectAnswersValueLayout: TLayout;
    CorrectAnswersValueLabel: TLabel;
    WrongAnswersSectionLayout: TLayout;
    WrongAnswersTitleLayout: TLayout;
    WrongAnswersTitleLabel: TLabel;
    WrongAnswersValueLayout: TLayout;
    WrongAnswersValueLabel: TLabel;

    // 버튼 섹션
    RetryButtonLayout: TLayout;
    RetryButtonBackRect: TRectangle;
    RetryButtonLabel: TLabel;
    HomeButtonLayout: TLayout;
    HomeButtonBackRect: TRectangle;
    HomeButtonLabel: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
