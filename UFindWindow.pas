unit UFindWindow;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,Buttons;
type
   TWinTracker =class;
   TOnWindowTrack =procedure (Sender :TWinTracker ;var Accept:boolean)of object;
   TWinTracker=class(TSpeedButton)
   private
     FRectForm:TForm;
     FHandle :HWND;
     FWinRect:TRect;
     FOnEndTrack: TNotifyEvent;
     FOnStartTrack: TNotifyEvent;
     FOnWindowTrack: TOnWindowTrack;
     FInflate: boolean;
     procedure SowRectForm;
   protected
     procedure WndProc(var Message: TMessage);override;
   public
     property Handle:HWND read FHandle;
     property WinRect:TRect read FWinRect;
   published
     property Inflate:boolean read FInflate write FInflate;
     property OnStartTrack:TNotifyEvent read FOnStartTrack write FOnStartTrack;
     property OnEndTrack:TNotifyEvent read FOnEndTrack write FOnEndTrack;
     property OnWindowTrack:TOnWindowTrack read FOnWindowTrack write FOnWindowTrack;
   end;

procedure Register;

implementation

{ TWinTracker }
procedure Register;
begin
  RegisterComponents('Example', [TWinTracker]);
end;

procedure TWinTracker.WndProc(var Message: TMessage);
begin
   case Message.Msg of
     WM_LBUTTONDOWN:
            if Message.WParam = MK_LBUTTON then
            begin
               FHandle := THandle(-1);
               if Assigned(OnStartTrack) then
                  OnStartTrack(Self);
                 SowRectForm();
                 SetCursor(windows.LoadCursor(0,IDC_HAND));
            end;
     WM_LBUTTONUP :
            begin
                  FreeAndNil(FRectForm);
                  if Assigned(OnEndTrack) then
                     OnEndTrack(Self);
            end;
     WM_MOUSEMOVE  :
            if Message.WParam = MK_LBUTTON then
            begin
               SowRectForm();
            end;

   end;
   inherited;
end;

procedure TWinTracker.SowRectForm();
const BORDSIZE = 3;
var
 W,H:integer;
 R1,R2:HRGN;
 Pt:TPoint;
 Hwnd:THandle;
 R:TRect;
 CanShow:boolean;
begin
      GetCursorPos(Pt);
      Hwnd:=WindowFromPoint(Pt);
      if Hwnd = FHandle then
         Exit;
      if (FRectForm <> nil) and (FRectForm.Handle = Hwnd) then
         Exit;

      GetWindowRect(Hwnd,FWinRect);
      CanShow :=True;
      R :=  FWinRect;
      if Assigned(OnWindowTrack) then
         OnWindowTrack(Self,CanShow);

      if not CanShow  then
         Exit;

      FHandle:=Hwnd;
      if FInflate then
         windows.InflateRect(R,BORDSIZE,BORDSIZE);
      if FRectForm = nil then
      begin
          FRectForm:= TForm.Create(nil);
          FRectForm.Color :=clRed;
          FRectForm.BorderStyle:=bsNone;
      end;
      FRectForm.Hide;
      W :=R.Right - R.Left;
      H :=R.Bottom -R.Top;
      SetWindowPos(FRectForm.Handle , HWND_TOPMOST, R.Left, R.Top, W, H, 0);
      R1:= CreateRectRgn(0, 0, W, H);
      R2 := CreateRectRgn(BORDSIZE, BORDSIZE, W - BORDSIZE, H - BORDSIZE);
      CombineRgn(R1, R1, R2, RGN_XOR);
      SetWindowRgn(FRectForm.Handle, R1, True);
      DeleteObject(R1);
      DeleteObject(R2);
      FRectForm.Show;
end;

end.
