{
  Stimulus Control
  Copyright (C) 2014-2023 Carlos Rafael Fernandes Picanço.

  The present file is distributed under the terms of the GNU General Public License (GPL v3.0).

  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.
}
unit sdl.app.stimulus.text;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils
  , SDL2
  , fgl
  , sdl.app.graphics.text
  , sdl.app.stimulus
  , sdl.app.events.abstract
  , session.strutils.mts
  ;

type

  TTextList = specialize TFPGList<TText>;

  { TTextStimulus }

  TTextStimulus = class(TStimulus)
    private
      FText : TText;
    protected
      procedure MouseDown(Sender: TObject; Shift: TCustomShiftState;
        X, Y: Integer); override;
    public
      procedure Load(AParameters : TStringList;
        AParent : TObject; ARect: TSDL_Rect); override;
      procedure Start; override;
      procedure Stop; override;
  end;

implementation

uses
  sdl.app.renderer.custom
  , session.constants.mts;

{ TTextStimuli }

procedure TTextStimulus.MouseDown(Sender: TObject; Shift: TCustomShiftState;
  X, Y: Integer);
begin
  DoResponse;
end;

procedure TTextStimulus.Load(AParameters: TStringList; AParent: TObject;
  ARect: TSDL_Rect);
var
  LWord : string;
begin
  FText := TText.Create(Self);
  LWord := GetWordValue(AParameters, IsSample, Index);
  FText.Load(LWord);
  FText.CentralizeWith(ARect);
  FText.Parent := TCustomRenderer(AParent);
  FText.OnMouseDown := @MouseDown;
end;

procedure TTextStimulus.Start;
begin
  FText.Show;
end;

procedure TTextStimulus.Stop;
begin
  FText.Hide;
end;

end.
