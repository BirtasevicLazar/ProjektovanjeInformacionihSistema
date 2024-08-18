unit Utilities;

{$SCOPEDENUMS ON}

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Types, UITypes, IOUtils;

// Types
type
  TDrawMode = (Fill, Fit, Stretch, Center, CenterFill, Center3Fill,
    CenterFit, Normal, Tile); { Windows DWM use a Center3 Fill }

  TTextFlag = (WordWrap, Top, VerticalCenter, Bottom, Left, Center, Right,
    NoClip, ShowAccelChar, Ellipsis, Auto);
  TTextFlags= set of TTextFlag;

// Controls
procedure DoBackgroundDraw(Sender: TObject);
procedure HandleScrollbox(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; var Handled: Boolean);

// Drawing
procedure DrawImageInRect(Canvas: TCanvas; Rect: TRect; Image: TGraphic;
  DrawMode: TDrawMode = TDrawMode.Fill; ImageMargin: integer = 0;
  ClipImage: boolean = false);
function GetDrawModeRects(Rect: TRect; Image: TGraphic; DrawMode:
  TDrawMode = TDrawMode.Fill; ImageMargin: integer = 0): TArray<TRect>; overload;
function GetDrawModeRect(Rect: TRect; Image: TGraphic; DrawMode:
  TDrawMode = TDrawMode.Fill; ImageMargin: integer = 0): TRect; overload;

const
  // App
  APPLICATION_NAME = 'Global Store';

var
  GlobalBackground: TPNGImage;

  // Global directories
  DirAppData,
  DirGlobalAppData: string;

implementation

procedure DoBackgroundDraw(Sender: TObject);
begin
  with TPaintBox(Sender).Canvas do begin
    DrawImageInRect(TPaintBox(Sender).Canvas, ClipRect, GlobalBackground);
  end;
end;

procedure HandleScrollbox(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; var Handled: Boolean);
begin
  if Handled then
    Exit;

  // Get vertical or horizontal scrolling
  var Selected: TControlScrollBar;
  const Horz = TScrollBox(Sender).HorzScrollBar;
  const Vert = TScrollBox(Sender).VertScrollBar;
  if (ssShift in Shift) or (Vert.Range <= 0) then
    Selected := Horz
  else
    Selected := Vert;

  // Apply scrolling
  const PreviousPos = Selected.Position;
  Selected.Position := Selected.Position - WheelDelta div 4;

  // Did any modifications happen?
  Handled := Selected.Position <> PreviousPos;
end;


function GetDrawModeRects(Rect: TRect; Image: TGraphic; DrawMode: TDrawMode; ImageMargin: integer): TArray<TRect>;
var
  A, B, C: real;
  TMPRect: TRect;
  W, H: Integer;
begin
  // Empty Image
  if Image.Empty then
    Exit;

  // Shrink Margins
  Rect.Inflate(-ImageMargin, -ImageMargin);

  // Load
  SetLength(Result, 1);
  if Image <> nil then
  case DrawMode of
    // Fill
    TDrawMode.Fill: begin
      Result[0] := Rect;

      A := Result[0].Width / Image.Width ;
      B := Image.Height * A;

      if B < Result[0].Height then
        begin
          C := Result[0].Height / Image.Height;

          Result[0].Width := trunc(Image.Width * C);
        end
          else
            Result[0].Height := trunc(B);
    end;
    // Fit
    TDrawMode.Fit: begin
      Result[0] := Rect;

      A := Result[0].Width / Image.Width ;
      B := Image.Height * A;

      if B > Result[0].Height then
        begin
          C := Result[0].Height / Image.Height;

          Result[0].Width := trunc(Image.Width * C);
        end
          else
            Result[0].Height := trunc(B);
    end;
    // Stretch
    TDrawMode.Stretch: begin
      Result[0] := Rect;
    end;
    // Center
    TDrawMode.Center: begin
      Result[0].Left := Rect.CenterPoint.X - Image.Width div 2;
      Result[0].Right := Rect.CenterPoint.X + Image.Width div 2;

      Result[0].Top := Rect.CenterPoint.Y - Image.Height div 2;
      Result[0].Bottom := Rect.CenterPoint.Y + Image.Height div 2;
    end;
    // Center Fill
    TDrawMode.CenterFill: begin
      Result[0] := Rect;

      A := Result[0].Width / Image.Width ;
      B := Image.Height * A;

      if B < Result[0].Height then
        begin
          C := Result[0].Height / Image.Height;

          Result[0].Width := trunc(Image.Width * C);
        end
          else
            Result[0].Height := trunc(B);

      W := Result[0].Width;
      H := Result[0].Height;

      Result[0].Left := Result[0].Left - (W - Rect.Width) div 2;
      Result[0].Right := Result[0].Right - (W - Rect.Width) div 2;
      Result[0].Top := Result[0].Top - (H - Rect.Height) div 2;
      Result[0].Bottom := Result[0].Bottom - (H - Rect.Height) div 2;
    end;
    // Center Fill
    TDrawMode.Center3Fill: begin
      Result[0] := Rect;

      A := Result[0].Width / Image.Width ;
      B := Image.Height * A;

      if B < Result[0].Height then
        begin
          C := Result[0].Height / Image.Height;

          Result[0].Width := trunc(Image.Width * C);
        end
          else
            Result[0].Height := trunc(B);

      W := Result[0].Width;
      H := Result[0].Height;

      Result[0].Left := Result[0].Left - (W - Rect.Width) div 3;
      Result[0].Right := Result[0].Right - (W - Rect.Width) div 3;
      Result[0].Top := Result[0].Top - (H - Rect.Height) div 3;
      Result[0].Bottom := Result[0].Bottom - (H - Rect.Height) div 3;
    end;
    // Center Fit
    TDrawMode.CenterFit: begin
      Result[0] := Rect;

      A := Result[0].Width / Image.Width ;
      B := Image.Height * A;

      if B > Result[0].Height then
        begin
          C := Result[0].Height / Image.Height;

          Result[0].Width := trunc(Image.Width * C);
        end
          else
            Result[0].Height := trunc(B);

      W := Result[0].Width;
      H := Result[0].Height;

      Result[0].Left := Result[0].Left + (Rect.Width - W) div 2;
      Result[0].Right := Result[0].Right + (Rect.Width - W) div 2;
      Result[0].Top := Result[0].Top + (Rect.Height - H) div 2;
      Result[0].Bottom := Result[0].Bottom + (Rect.Height - H) div 2;
    end;
    // Normal
    TDrawMode.Normal: begin
      Result[0].Left := Rect.Left;
      Result[0].Right := Result[0].Left + Image.Width;

      Result[0].Top := Rect.Top;
      Result[0].Bottom := Result[0].Bottom + Image.Height;
    end;
    // Tile
    TDrawMode.Tile: begin
      SetLength(Result, 0);
      A := Rect.Top;
      repeat
        B := Rect.Left;
        repeat
          SetLength(Result, Length(Result) + 1);

          TMPRect.TopLeft := Point(trunc(B), trunc(A));
          TMPRect.Width := Image.Width;
          TMPRect.Height := Image.Height;

          Result[Length(Result) - 1] := TMPRect;

          B := B + Image.Width;
        until (B >= Rect.Width);

        A := A + Image.Height;
      until (A >= Rect.Height);
    end;
  end;
end;

function GetDrawModeRect(Rect: TRect; Image: TGraphic; DrawMode: TDrawMode; ImageMargin: integer): TRect;
begin
  Result := GetDrawModeRects(Rect, Image, DrawMode, ImageMargin)[0];
end;

procedure DrawImageInRect(Canvas: TCanvas; Rect: TRect; Image: TGraphic;
  DrawMode: TDrawMode; ImageMargin: integer; ClipImage: boolean);
var
  Rects: TArray<TRect>;
  I: integer;
  Bitmap: TBitMap;
  FRect: TRect;
begin
  // Shrink Margins
  Rect.Inflate(-ImageMargin, -ImageMargin);

  // Get Rectangles
  Rects := GetDrawModeRects(Rect, Image, DrawMode, 0{Margins already defalted});

  if not ClipImage then
    // Standard Draw
    begin
      for I := 0 to High( Rects ) do
        Canvas.StretchDraw( Rects[I], Image );
    end
  else
    // Clip Image Drw
    begin
      for I := 0 to High(Rects) do
        begin
          Bitmap := TBitMap.Create(Rect.Width, Rect.Height);
          Bitmap.PixelFormat := pf32bit;
          Bitmap.Transparent := true;

          const PIXEL_BYTE_SIZE = 4;

          // Fill image with
          for var Y := 0 to Bitmap.Height - 1 do
            FillMemory(Bitmap.ScanLine[Y], PIXEL_BYTE_SIZE * Bitmap.Width, 0);

          Bitmap.Canvas.Lock;
          try
            FRect := Rects[I];
            FRect.Offset( -Rect.Left, -Rect.Top );

            Bitmap.Canvas.StretchDraw(FRect, Image); // Full opacity for temp

            // Image has no alpha channel, set A bytes to 255
            if not Image.Transparent then begin
              const RectZone = TRect.Intersect(Bitmap.Canvas.ClipRect, FRect);

              for var Y := RectZone.Top to RectZone.Bottom-1 do begin
                // Line
                const Pos: PByte = Bitmap.ScanLine[Y];

                // Start left
                for var X := RectZone.Left to RectZone.Right-1 do
                  Pos[X * PIXEL_BYTE_SIZE + 3] := 255;
              end;
            end;

            // Draw
            //Canvas.StretchDraw(Rect, BitMap, Opacity)
            Canvas.Draw(Rect.Left, Rect.Top, BitMap);
          finally
            Bitmap.Canvas.Unlock;
            BitMap.Free;
          end;
        end;
    end;
end;

initialization
  // Init directories
  DirGlobalAppData := IncludeTrailingPathDelimiter(
    GetEnvironmentVariable('appdata')
    );
  Assert(TDirectory.Exists(DirGlobalAppData), 'Invalid enviroment variabiles.');

  // Application data
  DirAppData := IncludeTrailingPathDelimiter(DirGlobalAppData+APPLICATION_NAME);
  if not TDirectory.Exists(DirAppData) then
    TDirectory.CreateDirectory(DirAppData);
  Assert(TDirectory.Exists(DirAppData), 'Failed to create application data directory.');

  // Background
  GlobalBackground := TPNGImage.Create;
  GlobalBackground.LoadFromResourceName(0, 'background');

finalization
  // Free memory
  GlobalBackground.Free;

end.
