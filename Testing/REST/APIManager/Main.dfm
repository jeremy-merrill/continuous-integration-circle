object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 17
  object btnTest: TButton
    Left = 0
    Top = 0
    Width = 624
    Height = 25
    Align = alTop
    Caption = 'Test'
    TabOrder = 0
    OnClick = btnTestClick
  end
  object re: TRichEdit
    Left = 0
    Top = 25
    Width = 624
    Height = 247
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object br2: TEdgeBrowser
    Left = 0
    Top = 272
    Width = 624
    Height = 169
    Align = alBottom
    TabOrder = 2
    AllowSingleSignOnUsingOSPrimaryAccount = False
    TargetCompatibleBrowserVersion = '117.0.2045.28'
    UserDataFolder = '%LOCALAPPDATA%\bds.exe.WebView2'
  end
  object OAuth: TOAuth2Authenticator
    Left = 384
    Top = 160
  end
end
