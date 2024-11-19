import { BlockQuote, LabeledList, Section, Stack } from '../components';
import { Window } from '../layouts';
import { Rules } from './AntagInfoRules'; // SKYRAT EDIT ADDITION

const tipstyle = {
  color: 'white',
};

const noticestyle = {
  color: 'lightblue',
};

export const AntagInfoNightmare = (props) => {
  return (
    <Window width={620} height={380}>
      <Window.Content backgroundColor="#0d0d0d">
        <Stack fill>
          <Stack.Item width="46.2%">
            <Section fill>
              <Stack vertical fill>
                <Stack.Item fontSize="25px">你是只夜魇.</Stack.Item>
                <Stack.Item>
                  <BlockQuote>
                    你是来自遥远星辰之外的生物，在黑暗中拥有难以置信的强大力量，
                    几乎不可战胜. 然而不幸的是，你会在光芒中枯萎燃烧. 你必须使用
                    <span style={noticestyle}>&ensp;light eater</span>{' '}
                    来熄灭站点光源，让狩猎更加方便.
                  </BlockQuote>
                </Stack.Item>
                <Stack.Divider />
                <Stack.Item textColor="label">
                  <span style={tipstyle}>提示 #1:&ensp;</span>
                  经常移动，空间站在发现你后会进行追捕，所以不要在一个地方呆太久.
                  <br />
                  <span style={tipstyle}>提示 #2:&ensp;</span>
                  机智地挑起不对等战斗，你在一对一的情况下非常强大，利用好这份能力.
                  越是艰苦战斗，就越难保持黑暗.
                  <br />
                  <span style={tipstyle}>提示 #3:&ensp;</span>
                  尽可能的完全摧毁APC，而不是可以方便修理的灯，APC修理起来很困难.
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item width="53%">
            <Section fill title="力量">
              <LabeledList>
                <LabeledList.Item label="影中起舞">
                  在阴影中的你完全免疫所有远程攻击，同时能恢复生命值.
                </LabeledList.Item>
                <LabeledList.Item label="暗影步伐">
                  你能在黑暗中无视地形地穿行，但光会让你显形.
                </LabeledList.Item>
                <LabeledList.Item label="黑暗之心">
                  你的心接纳黑暗，如果在黑暗中孤独死去，那么最终也能在黑暗中独自复活.
                </LabeledList.Item>
                <LabeledList.Item label="light eater">
                  你的扭曲附肢，它会吞噬掉所接触的光，无论是来自人还是物.
                  潜行7秒后，刺杀敌人将造成昏迷和额外伤害.
                </LabeledList.Item>
              </LabeledList>
            </Section>
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
