{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{$WARN IMMUTABLE_STRINGS OFF}
unit UntRegisterLogIn;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask, Vcl.Imaging.pngimage, Vcl.ExtDlgs;

type
  TFrmRegisterLogIn = class(TForm)
    BackgroundImage: TImage;
    GetStarted: TImage;
    EditCreatePassword: TEdit;
    EditCreateLogin: TEdit;
    LoadPhoto: TOpenPictureDialog;
    ImageUser: TImage;
    LabelPicture: TLabel;
    procedure GetStartedClick(Sender: TObject);
    procedure EditCreatePasswordKeyPress(Sender: TObject; var Key: Char);
    procedure CleanText();
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmRegisterLogIn: TFrmRegisterLogIn;
  jpg: TJPEGImage;

implementation

{$R *.dfm}

uses UntLogin, MMSystem;

procedure TFrmRegisterLogIn.CleanText;
begin

  EditCreateLogin.Text := '';
  EditCreatePassword.Text := '';

end;

procedure TFrmRegisterLogIn.EditCreatePasswordKeyPress(Sender: TObject;
  var Key: Char);

var
  I, x: Integer;

begin

  if Key = #13 then
  begin

    GetStartedClick(Self);

  end;

end;

procedure TFrmRegisterLogIn.FormCreate(Sender: TObject);
begin

  CleanText();

end;

procedure TFrmRegisterLogIn.FormShow(Sender: TObject);
begin

  CleanText();

end;

procedure TFrmRegisterLogIn.GetStartedClick(Sender: TObject);

var
  I: Integer;
  x: Integer;
begin
  x := 0;
  for I := 1 to 100 do
  begin

    if (VLogin[I].Username = EditCreateLogin.Text) and (VLogin[I].Status = True)
    then
    begin

      x := 1;
      Break

    end;

  end;

  if (EditCreateLogin.Text <> '') and (EditCreatePassword.Text <> '') then
  begin
    if x = 0 then
    begin
      for I := 1 to 100 do
      begin

        if (VLogin[I].Status = False) then
        begin

          VLogin[I].Username := EditCreateLogin.Text;
          VLogin[I].Password := EditCreatePassword.Text;
          VLogin[I].Status := True;
          MessageDlg('User registered!', mtConfirmation, [mbOk], 0);
          sndPlaySound('xpAlto Click.wav', SND_NODEFAULT Or SND_ASYNC);
          Break

        end;

      end;

      FrmRegisterLogIn.Close;
    end
    else
    begin

      MessageDlg('Name already exists!', mtConfirmation, [mbOk], 0);
      sndPlaySound('xpAlto Error.wav', SND_NODEFAULT Or SND_ASYNC);

    end;

  end
  else
  begin


    MessageDlg('Fill the camps!', mtInformation, [mbOk], 0);

  end;

end;

end.
