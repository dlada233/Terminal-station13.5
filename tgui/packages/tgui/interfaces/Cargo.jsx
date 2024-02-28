import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';

import { useBackend, useSharedState } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  Flex,
  Icon,
  Input,
  LabeledList,
  NoticeBox,
  RestrictedInput,
  Section,
  Stack,
  Table,
  Tabs,
} from '../components';
import { formatMoney } from '../format';
import { Window } from '../layouts';

export const Cargo = (props) => {
  return (
    <Window width={800} height={750}>
      <Window.Content scrollable>
        <CargoContent />
      </Window.Content>
    </Window>
  );
};

export const CargoContent = (props) => {
  /* SKYRAT EDIT BELOW - ADDS act */
  const { act, data } = useBackend();
  /* SKYRAT EDIT END */
  const [tab, setTab] = useSharedState('tab', 'catalog');
  const { cart = [], requests = [], requestonly } = data;
  const cart_length = cart.reduce((total, entry) => total + entry.amount, 0);

  return (
    <Box>
      <CargoStatus />
      <Section fitted>
        <Tabs>
          <Tabs.Tab
            icon="list"
            selected={tab === 'catalog'}
            onClick={() => setTab('catalog')}
          >
            商品分类
          </Tabs.Tab>
          <Tabs.Tab
            icon="envelope"
            textColor={tab !== 'requests' && requests.length > 0 && 'yellow'}
            selected={tab === 'requests'}
            onClick={() => setTab('requests')}
          >
            订购请求 ({requests.length})
          </Tabs.Tab>
          <Tabs.Tab
            icon="clipboard-list"
            selected={tab === 'company_import_window'}
            onClick={() => act('company_import_window')}
          >
            公司进口
          </Tabs.Tab>
          {!requestonly && (
            <>
              <Tabs.Tab
                icon="shopping-cart"
                textColor={tab !== 'cart' && cart_length > 0 && 'yellow'}
                selected={tab === 'cart'}
                onClick={() => setTab('cart')}
              >
                商品结账 ({cart_length})
              </Tabs.Tab>
              <Tabs.Tab
                icon="question"
                selected={tab === 'help'}
                onClick={() => setTab('help')}
              >
                帮助
              </Tabs.Tab>
            </>
          )}
        </Tabs>
      </Section>
      {tab === 'catalog' && <CargoCatalog />}
      {tab === 'requests' && <CargoRequests />}
      {tab === 'cart' && <CargoCart />}
      {tab === 'help' && <CargoHelp />}
      {tab === 'company_import_window' && tab === 'catalog'}
    </Box>
  );
};

const CargoStatus = (props) => {
  const { act, data } = useBackend();
  const {
    department,
    grocery,
    away,
    docked,
    loan,
    loan_dispatched,
    location,
    message,
    points,
    requestonly,
    can_send,
  } = data;

  return (
    <Section
      title={department}
      buttons={
        <Box inline bold>
          <AnimatedNumber
            value={points}
            format={(value) => formatMoney(value)}
          />
          {' credits'}
        </Box>
      }
    >
      <LabeledList>
        <LabeledList.Item label="穿梭机">
          {(docked && !requestonly && can_send && (
            <Button
              color={(grocery && 'orange') || 'green'}
              content={location}
              tooltip={
                (grocery &&
                  'The kitchen is waiting for their grocery supply delivery!') ||
                ''
              }
              tooltipPosition="right"
              onClick={() => act('send')}
            />
          )) ||
            location}
        </LabeledList.Item>
        <LabeledList.Item label="中央指挥部信息">{message}</LabeledList.Item>
        {!!loan && !requestonly && (
          <LabeledList.Item label="Loan">
            {(!loan_dispatched && (
              <Button
                content="租借穿梭机"
                disabled={!(away && docked)}
                onClick={() => act('loan')}
              />
            )) || <Box color="bad">Loaned to Centcom</Box>}
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};

/**
 * Take entire supplies tree
 * and return a flat supply pack list that matches search,
 * sorted by name and only the first page.
 * @param {any[]} supplies Supplies list.
 * @param {string} search The search term
 * @returns {any[]} The flat list of supply packs.
 */
const searchForSupplies = (supplies, search) => {
  search = search.toLowerCase();

  return flow([
    (categories) => categories.flatMap((category) => category.packs),
    filter(
      (pack) =>
        pack.name?.toLowerCase().includes(search.toLowerCase()) ||
        pack.desc?.toLowerCase().includes(search.toLowerCase()),
    ),
    sortBy((pack) => pack.name),
    (packs) => packs.slice(0, 25),
  ])(supplies);
};

export const CargoCatalog = (props) => {
  const { express } = props;
  const { act, data } = useBackend();

  const { self_paid, app_cost } = data;

  const supplies = Object.values(data.supplies);
  const { amount_by_name = [], max_order } = data;

  const [activeSupplyName, setActiveSupplyName] = useSharedState(
    'supply',
    supplies[0]?.name,
  );

  const [searchText, setSearchText] = useSharedState('search_text', '');

  const activeSupply =
    activeSupplyName === 'search_results'
      ? { packs: searchForSupplies(supplies, searchText) }
      : supplies.find((supply) => supply.name === activeSupplyName);

  return (
    <Section
      title="Catalog"
      buttons={
        !express && (
          <>
            <CargoCartButtons />
            <Button.Checkbox
              ml={2}
              content="私人购买"
              checked={self_paid}
              onClick={() => act('toggleprivate')}
            />
          </>
        )
      }
    >
      <Flex>
        <Flex.Item ml={-1} mr={1}>
          <Tabs vertical>
            <Tabs.Tab
              key="search_results"
              selected={activeSupplyName === 'search_results'}
            >
              <Stack align="baseline">
                <Stack.Item>
                  <Icon name="search" />
                </Stack.Item>
                <Stack.Item grow>
                  <Input
                    fluid
                    placeholder="Search..."
                    value={searchText}
                    onInput={(e, value) => {
                      if (value === searchText) {
                        return;
                      }

                      if (value.length) {
                        // Start showing results
                        setActiveSupplyName('search_results');
                      } else if (activeSupplyName === 'search_results') {
                        // return to normal category
                        setActiveSupplyName(supplies[0]?.name);
                      }
                      setSearchText(value);
                    }}
                  />
                </Stack.Item>
              </Stack>
            </Tabs.Tab>
            {supplies.map((supply) => (
              <Tabs.Tab
                key={supply.name}
                selected={supply.name === activeSupplyName}
                onClick={() => {
                  setActiveSupplyName(supply.name);
                  setSearchText('');
                }}
              >
                {supply.name} ({supply.packs.length})
              </Tabs.Tab>
            ))}
          </Tabs>
        </Flex.Item>
        <Flex.Item grow={1} basis={0}>
          <Table>
            {activeSupply?.packs.map((pack) => {
              const tags = [];
              if (pack.small_item) {
                tags.push('Small');
              }
              if (pack.access) {
                tags.push('Restricted');
              }
              return (
                <Table.Row key={pack.name} className="candystripe">
                  <Table.Cell>{pack.name}</Table.Cell>
                  <Table.Cell collapsing color="label" textAlign="right">
                    {tags.join(', ')}
                  </Table.Cell>
                  <Table.Cell collapsing textAlign="right">
                    <Button
                      fluid
                      tooltip={pack.desc}
                      tooltipPosition="left"
                      disabled={(amount_by_name[pack.name] || 0) >= max_order}
                      onClick={() =>
                        act('add', {
                          id: pack.id,
                        })
                      }
                    >
                      {formatMoney(
                        (self_paid && !pack.goody) || app_cost
                          ? Math.round(pack.cost * 1.1)
                          : pack.cost,
                      )}
                      {' cr'}
                    </Button>
                  </Table.Cell>
                </Table.Row>
              );
            })}
          </Table>
        </Flex.Item>
      </Flex>
    </Section>
  );
};

const CargoRequests = (props) => {
  const { act, data } = useBackend();
  const { requestonly, can_send, can_approve_requests } = data;
  const requests = data.requests || [];
  // Labeled list reimplementation to squeeze extra columns out of it
  return (
    <Section
      title="Active Requests"
      buttons={
        !requestonly && (
          <Button
            icon="times"
            content="清除"
            color="transparent"
            onClick={() => act('denyall')}
          />
        )
      }
    >
      {requests.length === 0 && <Box color="good">No Requests</Box>}
      {requests.length > 0 && (
        <Table>
          {requests.map((request) => (
            <Table.Row key={request.id} className="candystripe">
              <Table.Cell collapsing color="label">
                #{request.id}
              </Table.Cell>
              <Table.Cell>{request.object}</Table.Cell>
              <Table.Cell>
                <b>{request.orderer}</b>
              </Table.Cell>
              <Table.Cell width="25%">
                <i>{request.reason}</i>
              </Table.Cell>
              <Table.Cell collapsing textAlign="right">
                {formatMoney(request.cost)} cr
              </Table.Cell>
              {(!requestonly || can_send) && can_approve_requests && (
                <Table.Cell collapsing>
                  <Button
                    icon="check"
                    color="good"
                    onClick={() =>
                      act('approve', {
                        id: request.id,
                      })
                    }
                  />
                  <Button
                    icon="times"
                    color="bad"
                    onClick={() =>
                      act('deny', {
                        id: request.id,
                      })
                    }
                  />
                </Table.Cell>
              )}
            </Table.Row>
          ))}
        </Table>
      )}
    </Section>
  );
};

const CargoCartButtons = (props) => {
  const { act, data } = useBackend();
  const { requestonly, can_send, can_approve_requests } = data;
  const cart = data.cart || [];
  const total = cart.reduce((total, entry) => total + entry.cost, 0);
  return (
    <>
      <Box inline mx={1}>
        {cart.length === 0 && '购物车空空如也'}
        {cart.length === 1 && '1 件物品'}
        {cart.length >= 2 && cart.length + ' 件物品'}{' '}
        {total > 0 && `(${formatMoney(total)} cr)`}
      </Box>
      {!requestonly && !!can_send && !!can_approve_requests && (
        <Button
          icon="times"
          color="transparent"
          content="清除"
          onClick={() => act('clear')}
        />
      )}
    </>
  );
};

const CartHeader = (props) => {
  const { data } = useBackend();
  return (
    <Section>
      <Stack>
        <Stack.Item mt="4px">Current-Cart</Stack.Item>
        <Stack.Item ml="200px" mt="3px">
          Quantity
        </Stack.Item>
        <Stack.Item ml="72px">
          <CargoCartButtons />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const CargoCart = (props) => {
  const { act, data } = useBackend();
  const {
    requestonly,
    away,
    docked,
    location,
    can_send,
    amount_by_name,
    max_order,
  } = data;
  const cart = data.cart || [];
  return (
    <Section fill>
      <CartHeader />
      {cart.length === 0 && <Box color="label">购物车空空如也</Box>}
      {cart.length > 0 && (
        <Table>
          {cart.map((entry) => (
            <Table.Row key={entry.id} className="candystripe">
              <Table.Cell collapsing color="label" inline width="210px">
                #{entry.id}&nbsp;{entry.object}
              </Table.Cell>
              <Table.Cell inline ml="65px" width="40px">
                {(can_send && entry.can_be_cancelled && (
                  <RestrictedInput
                    width="40px"
                    minValue={0}
                    maxValue={max_order}
                    value={entry.amount}
                    onEnter={(e, value) =>
                      act('modify', {
                        order_name: entry.object,
                        amount: value,
                      })
                    }
                  />
                )) || <Input width="40px" value={entry.amount} disabled />}
              </Table.Cell>
              <Table.Cell inline ml="5px" width="10px">
                {!!can_send && !!entry.can_be_cancelled && (
                  <Button
                    icon="plus"
                    disabled={amount_by_name[entry.object] >= max_order}
                    onClick={() =>
                      act('add_by_name', { order_name: entry.object })
                    }
                  />
                )}
              </Table.Cell>
              <Table.Cell inline ml="15px" width="10px">
                {!!can_send && !!entry.can_be_cancelled && (
                  <Button
                    icon="minus"
                    onClick={() => act('remove', { order_name: entry.object })}
                  />
                )}
              </Table.Cell>
              <Table.Cell collapsing textAlign="right" inline ml="50px">
                {entry.paid > 0 && <b>[Paid Privately x {entry.paid}]</b>}
                {formatMoney(entry.cost)} {entry.cost_type}
                {entry.dep_order > 0 && <b>[Department x {entry.dep_order}]</b>}
              </Table.Cell>
              <Table.Cell inline mt="20px" />
            </Table.Row>
          ))}
        </Table>
      )}
      {cart.length > 0 && !requestonly && (
        <Box mt={2}>
          {(away === 1 && docked === 1 && (
            <Button
              color="green"
              style={{
                lineHeight: '28px',
                padding: '0 12px',
              }}
              content="确认订购"
              onClick={() => act('send')}
            />
          )) || <Box opacity={0.5}>Shuttle in {location}.</Box>}
        </Box>
      )}
    </Section>
  );
};

const CargoHelp = (props) => {
  return (
    <>
      <Section title="部门订购">
        空间站内的各个部门可以用他们的部门订购控制台来订货. 这些订单完全免费!会使部门订购控制台进入冷却时间，不会使用货舱的部门经费.
        接下来就是你的出场时间了: 订单将会出现在你的供应控制台里,之后你需要将送达的货物送到订购者手上.
        只要运送的板条箱没有被篡改，你会在送货时获得其全额价值的金额，这使得该系统成为一个不错的赚钱途径.
        <br />
        <b>
        检查部门订购的板条箱以获取货物需要送达的具体位置.
        </b>
      </Section>
      <Section title="MULE 骡机器人">
        MULE 骡机器人虽然速度慢，但非常可靠，只需少量操作即可完成货物运送，但运输途中可能会被人干扰.
        <br />
        <b>机器人操作简单，轻松上手:</b>
        <br />
        <b>1.</b> 把要运送的板条箱拖到骡子机器人旁边.
        <br />
        <b>2.</b> 把板条箱拖到MULE 骡机器人上. 它会装载在上面.
        <br />
        <b>3.</b> 打开你的PDA，打开<i>机器监管员</i>.
        <br />
        <b>4.</b> 找到你的MULE 骡机器人.
        <br />
        <b>5.</b> 点击<i>设置停泊处</i>.
        <br />
        <b>7.</b> 选择<i>对应停泊处</i>.
        <br />
        <b>8.</b> 点击<i>设置目的地</i>.
        <br />
        <b>9.</b> 选择<i>目的地</i>.
        <br />
        <b>10.</b> 点击 <i>前往目的地</i>.
      </Section>
      <Section title="处置运输系统">
        除了使用MULE 骡机器人或送货上门外，你还可以使用处置邮递系统.
        请注意，处理管道破裂可能会导致你的包裹丢失（这种情况很少发生），因此这不是最安全的递送方式
        如果你（或前台的其他工作人员）想寄一封信，可以用一张包裹纸包起来，然后用同样的方式寄出。.
        <br />
        <b>处置运输系统操作简单，轻松上手:</b>
        <br />
        <b>1.</b> 将物品/箱子用包装纸包起来.
        <br />
        <b>2.</b> 使用目的地标记器选择发送地点.
        <br />
        <b>3.</b> 给包裹贴上标签.
        <br />
        <b>4.</b> 将其放在传送带上，让运输系统来处理.
        <br />
      </Section>
      <NoticeBox textAlign="center" info mb={0}>
      遇到困惑的问题？问一问军需官!
      </NoticeBox>
    </>
  );
};
