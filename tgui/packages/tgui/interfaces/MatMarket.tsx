import { sortBy } from 'common/collections';
import { BooleanLike } from 'common/react';
import { toTitleCase } from 'common/string';

import { useBackend } from '../backend';
import {
  Button,
  Collapsible,
  Modal,
  NoticeBox,
  Section,
  Stack,
} from '../components';
import { formatMoney } from '../format';
import { Window } from '../layouts';

type Material = {
  name: string;
  quantity: number;
  rarity: number;
  trend: string;
  price: number;
  threshold: number;
  color: string;
  requested: number;
};

type Data = {
  orderingPrive: BooleanLike;
  canOrderCargo: BooleanLike;
  creditBalance: number;
  orderBalance: number;
  materials: Material[];
  catastrophe: BooleanLike;
  CARGO_CRATE_VALUE: number;
  updateTime: number;
};

export const MatMarket = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    orderingPrive,
    canOrderCargo,
    creditBalance,
    orderBalance,
    materials = [],
    catastrophe,
    CARGO_CRATE_VALUE,
  } = data;

  // offset cost with crate value if there is currently nothing in the order
  const total_order_cost = orderBalance || CARGO_CRATE_VALUE;
  // multiplier of 1.1 for private orders
  const multiplier = orderingPrive ? 1.1 : 1;

  return (
    <Window width={1110} height={600}>
      <Window.Content scrollable>
        {!!catastrophe && <MarketCrashModal />}
        <Section
          title="出售材料"
          buttons={
            !!canOrderCargo && (
              <Button
                icon="dollar"
                tooltip="使用货仓预算订购."
                color={orderingPrive ? '' : 'green'}
                content={orderingPrive ? '用货仓预算订购?' : '用货仓预算订购'}
                onClick={() => act('toggle_budget')}
              />
            )
          }
        >
          <NoticeBox info>
            <Collapsible title="使用说明" color="blue">
              在此订购的材料将在下次货船到港时运达.
              <br /> <br />
              要销售材料，请直接放入材料，所有出售到市场上的材料都需要缴纳20%的市场费.
              并且
              为了防止恶意操纵市场，所有注册的交易者一次最多可以购买10组材料.
              <br /> <br />
              最终购买价格将包含回收价格的板条箱运费.
            </Collapsible>
          </NoticeBox>
          <Section>
            <Stack>
              <Stack.Item width="15%">
                余额: <b>{formatMoney(creditBalance)}</b> cr.
              </Stack.Item>
              <Stack.Item width="15%">
                订购: <b>{formatMoney(orderBalance)}</b> cr.
              </Stack.Item>
              <Stack.Item
                width="20%"
                color={data.updateTime > 150 ? 'green' : '#ad7526'}
              >
                <b>{Math.round(data.updateTime / 10)} 秒</b>直到下次更新
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="times"
                  color="transparent"
                  ml={66}
                  onClick={() => act('clear')}
                >
                  清除
                </Button>
              </Stack.Item>
            </Stack>
          </Section>
        </Section>
        {sortBy(materials, (tempmat: Material) => tempmat.rarity).map(
          (material, i) => (
            <Section key={i}>
              <Stack fill>
                <Stack.Item width="75%">
                  <Stack>
                    <Stack.Item
                      textColor={material.color ? material.color : 'white'}
                      fontSize="125%"
                      width="15%"
                      pr="3%"
                    >
                      {toTitleCase(material.name)}
                    </Stack.Item>

                    <Stack.Item width="15%" pr="2%">
                      交易以<b>{formatMoney(material.price)}</b>cr.
                    </Stack.Item>
                    {material.price < material.threshold ? (
                      <Stack.Item width="33%" ml={2} textColor="grey">
                        材料价格触发熔断!
                        <br /> <b>交易暂时停止.</b>
                      </Stack.Item>
                    ) : (
                      <Stack.Item width="33%" ml={2}>
                        <b>{material.quantity || '零'}</b>份
                        <b>{material.name}</b>交易中.{' '}
                        {material.requested || '零'} 份材料已订购.
                      </Stack.Item>
                    )}

                    <Stack.Item
                      width="40%"
                      color={
                        material.trend === '上升趋势'
                          ? 'green'
                          : material.trend === '下降趋势'
                            ? 'red'
                            : 'white'
                      }
                    >
                      <b>{toTitleCase(material.name)}</b>价格呈
                      <b>{material.trend}</b>.
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    disabled={
                      catastrophe === 1 ||
                      material.price <= material.threshold ||
                      creditBalance - total_order_cost <
                        material.price * multiplier ||
                      material.requested + 1 > material.quantity
                    }
                    tooltip={material.price * 1}
                    onClick={() =>
                      act('buy', {
                        quantity: 1,
                        material: material.name,
                      })
                    }
                  >
                    购买 1
                  </Button>
                  <Button
                    disabled={
                      catastrophe === 1 ||
                      material.price <= material.threshold ||
                      creditBalance - total_order_cost <
                        material.price * 5 * multiplier ||
                      material.requested + 5 > material.quantity
                    }
                    tooltip={material.price * 5}
                    onClick={() =>
                      act('buy', {
                        quantity: 5,
                        material: material.name,
                      })
                    }
                  >
                    5
                  </Button>
                  <Button
                    disabled={
                      catastrophe === 1 ||
                      material.price <= material.threshold ||
                      creditBalance - total_order_cost <
                        material.price * 10 * multiplier ||
                      material.requested + 10 > material.quantity
                    }
                    tooltip={material.price * 10}
                    onClick={() =>
                      act('buy', {
                        quantity: 10,
                        material: material.name,
                      })
                    }
                  >
                    10
                  </Button>
                  <Button
                    disabled={
                      catastrophe === 1 ||
                      material.price <= material.threshold ||
                      creditBalance - total_order_cost <
                        material.price * 25 * multiplier ||
                      material.requested + 25 > material.quantity
                    }
                    tooltip={material.price * 25}
                    onClick={() =>
                      act('buy', {
                        quantity: 25,
                        material: material.name,
                      })
                    }
                  >
                    25
                  </Button>
                  <Button
                    disabled={
                      catastrophe === 1 ||
                      material.price <= material.threshold ||
                      creditBalance - total_order_cost <
                        material.price * 50 * multiplier ||
                      material.requested + 50 > material.quantity
                    }
                    tooltip={material.price * 50}
                    onClick={() =>
                      act('buy', {
                        quantity: 50,
                        material: material.name,
                      })
                    }
                  >
                    50
                  </Button>
                </Stack.Item>
                {material.requested > 0 && (
                  <Stack.Item ml={2}>x {material.requested}</Stack.Item>
                )}
              </Stack>
            </Section>
          ),
        )}
      </Window.Content>
    </Window>
  );
};

const MarketCrashModal = (props) => {
  return (
    <Modal textAlign="center" mr={1.5}>
      注意! 市场崩溃了
      <br /> <br />
      所有的材料现在一文不值
      <br /> <br />
      所有交易者均已启用交易熔断机制
      <br /> <br />
      <b>不要惊慌，我们将进行技术性调整</b>
    </Modal>
  );
};
