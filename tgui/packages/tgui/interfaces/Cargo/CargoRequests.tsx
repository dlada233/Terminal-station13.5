import { decodeHtmlEntities } from 'common/string';

import { useBackend } from '../../backend';
import { Button, NoticeBox, Section, Table } from '../../components';
import { TableCell, TableRow } from '../../components/Table';
import { formatMoney } from '../../format';
import { CargoData } from './types';

export function CargoRequests(props) {
  const { act, data } = useBackend<CargoData>();
  const { requests = [], requestonly, can_send, can_approve_requests } = data;

  return (
    <Section
      fill
      scrollable
      title="活跃请购"
      buttons={
        !requestonly && (
          <Button
            icon="times"
            color="transparent"
            onClick={() => act('denyall')}
          >
            Clear
          </Button>
        )
      }
    >
      {requests.length === 0 && <NoticeBox success>No Requests</NoticeBox>}
      {requests.length > 0 && (
        <Table>
          <TableRow header color="gray">
            <TableCell>ID</TableCell>
            <TableCell>物品</TableCell>
            <TableCell>请购人</TableCell>
            <TableCell>原因</TableCell>
            <TableCell>花费</TableCell>
            {(!requestonly || !!can_send) && !!can_approve_requests && (
              <TableCell>是否批准</TableCell>
            )}
          </TableRow>

          {requests.map((request) => (
            <Table.Row key={request.id} className="candystripe" color="label">
              <Table.Cell collapsing>#{request.id}</Table.Cell>
              <Table.Cell>{request.object}</Table.Cell>
              <Table.Cell>
                <b>{request.orderer}</b>
              </Table.Cell>
              <Table.Cell color="lightgray" width="25%">
                <i>{decodeHtmlEntities(request.reason)}</i>
              </Table.Cell>
              <Table.Cell collapsing color="gold">
                {formatMoney(request.cost)} cr
              </Table.Cell>
              {(!requestonly || !!can_send) && !!can_approve_requests && (
                <Table.Cell collapsing>
                  <Button
                    icon="check"
                    color="good"
                    onClick={() =>
                      act('approve', {
                        id: request.id,
                      })
                    }
                  />
                  <Button
                    icon="times"
                    color="bad"
                    onClick={() =>
                      act('deny', {
                        id: request.id,
                      })
                    }
                  />
                </Table.Cell>
              )}
            </Table.Row>
          ))}
        </Table>
      )}
    </Section>
  );
}
