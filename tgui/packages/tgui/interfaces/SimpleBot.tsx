import { BooleanLike } from 'common/react';
import { capitalizeAll } from 'common/string';
import { useBackend } from 'tgui/backend';
import {
  Button,
  Icon,
  LabeledControls,
  NoticeBox,
  Section,
  Slider,
  Stack,
  Tooltip,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type Data = {
  can_hack: BooleanLike;
  custom_controls: Record<string, number>;
  emagged: BooleanLike;
  has_access: BooleanLike;
  locked: BooleanLike;
  settings: Settings;
};

type Settings = {
  airplane_mode: BooleanLike;
  allow_possession: BooleanLike;
  has_personality: BooleanLike;
  maintenance_lock: BooleanLike;
  pai_inserted: boolean;
  patrol_station: BooleanLike;
  possession_enabled: BooleanLike;
  power: BooleanLike;
};

export function SimpleBot(props) {
  const { data } = useBackend<Data>();
  const { can_hack, custom_controls, locked } = data;
  const access = !locked || !!can_hack;

  return (
    <Window width={450} height={300}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section title="设置" buttons={<TabDisplay />}>
              {!access ? <NoticeBox>被锁定!</NoticeBox> : <SettingsDisplay />}
            </Section>
          </Stack.Item>
          {!!access && (
            <Stack.Item grow>
              <Section fill scrollable title="控制">
                <LabeledControls wrap>
                  {Object.entries(custom_controls).map((control) => (
                    <LabeledControls.Item
                      pb={2}
                      key={control[0]}
                      label={capitalizeAll(control[0].replace('_', ' '))}
                    >
                      <ControlHelper control={control} />
                    </LabeledControls.Item>
                  ))}
                </LabeledControls>
              </Section>
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
}

/** Creates a lock button at the top of the controls */
function TabDisplay(props) {
  const { act, data } = useBackend<Data>();
  const {
    can_hack,
    emagged,
    has_access,
    locked,
    settings: { allow_possession },
  } = data;

  return (
    <>
      {!!can_hack && (
        <Button
          color="danger"
          disabled={!can_hack}
          icon={emagged ? 'bug' : 'lock'}
          onClick={() => act('hack')}
          selected={!emagged}
          tooltip={!emagged ? '解锁安全协议.' : '重置操作系统.'}
        >
          {emagged ? '故障' : '安全锁定'}
        </Button>
      )}
      {!!allow_possession && <PaiButton />}
      <Button
        color="transparent"
        icon="fa-poll-h"
        onClick={() => act('rename')}
        tooltip="更新机器人的名称."
      >
        重命名
      </Button>
      <Button
        color="transparent"
        disabled={!has_access && !can_hack}
        icon={locked ? 'lock' : 'lock-open'}
        onClick={() => act('lock')}
        selected={locked}
        tooltip={`${locked ? '解锁' : '锁定'}控制面板.`}
      >
        控制锁定
      </Button>
    </>
  );
}

/** Creates a button indicating PAI status and offers the eject action */
function PaiButton(props) {
  const { act, data } = useBackend<Data>();
  const {
    settings: { pai_inserted },
  } = data;

  if (!pai_inserted) {
    return (
      <Button
        color="transparent"
        icon="robot"
        tooltip={`插入活跃状态的PAI来控制该设备.`}
      >
        PAI未插入
      </Button>
    );
  }

  return (
    <Button
      disabled={!pai_inserted}
      icon="eject"
      onClick={() => act('eject_pai')}
      tooltip={`取出当前的PAI.`}
    >
      取出PAI
    </Button>
  );
}

/** Displays the bot's standard settings: Power, patrol, etc. */
function SettingsDisplay(props) {
  const { act, data } = useBackend<Data>();
  const {
    settings: {
      airplane_mode,
      patrol_station,
      power,
      maintenance_lock,
      allow_possession,
      possession_enabled,
    },
  } = data;

  return (
    <LabeledControls>
      <LabeledControls.Item label="电源">
        <Tooltip content={`电源${power ? '关闭' : '开启'}.`}>
          <Icon
            size={2}
            name="power-off"
            color={power ? 'good' : 'gray'}
            onClick={() => act('power')}
          />
        </Tooltip>
      </LabeledControls.Item>
      <LabeledControls.Item label="飞行模式">
        <Tooltip content={`${!airplane_mode ? '关闭' : '开启'}远程控制台访问.`}>
          <Icon
            size={2}
            name="plane"
            color={airplane_mode ? 'yellow' : 'gray'}
            onClick={() => act('airplane')}
          />
        </Tooltip>
      </LabeledControls.Item>
      <LabeledControls.Item label="站内巡逻">
        <Tooltip content={`${patrol_station ? '关闭' : '开启'}自动站内巡逻.`}>
          <Icon
            size={2}
            name="map-signs"
            color={patrol_station ? 'good' : 'gray'}
            onClick={() => act('patrol')}
          />
        </Tooltip>
      </LabeledControls.Item>
      <LabeledControls.Item label="检修盖锁">
        <Tooltip
          content={maintenance_lock ? '打开检修仓门进行维护.' : '关闭检修仓门.'}
        >
          <Icon
            size={2}
            name="toolbox"
            color={maintenance_lock ? 'yellow' : 'gray'}
            onClick={() => act('maintenance')}
          />
        </Tooltip>
      </LabeledControls.Item>
      {!!allow_possession && (
        <LabeledControls.Item label="人格">
          <Tooltip
            content={
              possession_enabled
                ? '将人格重置为出厂默认值.'
                : '允许从网络上下载独特人格.'
            }
          >
            <Icon
              size={2}
              name="robot"
              color={possession_enabled ? 'good' : 'gray'}
              onClick={() => act('toggle_personality')}
            />
          </Tooltip>
        </LabeledControls.Item>
      )}
    </LabeledControls>
  );
}

enum ControlType {
  MedbotSync = 'sync_tech',
  MedbotThreshold = 'heal_threshold',
  FloorbotTiles = 'tile_stack',
  FloorbotLine = 'line_mode',
}

type ControlProps = {
  control: [string, number];
};

/** Helper function which identifies which button to create.
 * Might need some fine tuning if you are using more advanced controls.
 */
function ControlHelper(props: ControlProps) {
  const { act } = useBackend<Data>();
  const { control } = props;

  switch (control[0]) {
    case ControlType.MedbotSync:
      return <MedbotSync />;
    case ControlType.MedbotThreshold:
      return <MedbotThreshold control={control} />;
    case ControlType.FloorbotTiles:
      return <FloorbotTiles control={control} />;
    case ControlType.FloorbotLine:
      return <FloorbotLine control={control} />;
    default:
      return (
        <Icon
          color={control[1] ? 'good' : 'gray'}
          name={control[1] ? 'toggle-on' : 'toggle-off'}
          size={2}
          onClick={() => act(control[0])}
        />
      );
  }
}

/** Small button to sync medbots with research. */
function MedbotSync(props) {
  const { act } = useBackend<Data>();

  return (
    <Tooltip content={`将手术数据与研究网络同步，提高护理效率.`}>
      <Icon
        color="purple"
        name="cloud-download-alt"
        size={2}
        onClick={() => act('sync_tech')}
      />
    </Tooltip>
  );
}

/** Slider button for medbot healing thresholds */
function MedbotThreshold(props: ControlProps) {
  const { act } = useBackend<Data>();
  const { control } = props;

  return (
    <Tooltip content="调整主动治疗的伤害检测值.">
      <Slider
        minValue={5}
        maxValue={75}
        ranges={{
          good: [-Infinity, 15],
          average: [15, 55],
          bad: [55, Infinity],
        }}
        step={5}
        unit="%"
        value={control[1]}
        onChange={(_, value) => act(control[0], { threshold: value })}
      />
    </Tooltip>
  );
}

/** Tile stacks for floorbots - shows number and eject button */
function FloorbotTiles(props: ControlProps) {
  const { act } = useBackend<Data>();
  const { control } = props;

  return (
    <Button
      disabled={!control[1]}
      icon={control[1] ? 'eject' : ''}
      onClick={() => act('eject_tiles')}
      tooltip="一台机器人中包含的地砖数量."
    >
      {control[1] ? `${control[1]}` : '空'}
    </Button>
  );
}

/** Direction indicator for floorbot when line mode is chosen. */
function FloorbotLine(props: ControlProps) {
  const { act } = useBackend<Data>();
  const { control } = props;

  return (
    <Tooltip content="启用直线平铺模式.">
      <Icon
        color={control[1] ? 'good' : 'gray'}
        name={control[1] ? 'compass' : 'toggle-off'}
        onClick={() => act('line_mode')}
        size={!control[1] ? 2 : 1.5}
      >
        {' '}
        {control[1] ? control[1].toString().charAt(0).toUpperCase() : ''}
      </Icon>
    </Tooltip>
  );
}
