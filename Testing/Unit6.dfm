object Form6: TForm6
  Left = 0
  Top = 0
  Caption = 'Form6'
  ClientHeight = 517
  ClientWidth = 1122
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object re: TRichEdit
    Left = 0
    Top = 0
    Width = 660
    Height = 482
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 482
    Width = 1122
    Height = 35
    Align = alBottom
    Caption = 'Panel1'
    ParentShowHint = False
    ShowCaption = False
    ShowHint = False
    TabOrder = 1
    object Button1: TButton
      AlignWithMargins = True
      Left = 908
      Top = 4
      Width = 129
      Height = 27
      Align = alRight
      Caption = 'Generate Code'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      AlignWithMargins = True
      Left = 1043
      Top = 4
      Width = 75
      Height = 27
      Align = alRight
      Caption = 'Close'
      ModalResult = 2
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      AlignWithMargins = True
      Left = 764
      Top = 4
      Width = 138
      Height = 27
      Align = alRight
      Caption = 'Generate Object'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object gpMain: TGridPanel
    Left = 660
    Top = 0
    Width = 462
    Height = 482
    Align = alRight
    BevelOuter = bvNone
    Caption = 'gpMain'
    Color = clWhite
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 170.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = lblPrefix
        Row = 1
      end
      item
        Column = 1
        Control = edtPrefix
        Row = 1
      end
      item
        Column = 0
        Control = lblSuffix
        Row = 2
      end
      item
        Column = 1
        Control = edtSuffix
        Row = 2
      end
      item
        Column = 0
        ColumnSpan = 2
        Control = cbIncludeOwners
        Row = 3
      end
      item
        Column = 0
        Control = lblOwnerName
        Row = 4
      end
      item
        Column = 1
        Control = cboOwnerName
        Row = 4
      end
      item
        Column = 0
        ColumnSpan = 2
        Control = cbTopLevelOwner
        Row = 5
      end
      item
        Column = 0
        Control = lblTopOwnerClass
        Row = 6
      end
      item
        Column = 1
        Control = edtTopOwnerClass
        Row = 6
      end
      item
        Column = 0
        ColumnSpan = 2
        Control = cboUnit
        Row = 0
      end>
    ParentBackground = False
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 31.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 31.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 31.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 31.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 31.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 31.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 31.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    ShowCaption = False
    TabOrder = 2
    object lblPrefix: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 34
      Width = 164
      Height = 25
      Align = alClient
      AutoSize = False
      Caption = 'Class Name Prefix:'
      Layout = tlCenter
      ExplicitLeft = 200
      ExplicitTop = 65
      ExplicitWidth = 48
    end
    object edtPrefix: TEdit
      AlignWithMargins = True
      Left = 173
      Top = 34
      Width = 286
      Height = 25
      Align = alClient
      AutoSize = False
      TabOrder = 0
      Text = 'My'
    end
    object lblSuffix: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 65
      Width = 164
      Height = 25
      Align = alClient
      AutoSize = False
      Caption = 'Class Name Suffix:'
      Layout = tlCenter
      ExplicitLeft = 200
      ExplicitTop = 96
      ExplicitWidth = 48
    end
    object edtSuffix: TEdit
      AlignWithMargins = True
      Left = 173
      Top = 65
      Width = 286
      Height = 25
      Align = alClient
      AutoSize = False
      TabOrder = 1
    end
    object cbIncludeOwners: TCheckBox
      AlignWithMargins = True
      Left = 3
      Top = 96
      Width = 206
      Height = 25
      Margins.Right = 253
      Align = alClient
      Alignment = taLeftJustify
      Caption = 'Include Owner Properties:'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object lblOwnerName: TLabel
      AlignWithMargins = True
      Left = 20
      Top = 127
      Width = 147
      Height = 25
      Margins.Left = 20
      Align = alClient
      AutoSize = False
      Caption = 'Owner Property Name *: '
      Layout = tlCenter
      ExplicitLeft = 3
      ExplicitTop = 158
      ExplicitWidth = 245
    end
    object cboOwnerName: TComboBox
      AlignWithMargins = True
      Left = 173
      Top = 127
      Width = 286
      Height = 23
      Align = alClient
      DropDownCount = 12
      TabOrder = 3
    end
    object cbTopLevelOwner: TCheckBox
      AlignWithMargins = True
      Left = 3
      Top = 158
      Width = 206
      Height = 25
      Margins.Right = 253
      Align = alClient
      Alignment = taLeftJustify
      Caption = 'Top Level Class has Owner:'
      TabOrder = 4
    end
    object lblTopOwnerClass: TLabel
      AlignWithMargins = True
      Left = 20
      Top = 189
      Width = 147
      Height = 25
      Margins.Left = 20
      Align = alClient
      AutoSize = False
      Caption = 'Top Level Owner Class *:'
      Layout = tlCenter
      ExplicitLeft = 3
      ExplicitTop = 220
      ExplicitWidth = 227
    end
    object edtTopOwnerClass: TEdit
      AlignWithMargins = True
      Left = 173
      Top = 189
      Width = 286
      Height = 25
      Align = alClient
      AutoSize = False
      TabOrder = 5
      Text = 'TObject'
    end
    object cboUnit: TComboBox
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 456
      Height = 23
      Align = alClient
      DropDownCount = 12
      ItemIndex = 0
      Sorted = True
      TabOrder = 6
      Text = 'Unit7'
      Items.Strings = (
        'Unit7')
    end
  end
end
