import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Divider,
  Knob,
  LabeledControls,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

type Data = {
  movespeed: number;
  range: number;
  moving: BooleanLike;
};

export const TrainingMachine = () => {
  return (
    <Window width={230} height={150} title="AURUMILL">
      <Window.Content>
        <Section fill title="对练机">
          <TrainingControls />
        </Section>
      </Window.Content>
    </Window>
  );
};

/** Creates a labeledlist of controls */
const TrainingControls = (props) => {
  const { act, data } = useBackend<Data>();
  const { movespeed, range, moving } = data;

  return (
    <LabeledControls m={1}>
      <LabeledControls.Item label="速度">
        <Knob
          inline
          size={1.2}
          step={0.5}
          stepPixelSize={10}
          value={movespeed}
          minValue={1}
          maxValue={10}
          onDrag={(_, value) => act('movespeed', { movespeed: value })}
        />
      </LabeledControls.Item>
      <LabeledControls.Item label="范围">
        <Knob
          inline
          size={1.2}
          step={1}
          stepPixelSize={50}
          value={range}
          minValue={1}
          maxValue={7}
          onDrag={(_, value) => act('range', { range: value })}
        />
      </LabeledControls.Item>
      <Stack.Item>
        <Divider vertical />
      </Stack.Item>
      <Stack.Item>
        <Button fluid selected={moving} onClick={() => act('toggle')}>
          <Box bold fontSize="1.4em" lineHeight={3}>
            {moving ? '结束' : '开始'}
          </Box>
        </Button>
      </Stack.Item>
    </LabeledControls>
  );
};
