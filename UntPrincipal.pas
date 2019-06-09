// English:

{ ##########################
  # UCS - Universidade de Caxias do Sul (CETEC)
  # Grade: III Year.
  # Contact Management
  # Author: Lucas Simon Susin
  # Date of creation: 03/11/2019 13:40
  # Data of last modification: 23/05/2019 12:00
  ######################### }


// Português:

{ ##########################
  # UCS - Universidade de Caxias do Sul (CETEC)
  # Ano: III Série.
  # Agenda Multiusuário
  # Autor: Lucas Simon Susin
  # Data de criação: 11/03/2019 13:40
  # Data da ultima modificação: 23/05/2019 12:00
  ######################### }

unit UntPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.WinXCtrls, Vcl.Imaging.pngimage, Vcl.ComCtrls, Vcl.Grids, Vcl.Buttons,
  Vcl.Themes, Vcl.Styles, ShellAPI, MMSystem;

Type

  // type geral para todos formulário e units terem acesso
  { # global type access for all forms and units # }

  Contact = record

    Name: string[40];
    Title: string[3];
    Age: integer;
    Gender: boolean;
    District: string[20];
    CEP: string[9];
    ComercialPhone: string[8];
    ResidentialPhone: string[11];
    Address: string[40];
    Status: boolean;
  end;

var

  Bookmark: array [1 .. 100] of Contact;
  Edit: integer;
  FilterSelect: integer;

type
  TFrmPrincipal = class(TForm)
    MainMenu: TMainMenu;
    File1: TMenuItem;
    Help1: TMenuItem;
    SearchBox: TSearchBox;
    PanelDesign: TPanel;
    ImageEdit: TImage;
    ImageDelete: TImage;
    ImageAdd: TImage;
    ImageSearch: TImage;
    ImageSettings: TImage;
    Settings1: TMenuItem;
    Exit1: TMenuItem;
    Preferences1: TMenuItem;
    Aboutprog1: TMenuItem;
    StatusBar: TStatusBar;
    StringGridPrincipal: TStringGrid;
    BtnShowFilter: TBitBtn;
    BtnRemoveFilter: TBitBtn;
    Timer1: TTimer;
    PanelFilter: TPanel;
    RadioGroupGenderFilter: TRadioGroup;
    PanelFilterDesign: TPanel;
    PanelFilterDesign2: TPanel;
    EditFilterAge: TEdit;
    EditFilterDistrict: TEdit;
    EditFilterAddress: TEdit;
    PanelFilterDesign3: TPanel;
    BitBtnFilter: TBitBtn;
    PanelFilterDesignCheckBox: TPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    BitBtnFilterClear: TBitBtn;
    BitBtnClearSearchBox: TBitBtn;
    Timer2: TTimer;
    LabelMessage: TLabel;
    procedure Aboutprog1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure ImageSearchClick(Sender: TObject);
    procedure ImageSettingsClick(Sender: TObject);
    procedure Preferences1Click(Sender: TObject);
    procedure ImageAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure RefreshGrid();
    procedure ImageDeleteClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure StringGridPrincipalClick(Sender: TObject);
    procedure ImageEditClick(Sender: TObject);
    procedure BtnShowFilterClick(Sender: TObject);
    procedure BtnRemoveFilterClick(Sender: TObject);
    procedure CleanGrid();
    procedure BitBtnFilterClick(Sender: TObject);
    procedure BitBtnFilterClearClick(Sender: TObject);
    procedure SearchBoxDblClick(Sender: TObject);
    procedure BitBtnClearSearchBoxClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure SearchBoxChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure RadioGroupGenderFilterClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure EditFilterAgeChange(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure EditFilterDistrictChange(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure EditFilterAddressChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

  Filter: Contact;
  Arquive: file of Contact;

implementation

{$R *.dfm}

uses UntInfo, UntSettings, UntContact, UntLogin;

procedure TFrmPrincipal.Aboutprog1Click(Sender: TObject);
begin

  FrmInfo.Show;

end;

procedure TFrmPrincipal.BtnShowFilterClick(Sender: TObject);
begin

  if FilterSelect = 0 then
  begin

    sndPlaySound('xpAlto Open Program.wav', SND_NODEFAULT Or SND_ASYNC);

    if MessageDlg('Select which filters you want to use.', mtConfirmation,
      [mbOk], 0) = mrOk then
    begin

      if MessageDlg('Do you want to receive this message again?',
        mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      begin

        FilterSelect := 1;

      end
      else
      begin

        FilterSelect := 2;

      end;

    end;

  end;

  if FilterSelect = 2 then
  begin

    MessageDlg('Select which filters you want to use.', mtConfirmation,
      [mbOk], 0)

  end;

  PanelFilter.Visible := True;
  BtnRemoveFilter.Enabled := True;

end;

procedure TFrmPrincipal.BitBtnClearSearchBoxClick(Sender: TObject);
begin

  sndPlaySound('Clean Sound.wav', SND_NODEFAULT Or SND_ASYNC);
  RefreshGrid();
  SearchBox.Text := '';

end;

procedure TFrmPrincipal.BitBtnFilterClearClick(Sender: TObject);
begin

  sndPlaySound('Clean Sound.wav', SND_NODEFAULT Or SND_ASYNC);
  RadioGroupGenderFilter.ItemIndex := -1;
  EditFilterAge.Text := '';
  EditFilterDistrict.Text := '';
  EditFilterAddress.Text := '';

end;

procedure TFrmPrincipal.BitBtnFilterClick(Sender: TObject);
var
  x: boolean;
  i, aux, g: integer;

begin

  sndPlaySound('xpAlto Open Program.wav', SND_NODEFAULT Or SND_ASYNC);

  // idade
  { # age # }

  if CheckBox2.Checked = True then
  begin

    Filter.Age := StrToInt(EditFilterAge.Text);

  end;

  // sexo
  { # gender # }

  g := 0;
  if (RadioGroupGenderFilter.ItemIndex = 0) then
    Filter.Gender := True
  else if (RadioGroupGenderFilter.ItemIndex = 1) then
    Filter.Gender := False
  else if RadioGroupGenderFilter.ItemIndex = -1 then
    g := 1;

  // bairro
  { # district # }

  if CheckBox3.Checked = True then
  begin

    if EditFilterDistrict.Text <> '' then
      Filter.District := EditFilterDistrict.Text
    else
      Filter.District := '';

  end;

  // endereço
  { # address # }

  if CheckBox3.Checked = True then
  begin

    if EditFilterAddress.Text <> '' then
      Filter.Address := EditFilterAddress.Text
    else
      Filter.Address := '';

  end;

  CleanGrid();

  aux := 1;

  for i := 1 to 100 do
  begin
    if (Bookmark[i].Status) then
    begin
      x := False;

      if CheckBox2.Checked = True then
      begin

        if Filter.Age <> 0 then
        begin
          if Bookmark[i].Age <> Filter.Age then
            x := True;
        end;

      end;

      if CheckBox1.Checked = True then
      begin

        if g = 0 then
        begin
          if Bookmark[i].Gender <> Filter.Gender then
            x := True
        end;

      end;

      if CheckBox3.Checked = True then
      begin

        if Filter.Address <> '' then
        begin
          if Bookmark[i].Address <> Filter.Address then
            x := True;
        end;

      end;

      if CheckBox3.Checked = True then
      begin

        if Filter.District <> '' then
        begin
          if Bookmark[i].District <> Filter.District then
            x := True;
        end;

      end;

    end;

    if ((x = False) and (Bookmark[i].Status)) then
    begin

      // escrever na grid quando se filtra
      { # write in grid when it filters # }

      if Bookmark[i].Title = '' then
        StringGridPrincipal.Cells[0, aux] := ''
      else if Bookmark[i].Title = 'Mr' then
        StringGridPrincipal.Cells[0, aux] := 'Mr'
      else if Bookmark[i].Title = 'Mrs' then
        StringGridPrincipal.Cells[0, aux] := 'Mrs'
      else if Bookmark[i].Title = 'Ms' then
        StringGridPrincipal.Cells[0, aux] := 'Ms';

      StringGridPrincipal.Cells[1, aux] := Bookmark[i].Name;

      if Bookmark[i].Gender then
        StringGridPrincipal.Cells[2, aux] := 'Male'
      else
        StringGridPrincipal.Cells[2, aux] := 'Female';

      StringGridPrincipal.Cells[3, aux] := IntToStr(Bookmark[i].Age);

      StringGridPrincipal.Cells[4, aux] := Bookmark[i].District;

      StringGridPrincipal.Cells[5, aux] := Bookmark[i].Address;

      StringGridPrincipal.Cells[6, aux] := Bookmark[i].CEP;

      StringGridPrincipal.Cells[7, aux] := Bookmark[i].ResidentialPhone;

      StringGridPrincipal.Cells[8, aux] := Bookmark[i].ComercialPhone;

      aux := aux + 1

    end;

  end;

end;

procedure TFrmPrincipal.BtnRemoveFilterClick(Sender: TObject);
begin

  sndPlaySound('xpAlto Open Program.wav', SND_NODEFAULT Or SND_ASYNC);

  PanelFilter.Visible := False;

  CleanGrid();
  RefreshGrid();
  BtnRemoveFilter.Enabled := False;

  // limpa os campos do filtro ao sair
  { # clean the fields of the filter when exit # }

  RadioGroupGenderFilter.ItemIndex := -1;
  EditFilterAge.Text := '';
  EditFilterDistrict.Text := '';
  EditFilterAddress.Text := '';

end;

procedure TFrmPrincipal.CheckBox1Click(Sender: TObject);
begin

  if CheckBox1.Checked = False then
  begin

    RadioGroupGenderFilter.ItemIndex := -1;

  end;

end;

procedure TFrmPrincipal.CheckBox2Click(Sender: TObject);
begin

  if CheckBox2.Checked = False then
  begin

    EditFilterAge.Text := '';

  end;

end;

procedure TFrmPrincipal.CheckBox3Click(Sender: TObject);
begin

  if CheckBox3.Checked = False then
  begin

    EditFilterDistrict.Text := '';
    EditFilterAddress.Text := '';

  end;

end;

procedure TFrmPrincipal.CleanGrid;
var
  c, r: integer;
begin

  for c := 0 to StringGridPrincipal.ColCount - 1 do
  begin
    for r := 1 to StringGridPrincipal.RowCount - 1 do
    begin

      StringGridPrincipal.Cells[c, r] := '';

    end;
  end;

end;

procedure TFrmPrincipal.EditFilterAddressChange(Sender: TObject);
begin

  if EditFilterAddress.Text <> '' then
  begin

    CheckBox3.Checked := True
  end;

end;

procedure TFrmPrincipal.EditFilterAgeChange(Sender: TObject);
begin

  if EditFilterAge.Text <> '' then
  begin

    CheckBox2.Checked := True

  end;

end;

procedure TFrmPrincipal.EditFilterDistrictChange(Sender: TObject);
begin

  if EditFilterDistrict.Text <> '' then
  begin

    CheckBox3.Checked := True;

  end;

  if EditFilterAddress.Text <> '' then
  begin

    CheckBox3.Checked := True;

  end;

end;

procedure TFrmPrincipal.Exit1Click(Sender: TObject);
var
  aux: integer;

  // salvar os arquivos no data ao sair
  { # save arquives in data when exit # }

begin

  Sleep(1000);
  sndPlaySound('xpAlto Windows Logoff.wav', SND_NODEFAULT Or SND_ASYNC);

  rewrite(Arquive);
  aux := 1;
  while aux <= 100 do
  begin

    if (Bookmark[aux].Status = True) then
    begin

      write(Arquive, Bookmark[aux]);

    end;

    aux := aux + 1;

  end;

  closefile(Arquive);
  FrmPrincipal.Hide;
  FrmLogin.Show;

end;

procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
var
  aux: integer;

  // salvar os arquivos no data ao sair
  { # save arquives in data when exit # }

begin

  rewrite(Arquive);
  aux := 1;
  while aux <= 100 do
  begin

    if (Bookmark[aux].Status = True) then
    begin

      write(Arquive, Bookmark[aux]);

    end;

    aux := aux + 1;

  end;

  closefile(Arquive);
  FrmLogin.close();
end;

procedure TFrmPrincipal.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin

  if MessageDlg('Do you really want to close?', mtConfirmation,
    [mbOk, mbCancel], 0) = mrCancel then
  begin

    CanClose := False;

  end;

end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
var
  aux: integer;
begin

  // Mensagem de login
  { # Login message # }

  LabelMessage.Caption := ('Welcome,  ' + User);

  BitBtnClearSearchBox.Enabled := False;
  Edit := 0;
  FilterSelect := 0;

  for aux := 1 to 100 do

  begin

    Bookmark[aux].Status := False;

  end;

  assignfile(Arquive, User + '.TXT');
  if fileexists(User + '.TXT') then
    reset(Arquive)
  else
    rewrite(Arquive);

  seek(Arquive, 0);
  aux := 1;
  while (not eof(Arquive)) do

  begin

    read(Arquive, Bookmark[aux]);
    aux := aux + 1;

  end;

  // Carrega a primeira linha da grid
  { # Loads the first row in the grid # }

  StringGridPrincipal.Cells[0, 0] := ('        Title');
  StringGridPrincipal.Cells[1, 0] := ('        Name');
  StringGridPrincipal.Cells[2, 0] := ('        Gender');
  StringGridPrincipal.Cells[3, 0] := ('        Age');
  StringGridPrincipal.Cells[4, 0] := ('        District');
  StringGridPrincipal.Cells[5, 0] := ('       Address');
  StringGridPrincipal.Cells[6, 0] := ('        CEP');
  StringGridPrincipal.Cells[7, 0] := ('Residential Phone');
  StringGridPrincipal.Cells[8, 0] := ('Comercial Phone');

  RefreshGrid();
  ImageDelete.Enabled := False;
  ImageEdit.Enabled := False;
  PanelFilter.Visible := False;
  BtnRemoveFilter.Enabled := False;

end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin

  // Mensagem de login
  { # Login message # }

  LabelMessage.Caption := ('Welcome,  ' + User);

  RefreshGrid();

end;

procedure TFrmPrincipal.ImageAddClick(Sender: TObject);
begin

  sndPlaySound('xpAlto Open Program.wav', SND_NODEFAULT Or SND_ASYNC);

  FrmContact.BitBtnRegister.Caption := 'Register';
  FrmContact.Caption := 'New Contact';
  FrmContact.Show;
  FrmContact.Clean();
  FrmPrincipal.Enabled := False;

  PanelFilter.Visible := False;

  CleanGrid();
  RefreshGrid();
  BtnRemoveFilter.Enabled := False;

  // limpa os campos do filtro ao sair
  { # clean the fields of the filter when exit # }

  RadioGroupGenderFilter.ItemIndex := -1;
  EditFilterAge.Text := '';
  EditFilterDistrict.Text := '';
  EditFilterAddress.Text := '';

end;

procedure TFrmPrincipal.ImageDeleteClick(Sender: TObject);
var
  x: integer;

begin


  // informar mensagem que vai deletar StringGridPrincipal.Cells[1,StringGridPrincipal.Row] contato
  { # informs message that will delete StringGridPrincipal.Cells[1,StringGridPrincipal.Row] contact # }

  if (MessageDlg('Delete ' + StringGridPrincipal.Cells[1,
    StringGridPrincipal.Row] + '?', mtConfirmation, mbYesNo, 0) = mrYes) and
    (StringGridPrincipal.Row <> 0) then

  begin

    sndPlaySound('xpAlto Recycle.wav', SND_NODEFAULT Or SND_ASYNC);

    for x := 1 to 100 do

    begin

      if (StringGridPrincipal.Cells[1, StringGridPrincipal.Row] = Bookmark[x]
        .Name) and (Bookmark[x].Status = True) then
      begin

        Bookmark[x].Status := False;
        Break

      end;

      ImageDelete.Enabled := False;

    end;

    RefreshGrid();

  end;

end;

procedure TFrmPrincipal.ImageEditClick(Sender: TObject);
var
  i, x: integer;

begin

  sndPlaySound('xpAlto Open Program.wav', SND_NODEFAULT Or SND_ASYNC);

  if StringGridPrincipal.Cells[0, StringGridPrincipal.Row] = '' then
  begin

    FrmContact.ComboBoxTitle.ItemIndex := 0;

  end
  else if StringGridPrincipal.Cells[0, StringGridPrincipal.Row] = 'Mr' then
  begin

    FrmContact.ComboBoxTitle.ItemIndex := 1;

  end
  else if StringGridPrincipal.Cells[0, StringGridPrincipal.Row] = 'Mrs' then
  begin

    FrmContact.ComboBoxTitle.ItemIndex := 2;

  end
  else if StringGridPrincipal.Cells[0, StringGridPrincipal.Row] = 'Ms' then
  begin

    FrmContact.ComboBoxTitle.ItemIndex := 3;

  end;

  FrmContact.EditName.Text := StringGridPrincipal.Cells
    [1, StringGridPrincipal.Row];

  if StringGridPrincipal.Cells[2, StringGridPrincipal.Row] = 'Male' then
  begin

    FrmContact.RadioGroupGender.ItemIndex := 0;

  end
  else
  begin

    FrmContact.RadioGroupGender.ItemIndex := 1;

  end;

  FrmContact.ScrollBarAge.Position :=
    StrToInt(StringGridPrincipal.Cells[3, StringGridPrincipal.Row]);

  FrmContact.EditDistrict.Text := StringGridPrincipal.Cells
    [4, StringGridPrincipal.Row];

  FrmContact.EditAddress.Text := StringGridPrincipal.Cells
    [5, StringGridPrincipal.Row];

  FrmContact.MaskEditCep.Text := StringGridPrincipal.Cells
    [6, StringGridPrincipal.Row];

  FrmContact.MaskEditPhone.Text := StringGridPrincipal.Cells
    [7, StringGridPrincipal.Row];

  FrmContact.MaskEditCPhone.Text := StringGridPrincipal.Cells
    [8, StringGridPrincipal.Row];

  FrmContact.BitBtnRegister.Caption := 'Edit';
  FrmContact.Caption := 'Edit Contact';
  FrmContact.Show;
  i := StringGridPrincipal.Row;
  Bookmark[i].Status := False;
  Edit := 1;
  FrmPrincipal.Enabled := False;

  PanelFilter.Visible := False;

  BtnRemoveFilter.Enabled := False;

  // limpa os campos do filtro ao sair
  { # clean the fields of the filter when exit # }

  RadioGroupGenderFilter.ItemIndex := -1;
  EditFilterAge.Text := '';
  EditFilterDistrict.Text := '';
  EditFilterAddress.Text := '';

end;

procedure TFrmPrincipal.ImageSearchClick(Sender: TObject);
begin

  sndPlaySound('xpAlto Open Program.wav', SND_NODEFAULT Or SND_ASYNC);

  // comando para abrir link de fora
  { # command to open outside link # }

  ShellExecute(handle, 'open', 'https://github.com/LucasSusin', nil, nil, 0);

end;

procedure TFrmPrincipal.ImageSettingsClick(Sender: TObject);

begin

  sndPlaySound('xpAlto Open Program.wav', SND_NODEFAULT Or SND_ASYNC);

  FrmSettings.Show;

end;

procedure TFrmPrincipal.Preferences1Click(Sender: TObject);

begin

  FrmSettings.Show;

end;

procedure TFrmPrincipal.RadioGroupGenderFilterClick(Sender: TObject);
begin

  if not(RadioGroupGenderFilter.ItemIndex = -1) then
  begin

    CheckBox1.Checked := True;

  end;

end;

procedure TFrmPrincipal.RefreshGrid;
var
  i, x, aux, cont: integer;
begin

  i := 1;
  for i := 1 to 100 do
  begin

    StringGridPrincipal.Cells[0, i] := '';
    StringGridPrincipal.Cells[1, i] := '';
    StringGridPrincipal.Cells[2, i] := '';
    StringGridPrincipal.Cells[3, i] := '';
    StringGridPrincipal.Cells[4, i] := '';
    StringGridPrincipal.Cells[5, i] := '';
    StringGridPrincipal.Cells[6, i] := '';
    StringGridPrincipal.Cells[7, i] := '';
    StringGridPrincipal.Cells[8, i] := '';

  end;

  i := 1;
  for x := 1 to 100 do

  begin

    if Bookmark[x].Status = True then

    begin

      StringGridPrincipal.Cells[0, i] := Bookmark[x].Title;
      StringGridPrincipal.Cells[1, i] := Bookmark[x].Name;

      if Bookmark[i].Gender then
        StringGridPrincipal.Cells[2, i] := 'Male'
      else
        StringGridPrincipal.Cells[2, i] := 'Female';

      StringGridPrincipal.Cells[3, i] := IntToStr(Bookmark[x].Age);
      StringGridPrincipal.Cells[4, i] := Bookmark[x].District;
      StringGridPrincipal.Cells[5, i] := Bookmark[x].Address;
      StringGridPrincipal.Cells[6, i] := Bookmark[x].CEP;
      StringGridPrincipal.Cells[7, i] := Bookmark[x].ResidentialPhone;
      StringGridPrincipal.Cells[8, i] := Bookmark[x].ComercialPhone;

      Inc(i);

    end;

    StringGridPrincipal.RowCount := i;

  end;

  Edit := 0;

  // Mostra quantos contatos estão atualmente cadastrados
  { # Shows how many contacts are currently registered # }

  cont := 0;

  for aux := 1 to 100 do

  begin

    if Bookmark[aux].Status = True then
    begin

      cont := cont + 1;
    end
    else if cont > 1 then
    begin

      StatusBar.Panels[0].Text := IntToStr(cont) + '  Registered contacts!'

    end
    else if cont = 0 then
    begin

      StatusBar.Panels[0].Text := IntToStr(cont) + '  Registered contacts!'

    end
    else if cont = 1 then
    begin

      StatusBar.Panels[0].Text := IntToStr(cont) + '  Registered contact!'

    end;
  end

end;

procedure TFrmPrincipal.SearchBoxChange(Sender: TObject);
begin

  Timer2.Enabled := True;

end;

procedure TFrmPrincipal.SearchBoxDblClick(Sender: TObject);
var
  i, cont: integer;

begin

  cont := 1;

  if SearchBox.Text <> '' then
    CleanGrid();
  BitBtnClearSearchBox.Enabled := True;
  begin

    for i := 1 to 100 do
    begin

      if (uppercase((SearchBox.Text)) = (uppercase(Bookmark[i].Name))) and
        (Bookmark[i].Status = True) then
      begin

        StringGridPrincipal.Cells[1, cont] := Bookmark[i].Name;
        if Bookmark[i].Gender then
          StringGridPrincipal.Cells[2, cont] := 'Male'
        else
          StringGridPrincipal.Cells[2, cont] := 'Female';
        StringGridPrincipal.Cells[3, cont] := IntToStr(Bookmark[i].Age);
        StringGridPrincipal.Cells[4, cont] := Bookmark[i].District;
        StringGridPrincipal.Cells[5, cont] := Bookmark[i].Address;
        StringGridPrincipal.Cells[6, cont] := Bookmark[i].CEP;
        StringGridPrincipal.Cells[7, cont] := Bookmark[i].ResidentialPhone;
        StringGridPrincipal.Cells[8, cont] := Bookmark[i].ComercialPhone;

        cont := cont + 1;

      end;

    end;

  end;

end;

procedure TFrmPrincipal.StringGridPrincipalClick(Sender: TObject);
var
  x: integer;
begin
  for x := 1 to 100 do
  begin
    if (StringGridPrincipal.Cells[x, StringGridPrincipal.Row].Length <> 0) and
      (StringGridPrincipal.Row <> 0) then

    begin

      ImageEdit.Enabled := True;
      ImageDelete.Enabled := True;

    end;

  end;

end;

procedure TFrmPrincipal.Timer1Timer(Sender: TObject);
begin

  StatusBar.Panels[1].Text := ' ' + DateToStr(date); // para data {# for date #}
  StatusBar.Panels[2].Text := ' ' + TimeToStr(now); // para hora {# for time #}

end;

procedure TFrmPrincipal.Timer2Timer(Sender: TObject);
begin

  // Timer para modificar o botão "clear" do procurar nome em false
  { # Timer to modificate button "clear" from search name to false # }

  BitBtnClearSearchBox.Enabled := False;
  Timer2.Enabled := False;

end;

end.
