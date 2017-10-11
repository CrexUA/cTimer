program cTimer;

uses
  Vcl.Forms,
  TimerMain in 'TimerMain.pas' {frmTimerMain},
  Timer in 'Timer.pas' {frmTimer};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTimerMain, frmTimerMain);
  Application.CreateForm(TfrmTimer, frmTimer);
  Application.Run;
end.
