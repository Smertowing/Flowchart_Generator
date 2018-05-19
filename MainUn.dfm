object Flowchart_Manager: TFlowchart_Manager
  Left = 0
  Top = 0
  Caption = 'Flowchart_Manager'
  ClientHeight = 431
  ClientWidth = 958
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMemoTree: TPanel
    Left = 0
    Top = 0
    Width = 361
    Height = 431
    Align = alLeft
    TabOrder = 0
    object splMemoTree: TSplitter
      Left = 1
      Top = 235
      Width = 359
      Height = 2
      Cursor = crVSplit
      Align = alTop
    end
    object trMainTree: TTreeView
      Left = 1
      Top = 1
      Width = 359
      Height = 234
      Align = alTop
      Indent = 19
      TabOrder = 0
      Items.NodeData = {
        03010000001E0000000000000000000000FFFFFFFFFFFFFFFF00000000000000
        00000000000100}
    end
    object btnTemp: TButton
      Left = 280
      Top = 206
      Width = 75
      Height = 25
      Caption = 'Test'
      TabOrder = 1
      OnClick = btnTempClick
    end
    object reMainEdit: TRichEdit
      Left = 1
      Top = 237
      Width = 359
      Height = 193
      Align = alClient
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Lines.Strings = (
        '')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 2
      Zoom = 100
    end
  end
  object scrMain: TScrollBox
    Left = 361
    Top = 0
    Width = 597
    Height = 431
    HorzScrollBar.ButtonSize = 10
    VertScrollBar.ButtonSize = 20
    VertScrollBar.ParentColor = False
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 1
    OnMouseWheelDown = scrMainMouseWheelDown
    OnMouseWheelUp = scrMainMouseWheelUp
    object pbMain: TPaintBox
      Left = 5
      Top = 0
      Width = 0
      Height = 0
      OnMouseDown = pbMainMouseDown
      OnPaint = pbMainPaint
    end
    object mmoInput: TMemo
      Left = 496
      Top = 399
      Width = 98
      Height = 49
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Visible = False
    end
  end
  object MainMenu: TMainMenu
    Left = 256
    Top = 8
    object File1: TMenuItem
      Caption = 'File'
      object fileOpen1: TMenuItem
        Action = fileOpen
        Caption = 'Open'
      end
      object fileSavePNG1: TMenuItem
        Action = fileSavePNG
        Caption = 'Save PNG'
      end
      object fileSaveBMP1: TMenuItem
        Action = fileSaveBMP
        Caption = 'Save BMP'
      end
    end
  end
  object dlgOpenFile: TOpenDialog
    Left = 312
    Top = 8
  end
  object alMain: TActionList
    Left = 200
    Top = 8
    object fileOpen: TAction
      Category = 'File'
      Caption = 'fileOpen'
      ShortCut = 16463
      OnExecute = fileOpenExecute
    end
    object fileSavePNG: TAction
      Category = 'File'
      Caption = 'fileSave'
      Enabled = False
      ShortCut = 16467
      OnExecute = fileSavePNGExecute
    end
    object fileSaveBMP: TAction
      Category = 'File'
      Caption = 'fileSaveBMP'
      Enabled = False
      ShortCut = 49235
      OnExecute = fileSaveBMPExecute
    end
  end
  object dlgSaveFlowchart: TSaveDialog
    Left = 312
    Top = 56
  end
end
