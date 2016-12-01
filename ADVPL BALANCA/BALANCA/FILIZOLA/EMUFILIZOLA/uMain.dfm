object Form1: TForm1
  Left = 242
  Top = 201
  Width = 511
  Height = 174
  Caption = 'Emulador de Balan'#231'a FILIZOLA'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 8
    Width = 94
    Height = 13
    Caption = 'Contador Inviol'#225'vel:'
  end
  object Label2: TLabel
    Left = 0
    Top = 32
    Width = 119
    Height = 13
    Caption = 'Numerador de Pessagem'
  end
  object Label3: TLabel
    Left = 0
    Top = 56
    Width = 26
    Height = 13
    Caption = 'Data:'
  end
  object Label4: TLabel
    Left = 0
    Top = 80
    Width = 36
    Height = 13
    Caption = 'C'#243'digo:'
  end
  object Label5: TLabel
    Left = 236
    Top = 10
    Width = 55
    Height = 13
    Caption = 'Peso Bruto:'
  end
  object Label6: TLabel
    Left = 236
    Top = 33
    Width = 25
    Height = 13
    Caption = 'Tara:'
  end
  object Label7: TLabel
    Left = 236
    Top = 56
    Width = 66
    Height = 13
    Caption = 'Peso L'#237'quido:'
  end
  object lblResult: TLabel
    Left = -1
    Top = 114
    Width = 54
    Height = 8
    Caption = 'lblResult'
    Font.Charset = OEM_CHARSET
    Font.Color = clRed
    Font.Height = -8
    Font.Name = 'Terminal'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 240
    Top = 85
    Width = 28
    Height = 13
    Caption = 'Porta:'
  end
  object edContador: TEdit
    Left = 123
    Top = 2
    Width = 73
    Height = 21
    ReadOnly = True
    TabOrder = 0
    Text = '1234'
  end
  object edNumerador: TEdit
    Left = 123
    Top = 26
    Width = 73
    Height = 21
    TabOrder = 1
    Text = '000000'
  end
  object edData: TEdit
    Left = 123
    Top = 49
    Width = 94
    Height = 21
    TabOrder = 2
    Text = '29.01.04/11:30'
  end
  object edCodigo: TEdit
    Left = 123
    Top = 73
    Width = 74
    Height = 21
    TabOrder = 3
    Text = '000001'
  end
  object edPBruto: TEdit
    Left = 304
    Top = 2
    Width = 97
    Height = 21
    TabOrder = 4
    Text = '10,30'
    OnExit = edPBrutoExit
  end
  object edTara: TEdit
    Left = 304
    Top = 26
    Width = 97
    Height = 21
    TabOrder = 5
    Text = '1,98'
    OnExit = edPBrutoExit
  end
  object edPLiquido: TEdit
    Left = 304
    Top = 50
    Width = 97
    Height = 21
    TabOrder = 6
    Text = '8,32'
  end
  object Button1: TButton
    Left = 416
    Top = 1
    Width = 81
    Height = 25
    Caption = 'Enviar'
    TabOrder = 7
    OnClick = Button1Click
  end
  object cbxPorta: TComboBox
    Left = 304
    Top = 80
    Width = 97
    Height = 21
    ItemHeight = 13
    TabOrder = 8
    Text = 'COM1:'
    Items.Strings = (
      'COM1:'
      'COM2:')
  end
end
