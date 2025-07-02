unit Frames.WordData;

interface

uses
  // 시스템 기본 유닛
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  // FMX 기본 UI 유닛
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation;

type
  /// <summary>
  /// '단어장' 폼의 리스트에 표시될 개별 단어 정보를 담는 프레임입니다.
  /// </summary>
  TWordDataFrame = class(TFrame)
    // 배경 및 메인 레이아웃
    CardBackRect: TRectangle;
    MainLayout: TLayout;

    // 단어 및 품사 섹션
    WordHeaderLayout: TLayout;
    WordLabel: TLabel;
    PartOfSpeechContentLayout: TLayout;
    PartOfSpeechLabel: TLabel;

    // 한글 뜻 섹션
    WordContentLayout: TLayout;
    MeaningSectionLayout: TLayout;
    MeaningContentLayout: TLayout;
    MeaningLabel: TLabel;

    // 영문 예문 섹션
    EngExampleSectionLayout: TLayout;
    EngExampleContentLayout: TLayout;
    EngExampleLabel: TLabel;

    // 한글 예문 섹션
    KrExampleSectionLayout: TLayout;
    KrExampleContentLayout: TLayout;
    KrExampleLabel: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
