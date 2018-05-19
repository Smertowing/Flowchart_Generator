object Flowchart_Manager: TFlowchart_Manager
  Left = 0
  Top = 0
  Caption = 'Flowchart_Manager'
  ClientHeight = 390
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
    Height = 390
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
    object mmoMainMemo: TMemo
      Left = 1
      Top = 237
      Width = 359
      Height = 152
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object btnTemp: TButton
      Left = 280
      Top = 206
      Width = 75
      Height = 25
      Caption = 'Test'
      TabOrder = 2
      OnClick = btnTempClick
    end
  end
  object scrMain: TScrollBox
    Left = 361
    Top = 0
    Width = 597
    Height = 390
    HorzScrollBar.ButtonSize = 10
    VertScrollBar.ButtonSize = 20
    VertScrollBar.ParentColor = False
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 1
    OnMouseWheelUp = scrMainMouseWheelUp
    object pbMain: TPaintBox
      Left = 5
      Top = 0
      Width = 0
      Height = 0
      OnPaint = pbMainPaint
    end
  end
  object MainMenu: TMainMenu
    Left = 280
    Top = 8
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Action = fileOpen
        Caption = 'Open'
      end
      object fileOpen1: TMenuItem
        Action = fileSave
        Caption = 'Save PNG'
      end
      object fileSaveAs1: TMenuItem
        Action = fileSaveAs
        Caption = 'Save As'
        Visible = False
      end
    end
  end
  object dlgOpenFile: TOpenDialog
    Left = 320
    Top = 8
  end
  object alMain: TActionList
    Left = 240
    Top = 8
    object fileOpen: TAction
      Category = 'File'
      Caption = 'fileOpen'
      ShortCut = 16463
      OnExecute = fileOpenExecute
    end
    object fileSave: TAction
      Category = 'File'
      Caption = 'fileSave'
      Enabled = False
      ShortCut = 16467
      OnExecute = fileSaveExecute
    end
    object fileSaveAs: TAction
      Category = 'File'
      Caption = 'fileSaveAs'
      ShortCut = 49235
    end
  end
  object dlgSaveFlowchart: TSaveDialog
    Left = 320
    Top = 56
  end
end
