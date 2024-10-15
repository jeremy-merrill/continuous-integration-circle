object Form11: TForm11
  Left = 0
  Top = 0
  Caption = 'Form11'
  ClientHeight = 761
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Courier New'
  Font.Style = []
  Position = poDesigned
  OnCreate = FormCreate
  TextHeight = 14
  object RadioGroup1: TRadioGroup
    Left = 0
    Top = 0
    Width = 624
    Height = 57
    Align = alTop
    Caption = 'Font Size'
    Columns = 4
    ItemIndex = 0
    Items.Strings = (
      '8'
      '10'
      '12'
      '14')
    TabOrder = 0
    OnClick = RadioGroup1Click
  end
  object re: TRichEdit
    Left = 0
    Top = 57
    Width = 624
    Height = 704
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    ExplicitLeft = 128
    ExplicitTop = 176
    ExplicitWidth = 185
    ExplicitHeight = 89
  end
end
