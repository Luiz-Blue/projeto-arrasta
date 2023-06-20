{
  Stimulus Control
  Copyright (C) 2014-2023 Carlos Rafael Fernandes Picanço.

  The present file is distributed under the terms of the GNU General Public License (GPL v3.0).

  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.
}
unit session.pool;

{$mode objfpc}{$H+}

interface

uses
  session.endcriteria, counters.manager;

type

  { TPool }

  TPool = class
    RootData : string;
    RootMedia : string;
    BaseFileName : string;
    BaseFilePath : string;
    TimeStart : Extended;
    TestMode : Boolean;
    MonitorToShow : Byte;
  end;
var
  Pool : TPool;
  Counters : TCounterManager;
  EndCriteria : TEndCriteria;

implementation

uses SysUtils, SDL2;

initialization
  Counters := TCounterManager.Create;
  Pool := TPool.Create;
  EndCriteria := TEndCriteria.Create;

  with Pool do
  begin
    BaseFileName := '';
    BaseFilePath := SDL_GetBasePath();
    RootData := BaseFilePath + 'data' + DirectorySeparator;
    RootMedia := BaseFilePath +  'media' + DirectorySeparator;
    ForceDirectories(RootData);
    ForceDirectories(RootMedia);
    MonitorToShow := 0;
    TestMode := False;
  end

finalization
  Pool.Free;
  Counters.Free;
  EndCriteria.Free;

end.

