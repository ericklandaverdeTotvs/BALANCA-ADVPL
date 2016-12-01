unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    edContador: TEdit;
    Label2: TLabel;
    edNumerador: TEdit;
    Label3: TLabel;
    edData: TEdit;
    Label4: TLabel;
    edCodigo: TEdit;
    Label5: TLabel;
    edPBruto: TEdit;
    Label6: TLabel;
    edTara: TEdit;
    Label7: TLabel;
    edPLiquido: TEdit;
    lblResult: TLabel;
    Button1: TButton;
    cbxPorta: TComboBox;
    Label8: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure edPBrutoExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Esp : String;
    function tbReplChar(const Ch: Char; const Len: integer): string;
    function tbStrZero(const Value, Len: integer): string;
    function tbSpaco(Const Value: Double; Len: integer): string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var F: TextFile;
    S: String;
begin
    S := Chr(2)+edContador.Text+Esp+tbStrZero(StrToInt(edNumerador.Text),6)+
                        Esp+edData.Text+Esp+tbStrZero(StrToInt(edCodigo.Text),6)+
                        Esp+tbSpaco(StrToFloat(edPBruto.Text),7)+'kg'+
                        Esp+tbSpaco(StrToFloat(edTara.Text),7)+'kg^TR'+chr(14)+chr(32)+
                        tbSpaco(StrToFloat(edPLiquido.Text),7)+chr(20)+'kg'+chr(94)+chr(36)+
                        chr(81)+chr(10)+chr(13)+chr(3);

    AssignFile(F,cbxPorta.Text);
    ReWrite(F);
    Write(F,S);
    CloseFile(F);

    lblResult.Caption := S;    
end;

function TForm1.tbStrZero(const Value, Len: integer): string;
var
  I: integer;
begin
  Result := IntToStr(Value);
  I := Length(Result);
  if I < Len then
  Result := tbReplChar('0', Len-I) + Result
  else if I > Len then
  Result := tbReplChar('*', Len);
end;

function TForm1.tbSpaco(Const Value: Double; Len: integer): string;
var
  I: integer;
begin
  Result := FloatToStr(Value);
  I := Length(Result);
  if I < Len then
  Result := tbReplChar(' ', Len-I) + Result
  else if I > Len then
  Result := tbReplChar('*', Len);
end;


function TForm1.tbReplChar(const Ch: Char; const Len: integer): string;
var
  I: integer;
begin
  SetLength(Result, Len);
  for I := 1 to Len do
  Result[I] := Ch;
end;

procedure TForm1.edPBrutoExit(Sender: TObject);
begin
   edPLiquido.Text := FloatToStr(StrToFloat(edPBruto.Text) - StrToFloat(edTara.Text));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   Esp :=    chr(32)+chr(32);
end;

end.
