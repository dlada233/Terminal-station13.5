import { BlockQuote, Stack } from '../components';
import { Window } from '../layouts';
import { Rules } from './AntagInfoRules'; // SKYRAT EDIT ADDITION

const goodstyle = {
  color: 'lightgreen',
};

const badstyle = {
  color: 'red',
};

const noticestyle = {
  color: 'lightblue',
};

export const AntagInfoMorph = (props) => {
  return (
    <Window width={620} height={170} theme="abductor">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item fontSize="25px">你是拟态...</Stack.Item>
          <Stack.Item>
            <BlockQuote>
              ...一种能吃掉任何东西的变形怪物. 你可以用{' '}
              <span style={noticestyle}>
                &quot;拟态&quot; 能力拟态成任何你能看到的物体.
                Shift加左键对象可以快捷选中并进行拟态.
              </span>{' '}
              <span style={badstyle}>&ensp;拟态的过程会提醒附近的观察者.</span>{' '}
              当拟态时，你的移动速度更快，但无法攻击生物和吃掉东西, 此外
              <span style={badstyle}>
                &ensp;三格内的人如果检查你就会发现不可思议的错误.
              </span>{' '}
              你可以攻击任何物品或死亡生物来吃掉它们 -
              <span style={goodstyle}>&ensp;尸体能恢复你的生命值.</span>{' '}
              最后，你可以随时取消拟态，只需{' '}
              <span style={noticestyle}>
                对你自己使用 &quot;拟态&quot; 能力. Shift加左键的快捷键同样有效.
              </span>{' '}
            </BlockQuote>
          </Stack.Item>
          {/* SKYRAT EDIT ADDITION START */}
          <Stack.Item>
            <Rules />
          </Stack.Item>
          {/* SKYRAT EDIT ADDITION END */}
        </Stack>
      </Window.Content>
    </Window>
  );
};
