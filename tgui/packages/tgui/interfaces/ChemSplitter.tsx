import { toFixed } from 'common/math';

import { useBackend } from '../backend';
import { LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  straight: number;
  side: number;
  max_transfer: number;
};

export const ChemSplitter = (props) => {
  const { act, data } = useBackend<Data>();
  const { straight, side, max_transfer } = data;

  return (
    <Window width={220} height={105}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="直路">
              <NumberInput
                value={straight}
                unit="u"
                width="55px"
                minValue={1}
                maxValue={max_transfer}
                format={(value) => toFixed(value, 2)}
                step={0.05}
                stepPixelSize={4}
                onChange={(value) =>
                  act('set_amount', {
                    target: 'straight',
                    amount: value,
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="侧路">
              <NumberInput
                value={side}
                unit="u"
                width="55px"
                minValue={1}
                maxValue={max_transfer}
                format={(value) => toFixed(value, 2)}
                step={0.05}
                stepPixelSize={4}
                onChange={(value) =>
                  act('set_amount', {
                    target: 'side',
                    amount: value,
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
