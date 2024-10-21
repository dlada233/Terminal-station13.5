import { BooleanLike } from '../../../common/react';
import { useBackend } from '../../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  Section,
} from '../../components';

export type BeakerReagent = {
  name: string;
  volume: number;
};

export type Beaker = {
  maxVolume: number;
  pH: number;
  currentVolume: number;
  contents: BeakerReagent[];
};

type BeakerProps = {
  beaker: Beaker;
  replace_contents?: BeakerReagent[];
  title_label?: string;
  showpH?: BooleanLike;
};

export const BeakerDisplay = (props: BeakerProps) => {
  const { act } = useBackend();
  const { beaker, replace_contents, title_label, showpH } = props;
  const beakerContents = replace_contents || beaker?.contents || [];

  return (
    <LabeledList>
      <LabeledList.Item
        label="Beaker"
        buttons={
          !!beaker && (
            <Button icon="eject" onClick={() => act('eject')}>
              取出
            </Button>
          )
        }
      >
        {title_label ||
          (!!beaker && (
            <>
              <AnimatedNumber initial={0} value={beaker.currentVolume} />/
              {beaker.maxVolume} 单位
            </>
          )) ||
          '无烧杯'}
      </LabeledList.Item>
      <LabeledList.Item label="内容物">
        <Box color="label">
          {(!title_label && !beaker && 'N/A') ||
            (beakerContents.length === 0 && '无')}
        </Box>
        {beakerContents.map((chemical) => (
          <Box key={chemical.name} color="label">
            <AnimatedNumber initial={0} value={chemical.volume} /> 单位{' '}
            {chemical.name}
          </Box>
        ))}
        {beakerContents.length > 0 && !!showpH && (
          <Box>
            pH:
            <AnimatedNumber value={beaker.pH} />
          </Box>
        )}
      </LabeledList.Item>
    </LabeledList>
  );
};

export const BeakerSectionDisplay = (props: BeakerProps) => {
  const { act } = useBackend();
  const { beaker, replace_contents, title_label, showpH } = props;
  const beakerContents = replace_contents || beaker?.contents || [];

  return (
    <Section
      title={title_label || '烧杯'}
      buttons={
        !!beaker && (
          <>
            <Box inline color="label" mr={2}>
              {beaker.currentVolume} / {beaker.maxVolume} units
            </Box>
            <Button icon="eject" onClick={() => act('eject')}>
              取出
            </Button>
          </>
        )
      }
    >
      <Box color="label">
        {(!beaker && 'N/A') || (beakerContents.length === 0 && '无')}
      </Box>
      {beakerContents.map((chemical) => (
        <Box key={chemical.name} color="label">
          <AnimatedNumber initial={0} value={chemical.volume} /> 单位{' '}
          {chemical.name}
        </Box>
      ))}
      {beakerContents.length > 0 && !!showpH && (
        <Box>
          pH:
          <AnimatedNumber value={beaker.pH} />
        </Box>
      )}
    </Section>
  );
};
