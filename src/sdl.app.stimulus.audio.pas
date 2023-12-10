{
  Stimulus Control
  Copyright (C) 2014-2023 Carlos Rafael Fernandes Picanço.

  The present file is distributed under the terms of the GNU General Public License (GPL v3.0).

  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.
}
unit sdl.app.stimulus.audio;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils
  , SDL2
  , sdl.app.graphics.rectangule
  , sdl.app.audio.loops
  , sdl.app.stimulus
  , sdl.app.graphics.picture
  , sdl.app.graphics.text
  , sdl.app.events.abstract
  ;

type

  { TAudioStimulus }

  TAudioStimulus = class(TStimulus)
  private
    FLoops : TSoundLoop;
    FPicture : TPicture;
    FText    : TText;
    FHasPrompt : Boolean;
    procedure SoundFinished(Sender: TObject);
    procedure SoundStart(Sender: TObject);
    procedure NoResponse(Sender: TObject);
  protected
    function GetStimulusName : string; override;
    function GetRect: TRectangule; override;
    procedure SetRect(AValue: TRectangule); override;
    procedure MouseDown(Sender: TObject; Shift: TCustomShiftState;
      X, Y: Integer); override;
    procedure MouseEnter(Sender: TObject); override;
    procedure MouseExit(Sender: TObject); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Load(AParameters : TStringList;
        AParent : TObject; ARect: TSDL_Rect); override;
    procedure Start; override;
    procedure Stop; override;
  end;

implementation

uses sdl.app.audio
   , sdl.app.renderer.custom
   , session.parameters.global
   , session.loggers.writerow.timestamp
   , session.pool
   , session.constants.mts
   , session.strutils
   , session.strutils.mts;

{ TAudioStimulus }

function TAudioStimulus.GetStimulusName: string;
begin
  if IsSample then begin
    Result := 'Audio.Sample' + #9 + FCustomName;
  end else begin
    Result := 'Audio.Comparison' + #9 + FCustomName;
  end;
end;

function TAudioStimulus.GetRect: TRectangule;
begin
  Result := FPicture as TRectangule;
end;

procedure TAudioStimulus.SetRect(AValue: TRectangule);
begin
  FPicture.BoundsRect := AValue.BoundsRect;
end;

procedure TAudioStimulus.SoundFinished(Sender: TObject);
begin
  Timestamp('Stop.' + GetStimulusName);
  if IsSample then begin

  end else begin
    DoResponse(False);
  end;
end;

procedure TAudioStimulus.SoundStart(Sender: TObject);
begin
  Timestamp('Start.' + GetStimulusName);
end;

procedure TAudioStimulus.NoResponse(Sender: TObject);
begin
  if Assigned(OnNoResponse) then begin
    FLoops.Stop;
    Timestamp('NoResponse.' + GetStimulusName);
    OnResponse := nil;
    OnNoResponse(Self);
  end;
end;

procedure TAudioStimulus.MouseDown(Sender: TObject; Shift: TCustomShiftState;
  X, Y: Integer);
begin
  if IsSample then begin
    with FLoops do begin
      if TotalLoops > 1 then begin
        FLoops.OnFinalLoopStop := nil;
      end;
    end;
    if ResponseID = 0 then begin
      Timestamp('Stimulus.Response.' + GetStimulusName);
      DoResponse(True);
      OnResponse := nil;
    end;
  end else begin
    if SDLAudio.Playing then begin
      { do nothing }
    end else begin
      if Assigned(OnMouseDown) then
        OnMouseDown(Self, Shift, X, Y);

      Timestamp('Stimulus.Response.' + GetStimulusName);
      FLoops.Start;
    end;
  end;
end;

procedure TAudioStimulus.MouseEnter(Sender: TObject);
begin
  if IsSample then begin
    { do nothing }
  end else begin
    //FButtonPicture.Show;
  end;
end;

procedure TAudioStimulus.MouseExit(Sender: TObject);
begin
  if IsSample then begin
    { do nothing }
  end else begin
    //FButtonPicture.Hide;
  end;
end;

constructor TAudioStimulus.Create;
begin
  inherited Create;
  FPicture := TPicture.Create;
  FPicture.Owner := Self;
  FLoops := TSoundLoop.Create;
  FText := TText.Create;
  FHasPrompt := False;
end;

destructor TAudioStimulus.Destroy;
begin
  //SDLAudio.UnregisterChannel(FSound);
  //FSound.Free;
  FText.Free;
  FLoops.Free;
  FPicture.Free;
  inherited Destroy;
end;

procedure TAudioStimulus.Load(AParameters: TStringList; AParent: TObject;
  ARect: TSDL_Rect);
const
  LAudioPicture : string = 'AudioPicture'+IMG_EXT;
begin
  FCustomName := GetWordValue(AParameters, IsSample, Index);
  FHasPrompt := HasDAPAAPPrompt(AParameters);
  if FHasPrompt then begin
    FText.FontName := GlobalTrialParameters.FontName;
    //FText.FontSize := 50;
    FText.Load(FCustomName);
    FText.CentralizeWith(ARect);
    FText.Parent := TCustomRenderer(AParent);
    FText.OnMouseDown := @MouseDown;
  end else begin
    FPicture.LoadFromFile(Assets(LAudioPicture));
    FPicture.BoundsRect := ARect;
    FPicture.Parent := TCustomRenderer(AParent);
    FPicture.OnMouseDown := @MouseDown;
    FPicture.OnMouseEnter := @MouseEnter;
    FPicture.OnMouseExit := @MouseExit;
  end;

  FLoops.TotalLoops := GetTotalLoopsValue(AParameters);
  with FLoops do begin
    Sound := SDLAudio.LoadFromFile(AudioFile(FCustomName));
    OnEveryLoopStart := @SoundStart;
    OnEveryLoopStop := @SoundFinished;
    if TotalLoops > 1 then begin
      FLoops.OnFinalLoopStop := @NoResponse;
    end;
  end;
end;

procedure TAudioStimulus.Start;
var
  LRectangule : TRectangule;
begin
  if FHasPrompt then begin
    LRectangule := FText;
  end else begin
    LRectangule := FPicture;
  end;

  if IsSample then begin
    LRectangule.Show;
    if FLoops.TotalLoops > 0 then begin
      FLoops.Start;
    end;
  end else begin
    LRectangule.Show;
  end;
end;

procedure TAudioStimulus.Stop;
var
  LRectangule : TRectangule;
begin
  if FLoops.TotalLoops > 1 then begin
    FLoops.Stop;
  end;
  if FHasPrompt then begin
    LRectangule := FText;
  end else begin
    LRectangule := FPicture;
  end;
  LRectangule.Hide;
end;

end.

