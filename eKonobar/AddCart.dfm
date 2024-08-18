object BoxAddCart: TBoxAddCart
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Dodaj u korpu'
  ClientHeight = 361
  ClientWidth = 584
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object Image1: TImage
    Left = 24
    Top = 32
    Width = 105
    Height = 105
    Center = True
    Proportional = True
  end
  object Label2: TLabel
    Left = 147
    Top = 48
    Width = 149
    Height = 32
    Caption = 'Naziv'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 302
    Top = 81
    Width = 63
    Height = 21
    Caption = '0.00 EUR'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 147
    Top = 81
    Width = 144
    Height = 21
    Caption = 'Cena:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI Semibold'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 24
    Top = 185
    Width = 102
    Height = 21
    Caption = 'Kolicina:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 147
    Top = 108
    Width = 366
    Height = 61
    AutoSize = False
    Caption = 'Opis'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 293
    Width = 578
    Height = 65
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 0
    ExplicitTop = 296
    ExplicitWidth = 584
    object Button1: TButton
      AlignWithMargins = True
      Left = 400
      Top = 3
      Width = 175
      Height = 59
      Align = alRight
      Caption = 'OK'
      CommandLinkHint = 'Dodaj u korpu'
      Default = True
      ModalResult = 1
      Style = bsCommandLink
      TabOrder = 0
      ExplicitLeft = 416
      ExplicitTop = 6
      ExplicitHeight = 41
    end
    object Button2: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 200
      Height = 59
      Align = alLeft
      Cancel = True
      Caption = 'Otkazi'
      CommandLinkHint = 'Nemoj da dodas u korpu'
      ModalResult = 2
      Style = bsCommandLink
      TabOrder = 1
      ExplicitHeight = 54
    end
  end
  object NumberBox1: TNumberBox
    Left = 24
    Top = 212
    Width = 529
    Height = 33
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    MinValue = 1.000000000000000000
    MaxValue = 999.000000000000000000
    ParentFont = False
    TabOrder = 1
    Value = 1.000000000000000000
  end
  object UpDown1: TUpDown
    Left = 551
    Top = 212
    Width = 16
    Height = 33
    Associate = NumberBox1
    Position = 1
    TabOrder = 2
  end
end
