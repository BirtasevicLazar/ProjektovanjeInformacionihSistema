unit OrderingUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Utilities, Vcl.ControlList, Vcl.ComCtrls, OrderStorage, AddCart,
  System.ImageList, Vcl.ImgList, Cod.Animation.Component;

type
  TBoxOrder = class(TForm)
    PaintBox1: TPaintBox;
    Button5: TButton;
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    Panel2: TPanel;
    Label1: TLabel;
    ControlList1: TControlList;
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    TabControl1: TTabControl;
    Button1: TButton;
    ControlListButton1: TControlListButton;
    ImageList1: TImageList;
    View_Cart: TPanel;
    ScrollBox2: TScrollBox;
    Panel3: TPanel;
    Label6: TLabel;
    ControlList2: TControlList;
    Image2: TImage;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ControlListButton2: TControlListButton;
    Button3: TButton;
    Label5: TLabel;
    Memo1: TMemo;
    Label10: TLabel;
    ComboBox1: TComboBox;
    NewAnimation1: TIntAnim;
    Label11: TLabel;
    Label12: TLabel;
    procedure PaintBox1Paint(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure TabControl1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ControlList1BeforeDrawItem(AIndex: Integer; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
    procedure ControlListButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ControlList2BeforeDrawItem(AIndex: Integer; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
    procedure ControlListButton2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    VisibleItems: TArray<integer>;
    Cart: TCart;

    function GetCartTotalPrice: currency;
  public
    { Public declarations }
    procedure ApplyFilter;
    procedure UpdateShoppingCart;
  end;

var
  BoxOrder: TBoxOrder;

implementation

uses MainUI;

{$R *.dfm}

procedure TBoxOrder.ApplyFilter;
procedure Add(Item: integer);
begin
  const Index = Length(VisibleItems);
  SetLength(VisibleItems, Index+1);
  VisibleItems[Index] := Item;
end;
var
  I: integer;
begin
  VisibleItems := [];
  ControlList1.ItemCount := 0;

  for I := 0 to High(OrderMenu) do begin
    if (TabControl1.TabIndex <> 0) and (OrderMenu[I].Category <> TabControl1.Tabs[TabControl1.TabIndex]) then
      continue;

    Add(I);
  end;

  // Show list
  ControlList1.ItemCount := Length(VisibleItems);
  ControlList1.ClientHeight := ControlList1.ItemHeight * ControlList1.ItemCount;
end;

procedure TBoxOrder.Button1Click(Sender: TObject);
begin
  // Show
  View_Cart.Visible := not View_Cart.Visible;
  View_Cart.BringToFront;

  // Load
  UpdateShoppingCart;
end;

procedure TBoxOrder.Button3Click(Sender: TObject);
var
  Order: TOrder;
begin
  // Create order
  Order.DateCreated := Now;
  Order.TotalPrice := Self.GetCartTotalPrice;
  Order.Payment := TPaymentMethod(ComboBox1.ItemIndex);
  Order.Cart := Cart;
  Order.Note := Memo1.Text;

  // Push to database
  CreateNewOrder(Order);

  // Close
  Cart := [];
  View_Cart.Hide;
  UpdateShoppingCart;

  Close;
end;

procedure TBoxOrder.Button5Click(Sender: TObject);
begin
  // Close cart
  if View_Cart.Visible then begin
    View_Cart.Hide;
    UpdateShoppingCart;

    Exit;
  end;

  // Close
  Close;
end;

procedure TBoxOrder.ControlList1BeforeDrawItem(AIndex: Integer;
  ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
begin
  const Item = OrderMenu[ VisibleItems[AIndex] ];

  // Data
  Label2.Caption := Item.Name;
  Label4.Caption := Format('%.2f eur', [Item.Price]);

  // Image
  Image1.Picture.Graphic := Item.Image;
end;

procedure TBoxOrder.ControlList2BeforeDrawItem(AIndex: Integer;
  ACanvas: TCanvas; ARect: TRect; AState: TOwnerDrawState);
begin
  const CartItem = Cart[AIndex];
  const Item = OrderMenu[ GetOrderItem(CartItem.Identifier) ];

  // Data
  Label7.Caption := Item.Name;
  Label9.Caption := Format('%.2f eur x %D', [Item.Price, CartItem.Amount]);

  // Image
  Image2.Picture.Graphic := Item.Image;
end;

procedure TBoxOrder.ControlListButton1Click(Sender: TObject);
var
  Index: integer;
begin
  with TBoxAddCart.Create(Self) do
    try
      // Load data
      const Item = OrderMenu[VisibleItems[ControlList1.ItemIndex]];

      Label2.Caption := Item.Name;
      Label4.Caption := Format('%.2f eur', [Item.Price]);
      Label5.Caption := Item.Description;

      Image1.Picture.Graphic := Item.Image;

      // Show
       if ShowModal <> mrOk then
        Exit;

      // Add to cart
      Index := -1;
      for var I := 0 to High(Cart) do
        if Cart[I].Identifier = Item.Identifier then begin
          Index := I;
          Break;
        end;

      // New item
      if Index = -1 then begin
        Index := Length(Cart);
        SetLength(Cart, Index+1);

        Cart[Index].Identifier := Item.Identifier;
        Cart[Index].Amount := 0;
      end;

      // Add amount
      Inc(Cart[Index].Amount, NumberBox1.ValueInt);
    finally
      Free;
    end;
end;

procedure TBoxOrder.ControlListButton2Click(Sender: TObject);
begin
  const Index = ControlList2.ItemIndex;

  // Offset items
  for var I := Index to Length(Cart)-2 do
    Cart[I] := Cart[I+1];

  // Remove item
  SetLength(Cart, Length(Cart)-1);

  // Update list
  UpdateShoppingCart;
end;

procedure TBoxOrder.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Show main menu
  BoxMain.Show;
end;

procedure TBoxOrder.FormCreate(Sender: TObject);
var
  I: integer;
begin
  // Populate filter list
  for I := 0 to High(OrderMenu) do
    if TabControl1.Tabs.IndexOf(OrderMenu[I].Category) = -1 then
      TabControl1.Tabs.Add( OrderMenu[I].Category );
end;

procedure TBoxOrder.FormShow(Sender: TObject);
begin
  // Close cart
  View_Cart.Hide;

  // Clear cart
  Cart := [];
  Memo1.Clear;

  // UI
  UpdateShoppingCart;

  // Filter
  TabControl1.TabIndex := 0;

  // Filter
  ApplyFilter;
end;

function TBoxOrder.GetCartTotalPrice: currency;
var
  I: integer;
begin
  Result := 0;
  for I := 0 to High(Cart) do begin
    const Item = OrderMenu[ GetOrderItem(Cart[I].Identifier) ];

    Result := Result + Item.Price * Cart[I].Amount;
  end;
end;

procedure TBoxOrder.PaintBox1Paint(Sender: TObject);
begin
  DoBackgroundDraw(Sender);
end;

procedure TBoxOrder.ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  HandleScrollbox(Sender, Shift, WheelDelta, Handled);
end;

procedure TBoxOrder.TabControl1Change(Sender: TObject);
begin
  // Filter
  ApplyFilter;

  // Redraw
  ControlList1.Invalidate;
end;

procedure TBoxOrder.UpdateShoppingCart;
begin
  // UI
  if View_Cart.Visible then
    ControlList2.ItemCount := Length(Cart)
  else
    ControlList2.ItemCount := 0;
  ControlList2.ClientHeight := ControlList2.ItemCount * ControlList2.ItemHeight;

  // Realign
  ControlList2.Top := Label6.BoundsRect.Bottom+1;

  // Order button
  Button3.Enabled := Length(Cart) > 0;

  // Get price
  Label12.Caption := Format('%.2f eur', [GetCartTotalPrice]);
end;

end.
