unit UntContact;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.CheckLst, Vcl.ComCtrls, Vcl.Imaging.pngimage, Vcl.Mask, Vcl.Buttons,
  UntPrincipal, System.UITypes, MMSystem, Vcl.Themes, Vcl.Styles;

type
  TFrmContact = class(TForm)
    Panel1: TPanel;
    LabelWriteTitle: TLabel;
    ComboBoxTitle: TComboBox;
    LabelWriteName: TLabel;
    EditName: TEdit;
    Panel2: TPanel;
    RadioGroupGender: TRadioGroup;
    Panel3: TPanel;
    ScrollBarAge: TScrollBar;
    GroupBox3: TGroupBox;
    LabelAge: TLabel;
    LabelWriteYear: TLabel;
    ImageGender: TImage;
    ImageAge: TImage;
    ImageName: TImage;
    GroupBox2: TGroupBox;
    LabelGender: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    LabelWritePhone: TLabel;
    MaskEditPhone: TMaskEdit;
    GroupBox1: TGroupBox;
    LabelName: TLabel;
    MaskEditCPhone: TMaskEdit;
    EditAddress: TEdit;
    EditDistrict: TEdit;
    LabelWriteAddress: TLabel;
    LabelWriteDistrict: TLabel;
    LabelWriteCEP: TLabel;
    ImagePhone: TImage;
    LabelWriteCPhone: TLabel;
    ImageAddress: TImage;
    BitBtnRegister: TBitBtn;
    MaskEditCep: TMaskEdit;
    BitBtnClean: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ScrollBarAgeChange(Sender: TObject);
    function PositionString: integer;
    function VerifiesName(pName: string): integer;
    function VerifiesRegisteredContact: integer;
    procedure BitBtnRegisterClick(Sender: TObject);
    procedure Clean();
    procedure MaskEditCepClick(Sender: TObject);
    procedure MaskEditPhoneClick(Sender: TObject);
    procedure MaskEditCPhoneClick(Sender: TObject);
    procedure BitBtnCleanClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmContact: TFrmContact;

implementation

{$R *.dfm}


procedure TFrmContact.BitBtnCleanClick(Sender: TObject);
begin

  sndPlaySound('Clean Sound.wav', SND_NODEFAULT Or SND_ASYNC);
  EditName.Text := '';
  EditAddress.Text := '';
  EditDistrict.Text := '';
  MaskEditPhone.Text := '';
  MaskEditCPhone.Text := '';
  MaskEditCep.Text := '';
  ScrollBarAge.Position := 1;
  RadioGroupGender.ItemIndex := -1;
  ComboBoxTitle.ItemIndex := 0;

end;

procedure TFrmContact.BitBtnRegisterClick(Sender: TObject);
var
  x: integer;

begin


  // verifica se o botão editar foi acionado
  { # verifies if the edit button was clicked # }

  if Edit = 1 then
  begin

    // procura um espaço livre (false) para alocar os dados do contato
    { # search for an empty space (false) to alocate data from the contact # }

    x := VerifiesRegisteredContact();

    if x <> 0 then

    begin

      if EditName.Text <> '' then

        // verifica se o nome escolhido já existe
        { # verifies if the name chosen already exists # }

        if VerifiesName(EditName.Text) = 1 then
          Bookmark[x].Name := EditName.Text
        else
        begin

          sndPlaySound('xpAlto Error.wav', SND_NODEFAULT Or SND_ASYNC);
          MessageDlg('This name already exists!', mtError, [mbRetry], 0);
          Exit

        end
      else
      begin

        sndPlaySound('xpAlto Error.wav', SND_NODEFAULT Or SND_ASYNC);
        MessageDlg('Type your name again!', mtError, [mbRetry], 0);
        Exit

      end;

      Bookmark[x].Title := ComboBoxTitle.Text;

      Bookmark[x].Age := ScrollBarAge.Position;

      if (RadioGroupGender.ItemIndex = 0) then
        Bookmark[x].Gender := True
      else if (RadioGroupGender.ItemIndex = 1) then
        Bookmark[x].Gender := False
      else
      begin

        sndPlaySound('xpAlto Error.wav', SND_NODEFAULT Or SND_ASYNC);
        MessageDlg('Choose your gender again!', mtError, [mbRetry], 0);
        Exit

      end;

      if EditDistrict.Text <> '' then
        Bookmark[x].District := EditDistrict.Text
      else
      begin

        sndPlaySound('xpAlto Error.wav', SND_NODEFAULT Or SND_ASYNC);
        MessageDlg('Type your district again!', mtError, [mbRetry], 0);
        Exit

      end;

      if EditAddress.Text <> '' then
        Bookmark[x].Address := EditAddress.Text
      else
      begin

        sndPlaySound('xpAlto Error.wav', SND_NODEFAULT Or SND_ASYNC);
        MessageDlg('Type your address again!', mtError, [mbRetry], 0);
        Exit

      end;

      Bookmark[x].CEP := MaskEditCep.Text;

      if MaskEditPhone.Text <> '' then
        Bookmark[x].ResidentialPhone := MaskEditPhone.Text
      else
      begin

        sndPlaySound('xpAlto Error.wav', SND_NODEFAULT Or SND_ASYNC);
        MessageDlg('Type your Residential phone again!', mtError, [mbRetry], 0);
        Exit

      end;

      Bookmark[x].ComercialPhone := MaskEditCPhone.Text;
      Bookmark[x].Status := True;

      sndPlaySound('xpAlto Click.wav', SND_NODEFAULT Or SND_ASYNC);
      MessageDlg('Contact Edited!', mtConfirmation, [mbOk], 0);
      FrmContact.Hide;
      FrmPrincipal.Enabled := True;

    end
    else

    begin

      sndPlaySound('xpAlto Error.wav', SND_NODEFAULT Or SND_ASYNC);
      MessageDlg('Bookmark is full!', mtInformation, [mbRetry], 0);
      FrmPrincipal.Enabled := True;
      Exit

    end;

  end

  // verifica se o nome escolhido já existe
  { # verifies if the name chosen already exists # }

  else if VerifiesName(EditName.Text) = 1 then

  begin

    // procura um espaço livre (false) para alocar os dados do contato
    { # search for an empty space (false) to alocate data from the contact # }

    x := VerifiesRegisteredContact();

    if x <> 0 then

    begin

      if EditName.Text <> '' then
        Bookmark[x].Name := EditName.Text
      else
      begin

        sndPlaySound('xpAlto Error.wav', SND_NODEFAULT Or SND_ASYNC);
        MessageDlg('Type your name again!', mtError, [mbRetry], 0);
        Exit

      end;

      Bookmark[x].Title := ComboBoxTitle.Text;

      Bookmark[x].Age := ScrollBarAge.Position;

      if (RadioGroupGender.ItemIndex = 0) then
        Bookmark[x].Gender := True
      else if (RadioGroupGender.ItemIndex = 1) then
        Bookmark[x].Gender := False
      else
      begin

        sndPlaySound('xpAlto Error.wav', SND_NODEFAULT Or SND_ASYNC);
        MessageDlg('Choose your gender again!', mtError, [mbRetry], 0);
        Exit

      end;

      if EditDistrict.Text <> '' then
        Bookmark[x].District := EditDistrict.Text
      else
      begin

        sndPlaySound('xpAlto Error.wav', SND_NODEFAULT Or SND_ASYNC);
        MessageDlg('Type your district again!', mtError, [mbRetry], 0);
        Exit

      end;

      if EditAddress.Text <> '' then
        Bookmark[x].Address := EditAddress.Text
      else
      begin

        sndPlaySound('xpAlto Error.wav', SND_NODEFAULT Or SND_ASYNC);
        MessageDlg('Type your address again!', mtError, [mbRetry], 0);
        Exit

      end;

      Bookmark[x].CEP := MaskEditCep.Text;

      if MaskEditPhone.Text <> '' then
        Bookmark[x].ResidentialPhone := MaskEditPhone.Text
      else
      begin

        sndPlaySound('xpAlto Error.wav', SND_NODEFAULT Or SND_ASYNC);
        MessageDlg('Type your Residential phone again!', mtError, [mbRetry], 0);
        Exit

      end;

      Bookmark[x].ComercialPhone := MaskEditCPhone.Text;
      Bookmark[x].Status := True;
      FrmPrincipal.Enabled := True;

      sndPlaySound('xpAlto Click.wav', SND_NODEFAULT Or SND_ASYNC);
      MessageDlg('Contact registered!', mtConfirmation, [mbOk], 0);
      FrmContact.Hide;
      FrmPrincipal.Show;

    end
    else

    begin

      sndPlaySound('xpAlto Error.wav', SND_NODEFAULT Or SND_ASYNC);
      MessageDlg('Bookmark is full!', mtInformation, [mbRetry], 0);
      FrmPrincipal.Enabled := True;
      FrmPrincipal.Show;
      Exit

    end;

  end
  else

  begin

    sndPlaySound('xpAlto Error.wav', SND_NODEFAULT Or SND_ASYNC);
    MessageDlg('The name already exists!', mtError, [mbRetry], 0);
    Exit

  end;

  // limpa os campos
  { # clean the fields # }

  Clean();

  FrmPrincipal.RefreshGrid();

  FrmPrincipal.Enabled := True;
  FrmPrincipal.Show;

end;

procedure TFrmContact.Clean;
begin

  // limpa os campos
  { # clean the fields # }

  EditName.Text := '';
  EditAddress.Text := '';
  EditDistrict.Text := '';
  MaskEditPhone.Text := '';
  MaskEditCPhone.Text := '';
  MaskEditCep.Text := '';
  ScrollBarAge.Position := 1;
  RadioGroupGender.ItemIndex := -1;
  ComboBoxTitle.ItemIndex := 0;

end;

procedure TFrmContact.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  FrmPrincipal.Show;
  FrmPrincipal.Enabled := True;

end;

procedure TFrmContact.MaskEditCepClick(Sender: TObject);
begin

  // ao clicar no edit a cursor vai para a primeira letra
  { # when edit is clicked, cursor goes to the first letter # }

  MaskEditCep.SelStart := 0;

end;

procedure TFrmContact.MaskEditCPhoneClick(Sender: TObject);
begin

  // ao clicar no edit a cursor vai para a primeira letra
  { # when edit is clicked, cursor goes to the first letter # }

  MaskEditCPhone.SelStart := 0;

end;

procedure TFrmContact.MaskEditPhoneClick(Sender: TObject);
begin

  // ao clicar no edit a cursor vai para a primeira letra
  { # when edit is clicked, cursor goes to the first letter # }

  MaskEditPhone.SelStart := 0;

end;

function TFrmContact.PositionString: integer;
var
  x: integer;

begin

  // verificar qual posição do vetor está livre (falso)
  { # verifies witch position from the vector is usable (false) # }

  for x := 1 to 100 do

  begin
    if (Bookmark[x].Status = False) then

    begin

      result := x;
      Exit

    end;

  end;

  result := 0;
  Exit

end;

procedure TFrmContact.ScrollBarAgeChange(Sender: TObject);

begin

  if ScrollBarAge.Position = 1 then

  begin

    LabelWriteYear.Caption := ScrollBarAge.Position.ToString + ' Year';

  end

  else
    LabelWriteYear.Caption := ScrollBarAge.Position.ToString + ' Years';

end;

function TFrmContact.VerifiesName(pName: string): integer;
var
  cont: integer;

begin


  for cont := 1 to 100 do

  begin

    if (Bookmark[cont].Name = pName) and (Bookmark[cont].Status = True) then

    begin

      result := 0;
      Exit

    end;

  end;

  result := 1;
  Exit

end;

function TFrmContact.VerifiesRegisteredContact: integer;
var
  x: integer;

begin

  for x := 1 to 100 do

  begin

    if (Bookmark[x].Status = False) then

    begin

      result := x;
      Exit

    end;

  end;

  // se estiver cheio retorna 0
  { # if it's full then returns 0 # }

  result := 0;

end;

end.
