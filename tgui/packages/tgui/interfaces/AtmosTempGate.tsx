import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  on: BooleanLike;
  temperature: number;
  min_temperature: number;
  max_temperature: number;
};

export const AtmosTempGate = (props) => {
  const { act, data } = useBackend<Data>();
  const { on, temperature, min_temperature, max_temperature } = data;

  return (
    <Window width={335} height={115}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="电源">
              <Button
                icon={on ? 'power-off' : 'times'}
                content={on ? '开' : '关'}
                selected={on}
                onClick={() => act('power')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="热值设置">
              <NumberInput
                animated
                value={temperature}
                unit="K"
                width="75px"
                minValue={min_temperature}
                maxValue={max_temperature}
                step={1}
                onChange={(value) =>
                  act('temperature', {
                    temperature: value,
                  })
                }
              />
              <Button
                ml={1}
                icon="plus"
                content="最大值"
                disabled={temperature === max_temperature}
                onClick={() =>
                  act('temperature', {
                    temperature: 'max',
                  })
                }
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
