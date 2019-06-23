unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, UFindWindow,  ExtCtrls, Menus, XPMan,
  ComCtrls;

type

  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    WinTracker1: TWinTracker;
    procedure WinTracker1EndTrack(Sender: TObject);
    procedure WinTracker1StartTrack(Sender: TObject);
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
procedure TForm1.WinTracker1EndTrack(Sender: TObject);
begin
    WindowState :=wsNormal;
    Edit1.Text:='0x'+inttohex(WinTracker1.Handle,8) ;
end;
procedure TForm1.WinTracker1StartTrack(Sender: TObject);
begin
    WindowState:=wsMinimized;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   WinTracker1:= TWinTracker.Create(self);
   WinTracker1.Parent:=self ;
   //WinTracker1.Inflate:=true;
   WinTracker1.OnEndTrack :=WinTracker1EndTrack;
   WinTracker1.OnStartTrack :=WinTracker1StartTrack;
end;


end.
