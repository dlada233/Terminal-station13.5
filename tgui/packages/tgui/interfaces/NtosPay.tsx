import { useBackend } from '../backend';
import {
  Box,
  Button,
  Divider,
  Input,
  NoticeBox,
  RestrictedInput,
  Section,
  Stack,
  Table,
  Tooltip,
} from '../components';
import { NtosWindow } from '../layouts';

type Data = {
  name: string;
  owner_token: string;
  money: number;
  transaction_list: Transactions[];
  wanted_token: string;
};

type Transactions = {
  adjusted_money: number;
  reason: string;
};
let name_to_token, money_to_send, token;

export const NtosPay = (props) => {
  return (
    <NtosWindow width={495} height={655}>
      <NtosWindow.Content>
        <NtosPayContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const NtosPayContent = (props) => {
  const { data } = useBackend<Data>();
  const { name } = data;

  if (!name) {
    return (
      <NoticeBox>
        You need to insert your ID card into the card slot in order to use this
        application.
      </NoticeBox>
    );
  }

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Introduction />
      </Stack.Item>
      <Stack.Item>
        <TransferSection />
      </Stack.Item>
      <Stack.Item grow>
        <TransactionHistory />
      </Stack.Item>
    </Stack>
  );
};

/** Displays the user's name and balance. */
const Introduction = (props) => {
  const { data } = useBackend<Data>();
  const { name, owner_token, money } = data;
  return (
    <Section textAlign="center">
      <Table>
        <Table.Row>Hi, {name}.</Table.Row>
        <Table.Row>Your pay token is {owner_token}.</Table.Row>
        <Table.Row>
          Account balance: {money} credit{money === 1 ? '' : 's'}
        </Table.Row>
      </Table>
    </Section>
  );
};

/** Displays the transfer section. */
const TransferSection = (props) => {
  const { act, data } = useBackend<Data>();
  const { money, wanted_token } = data;

  return (
    <Stack>
      <Stack.Item>
        <Section title="转账">
          <Box>
            <Tooltip
              content="输入转账收款方的支付令牌."
              position="top"
            >
              <Input
                placeholder="支付令牌"
                width="190px"
                onChange={(e, value) => (token = value)}
              />
            </Tooltip>
          </Box>
          <Tooltip
            content="输入转出信用点的数额."
            position="top"
          >
            <RestrictedInput
              width="83px"
              minValue={1}
              maxValue={money}
              onChange={(_, value) => (money_to_send = value)}
              value={1}
            />
          </Tooltip>
          <Button
            content="转出信用点"
            onClick={() =>
              act('Transaction', {
                token: token,
                amount: money_to_send,
              })
            }
          />
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section title="获取令牌" width="270px" height="98px">
          <Box>
            <Input
              placeholder="户主全称."
              width="190px"
              onChange={(e, value) => (name_to_token = value)}
            />
            <Button
              content="获取"
              onClick={() =>
                act('GetPayToken', {
                  wanted_name: name_to_token,
                })
              }
            />
          </Box>
          <Divider hidden />
          <Box nowrap>{wanted_token}</Box>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

/** Displays the transaction history. */
const TransactionHistory = (props) => {
  const { data } = useBackend<Data>();
  const { transaction_list = [] } = data;

  return (
    <Section fill title="收支记录">
      <Section fill scrollable title={<TableHeaders />}>
        <Table>
          {transaction_list.map((log) => (
            <Table.Row
              key={log}
              className="candystripe"
              color={log.adjusted_money < 1 ? 'red' : 'green'}
            >
              <Table.Cell width="100px">
                {log.adjusted_money > 1 ? '+' : ''}
                {log.adjusted_money}
              </Table.Cell>
              <Table.Cell textAlign="center">{log.reason}</Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Section>
    </Section>
  );
};

/** Renders a set of sticky headers */
const TableHeaders = (props) => {
  return (
    <Table>
      <Table.Row>
        <Table.Cell color="label" width="100px">
          Amount
        </Table.Cell>
        <Table.Cell color="label" textAlign="center">
          Reason
        </Table.Cell>
      </Table.Row>
    </Table>
  );
};
