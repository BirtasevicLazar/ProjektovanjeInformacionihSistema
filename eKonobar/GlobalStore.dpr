program GlobalStore;

{$R *.dres}

uses
  Vcl.Forms,
  MainUI in 'MainUI.pas' {BoxMain},
  Utilities in 'Utilities.pas',
  OrderingUI in 'OrderingUI.pas' {BoxOrder},
  OrderStorage in 'OrderStorage.pas',
  AddCart in 'AddCart.pas' {BoxAddCart},
  WaiterUI in 'WaiterUI.pas' {BoxWaiter},
  SystemArrayHelpers in 'SystemArrayHelpers.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TBoxMain, BoxMain);
  Application.CreateForm(TBoxOrder, BoxOrder);
  Application.CreateForm(TBoxWaiter, BoxWaiter);
  Application.Run;
end.
