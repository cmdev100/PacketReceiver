object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Packet Receiver'
  ClientHeight = 310
  ClientWidth = 527
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    527
    310)
  TextHeight = 15
  object lblPortTxt: TLabel
    Left = 8
    Top = 18
    Width = 25
    Height = 15
    Caption = 'Port:'
  end
  object lblMessagesTxt: TLabel
    Left = 8
    Top = 51
    Width = 54
    Height = 15
    Caption = 'Messages:'
  end
  object btnListen: TButton
    Left = 444
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Start listen'
    TabOrder = 3
    OnClick = btnListenClick
  end
  object edtPort: TEdit
    Left = 39
    Top = 15
    Width = 66
    Height = 23
    NumbersOnly = True
    TabOrder = 0
    Text = 'edtPort'
  end
  object btnClear: TButton
    Left = 454
    Top = 48
    Width = 65
    Height = 18
    Anchors = [akTop, akRight]
    Caption = 'Clear'
    TabOrder = 4
    OnClick = btnClearClick
  end
  object rbUDP: TRadioButton
    Left = 120
    Top = 8
    Width = 49
    Height = 17
    Caption = 'UDP'
    TabOrder = 1
    OnClick = ServerTypeClick
  end
  object rbTCP: TRadioButton
    Left = 120
    Top = 31
    Width = 49
    Height = 17
    Caption = 'TCP'
    TabOrder = 2
    OnClick = ServerTypeClick
  end
  object lvMessages: TListView
    Left = 8
    Top = 72
    Width = 511
    Height = 230
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Timestamp'
        MaxWidth = 120
        MinWidth = 120
        Width = 120
      end
      item
        Caption = 'Sender'
        MaxWidth = 120
        MinWidth = 120
        Width = 120
      end
      item
        AutoSize = True
        Caption = 'Message'
      end>
    GridLines = True
    TabOrder = 5
    ViewStyle = vsReport
  end
  object IdUDPServer: TIdUDPServer
    Bindings = <>
    DefaultPort = 0
    ReuseSocket = rsFalse
    OnUDPRead = IdUDPServerUDPRead
    Left = 32
    Top = 88
  end
  object IdTCPServer: TIdTCPServer
    Bindings = <>
    DefaultPort = 0
    OnExecute = IdTCPServerExecute
    Left = 32
    Top = 144
  end
end
