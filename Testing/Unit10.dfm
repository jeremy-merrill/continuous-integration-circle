object Form10: TForm10
  Left = 0
  Top = 0
  Caption = 'Form10'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 25
  object Button1: TButton
    Left = 88
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object CheckBox1: TCheckBox
    Left = 312
    Top = 280
    Width = 145
    Height = 17
    Hint = 'Testing Hint Message|This is a test 1..2..3..'
    CustomHint = bHint
    Caption = 'CheckBox1'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 248
    Top = 352
    Width = 297
    Height = 33
    TabOrder = 2
    Text = 'Edit1'
  end
  object bHint: TBalloonHint
    Style = bhsStandard
    Delay = 50
    HideAfter = 5000
    Left = 112
    Top = 200
  end
  object ApplicationEvents1: TApplicationEvents
    Left = 216
    Top = 200
  end
end
