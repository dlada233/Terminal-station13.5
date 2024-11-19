import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Box, Button, Image, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  all_worlds: string[];
  attack_types: AttackTypeData[];
  max_hp: number;
  max_mp: number;
  ui_panel: string;
  feedback_message: string;
  player_current_world: string;
  unlocked_world_modifier: number;
  latest_unlocked_world_position: number;
  player_gold: number;
  player_current_hp: number;
  player_current_mp: number;
  enemy_icon_id: string;
  enemy_name: string;
  enemy_max_hp: number;
  enemy_hp: number;
  enemy_mp: number;
  cost_of_items: number;
  equipped_gear: EquippedGear[];
  shop_items: string[];
};

type AttackTypeData = {
  name: string;
  tooltip: string;
};

type EquippedGear = {
  name: string;
  slot: string;
};

export const BattleArcade = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    ui_panel,
    player_current_hp,
    player_current_mp,
    max_hp,
    max_mp,
    player_gold,
    equipped_gear = [],
  } = data;
  return (
    <Window width={420} height={415}>
      <Window.Content>
        <Section align="center">
          玩家状态 <br /> HP:{' '}
          <span style={{ color: '#c91212' }}>
            {player_current_hp}/{max_hp}
          </span>{' '}
          | MP:{' '}
          <span style={{ color: '#0783b5' }}>
            {player_current_mp}/{max_mp}
          </span>{' '}
          | <span style={{ color: '#b8c10b' }}>{player_gold || 0}</span>G <br />
          {!equipped_gear.length && '没有佩戴装备!'}
          {equipped_gear.map((gear, index) => (
            <>
              {gear.slot}: {gear.name} <br />
            </>
          ))}
        </Section>
        {ui_panel === '商店' ? (
          <ShopPanel />
        ) : ui_panel === '世界地图' ? (
          <WorldMapPanel />
        ) : ui_panel === '战斗' ? (
          <BattlePanel />
        ) : ui_panel === '战斗之间' ? (
          <BetweenBattlePanel />
        ) : (
          <GameOverPanel />
        )}
      </Window.Content>
    </Window>
  );
};

const ShopPanel = (props) => {
  const { act, data } = useBackend<Data>();
  const { shop_items, cost_of_items, unlocked_world_modifier } = data;
  return (
    <Section align="center">
      <Box>欢迎来到旅店!</Box>
      <Image width={8} src={resolveAsset('shopkeeper.png')} />
      <Box m={2}>
        请随便看看商品，或休息一晚. 我&apos;将在这里
        确保您&apos;睡个好觉&apos;而不用担心袭击和偷窃.
      </Box>
      {shop_items.map((item, index) => (
        <Button
          key={index}
          icon="shield"
          width="100%"
          onClick={() => act('buy_item', { purchasing_item: item })}
        >
          {item}: {cost_of_items * unlocked_world_modifier}G
        </Button>
      ))}
      <Button icon="bed" width="100%" onClick={() => act('sleep')}>
        休息 {cost_of_items / 2}G
      </Button>
      <Button icon="arrow-left" width="100%" onClick={() => act('leave')}>
        离开旅店
      </Button>
    </Section>
  );
};

const WorldMapPanel = (props) => {
  const { act, data } = useBackend<Data>();
  const { all_worlds, latest_unlocked_world_position } = data;
  return (
    <Section align="center">
      <Box>
        <Button color="transparent" icon="map" /> 世界地图{' '}
        <Button color="transparent" icon="map" />
      </Box>
      <Box m={1}>随着深入，敌人将变得更加棘手，能得到的战利品也会越多.</Box>
      <Button icon="house" width="100%" onClick={() => act('enter_inn')}>
        进入旅店
      </Button>
      {all_worlds.map((world, index) => (
        <Button
          key={index}
          disabled={index >= latest_unlocked_world_position}
          icon="fist-raised"
          width="100%"
          onClick={() => act('start_fight', { selected_arena: world })}
        >
          {world}
        </Button>
      ))}
    </Section>
  );
};

const BattlePanel = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    attack_types,
    enemy_icon_id,
    enemy_name,
    enemy_max_hp,
    enemy_hp,
    enemy_mp,
    feedback_message,
  } = data;
  return (
    <Section align="center">
      {feedback_message && <Box>{feedback_message}</Box>}
      <Box>
        {enemy_name}&apos; HP: {enemy_hp}/{enemy_max_hp}
      </Box>
      <Box>
        {enemy_name}&apos; MP: {enemy_mp}
      </Box>
      <Image width={10} src={resolveAsset(enemy_icon_id)} />
      {attack_types.map((attack, index) => (
        <Button
          key={index}
          icon="fist-raised"
          width="100%"
          tooltip={attack.tooltip}
          onClick={() => act(attack.name)}
        >
          {attack.name}
        </Button>
      ))}
      <Button.Confirm
        icon="shoe-prints"
        width="100%"
        confirmContent="确定逃跑?"
        onClick={() => act('flee')}
      >
        逃跑 (失去一半的金钱)
      </Button.Confirm>
    </Section>
  );
};

const BetweenBattlePanel = (props) => {
  const { act, data } = useBackend<Data>();
  return (
    <Section align="center">
      <Image width={10} src={resolveAsset('fireplace.png')} />
      <Box m={1}>
        夜幕降临，你可以选择休息，这将下场战斗到来前恢复你的生命值和法力值. 然而
        你可能会被袭击，迫使你在没有得到治疗的情况下进行战斗.
      </Box>
      <Button icon="bed" width="100%" onClick={() => act('continue_with_rest')}>
        尝试休息
      </Button>
      <Button
        icon="fire"
        width="100%"
        onClick={() => act('continue_without_rest')}
      >
        不休息就离开
      </Button>
      <Button
        icon="shoe-prints"
        width="100%"
        onClick={() => act('abandon_quest')}
      >
        放弃使命
      </Button>
    </Section>
  );
};

const GameOverPanel = (props) => {
  const { act, data } = useBackend<Data>();
  return (
    <Section align="center">
      <Box color="red" fontSize="32px" m={1}>
        游戏结束
      </Box>
      <Box fontSize="15px">
        <Button
          lineHeight={2}
          fluid
          icon="arrow-left"
          onClick={() => act('restart')}
        >
          主菜单
        </Button>
      </Box>
    </Section>
  );
};
