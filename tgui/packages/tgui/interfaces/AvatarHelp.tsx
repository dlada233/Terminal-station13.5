import { useBackend } from '../backend';
import { Box, Icon, Section, Stack } from '../components';
import { Window } from '../layouts';

type Data = {
  help_text: string;
};

const DEFAULT_HELP = `无信息可用! 如果需要请寻求帮助.`;

const boxHelp = [
  {
    color: 'purple',
    text: '研究该区域，看看需要做什么来回收箱子，注意此域信息以及相关线索.',
    icon: 'search-location',
    title: '搜索',
  },
  {
    color: 'green',
    text: '将箱子带回到安全屋的指定回收地点，这个地点可能看起来比较奇特，检查安全屋以找到它.',
    icon: 'boxes',
    title: '回收',
  },
  {
    color: 'blue',
    text: '梯子是回收缓存前断开链接的最安全方式，如果你的连接中断，网络舱提供有限的复苏潜力.',
    icon: 'plug',
    title: '断开连接',
  },
  {
    color: 'yellow',
    text: '在连接状态下，你可以在一定程度上免受环境危害和入侵的威胁，但也并不绝对，请密切关注警报信息.',
    icon: 'id-badge',
    title: '安全',
  },
  {
    color: 'gold',
    text: '生成虚拟角色会耗费巨大的带宽，请不要浪费它们.',
    icon: 'coins',
    title: '尝试限制',
  },
  {
    color: 'red',
    text: '记住，你与存在体是物理相连的. 你是敌对环境中的外来物体，它会试图强行将你驱逐出去.',
    icon: 'skull-crossbones',
    title: '意识危险',
  },
] as const;

export const AvatarHelp = (props) => {
  const { data } = useBackend<Data>();
  const { help_text = DEFAULT_HELP } = data;

  return (
    <Window title="域信息" width={600} height={600}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item grow>
            <Section color="good" fill scrollable title="欢迎来到虚拟域.">
              {help_text}
            </Section>
          </Stack.Item>
          <Stack.Item grow={4}>
            <Stack fill vertical>
              <Stack.Item grow>
                <Stack fill>
                  {[0, 1].map((i) => (
                    <BoxHelp index={i} key={i} />
                  ))}
                </Stack>
              </Stack.Item>
              <Stack.Item grow>
                <Stack fill>
                  {[2, 3].map((i) => (
                    <BoxHelp index={i} key={i} />
                  ))}
                </Stack>
              </Stack.Item>
              <Stack.Item grow>
                <Stack fill>
                  {[4, 5].map((i) => (
                    <BoxHelp index={i} key={i} />
                  ))}
                </Stack>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

// I wish I had media queries
const BoxHelp = (props: { index: number }) => {
  const { index } = props;

  return (
    <Stack.Item grow>
      <Section
        color="label"
        fill
        minHeight={10}
        title={
          <Stack align="center">
            <Icon
              color={boxHelp[index].color}
              mr={1}
              name={boxHelp[index].icon}
            />
            <Box>{boxHelp[index].title}</Box>
          </Stack>
        }
      >
        {boxHelp[index].text}
      </Section>
    </Stack.Item>
  );
};
