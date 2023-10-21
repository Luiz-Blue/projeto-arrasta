{
  Stimulus Control
  Copyright (C) 2014-2023 Carlos Rafael Fernandes Picanço.

  The present file is distributed under the terms of the GNU General Public License (GPL v3.0).

  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.
}
unit sdl.app.trials.last;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils
  , SDL2
  , sdl.app.trials
  , sdl.app.stimuli.contract
  , sdl.app.stimuli
  , sdl.app.stimuli.last
  ;

type

  { TLastTrial }

  TLastTrial = class sealed (TTrial)
    private
      FStimuli : TStimuli;
    protected
      function GetIStimuli: IStimuli; override;
    public
      constructor Create(AOwner: TComponent); override;
  end;


implementation

{ TLastTrial }

function TLastTrial.GetIStimuli: IStimuli;
begin
  Result := FStimuli.AsInterface;
end;

constructor TLastTrial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FStimuli := TLastStimuli.Create(Self);
  FStimuli.OnFinalize := nil;
end;

end.

