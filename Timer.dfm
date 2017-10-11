object frmTimer: TfrmTimer
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSizeToolWin
  ClientHeight = 366
  ClientWidth = 399
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pgcTimer: TRzPageControl
    Left = 0
    Top = 17
    Width = 399
    Height = 349
    Hint = ''
    ActivePage = tsDigital
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    ExplicitTop = 0
    ExplicitHeight = 366
    FixedDimension = 19
    object tsDigital: TRzTabSheet
      Caption = 'tsDigital'
      ExplicitHeight = 343
      object pnlTimerDigital: TPanel
        Left = 0
        Top = 0
        Width = 395
        Height = 326
        Align = alClient
        Caption = '00:00:00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = True
        ParentFont = False
        TabOrder = 0
        OnMouseDown = pnlTimerDigitalMouseDown
        ExplicitHeight = 343
      end
    end
    object tsAnalog: TRzTabSheet
      Caption = 'tsAnalog'
      ExplicitHeight = 343
      object Clock: TJvClock
        Left = 0
        Top = 0
        Width = 395
        Height = 326
        DateFormat = 'dd/MM/yyyy'
        ShowMode = scAnalog
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -78
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentColor = True
        ParentFont = False
        OnGetTime = ClockGetTime
        OnMouseDown = ClockMouseDown
        ExplicitHeight = 343
      end
    end
  end
  object pbProgess: TProgressBar
    Left = 0
    Top = 0
    Width = 399
    Height = 17
    Align = alTop
    Smooth = True
    Step = 1
    TabOrder = 1
  end
  object fcTimer: TRzFrameController
    Left = 409
    Top = 36
  end
  object tmrTimer: TTimer
    Enabled = False
    OnTimer = tmrTimerTimer
    Left = 25
    Top = 36
  end
  object GradientCaption: TJvGradientCaption
    Captions = <
      item
      end>
    GradientInactive = True
    StartColor = clPurple
    EndColor = clPurple
    Left = 329
    Top = 268
  end
  object fsTimer: TJvFormStorage
    AppStorage = frmTimerMain.AppIniFileStorage
    AppStoragePath = '%FORM_NAME%\'
    Options = [fpSize, fpLocation]
    StoredValues = <>
    Left = 339
    Top = 28
  end
end
