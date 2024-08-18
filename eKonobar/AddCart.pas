unit AddCart;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Utilities, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.NumberBox, Vcl.ComCtrls;

type
  TBoxAddCart = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    Image1: TImage;
    Label2: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    NumberBox1: TNumberBox;
    UpDown1: TUpDown;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BoxAddCart: TBoxAddCart;

implementation

{$R *.dfm}

end.
