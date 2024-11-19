import { useBackend, useSharedState } from '../backend';
import {
  Box,
  Button,
  Flex,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from '../components';
import { Window } from '../layouts';

export const DopplerArray = (props) => {
  return (
    <Window width={650} height={320} resizable>
      <Window.Content>
        <DopplerArrayContent />
      </Window.Content>
    </Window>
  );
};

const DopplerArrayContent = (props) => {
  const { act, data } = useBackend();
  const { records = [], disk, storage } = data;
  const [activeRecordName, setActiveRecordName] = useSharedState(
    'activeRecordrecord',
    records[0]?.name,
  );
  const activeRecord = records.find((record) => {
    return record.name === activeRecordName;
  });
  const DopplerArrayFooter = (
    <Section title={disk ? disk + ' (' + storage + ')' : '未插入软盘'}>
      <Button
        textAlign="center"
        fluid
        icon="eject"
        content="取出软盘"
        disabled={!disk}
        onClick={() => act('eject_disk')}
      />
    </Section>
  );
  const DopplerArrayRecords = (
    <Section>
      <Stack>
        <Stack.Item mr={2}>
          <Tabs vertical>
            {records.map((record) => (
              <Tabs.Tab
                icon="file"
                key={record.name}
                selected={record.name === activeRecordName}
                onClick={() => setActiveRecordName(record.name)}
              >
                {record.name}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Stack.Item>
        {activeRecord ? (
          <Stack.Item>
            <Section
              title={activeRecord.name}
              buttons={
                <>
                  <Button.Confirm
                    icon="trash"
                    content="删除"
                    color="bad"
                    onClick={() =>
                      act('delete_record', {
                        ref: activeRecord.ref,
                      })
                    }
                  />
                  <Button
                    icon="floppy-disk"
                    content="储存"
                    disabled={!disk}
                    tooltip="将选中记录保存到已插入的数据软盘中."
                    tooltipPosition="bottom"
                    onClick={() =>
                      act('save_record', {
                        ref: activeRecord.ref,
                      })
                    }
                  />
                </>
              }
            >
              <LabeledList>
                <LabeledList.Item label="时间戳">
                  {activeRecord.timestamp}
                </LabeledList.Item>
                <LabeledList.Item label="坐标">
                  {activeRecord.coordinates}
                </LabeledList.Item>
                <LabeledList.Item label="位移">
                  {activeRecord.displacement} 秒
                </LabeledList.Item>
                <LabeledList.Item label="中心半径">
                  {activeRecord.factual_epicenter_radius}
                  {activeRecord.theory_epicenter_radius &&
                    ' (理论: ' + activeRecord.theory_epicenter_radius + ')'}
                </LabeledList.Item>
                <LabeledList.Item label="外半径">
                  {activeRecord.factual_outer_radius}
                  {activeRecord.theory_outer_radius &&
                    ' (理论: ' + activeRecord.theory_outer_radius + ')'}
                </LabeledList.Item>
                <LabeledList.Item label="冲击波半径">
                  {activeRecord.factual_shockwave_radius}
                  {activeRecord.theory_shockwave_radius &&
                    ' (理论: ' + activeRecord.theory_shockwave_radius + ')'}
                </LabeledList.Item>
                <LabeledList.Item label="可能原因">
                  {activeRecord.reaction_results.length
                    ? activeRecord.reaction_results.map((reaction_name) => (
                        <Box key={reaction_name}>{reaction_name}</Box>
                      ))
                    : '无信息可用'}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
        ) : (
          <Stack.Item grow={1} basis={0}>
            <NoticeBox>未选中记录</NoticeBox>
          </Stack.Item>
        )}
      </Stack>
    </Section>
  );
  return (
    <Flex direction="column" height="100%">
      <Flex.Item grow>
        {!records.length ? <NoticeBox>无记录</NoticeBox> : DopplerArrayRecords}
      </Flex.Item>
      <Flex.Item>{DopplerArrayFooter}</Flex.Item>
    </Flex>
  );
};
