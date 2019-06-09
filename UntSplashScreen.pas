unit UntSplashScreen;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TFrmSplashScreen = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure PosChange(var Msg: TWmWindowPosChanging);
      message WM_WINDOWPOSCHANGING;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmSplashScreen: TFrmSplashScreen;

implementation

{$R *.dfm}

uses UntLogin, UntPrincipal;

procedure TFrmSplashScreen.PosChange(var Msg: TWmWindowPosChanging);
begin

  // form não pode ser movido
  { # form not movable # }

  Msg.WindowPos.x := (Screen.Width-Width)  div 2;
  Msg.WindowPos.y := (Screen.Height-Height) div 2;
  Msg.Result := 0;

end;

procedure TFrmSplashScreen.Timer1Timer(Sender: TObject);
begin

  Timer1.Enabled := False;
  Close;

end;

end.
