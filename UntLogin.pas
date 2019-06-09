unit UntLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Mask, Vcl.Buttons, Vcl.Imaging.pngimage,Vcl.Themes, Vcl.Styles,
  MMSystem, System.UITypes;

var
  User: string;

type
  Login = record

    Username: string[10];
    Password: string[10];
    Status: boolean;

  end;

type
  TFrmLogin = class(TForm)
    ImageBackground: TImage;
    MaskEditUser: TMaskEdit;
    ImageLogin: TImage;
    MaskEditPassword: TMaskEdit;
    BitBtnCreateUser: TBitBtn;
    procedure ImageLoginClick(Sender: TObject);
    procedure MaskEditUserMouseEnter(Sender: TObject);
    procedure MaskEditPasswordMouseEnter(Sender: TObject);
    procedure BitBtnCreateUserClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure CleanText();
    procedure FormShow(Sender: TObject);
    procedure MaskEditPasswordKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;
  VLogin: array [1 .. 100] of Login;
  Archive: file of Login;
  sp: integer;

implementation

{$R *.dfm}

uses UntSplashScreen, UntInfo, UntContact, UntSettings, UntPrincipal, UntRegisterLogIn;

procedure TFrmLogin.BitBtnCreateUserClick(Sender: TObject);
begin

  sndPlaySound('xpAlto Open Program.wav', SND_NODEFAULT Or SND_ASYNC);
  FrmRegisterLogin.Show;

end;

procedure TFrmLogin.CleanText;
begin

  MaskEditUser.Text := 'USERNAME';
  MaskEditPassword.Text := '1234';

end;

procedure TFrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
var
  aux: integer;
begin

  rewrite(Archive);
  aux := 1;
  while aux <= 100 do
  begin

    if (VLogin[aux].Status = True) then
    begin

      write(Archive, VLogin[aux]);

    end;

    aux := aux + 1;

  end;

  closefile(Archive);

end;

procedure TFrmLogin.FormCreate(Sender: TObject);
var
  aux: integer;
begin

  CleanText();

  for aux := 1 to 100 do

  begin

    VLogin[aux].Status := False;

  end;

  assignfile(Archive, 'Login.TXT');
  if fileexists('Login.TXT') then
    reset(Archive)
  else
    rewrite(Archive);

  seek(Archive, 0);
  aux := 1;
  while (not eof(Archive)) do

  begin

    read(Archive, VLogin[aux]);
    VLogin[aux].Status := True;

    aux := aux + 1;

  end;

  sndPlaySound('xpAlto Open Program.wav', SND_NODEFAULT Or SND_ASYNC);

end;

procedure TFrmLogin.FormShow(Sender: TObject);
begin

  // variável para aparecer splash screen
  { # variable to initializate splash screen # }

  if sp = 0 then
  begin

    sp := 1;
    FrmSplashScreen.ShowModal;

  end;

  CleanText();

end;

procedure TFrmLogin.ImageLoginClick(Sender: TObject);
var
  I: integer;
begin

  for I := 1 to 100 do
  begin

    if (VLogin[I].Username = MaskEditUser.Text) and (VLogin[I].Status = True)
    then
    begin

      if (VLogin[I].Password = MaskEditPassword.Text) and
        (VLogin[I].Status = True) then
      begin

        Sleep(700);
        sndPlaySound('xpAlto Windows Logon.wav', SND_NODEFAULT Or SND_ASYNC);

        User := VLogin[I].Username;
        FrmPrincipal := TFrmPrincipal.Create(Self);

        FrmPrincipal.Show;
        FrmLogin.Hide;
        Break;

      end
      else
      begin

        MessageDlg('Incorrect Password!', mtWarning, [mbOk], 0);
        sndPlaySound('xpAlto Error.wav', SND_NODEFAULT Or SND_ASYNC);
        MaskEditPassword.SetFocus;
        Break;

      end;

    end

  end;

  if (I = 101) then
  begin
    begin

      MessageDlg('Incorrect Username!', mtWarning, [mbOk], 0);
      sndPlaySound('xpAlto Error.wav', SND_NODEFAULT Or SND_ASYNC);
      MaskEditUser.SetFocus;

    end;
  end;

end;

procedure TFrmLogin.MaskEditPasswordKeyPress(Sender: TObject; var Key: Char);
begin

  if Key = #13 then
  begin

    ImageLoginClick(Self);

  end;

end;

procedure TFrmLogin.MaskEditPasswordMouseEnter(Sender: TObject);
begin

  if MaskEditPassword.Text = '1234' then
  begin

    MaskEditPassword.Text := '';

  end;

end;

procedure TFrmLogin.MaskEditUserMouseEnter(Sender: TObject);
begin

  if MaskEditUser.Text = 'USERNAME' then
  begin

    MaskEditUser.Text := '';

  end;

end;

// variável para aparecer splash screen
{ # variable to initializate splash screen # }

Initialization

sp := 0;

end.
