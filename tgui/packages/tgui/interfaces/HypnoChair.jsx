import { useBackend } from '../backend';
import { Button, Icon, Input, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const HypnoChair = (props) => {
  const { act, data } = useBackend();
  return (
    <Window width={375} height={480}>
      <Window.Content>
        <Section title="机器信息" backgroundColor="#450F44">
          强化审讯室的设计目的是诱导受试者进入深度恍惚状态. 一旦
          程序完成，通过说出植入的触发短语，受试者将能够立即表现出完全的服从和诚实.
        </Section>
        <Section title="受试者信息" textAlign="center">
          <LabeledList>
            <LabeledList.Item label="姓名">
              {data.occupant.name ? data.occupant.name : '舱内无人'}
            </LabeledList.Item>
            {!!data.occupied && (
              <LabeledList.Item
                label="状况"
                color={
                  data.occupant.stat === 0
                    ? 'good'
                    : data.occupant.stat === 1
                      ? 'average'
                      : 'bad'
                }
              >
                {data.occupant.stat === 0
                  ? '意识清醒'
                  : data.occupant.stat === 1
                    ? '无意识'
                    : '死亡'}
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>
        <Section title="操作面板" textAlign="center">
          <LabeledList>
            <LabeledList.Item label="舱门">
              <Button
                icon={data.open ? 'unlock' : 'lock'}
                color={data.open ? 'default' : 'red'}
                content={data.open ? '开启' : '关闭'}
                onClick={() => act('door')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="触发短语">
              <Input
                value={data.trigger}
                onChange={(e, value) =>
                  act('set_phrase', {
                    phrase: value,
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="审讯">
              <Button
                icon="code-branch"
                content={data.interrogating ? '中断审讯' : '开始强化审讯'}
                onClick={() => act('interrogate')}
              />
              {data.interrogating === 1 && (
                <Icon name="cog" color="orange" spin />
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
