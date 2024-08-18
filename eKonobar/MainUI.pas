unit MainUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Types, UITypes, Utilities, Vcl.StdCtrls, OrderingUI, OrderStorage;

type
  TBoxMain = class(TForm)
    PaintBox1: TPaintBox;
    Menu_Main: TPanel;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Menu_Password: TPanel;
    Label2: TLabel;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    procedure PaintBox1Paint(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BoxMain: TBoxMain;

implementation

{$R *.dfm}

uses WaiterUI;

procedure TBoxMain.Button1Click(Sender: TObject);
begin
  Hide;

  BoxOrder.Show;
end;

procedure TBoxMain.Button2Click(Sender: TObject);
begin
  if ReadWaiterPasword = '' then begin
    MessageDlg('Nemate postavljenu lozinku za konobara. Preporučujemo da je postavite što pre.',
      mtWarning, [mbOk], 0);

    // Hide
    Hide;

    // Show
    BoxWaiter.Show;

    Exit;
  end;

  Menu_Password.Show;
  Menu_Password.BringToFront;
end;

procedure TBoxMain.Button3Click(Sender: TObject);
begin
  if Edit1.Text <> ReadWaiterPasword then begin
    Edit1.Clear;

    MessageDLG('Ta lozinka je netačna!', mtWarning, [mbOk], 0);

    Exit;
  end;

  // Close password box + clear data
  Edit1.Clear;
  Menu_Password.Hide;

  // Hide
  Hide;

  // Show
  BoxWaiter.Show;
end;

procedure TBoxMain.Button4Click(Sender: TObject);
begin
  Menu_Password.Hide;
end;

procedure TBoxMain.PaintBox1Paint(Sender: TObject);
begin
  DoBackgroundDraw(Sender);
end;

end.
