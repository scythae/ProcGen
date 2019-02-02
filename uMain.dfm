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
    object lGenerationInterval: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 148
      Width = 206
      Height = 13
      Align = alTop
      Caption = 'GenerationFrequency'
      ExplicitTop = 124
      ExplicitWidth = 104
    end
    object lMinimumNeighbours: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 212
      Width = 206
      Height = 13
      Align = alTop
      Caption = 'MinimumNeighbours'
      ExplicitTop = 188
      ExplicitWidth = 94
    end
    object lMaximumNeighbours: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 276
      Width = 206
      Height = 13
      Align = alTop
      Caption = 'MaximumNeighbours'
      ExplicitTop = 252
      ExplicitWidth = 98
    end
    object lMaximumCells: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 340
      Width = 206
      Height = 13
      Align = alTop
      Caption = 'MaximumCells'
      ExplicitTop = 316
      ExplicitWidth = 66
    end
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
    object tbGenerationInterval: TTrackBar
      Left = 1
      Top = 164
      Width = 212
      Height = 45
      Align = alTop
      Max = 2000
      Min = 1
      Frequency = 100
      Position = 1
      PositionToolTip = ptBottom
      TabOrder = 1
      TickMarks = tmBoth
      OnChange = OnSettingsChange
      ExplicitTop = 140
    end
    object tbMinNeighbours: TTrackBar
      Left = 1
      Top = 228
      Width = 212
      Height = 45
      Align = alTop
      Position = 2
      PositionToolTip = ptBottom
      TabOrder = 2
      TickMarks = tmBoth
      OnChange = OnSettingsChange
      ExplicitTop = 204
    end
    object tbMaxNeighbours: TTrackBar
      Left = 1
      Top = 292
      Width = 212
      Height = 45
      Align = alTop
      Position = 6
      PositionToolTip = ptBottom
      TabOrder = 3
      TickMarks = tmBoth
      OnChange = OnSettingsChange
      ExplicitTop = 268
    end
    object tbMaximumCells: TTrackBar
      Left = 1
      Top = 356
      Width = 212
      Height = 45
      Align = alTop
      Max = 10000
      Frequency = 500
      Position = 200
      PositionToolTip = ptBottom
      TabOrder = 4
      TickMarks = tmBoth
      OnChange = OnSettingsChange
      ExplicitTop = 332
    end
    object rgGenerationType: TRadioGroup
      Left = 1
      Top = 26
      Width = 212
      Height = 119
      Align = alTop
      Caption = 'Generation Type'
      ItemIndex = 3
      Items.Strings = (
        'Cellular Automaton'
        'Random Walk'
        'Binary Space Partioning'
        'BSP + Random Walk')
      TabOrder = 5
      OnClick = rgGenerationTypeClick
    end
  end
  object tmrGeneration: TTimer
    Enabled = False
    OnTimer = tmrGenerationTimer
    Left = 296
    Top = 136
  end
end
