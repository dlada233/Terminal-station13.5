import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  Section,
} from '../components';
import { Window } from '../layouts';
import { CargoCatalog } from './Cargo/CargoCatalog';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

type Data = {
  locked: BooleanLike;
  points: number;
  usingBeacon: BooleanLike;
  beaconzone: string;
  beaconName: string;
  canBuyBeacon: BooleanLike;
  hasBeacon: BooleanLike;
  printMsg: string;
  message: string;
};

export function CargoExpress(props) {
  const { data } = useBackend<Data>();
  const { locked } = data;

  return (
    <Window width={600} height={700}>
      <Window.Content scrollable>
        <InterfaceLockNoticeBox accessText="货仓技工-等级ID卡" />
        {!locked && <CargoExpressContent />}
      </Window.Content>
    </Window>
  );
}

function CargoExpressContent(props) {
  const { act, data } = useBackend<Data>();
  const {
    hasBeacon,
    message,
    points,
    usingBeacon,
    beaconzone,
    beaconName,
    canBuyBeacon,
    printMsg,
  } = data;

  return (
    <>
      <Section
        title="货仓快递"
        buttons={
          <Box inline bold>
            <AnimatedNumber value={Math.round(points)} />
            {'信用点'}
          </Box>
        }
      >
        <LabeledList>
          <LabeledList.Item label="着陆位置">
            <Button selected={!usingBeacon} onClick={() => act('LZCargo')}>
              货仓
            </Button>
            <Button
              selected={usingBeacon}
              disabled={!hasBeacon}
              onClick={() => act('LZBeacon')}
            >
              {beaconzone} ({beaconName})
            </Button>
            <Button disabled={!canBuyBeacon} onClick={() => act('printBeacon')}>
              {printMsg}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="注意">{message}</LabeledList.Item>
        </LabeledList>
      </Section>
      <CargoCatalog express />
    </>
  );
}
