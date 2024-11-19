import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  Button,
  Flex,
  Knob,
  LabeledControls,
  NumberInput,
  Section,
} from '../components';
import { Window } from '../layouts';

type Data = {
  temperature: number;
  fluid_type: string;
  minTemperature: number;
  maxTemperature: number;
  fluidTypes: string[];
  contents: { ref: string; name: string }[];
  allow_breeding: BooleanLike;
  feeding_interval: number;
};

export const Aquarium = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    temperature,
    fluid_type,
    minTemperature,
    maxTemperature,
    fluidTypes,
    contents,
    allow_breeding,
    feeding_interval,
  } = data;

  return (
    <Window width={520} height={400}>
      <Window.Content>
        <Section title="水族箱控制">
          <LabeledControls>
            <LabeledControls.Item label="温度">
              <Knob
                size={1.25}
                mb={1}
                value={temperature}
                unit="K"
                minValue={minTemperature}
                maxValue={maxTemperature}
                step={1}
                stepPixelSize={1}
                onDrag={(_, value) =>
                  act('temperature', {
                    temperature: value,
                  })
                }
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="液体">
              <Flex direction="column" mb={1}>
                {fluidTypes.map((f) => (
                  <Flex.Item key={f}>
                    <Button
                      fluid
                      content={f}
                      selected={fluid_type === f}
                      onClick={() => act('fluid', { fluid: f })}
                    />
                  </Flex.Item>
                ))}
              </Flex>
            </LabeledControls.Item>
            <LabeledControls.Item label="繁衍预防">
              <Button
                content={allow_breeding ? '离线' : '在线'}
                selected={!allow_breeding}
                onClick={() => act('allow_breeding')}
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="投喂间隔">
              <NumberInput
                fluid
                value={feeding_interval}
                minValue={1}
                maxValue={7}
                step={1}
                unit="分钟"
                onChange={(value) =>
                  act('feeding_interval', {
                    feeding_interval: value,
                  })
                }
              />
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
        <Section title="内容">
          {contents.map((movable) => (
            <Button
              key={movable.ref}
              content={movable.name}
              onClick={() => act('remove', { ref: movable.ref })}
            />
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
