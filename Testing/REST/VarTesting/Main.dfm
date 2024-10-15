object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object Label1: TLabel
    Left = 40
    Top = 40
    Width = 37
    Height = 15
    Caption = 'Testing'
  end
  object Label2: TLabel
    Left = 120
    Top = 40
    Width = 34
    Height = 15
    Caption = 'Label2'
  end
  object Button1: TButton
    Left = 40
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object re: TRichEdit
    Left = 0
    Top = 160
    Width = 624
    Height = 281
    Align = alBottom
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Lines.Strings = (
      're')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
  end
end
