import { useBackend } from '../backend';
import { Button, Icon, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const ImplantChair = (props) => {
  const { act, data } = useBackend();
  return (
    <Window width={375} height={280}>
      <Window.Content>
        <Section title="使用者信息" textAlign="center">
          <LabeledList>
            <LabeledList.Item label="姓名">
              {data.occupant.name || '舱内无人'}
            </LabeledList.Item>
            {!!data.occupied && (
              <LabeledList.Item
                label="状态"
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
                content={data.open ? '打开' : '关闭'}
                onClick={() => act('door')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="植入使用者">
              <Button
                icon="code-branch"
                content={data.ready ? data.special_name || '植入' : '重装中'}
                onClick={() => act('implant')}
              />
              {data.ready === 0 && <Icon name="cog" color="orange" spin />}
            </LabeledList.Item>
            <LabeledList.Item label="植入物剩余">
              {data.ready_implants}
              {data.replenishing === 1 && <Icon name="sync" color="red" spin />}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
