import { BooleanLike } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Button,
  Dropdown,
  Image,
  LabeledList,
  NumberInput,
  ProgressBar,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

type Data = {
  auto_defend: BooleanLike;
  repair_node_drone: BooleanLike;
  plant_mines: BooleanLike;
  bot_mode: BooleanLike;
  bot_name: string;
  bot_health: number;
  bot_maintain_distance: number;
  bot_maxhealth: number;
  bot_icon: string;
  bot_color: string;
  possible_colors: Possible_Colors[];
};

type Possible_Colors = {
  color_name: string;
  color_value: string;
};

export const MineBot = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    auto_defend,
    repair_node_drone,
    plant_mines,
    bot_name,
    bot_health,
    bot_mode,
    bot_maxhealth,
    possible_colors,
    bot_maintain_distance,
    bot_color,
    bot_icon,
  } = data;
  const possibleColorList = {};
  for (const index in possible_colors) {
    const color = possible_colors[index];
    possibleColorList[color.color_name] = color;
  }
  const [selectedDistance, setSelectedDistance] = useState(
    bot_maintain_distance,
  );
  const [selectedColor, setSelectedColor] = useState(
    possibleColorList[bot_color],
  );
  return (
    <Window
      title="采矿机器人设置面板"
      width={625}
      height={328}
      theme="hackerman"
    >
      <Window.Content>
        <Stack>
          <Stack.Item width="50%">
            <Section
              textAlign="center"
              title={bot_name}
              buttons={
                <Button.Input
                  color="transparent"
                  onCommit={(e, value) =>
                    act('set_name', {
                      chosen_name: value,
                    })
                  }
                >
                  重命名
                </Button.Input>
              }
            >
              <Stack vertical>
                <Stack.Item>
                  <Image
                    m={1}
                    src={`data:image/jpeg;base64,${bot_icon}`}
                    height="160px"
                    width="160px"
                    style={{
                      verticalAlign: 'middle',
                      borderRadius: '1em',
                      border: '1px solid green',
                    }}
                  />
                </Stack.Item>
                <Stack.Item ml="25%">
                  <Dropdown
                    width="65%"
                    selected={selectedColor?.color_name}
                    options={possible_colors.map((possible_color) => {
                      return possible_color.color_name;
                    })}
                    onSelected={(selected) =>
                      setSelectedColor(possibleColorList[selected])
                    }
                  />
                </Stack.Item>
                <Stack.Item textAlign="center">
                  <Button
                    textAlign="center"
                    width="50%"
                    style={{ padding: '3px' }}
                    onClick={() =>
                      act('set_color', {
                        chosen_color: selectedColor?.color_value,
                      })
                    }
                  >
                    应用颜色
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item width="50%" textAlign="center">
            <Section title="配置">
              <LabeledList>
                <LabeledList.Item label="健康">
                  <ProgressBar
                    value={bot_health}
                    maxValue={bot_maxhealth}
                    color="white"
                  />
                </LabeledList.Item>
                <LabeledList.Item label="模式">
                  <Button
                    textAlign="center"
                    width="50%"
                    style={{ padding: '3px' }}
                    onClick={() => act('toggle_mode')}
                  >
                    {bot_mode ? '战斗' : '安全'}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="修复节点无人机">
                  <Button
                    textAlign="center"
                    width="50%"
                    style={{ padding: '3px' }}
                    onClick={() => act('toggle_repair')}
                  >
                    {repair_node_drone ? '修理' : '忽略'}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="布置地雷">
                  <Button
                    textAlign="center"
                    width="50%"
                    style={{ padding: '3px' }}
                    onClick={() => act('toggle_mines')}
                  >
                    {plant_mines ? '开启' : '关闭'}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="自卫保护">
                  <Button
                    textAlign="center"
                    width="50%"
                    style={{ padding: '3px' }}
                    onClick={() => act('toggle_defend')}
                  >
                    {auto_defend ? '开启' : '关闭'}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="保持距离">
                  <NumberInput
                    width="50%"
                    value={selectedDistance}
                    minValue={0}
                    step={1}
                    maxValue={5}
                    onChange={(value) =>
                      act('change_min_distance', {
                        distance: value,
                      })
                    }
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
