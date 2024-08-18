unit OrderStorage;

{$SCOPEDENUMS ON}

interface

uses
  Classes, Types, SysUtils, UITypes, IOUtils, Vcl.Graphics, Windows,
  IniFiles, Imaging.pngimage, Utilities, Cod.StringUtils, SystemArrayHelpers;

type
  // Cart
  TCartItem = record
    Identifier: string;
    Amount: integer;

    // Conversion
    function ToString: string;
    constructor FromString(AStr: string);
  end;
  TCart = TArray<TCartItem>;

  // Helper
  TCartHelper = record helper for TCart
    // Conversion
    function ToString: string;
    constructor FromString(AStr: string);
  end;

  // Order
  TPaymentMethod = (Cash, Card);
  TOrder = record
    // Respective file
    FilePath: string;

    // Data
    DateCreated: TDateTime;

    TotalPrice: currency;
    Payment: TPaymentMethod;

    Cart: TCart;

    Note: string;

    // Removal
    procedure Delete;

    // Reading / writing
    procedure Load;
    procedure Save;
  end;

  // Menu
  TOrderable = record
    Identifier: string;

    // Detalies
    Name: string;
    Description: string;
    Price: currency; // euro
    Image: TPNGImage;
    Category: string;
  end;

  // Order
  procedure CreateNewOrder(Order: TOrder);
  procedure DeleteOrder(Index: integer);

  // Sort
  procedure SortOrdersByDate;

  // Password
  function ReadWaiterPasword: string;
  procedure SetWaiterPasword(Password: string);

  // Menu
  function GetOrderItem(Identifier: string): integer;

var
  // Files
  PasswordFile: string;

  // Master menu list
  OrderMenu: TArray<TOrderable>;

  // Orders
  OrderDirectory: string;
  Orders: TArray<TOrder>;

implementation

function GenerateStringSequence(Length: integer; Characters: string): string;
var
  CharactersLength: integer;
begin
  CharactersLength := Characters.Length;

  // Generate
  SetLength(Result, Length);
  for var I := 1 to Length do begin
    Randomize;
    Result[I] := Characters[Random(CharactersLength)+1];
  end;
end;

procedure CreateNewOrder(Order: TOrder);
begin
  // Generate file name
  repeat
    Order.FilePath := OrderDirectory+GenerateStringSequence(10, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')+'.ini';
  until not TFile.Exists(Order.FilePath);

  // Add to list
  const Index = Length(Orders);
  SetLength(Orders, Index+1);
  Orders[Index] := Order;

  // Save
  Order.Save;

  // Sort
  SortOrdersByDate;
end;

procedure DeleteOrder(Index: integer);
begin
  // Delete file
  Orders[Index].Delete;

  // Offset array
  for var I := Index to Length(Orders)-2 do
    Orders[I] := Orders[I+1];

  // Shrink array
  SetLength(Orders, Length(Orders)-1);

  // sorting is not required here
end;

procedure SortOrdersByDate;
begin
  // Sort using external Array Utility library and callback
  TArrayUtils<TOrder>.Sort(Orders, function(A, B: TOrder): boolean begin
    Result := A.DateCreated < B.DateCreated;
  end);
end;

function ReadWaiterPasword: string;
begin
  if TFile.Exists(PasswordFile) then
    Result := TFile.ReadAllText(PasswordFile, TEncoding.UTF8)
  else
    Result := '';
end;

procedure SetWaiterPasword(Password: string);
begin
  TFile.WriteAllText(PasswordFile, Password, TEncoding.UTF8);
end;

function GetOrderItem(Identifier: string): integer;
begin
  Result := -1;

  // Search
  for var I := 0 to High(OrderMenu) do
    if OrderMenu[I].Identifier = Identifier then
      Exit( I );
end;

{ TCartItem }

constructor TCartItem.FromString(AStr: string);
begin
  const Items = AStr.Split([':']);
  Identifier := Items[0];
  Amount := Items[1].ToInteger;
end;

function TCartItem.ToString: string;
begin
  Result := Format('%S:%D', [Identifier, Amount]);
end;

{ TCartHelper }

constructor TCartHelper.FromString(AStr: string);
begin
  const Items = AStr.Split([','], TStringSplitOptions.ExcludeEmpty);

  // Size
  SetLength(Self, Length(Items));

  // Load
  for var I := 0 to High(Self) do
    Self[I] := TCartItem.FromString( Items[I] );
end;

function TCartHelper.ToString: string;
begin
  Result := '';

  // Add each
  for var I := 0 to High(Self) do
    Result := Result + Self[I].ToString + ',';

  // Delete end ","
  Result := Result.Substring(0, Result.Length-1);
end;

{ TOrder }

procedure TOrder.Delete;
begin
  // Remove residue
  if TFile.Exists(FilePath) then
    TFile.Delete(FilePath);
end;

procedure TOrder.Load;
begin
  // Read
  with TIniFile.Create(FilePath) do
    try
      DateCreated := ReadDateTime('General', 'Created', 0);

      TotalPrice := ReadFloat('Payment', 'Price', 0);
      Payment := TPaymentMethod(ReadInteger('Payment', 'Method', 0));

      Cart := TCart.FromString( ReadString('Cart', 'Contents', '') );

      Note:= ReadString('Extra', 'Note', '');
    finally
      Free;
    end;
end;

procedure TOrder.Save;
begin
  // Remove existing
  Delete;

  // Write
  with TIniFIle.Create(FilePath) do
    try
      WriteDateTime('General', 'Created', DateCreated);

      WriteFloat('Payment', 'Price', TotalPrice);
      WriteInteger('Payment', 'Method', integer(Payment));

      WriteString('Cart', 'Contents', Cart.ToString);

      WriteString('Extra', 'Note', Note);
    finally
      Free;
    end;
end;

var
  Items: TArray<string>;
  I: integer;
initialization
  // Directory
  OrderDirectory := DirAppData + 'Orders\';
  if not TDirectory.Exists(OrderDirectory) then
    TDirectory.CreateDirectory(OrderDirectory);

  PasswordFile := DirAppData+'waiter-pass.dat';

  // Load menu
  Items := TDirectory.GetFiles('.\Menu', '*.ini', TSearchOption.soTopDirectoryOnly);
  for I := 0 to High(Items) do begin
    const FileName = Items[I];
    const ImageName = FileName.Replace('.ini', '.png');

    // Image exists?
    if not TFile.Exists(ImageName) then begin
      OutputDebugString(PChar(Format('It seems the menu "%S" is invalid or corrupt.', [FileName])));
      continue;
    end;

    // Load
    const Index = Length(OrderMenu);
    SetLength(OrderMenu, Index+1);

    // Data
    with TIniFile.Create(FileName) do
      try
        with OrderMenu[Index] do begin
          Identifier := ChangeFileExt(ExtractFileName(FileName), '');
          Name := ReadString('Basic', 'Name', 'Unknown');
          Description := ReadString('Basic', 'Description', 'Unknown description');
          Price := ReadFloat('Basic', 'Price', 0);
          Category := ReadString('Basic', 'Category', 'Unknown category');
        end;
      finally
        Free;
      end;

    // Image
    OrderMenu[Index].Image := TPNGImage.Create;
    try
      OrderMenu[Index].Image.LoadFromFile( ImageName );
    except
      raise Exception.Create(Format('Menu order "%S" is corrupt. The PNG image could not be loaded. Halting.', [FileName]));
      Halt;
    end;
  end;

  // Load orders
  Items := TDirectory.GetFiles(OrderDirectory, '*.ini', TSearchOption.soTopDirectoryOnly);
  SetLength(Orders, Length(Items));
  for I := 0 to High(Orders) do begin
    Orders[I].FilePath := Items[I];

    // Load order
    Orders[I].Load;
  end;

  // Sort
  SortOrdersByDate;

finalization
  var I: integer;

  // Free images
  for I := 0 to High(OrderMenu) do
    OrderMenu[I].Image.Free;

  // Set to empty
  OrderMenu := [];
end.
