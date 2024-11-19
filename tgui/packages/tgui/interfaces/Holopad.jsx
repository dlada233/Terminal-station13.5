import { useBackend } from '../backend';
import {
  Box,
  Button,
  Flex,
  Icon,
  LabeledList,
  Modal,
  NoticeBox,
  Section,
} from '../components';
import { Window } from '../layouts';

export const Holopad = (props) => {
  const { act, data } = useBackend();
  const { calling } = data;
  return (
    <Window width={440} height={245}>
      {!!calling && (
        <Modal fontSize="36px" fontFamily="monospace">
          <Flex align="center">
            <Flex.Item mr={2} mt={2}>
              <Icon name="phone-alt" rotation={25} />
            </Flex.Item>
            <Flex.Item mr={2}>{'呼叫中...'}</Flex.Item>
          </Flex>
          <Box mt={2} textAlign="center" fontSize="24px">
            <Button
              lineHeight="40px"
              icon="times"
              content="挂断"
              color="bad"
              onClick={() => act('hang_up')}
            />
          </Box>
        </Modal>
      )}
      <Window.Content scrollable>
        <HolopadContent />
      </Window.Content>
    </Window>
  );
};

const HolopadContent = (props) => {
  const { act, data } = useBackend();
  const {
    on_network,
    on_cooldown,
    allowed,
    disk,
    disk_record,
    replay_mode,
    loop_mode,
    record_mode,
    holo_calls = [],
  } = data;
  return (
    <>
      <Section
        title="全息投影平台"
        buttons={
          <Button
            icon="bell"
            content={on_cooldown ? '已请求AI显像' : '请求AI显像'}
            disabled={!on_network || on_cooldown}
            onClick={() => act('AIrequest')}
          />
        }
      >
        <LabeledList>
          <LabeledList.Item label="通讯">
            <Button
              icon="phone-alt"
              content={allowed ? '连接到投影平台' : '拨打至其他平台'}
              disabled={!on_network}
              onClick={() => act('holocall', { headcall: allowed })}
            />
          </LabeledList.Item>
          {holo_calls.map((call) => {
            return (
              <LabeledList.Item
                label={call.connected ? '当前通话' : '传入通话'}
                key={call.ref}
              >
                <Button
                  icon={call.connected ? 'phone-slash' : 'phone-alt'}
                  content={
                    call.connected
                      ? '断开呼叫 ' + call.caller
                      : '接听呼叫 ' + call.caller
                  }
                  color={call.connected ? 'bad' : 'good'}
                  disabled={!on_network}
                  onClick={() =>
                    act(call.connected ? 'disconnectcall' : 'connectcall', {
                      holopad: call.ref,
                    })
                  }
                />
              </LabeledList.Item>
            );
          })}
          {holo_calls.filter((call) => !call.connected).length > 0 && (
            <LabeledList.Item key="reject">
              <Button
                icon="phone-slash"
                content="拒绝来电"
                color="bad"
                onClick={() => act('rejectall')}
              />
            </LabeledList.Item>
          )}
        </LabeledList>
      </Section>
      <Section
        title="投影软盘"
        buttons={
          <Button
            icon="eject"
            content="取出"
            disabled={!disk || replay_mode || record_mode}
            onClick={() => act('disk_eject')}
          />
        }
      >
        {(!disk && <NoticeBox>No holodisk</NoticeBox>) || (
          <LabeledList>
            <LabeledList.Item label="软盘播放器">
              <Button
                icon={replay_mode ? 'pause' : 'play'}
                content={replay_mode ? '停止' : '重播'}
                selected={replay_mode}
                disabled={record_mode || !disk_record}
                onClick={() => act('replay_mode')}
              />
              <Button
                icon={'sync'}
                content={loop_mode ? '循环中' : '循环'}
                selected={loop_mode}
                disabled={record_mode || !disk_record}
                onClick={() => act('loop_mode')}
              />
              <Button
                icon="exchange-alt"
                content="更改偏移"
                disabled={!replay_mode}
                onClick={() => act('offset')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="录像机">
              <Button
                icon={record_mode ? 'pause' : 'video'}
                content={record_mode ? '结束录像' : '录像'}
                selected={record_mode}
                disabled={(disk_record && !record_mode) || replay_mode}
                onClick={() => act('record_mode')}
              />
              <Button
                icon="trash"
                content="清除录像"
                color="bad"
                disabled={!disk_record || replay_mode || record_mode}
                onClick={() => act('record_clear')}
              />
            </LabeledList.Item>
          </LabeledList>
        )}
      </Section>
    </>
  );
};
