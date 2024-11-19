import { map } from 'common/collections';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Button, Flex, LabeledList, Section, Table, Tabs } from '../components';
import { Window } from '../layouts';

export const ShuttleManipulator = (props) => {
  const [tab, setTab] = useState(1);

  return (
    <Window title="飞船调制器" width={800} height={600} theme="admin">
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>
            状态
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 2} onClick={() => setTab(2)}>
            模板
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 3} onClick={() => setTab(3)}>
            更改
          </Tabs.Tab>
        </Tabs>
        {tab === 1 && <ShuttleManipulatorStatus />}
        {tab === 2 && <ShuttleManipulatorTemplates />}
        {tab === 3 && <ShuttleManipulatorModification />}
      </Window.Content>
    </Window>
  );
};

export const ShuttleManipulatorStatus = (props) => {
  const { act, data } = useBackend();
  const shuttles = data.shuttles || [];
  return (
    <Section>
      <Table>
        {shuttles.map((shuttle) => (
          <Table.Row key={shuttle.id}>
            <Table.Cell>
              <Button
                content="跳跃"
                key={shuttle.id}
                onClick={() =>
                  act('jump_to', {
                    type: 'mobile',
                    id: shuttle.id,
                  })
                }
              />
            </Table.Cell>
            <Table.Cell>
              <Button
                content="起飞"
                key={shuttle.id}
                disabled={!shuttle.can_fly}
                onClick={() =>
                  act('fly', {
                    id: shuttle.id,
                  })
                }
              />
            </Table.Cell>
            <Table.Cell>{shuttle.name}</Table.Cell>
            <Table.Cell>{shuttle.id}</Table.Cell>
            <Table.Cell>{shuttle.status}</Table.Cell>
            <Table.Cell>
              {shuttle.mode}
              {!!shuttle.timer && (
                <>
                  ({shuttle.timeleft})
                  <Button
                    content="快速航行"
                    key={shuttle.id}
                    disabled={!shuttle.can_fast_travel}
                    onClick={() =>
                      act('fast_travel', {
                        id: shuttle.id,
                      })
                    }
                  />
                </>
              )}
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

export const ShuttleManipulatorTemplates = (props) => {
  const { act, data } = useBackend();
  const templateObject = data.templates || {};
  const selected = data.selected || {};
  const [selectedTemplateId, setSelectedTemplateId] = useState(
    Object.keys(templateObject)[0],
  );
  const actualTemplates = templateObject[selectedTemplateId]?.templates || [];

  return (
    <Section>
      <Flex>
        <Flex.Item>
          <Tabs vertical>
            {map(templateObject, (template, templateId) => (
              <Tabs.Tab
                key={templateId}
                selected={selectedTemplateId === templateId}
                onClick={() => setSelectedTemplateId(templateId)}
              >
                {template.port_id}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Flex.Item>
        <Flex.Item grow={1} basis={0}>
          {actualTemplates.map((actualTemplate) => {
            const isSelected =
              actualTemplate.shuttle_id === selected.shuttle_id;
            // Whoever made the structure being sent is an asshole
            return (
              <Section
                title={actualTemplate.name}
                level={2}
                key={actualTemplate.shuttle_id}
                buttons={
                  <Button
                    content={isSelected ? '已选中' : '选中'}
                    selected={isSelected}
                    onClick={() =>
                      act('select_template', {
                        shuttle_id: actualTemplate.shuttle_id,
                      })
                    }
                  />
                }
              >
                {(!!actualTemplate.description ||
                  !!actualTemplate.admin_notes) && (
                  <LabeledList>
                    {!!actualTemplate.description && (
                      <LabeledList.Item label="描述">
                        {actualTemplate.description}
                      </LabeledList.Item>
                    )}
                    {!!actualTemplate.admin_notes && (
                      <LabeledList.Item label="管理员注释">
                        {actualTemplate.admin_notes}
                      </LabeledList.Item>
                    )}
                  </LabeledList>
                )}
              </Section>
            );
          })}
        </Flex.Item>
      </Flex>
    </Section>
  );
};

export const ShuttleManipulatorModification = (props) => {
  const { act, data } = useBackend();
  const selected = data.selected || {};
  const existingShuttle = data.existing_shuttle || {};
  return (
    <Section>
      {selected ? (
        <>
          <Section level={2} title={selected.name}>
            {(!!selected.description || !!selected.admin_notes) && (
              <LabeledList>
                {!!selected.description && (
                  <LabeledList.Item label="描述">
                    {selected.description}
                  </LabeledList.Item>
                )}
                {!!selected.admin_notes && (
                  <LabeledList.Item label="管理员注释">
                    {selected.admin_notes}
                  </LabeledList.Item>
                )}
              </LabeledList>
            )}
          </Section>
          {existingShuttle ? (
            <Section level={2} title={'存在的飞船: ' + existingShuttle.name}>
              <LabeledList>
                <LabeledList.Item
                  label="状态"
                  buttons={
                    <Button
                      content="跳至"
                      onClick={() =>
                        act('jump_to', {
                          type: 'mobile',
                          id: existingShuttle.id,
                        })
                      }
                    />
                  }
                >
                  {existingShuttle.status}
                  {!!existingShuttle.timer && <>({existingShuttle.timeleft})</>}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          ) : (
            <Section level={2} title="存在的飞船: 无" />
          )}
          <Section level={2} title="状态">
            <Button
              content="加载"
              color="good"
              onClick={() =>
                act('load', {
                  shuttle_id: selected.shuttle_id,
                })
              }
            />
            <Button
              content="预览"
              onClick={() =>
                act('preview', {
                  shuttle_id: selected.shuttle_id,
                })
              }
            />
            <Button
              content="接替"
              color="bad"
              onClick={() =>
                act('replace', {
                  shuttle_id: selected.shuttle_id,
                })
              }
            />
          </Section>
        </>
      ) : (
        '未选中飞船'
      )}
    </Section>
  );
};
