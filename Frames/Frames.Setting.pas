unit Frames.Setting;

interface

uses
  // RTL
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  // FMX
  FMX.Types, FMX.Controls, FMX.Controls.Presentation, FMX.Layouts, FMX.Forms,
  FMX.Objects, FMX.StdCtrls, FMX.Graphics, FMX.Dialogs,

  // Skia
  System.Skia, FMX.Skia,

  FMX.DialogService,  // ShowMessage 위해
  DM.AppData;

type
  TCountChangedEvent = procedure(Sender: TObject; NewCount: Integer) of object;

  TSettingFrame = class(TFrame)
    ExitButtonSvg: TSkSvg;
    SettingBackRect: TRectangle;
    LogoSectionLayout: TLayout;
    LogoSvg: TSkSvg;
    LogoLabel: TLabel;
    TitleLayout: TLayout;
    TitleLabel: TLabel;
    CountSelectorLayout: TLayout;
    CountValueSectionLayout: TLayout;
    CountValueBackRect: TRectangle;
    CountValueLabel: TLabel;
    DecreaseButtonLayout: TLayout;
    DecreaseIconSvg: TSkSvg;
    IncreaseButtonLayout: TLayout;
    IncreaseIconSvg: TSkSvg;
    SettingLayout: TLayout;
    MainLayout: TScaledLayout;
    CountSelectorSectionLayout: TLayout;
    ResetLayout: TLayout;
    ResetButtonRect: TRectangle;
    ResetButtonLabel: TLabel;
    LogoLayout: TLayout;
    procedure ExitButtonSvgClick(Sender: TObject);
    procedure IncreaseButtonLayoutClick(Sender: TObject);
    procedure DecreaseButtonLayoutClick(Sender: TObject);
    procedure ResetButtonRectClick(Sender: TObject);
  private
    { Private declarations }
    FQuizCount: Integer;
    FOnCountChanged: TCountChangedEvent;
    FOnClose: TNotifyEvent;

    procedure SetQuizCount(const Value: Integer);

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;

    /// 퀴즈 문항 수
    property QuizCount: Integer read FQuizCount write SetQuizCount;
    /// 값 변경 시 리스너
    property OnCountChanged: TCountChangedEvent read FOnCountChanged write FOnCountChanged;
    /// 닫기 시 리스너
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
  end;

implementation

{$R *.fmx}

constructor TSettingFrame.Create(AOwner: TComponent);
begin
  inherited;
  // 기본값 세팅
  FQuizCount := 20;
  CountValueLabel.Text := FQuizCount.ToString;

  // 클릭 영역 활성화 및 이벤트 연결
  DecreaseButtonLayout.HitTest := True;
  IncreaseButtonLayout.HitTest := True;
  DecreaseIconSvg.HitTest := False;
  IncreaseIconSvg.HitTest := False;
  ExitButtonSvg.HitTest := True;

  DecreaseButtonLayout.OnClick := DecreaseButtonLayoutClick;
  IncreaseButtonLayout.OnClick := IncreaseButtonLayoutClick;
  ExitButtonSvg.OnClick := ExitButtonSvgClick;
end;

procedure TSettingFrame.SetQuizCount(const Value: Integer);
begin
  if (Value < 5) or (Value > 50) then Exit;
  if FQuizCount = Value then Exit;
  FQuizCount := Value;
  CountValueLabel.Text := FQuizCount.ToString;
  if Assigned(FOnCountChanged) then
    FOnCountChanged(Self, FQuizCount);
end;

procedure TSettingFrame.DecreaseButtonLayoutClick(Sender: TObject);
begin
  QuizCount := FQuizCount - 1;
end;

procedure TSettingFrame.IncreaseButtonLayoutClick(Sender: TObject);
begin
  QuizCount := FQuizCount + 1;
end;

procedure TSettingFrame.ResetButtonRectClick(Sender: TObject);
begin
  // 1) 데이터 초기화
  AppDataModule.Connection.ExecSQL('DELETE FROM Log');
  AppDataModule.Connection.ExecSQL('DELETE FROM WrongWords');
  AppDataModule.Connection.ExecSQL('DELETE FROM DAILY_WORDS');

  // 2) 사용자에게 종료 알림 & 종료
  TDialogService.ShowMessage(
    '모든 학습 데이터가 초기화되었습니다.' + sLineBreak +
    '애플리케이션을 재시작 해주세요! 이제 앱을 종료합니다.',
    procedure(const AResult: TModalResult)
    begin
      Application.Terminate;
    end
  );
end;

procedure TSettingFrame.ExitButtonSvgClick(Sender: TObject);
begin
  if Assigned(FOnClose) then
    FOnClose(Self);
end;

end.
