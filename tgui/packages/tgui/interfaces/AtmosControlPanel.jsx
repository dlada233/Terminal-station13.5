import { map, sortBy } from 'common/collections';

import { useBackend } from '../backend';
import { Box, Button, Flex, Section, Table } from '../components';
import { Window } from '../layouts';

export const AtmosControlPanel = (props) => {
  const { act, data } = useBackend();
  const groups = sortBy(
    map(data.excited_groups, (group, i) => ({
      ...group,
      // Generate a unique id
      id: group.area + i,
    })),
    (group) => group.id,
  );
  return (
    <Window title="SSAir 控制面板" width={900} height={500}>
      <Section m={1}>
        <Flex justify="space-between" align="baseline">
          <Flex.Item>
            <Button
              onClick={() => act('toggle-freeze')}
              color={data.frozen === 1 ? 'good' : 'bad'}
            >
              {data.frozen === 1 ? '冷却子系统' : '解冻子系统'}
            </Button>
          </Flex.Item>
          <Flex.Item>Fire Cnt: {data.fire_count}</Flex.Item>
          <Flex.Item>活跃地块: {data.active_size}</Flex.Item>
          <Flex.Item>激活组: {data.excited_size}</Flex.Item>
          <Flex.Item>热点: {data.hotspots_size}</Flex.Item>
          <Flex.Item>超导体: {data.conducting_size}</Flex.Item>
          <Flex.Item>
            <Button.Checkbox
              checked={data.showing_user}
              onClick={() => act('toggle_user_display')}
            >
              Personal View
            </Button.Checkbox>
          </Flex.Item>
          <Flex.Item>
            <Button.Checkbox
              checked={data.show_all}
              onClick={() => act('toggle_show_all')}
            >
              显示所有
            </Button.Checkbox>
          </Flex.Item>
        </Flex>
      </Section>
      <Box fillPositionedParent top="45px">
        <Window.Content scrollable>
          <Section>
            <Table>
              <Table.Row header>
                <Table.Cell>区域名称</Table.Cell>
                <Table.Cell collapsing>冷却</Table.Cell>
                <Table.Cell collapsing>拆除</Table.Cell>
                <Table.Cell collapsing>地块</Table.Cell>
                <Table.Cell collapsing>
                  {data.display_max === 1 && '最大份额'}
                </Table.Cell>
                <Table.Cell collapsing>显示</Table.Cell>
              </Table.Row>
              {groups.map((group) => (
                <tr key={group.id}>
                  <td>
                    <Button
                      content={group.area}
                      onClick={() =>
                        act('move-to-target', {
                          spot: group.jump_to,
                        })
                      }
                    />
                  </td>
                  <td>{group.breakdown}</td>
                  <td>{group.dismantle}</td>
                  <td>{group.size}</td>
                  <td>{data.display_max === 1 && group.max_share}</td>
                  <td>
                    <Button.Checkbox
                      checked={group.should_show}
                      onClick={() =>
                        act('toggle_show_group', {
                          group: group.group,
                        })
                      }
                    />
                  </td>
                </tr>
              ))}
            </Table>
          </Section>
        </Window.Content>
      </Box>
    </Window>
  );
};
