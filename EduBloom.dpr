program EduBloom;

uses
  System.StartUpCopy,
  FMX.Forms,
  Forms.Main in 'Forms\Forms.Main.pas' {MainForm},
  DM.AppData in 'Resources\DM.AppData.pas' {AppDataModule: TDataModule},
  Forms.Quiz in 'Forms\Forms.Quiz.pas' {QuizForm},
  Frames.QuizType1 in 'Frames\Frames.QuizType1.pas' {QuizType1Frame: TFrame},
  Frames.QuizResult in 'Frames\Frames.QuizResult.pas' {QuizResultFrame: TFrame},
  Frames.QuizType4 in 'Frames\Frames.QuizType4.pas' {QuizType4Frame: TFrame},
  Frames.QuizType3 in 'Frames\Frames.QuizType3.pas' {QuizType3Frame: TFrame},
  Frames.QuizType2 in 'Frames\Frames.QuizType2.pas' {QuizType2Frame: TFrame},
  Forms.Dictionary in 'Forms\Forms.Dictionary.pas' {DictionaryForm},
  Forms.Log in 'Forms\Forms.Log.pas' {LogForm},
  Frames.LogItem in 'Frames\Frames.LogItem.pas' {LogItemFrame: TFrame},
  Frames.WordData in 'Frames\Frames.WordData.pas' {WordDataFrame: TFrame},
  Frames.QuizStart in 'Frames\Frames.QuizStart.pas' {QuizStartFrame: TFrame},
  Forms.BaseForm in 'Forms\Forms.BaseForm.pas' {BaseForm},
  QuizTypes in 'Resources\QuizTypes.pas',
  Forms.Exit in 'Forms\Forms.Exit.pas' {ExitForm},
  AppPaths in 'Resources\AppPaths.pas',
  Frames.Warning in 'Frames\Frames.Warning.pas' {WarningFrame: TFrame},
  Frames.Setting in 'Frames\Frames.Setting.pas' {SettingFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.OnException := MainForm.HandleGlobalException;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TLogForm, LogForm);
  Application.CreateForm(TDictionaryForm, DictionaryForm);
  Application.CreateForm(TAppDataModule, AppDataModule);
  Application.CreateForm(TQuizForm, QuizForm);
  Application.CreateForm(TExitForm, ExitForm);
  Application.Run;
end.
