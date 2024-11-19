import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  Button,
  LabeledList,
  NumberInput,
  ProgressBar,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

type ModularShieldGenData = {
  max_strength: number;
  current_strength: number;
  max_regeneration: number;
  current_regeneration: number;
  max_radius: number;
  current_radius: number;
  active: BooleanLike;
  recovering: BooleanLike;
  exterior_only: BooleanLike;
  initiating_field: BooleanLike;
};

export const ModularShieldGen = (props) => {
  const { topLevel } = props;
  const { act, data } = useBackend<ModularShieldGenData>();
  const {
    max_strength,
    max_regeneration,
    current_regeneration,
    max_radius,
    current_radius,
    current_strength,
    active,
    exterior_only,
    recovering,
    initiating_field,
  } = data;

  return (
    <Window title="模块化护盾发生器" width={690} height={225}>
      <Window.Content>
        <Stack fill>
          <Stack.Item grow={2}>
            <Section title="护盾强度" color={recovering ? 'red' : 'white'}>
              <ProgressBar
                title="护盾强度"
                value={current_strength}
                maxValue={max_strength}
                ranges={{
                  good: [max_strength * 0.75, max_strength],
                  average: [max_strength * 0.25, max_strength * 0.75],
                  bad: [0, max_strength * 0.25],
                }}
              >
                {current_strength}/{max_strength}
              </ProgressBar>
            </Section>
            <Section title="护盾再生与护盾半径">
              <ProgressBar
                title="护盾再生率"
                value={current_regeneration}
                maxValue={max_regeneration}
                ranges={{
                  good: [max_regeneration * 0.75, max_regeneration],
                  average: [max_regeneration * 0.25, max_regeneration * 0.75],
                  bad: [0, max_regeneration * 0.25],
                }}
              >
                护盾再生 {current_regeneration}/{max_regeneration}
              </ProgressBar>
              <Section>
                <ProgressBar
                  title="护盾半径"
                  value={current_radius}
                  maxValue={max_radius}
                  ranges={{
                    good: [max_radius * 0.75, max_radius],
                    average: [max_radius * 0.25, max_radius * 0.75],
                    bad: [0, max_radius * 0.25],
                  }}
                >
                  护盾半径 {current_radius}/{max_radius}
                </ProgressBar>
              </Section>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section title="设置">
              <LabeledList>
                <LabeledList.Item label="设置半径">
                  <NumberInput
                    disabled={active}
                    fluid
                    step={1}
                    value={current_radius}
                    minValue={3}
                    maxValue={max_radius}
                    onChange={(value) =>
                      act('set_radius', {
                        new_radius: value,
                      })
                    }
                  />
                </LabeledList.Item>
                <LabeledList.Item label="限制">
                  <Button
                    disabled={active}
                    onClick={() => act('toggle_exterior')}
                  >
                    {exterior_only ? '仅外部' : '内部&外部'}
                  </Button>
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <Section>
              <LabeledList>
                <LabeledList.Item label="电源开关">
                  <Button
                    bold
                    disabled={recovering || initiating_field}
                    selected={active}
                    content={active ? '开' : '关'}
                    icon="power-off"
                    onClick={() => act('toggle_shields')}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
