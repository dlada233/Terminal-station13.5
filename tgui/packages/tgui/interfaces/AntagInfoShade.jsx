import { useBackend } from '../backend';
import { Icon, Section, Stack } from '../components';
import { Window } from '../layouts';

export const AntagInfoShade = (props) => {
  const { act, data } = useBackend();
  const { master_name } = data;
  return (
    <Window width={400} height={400} theme="abductor">
      <Window.Content backgroundColor="#9d0032">
        <Icon
          size={20}
          name="ghost"
          color="#660020"
          position="absolute"
          top="20%"
          left="28%"
        />
        <Section fill>
          <Stack vertical fill textAlign="center">
            <Stack.Item fontSize="20px">你的灵魂遭到捕获!</Stack.Item>
            <Stack.Item fontSize="30px">
              你必须服从 {master_name} 的意志!
            </Stack.Item>
            <Stack.Item fontSize="20px">
              不惜一切代价地帮助其达成目标.
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
