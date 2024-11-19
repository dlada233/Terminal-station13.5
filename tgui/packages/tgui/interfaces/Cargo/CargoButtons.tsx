import { useBackend } from '../../backend';
import { Box, Button } from '../../components';
import { formatMoney } from '../../format';
import { CargoData } from './types';

export function CargoCartButtons(props) {
  const { act, data } = useBackend<CargoData>();
  const { cart = [], requestonly, can_send, can_approve_requests } = data;

  let total = 0;
  let amount = 0;
  for (let i = 0; i < cart.length; i++) {
    amount += cart[i].amount;
    total += cart[i].cost;
  }

  const canClear =
    !requestonly && !!can_send && !!can_approve_requests && cart.length > 0;

  return (
    <>
      <Box inline mx={1}>
        {amount === 0 && '购物车是空的'}
        {amount === 1 && '1 件物品'}
        {amount >= 2 && amount + ' 件物品'}{' '}
        {total > 0 && `(${formatMoney(total)} cr)`}
      </Box>

      <Button
        disabled={!canClear}
        icon="times"
        color="transparent"
        onClick={() => act('clear')}
      >
        清空
      </Button>
    </>
  );
}
