{
  Stimulus Control
  Copyright (C) 2014-2023 Carlos Rafael Fernandes Picanço.

  The present file is distributed under the terms of the GNU General Public License (GPL v3.0).

  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.
}
unit session.constants.mts;

{$mode ObjFPC}{$H+}

interface

type
  TMTSKeys = record
    RelationKey    : string;
    SamplesKey     : string;
    SampleKey      : string;
    ComparisonsKey : string;
    ComparisonKey  : string;
    HasPromptKey   : string;
  end;

const
  HeaderSample = 'S';
  HeaderCompasisons = 'Comparisons';
  HeaderCompasison = 'C';
  HeaderRelation = 'Relation';

  MTSKeys : TMTSKeys = (
    RelationKey    : HeaderRelation;
    SamplesKey     : 'Samples';
    SampleKey      : HeaderSample;
    ComparisonsKey : HeaderCompasisons;
    ComparisonKey  : HeaderCompasison;
    HasPromptKey   : 'HasPrompt');

implementation

end.

