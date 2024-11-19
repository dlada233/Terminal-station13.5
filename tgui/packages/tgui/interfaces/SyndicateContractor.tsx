import { BooleanLike } from 'common/react';

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
  Stack,
} from '../components';
import { FakeTerminal } from '../components/FakeTerminal';
import { NtosWindow } from '../layouts';

enum CONTRACT {
  Inactive = 1,
  Active = 2,
  Complete = 5,
}

type Data = {
  contracts_completed: number;
  contracts: ContractData[];
  dropoff_direction: string;
  earned_tc: number;
  error: string;
  extraction_enroute: BooleanLike;
  first_load: BooleanLike;
  info_screen: BooleanLike;
  logged_in: BooleanLike;
  ongoing_contract: BooleanLike;
  redeemable_tc: number;
};

type ContractData = {
  contract: string;
  dropoff: string;
  extraction_enroute: BooleanLike;
  id: number;
  message: string;
  payout_bonus: number;
  payout: number;
  status: number;
  target_rank: string;
  target: string;
};

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
] as const;

export function SyndicateContractor(props) {
  return (
    <NtosWindow width={500} height={600}>
      <NtosWindow.Content scrollable>
        <SyndicateContractorContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
}

function SyndicateContractorContent(props) {
  const { data, act } = useBackend<Data>();
  const { error, logged_in, first_load, info_screen } = data;

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
  ] as const;

  const errorPane = !!error && (
    <Modal backgroundColor="red">
      <Flex align="center">
        <Flex.Item mr={2}>
          <Icon size={4} name="exclamation-triangle" />
        </Flex.Item>
        <Flex.Item mr={2} grow={1} textAlign="center">
          <Box width="260px" textAlign="left" minHeight="80px">
            {error}
          </Box>
          <Button onClick={() => act('PRG_clear_error')}>Dismiss</Button>
        </Flex.Item>
      </Flex>
    </Modal>
  );

  if (!logged_in) {
    return (
      <Section minHeight="525px">
        <Box width="100%" textAlign="center">
          <Button color="transparent" onClick={() => act('PRG_login')}>
            注册用户
          </Button>
        </Box>
        {!!error && <NoticeBox>{error}</NoticeBox>}
      </Section>
    );
  }

  if (logged_in && first_load) {
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

  if (info_screen) {
    return (
      <>
        <Box backgroundColor="rgba(0, 0, 0, 0.8)" minHeight="500px">
          <FakeTerminal allMessages={infoEntries} linesPerSecond={10} />
        </Box>
        <Button
          fluid
          color="transparent"
          textAlign="center"
          onClick={() => act('PRG_toggle_info')}
        >
          继续
        </Button>
      </>
    );
  }

  return (
    <>
      {errorPane}
      <StatusPane state={props.state} />
      <ContractsTab />
    </>
  );
}

function StatusPane(props) {
  const { act, data } = useBackend<Data>();
  const { redeemable_tc, earned_tc, contracts_completed } = data;

  return (
    <Section
      buttons={
        <Button
          color="transparent"
          mb={0}
          ml={1}
          onClick={() => act('PRG_toggle_info')}
        >
          再次查看说明
        </Button>
      }
      title="契约特工状态"
    >
      <Stack>
        <Stack.Item grow>
          <LabeledList>
            <LabeledList.Item
              label="可领取TC"
              buttons={
                <Button
                  disabled={redeemable_tc <= 0}
                  onClick={() => act('PRG_redeem_TC')}
                >
                  领取
                </Button>
              }
            >
              {String(redeemable_tc)}
            </LabeledList.Item>
            <LabeledList.Item label="挣得TC">
              {String(earned_tc)}
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
        <Stack.Item grow>
          <LabeledList>
            <LabeledList.Item label="契约完成">
              {String(contracts_completed)}
            </LabeledList.Item>
            <LabeledList.Item label="当前状态">激活</LabeledList.Item>
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
}

function ContractsTab(props) {
  const { act, data } = useBackend<Data>();
  const {
    contracts = [],
    ongoing_contract,
    extraction_enroute,
    dropoff_direction,
  } = data;

  return (
    <>
      <Section
        title="可接取契约"
        buttons={
          <Button
            disabled={!ongoing_contract || !!extraction_enroute}
            onClick={() => act('PRG_call_extraction')}
          >
            呼叫回收舱
          </Button>
        }
      >
        {contracts.map((contract) => {
          if (ongoing_contract && contract.status !== CONTRACT.Active) {
            return;
          }
          const active = contract.status > CONTRACT.Inactive;
          if (contract.status >= CONTRACT.Complete) {
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
              buttons={
                <>
                  <Box inline bold mr={1}>
                    {`${contract.payout} (+${contract.payout_bonus}) TC`}
                  </Box>
                  <Button
                    disabled={!!contract.extraction_enroute}
                    color={active && 'bad'}
                    onClick={() =>
                      act('PRG_contract' + (active ? '_abort' : '-accept'), {
                        contract_id: contract.id,
                      })
                    }
                  >
                    {active ? '中止' : '接取'}
                  </Button>
                </>
              }
            >
              <Stack>
                <Stack.Item grow>{contract.message}</Stack.Item>
                <Stack.Item>
                  <Box bold mb={1}>
                    回收位置:
                  </Box>
                  <Box>{contract.dropoff}</Box>
                </Stack.Item>
              </Stack>
            </Section>
          );
        })}
      </Section>
      <Section
        title="回收定位器"
        textAlign="center"
        opacity={ongoing_contract ? 100 : 0}
      >
        <Box bold>{dropoff_direction}</Box>
      </Section>
    </>
  );
}
