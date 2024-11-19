import { useBackend, useSharedState } from '../backend';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
  Tabs,
} from '../components';
import { NtosWindow } from '../layouts';

export const NtosCyborgRemoteMonitor = (props) => {
  return (
    <NtosWindow width={600} height={800}>
      <NtosWindow.Content>
        <NtosCyborgRemoteMonitorContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const ProgressSwitch = (param) => {
  switch (param) {
    case -1:
      return '_';
    case 0:
      return '连接中';
    case 25:
      return '开始传输';
    case 50:
      return '下载中';
    case 75:
      return '下载中';
    case 100:
      return '格式化';
  }
};

export const NtosCyborgRemoteMonitorContent = (props) => {
  const { act, data } = useBackend();
  const [tab_main, setTab_main] = useSharedState('tab_main', 1);
  const { card, cyborgs = [], DL_progress } = data;
  const storedlog = data.borglog || [];

  if (!cyborgs.length) {
    return <NoticeBox>未检测到赛博单位.</NoticeBox>;
  }

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Tabs>
          <Tabs.Tab
            icon="robot"
            lineHeight="23px"
            selected={tab_main === 1}
            onClick={() => setTab_main(1)}
          >
            赛博
          </Tabs.Tab>
          <Tabs.Tab
            icon="clipboard"
            lineHeight="23px"
            selected={tab_main === 2}
            onClick={() => setTab_main(2)}
          >
            存储日志文件
          </Tabs.Tab>
        </Tabs>
      </Stack.Item>
      {tab_main === 1 && (
        <>
          {!card && (
            <Stack.Item>
              <NoticeBox>某些功能需要ID卡登录.</NoticeBox>
            </Stack.Item>
          )}
          <Stack.Item grow={1}>
            <Section fill scrollable>
              {cyborgs.map((cyborg) => (
                <Section
                  key={cyborg.ref}
                  title={cyborg.name}
                  buttons={
                    <Button
                      icon="terminal"
                      content="发送消息"
                      color="blue"
                      disabled={!card}
                      onClick={() =>
                        act('messagebot', {
                          ref: cyborg.ref,
                        })
                      }
                    />
                  }
                >
                  <LabeledList>
                    <LabeledList.Item label="状态">
                      <Box
                        color={
                          cyborg.status
                            ? 'bad'
                            : cyborg.locked_down
                              ? 'average'
                              : 'good'
                        }
                      >
                        {cyborg.status
                          ? '未响应'
                          : cyborg.locked_down
                            ? '锁定'
                            : cyborg.shell_discon
                              ? '运转正常/连接断开'
                              : '运转正常'}
                      </Box>
                    </LabeledList.Item>
                    <LabeledList.Item label="情况">
                      <Box
                        color={
                          cyborg.integ <= 25
                            ? 'bad'
                            : cyborg.integ <= 75
                              ? 'average'
                              : 'good'
                        }
                      >
                        {cyborg.integ === 0
                          ? '硬性故障'
                          : cyborg.integ <= 25
                            ? '功能下线'
                            : cyborg.integ <= 75
                              ? '功能受损'
                              : '功能正常'}
                      </Box>
                    </LabeledList.Item>
                    <LabeledList.Item label="充能">
                      <Box
                        color={
                          cyborg.charge <= 30
                            ? 'bad'
                            : cyborg.charge <= 70
                              ? 'average'
                              : 'good'
                        }
                      >
                        {typeof cyborg.charge === 'number'
                          ? cyborg.charge + '%'
                          : '未找到'}
                      </Box>
                    </LabeledList.Item>
                    <LabeledList.Item label="模式">
                      {cyborg.module}
                    </LabeledList.Item>
                    <LabeledList.Item label="升级">
                      {cyborg.upgrades}
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              ))}
            </Section>
          </Stack.Item>
        </>
      )}
      {tab_main === 2 && (
        <>
          <Stack.Item>
            <Section>
              扫描赛博以下载存储日志.
              <ProgressBar value={DL_progress / 100}>
                {ProgressSwitch(DL_progress)}
              </ProgressBar>
            </Section>
          </Stack.Item>
          <Stack.Item grow={1}>
            <Section fill scrollable backgroundColor="black">
              {storedlog.map((log) => (
                <Box mb={1} key={log} color="green">
                  {log}
                </Box>
              ))}
            </Section>
          </Stack.Item>
        </>
      )}
    </Stack>
  );
};
