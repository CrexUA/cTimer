unit Timer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, JvComponentBase, JvFormPlacement, Vcl.ExtCtrls,
  RzCommon, JvExExtCtrls, JvExtComponent, JvClock, RzTabs, ShellApi,
  JvGradientCaption, Vcl.ComCtrls;

type
  TfrmTimer = class(TForm)
    pgcTimer: TRzPageControl;
    tsDigital: TRzTabSheet;
    tsAnalog: TRzTabSheet;
    pnlTimerDigital: TPanel;
    fcTimer: TRzFrameController;
    tmrTimer: TTimer;
    Clock: TJvClock;
    GradientCaption: TJvGradientCaption;
    fsTimer: TJvFormStorage;
    pbProgess: TProgressBar;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure pnlTimerDigitalMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure tmrTimerTimer(Sender: TObject);
    procedure ClockMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ClockGetTime(Sender: TObject; var ATime: TDateTime);
  private
    { Private declarations }
    procedure MouseDrag;
  {protected
     procedure CreateParams (var Params: TCreateParams); override;}
  public
    { Public declarations }
    tHour, tMinute, tSecond : Integer;
  end;

var
  frmTimer: TfrmTimer;

const  SC_DragMove = $F012;

implementation

{$R *.dfm}

uses
  TimerMain;

const FormWidth : Integer = 500;

procedure TfrmTimer.MouseDrag;
begin
  ReleaseCapture;
  perform(WM_SysCommand, SC_DragMove, 0);
end;

procedure TfrmTimer.pnlTimerDigitalMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MouseDrag;
end;

procedure TfrmTimer.tmrTimerTimer(Sender: TObject);
var
  CurrentTime : TDateTime;
  formattedDateTime, formattedTimer : String;
begin
  case frmTimerMain.rgMode.ItemIndex of
    0 :
    begin
      //tpTimerAnalog.Time := Now;
      DateTimeToString(formattedDateTime, 'hh:nn:ss', Now);
      pnlTimerDigital.Caption := formattedDateTime;
      frmTimerMain.txtTimer.Caption := formattedDateTime;
    end;
    1 :
    begin
      case frmTimerMain.rgCountDirection.ItemIndex of
        0 :
        begin
          Inc(tSecond);
          if tSecond = 60 then
          begin
            inc(tMinute);
            tSecond := 0;
          end;

          if tMinute = 60 then
          begin
            Inc(tHour);
            tMinute := 0;
          end;

          formattedTimer := FormatFloat('00', tHour) + ':' +
            FormatFloat('00', tMinute) + ':' +
            FormatFloat('00', tSecond);

          pnlTimerDigital.Caption := formattedTimer;
          frmTimerMain.txtTimer.Caption := formattedTimer;
        end;

        1 :
        begin
          if not((tSecond = 0) and (tMinute = 0) and (tHour = 0)) then
          begin
            if tSecond = 0 then
            begin
              Dec(tMinute);
              tSecond := 59;
            end;
            Dec(tSecond);

            if tMinute = 0 then
            begin
              Dec(tHour);
              tMinute := 59;
            end;

            formattedTimer := FormatFloat('00', tHour) + ':' +
              FormatFloat('00', tMinute) + ':' +
              FormatFloat('00', tSecond);

            pnlTimerDigital.Caption := formattedTimer;
            frmTimerMain.txtTimer.Caption := formattedTimer;
          end;
        end;
      end;

      pbProgess.StepIt;
    end;
  end;
end;

procedure TfrmTimer.ClockGetTime(Sender: TObject; var ATime: TDateTime);
var
  formattedDateTime : String;
begin
  DateTimeToString(formattedDateTime, 'hh:nn:ss', Now);
  frmTimerMain.txtTime.Caption := formattedDateTime;
end;

procedure TfrmTimer.ClockMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MouseDrag;
end;

procedure TfrmTimer.FormCreate(Sender: TObject);
begin
  SetWindowLong(Handle, GWL_STYLE, GetWindowLong(Handle, GWL_STYLE) and not WS_CAPTION) ;
  ClientHeight := Height;

  frmTimer.Width := FormWidth;

  tHour := 0;
  tMinute := 0;
  tSecond := 0;

  pbProgess.Visible := frmTimerMain.chkProgressBar.Checked;
end;

procedure TfrmTimer.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  MouseDrag;
end;


procedure TfrmTimer.FormResize(Sender: TObject);
begin
  pnlTimerDigital.Font.Size := Trunc(72/FormWidth * frmTimer.Width);
end;

end.
