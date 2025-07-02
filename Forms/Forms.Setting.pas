unit Forms.Setting;

interface

uses
  // 시스템 기본 유닛
  System.SysUtils, System.Types, System.UITypes, System.Classes,

  // FMX 기본 UI 유닛
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation,

  // Skia 그래픽 유닛
  System.Skia, FMX.Skia, FMX.StdCtrls;

type
  TCountChangedEvent = procedure(Sender: TObject; NewCount: Integer) of object;

  TSettingForm = class(TForm)
    // 배경 및 로고
    SettingBackRect: TRectangle;
    LogoSectionLayout: TLayout;
    LogoSvg: TSkSvg;
    LogoLabel: TLabel;

    // 타이틀 및 닫기 버튼
    TitleLayout: TLayout;
    TitleLabel: TLabel;
    ExitButtonSvg: TSkSvg;

    // 문항 수 선택 영역
    CountSelectorSectionLayout: TLayout;
    DecreaseButtonLayout: TLayout;
    DecreaseIconSvg: TSkSvg;
    CountValueSectionLayout: TLayout;
    CountValueBackRect: TRectangle;
    CountValueLabel: TLabel;
    IncreaseButtonLayout: TLayout;
    IncreaseIconSvg: TSkSvg;

    // 폼 전체를 감싸는 루트 레이아웃
    MainLayout: TLayout;

    // 이벤트 핸들러
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DecreaseButtonLayoutClick(Sender: TObject);
    procedure IncreaseButtonLayoutClick(Sender: TObject);
    procedure ExitButtonSvgClick(Sender: TObject);
  private
    FQuizCount: Integer;
    FOnCountChanged: TCountChangedEvent;
    FOnClose: TNotifyEvent;
    procedure SetQuizCount(const Value: Integer);
    procedure SetupResponsiveLayout; // << [추가] 반응형 레이아웃 설정 프로시저
  public
    property OnCountChanged: TCountChangedEvent read FOnCountChanged write FOnCountChanged;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property QuizCount: Integer read FQuizCount write SetQuizCount;
  end;

var
  SettingForm: TSettingForm;

implementation

{$R *.fmx}

/// <summary>
/// 폼 생성 시 컨트롤 초기화 및 반응형 레이아웃을 설정합니다.
/// </summary>
procedure TSettingForm.FormCreate(Sender: TObject);
begin
  // 초기 기본값 설정
  FQuizCount := 20;
  CountValueLabel.Text := FQuizCount.ToString;

  // 클릭 상호작용 설정
  DecreaseButtonLayout.HitTest := True;
  IncreaseButtonLayout.HitTest := True;
  DecreaseIconSvg.HitTest      := False;
  IncreaseIconSvg.HitTest      := False;
  ExitButtonSvg.HitTest        := True;

  // 이벤트 핸들러 연결
  DecreaseButtonLayout.OnClick := DecreaseButtonLayoutClick;
  IncreaseButtonLayout.OnClick := IncreaseButtonLayoutClick;
  ExitButtonSvg.OnClick        := ExitButtonSvgClick;

  // << [수정] 반응형 레이아웃 설정 함수 호출
  SetupResponsiveLayout;
end;

/// <summary>
/// 폼이 표시될 때 메인 폼의 위치에 맞게 좌표를 조정합니다 (윈도우 전용).
/// </summary>
procedure TSettingForm.FormShow(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  if Assigned(Application.MainForm) then
  begin
    Position := TFormPosition.Designed;
    SetBounds(Application.MainForm.Left,
              Application.MainForm.Top,
              Width, Height);
  end;
  {$ENDIF}
end;


/// <summary>
/// << [추가] 다양한 화면 크기에 대응하기 위해 컨트롤의 정렬과 여백을 코드로 설정합니다.
/// TScaledLayout 대신 TAlignLayout과 Margins를 사용하여 유연한 UI를 구성합니다.
/// </summary>
procedure TSettingForm.SetupResponsiveLayout;
begin
  // 1. 루트 레이아웃이 폼 전체를 채우도록 설정
  MainLayout.Align := TAlignLayout.Client;

  // 2. 타이틀 바 (상단에 고정)
  TitleLayout.Align := TAlignLayout.Top;
  TitleLayout.Height := 50; // 타이틀 바 높이 고정
  TitleLayout.Margins.Top := 10;
  TitleLayout.Margins.Left := 10;
  TitleLayout.Margins.Right := 10;

  // 타이틀 바 내부 요소 정렬
  TitleLabel.Align := TAlignLayout.Client;
  ExitButtonSvg.Align := TAlignLayout.Right;
  ExitButtonSvg.Width := 30; // 닫기 버튼 너비 고정
  ExitButtonSvg.Margins.Right := 10;

  // 3. 로고 영역 (타이틀 바 아래에 위치)
  LogoSectionLayout.Align := TAlignLayout.Top;
  LogoSectionLayout.Height := 150; // 로고 영역 높이 고정
  LogoSectionLayout.Margins.Top := 20;

  // 로고 이미지와 라벨 중앙 정렬
  LogoSvg.Align := TAlignLayout.Center;
  LogoLabel.Align := TAlignLayout.Center;

  // 4. 문항 수 선택 영역 (화면 중앙을 차지하도록 설정)
  CountSelectorSectionLayout.Align := TAlignLayout.Client;
  CountSelectorSectionLayout.Margins.Top := 20;
  CountSelectorSectionLayout.Margins.Bottom := 20;
  CountSelectorSectionLayout.Margins.Left := 20;
  CountSelectorSectionLayout.Margins.Right := 20;

  // 문항 수 선택 영역 내부 요소들 (좌/우 버튼, 중앙 값)
  // [감소] - [값] - [증가] 형태의 3단 레이아웃
  DecreaseButtonLayout.Align := TAlignLayout.Left;
  DecreaseButtonLayout.Width := 80; // 감소 버튼 너비 고정

  IncreaseButtonLayout.Align := TAlignLayout.Right;
  IncreaseButtonLayout.Width := 80; // 증가 버튼 너비 고정

  CountValueSectionLayout.Align := TAlignLayout.Client; // 남는 공간을 모두 차지

  // 숫자 값 라벨은 중앙에 정렬
  CountValueLabel.Align := TAlignLayout.Center;
end;


/// <summary>
/// '감소' 버튼 클릭 시 퀴즈 문항 수를 1 감소시킵니다.
/// </summary>
procedure TSettingForm.DecreaseButtonLayoutClick(Sender: TObject);
begin
  QuizCount := FQuizCount - 1;
end;

/// <summary>
/// '증가' 버튼 클릭 시 퀴즈 문항 수를 1 증가시킵니다.
/// </summary>
procedure TSettingForm.IncreaseButtonLayoutClick(Sender: TObject);
begin
  QuizCount := FQuizCount + 1;
end;

/// <summary>
/// '닫기' 버튼 클릭 시 플랫폼에 따라 다르게 동작합니다.
/// </summary>
procedure TSettingForm.ExitButtonSvgClick(Sender: TObject);
begin
  {$IFDEF ANDROID}
  if Assigned(FOnClose) then
    FOnClose(Self);
  {$ELSE}
  ModalResult := mrCancel;
  {$ENDIF}
end;

/// <summary>
/// 퀴즈 문항 수를 설정하고, 변경 시 UI 갱신 및 이벤트를 발생시킵니다.
/// </summary>
procedure TSettingForm.SetQuizCount(const Value: Integer);
begin
  if (Value < 5) or (Value > 50) then
    Exit;
  if FQuizCount = Value then
    Exit;

  FQuizCount := Value;
  CountValueLabel.Text := FQuizCount.ToString;

  if Assigned(FOnCountChanged) then
    FOnCountChanged(Self, FQuizCount);
end;

end.
