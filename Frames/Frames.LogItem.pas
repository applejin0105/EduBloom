unit Frames.LogItem;

interface

uses
  // 시스템 기본 유닛
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  // FMX 기본 UI 유닛
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation,

  // Skia 그래픽 유닛
  System.Skia, FMX.Skia;

type
  /// <summary>
  /// '학습 기록' 폼의 리스트에 표시될 개별 항목을 나타내는 프레임입니다.
  /// </summary>
  TLogItemFrame = class(TFrame)
    // 전체 레이아웃
    MainLayout: TLayout;

    // 좌측 정보 (날짜, 문제 수)
    EntryInfoSectionLayout: TLayout;
    EntryDateSectionLayout: TLayout;
    EntryDateLabel: TLabel;
    EntryStudyCountSectionLayout: TLayout;
    EntryStudyCountLabel: TLabel;

    // 우측 통계 (학습 시간, 정답률)
    EntryStatsSectionLayout: TLayout;
    DetailIconSectionLayout: TLayout;
    DetailIconSvg: TSkSvg;
    EntryStatsValuesSectionLayout: TLayout;
    StudyTimeSectionLayout: TLayout;
    StudyTimeValueLabel: TLabel;
    AccuracySectionLayout: TLayout;
    AccuracyValueLabel: TLabel;
  private
    { Private declarations }
    procedure SetEntryDateText(const Value: string);
    procedure SetEntryStudyCountText(const Value: string);
    procedure SetStudyTimeText(const Value: string);
    procedure SetAccuracyText(const Value: string);
  public
    { Public declarations }
    /// <summary>
    /// 학습 날짜를 나타내는 텍스트 (예: '6월 3일 화요일')를 설정합니다.
    /// </summary>
    property EntryDateText: string write SetEntryDateText;

    /// <summary>
    /// 총 학습 문제 수를 나타내는 텍스트 (예: '30개')를 설정합니다.
    /// </summary>
    property EntryStudyCountText: string write SetEntryStudyCountText;

    /// <summary>
    /// 총 학습 시간을 나타내는 텍스트 (예: '0:10')를 설정합니다.
    /// </summary>
    property StudyTimeText: string write SetStudyTimeText;

    /// <summary>
    /// 정답률 및 맞힌 개수를 나타내는 텍스트 (예: '26/30')를 설정합니다.
    /// </summary>
    property AccuracyText: string write SetAccuracyText;
  end;


implementation

{$R *.fmx}

/// <summary>
/// 학습 기록 날짜를 표시하는 라벨의 텍스트를 설정합니다.
/// </summary>
/// <param name="Value">표시할 날짜 텍스트</param>
procedure TLogItemFrame.SetEntryDateText(const Value: string);
begin
  EntryDateLabel.Text := Value;
end;

/// <summary>
/// 학습한 문제 수를 표시하는 라벨의 텍스트를 설정합니다.
/// </summary>
/// <param name="Value">표시할 문제 수 텍스트</param>
procedure TLogItemFrame.SetEntryStudyCountText(const Value: string);
begin
  EntryStudyCountLabel.Text := Value;
end;

/// <summary>
/// 총 학습 시간을 표시하는 라벨의 텍스트를 설정합니다.
/// </summary>
/// <param name="Value">표시할 학습 시간 텍스트</param>
procedure TLogItemFrame.SetStudyTimeText(const Value: string);
begin
  StudyTimeValueLabel.Text := Value;
end;

/// <summary>
/// 정답률 또는 맞힌 개수를 표시하는 라벨의 텍스트를 설정합니다.
/// </summary>
/// <param name="Value">표시할 정답률 텍스트</param>
procedure TLogItemFrame.SetAccuracyText(const Value: string);
begin
  AccuracyValueLabel.Text := Value;
end;

end.
