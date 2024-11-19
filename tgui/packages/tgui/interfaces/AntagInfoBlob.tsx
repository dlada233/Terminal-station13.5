import { useBackend } from '../backend';
import {
  Box,
  Collapsible,
  Divider,
  LabeledList,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';
import { Rules } from './AntagInfoRules'; // SKYRAT EDIT ADDITION
import { Objective } from './common/Objectives';

type Data = {
  color: string;
  description: string;
  effects: string;
  name: string;
  objectives: Objective[];
};

const BLOB_COLOR = '#556b2f';

export const AntagInfoBlob = (props) => {
  return (
    <Window width={400} height={550}>
      <Window.Content>
        <Section fill scrollable>
          <Overview />
          <Divider />
          <Basics />
          <Structures />
          <Minions />
          <ObjectiveDisplay />
          <Rules /* SKYRAT EDIT ADDITION */ />
        </Section>
      </Window.Content>
    </Window>
  );
};

const Overview = (props) => {
  const { data } = useBackend<Data>();
  const { color, description, effects, name } = data;

  if (!name) {
    return (
      <Stack vertical>
        <Stack.Item bold fontSize="14px" textColor={BLOB_COLOR}>
          You haven&apos;t revealed your true form yet!
        </Stack.Item>
        <Stack.Item>
          You must be succumb to the infection. Find somewhere safe and pop!
        </Stack.Item>
      </Stack>
    );
  }

  return (
    <Stack vertical>
      <Stack.Item bold fontSize="24px" textColor={BLOB_COLOR}>
        你是真菌生物!
      </Stack.Item>
      <Stack.Item>作为真菌的主脑，你可以控制整片真菌.</Stack.Item>
      <Stack.Item>
        你的真菌试剂为:{' '}
        <span
          style={{
            color,
          }}
        >
          {name}
        </span>
      </Stack.Item>
      <Stack.Item>
        {' '}
        <span
          style={{
            color,
          }}
        >
          {name}
        </span>{' '}
        {description}
      </Stack.Item>
      {effects && (
        <Stack.Item>
          The{' '}
          <span
            style={{
              color,
            }}
          >
            {name}
          </span>{' '}
          {effects}
        </Stack.Item>
      )}
    </Stack>
  );
};

const Basics = (props) => {
  return (
    <Collapsible title="基本事项">
      <LabeledList>
        <LabeledList.Item label="攻击">
          真菌体可以扩张，这将攻击该地块上的人类以及物件，清理完成后即可布下真菌体.
        </LabeledList.Item>
        <LabeledList.Item label="放置">
          你能通过右下角按钮手动放置你的真菌体核心.
        </LabeledList.Item>
        <LabeledList.Item label="HUD">
          除了HUD上的按键，还有一些快捷键可以用来加速扩张和防御.
        </LabeledList.Item>
        <LabeledList.Item label="快捷键">
          左键单击 = 扩张真菌体 | 鼠标中键 = 聚集孢子 | Ctrl+左键 = 形成真菌墙 |
          Alt+左键 = 移除真菌体
        </LabeledList.Item>
        <LabeledList.Item label="交流">
          通过说话能够向其他真菌主脑传达消息，让你们可以进行配合.
        </LabeledList.Item>
      </LabeledList>
    </Collapsible>
  );
};

const Minions = (props) => {
  return (
    <Collapsible title="侍从">
      <LabeledList>
        <LabeledList.Item label="真菌兽">
          难杀、强力并且拥有感知的防御单位，需要在工厂真菌体上花费资源来生产.
          完成生产的工厂真菌体在一段时间内将变得虚弱，无法生产孢子.
        </LabeledList.Item>
        <LabeledList.Item label="真菌孢子">
          由工厂真菌体自动生产，个体脆弱但可以通过大量集结来战胜敌人.
          它们也会自动攻击工厂真菌体附近的敌人，并且能够附着尸体并转化成真菌僵尸.
        </LabeledList.Item>
      </LabeledList>
    </Collapsible>
  );
};

const Structures = (props) => {
  return (
    <Collapsible title="构造">
      <Box>
        普通的真菌体可以扩张你的地盘，它们可以被升级为特殊真菌体，执行某些特殊功能.
      </Box>
      <br />
      <Box>普通真菌体有以下的升级类型:</Box>
      <Divider />
      <LabeledList>
        <LabeledList.Item label="真菌墙">
          坚固且昂贵的真菌体，能造成更多的伤害.
          它们防火、隔绝空气，像一道墙一样可以阻挡火焰等威胁.
          坚固真菌墙再升级会成为反光真菌墙，能够反射光束,
          但代价是坚固真菌墙的一些额外生命值.
        </LabeledList.Item>
        <LabeledList.Item label="资源真菌体">
          这种真菌体可以为你提供更多的资源，必须放置在真菌体节点或核心附近.
        </LabeledList.Item>
        <LabeledList.Item label="工厂真菌体">
          自动生产真菌孢子或生产其他真菌生物攻击附近的敌人，必须放置在真菌体节点或核心附近.
        </LabeledList.Item>
        <LabeledList.Item label="真菌体节点">
          如同核心一样会自动向附近扩张的真菌体节点，它可以激活资源真菌体和工厂真菌体.
        </LabeledList.Item>
      </LabeledList>
    </Collapsible>
  );
};

const ObjectiveDisplay = (props) => {
  const { data } = useBackend<Data>();
  const { color, objectives } = data;

  return (
    <Collapsible title="目标">
      <LabeledList>
        {objectives.map(({ explanation }, index) => (
          <LabeledList.Item
            color={color ?? 'white'}
            key={index}
            label={(index + 1).toString()}
          >
            {explanation}
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Collapsible>
  );
};
