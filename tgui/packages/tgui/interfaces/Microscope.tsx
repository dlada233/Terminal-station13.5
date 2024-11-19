import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Divider,
  DmIcon,
  Icon,
  NoticeBox,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

type Data = {
  has_dish: BooleanLike;
  cell_lines: CellLine[];
};

type CellLine = {
  type: string;
  name: string;
  desc: string;
  icon: string;
  icon_state: string;
  consumption_rate: number;
  growth_rate: number;
  suspectibility: number;
  requireds: Record<string, number>;
  supplementaries: Record<string, number>;
  suppressives: Record<string, number>;
};

export const Microscope = (props) => {
  const { act, data } = useBackend<Data>();
  const { has_dish, cell_lines = [] } = data;

  return (
    <Window width={620} height={620}>
      <Window.Content scrollable>
        <Section
          title={has_dish ? '培养皿样本' : '无培养皿'}
          buttons={
            !!has_dish && (
              <Button
                icon="eject"
                disabled={!has_dish}
                onClick={() => act('eject_petridish')}
              >
                拿取
              </Button>
            )
          }
        >
          <CellList cell_lines={cell_lines} />
        </Section>
      </Window.Content>
    </Window>
  );
};

const CellList = (props) => {
  const { cell_lines } = props;
  const fallback = (
    <Icon name="spinner" size={5} height="64px" width="64px" spin />
  );
  if (!cell_lines.length) {
    return <NoticeBox>未发现微生物</NoticeBox>;
  }

  return cell_lines.map((cell_line) => {
    return cell_line.type !== 'virus' ? (
      <Stack key={cell_line.desc} mt={2}>
        <Stack.Item>
          <DmIcon
            fallback={fallback}
            icon={cell_line.icon}
            icon_state={cell_line.icon_state}
            height="64px"
            width="64px"
          />
        </Stack.Item>
        <Stack.Item grow pl={1}>
          <Section
            title={cell_line.desc}
            buttons={
              <Button
                color="transparent"
                icon="circle-question"
                tooltip="将样本放入生长缸中，加入所需试剂."
              />
            }
          >
            <Box my={1}>
              每秒消耗{cell_line.consumption_rate}单位营养，来实现每秒
              {cell_line.growth_rate}%的增长.
            </Box>
            {cell_line.suspectibility > 0 && (
              <Box my={1}>感染病毒后，降低{cell_line.suspectibility}%.</Box>
            )}
            <Stack fill>
              <Stack.Item grow>
                <GroupTitle title="所需试剂" />
                {Object.keys(cell_line.requireds).map((reagent) => (
                  <Button fluid key={reagent}>
                    {reagent}
                  </Button>
                ))}
              </Stack.Item>
              <Stack.Item grow>
                <GroupTitle title="增补物" />
                {Object.keys(cell_line.supplementaries).map((reagent) => (
                  <Button
                    fluid
                    color="good"
                    key={reagent}
                    tooltip={
                      '+' + cell_line.supplementaries[reagent] + '%成长每秒.'
                    }
                  >
                    {reagent}
                  </Button>
                ))}
              </Stack.Item>
              <Stack.Item grow>
                <GroupTitle title="抑制物" />
                {Object.keys(cell_line.suppressives).map((reagent) => (
                  <Button
                    fluid
                    color="bad"
                    key={reagent}
                    tooltip={cell_line.suppressives[reagent] + '% 成长每秒.'}
                  >
                    {reagent}
                  </Button>
                ))}
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>
      </Stack>
    ) : (
      <Stack key={cell_line.desc} mt={2}>
        <Stack.Item>
          <Icon name="viruses" color="bad" size={4} mr={1} />
        </Stack.Item>
        <Stack.Item grow pl={1}>
          <Section title={cell_line.desc}>
            <Box my={1}>
              在没有太空西林抑制的情况下，对其他细胞系生长有抑制作用.
            </Box>
          </Section>
        </Stack.Item>
      </Stack>
    );
  });
};

const GroupTitle = (props) => {
  const { title } = props;
  return (
    <Stack my={1}>
      <Stack.Item grow>
        <Divider />
      </Stack.Item>
      <Stack.Item
        style={{
          textTransform: 'capitalize',
        }}
        color={'gray'}
      >
        {title}
      </Stack.Item>
      <Stack.Item grow>
        <Divider />
      </Stack.Item>
    </Stack>
  ) as any;
};
