object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 439
  ClientWidth = 616
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 616
    Height = 15
    Align = alTop
    Caption = 'Label1'
    ExplicitWidth = 34
  end
  object re: TRichEdit
    Left = 0
    Top = 56
    Width = 616
    Height = 328
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Segoe MDL2 Assets'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 15
    Width = 616
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = Panel1Click
    object Label2: TLabel
      Left = 1
      Top = 1
      Width = 43
      Height = 39
      Align = alLeft
      Caption = 'test'
      Color = clAqua
      ParentColor = False
      Layout = tlCenter
      StyleElements = []
      ExplicitLeft = 28
      ExplicitHeight = 37
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 384
    Width = 616
    Height = 55
    Align = alBottom
    Caption = 'Panel2'
    TabOrder = 2
    object lblSSize: TLabel
      AlignWithMargins = True
      Left = 172
      Top = 4
      Width = 39
      Height = 47
      Align = alLeft
      Caption = 'lblSSize'
      Layout = tlCenter
      ExplicitHeight = 15
    end
    object rgSSize: TRadioGroup
      Left = 1
      Top = 1
      Width = 168
      Height = 53
      Align = alLeft
      Caption = 'rgSSize'
      Columns = 4
      Items.Strings = (
        '8'
        '10'
        '12'
        '14')
      TabOrder = 0
      OnClick = rgSSizeClick
    end
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 112
    Top = 192
    Data = (
      (
        'Component = Form3'
        'Status = stsDefault')
      (
        'Component = re'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = rgSSize'
        'Status = stsDefault'))
  end
end
