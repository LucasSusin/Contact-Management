unit UntInfo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, ShellAPI, Vcl.Themes, Vcl.Styles;

type
  TFrmInfo = class(TForm)
    LabelTitle: TLabel;
    Image1: TImage;
    LabelVersion: TLabel;
    LabelCopyright: TLabel;
    LabelFree: TLabel;
    LabelCetec: TLabel;
    LabelSupport: TLabel;
    LabelGithub: TLabel;
    LinkLabelCetec: TLinkLabel;
    LabelEmail: TLabel;
    LinkLabelGithub: TLinkLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure LinkLabelCetecLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure LinkLabelGithubLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmInfo: TFrmInfo;

implementation

{$R *.dfm}

uses UntPrincipal;

procedure TFrmInfo.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  FrmPrincipal.show;

end;

procedure TFrmInfo.FormCreate(Sender: TObject);
begin

  LinkLabelCetec.Caption :=
    '<a href="https://www.ucs.br/site/cetec/">https://www.ucs.br/site/cetec/</a>';

  LinkLabelGithub.Caption :=
    '<a href="https://github.com/LucasSusin">https://github.com/LucasSusin</a>';

end;

procedure TFrmInfo.LinkLabelCetecLinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin

  ShellExecute(0, nil, PChar(Link), nil, nil, 1);

end;

procedure TFrmInfo.LinkLabelGithubLinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin

  ShellExecute(0, nil, PChar(Link), nil, nil, 1);

end;

end.
