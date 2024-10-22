import { useBackend } from '../backend';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

export const Apc = (props) => {
  return (
    <Window width={450} height={445}>
      <Window.Content scrollable>
        <ApcContent />
      </Window.Content>
    </Window>
  );
};

const powerStatusMap = {
  2: {
    color: 'good',
    externalPowerText: '外部供电',
    chargingText: '完全充电',
  },
  1: {
    color: 'average',
    externalPowerText: '低功率外部供电',
    chargingText: '充电中: ',
  },
  0: {
    color: 'bad',
    externalPowerText: '无外部供电',
    chargingText: '未充电',
  },
};

const malfMap = {
  1: {
    icon: 'terminal',
    content: '超驰覆盖中',
    action: 'hack',
  },
  2: {
    icon: 'caret-square-down',
    content: '分流核心程序',
    action: 'occupy',
  },
  3: {
    icon: 'caret-square-left',
    content: '返回主核心',
    action: 'deoccupy',
  },
  4: {
    icon: 'caret-square-down',
    content: '分流核心程序',
    action: 'occupy',
  },
};

const ApcContent = (props) => {
  const { act, data } = useBackend();
  const locked = data.locked && !data.siliconUser;
  const externalPowerStatus =
    powerStatusMap[data.externalPower] || powerStatusMap[0];
  const chargingStatus =
    powerStatusMap[data.chargingStatus] || powerStatusMap[0];
  const channelArray = data.powerChannels || [];
  const malfStatus = malfMap[data.malfStatus] || malfMap[0];
  const adjustedCellChange = data.powerCellStatus / 100;
  if (data.failTime > 0) {
    return (
      <NoticeBox info textAlign="center" mb={0}>
        <b>
          <h3>系统故障</h3>
        </b>
        I/O 监测器故障! <br />
        请等待系统重启.
        <br />
        重启软件将在 {data.failTime} 秒后可执行...
        <br />
        <br />
        <Button
          icon="sync"
          content="立刻重启"
          tooltip="重置面板."
          tooltipPosition="bottom"
          onClick={() => act('reboot')}
        />
      </NoticeBox>
    );
  }
  return (
    <>
      <InterfaceLockNoticeBox
        siliconUser={data.remoteAccess || data.siliconUser}
        preventLocking={data.remoteAccess}
      />
      <Section title="电源状态">
        <LabeledList>
          <LabeledList.Item
            label="电源线路"
            color={externalPowerStatus.color}
            buttons={
              <Button
                icon={data.isOperating ? 'power-off' : 'times'}
                content={data.isOperating ? '开' : '关'}
                selected={data.isOperating && !locked}
                disabled={locked}
                onClick={() => act('breaker')}
              />
            }
          >
            [ {externalPowerStatus.externalPowerText} ]
          </LabeledList.Item>
          <LabeledList.Item label="电池电量">
            <ProgressBar color="good" value={adjustedCellChange} />
          </LabeledList.Item>
          <LabeledList.Item
            label="充电模式"
            color={chargingStatus.color}
            buttons={
              <Button
                icon={data.chargeMode ? 'sync' : 'times'}
                content={data.chargeMode ? '自动' : '关闭'}
                disabled={locked}
                onClick={() => act('charge')}
              />
            }
          >
            [{' '}
            {chargingStatus.chargingText +
              (data.chargingStatus === 1 ? data.chargingPowerDisplay : '')}{' '}
            ]
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="供电支路">
        <LabeledList>
          {channelArray.map((channel) => {
            const { topicParams } = channel;
            return (
              <LabeledList.Item
                key={channel.title}
                label={channel.title}
                buttons={
                  <>
                    <Box
                      inline
                      mx={2}
                      color={channel.status >= 2 ? 'good' : 'bad'}
                    >
                      {channel.status >= 2 ? '开' : '关'}
                    </Box>
                    <Button
                      icon="sync"
                      content="自动"
                      selected={
                        !locked &&
                        (channel.status === 1 || channel.status === 3)
                      }
                      disabled={locked}
                      onClick={() => act('channel', topicParams.auto)}
                    />
                    <Button
                      icon="power-off"
                      content="开启"
                      selected={!locked && channel.status === 2}
                      disabled={locked}
                      onClick={() => act('channel', topicParams.on)}
                    />
                    <Button
                      icon="times"
                      content="关闭"
                      selected={!locked && channel.status === 0}
                      disabled={locked}
                      onClick={() => act('channel', topicParams.off)}
                    />
                  </>
                }
              >
                {channel.powerLoad}
              </LabeledList.Item>
            );
          })}
          <LabeledList.Item label="总负载">
            <b>{data.totalLoad}</b>
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section
        title="其他杂项"
        buttons={
          !!data.siliconUser && (
            <>
              {!!data.malfStatus && (
                <Button
                  icon={malfStatus.icon}
                  content={malfStatus.content}
                  color="bad"
                  onClick={() => act(malfStatus.action)}
                />
              )}
              <Button
                icon="lightbulb-o"
                content="超载"
                onClick={() => act('overload')}
              />
            </>
          )
        }
      >
        <LabeledList>
          <LabeledList.Item
            label="面板盖锁"
            buttons={
              <Button
                tooltip="APC面板盖是否可被用撬棍撬开."
                icon={data.coverLocked ? 'lock' : 'unlock'}
                content={data.coverLocked ? '闭合' : '解锁'}
                disabled={locked}
                onClick={() => act('cover')}
              />
            }
          />
          <LabeledList.Item
            label="应急照明"
            buttons={
              <Button
                tooltip="当没有供电时，照明光源使用内部电池."
                icon="lightbulb-o"
                content={data.emergencyLights ? '开启' : '关闭'}
                disabled={locked}
                onClick={() => act('emergency_lighting')}
              />
            }
          />
          <LabeledList.Item
            label="夜间照明"
            buttons={
              <Button
                tooltip="调暗灯光以降低功耗."
                icon="lightbulb-o"
                content={data.nightshiftLights ? '开启' : '关闭'}
                disabled={data.disable_nightshift_toggle}
                onClick={() => act('toggle_nightshift')}
              />
            }
          />
        </LabeledList>
      </Section>
    </>
  );
};
