import { useBackend } from '../backend';
import {
  Box,
  Button,
  ColorBox,
  Divider,
  Flex,
  Icon,
  Image,
  Input,
  LabeledList,
  Section,
  Stack,
  Table,
} from '../components';
import { Window } from '../layouts';

type ColorEntry = {
  index: Number;
  value: string;
};

type SpriteData = {
  icon_states: string[];
  finished: string;
  steps: SpriteEntry[];
  time_spent: Number;
};

type SpriteEntry = {
  layer: string;
  result: string;
  config_name: string;
};

type GreyscaleMenuData = {
  greyscale_config: string;
  colors: ColorEntry[];
  sprites: SpriteData;
  generate_full_preview: boolean;
  unlocked: boolean;
  monitoring_files: boolean;
  sprites_dir: string;
  icon_state: string;
  refreshing: boolean;
};

enum Direction {
  North = '北',
  NorthEast = '东北',
  East = '东',
  SouthEast = '东南',
  South = '南',
  SouthWest = '西南',
  West = '西',
  NorthWest = '西北',
}

const DirectionAbbreviation: Record<Direction, string> = {
  [Direction.North]: 'N',
  [Direction.NorthEast]: 'NE',
  [Direction.East]: 'E',
  [Direction.SouthEast]: 'SE',
  [Direction.South]: 'S',
  [Direction.SouthWest]: 'SW',
  [Direction.West]: 'W',
  [Direction.NorthWest]: 'NW',
};

const ConfigDisplay = (props) => {
  const { act, data } = useBackend<GreyscaleMenuData>();
  return (
    <Section title="设计">
      <LabeledList>
        <LabeledList.Item label="设计类型">
          <Button icon="cogs" onClick={() => act('select_config')} />
          <Input
            value={data.greyscale_config}
            onChange={(_, value) =>
              act('load_config_from_string', { config_string: value })
            }
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const ColorDisplay = (props) => {
  const { act, data } = useBackend<GreyscaleMenuData>();
  const colors = data.colors || [];
  return (
    <Section title="颜色">
      <LabeledList>
        <LabeledList.Item label="整体颜色码">
          <Button
            icon="dice"
            onClick={() => act('random_all_colors')}
            tooltip="随机所有部位颜色."
          />
          <Input
            value={colors.map((item) => item.value).join('')}
            onChange={(_, value) =>
              act('recolor_from_string', { color_string: value })
            }
          />
        </LabeledList.Item>
        {colors.map((item) => (
          <LabeledList.Item
            key={`colorgroup${item.index}${item.value}`}
            label={`颜色部位${item.index}`}
            color={item.value}
          >
            <ColorBox color={item.value} />{' '}
            <Button
              icon="palette"
              onClick={() => act('pick_color', { color_index: item.index })}
              tooltip="弹出颜色编辑器来选择颜色."
            />
            <Button
              icon="dice"
              onClick={() => act('random_color', { color_index: item.index })}
              tooltip="随机该部位的颜色."
            />
            <Input
              value={item.value}
              width={7}
              onChange={(_, value) =>
                act('recolor', { color_index: item.index, new_color: value })
              }
            />
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

const PreviewCompassSelect = (props) => {
  const { act, data } = useBackend<GreyscaleMenuData>();
  return (
    <Box>
      <Stack vertical>
        <Flex>
          <SingleDirection dir={Direction.NorthWest} />
          <SingleDirection dir={Direction.North} />
          <SingleDirection dir={Direction.NorthEast} />
        </Flex>
        <Flex>
          <SingleDirection dir={Direction.West} />
          <Flex.Item grow={1} basis={0}>
            <Button lineHeight={3} m={-0.2} fluid>
              <Icon name="arrows-alt" size={1.5} m="20%" />
            </Button>
          </Flex.Item>
          <SingleDirection dir={Direction.East} />
        </Flex>
        <Flex>
          <SingleDirection dir={Direction.SouthWest} />
          <SingleDirection dir={Direction.South} />
          <SingleDirection dir={Direction.SouthEast} />
        </Flex>
      </Stack>
    </Box>
  );
};

const SingleDirection = (props) => {
  const { dir } = props;
  const { data, act } = useBackend<GreyscaleMenuData>();
  return (
    <Flex.Item grow={1} basis={0}>
      <Button
        content={DirectionAbbreviation[dir]}
        tooltip={`将预览贴图方向设为朝${dir}`}
        disabled={`${dir}` === data.sprites_dir ? true : false}
        textAlign="center"
        onClick={() => act('change_dir', { new_sprite_dir: dir })}
        lineHeight={3}
        m={-0.2}
        fluid
      />
    </Flex.Item>
  );
};

const IconStatesDisplay = (props) => {
  const { data, act } = useBackend<GreyscaleMenuData>();
  return (
    <Section title="图标状态">
      <Flex>
        {data.sprites.icon_states.map((item) => (
          <Flex.Item key={item}>
            <Button
              mx={0.5}
              content={item ? item : '空白状态'}
              disabled={item === data.icon_state}
              onClick={() => act('select_icon_state', { new_icon_state: item })}
            />
          </Flex.Item>
        ))}
      </Flex>
    </Section>
  );
};

const PreviewDisplay = (props) => {
  const { data } = useBackend<GreyscaleMenuData>();
  return (
    <Section title={`预览 (${data.sprites_dir})`}>
      <Table>
        <Table.Row>
          <Table.Cell width="50%">
            <PreviewCompassSelect />
          </Table.Cell>
          {data.sprites?.finished ? (
            <Table.Cell>
              <Image m={0} mx="10%" src={data.sprites.finished} width="75%" />
            </Table.Cell>
          ) : (
            <Table.Cell>
              <Box>
                <Icon name="image" ml="25%" size={5} />
              </Box>
            </Table.Cell>
          )}
        </Table.Row>
      </Table>
      {!!data.unlocked && `耗时: ${data.sprites.time_spent}ms`}
      <Divider />
      {!data.refreshing && (
        <Table>
          {!!data.generate_full_preview && data.sprites.steps !== null && (
            <Table.Row header>
              <Table.Cell width="50%" textAlign="center">
                Layer Source
              </Table.Cell>
              <Table.Cell width="25%" textAlign="center">
                Step Layer
              </Table.Cell>
              <Table.Cell width="25%" textAlign="center">
                Step Result
              </Table.Cell>
            </Table.Row>
          )}
          {!!data.generate_full_preview &&
            data.sprites.steps !== null &&
            data.sprites.steps.map((item) => (
              <Table.Row key={`${item.result}|${item.layer}`}>
                <Table.Cell verticalAlign="middle">
                  {item.config_name}
                </Table.Cell>
                <Table.Cell>
                  <SingleSprite source={item.layer} />
                </Table.Cell>
                <Table.Cell>
                  <SingleSprite source={item.result} />
                </Table.Cell>
              </Table.Row>
            ))}
        </Table>
      )}
    </Section>
  );
};

const SingleSprite = (props) => {
  const { source } = props;
  return <Image src={source} />;
};

const LoadingAnimation = () => {
  return (
    <Box height={0} mt="-100%">
      <Icon name="cog" height={22.7} opacity={0.5} size={25} spin />
    </Box>
  );
};

export const GreyscaleModifyMenu = (props) => {
  const { act, data } = useBackend<GreyscaleMenuData>();
  return (
    <Window title="色彩配置" width={325} height={800}>
      <Window.Content scrollable>
        <ConfigDisplay />
        <ColorDisplay />
        <IconStatesDisplay />
        <Flex direction="column">
          {!!data.unlocked && (
            <Flex.Item justify="flex-start">
              <Button
                content={
                  <Icon name="file-image-o" spin={data.monitoring_files} />
                }
                tooltip="持续检查文件的更改并在必要时重新加载，警告：高占用."
                selected={data.monitoring_files}
                onClick={() => act('toggle_mass_refresh')}
                width={1.9}
                mr={-0.2}
              />
              <Button
                content="刷新图标文件"
                tooltip="从硬盘加载json配置和图标文件，这有助于避免重启服务器以检查更改，警告：高占用."
                onClick={() => act('refresh_file')}
              />
              <Button
                content="保存图标文件"
                tooltip="将图标文件保存到tmp/中的临时文件中，如果你想在其他地方生成该图标，或者查看更精准的表示，这非常有用."
                onClick={() => act('save_dmi')}
              />
            </Flex.Item>
          )}
          <Flex.Item>
            <Button
              content="应用"
              tooltip="将所做更改应用于创建此菜单的对象."
              color="red"
              onClick={() => act('apply')}
            />
            <Button.Checkbox
              content="完整预览"
              tooltip="生成并完整显示贴图生成过程，而不仅仅是最终输出."
              disabled={!data.generate_full_preview && !data.unlocked}
              checked={data.generate_full_preview}
              onClick={() => act('toggle_full_preview')}
            />
          </Flex.Item>
        </Flex>
        <PreviewDisplay />
        {!!data.refreshing && <LoadingAnimation />}
      </Window.Content>
    </Window>
  );
};
