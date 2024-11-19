import { filter, sortBy } from 'common/collections';
import { toFixed } from 'common/math';
import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Divider,
  LabeledList,
  NumberInput,
  ProgressBar,
  Section,
  Stack,
} from '../components';
import { getGasColor } from '../constants';
import { Window } from '../layouts';

type Data = {
  on: BooleanLike;
  gas_transfer_rate: number;
  bluespace_network_gases: Gas[];
  credits: number;
};

type Gas = {
  name: string;
  amount: number;
  price: number;
  id: string;
};

type GasDisplayProps = {
  gas: Gas;
  gasMax: number;
};

const mappedTopMargin = '2%';

export const BluespaceSender = (props) => {
  const { act, data } = useBackend<Data>();
  const { gas_transfer_rate, credits, bluespace_network_gases = [], on } = data;

  const gases: Gas[] = sortBy(
    filter(bluespace_network_gases, (gas) => gas.amount >= 0.01),
    (gas) => -gas.amount,
  );

  const gasMax = Math.max(1, ...gases.map((gas) => gas.amount));

  return (
    <Window title="蓝空供货站" width={500} height={600}>
      <Window.Content>
        <Section
          scrollable
          fill
          title="蓝空网络气体"
          buttons={
            <>
              <Button
                mr={0.5}
                color="transparent"
                icon="info"
                tooltipPosition="bottom-start"
                tooltip={`
                在这里用管道输入的任何气体都将被添加到蓝空网络中!
                这意味着与其相连(多功能工具)的蓝空售货机将使用其库存，以这台机器的价格购买.
              `}
              />
              <NumberInput
                animated
                value={gas_transfer_rate}
                step={0.01}
                width="63px"
                unit="moles/S"
                minValue={0}
                maxValue={1}
                onDrag={(value) =>
                  act('rate', {
                    rate: value,
                  })
                }
              />
              <Button
                ml={0.5}
                icon={on ? 'power-off' : 'times'}
                content={on ? '开启' : '关闭'}
                selected={on}
                tooltipPosition="bottom-start"
                tooltip="只会吸收气体."
                onClick={() => act('power')}
              />
              <Button
                ml={0.5}
                content="收回气体"
                tooltipPosition="bottom-start"
                tooltip="会将内部气体收回管道中."
                onClick={() => act('retrieve')}
              />
            </>
          }
        >
          <Box>{'售货机至今为止已经售出了 ' + credits + ' 信用点.'}</Box>
          <Divider />
          <LabeledList>
            {gases.map((gas, index) => (
              <GasDisplay gas={gas} gasMax={gasMax} key={index} />
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

const GasDisplay = (props: GasDisplayProps) => {
  const { act } = useBackend<Data>();
  const {
    gas: { amount, id, name, price },
    gasMax,
  } = props;

  return (
    <LabeledList.Item className="candystripe" label={name}>
      <Stack fill>
        <Stack.Item grow={2}>
          <NumberInput
            animated
            fluid
            value={price}
            step={1}
            unit="每mole"
            minValue={0}
            maxValue={100}
            onDrag={(value) =>
              act('price', {
                gas_price: value,
                gas_type: id,
              })
            }
          />
        </Stack.Item>
        <Stack.Item grow={3}>
          <ProgressBar
            color={getGasColor(id)}
            value={amount}
            minValue={0}
            maxValue={gasMax}
          />
        </Stack.Item>
        <Stack.Item color="label" grow={2}>
          {toFixed(amount, 2) + ' moles'}
        </Stack.Item>
      </Stack>
    </LabeledList.Item>
  );
};
