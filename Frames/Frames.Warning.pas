unit Frames.Warning;

interface

uses
  // 시스템 기본 유닛
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  // FMX 기본 UI 유닛
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation;

type
  /// <summary>
  /// 특정 조건에서 사용자에게 경고 메시지를 표시하는 프레임입니다.
  /// (예: 오답 노트에 틀린 단어가 없을 경우)
  /// </summary>
  TWarningFrame = class(TFrame)
    // UI 컴포넌트
    WarningBackRect: TRectangle;
    WarningLabel: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
