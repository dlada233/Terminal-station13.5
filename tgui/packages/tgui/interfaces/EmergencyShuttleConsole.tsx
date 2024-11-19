import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Box, Button, Section, Stack } from '../components';
import { Window } from '../layouts';

type Data = {
  authorizations_remaining: number;
  authorizations: Authorization[];
  emagged: BooleanLike;
  enabled: BooleanLike;
  engines_started: BooleanLike;
  timer_str: string;
};

type Authorization = {
  job: string;
  name: string;
};

export function EmergencyShuttleConsole(props) {
  const { act, data } = useBackend<Data>();
  const {
    authorizations = [],
    authorizations_remaining,
    emagged,
    enabled,
    engines_started,
    timer_str,
  } = data;

  return (
    <Window width={400} height={350}>
      <Window.Content>
        <Section>
          <Box bold fontSize="40px" textAlign="center" fontFamily="monospace">
            {timer_str}
          </Box>
          <Box textAlign="center" fontSize="16px" mb={1}>
            <Box inline bold>
              引擎:
            </Box>
            <Box inline color={engines_started ? 'good' : 'average'} ml={1}>
              {engines_started ? '在线' : '闲置'}
            </Box>
          </Box>
          <Section
            title="提前发射授权"
            buttons={
              <Button
                color="bad"
                disabled={!enabled}
                icon="times"
                onClick={() => act('abort')}
              >
                全部撤销
              </Button>
            }
          >
            <Stack>
              <Stack.Item grow>
                <Button
                  color="good"
                  disabled={!enabled}
                  fluid
                  icon="exclamation-triangle"
                  onClick={() => act('authorize')}
                >
                  授权
                </Button>
              </Stack.Item>
              <Stack.Item grow>
                <Button
                  disabled={!enabled}
                  fluid
                  icon="minus"
                  onClick={() => act('repeal')}
                >
                  撤销
                </Button>
              </Stack.Item>
            </Stack>
            <Section
              title="授权"
              minHeight="150px"
              buttons={
                <Box inline bold color={emagged ? 'bad' : 'good'}>
                  {emagged ? '故障' : '剩余: ' + authorizations_remaining}
                </Box>
              }
            >
              {authorizations.length === 0 ? (
                <Box bold textAlign="center" fontSize="16px" color="average">
                  无激活授权
                </Box>
              ) : (
                authorizations.map((authorization) => (
                  <Box
                    key={authorization.name}
                    bold
                    fontSize="16px"
                    className="candystripe"
                  >
                    {authorization.name} ({authorization.job})
                  </Box>
                ))
              )}
            </Section>
          </Section>
        </Section>
      </Window.Content>
    </Window>
  );
}
