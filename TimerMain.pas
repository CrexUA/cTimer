unit TimerMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.DateUtils,
  Vcl.ExtCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, RzDBGrid, MemDS, VirtualTable,
  System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, JvFormPlacement,
  JvComponentBase, JvAppStorage, JvAppIniStorage, ovccmbx, ovcclrcb, Vcl.Buttons,
  Vcl.Mask, JvExMask, JvToolEdit, Vcl.ExtDlgs, Vcl.DBCtrls;

type
  TfrmTimerMain = class(TForm)
    rgTimerType: TRadioGroup;
    rgMode: TRadioGroup;
    rgCountDirection: TRadioGroup;
    AppIniFileStorage: TJvAppIniFileStorage;
    fsMain: TJvFormStorage;
    ilMain: TImageList;
    btnStart: TSpeedButton;
    btnPause: TSpeedButton;
    btnStop: TSpeedButton;
    btnReset: TSpeedButton;
    aclMain: TActionList;
    actStart: TAction;
    actStop: TAction;
    actPause: TAction;
    actReset: TAction;
    vtMain: TVirtualTable;
    dsMain: TDataSource;
    grdTime: TRzDBGrid;
    vtMainID: TIntegerField;
    vtMainSpeach: TStringField;
    vtMainDuration: TTimeField;
    Label2: TLabel;
    chkDBBlock: TCheckBox;
    Label3: TLabel;
    dlgOpenFile: TOpenTextFileDialog;
    edtSpeach: TEdit;
    btnOpenFile: TSpeedButton;
    actOpenFile: TAction;
    btnSaveAs: TSpeedButton;
    actSaveAs: TAction;
    dlgSaveFile: TFileSaveDialog;
    grpDigColor: TGroupBox;
    Label1: TLabel;
    cbbTimerBackGround: TOvcColorComboBox;
    cbbTimerFont: TOvcColorComboBox;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    cbbAnalogColor: TOvcColorComboBox;
    cbbDotsColor: TOvcColorComboBox;
    nvSpeach: TDBNavigator;
    txtTimer: TStaticText;
    Label7: TLabel;
    txtTime: TStaticText;
    chkProgressBar: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure cbbTimerBackGroundChange(Sender: TObject);
    procedure rgTimerTypeClick(Sender: TObject);
    procedure rgModeClick(Sender: TObject);
    procedure actStartExecute(Sender: TObject);
    procedure actStopExecute(Sender: TObject);
    procedure actPauseExecute(Sender: TObject);
    procedure actResetExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chkDBBlockClick(Sender: TObject);
    procedure actOpenFileExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure cbbTimerFontChange(Sender: TObject);
    procedure cbbAnalogColorChange(Sender: TObject);
    procedure cbbDotsColorChange(Sender: TObject);
    procedure vtMainBeforeEdit(DataSet: TDataSet);
    procedure chkProgressBarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure vtMainAfterScroll(DataSet: TDataSet);
  private
    { Private declarations }
    TimerFontColor, TimerBackGroundColor, AnalogColor, DialColor : TColor;
    Started : Boolean;
  public
    { Public declarations }
  end;

var
  frmTimerMain: TfrmTimerMain;

implementation

{$R *.dfm}

uses Timer;

procedure TfrmTimerMain.actOpenFileExecute(Sender: TObject);
begin
  if dlgOpenFile.Execute() then
  begin
    try
      vtMain.ReadOnly := False;
      vtMain.Close;
      vtMain.LoadFromFile(dlgOpenFile.FileName);
      vtMain.Open;
    except
      ShowMessage('Помилка відкритя файла з промовами');
      Exit
    end;

    chkDBBlock.Checked := True;
    vtMain.ReadOnly := True;
    edtSpeach.Text := ExtractFileName(dlgOpenFile.FileName);
  end;
end;

procedure TfrmTimerMain.actPauseExecute(Sender: TObject);
begin
  frmTimer.tmrTimer.Enabled := not frmTimer.tmrTimer.Enabled;
end;

procedure TfrmTimerMain.actResetExecute(Sender: TObject);
begin
  frmTimer.tHour := 0;
  frmTimer.tMinute := 0;
  frmTimer.tSecond := 0;

  frmTimer.tmrTimer.Enabled := False;
  Started := False;

  frmTimer.pnlTimerDigital.Caption := '00:00:00';
  txtTimer.Caption := frmTimer.pnlTimerDigital.Caption;
end;

procedure TfrmTimerMain.actSaveAsExecute(Sender: TObject);
begin
  if dlgSaveFile.Execute() then
  begin
    try
        vtMain.SaveToFile(dlgSaveFile.FileName);
    except
      ShowMessage('Помилка збереження файла з промовами');
      Exit
    end;

    edtSpeach.Text := ExtractFileName(dlgSaveFile.FileName);
  end;
end;

procedure TfrmTimerMain.actStartExecute(Sender: TObject);
begin
  if Started then
    Exit;

  frmTimer.tHour := HourOf(vtMain.FieldByName('Duration').AsDateTime);
  frmTimer.tMinute := MinuteOf(vtMain.FieldByName('Duration').AsDateTime);
  frmTimer.tSecond := SecondOf(vtMain.FieldByName('Duration').AsDateTime);

  frmTimer.pbProgess.Min := 0;
  frmTimer.pbProgess.Max := frmTimer.tHour  * 60 * 60 + frmTimer.tMinute * 60 + frmTimer.tSecond;

  frmTimer.tmrTimer.Enabled := True;
  Started := True;
end;

procedure TfrmTimerMain.actStopExecute(Sender: TObject);
begin
  Started := False;
  frmTimer.tmrTimer.Enabled := False;
end;

procedure TfrmTimerMain.chkDBBlockClick(Sender: TObject);
begin
  vtMain.ReadOnly := chkDBBlock.Checked;
end;

procedure TfrmTimerMain.chkProgressBarClick(Sender: TObject);
begin
  frmTimer.pbProgess.Visible := chkProgressBar.Checked;
end;

procedure TfrmTimerMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if edtSpeach.Text <> '' then
    vtMain.SaveToFile(edtSpeach.Text)
      else
        vtMain.SaveToFile('Items.db');
end;

procedure TfrmTimerMain.FormCreate(Sender: TObject);
begin
  Started := False;
end;

procedure TfrmTimerMain.FormShow(Sender: TObject);
begin
  TimerFontColor := clWhite;
  TimerBackGroundColor := clBlack;
  AnalogColor := clBlack;

  try
    if edtSpeach.Text <> '' then
    begin
      if(FileExists(edtSpeach.Text)) then
        vtMain.LoadFromFile(edtSpeach.Text)
    end
      else
        if(FileExists('Items.db')) then
          vtMain.LoadFromFile('Items.db')
            else
            begin
              vtMain.SaveToFile('Items.db');
              vtMain.LoadFromFile('Items.db');
            end;
  except
    ShowMessage('Помилка завантаження файла з промовами');
  end;

  cbbTimerBackGroundChange(Sender);
  cbbTimerFontChange(Sender);
  cbbAnalogColorChange(Sender);
  cbbDotsColorChange(Sender);

  rgModeClick(Sender);
  rgTimerTypeClick(Sender);
  chkDBBlockClick(Sender);

  frmTimer.tsDigital.TabVisible := False;
  frmTimer.tsAnalog.TabVisible := False;
  frmTimer.Show;
end;

procedure TfrmTimerMain.cbbDotsColorChange(Sender: TObject);
begin
  DialColor := cbbDotsColor.SelectedColor;
  frmTimer.Clock.DotsColor := DialColor;
end;

procedure TfrmTimerMain.cbbAnalogColorChange(Sender: TObject);
begin
  AnalogColor := cbbAnalogColor.SelectedColor;
  frmTimer.Clock.HoursHandColor := AnalogColor;
  frmTimer.Clock.MinutesHandColor := AnalogColor;
  frmTimer.Clock.SecondsHandColor := AnalogColor;

end;

procedure TfrmTimerMain.cbbTimerFontChange(Sender: TObject);
begin
  TimerFontColor := cbbTimerFont.SelectedColor;
  frmTimer.pnlTimerDigital.Font.Color := TimerFontColor;
end;

procedure TfrmTimerMain.cbbTimerBackGroundChange(Sender: TObject);
begin
  TimerBackGroundColor := cbbTimerBackGround.SelectedColor;
  frmTimer.Color := TimerBackGroundColor;

  frmTimer.GradientCaption.Active := False;
  frmTimer.GradientCaption.StartColor := TimerFontColor;
  frmTimer.GradientCaption.EndColor := TimerFontColor;
  frmTimer.GradientCaption.Active := True;
end;

procedure TfrmTimerMain.rgModeClick(Sender: TObject);
begin
  actStart.Visible := (rgMode.ItemIndex = 1);
  actStop.Visible := (rgMode.ItemIndex = 1);
  actPause.Visible := (rgMode.ItemIndex = 1);
  actReset.Visible := (rgMode.ItemIndex = 1);

  case rgMode.ItemIndex of
    0 :
      begin
        frmTimer.pnlTimerDigital.Font.Color := TimerFontColor;
      end;
    1 :
      begin
        frmTimer.pnlTimerDigital.Font.Color := TimerFontColor;
      end;
  end;


end;

procedure TfrmTimerMain.rgTimerTypeClick(Sender: TObject);
begin
  frmTimer.pgcTimer.ActivePageIndex := rgTimerType.ItemIndex;
end;

procedure TfrmTimerMain.vtMainAfterScroll(DataSet: TDataSet);
var
  formattedTimer : String;
begin
  if Started then
    Exit;

  frmTimer.tHour := HourOf(vtMain.FieldByName('Duration').AsDateTime);
  frmTimer.tMinute := MinuteOf(vtMain.FieldByName('Duration').AsDateTime);
  frmTimer.tSecond := SecondOf(vtMain.FieldByName('Duration').AsDateTime);

  formattedTimer := FormatFloat('00', frmTimer.tHour) + ':' +
                    FormatFloat('00', frmTimer.tMinute) + ':' +
                    FormatFloat('00', frmTimer.tSecond);

  frmTimer.pnlTimerDigital.Caption := formattedTimer;
  txtTimer.Caption := formattedTimer;

end;

procedure TfrmTimerMain.vtMainBeforeEdit(DataSet: TDataSet);
begin
  if vtMain.ReadOnly then
    Exit
      else
        inherited;
end;

end.
