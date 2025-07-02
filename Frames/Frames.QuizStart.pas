unit Frames.QuizStart;

interface

uses
  // 시스템 기본 유닛
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  // FMX 기본 UI 유닛
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation,

  // Skia 그래픽 유닛
  System.Skia, FMX.Skia,

  System.IOUtils;

type
  /// <summary>
  /// '퀴즈 시작' 버튼 클릭 시 발생하는 이벤트를 정의합니다.
  /// </summary>
  /// <param name="Sender">이벤트를 발생시킨 객체</param>
  /// <param name="Count">설정된 퀴즈 문항 수</param>
  TStartClickEvent = procedure(Sender: TObject; Count: Integer) of object;

  /// <summary>
  /// 퀴즈 시작 전 문제 수를 설정하고 시작 신호를 보내는 프레임입니다.
  /// </summary>
  TQuizStartFrame = class(TFrame)
    // 배경 및 레이아웃
    QuizStartBackgroundRect: TRectangle;
    MainLayout: TLayout;
    LogoSectionLayout: TLayout;
    CountSectionLayout: TLayout;
    StartButtonSectionLayout: TLayout;

    // 로고 섹션
    LogoCardBackRect: TRectangle;
    LogoIconSvg: TSkSvg;

    // 문항 수 선택 섹션
    CountSelectorSectionLayout: TLayout;
    DecreaseButtonLayout: TLayout;
    DecreaseIconSvg: TSkSvg;
    CountValueSectionLayout: TLayout;
    CountValueBackRect: TRectangle;
    CountValueLabel: TLabel;
    IncreaseButtonLayout: TLayout;
    IncreaseIconSvg: TSkSvg;

    // 시작 버튼 섹션
    StartButtonBackRect: TRectangle;
    StartButtonLabel: TLabel;
    procedure DecreaseButtonLayoutClick(Sender: TObject);
    procedure IncreaseButtonLayoutClick(Sender: TObject);
    procedure StartButtonBackRectClick(Sender: TObject);

  private
    FQuizCount: Integer;
    FOnStart: TStartClickEvent;

  public
    /// <summary>
    /// 프레임을 초기화하고 기본 퀴즈 문항 수를 설정합니다.
    /// </summary>
    /// <param name="ADefaultCount">초기값으로 설정할 퀴즈 문항 수</param>
    procedure Init(const ADefaultCount: Integer);

    /// <summary>
    /// '퀴즈 시작' 버튼 클릭 시 호출할 이벤트 핸들러입니다.
    /// </summary>
    property OnStart: TStartClickEvent read FOnStart write FOnStart;
  end;

implementation

{$R *.fmx}

/// <summary>
/// 프레임을 초기화하고 기본 퀴즈 문항 수를 설정합니다.
/// </summary>
/// <param name="ADefaultCount">초기값으로 설정할 퀴즈 문항 수</param>
procedure TQuizStartFrame.Init(const ADefaultCount: Integer);
begin
  FQuizCount := ADefaultCount;
  CountValueLabel.Text := FQuizCount.ToString;

  // 버튼 이벤트 핸들러 연결
  DecreaseButtonLayout.OnClick := DecreaseButtonLayoutClick;
  IncreaseButtonLayout.OnClick := IncreaseButtonLayoutClick;
  StartButtonBackRect.OnClick  := StartButtonBackRectClick;
end;

/// <summary>
/// '감소' 버튼 클릭 시 퀴즈 문항 수를 1 감소시킵니다.
/// </summary>
procedure TQuizStartFrame.DecreaseButtonLayoutClick(Sender: TObject);
begin
  if FQuizCount > 5 then // 최소 5개
  begin
    Dec(FQuizCount);
    CountValueLabel.Text := FQuizCount.ToString;
  end;
end;

/// <summary>
/// '증가' 버튼 클릭 시 퀴즈 문항 수를 1 증가시킵니다.
/// </summary>
procedure TQuizStartFrame.IncreaseButtonLayoutClick(Sender: TObject);
begin
  if FQuizCount < 50 then // 최대 50개
  begin
    Inc(FQuizCount);
    CountValueLabel.Text := FQuizCount.ToString;
  end;
end;

/// <summary>
/// '퀴즈 시작' 버튼 클릭 시 OnStart 이벤트를 발생시킵니다.
/// </summary>
procedure TQuizStartFrame.StartButtonBackRectClick(Sender: TObject);
begin
  try
    if Assigned(FOnStart) then
      FOnStart(Self, FQuizCount);
  except
    on E: Exception do
    begin
      // 에뮬레이터에서도 즉시 메시지
      ShowMessage('퀴즈 시작 중 예외 발생!' + sLineBreak +
                  E.ClassName + ': ' + E.Message);

      // 로그 파일에 남기기
      TFile.AppendAllText(
        TPath.Combine(TPath.GetDocumentsPath, 'StartCrash.txt'),
        FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) +
        ' - ' + E.ClassName + ': ' + E.Message + sLineBreak
      );
    end;
  end;
end;

end.
