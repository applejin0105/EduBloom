unit Forms.Exit;

interface

uses
  // 시스템 기본 유닛
  System.SysUtils, System.Classes, System.UITypes,

  // FMX 기본 UI 유닛
  FMX.Forms, FMX.Types, FMX.Controls, FMX.Graphics, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,

  // Skia 그래픽 유닛
  System.Skia, FMX.Skia;

type
  TExitForm = class(TForm)
    // 메시지 영역
    ExitMessageLabel: TLabel;

    // 버튼 영역
    CancelButtonRect: TRectangle;
    ExitButtonRect: TRectangle;

    // 이벤트 핸들러
    procedure FormShow(Sender: TObject);
    procedure CancelButtonRectClick(Sender: TObject);
    procedure ExitButtonRectClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  ExitForm: TExitForm;

implementation

{$R *.fmx}

/// <summary>
/// 폼이 표시될 때 메인 폼의 위치에 맞게 좌표 조정 (윈도우 전용)
/// </summary>
procedure TExitForm.FormShow(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  // 폼 위치를 디자인 시점이 아닌, 실행 시 코드로 지정
  Position := TFormPosition.Designed;

  // 모달 폼을 메인 폼의 좌상단 좌표로 이동
  if Assigned(Application.MainForm) then
  begin
    SetBounds(
      Application.MainForm.Left,
      Application.MainForm.Top,
      Width,  // DFM에 정의된 폼 너비 사용
      Height  // DFM에 정의된 폼 높이 사용
    );
  end;
  {$ENDIF}
end;

/// <summary>
/// '아니오' 버튼(취소) 클릭 시 ModalResult를 mrCancel로 설정
/// </summary>
procedure TExitForm.CancelButtonRectClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

/// <summary>
/// '종료' 버튼(확인) 클릭 시 ModalResult를 mrOk로 설정하여 종료 처리
/// </summary>
procedure TExitForm.ExitButtonRectClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
