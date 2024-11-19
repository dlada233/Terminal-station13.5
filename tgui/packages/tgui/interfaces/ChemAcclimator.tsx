import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  chem_temp: number;
  target_temperature: number;
  allowed_temperature_difference: number;
  enabled: BooleanLike;
  max_volume: number;
  reagent_volume: number;
  acclimate_state: string;
  emptying: BooleanLike;
};

export const ChemAcclimator = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    chem_temp,
    target_temperature,
    allowed_temperature_difference,
    enabled,
    max_volume,
    reagent_volume,
    acclimate_state,
    emptying,
  } = data;

  return (
    <Window width={320} height={271}>
      <Window.Content>
        <Section title="Acclimator">
          <LabeledList>
            <LabeledList.Item label="当前温度">{chem_temp} K</LabeledList.Item>
            <LabeledList.Item label="目标温度">
              <NumberInput
                value={target_temperature}
                unit="K"
                width="59px"
                minValue={0}
                maxValue={1000}
                step={5}
                stepPixelSize={2}
                onChange={(value) =>
                  act('set_target_temperature', {
                    temperature: value,
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="可接受温差">
              <NumberInput
                step={1}
                value={allowed_temperature_difference}
                unit="K"
                width="59px"
                minValue={1}
                maxValue={target_temperature}
                stepPixelSize={2}
                onChange={(value) => {
                  act('set_allowed_temperature_difference', {
                    temperature: value,
                  });
                }}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Status"
          buttons={
            <Button
              icon="power-off"
              content={enabled ? '开启' : '关闭'}
              selected={enabled}
              onClick={() => act('toggle_power')}
            />
          }
        >
          <LabeledList>
            <LabeledList.Item label="体积">
              <NumberInput
                value={max_volume}
                unit="u"
                width="50px"
                minValue={reagent_volume}
                maxValue={200}
                step={2}
                stepPixelSize={2}
                onChange={(value) =>
                  act('change_volume', {
                    volume: value,
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="当前操作">
              {acclimate_state}
            </LabeledList.Item>
            <LabeledList.Item label="当前阶段">
              {emptying ? '清空' : '填充'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
