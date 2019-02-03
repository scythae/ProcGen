object frMain: TfrMain
  Left = 0
  Top = 0
  Caption = 'ProcGen'
  ClientHeight = 598
  ClientWidth = 702
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object pSettings: TPanel
    Left = 488
    Top = 0
    Width = 214
    Height = 598
    Align = alRight
    TabOrder = 0
    object btnRestart: TButton
      Left = 1
      Top = 1
      Width = 212
      Height = 25
      Align = alTop
      Caption = 'Restart'
      TabOrder = 0
      OnClick = btnRestartClick
    end
    object rgGenerationType: TRadioGroup
      Left = 1
      Top = 26
      Width = 212
      Height = 132
      Align = alTop
      Caption = 'Generation Type'
      ItemIndex = 1
      Items.Strings = (
        'Cellular Automaton'
        'Random Walk'
        'Binary Space Partioning'
        'BSP + Random Walk'
        'Random Walk passage')
      TabOrder = 1
      OnClick = rgGenerationTypeClick
    end
    object pCASettings: TPanel
      Left = 1
      Top = 366
      Width = 212
      Height = 123
      Align = alTop
      TabOrder = 2
      ExplicitTop = 222
      object lMinimumNeighbours: TLabel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 204
        Height = 13
        Align = alTop
        Caption = 'MinimumNeighbours'
        ExplicitWidth = 94
      end
      object lMaximumNeighbours: TLabel
        AlignWithMargins = True
        Left = 4
        Top = 60
        Width = 204
        Height = 13
        Align = alTop
        Caption = 'MaximumNeighbours'
        ExplicitLeft = 12
        ExplicitTop = 65
      end
      object tbMinNeighbours: TTrackBar
        Left = 1
        Top = 20
        Width = 210
        Height = 37
        Align = alTop
        Position = 2
        PositionToolTip = ptBottom
        TabOrder = 0
        TickMarks = tmBoth
        OnChange = OnSettingsChange
      end
      object tbMaxNeighbours: TTrackBar
        Left = 1
        Top = 76
        Width = 210
        Height = 45
        Align = alTop
        Position = 6
        PositionToolTip = ptBottom
        TabOrder = 1
        TickMarks = tmBoth
        OnChange = OnSettingsChange
        ExplicitTop = 305
        ExplicitWidth = 212
      end
    end
    object pRWSettings: TPanel
      Left = 1
      Top = 293
      Width = 212
      Height = 73
      Align = alTop
      TabOrder = 3
      ExplicitTop = 222
      object lRWMaximumCells: TLabel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 204
        Height = 13
        Align = alTop
        Caption = 'MaximumCells'
        ExplicitWidth = 66
      end
      object tbMaximumCells: TTrackBar
        Left = 1
        Top = 20
        Width = 210
        Height = 37
        Align = alTop
        Max = 1000
        Frequency = 50
        Position = 200
        PositionToolTip = ptBottom
        TabOrder = 0
        TickMarks = tmBoth
        OnChange = OnSettingsChange
      end
    end
    object pGenerationMultiplier: TPanel
      Left = 1
      Top = 220
      Width = 212
      Height = 73
      Align = alTop
      TabOrder = 4
      ExplicitTop = 222
      object lGenerationMultiplier: TLabel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 204
        Height = 13
        Align = alTop
        Caption = 'Generation Multiplier'
        ExplicitWidth = 98
      end
      object tbGenerationMultiplier: TTrackBar
        Left = 1
        Top = 20
        Width = 210
        Height = 37
        Align = alTop
        Max = 100
        Min = 1
        Frequency = 5
        Position = 10
        PositionToolTip = ptBottom
        TabOrder = 0
        TickMarks = tmBoth
        OnChange = OnSettingsChange
        ExplicitTop = 23
      end
    end
    object pGenerationsInterval: TPanel
      Left = 1
      Top = 158
      Width = 212
      Height = 62
      Align = alTop
      TabOrder = 5
      ExplicitLeft = -7
      ExplicitTop = 138
      object lGenerationInterval: TLabel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 204
        Height = 13
        Align = alTop
        Caption = 'Interval between generations'
        ExplicitTop = 20
      end
      object tbGenerationInterval: TTrackBar
        Left = 1
        Top = 20
        Width = 210
        Height = 45
        Align = alTop
        Max = 1000
        Min = 1
        Frequency = 100
        Position = 1
        PositionToolTip = ptBottom
        TabOrder = 0
        TickMarks = tmBoth
        OnChange = OnSettingsChange
        ExplicitTop = 17
      end
    end
  end
  object tmrGeneration: TTimer
    Enabled = False
    OnTimer = tmrGenerationTimer
    Left = 296
    Top = 136
  end
end
