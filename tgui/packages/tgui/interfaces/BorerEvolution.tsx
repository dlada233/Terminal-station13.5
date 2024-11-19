// THIS IS A SKYRAT UI FILE
import { useBackend } from '../backend';
import { BlockQuote, Button, Section, Stack } from '../components';
import { Window } from '../layouts';

const borerColor = {
  fontWeight: 'bold',
  color: '#b2c96b',
};

type Evolution = {
  path: string;
  name: string;
  desc: string;
  gainFlavor: string;
  cost: number;
  disabled: boolean;
  evoPath: string;
  color: string;
  tier: number;
  exclusive: boolean;
};

type EvolutionInfo = {
  learnableEvolution: Evolution[];
  learnedEvolution: Evolution[];
};

type Info = {
  evolution_points: number;
};

export const BorerEvolution = (props) => {
  return (
    <Window width={675} height={600} theme="wizard" title="进化树">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item grow>
            <EvoInfo />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const PastEvolutions = (props) => {
  const { data } = useBackend<EvolutionInfo>();
  const { learnedEvolution } = data;

  return (
    <Stack.Item grow>
      <Section title="过往进化" fill scrollable>
        <Stack vertical>
          {(!learnedEvolution.length && 'None!') ||
            learnedEvolution.map((learned) => (
              <Stack.Item key={learned.name}>
                <Button
                  width="100%"
                  color={learned.color}
                  content={`${learned.evoPath} - ${
                    learned.tier !== -1 ? `T${learned.tier} -` : ``
                  } ${learned.name}`}
                  tooltip={learned.desc}
                />
              </Stack.Item>
            ))}
        </Stack>
      </Section>
    </Stack.Item>
  );
};

const EvolutionList = (props) => {
  const { data, act } = useBackend<EvolutionInfo>();
  const { learnableEvolution } = data;

  return (
    <Stack.Item grow>
      <Section title="可能进化" fill scrollable>
        {(!learnableEvolution.length && 'None!') ||
          learnableEvolution.map((toLearn) => (
            <Stack.Item key={toLearn.name} mb={1}>
              <Button
                width="100%"
                color={toLearn.color}
                disabled={toLearn.disabled}
                content={`${toLearn.evoPath} - ${
                  toLearn.tier !== -1 ? `T${toLearn.tier} -` : ``
                } ${
                  toLearn.cost > 0
                    ? `${toLearn.name}: ${toLearn.cost}
                  点数`
                    : toLearn.name
                }`}
                tooltip={
                  toLearn.exclusive
                    ? toLearn.desc +
                      `. 拿了这个后，你将无法再获得其他T3+基因组.`
                    : toLearn.desc
                }
                onClick={() => act('evolve', { path: toLearn.path })}
              />
              {!!toLearn.gainFlavor && (
                <BlockQuote>
                  <i>{toLearn.gainFlavor}</i>
                </BlockQuote>
              )}
            </Stack.Item>
          ))}
      </Section>
    </Stack.Item>
  );
};

const EvoInfo = (props) => {
  const { data } = useBackend<Info>();
  const { evolution_points } = data;

  return (
    <Stack justify="space-evenly" height="100%" width="100%">
      <Stack.Item grow>
        <Stack vertical height="100%">
          <Stack.Item fontSize="20px" textAlign="center">
            你拥有 <b>{evolution_points || 0}</b>&nbsp;
            <span style={borerColor}>进化点</span> 可供花费.
          </Stack.Item>
          <Stack.Item grow>
            <Stack height="100%">
              <PastEvolutions />
              <EvolutionList />
            </Stack>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
