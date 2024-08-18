unit WaiterUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, OrderStorage, Utilities,
  IOUtils, Vcl.ControlList, Vcl.ComCtrls, Vcl.StdCtrls, System.ImageList,
  Vcl.ImgList, UITypes;

type
  TBoxWaiter = class(TForm)
    PaintBox1: TPaintBox;
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    Panel2: TPanel;
    Label1: TLabel;
    ControlList1: TControlList;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ControlListButton1: TControlListButton;
    ImageList1: TImageList;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ControlListButton2: TControlListButton;
    Button5: TButton;
    Button1: TButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ControlList1BeforeDrawItem(AIndex: Integer; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
    procedure ControlListButton2Click(Sender: TObject);
    procedure ControlListButton1Click(Sender: TObject);
    procedure ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Button5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateOrderList;
  public
    { Public declarations }
  end;

var
  BoxWaiter: TBoxWaiter;

implementation

uses MainUI;

{$R *.dfm}

procedure TBoxWaiter.Button1Click(Sender: TObject);
var
  Password: string;
begin
  if not InputQuery('Promeni lozinku', 'Unesite novu lozinku za konobara', Password) then
    Exit;

  // Write password
  SetWaiterPasword( Password );

  // Done
  MessageDLG('Nova lozinka je uspešno postavljena!', mtInformation, [mbOk], 0);
end;

procedure TBoxWaiter.Button5Click(Sender: TObject);
begin
  Close;
end;

procedure TBoxWaiter.ControlList1BeforeDrawItem(AIndex: Integer;
  ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
begin
  const Order = Orders[AIndex];

  Label2.Caption := DateTimeToStr( Order.DateCreated );
  Label4.Caption := Format('%.2f eur', [Order.TotalPrice]);

  case Order.Payment of
    TPaymentMethod.Cash: Label6.Caption := 'Keš';
    TPaymentMethod.Card: Label6.Caption := 'Kartica';

    else Label6.Caption := 'Nepoznato';
  end;

  Label8.Caption := Order.Note;
end;

procedure TBoxWaiter.ControlListButton1Click(Sender: TObject);
var
  Items: string;
begin
  const Order = Orders[ ControlList1.ItemIndex ];

  // Start
  Items := 'Naručeni meni:'#13#13;

  // Get items
  for var I := 0 to High(Order.Cart) do begin
    const Menu = OrderMenu[ GetOrderItem(Order.Cart[I].Identifier) ];

    Items := Items + Format(' - "%S", %2.f eur x %D'#13, [Menu.Name, Menu.Price, Order.Cart[I].Amount]);
  end;


  // Show dialog
  MessageDlg(Items, mtInformation, [mbOk], 0);
end;

procedure TBoxWaiter.ControlListButton2Click(Sender: TObject);
begin
  DeleteOrder( ControlList1.ItemIndex );

  // Update list
  UpdateOrderList;
end;

procedure TBoxWaiter.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Show main menu
  BoxMain.Show;
end;

procedure TBoxWaiter.FormResize(Sender: TObject);
begin
  const VALUE_MARGIN = 15;

  // Fix layout
  ControlListButton1.Left := ControlList1.ClientWidth - ControlListButton1.Width - VALUE_MARGIN;
  ControlListButton2.Left := ControlListButton1.Left;

  Label8.Width := ControlList1.ClientWidth - Label8.Left - ControlListButton1.Width - VALUE_MARGIN - VALUE_MARGIN;
end;

procedure TBoxWaiter.FormShow(Sender: TObject);
begin
  UpdateOrderList;
end;

procedure TBoxWaiter.PaintBox1Paint(Sender: TObject);
begin
  DoBackgroundDraw(Sender);
end;

procedure TBoxWaiter.ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  HandleScrollbox(Sender, Shift, WheelDelta, Handled);
end;

procedure TBoxWaiter.UpdateOrderList;
begin
  ControlList1.ItemCount := Length(Orders);
  ControlList1.ClientHeight := ControlList1.ItemCount * ControlList1.ItemHeight;
end;

end.
