import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';
import { getGasLabel } from '../constants';
import { Window } from '../layouts';

type Data = {
  filter_types: Filter[];
  on: BooleanLike;
  rate: number;
  max_rate: number;
};

type Filter = {
  enabled: BooleanLike;
  gas_id: string;
};

export const AtmosFilter = (props) => {
  const { act, data } = useBackend<Data>();
  const { filter_types = [], on, rate, max_rate } = data;

  return (
    <Window width={440} height={240}>
      <Window.Content>
        <Section
          buttons={
            <Button
              icon={on ? 'power-off' : 'times'}
              content={on ? '开' : '关'}
              selected={on}
              onClick={() => act('power')}
            />
          }
          fill
          title="气体过滤器"
        >
          <LabeledList>
            <LabeledList.Item label="输送效率">
              <NumberInput
                animated
                step={1}
                value={rate}
                width="63px"
                unit="L/s"
                minValue={0}
                maxValue={max_rate}
                onDrag={(value) =>
                  act('rate', {
                    rate: value,
                  })
                }
              />
              <Button
                ml={1}
                icon="plus"
                content="最大值"
                disabled={rate === max_rate}
                onClick={() =>
                  act('rate', {
                    rate: 'max',
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="过滤类型">
              {filter_types.map(({ enabled, gas_id }, index) => (
                <Button
                  key={index}
                  icon={enabled ? 'check-square-o' : 'square-o'}
                  selected={enabled}
                  onClick={() =>
                    act('toggle_filter', {
                      val: gas_id,
                    })
                  }
                >
                  {getGasLabel(gas_id)}
                </Button>
              ))}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
