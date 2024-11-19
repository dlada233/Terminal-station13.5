import { decodeHtmlEntities } from 'common/string';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Dropdown,
  Icon,
  NoticeBox,
  RestrictedInput,
  Section,
  Stack,
  Table,
  TextArea,
  Tooltip,
} from 'tgui/components';
import { Window } from 'tgui/layouts';

type HoloPayData = {
  available_logos: string[];
  balance: number;
  description: string;
  force_fee: number;
  max_fee: number;
  name: string;
  owner: string;
  shop_logo: string;
  user: { name: string; balance: number };
};

const COPYRIGHT_SCROLLER = `Nanotrasen (c) 2525-2562. 一经出售，概不退款.
不可挪用部门资金支付. 欲了解更多信息，请询问人事部长.
保留所有权利. 所有商标均为其各自所有者财产.`;

export const HoloPay = (props) => {
  const { data } = useBackend<HoloPayData>();
  const { owner } = data;
  const [setupMode, setSetupMode] = useState(false);
  // User clicked the "Setup" or "Done" button.
  const onClick = () => {
    setSetupMode(!setupMode);
  };

  return (
    <Window height={300} width={250} title="全息支付">
      <Window.Content>
        {!owner ? (
          <NoticeBox>错误! 请先刷ID卡.</NoticeBox>
        ) : (
          <Stack fill vertical>
            <Stack.Item>
              <AccountDisplay onClick={onClick} />
            </Stack.Item>
            <Stack.Item grow>
              {!setupMode ? (
                <TerminalDisplay onClick={onClick} />
              ) : (
                <SetupDisplay onClick={onClick} />
              )}
            </Stack.Item>
          </Stack>
        )}
      </Window.Content>
    </Window>
  );
};

/**
 * Displays the current user's bank information (if any)
 */
const AccountDisplay = (props) => {
  const { data } = useBackend<HoloPayData>();
  const { user } = data;
  if (!user) {
    return <NoticeBox>错误! 未找到账户.</NoticeBox>;
  }

  return (
    <Section>
      <Table>
        <Table.Row>
          <Table.Cell>
            <Box color="label">
              <Icon name="money-check" color="label" mr={1} />
              {user?.name}
            </Box>
          </Table.Cell>
          <Table.Cell collapsing>
            <Box color="good">
              {user?.balance} cr <Icon color="gold" name="coins" />
            </Box>
          </Table.Cell>
        </Table.Row>
      </Table>
    </Section>
  );
};

/**
 * Displays the payment processor. This is the main display.
 * Shows icon, name, payment button.
 */
const TerminalDisplay = (props) => {
  const { act, data } = useBackend<HoloPayData>();
  const { description, force_fee, name, owner, user, shop_logo } = data;
  const { onClick } = props;
  const is_owner = owner === user?.name;
  const cannot_pay =
    is_owner || !user || user?.balance < 1 || user?.balance < force_fee;

  return (
    <Section
      buttons={
        is_owner && (
          <Button icon="edit" onClick={onClick}>
            设置
          </Button>
        )
      }
      fill
      title="终端"
    >
      <Stack fill vertical>
        <Stack.Item align="center">
          <Icon color="good" name={shop_logo} size={5} />
        </Stack.Item>
        <Stack.Item grow textAlign="center">
          <Tooltip content={description} position="bottom">
            <Box color="label" fontSize="17px" overflow="hidden">
              {decodeHtmlEntities(name)}
            </Box>
          </Tooltip>
        </Stack.Item>
        <Stack.Item>
          {force_fee ? (
            <Button.Confirm
              content={
                <>
                  <Icon name="coins" />
                  支付 {force_fee + ' cr'}
                </>
              }
              disabled={cannot_pay}
              fluid
              height="2rem"
              onClick={() => act('pay')}
              pt={0.2}
              textAlign="center"
            />
          ) : (
            <Button
              content={
                <>
                  <Icon name="coins" />
                  支付
                </>
              }
              disabled={cannot_pay}
              fluid
              height="2rem"
              onClick={() => act('pay')}
              pt={0.2}
              textAlign="center"
            />
          )}
        </Stack.Item>
        <Stack.Item>
          {/* @ts-ignore */}
          <marquee scrollamount="2">
            <Box color="darkgray" fontSize="8px">
              {COPYRIGHT_SCROLLER}
            </Box>
            {/* @ts-ignore */}
          </marquee>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

/**
 * User has clicked "setup" button. Changes vars on the holopay.
 */
const SetupDisplay = (props) => {
  const { act, data } = useBackend<HoloPayData>();
  const { available_logos = [], force_fee, max_fee, name, shop_logo } = data;
  const { onClick } = props;

  return (
    <Section
      buttons={
        <Button
          icon="check"
          onClick={() => {
            act('done');
            onClick();
          }}
        >
          完成
        </Button>
      }
      fill
      scrollable
      title="设置"
    >
      <Stack fill vertical>
        <Stack.Item>
          <Box bold color="label">
            商标
          </Box>
          <Dropdown
            onSelected={(value) => act('logo', { logo: value })}
            options={available_logos}
            selected={shop_logo}
            width="100%"
          />
        </Stack.Item>
        <Stack.Item>
          <Box bold color="label">
            名称 (3 - 42字符)
          </Box>
          <TextArea
            fluid
            height="3rem"
            maxLength={42}
            onChange={(_, value) => {
              value?.length > 3 && act('rename', { name: value });
            }}
            placeholder={decodeHtmlEntities(name)}
          />
        </Stack.Item>
        <Stack.Item>
          <Tooltip content="设定固定费用，而非随意支付.">
            <Box bold color="label">
              固定费用
            </Box>
            <RestrictedInput
              fluid
              maxValue={max_fee}
              onChange={(_, value) => act('fee', { amount: value })}
              value={force_fee}
            />
          </Tooltip>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
