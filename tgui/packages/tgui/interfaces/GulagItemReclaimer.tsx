import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, NoticeBox, Section, Table } from '../components';
import { Window } from '../layouts';

type Data = {
  can_reclaim: BooleanLike;
  mobs: { mob: string; name: string }[];
};

export const GulagItemReclaimer = (props) => {
  const { act, data } = useBackend<Data>();
  const { can_reclaim, mobs = [] } = data;

  return (
    <Window width={325} height={400}>
      <Window.Content scrollable>
        {mobs.length === 0 && <NoticeBox>无储存物品</NoticeBox>}
        {mobs.length > 0 && (
          <Section title="储存物品">
            <Table>
              {mobs.map((mob) => (
                <Table.Row key={mob.mob}>
                  <Table.Cell>{mob.name}</Table.Cell>
                  <Table.Cell textAlign="right">
                    <Button
                      content="取回物品"
                      disabled={!can_reclaim}
                      onClick={() =>
                        act('release_items', {
                          mobref: mob.mob,
                        })
                      }
                    />
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
