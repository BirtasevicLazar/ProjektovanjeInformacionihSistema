object BoxMain: TBoxMain
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'eKonobar'
  ClientHeight = 561
  ClientWidth = 984
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object PaintBox1: TPaintBox
    Left = 0
    Top = 0
    Width = 984
    Height = 561
    Align = alClient
    OnPaint = PaintBox1Paint
    ExplicitLeft = 176
    ExplicitTop = 120
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object Menu_Main: TPanel
    AlignWithMargins = True
    Left = 120
    Top = 100
    Width = 744
    Height = 361
    Margins.Left = 120
    Margins.Top = 100
    Margins.Right = 120
    Margins.Bottom = 100
    Align = alClient
    BevelKind = bkFlat
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    ShowCaption = False
    TabOrder = 0
    object Label1: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 45
      Width = 734
      Height = 45
      Margins.Top = 45
      Align = alTop
      Alignment = taCenter
      Caption = 'Dobrodosli!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 167
    end
    object Button1: TButton
      AlignWithMargins = True
      Left = 180
      Top = 103
      Width = 380
      Height = 82
      Margins.Left = 180
      Margins.Top = 10
      Margins.Right = 180
      Margins.Bottom = 10
      Align = alTop
      Caption = 'Pristup meniju za narucivanje'
      CommandLinkHint = 
        'Dobrodosli! Ako ste kupac, kliknite ovde da zapocnete narucivanj' +
        'e onoga sto zelite!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Style = bsCommandLink
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      AlignWithMargins = True
      Left = 180
      Top = 205
      Width = 380
      Height = 82
      Margins.Left = 180
      Margins.Top = 10
      Margins.Right = 180
      Margins.Bottom = 10
      Align = alTop
      Caption = 'Pristup listi porudzbina konobara'
      CommandLinkHint = 
        'Ako ste konobar, kliknite na ovo dugme da biste videlisve porudz' +
        'bine'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Style = bsCommandLink
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object Menu_Password: TPanel
    AlignWithMargins = True
    Left = 120
    Top = 100
    Width = 744
    Height = 361
    Margins.Left = 120
    Margins.Top = 100
    Margins.Right = 120
    Margins.Bottom = 100
    Align = alClient
    BevelKind = bkFlat
    BevelOuter = bvNone
    ParentBackground = False
    ParentColor = True
    ShowCaption = False
    TabOrder = 1
    Visible = False
    object Label2: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 45
      Width = 734
      Height = 45
      Margins.Top = 45
      Align = alTop
      Alignment = taCenter
      Caption = 'Unesi sifru'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 149
    end
    object Button3: TButton
      AlignWithMargins = True
      Left = 180
      Top = 152
      Width = 380
      Height = 50
      Margins.Left = 180
      Margins.Top = 10
      Margins.Right = 180
      Margins.Bottom = 10
      Align = alTop
      Caption = 'Zavrsi'
      CommandLinkHint = 'Potvrdi sifru'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Style = bsCommandLink
      TabOrder = 0
      OnClick = Button3Click
    end
    object Button4: TButton
      AlignWithMargins = True
      Left = 180
      Top = 222
      Width = 380
      Height = 50
      Margins.Left = 180
      Margins.Top = 10
      Margins.Right = 180
      Margins.Bottom = 10
      Align = alTop
      Caption = 'Otkazi'
      CommandLinkHint = 'Vrati se na glavni meni'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Style = bsCommandLink
      TabOrder = 1
      OnClick = Button4Click
    end
    object Edit1: TEdit
      AlignWithMargins = True
      Left = 200
      Top = 103
      Width = 340
      Height = 29
      Margins.Left = 200
      Margins.Top = 10
      Margins.Right = 200
      Margins.Bottom = 10
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 2
      TextHint = 'Ovde ukucaj sifru'
    end
  end
end
