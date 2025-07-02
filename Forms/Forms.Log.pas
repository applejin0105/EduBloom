unit Forms.Log;

interface

uses
  // 시스템 기본 유닛
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.DateUtils, System.Math,

  // FMX 기본 UI 유닛
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Ani,

  // Skia 그래픽 유닛
  System.Skia, FMX.Skia,

  // DB 관련
  Data.DB,

  // 프로젝트 모듈
  DM.AppData,
  Frames.LogItem,

  // 사용자 정의 폼
  Forms.BaseForm;

const
  WeekDays: array[1..7] of string =
    ('일요일','월요일','화요일','수요일','목요일','금요일','토요일');

type
  TLogForm = class(TBaseForm)
    // 전체 레이아웃
    MainLayout: TScaledLayout;

    // 헤더 및 네비게이션
    HeaderSectionLayout: TLayout;
    HeaderTitleLayout: TLayout;
    HeaderTitleLabel: TLabel;
    HomeIconSvgLayout: TLayout;
    HomeIconSvg: TSkSvg;

    // 학습 요약 카드 섹션
    SummarySectionLayout: TLayout;
    SummaryTitleSectionLayout: TLayout;
    SummaryTitleLabelLayout: TLayout;
    SummaryTitleLabel: TLabel;
    SummaryStatsGridLayout: TGridLayout;
    StudiedWordsCardBackRect: TRectangle;
    AccuracyCardBackRect: TRectangle;
    StudyTimeCardBackRect: TRectangle;
    StreakCardBackRect: TRectangle;

    // 학습 단어 수 카드
    StudiedWordsCountSectionLayout: TLayout;
    StudiedWordsTitleLayout: TLayout;
    StudiedWordsTitleLabel: TLabel;
    StudiedWordsCountValueLayout: TLayout;
    StudiedWordsCountValueLabel: TLabel;
    StudiedWordsCountUnitLayout: TLayout;
    StudiedWordsCountUnitLabel: TLabel;

    // 정답률 카드
    AccuracyCountSectionLayout: TLayout;
    AccuracyTitleLayout: TLayout;
    AccuracyTitleLabel: TLabel;
    AccuracyCountValueLayout: TLayout;
    AccuracyCountValueLabel: TLabel;
    AccuracyCountUnitLayout: TLayout;
    AccuracyCountUnitLabel: TLabel;

    // 학습 시간 카드
    StudyTimeHoursSectionLayout: TLayout;
    StudyTimeHoursValueLayout: TLayout;
    StudyTimeHoursValueLabel: TLabel;
    StudyTimeHoursUnitLayout: TLayout;
    StudyTimeHoursUnitLabel: TLabel;
    StudyTimeMinutesSectionLayout: TLayout;
    StudyTimeMinutesValueLayout: TLayout;
    StudyTimeMinutesValueLabel: TLabel;
    StudyTimeMinutesUnitLayout: TLayout;
    StudyTimeMinutesUnitLabel: TLabel;

    // 연속 학습일 카드
    DayStreakSectionLayout: TLayout;
    DayStreakTitleLayout: TLayout;
    DayStreakTitleLabel: TLabel;
    DayStreakValueLayout: TLayout;
    DayStreakValueLabel: TLabel;
    DayStreakUnitLayout: TLayout;
    DayStreakUnitLabel: TLabel;

    // 주간 차트 섹션
    ChartSecionLayout: TLayout;
    ChartBackRect: TRectangle;
    ChartLegendLayout: TLayout;
    LineChartIconLayout: TLayout;
    LineChartIconSvg: TSkSvg;
    LineChartLabelLayout: TLayout;
    LineChartLabel: TLabel;
    BarChartIconLayout: TLayout;
    BarChartIconSvg: TSkSvg;
    BarChartLabelLayout: TLayout;
    BarChartLabel: TLabel;
    LineChartLayout: TLayout;
    BarChartLayout: TLayout;

    // 학습 기록 리스트 섹션
    HistorySectionLayout: TLayout;
    HistoryTitleSectionLayout: TLayout;
    HistoryTitleLabel: TLabel;
    HistoryListContainerLayout: TLayout;
    HistoryListBackRect: TRectangle;
    HistoryListScrollBox: TScrollBox;

    // 이벤트 핸들러
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure HomeIconSvgClick(Sender: TObject);
  private
    FLogs: TArray<TLogEntry>; // 차트 렌더링에 사용될 최근 로그 데이터
    procedure LoadFromDatabase;
    procedure PopulateLastStudyList(const AData: TArray<TLogEntry>);
    function CalculateStreak(const Logs: TArray<TLogEntry>): Integer;
    procedure RenderManualChart;
  public
    { Public declarations }
  end;

var
  LogForm: TLogForm;

implementation

{$R *.fmx}

/// <summary>
/// 폼 생성 시 Hide 이벤트 핸들러를 연결합니다.
/// </summary>
procedure TLogForm.FormCreate(Sender: TObject);
begin
  inherited;
  // 이 폼이 숨겨질 때 메인 폼을 다시 표시하기 위해 이벤트 연결
  Self.OnHide := FormHide;
end;

/// <summary>
/// 폼이 표시될 때 위치를 조정하고 데이터베이스에서 학습 기록을 로드합니다.
/// </summary>
procedure TLogForm.FormShow(Sender: TObject);
begin
  inherited;
  {$IFDEF MSWINDOWS}
  // MainForm 위치에 맞게 폼 위치 조정
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
  // DB에서 데이터를 로드하여 UI 갱신
  LoadFromDatabase;
end;

/// <summary>
/// 폼이 숨겨진 후 메인 폼을 다시 표시합니다.
/// </summary>
procedure TLogForm.FormHide(Sender: TObject);
begin
  // 메인폼이 자신(Self)이 아닐 경우에만 메인폼을 페이드 인 효과로 표시
  if Assigned(Application.MainForm) and (Application.MainForm <> Self) then
    (Application.MainForm as TBaseForm).ShowWithFade;
end;

/// <summary>
/// 홈 아이콘 클릭 시 현재 폼을 닫고 메인 화면으로 복귀합니다.
/// </summary>
procedure TLogForm.HomeIconSvgClick(Sender: TObject);
begin
  HideWithFade;
end;

/// <summary>
/// 데이터베이스에서 모든 학습 기록을 로드하여 요약 정보를 계산하고 UI를 갱신합니다.
/// </summary>
procedure TLogForm.LoadFromDatabase;
var
  AllLogs, Last5: TArray<TLogEntry>;
  TotalCorrect, TotalCount, TotalMin: Integer;
  Accuracy: Double;
  i: Integer;
begin
  AllLogs := AppDataModule.LoadAllLogs;
  if Length(AllLogs) = 0 then Exit; // 기록이 없으면 종료

  // 전체 기록 요약 계산
  TotalCorrect := 0; TotalCount := 0; TotalMin := 0;
  for i := 0 to High(AllLogs) do
  begin
    Inc(TotalCorrect, AllLogs[i].CorrectCount);
    Inc(TotalCount,   AllLogs[i].TotalCount);
    Inc(TotalMin,     AllLogs[i].Hours*60 + AllLogs[i].Minutes);
  end;
  if TotalCount > 0 then
    Accuracy := TotalCorrect / TotalCount
  else
    Accuracy := 0;

  // 요약 카드 UI 갱신
  StudiedWordsCountValueLabel.Text := Format('%d', [TotalCorrect]);
  AccuracyCountValueLabel.Text     := Format('%.0f%', [Accuracy*100]);
  StudyTimeHoursValueLabel.Text    := (TotalMin div 60).ToString;
  StudyTimeMinutesValueLabel.Text  := (TotalMin mod 60).ToString;
  DayStreakValueLabel.Text         := Format('%d', [CalculateStreak(AllLogs)]);

  // 차트용으로 최근 5개 기록을 복사
  if Length(AllLogs) > 5 then
    Last5 := Copy(AllLogs, Length(AllLogs) - 5, 5)
  else
    Last5 := AllLogs;
  FLogs := Last5;

  // 차트와 학습 기록 리스트 UI 갱신
  RenderManualChart;
  PopulateLastStudyList(AllLogs);
end;

/// <summary>
/// 주어진 학습 기록 데이터로 '최근 학습 기록' 리스트를 동적으로 채웁니다.
/// </summary>
/// <param name="AData">화면에 표시할 로그 데이터 배열</param>
procedure TLogForm.PopulateLastStudyList(const AData: TArray<TLogEntry>);
var
  i: Integer;
  item: TLogItemFrame;
  sep: TRectangle;
begin
  // 이전 내용 전부 해제
  while HistoryListScrollBox.Content.ControlsCount > 0 do
    HistoryListScrollBox.Content.Controls[0].Free;

  HistoryListScrollBox.BeginUpdate;
  try
    // 데이터를 역순으로 표시하기 위해 High부터 Low로 순회
    for i := High(AData) downto Low(AData) do
    begin
      // 로그 아이템 프레임 생성 및 설정
      item := TLogItemFrame.Create(nil); // Owner를 nil로 하여 직접 관리
      item.Parent := HistoryListScrollBox.Content;
      item.Align  := TAlignLayout.Top;
      item.Margins.Rect := TRectF.Create(0, 8, 0, 8);

      // 데이터 할당
      item.EntryDateText := Format('%d월 %d일 %s', [
                        MonthOf(AData[i].LogDate),
                        DayOf(AData[i].LogDate),
                        WeekDays[DayOfWeek(AData[i].LogDate)]]);
      item.EntryStudyCountText := Format('%d개', [AData[i].TotalCount]);
      item.AccuracyText := Format('%d/%d', [AData[i].CorrectCount, AData[i].TotalCount]);
      item.StudyTimeText := Format('%d:%2.2d', [AData[i].Hours, AData[i].Minutes]);

      // 마지막 아이템이 아닐 경우 구분선 추가
      if i > Low(AData) then
      begin
        sep := TRectangle.Create(HistoryListScrollBox.Content);
        sep.Parent := HistoryListScrollBox.Content;
        sep.Align  := TAlignLayout.Top;
        sep.Height := 1;
        sep.Margins.Rect := TRectF.Create(16, 0, 16, 0);
        sep.Stroke.Kind := TBrushKind.None;
        sep.Fill.Kind   := TBrushKind.Solid;
        sep.Fill.Color  := $FFE0E0E0;
        sep.HitTest     := False;
      end;
    end;
  finally
    HistoryListScrollBox.EndUpdate;
  end;
end;

/// <summary>
/// 정렬된 학습 기록을 바탕으로 현재 연속 학습일수를 계산합니다.
/// </summary>
/// <param name="Logs">날짜순으로 정렬된 전체 로그 데이터</param>
/// <returns>연속 학습일 수</returns>
function TLogForm.CalculateStreak(const Logs: TArray<TLogEntry>): Integer;
var
  Today, Prev: TDateTime;
  cnt, i: Integer;
begin
  Result := 0;
  if Length(Logs) = 0 then Exit;

  Today := Date; // 오늘 날짜
  // 마지막 로그가 어제 또는 오늘인지 확인
  if DaysBetween(Logs[High(Logs)].LogDate, Today) > 1 then Exit;

  Prev  := Today + 1;
  cnt := 0;
  for i := High(Logs) downto Low(Logs) do
  begin
    if Trunc(Prev) - Trunc(Logs[i].LogDate) = 1 then
    begin
      Inc(cnt);
      Prev := Logs[i].LogDate;
    end
    else if Trunc(Logs[i].LogDate) = Trunc(Prev) then
      Continue // 같은 날짜의 로그는 건너뜀
    else if (i < High(Logs)) then // 첫 루프가 아닐 때만 중단
      Break;
  end;

  // 마지막 로그가 오늘 날짜이면 1일 추가
  if (Length(Logs) > 0) and (Trunc(Logs[High(Logs)].LogDate) = Today) and (cnt = 0) then
    Result := 1
  else
    Result := cnt;
end;

/// <summary>
/// 최근 학습 기록(FLogs)을 기반으로 정답률(막대) 및 학습 시간(곡선) 차트를 그립니다.
/// 애니메이션 효과를 포함하여 동적으로 차트를 렌더링합니다.
/// </summary>
procedure TLogForm.RenderManualChart;
const
  LABEL_AREA_H = 14;
  SIDE_MARGIN  = 17;
  BAR_WIDTH    = 17;
var
  ChartCanvas: TLayout;
  i, Count: Integer;
  W, H, chartH, cellW, barW, maxBarH: Single;
  maxTimeMin: Integer;
  entry: TLogEntry;
  barRect: TRectangle;
  lblDate: TLabel;
  animH, animY, animP: TFloatAnimation;
  rawPts: TArray<TPointF>;
  pd: TPathData;
  path: TPath;

  function CalcMaxTime: Integer;
  var j: Integer;
  begin
    Result := 1; // 0으로 나누는 것을 방지하기 위해 최소 1로 설정
    for j := 0 to High(FLogs) do
      Result := Max(Result, FLogs[j].Hours * 60 + FLogs[j].Minutes);
  end;

begin
  Count := Length(FLogs);
  if Count = 0 then Exit;

  // 1. 이전 차트 캔버스 제거
  if ChartBackRect.TagObject is TLayout then
  begin
    TLayout(ChartBackRect.TagObject).Free;
    ChartBackRect.TagObject := nil;
  end;

  // 2. 새 차트 캔버스 생성 및 설정
  ChartCanvas := TLayout.Create(ChartBackRect);
  ChartCanvas.Parent := ChartBackRect;
  ChartBackRect.TagObject := ChartCanvas; // 나중에 참조/해제하기 위해 저장
  ChartCanvas.Align := TAlignLayout.Client;
  ChartCanvas.Margins.Rect := TRectF.Create(SIDE_MARGIN, ChartLegendLayout.Height, SIDE_MARGIN, 0);
  ChartCanvas.ClipChildren := True;
  ChartLegendLayout.BringToFront;

  // 3. 차트 영역 치수 계산
  W        := ChartCanvas.Width;
  H        := ChartCanvas.Height;
  chartH   := H - LABEL_AREA_H;
  cellW    := W / Count;
  barW     := BAR_WIDTH;
  maxBarH  := chartH * 0.8;
  maxTimeMin := CalcMaxTime;

  // 4. 막대(정답률) 및 날짜 라벨 생성
  for i := 0 to Count - 1 do
  begin
    entry := FLogs[i];

    // 막대(Rectangle) 생성 및 애니메이션
    barRect := TRectangle.Create(ChartCanvas);
    barRect.Parent := ChartCanvas;
    barRect.HitTest := False;
    barRect.Stroke.Thickness := 0;
    barRect.Fill.Color := $FFC1D6D2;
    barRect.Width := barW;
    barRect.Position.X := cellW * i + (cellW - barW) / 2;
    barRect.Position.Y := chartH;
    barRect.Height     := 0;

    animH := TFloatAnimation.Create(barRect);
    animH.Parent         := barRect;
    animH.PropertyName   := 'Height';
    animH.StartValue     := 0;
    animH.StopValue      := (entry.CorrectCount / entry.TotalCount) * maxBarH;
    animH.Duration       := 0.5;
    animH.Delay          := i * 0.1;
    animH.Interpolation  := TInterpolationType.Cubic;
    animH.Start;

    animY := TFloatAnimation.Create(barRect);
    animY.Parent         := barRect;
    animY.PropertyName   := 'Position.Y';
    animY.StartValue     := chartH;
    animY.StopValue      := chartH - animH.StopValue;
    animY.Duration       := animH.Duration;
    animY.Delay          := animH.Delay;
    animY.Interpolation  := TInterpolationType.Cubic;
    animY.Start;

    // 날짜 라벨(TLabel) 생성
    lblDate := TLabel.Create(ChartCanvas);
    lblDate.Parent := ChartCanvas;
    lblDate.TextSettings.Font.Family := 'Noto Sans KR';
    lblDate.TextSettings.Font.Size   := 6;
    lblDate.TextSettings.HorzAlign   := TTextAlign.Center;
    lblDate.Text := FormatDateTime('MM/dd', entry.LogDate);
    lblDate.SetBounds(Round(cellW * i), Round(chartH + 1), Round(cellW), LABEL_AREA_H - 2);
  end;

  // 5. 곡선(학습시간) 포인트 계산
  SetLength(rawPts, Count);
  for i := 0 to Count - 1 do
  begin
    entry := FLogs[i];
    rawPts[i].X := cellW * i + cellW / 2;
    rawPts[i].Y := chartH - ((entry.Hours * 60 + entry.Minutes) / maxTimeMin) * maxBarH;
  end;

  // 6. Cubic Bezier 보간으로 부드러운 곡선 데이터 생성
  pd := TPathData.Create;
  try
    if Count > 0 then
    begin
      pd.MoveTo(rawPts[0]);
      for i := 0 to Count - 2 do
      begin
        var midX := (rawPts[i].X + rawPts[i+1].X) * 0.5;
        var c1   := PointF(midX, rawPts[i].Y);
        var c2   := PointF(midX, rawPts[i+1].Y);
        pd.CurveTo(c1, c2, rawPts[i+1]);
      end;
    end;
  except
    pd.Free;
    raise;
  end;

  // 7. 곡선(TPath) 생성 및 애니메이션
  path := TPath.Create(ChartCanvas);
  path.Parent   := ChartCanvas;
  path.Data     := pd;
  path.Stroke.Kind      := TBrushKind.Solid;
  path.Stroke.Thickness := 2;
  path.Stroke.Color     := $FF88B7A7;
  path.Fill.Kind        := TBrushKind.None;
  path.Opacity          := 0;

  animP := TFloatAnimation.Create(path);
  animP.Parent        := path;
  animP.PropertyName  := 'Opacity';
  animP.StartValue    := 0;
  animP.StopValue     := 1;
  animP.Duration      := 1.2;
  animP.Interpolation := TInterpolationType.Cubic;
  animP.Start;
end;

end.
