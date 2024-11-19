import { useBackend } from '../../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  Section,
} from '../../components';
import { formatMoney } from '../../format';
import { CargoData } from './types';

export function CargoStatus(props) {
  const { act, data } = useBackend<CargoData>();
  const {
    department,
    grocery,
    away,
    docked,
    loan,
    loan_dispatched,
    location,
    message,
    points,
    requestonly,
    can_send,
  } = data;

  return (
    <Section
      title={department}
      buttons={
        <Box inline bold>
          <AnimatedNumber
            value={points}
            format={(value) => formatMoney(value)}
          />
          {' 信用点'}
        </Box>
      }
    >
      <LabeledList>
        <LabeledList.Item label="货船">
          {!!docked && !requestonly && !!can_send ? (
            <Button
              color={grocery ? 'orange' : 'green'}
              tooltip={
                grocery ? '厨房已订购了产品，请确保它们被尽快送达厨房!' : ''
              }
              tooltipPosition="right"
              onClick={() => act('send')}
            >
              {location}
            </Button>
          ) : (
            String(location)
          )}
        </LabeledList.Item>
        <LabeledList.Item label="CentCom-中央指挥部消息">
          {message}
        </LabeledList.Item>
        {!!loan && !requestonly && (
          <LabeledList.Item label="租借">
            {!loan_dispatched ? (
              <Button disabled={!(away && docked)} onClick={() => act('loan')}>
                借出货船
              </Button>
            ) : (
              <Box color="bad">已借出给CentCom</Box>
            )}
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
}
