import { useBackend, useSharedState } from '../backend';
import {
  Box,
  Button,
  Icon,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from '../components';
import { NtosWindow } from '../layouts';

export const NtosNetMonitor = (props) => {
  const { act, data } = useBackend();
  const [tab_main, setTab_main] = useSharedState('tab_main', 1);
  const {
    ntnetrelays,
    idsalarm,
    idsstatus,
    ntnetlogs = [],
    tablets = [],
  } = data;

  return (
    <NtosWindow>
      <NtosWindow.Content scrollable>
        <Stack.Item>
          <Tabs>
            <Tabs.Tab
              icon="network-wired"
              lineHeight="23px"
              selected={tab_main === 1}
              onClick={() => setTab_main(1)}
            >
              NtNet
            </Tabs.Tab>
            <Tabs.Tab
              icon="tablet"
              lineHeight="23px"
              selected={tab_main === 2}
              onClick={() => setTab_main(2)}
            >
              平板设备 ({tablets.length})
            </Tabs.Tab>
          </Tabs>
        </Stack.Item>
        {tab_main === 1 && (
          <Stack.Item>
            <MainPage
              ntnetrelays={ntnetrelays}
              idsalarm={idsalarm}
              idsstatus={idsstatus}
              ntnetlogs={ntnetlogs}
            />
          </Stack.Item>
        )}
        {tab_main === 2 && (
          <Stack.Item>
            <TabletPage tablets={tablets} />
          </Stack.Item>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const MainPage = (props) => {
  const { ntnetrelays, idsalarm, idsstatus, ntnetlogs = [] } = props;
  const { act, data } = useBackend();

  return (
    <Section>
      <NoticeBox>
        警告: 在使用无线设备时禁用无线发射器可能会导致您无法重新启用它们！
      </NoticeBox>
      <Section title="无线连接">
        {ntnetrelays.map((relay) => (
          <Section
            key={relay.ref}
            title={relay.name}
            buttons={
              <Button.Confirm
                color={relay.is_operational ? 'good' : 'bad'}
                content={relay.is_operational ? '已开启' : '已关闭'}
                onClick={() =>
                  act('toggle_relay', {
                    ref: relay.ref,
                  })
                }
              />
            }
          />
        ))}
      </Section>
      <Section title="安全系统">
        {!!idsalarm && (
          <>
            <NoticeBox>检测到网络入侵</NoticeBox>
            <Box italics>网络中检测到异常活动. 查看系统日志了解更多信息</Box>
          </>
        )}
        <LabeledList>
          <LabeledList.Item
            label="IDS状态"
            buttons={
              <>
                <Button
                  icon={idsstatus ? 'power-off' : 'times'}
                  content={idsstatus ? '已开启' : '已关闭'}
                  selected={idsstatus}
                  onClick={() => act('toggleIDS')}
                />
                <Button
                  icon="sync"
                  content="Reset"
                  color="bad"
                  onClick={() => act('resetIDS')}
                />
              </>
            }
          />
        </LabeledList>
        <Section
          title="系统日志"
          buttons={
            <Button.Confirm
              icon="trash"
              content="清除日志"
              onClick={() => act('purgelogs')}
            />
          }
        >
          {ntnetlogs.map((log) => (
            <Box key={log.entry} className="candystripe">
              {log.entry}
            </Box>
          ))}
        </Section>
      </Section>
    </Section>
  );
};

const TabletPage = (props) => {
  const { tablets } = props;
  const { act, data } = useBackend();
  if (!tablets.length) {
    return <NoticeBox>未检测到平板设备.</NoticeBox>;
  }
  return (
    <Section>
      <Stack vertical mt={1}>
        <Section fill textAlign="center">
          <Icon name="comment" mr={1} />
          激活平板设备
        </Section>
      </Stack>
      <Stack vertical mt={1}>
        <Section fill>
          <Stack vertical>
            {tablets.map((tablet) => (
              <Section
                key={tablet.ref}
                title={tablet.name}
                buttons={
                  <Button.Confirm
                    icon={tablet.enabled_spam ? 'unlock' : 'lock'}
                    color={tablet.enabled_spam ? 'good' : 'default'}
                    content={
                      tablet.enabled_spam ? '限制群体PDA' : '允许群体PDA'
                    }
                    onClick={() =>
                      act('toggle_mass_pda', {
                        ref: tablet.ref,
                      })
                    }
                  />
                }
              />
            ))}
          </Stack>
        </Section>
      </Stack>
    </Section>
  );
};
