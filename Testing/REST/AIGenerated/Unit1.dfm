object Form14: TForm14
  Left = 0
  Top = 0
  Caption = 'Form14'
  ClientHeight = 555
  ClientWidth = 787
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 17
  object Splitter1: TSplitter
    Left = 153
    Top = 0
    Height = 555
    ExplicitLeft = 152
    ExplicitTop = 152
    ExplicitHeight = 100
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 153
    Height = 555
    Align = alLeft
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object Label1js: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 58
      Width = 145
      Height = 17
      Align = alTop
      Caption = 'JavaScript:'
      WordWrap = True
      ExplicitWidth = 61
    end
    object Label1: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 35
      Width = 145
      Height = 17
      Align = alTop
      Caption = 'Label1'
      WordWrap = True
      ExplicitWidth = 38
    end
    object Button1: TButton
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 145
      Height = 25
      Align = alTop
      Caption = 'Run JavaScript'
      TabOrder = 0
      OnClick = Button1Click
    end
    object re: TRichEdit
      Left = 1
      Top = 78
      Width = 151
      Height = 476
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      Lines.Strings = (
        'function test(a) {'
        '  return a;'
        '};'
        'test(12345);')
      ParentFont = False
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 156
    Top = 0
    Width = 631
    Height = 555
    Align = alClient
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 1
    object Label2: TLabel
      Left = 1
      Top = 383
      Width = 629
      Height = 17
      Align = alBottom
      Caption = 'Request / Result'
      ExplicitWidth = 95
    end
    object Splitter2: TSplitter
      Left = 1
      Top = 380
      Width = 629
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 26
      ExplicitWidth = 357
    end
    object Label4: TLabel
      Left = 1
      Top = 26
      Width = 629
      Height = 17
      Align = alTop
      Caption = 'JSON'
      ExplicitWidth = 32
    end
    object Button2: TButton
      Left = 1
      Top = 1
      Width = 629
      Height = 25
      Align = alTop
      Caption = 'Run REST JSON'
      TabOrder = 0
      OnClick = Button2Click
    end
    object reREST: TRichEdit
      Left = 1
      Top = 400
      Width = 629
      Height = 154
      Align = alBottom
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object reJSON: TRichEdit
      Left = 1
      Top = 43
      Width = 629
      Height = 337
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
end
