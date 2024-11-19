import { useBackend } from '../backend';
import { Box, Button, Section, Stack } from '../components';
import { Window } from '../layouts';

type Data = {
  cabinet_name: string;
  contents: string[];
  contents_ref: string;
};

export const FilingCabinet = (props) => {
  const { act, data } = useBackend<Data>();
  const { cabinet_name, contents, contents_ref } = data;

  return (
    <Window title={cabinet_name || '文件柜'} width={350} height={300}>
      <Window.Content backgroundColor="#B88F3D" scrollable>
        {contents.map((object, index) => (
          <Stack
            key={contents_ref[index]}
            color="black"
            backgroundColor="white"
            style={{ padding: '2px' }}
            mb={0.5}
          >
            <Stack.Item align="center" grow={1}>
              <Box align="center">{object}</Box>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="eject"
                onClick={() =>
                  act('remove_object', { ref: contents_ref[index] })
                }
              />
            </Stack.Item>
          </Stack>
        ))}
        {contents.length === 0 && (
          <Section>
            <Box color="white" align="center">
              {cabinet_name}是空的!
            </Box>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
