unit Forms.BaseForm;

interface

uses
  // 시스템 기본 유닛
  System.SysUtils, System.Classes, System.UITypes,

  // FMX 기본 UI 유닛
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Layouts, FMX.Ani,
  FMX.Dialogs, FMX.Platform, FMX.VirtualKeyboard, FMX.DialogService;

type
  /// <summary>
  /// 모든 폼의 기반이 되는 클래스.
  /// 공통 기능 (페이드 인/아웃, 뒤로가기 버튼 처리 등)을 제공합니다.
  /// </summary>
  TBaseForm = class(TForm)
  private
    FService           : IFMXVirtualKeyboardService; // 가상 키보드 서비스 인터페이스
    FMainLayout        : TControl;  // 애니메이션 효과를 적용할 메인 레이아웃
    FOnFadeInFinished  : TProc;     // 페이드 인 완료 후 실행될 콜백
    FOnFadeOutFinished : TProc;     // 페이드 아웃 완료 후 실행될 콜백

    procedure FormKeyUpHandler(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
    procedure DoFadeIn(const AAfterProc: TProc = nil);
    procedure DoFadeOut(const AAfterProc: TProc = nil);
    procedure FadeInComplete(Sender: TObject);
    procedure FadeOutComplete(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;

    /// <summary>
    /// 폼을 표시하고 기본 페이드 인 효과를 적용합니다.
    /// </summary>
    procedure ShowWithFade; overload;

    /// <summary>
    /// 기본 페이드 아웃 효과를 적용한 후 폼을 숨깁니다.
    /// </summary>
    procedure HideWithFade; overload;

    /// <summary>
    /// 폼을 표시하고 페이드 인 효과 후 지정된 콜백 프로시저를 실행합니다.
    /// </summary>
    /// <param name="AAfterFadeProc">애니메이션 완료 후 실행할 프로시저</param>
    procedure ShowWithFade(const AAfterFadeProc: TProc); overload;

    /// <summary>
    /// 페이드 아웃 효과 후 폼을 숨기고 지정된 콜백 프로시저를 실행합니다.
    /// </summary>
    /// <param name="AAfterFadeProc">애니메이션 완료 후 실행할 프로시저</param>
    procedure HideWithFade(const AAfterFadeProc: TProc); overload;
  end;

implementation

uses
  Forms.Exit;

/// <summary>
/// 생성자: 가상 키보드 서비스, 뒤로가기 키 핸들러, 메인 레이아웃을 초기화합니다.
/// </summary>
constructor TBaseForm.Create(AOwner: TComponent);
begin
  inherited;
  // 가상 키보드 서비스 초기화 (모바일 플랫폼용)
  TPlatformServices.Current.SupportsPlatformService(
    IFMXVirtualKeyboardService, FService);

  // 하드웨어 뒤로가기 키(Android) 및 ESC 키(Windows) 대응
  Self.OnKeyUp := FormKeyUpHandler;

  // 애니메이션을 적용할 최상위 레이아웃을 찾아서 할당
  FMainLayout := Self.FindComponent('MainLayout') as TControl;
end;

/// <summary>
/// 폼의 KeyUp 이벤트를 처리하여 하드웨어 뒤로가기/ESC 키에 반응합니다.
/// </summary>
procedure TBaseForm.FormKeyUpHandler(Sender: TObject;
  var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
begin
  // 뒤로가기 키(vkHardwareBack) 또는 ESC 키(vkEscape)가 눌렸을 때
  if (Key = vkHardwareBack) or (Key = vkEscape) then
  begin
    Key := 0; // 키 입력을 처리했음을 시스템에 알림

    // 가상 키보드가 활성화된 상태이면, 키보드만 닫고 종료 확인창은 띄우지 않음
    if Assigned(FService) and
        (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then
      Exit;

    // --- 플랫폼별 종료 확인창 처리 ---
    {$IFDEF ANDROID}
    // [안드로이드 전용] TDialogService를 사용한 비동기 네이티브 대화상자
    TDialogService.MessageDialog(
      '애플리케이션을 종료하시겠습니까?',      // 메시지
      TMsgDlgType.mtConfirmation,            // 타입 (확인)
      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],    // 버튼 종류 (예/아니오)
      TMsgDlgBtn.mbNo,                       // 기본 선택 버튼
      0,
      procedure(const AResult: TModalResult) // 사용자가 버튼 클릭 시 실행될 콜백
      begin
        if AResult = mrYes then
          Application.Terminate; // '예'를 선택했을 때만 앱 종료
      end
    );
    {$ELSE}
    // [Windows 및 기타 플랫폼용] 기존의 TExitForm을 모달로 표시
    var
      dlg: TExitForm;
    begin
      dlg := TExitForm.Create(Application);
      try
        // dlg.Position은 TExitForm의 OnShow 이벤트에서 처리되므로 여기선 호출 불필요
        if dlg.ShowModal = mrOK then
          Application.Terminate; // '종료' 선택 시 애플리케이션 종료
      finally
        dlg.Free;
      end;
    end;
    {$ENDIF}
  end;
end;

/// <summary>
/// 폼의 메인 레이아웃에 페이드 인 애니메이션을 적용합니다.
/// </summary>
/// <param name="AAfterProc">애니메이션 완료 후 실행할 콜백 프로시저</param>
procedure TBaseForm.DoFadeIn(const AAfterProc: TProc);
var
  anim: TFloatAnimation;
begin
  if not Assigned(FMainLayout) then Exit;

  FMainLayout.Opacity := 0; // 시작 전 투명하게 설정
  FOnFadeInFinished := AAfterProc;

  anim := TFloatAnimation.Create(FMainLayout);
  anim.Parent := FMainLayout;
  anim.PropertyName := 'Opacity';
  anim.StartValue := 0;
  anim.StopValue := 1;
  anim.Duration := 0.3;
  anim.OnFinish := FadeInComplete;
  anim.Start;
end;

/// <summary>
/// 폼의 메인 레이아웃에 페이드 아웃 애니메이션을 적용합니다.
/// </summary>
/// <param name="AAfterProc">애니메이션 완료 후 실행할 콜백 프로시저</param>
procedure TBaseForm.DoFadeOut(const AAfterProc: TProc);
var
  anim: TFloatAnimation;
begin
  if not Assigned(FMainLayout) then Exit;

  FOnFadeOutFinished := AAfterProc;

  anim := TFloatAnimation.Create(FMainLayout);
  anim.Parent := FMainLayout;
  anim.PropertyName := 'Opacity';
  anim.StartValue := FMainLayout.Opacity; // 현재 투명도에서 시작
  anim.StopValue := 0;
  anim.Duration := 0.3;
  anim.OnFinish := FadeOutComplete;
  anim.Start;
end;

/// <summary>
/// 페이드 인 애니메이션 완료 후 콜백을 실행하고 애니메이션 객체를 해제합니다.
/// </summary>
procedure TBaseForm.FadeInComplete(Sender: TObject);
begin
  if Sender is TFloatAnimation then
    TFloatAnimation(Sender).Free;

  if Assigned(FOnFadeInFinished) then
    FOnFadeInFinished();
end;

/// <summary>
/// 페이드 아웃 애니메이션 완료 후 폼을 숨기고 콜백을 실행하며 애니메이션 객체를 해제합니다.
/// </summary>
procedure TBaseForm.FadeOutComplete(Sender: TObject);
begin
  if Sender is TFloatAnimation then
    TFloatAnimation(Sender).Free;

  Hide; // 폼 숨기기

  if Assigned(FOnFadeOutFinished) then
    FOnFadeOutFinished();
end;

/// <summary>
/// 폼을 표시하고 기본 페이드 인 효과를 적용합니다.
/// </summary>
procedure TBaseForm.ShowWithFade;
begin
  inherited Show;
  DoFadeIn(nil);
end;

/// <summary>
/// 폼을 표시하고 페이드 인 효과 후 지정된 콜백 프로시저를 실행합니다.
/// </summary>
procedure TBaseForm.ShowWithFade(const AAfterFadeProc: TProc);
begin
  inherited Show;
  DoFadeIn(AAfterFadeProc);
end;

/// <summary>
/// 기본 페이드 아웃 효과를 적용한 후 폼을 숨깁니다.
/// </summary>
procedure TBaseForm.HideWithFade;
begin
  DoFadeOut(nil);
end;

/// <summary>
/// 페이드 아웃 효과 후 폼을 숨기고 지정된 콜백 프로시저를 실행합니다.
/// </summary>
procedure TBaseForm.HideWithFade(const AAfterFadeProc: TProc);
begin
  DoFadeOut(AAfterFadeProc);
end;

end.
