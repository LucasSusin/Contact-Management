unit UntSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.Themes, Vcl.Styles;

type

  TFrmSettings = class(TForm)
    ComboBoxThemes: TComboBox;
    Panel1: TPanel;
    Image1: TImage;
    LabelThemes: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBoxThemesChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    // fdefaultStyleName: String;
  public
    { Public declarations }
  end;

var
  FrmSettings: TFrmSettings;

implementation

{$R *.dfm}

uses UntPrincipal, UntContact, UntLogin, UntInfo,
  UntRegisterLogIn, UntSplashScreen;

procedure TFrmSettings.ComboBoxThemesChange(Sender: TObject);
begin

  TStyleManager.TrySetStyle(ComboBoxThemes.Items[ComboBoxThemes.ItemIndex]);

end;

procedure TFrmSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  FrmPrincipal.Enabled := True;

end;


procedure TFrmSettings.FormCreate(Sender: TObject);
var
  s: string;
begin

  FrmPrincipal.Enabled := False;

  ComboBoxThemes.Items.BeginUpdate;
  try
    ComboBoxThemes.Items.Clear;
    for s in TStyleManager.StyleNames do
      ComboBoxThemes.Items.Add(s);
    ComboBoxThemes.Sorted := True;
    // Select the style that's currently in use in the combobox
    ComboBoxThemes.ItemIndex := ComboBoxThemes.Items.IndexOf
      (TStyleManager.ActiveStyle.Name);
  finally
    ComboBoxThemes.Items.EndUpdate;
  end;

  TStyleManager.TrySetStyle('TabletDark');

end;

procedure TFrmSettings.FormShow(Sender: TObject);
var
  s: string;
begin

  {FrmPrincipal.Enabled := False;

  ComboBoxThemes.Items.BeginUpdate;
  try
    ComboBoxThemes.Items.Clear;
    for s in TStyleManager.StyleNames do
      ComboBoxThemes.Items.Add(s);
    ComboBoxThemes.Sorted := True;
    // Select the style that's currently in use in the combobox
    ComboBoxThemes.ItemIndex := ComboBoxThemes.Items.IndexOf
      (TStyleManager.ActiveStyle.Name);
  finally
    ComboBoxThemes.Items.EndUpdate;
  end;

  TStyleManager.TrySetStyle('TabletDark'); }

end;

end.
