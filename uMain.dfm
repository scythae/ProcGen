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
      Top = 124
      Width = 206
      Height = 13
      Align = alTop
      Caption = 'GenerationFrequency'
      ExplicitTop = 108
      ExplicitWidth = 104
    end
    object lMinimumNeighbours: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 188
      Width = 206
      Height = 13
      Align = alTop
      Caption = 'MinimumNeighbours'
      ExplicitTop = 172
      ExplicitWidth = 94
    end
    object lMaximumNeighbours: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 252
      Width = 206
      Height = 13
      Align = alTop
      Caption = 'MaximumNeighbours'
      ExplicitTop = 236
      ExplicitWidth = 98
    end
    object lMaximumCells: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 316
      Width = 206
      Height = 13
      Align = alTop
      Caption = 'MaximumCells'
      ExplicitTop = 300
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
      Top = 140
      Width = 212
      Height = 45
      Align = alTop
      Max = 2000
      Min = 1
      Frequency = 100
      Position = 500
      PositionToolTip = ptBottom
      TabOrder = 1
      TickMarks = tmBoth
      OnChange = OnSettingsChange
      ExplicitTop = 124
    end
    object tbMinNeighbours: TTrackBar
      Left = 1
      Top = 204
      Width = 212
      Height = 45
      Align = alTop
      Position = 2
      PositionToolTip = ptBottom
      TabOrder = 2
      TickMarks = tmBoth
      OnChange = OnSettingsChange
      ExplicitTop = 188
    end
    object tbMaxNeighbours: TTrackBar
      Left = 1
      Top = 268
      Width = 212
      Height = 45
      Align = alTop
      Position = 6
      PositionToolTip = ptBottom
      TabOrder = 3
      TickMarks = tmBoth
      OnChange = OnSettingsChange
      ExplicitTop = 252
    end
    object tbMaximumCells: TTrackBar
      Left = 1
      Top = 332
      Width = 212
      Height = 45
      Align = alTop
      Max = 10000
      Frequency = 500
      Position = 10000
      PositionToolTip = ptBottom
      TabOrder = 4
      TickMarks = tmBoth
      OnChange = OnSettingsChange
      ExplicitTop = 316
    end
    object rgGenerationType: TRadioGroup
      Left = 1
      Top = 26
      Width = 212
      Height = 95
      Align = alTop
      Caption = 'Generation Type'
      ItemIndex = 2
      Items.Strings = (
        'Cellular Automaton'
        'Random Walk'
        'Binary Space Partioning')
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
