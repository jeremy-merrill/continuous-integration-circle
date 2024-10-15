object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 506
  ClientWidth = 889
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 20
  object eb: TEdgeBrowser
    Left = 0
    Top = 0
    Width = 889
    Height = 293
    Align = alClient
    TabOrder = 0
    AllowSingleSignOnUsingOSPrimaryAccount = False
    TargetCompatibleBrowserVersion = '117.0.2045.28'
    UserDataFolder = '%LOCALAPPDATA%\bds.exe.WebView2'
    OnExecuteScript = ebExecuteScript
    OnNavigationCompleted = ebNavigationCompleted
    OnWebMessageReceived = ebWebMessageReceived
    ExplicitTop = -2
  end
  object Panel1: TPanel
    Left = 0
    Top = 293
    Width = 889
    Height = 35
    Align = alBottom
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    object btnLoad: TButton
      AlignWithMargins = True
      Left = 810
      Top = 4
      Width = 75
      Height = 27
      Align = alRight
      Caption = 'Load'
      TabOrder = 0
      OnClick = btnLoadClick
    end
  end
  object re: TRichEdit
    Left = 0
    Top = 328
    Width = 889
    Height = 178
    Align = alBottom
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    Lines.Strings = (
      're')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object broker: TRPCBroker
    ShowCertDialog = False
    ClearParameters = True
    ClearResults = True
    Connected = False
    ListenerPort = 9026
    RemoteProcedure = '5031'
    RpcVersion = '0'
    Server = 'vac20devcrd802.crd.vaec.va.gov'
    KernelLogIn = True
    LogIn.AccessCode = 'jmerrill12'
    LogIn.VerifyCode = 'test1234#'
    LogIn.Mode = lmSSOi
    LogIn.PromptDivision = True
    UseSecureConnection = secureNone
    SSHHide = False
    Left = 24
    Top = 22
  end
end
