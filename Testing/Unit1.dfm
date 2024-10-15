object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 555
  ClientWidth = 796
  Color = clBtnFace
  CustomTitleBar.SystemHeight = False
  CustomTitleBar.ShowCaption = False
  CustomTitleBar.ShowIcon = False
  CustomTitleBar.SystemColors = False
  CustomTitleBar.SystemButtons = False
  CustomTitleBar.BackgroundColor = clWhite
  CustomTitleBar.ForegroundColor = 65793
  CustomTitleBar.InactiveBackgroundColor = clWhite
  CustomTitleBar.InactiveForegroundColor = 10066329
  CustomTitleBar.ButtonForegroundColor = 65793
  CustomTitleBar.ButtonBackgroundColor = clWhite
  CustomTitleBar.ButtonHoverForegroundColor = 65793
  CustomTitleBar.ButtonHoverBackgroundColor = 16053492
  CustomTitleBar.ButtonPressedForegroundColor = 65793
  CustomTitleBar.ButtonPressedBackgroundColor = 15395562
  CustomTitleBar.ButtonInactiveForegroundColor = 10066329
  CustomTitleBar.ButtonInactiveBackgroundColor = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -24
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 32
  object BitBtn1: TBitBtn
    Left = 0
    Top = 517
    Width = 796
    Height = 38
    Align = alBottom
    Kind = bkClose
    NumGlyphs = 2
    TabOrder = 0
    ExplicitTop = 516
    ExplicitWidth = 792
  end
  object re: TRichEdit
    Left = 0
    Top = 66
    Width = 796
    Height = 451
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
    ExplicitWidth = 792
    ExplicitHeight = 450
  end
  object Button1: TButton
    Left = 0
    Top = 0
    Width = 796
    Height = 25
    Align = alTop
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
    ExplicitWidth = 792
  end
  object Panel1: TPanel
    Left = 0
    Top = 25
    Width = 796
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    ParentBackground = False
    TabOrder = 3
    ExplicitWidth = 792
    object ComboBox1: TComboBox
      Left = 570
      Top = 1
      Width = 225
      Height = 40
      Align = alRight
      TabOrder = 0
      Text = 'ComboBox1'
      OnChange = ComboBox1Change
      Items.Strings = (
        'clBlack'
        'clMaroon'
        'clGreen'
        'clOlive'
        'clNavy'
        'clPurple'
        'clTeal'
        'clGray'
        'clSilver'
        'clRed'
        'clLime'
        'clYellow'
        'clBlue'
        'clFuchsia'
        'clAqua'
        'clWhite'
        'clMoneyGreen'
        'clSkyBlue'
        'clCream'
        'clMedGray'
        'clActiveBorder'
        'clActiveCaption'
        'clAppWorkSpace'
        'clBackground'
        'clBtnFace'
        'clBtnHighlight'
        'clBtnShadow'
        'clBtnText'
        'clCaptionText'
        'clDefault'
        'clGradientActiveCaption'
        'clGradientInactiveCaption'
        'clGrayText'
        'clHighlight'
        'clHighlightText'
        'clHotLight'
        'clInactiveBorder'
        'clInactiveCaption'
        'clInactiveCaptionText'
        'clInfoBk'
        'clInfoText'
        'clMenu'
        'clMenuBar'
        'clMenuHighlight'
        'clMenuText'
        'clNone'
        'clScrollBar'
        'cl3DDkShadow'
        'cl3DLight'
        'clWindow'
        'clWindowFrame'
        'clWindowText')
      ExplicitLeft = 566
    end
  end
  object rgInner: TRadioGroup
    Left = 208
    Top = 72
    Width = 561
    Height = 81
    Caption = 'Inner'
    Columns = 4
    Items.Strings = (
      'None'
      'Lowered'
      'Raised'
      'Space')
    TabOrder = 4
    OnClick = rgInnerClick
  end
  object GridPanel1: TGridPanel
    Left = 32
    Top = 192
    Width = 169
    Height = 81
    Caption = 'GridPanel1'
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = Panel2
        Row = 0
      end>
    RowCollection = <
      item
        Value = 50.000000000000000000
      end
      item
        Value = 50.000000000000000000
      end>
    TabOrder = 5
    object Panel2: TKeyClickPanel
      Left = 1
      Top = 1
      Width = 167
      Height = 41
      Align = alTop
      Alignment = taLeftJustify
      Caption = ' Panel2'
      TabOrder = 0
      TabStop = True
      ShowFocus = True
      ExplicitLeft = 0
    end
  end
  object rgKind: TRadioGroup
    Left = 216
    Top = 176
    Width = 553
    Height = 105
    Caption = 'Kind'
    Columns = 4
    Items.Strings = (
      'None'
      'Tile'
      'Soft'
      'Flat')
    TabOrder = 6
    OnClick = rgKindClick
  end
  object rgOuter: TRadioGroup
    Left = 216
    Top = 312
    Width = 553
    Height = 105
    Caption = 'rgOuter'
    Columns = 4
    Items.Strings = (
      'None'
      'Lowered'
      'Raised'
      'Space')
    TabOrder = 7
    OnClick = rgOuterClick
  end
  object cb3D: TCheckBox
    Left = 216
    Top = 456
    Width = 161
    Height = 33
    Caption = 'Ctl3D'
    Checked = True
    State = cbChecked
    TabOrder = 8
    OnClick = cb3DClick
  end
end
