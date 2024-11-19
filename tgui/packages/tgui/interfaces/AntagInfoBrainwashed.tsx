import { useBackend } from '../backend';
import { Box, Icon, Section, Stack } from '../components';
import { Window } from '../layouts';
import { Objective, ObjectivePrintout } from './common/Objectives';

type Data = {
  objectives: Objective[];
};

export const AntagInfoBrainwashed = (porps) => {
  const { data } = useBackend<Data>();

  return (
    <Window width={400} height={400} theme="abductor">
      <Window.Content backgroundColor="#722e7d">
        <Icon
          size={16}
          name="flushed"
          color="#3f1945"
          position="absolute"
          top="42%"
          left="26%"
        />
        <Section fill>
          <Stack vertical fill textAlign="center">
            <Stack.Item fontFamily="Wingdings">
              Hey, no! Stop translating this!
            </Stack.Item>
            <Stack.Item mt={-0.25} fontSize="20px">
              你的思想在动摇...
            </Stack.Item>
            <Stack.Item mt={-0.25} fontSize="20px">
              It is focusing on a single purpose...
            </Stack.Item>
            <Stack.Item mt={3.5} grow>
              <ObjectivePrintout
                fill
                objectives={data.objectives}
                objectiveFollowup={
                  <Box bold textColor="red">
                    本指令必须被遵守.
                  </Box>
                }
              />
            </Stack.Item>
            <Stack.Item fontSize="20px" textColor="#61e4b9">
              不惜任何代价完成该指令!
            </Stack.Item>
            <Stack.Item fontFamily="Wingdings">
              You ruined my cool font effect.
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
