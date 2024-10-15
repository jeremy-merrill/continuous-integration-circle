object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 441
  ClientWidth = 1812
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
    Left = 602
    Top = 0
    Height = 441
    ExplicitLeft = 328
    ExplicitTop = 264
    ExplicitHeight = 100
  end
  object Splitter2: TSplitter
    Left = 1207
    Top = 0
    Height = 441
    ExplicitLeft = 632
    ExplicitTop = 304
    ExplicitHeight = 100
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 602
    Height = 441
    Align = alLeft
    Caption = 'Panel1'
    TabOrder = 0
    object reJSON: TRichEdit
      Left = 1
      Top = 105
      Width = 600
      Height = 335
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object gpMain: TGridPanel
      Left = 1
      Top = 1
      Width = 600
      Height = 104
      Align = alTop
      Caption = 'gpMain'
      ColumnCollection = <
        item
          Value = 30.000000000000000000
        end
        item
          Value = 70.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = btnLoadJSON
          Row = 0
        end
        item
          Column = 0
          Control = btnExecute
          Row = 1
        end
        item
          Column = 1
          Control = rg
          Row = 0
          RowSpan = 3
        end
        item
          Column = 0
          Control = btnStep
          Row = 2
        end>
      RowCollection = <
        item
          Value = 33.333333333333340000
        end
        item
          Value = 33.333333333333340000
        end
        item
          Value = 33.333333333333310000
        end>
      ShowCaption = False
      TabOrder = 1
      object btnLoadJSON: TButton
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 173
        Height = 28
        Align = alClient
        Caption = 'Load JSON'
        TabOrder = 0
        OnClick = btnLoadJSONClick
      end
      object btnExecute: TButton
        AlignWithMargins = True
        Left = 4
        Top = 38
        Width = 173
        Height = 28
        Align = alClient
        Caption = 'Execute'
        Enabled = False
        TabOrder = 1
        OnClick = btnExecuteClick
      end
      object rg: TRadioGroup
        Left = 180
        Top = 1
        Width = 419
        Height = 102
        Align = alClient
        Caption = ' Select JSON to Execute'
        Columns = 2
        TabOrder = 2
        OnClick = rgClick
      end
      object btnStep: TButton
        AlignWithMargins = True
        Left = 4
        Top = 72
        Width = 173
        Height = 28
        Align = alClient
        Caption = 'Step'
        Enabled = False
        TabOrder = 3
        OnClick = btnStepClick
      end
    end
  end
  object Panel2: TPanel
    Left = 605
    Top = 0
    Width = 602
    Height = 441
    Align = alLeft
    Caption = 'Panel2'
    TabOrder = 1
    object lblRequest: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 594
      Height = 17
      Align = alTop
      Caption = 'Request'
      ExplicitWidth = 47
    end
    object reRequest: TRichEdit
      Left = 1
      Top = 24
      Width = 600
      Height = 416
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      ExplicitTop = 27
    end
  end
  object Panel3: TPanel
    Left = 1210
    Top = 0
    Width = 602
    Height = 441
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 2
    object lblResponse: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 594
      Height = 17
      Align = alTop
      Caption = 'Response'
      ExplicitWidth = 57
    end
    object reResponse: TRichEdit
      Left = 1
      Top = 24
      Width = 600
      Height = 416
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object RESTClient: TRESTClient
    Params = <>
    SynchronizedEvents = False
    OnAuthEvent = RESTClientAuthEvent
    OnSendData = RESTClientSendData
    OnReceiveData = RESTClientReceiveData
    OnReceiveDataEx = RESTClientReceiveDataEx
    Left = 464
    Top = 32
  end
  object RESTRequest: TRESTRequest
    Client = RESTClient
    Params = <>
    Response = RESTResponse
    OnBeforeExecute = RESTRequestBeforeExecute
    SynchronizedEvents = False
    Left = 464
    Top = 88
  end
  object RESTResponse: TRESTResponse
    Left = 464
    Top = 144
  end
end
