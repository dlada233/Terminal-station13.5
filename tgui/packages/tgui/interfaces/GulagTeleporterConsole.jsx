import { useBackend } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';

export const GulagTeleporterConsole = (props) => {
  const { act, data } = useBackend();
  const {
    teleporter,
    teleporter_lock,
    teleporter_state_open,
    teleporter_location,
    beacon,
    beacon_location,
    id,
    id_name,
    can_teleport,
    goal = 0,
    prisoner = {},
  } = data;
  return (
    <Window width={350} height={295}>
      <Window.Content>
        <Section
          title="传送终端"
          buttons={
            <>
              <Button
                content={teleporter_state_open ? '开启' : '关闭'}
                disabled={teleporter_lock}
                selected={teleporter_state_open}
                onClick={() => act('toggle_open')}
              />
              <Button
                icon={teleporter_lock ? 'lock' : 'unlock'}
                content={teleporter_lock ? '已锁定' : '已解锁'}
                selected={teleporter_lock}
                disabled={teleporter_state_open}
                onClick={() => act('teleporter_lock')}
              />
            </>
          }
        >
          <LabeledList>
            <LabeledList.Item
              label="传送单元"
              color={teleporter ? 'good' : 'bad'}
              buttons={
                !teleporter && (
                  <Button
                    content="重连"
                    onClick={() => act('scan_teleporter')}
                  />
                )
              }
            >
              {teleporter ? teleporter_location : '未连接'}
            </LabeledList.Item>
            <LabeledList.Item
              label="接收信标"
              color={beacon ? 'good' : 'bad'}
              buttons={
                !beacon && (
                  <Button content="重连" onClick={() => act('scan_beacon')} />
                )
              }
            >
              {beacon ? beacon_location : '未连接'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="囚犯信息">
          <LabeledList>
            <LabeledList.Item label="囚犯ID">
              <Button
                fluid
                content={id ? id_name : '无ID'}
                onClick={() => act('handle_id')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="目标点数">
              <NumberInput
                value={goal}
                step={1}
                width="48px"
                minValue={1}
                maxValue={1000}
                onChange={(value) => act('set_goal', { value })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="占用">
              {prisoner.name || '未被占用'}
            </LabeledList.Item>
            <LabeledList.Item label="囚犯状况">
              {prisoner.crimstat || '无状况'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Button
          fluid
          content="处理囚犯"
          disabled={!can_teleport}
          textAlign="center"
          color="bad"
          onClick={() => act('teleport')}
        />
      </Window.Content>
    </Window>
  );
};
