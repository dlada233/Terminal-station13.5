import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Flex,
  Grid,
  Icon,
  LabeledList,
  Modal,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tabs,
} from '../components';
import { FakeTerminal } from '../components/FakeTerminal';
import { NtosWindow } from '../layouts';

const CONTRACT_STATUS_INACTIVE = 1;
const CONTRACT_STATUS_ACTIVE = 2;
const CONTRACT_STATUS_BOUNTY_CONSOLE_ACTIVE = 3;
const CONTRACT_STATUS_EXTRACTING = 4;
const CONTRACT_STATUS_COMPLETE = 5;
const CONTRACT_STATUS_ABORTED = 6;

export const SyndContractor = (props) => {
  return (
    <NtosWindow width={500} height={600} theme="syndicate">
      <NtosWindow.Content scrollable>
        <SyndContractorContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const SyndContractorContent = (props) => {
  const { data, act } = useBackend();

  const terminalMessages = [
    '记录生物特征数据...',
    '分析嵌入式辛迪加信息...',
    '状态确认',
    '连接辛迪加数据库...',
    '等待响应...',
    '等待响应...',
    '等待响应...',
    '等待响应...',
    '等待响应...',
    '等待响应...',
    '收到响应, 应答 4851234...',
    '确认ACC ' + Math.round(Math.random() * 20000),
    '设置私人账户...',
    '已创建契约账户',
    '搜索可用契约...',
    '搜索可用契约...',
    '搜索可用契约...',
    '搜索可用契约...',
    '已找到契约',
    '欢迎，特工',
  ];

  const infoEntries = [
    'SyndTract v2.0',
    '',
    '我们已经确定了一些你所在区域内的高价值目标. ',
    '据信他们持有对我们组织来说极为重要的宝贵即时信息.',
    '',
    '下面列出的是所有你可以接取的契约. ',
    '你需要把目标带到指定地点，然后用上行链路与我们联系，',
    '我们会派出专门的回收单位进行回收.',
    '',
    '我们希望目标能活着送过来 - 但尸体也可以接受，只是你的报酬将因此减少. ',
    '一旦我们收到了目标，报酬就会立刻打给你，你在这个上行链路上可以随时领取，',
    '报酬以TC水晶形式支付，你拿到后可以将其存入其他的上行链路消费.',
    '',
    '最后，我们对送来的目标进行完必要的工作后就会要求空间站支付赎金，你也会得到',
    '赎金中的一部分. 当他们被赎回空间站的时候，你可能要注意不被他们认出来. ',
    '我们为你提供的契约装备里有一些可以帮助你隐藏身份.',
  ];

  const errorPane = !!data.error && (
    <Modal backgroundColor="red">
      <Flex align="center">
        <Flex.Item mr={2}>
          <Icon size={4} name="exclamation-triangle" />
        </Flex.Item>
        <Flex.Item mr={2} grow={1} textAlign="center">
          <Box width="260px" textAlign="left" minHeight="80px">
            {data.error}
          </Box>
          <Button content="Dismiss" onClick={() => act('PRG_clear_error')} />
        </Flex.Item>
      </Flex>
    </Modal>
  );

  if (!data.logged_in) {
    return (
      <Section minHeight="525px">
        <Box width="100%" textAlign="center">
          <Button
            content="注册用户"
            color="transparent"
            onClick={() => act('PRG_login')}
          />
        </Box>
        {!!data.error && <NoticeBox>{data.error}</NoticeBox>}
      </Section>
    );
  }

  if (data.logged_in && data.first_load) {
    return (
      <Box backgroundColor="rgba(0, 0, 0, 0.8)" minHeight="525px">
        <FakeTerminal
          allMessages={terminalMessages}
          finishedTimeout={3000}
          onFinished={() => act('PRG_set_first_load_finished')}
        />
      </Box>
    );
  }

  if (data.info_screen) {
    return (
      <>
        <Box backgroundColor="rgba(0, 0, 0, 0.8)" minHeight="500px">
          <FakeTerminal allMessages={infoEntries} linesPerSecond={10} />
        </Box>
        <Button
          fluid
          content="继续"
          color="transparent"
          textAlign="center"
          onClick={() => act('PRG_toggle_info')}
        />
      </>
    );
  }

  return (
    <>
      {errorPane}
      <SyndPane />
    </>
  );
};

export const StatusPane = (props) => {
  const { act, data } = useBackend();

  return (
    <Section
      title={
        <>
          契约特工状态
          <Button
            content="再次查看说明"
            color="transparent"
            mb={0}
            ml={1}
            onClick={() => act('PRG_toggle_info')}
          />
        </>
      }
      buttons={
        <Box bold mr={1}>
          {data.contract_rep} Rep
        </Box>
      }
    >
      <Stack>
        <Stack.Item grow>
          <LabeledList>
            <LabeledList.Item
              label="可领取TC"
              buttons={
                <Button
                  content="领取"
                  disabled={data.redeemable_tc <= 0}
                  onClick={() => act('PRG_redeem_TC')}
                />
              }
            >
              {String(data.redeemable_tc)}
            </LabeledList.Item>
            <LabeledList.Item label="挣得TC">
              {String(data.earned_tc)}
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
        <Stack.Item grow>
          <LabeledList>
            <LabeledList.Item label="契约完成">
              {String(data.contracts_completed)}
            </LabeledList.Item>
            <LabeledList.Item label="当前状态">激活</LabeledList.Item>
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const SyndPane = (props) => {
  const [tab, setTab] = useState(1);
  return (
    <>
      <StatusPane state={props.state} />
      <Tabs>
        <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>
          契约
        </Tabs.Tab>
        <Tabs.Tab selected={tab === 2} onClick={() => setTab(2)}>
          Hub
        </Tabs.Tab>
      </Tabs>
      {tab === 1 && <ContractsTab />}
      {tab === 2 && <HubTab />}
    </>
  );
};

const ContractsTab = (props) => {
  const { act, data } = useBackend();
  const contracts = data.contracts || [];
  return (
    <>
      <Section
        title="可接取契约"
        buttons={
          <Button
            content="呼叫回收舱"
            disabled={!data.ongoing_contract || data.extraction_enroute}
            onClick={() => act('PRG_call_extraction')}
          />
        }
      >
        {contracts.map((contract) => {
          if (
            data.ongoing_contract &&
            contract.status !== CONTRACT_STATUS_ACTIVE
          ) {
            return;
          }
          const active = contract.status > CONTRACT_STATUS_INACTIVE;
          if (contract.status >= CONTRACT_STATUS_COMPLETE) {
            return;
          }
          return (
            <Section
              key={contract.target}
              title={
                contract.target
                  ? `${contract.target} (${contract.target_rank})`
                  : '无效目标'
              }
              level={active ? 1 : 2}
              buttons={
                <>
                  <Box inline bold mr={1}>
                    {`${contract.payout} (+${contract.payout_bonus}) TC`}
                  </Box>
                  <Button
                    content={active ? '中止' : '接取'}
                    disabled={contract.extraction_enroute}
                    color={active && 'bad'}
                    onClick={() =>
                      act('PRG_contract' + (active ? '_abort' : '-accept'), {
                        contract_id: contract.id,
                      })
                    }
                  />
                </>
              }
            >
              <Grid>
                <Grid.Column>{contract.message}</Grid.Column>
                <Grid.Column size={0.5}>
                  <Box bold mb={1}>
                    回收位置:
                  </Box>
                  <Box>{contract.dropoff}</Box>
                </Grid.Column>
              </Grid>
            </Section>
          );
        })}
      </Section>
      <Section
        title="回收定位器"
        textAlign="center"
        opacity={data.ongoing_contract ? 100 : 0}
      >
        <Box bold>{data.dropoff_direction}</Box>
      </Section>
    </>
  );
};

const HubTab = (props) => {
  const { act, data } = useBackend();
  const contractor_hub_items = data.contractor_hub_items || [];
  return (
    <Section>
      {contractor_hub_items.map((item) => {
        const repInfo = item.cost ? item.cost + ' Rep' : '免费';
        const limited = item.limited !== -1;
        return (
          <Section
            key={item.name}
            title={item.name + ' - ' + repInfo}
            level={2}
            buttons={
              <>
                {limited && (
                  <Box inline bold mr={1}>
                    {item.limited}剩余
                  </Box>
                )}
                <Button
                  content="购买"
                  disabled={
                    data.contract_rep < item.cost ||
                    (limited && item.limited <= 0)
                  }
                  onClick={() =>
                    act('buy_hub', {
                      item: item.name,
                      cost: item.cost,
                    })
                  }
                />
              </>
            }
          >
            <Table>
              <Table.Row>
                <Table.Cell>
                  <Icon fontSize="60px" name={item.item_icon} />
                </Table.Cell>
                <Table.Cell verticalAlign="top">{item.desc}</Table.Cell>
              </Table.Row>
            </Table>
          </Section>
        );
      })}
    </Section>
  );
};
