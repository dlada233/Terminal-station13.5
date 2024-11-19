import { useBackend } from '../backend';
import { Box, Button, Dimmer, NoticeBox, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export const NtosJobManager = (props) => {
  return (
    <NtosWindow width={400} height={620}>
      <NtosWindow.Content scrollable>
        <NtosJobManagerContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const NtosJobManagerContent = (props) => {
  const { act, data } = useBackend();
  const { authed, cooldown, slots = [], prioritized = [] } = data;
  if (!authed) {
    return (
      <NoticeBox>
        当前ID无更改工作职位的所需权限.
      </NoticeBox>
    );
  }
  return (
    <Section>
      {cooldown > 0 && (
        <Dimmer>
          <Box bold textAlign="center" fontSize="20px">
            On Cooldown: {cooldown}s
          </Box>
        </Dimmer>
      )}
      <Table>
        <Table.Row header>
          <Table.Cell>优先级</Table.Cell>
          <Table.Cell>职位</Table.Cell>
        </Table.Row>
        {slots.map((slot) => (
          <Table.Row key={slot.title} className="candystripe">
            <Table.Cell bold>
              <Button.Checkbox
                fluid
                content={slot.title}
                disabled={slot.total <= 0}
                checked={slot.total > 0 && prioritized.includes(slot.title)}
                onClick={() =>
                  act('PRG_priority', {
                    target: slot.title,
                  })
                }
              />
            </Table.Cell>
            <Table.Cell collapsing>
              {slot.current} / {slot.total}
            </Table.Cell>
            <Table.Cell collapsing>
              <Button
                content="开启"
                disabled={!slot.status_open}
                onClick={() =>
                  act('PRG_open_job', {
                    target: slot.title,
                  })
                }
              />
              <Button
                content="关闭"
                disabled={!slot.status_close}
                onClick={() =>
                  act('PRG_close_job', {
                    target: slot.title,
                  })
                }
              />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
