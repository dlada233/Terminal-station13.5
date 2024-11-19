import { toTitleCase } from 'common/string';

import { useBackend } from '../backend';
import { Box, Button, Section, Table } from '../components';
import { Window } from '../layouts';

type Material = {
  name: string;
  amount: number;
};

type Data = {
  materials: Material[];
};

export const OreBox = (props) => {
  const { act, data } = useBackend<Data>();
  const { materials } = data;

  return (
    <Window width={335} height={415}>
      <Window.Content scrollable>
        <Section
          title="矿岩存储"
          buttons={
            <Button
              disabled={materials.length === 0}
              onClick={() => act('removeall')}
            >
              空
            </Button>
          }
        >
          <Table>
            <Table.Row header>
              <Table.Cell>物品</Table.Cell>
              <Table.Cell collapsing textAlign="right">
                数量
              </Table.Cell>
            </Table.Row>
            {materials.map((material, id) => (
              <Table.Row key={id}>
                <Table.Cell>{toTitleCase(material.name)}</Table.Cell>
                <Table.Cell collapsing textAlign="right">
                  <Box color="label" inline>
                    {material.amount}
                  </Box>
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
        <Section>
          <Box>
            矿石可以用采矿背包快捷装入或亲手装入. 巨大石块也可以在这里储存.
            <br />
            爆裂闪矿无法储存在内.
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
