// THIS IS A SKYRAT UI FILE
import { round } from 'common/math';
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Collapsible,
  Input,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
  Slider,
  Stack,
  Tabs,
  TextArea,
} from '../components';
import { Window } from '../layouts';

export const OpposingForcePanel = (props) => {
  const [tab, setTab] = useState(1);
  const { act, data } = useBackend();
  const { admin_mode, creator_ckey, owner_antag } = data;
  return (
    <Window
      title={'反派对抗力量: ' + creator_ckey}
      width={585}
      height={840}
      theme={owner_antag ? 'syndicate' : 'admin'}
    >
      <Window.Content scrollable>
        <Stack vertical grow mb={1}>
          <Stack.Item>
            <Tabs fill>
              {admin_mode ? (
                <>
                  <Tabs.Tab
                    width="100%"
                    selected={tab === 1}
                    onClick={() => setTab(1)}
                  >
                    管理员控制
                  </Tabs.Tab>
                  <Tabs.Tab
                    width="100%"
                    selected={tab === 2}
                    onClick={() => setTab(2)}
                  >
                    管理员聊天
                  </Tabs.Tab>
                </>
              ) : (
                <>
                  <Tabs.Tab
                    width="100%"
                    selected={tab === 1}
                    onClick={() => setTab(1)}
                  >
                    概要
                  </Tabs.Tab>
                  <Tabs.Tab
                    width="100%"
                    selected={tab === 2}
                    onClick={() => setTab(2)}
                  >
                    装备
                  </Tabs.Tab>
                  <Tabs.Tab
                    width="100%"
                    selected={tab === 3}
                    onClick={() => setTab(3)}
                  >
                    管理员聊天
                  </Tabs.Tab>
                </>
              )}
            </Tabs>
          </Stack.Item>
        </Stack>
        {admin_mode ? (
          <>
            {tab === 1 && <AdminTab />}
            {tab === 2 && <AdminChatTab />}
          </>
        ) : (
          <>
            {tab === 1 && <OpposingForceTab />}
            {tab === 2 && <EquipmentTab />}
            {tab === 3 && <AdminChatTab />}
          </>
        )}
      </Window.Content>
    </Window>
  );
};

export const OpposingForceTab = (props) => {
  const { act, data } = useBackend();
  const {
    creator_ckey,
    objectives = [],
    can_submit,
    status,
    can_request_update,
    request_updates_muted,
    can_edit,
    backstory,
    handling_admin,
    blocked,
    approved,
    denied,
  } = data;
  return (
    <Stack vertical grow>
      <Stack.Item>
        <Section
          title={
            handling_admin ? '控制处 - 处理管理员: ' + handling_admin : '控制处'
          }
        >
          <Stack>
            <Stack.Item>
              <Button
                icon="check"
                color="good"
                tooltip={
                  '提交你的申请并接受审查.' + (blocked ? ' (被封禁)' : '')
                }
                disabled={!can_submit || blocked}
                content="提交申请"
                onClick={() => act('submit')}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="question"
                color="orange"
                tooltip={
                  '向管理员请求帮助.' +
                  (request_updates_muted ? ' (被禁言)' : '')
                }
                disabled={!can_request_update || request_updates_muted}
                content="请求帮助"
                onClick={() => act('request_update')}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="wrench"
                color="blue"
                tooltip="修改你的申请，将重置所有授权状态."
                disabled={can_edit}
                content="修改申请"
                onClick={() => act('modify_request')}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="trash"
                color="bad"
                tooltip="从队列中删除申请."
                disabled={status === 'Not submitted'}
                content="取消申请"
                onClick={() => act('close_application')}
              />
            </Stack.Item>
          </Stack>
          <Stack>
            <Stack.Item>
              <Button
                icon="file-import"
                color="blue"
                tooltip="从.josn文件导入申请"
                disabled={status === 'Awaiting approval'}
                content="导入JSON"
                onClick={() => act('import_json')}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="file-export"
                color="purple"
                tooltip="将申请导出为.json文件."
                disabled={status === 'Awaiting approval'}
                content="导出JSON"
                onClick={() => act('export_json')}
              />
            </Stack.Item>
          </Stack>
          <NoticeBox
            color={approved ? 'good' : denied ? 'bad' : 'orange'}
            mt={2}
          >
            {status}
          </NoticeBox>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section title="背景故事">
          <TextArea
            disabled={!can_edit}
            height="100px"
            value={backstory}
            placeholder="描述一下你为什么想要对抗空间站. 包括具体的事件细节，比如什么导致了你想要对抗的想法. 请把自己当成这个角色，做出符合情景的反应.（字符限制2000字）"
            onChange={(_e, value) =>
              act('set_backstory', {
                backstory: value,
              })
            }
          />
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section
          title="目标"
          buttons={
            <Button
              icon="plus"
              content="添加目标"
              onClick={() => act('add_objective')}
            />
          }
        >
          {!!objectives.length && <OpposingForceObjectives />}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

export const OpposingForceObjectives = (props) => {
  const { act, data } = useBackend();
  const { objectives = [], can_edit } = data;

  const [selectedObjectiveID, setSelectedObjective] = useState(
    objectives[0]?.id,
  );

  const selectedObjective = objectives.find((objective) => {
    return objective.id === selectedObjectiveID;
  });

  return (
    <Stack vertical grow>
      {objectives.length > 0 && (
        <Stack.Item>
          <Tabs fill>
            {objectives.map((objective) => (
              <Tabs.Tab
                color={
                  objective.status_text === '暂未评估'
                    ? 'yellow'
                    : objective.approved
                      ? 'good'
                      : 'bad'
                }
                textColor={
                  objective.status_text === '暂未评估'
                    ? 'yellow'
                    : objective.approved
                      ? 'good'
                      : 'bad'
                }
                width="25%"
                key={objective.id}
                selected={objective.id === selectedObjectiveID}
                onClick={() => setSelectedObjective(objective.id)}
              >
                <Stack align="center">
                  <Stack.Item width="80%">
                    {objective.title ? objective.title : '空白目标'}
                  </Stack.Item>
                  <Stack.Item width="20%">
                    <Button
                      disabled={!can_edit}
                      height="90%"
                      icon="minus"
                      color="bad"
                      textAlign="center"
                      tooltip="移除目标"
                      onClick={() =>
                        act('remove_objective', {
                          objective_ref: objective.ref,
                        })
                      }
                    />
                  </Stack.Item>
                </Stack>
              </Tabs.Tab>
            ))}
          </Tabs>
        </Stack.Item>
      )}
      {selectedObjective ? (
        <Stack.Item>
          <Stack vertical>
            <Stack.Item>
              <Stack.Item>
                <Stack vertical>
                  <Stack.Item>标题</Stack.Item>
                  <Stack.Item>
                    <Input
                      disabled={!can_edit}
                      width="100%"
                      placeholder="blank objective"
                      value={selectedObjective.title}
                      onChange={(e, value) =>
                        act('set_objective_title', {
                          objective_ref: selectedObjective.ref,
                          title: value,
                        })
                      }
                    />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item>
                <Stack vertical mt={2}>
                  <Stack.Item>
                    强度: {selectedObjective.text_intensity}
                  </Stack.Item>
                  <Stack.Item>
                    <Slider
                      disabled={!can_edit}
                      step={0.1}
                      stepPixelSize={0.1}
                      value={selectedObjective.intensity}
                      format={(value) => round(value)}
                      minValue={0}
                      maxValue={500}
                      onDrag={(e, value) =>
                        act('set_objective_intensity', {
                          objective_ref: selectedObjective.ref,
                          new_intensity_level: value,
                        })
                      }
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Stack>
                      <Stack.Item>
                        <Button
                          ml={7.6}
                          mr={15}
                          disabled={!can_edit}
                          icon="laugh"
                          color="good"
                          onClick={() =>
                            act('set_objective_intensity', {
                              objective_ref: selectedObjective.ref,
                              new_intensity_level: 50,
                            })
                          }
                        />
                        <Button
                          mr={15}
                          disabled={!can_edit}
                          icon="smile"
                          color="teal"
                          onClick={() =>
                            act('set_objective_intensity', {
                              objective_ref: selectedObjective.ref,
                              new_intensity_level: 150,
                            })
                          }
                        />
                        <Button
                          mr={15}
                          disabled={!can_edit}
                          icon="meh-blank"
                          color="olive"
                          onClick={() =>
                            act('set_objective_intensity', {
                              objective_ref: selectedObjective.ref,
                              new_intensity_level: 250,
                            })
                          }
                        />
                        <Button
                          mr={15}
                          disabled={!can_edit}
                          icon="frown"
                          color="orange"
                          onClick={() =>
                            act('set_objective_intensity', {
                              objective_ref: selectedObjective.ref,
                              new_intensity_level: 350,
                            })
                          }
                        />
                        <Button
                          disabled={!can_edit}
                          icon="grimace"
                          color="red"
                          onClick={() =>
                            act('set_objective_intensity', {
                              objective_ref: selectedObjective.ref,
                              new_intensity_level: 450,
                            })
                          }
                        />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item>
                <Stack vertical mt={2}>
                  <Stack.Item>
                    描述
                    <Button
                      icon="info"
                      tooltip="在这里输入客观描述，描述你想做什么，比如 “摧毁死星” 或 “摧毁死星或死星基地” （1000字符限制）."
                      color="light-gray"
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <TextArea
                      fluid
                      disabled={!can_edit}
                      height="85px"
                      value={selectedObjective.description}
                      onChange={(e, value) =>
                        act('set_objective_description', {
                          objective_ref: selectedObjective.ref,
                          new_desciprtion: value,
                        })
                      }
                    />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item>
                <Stack vertical mt={2}>
                  <Stack.Item>
                    缘由/义理
                    <Button
                      icon="info"
                      tooltip="在这里输入有此目标的原因，最好确保你有可以理解的理由这么做.（1000字符限制）"
                      color="light-gray"
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <TextArea
                      disabled={!can_edit}
                      height="85px"
                      value={selectedObjective.justification}
                      onChange={(e, value) =>
                        act('set_objective_justification', {
                          objective_ref: selectedObjective.ref,
                          new_justification: value,
                        })
                      }
                    />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item mt={2}>
                <NoticeBox color={selectedObjective.approved ? 'good' : 'bad'}>
                  {selectedObjective.status_text === '暂未评估'
                    ? '目标暂未评估'
                    : selectedObjective.approved
                      ? '目标被批准'
                      : selectedObjective.denied_text
                        ? '目标被否决 - 原因: ' + selectedObjective.denied_text
                        : '目标被否决'}
                </NoticeBox>
              </Stack.Item>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      ) : (
        <Stack.Item>未选择目标.</Stack.Item>
      )}
    </Stack>
  );
};

export const EquipmentTab = (props) => {
  const { act, data } = useBackend();
  const { equipment_list = [], selected_equipment = [], can_edit } = data;
  return (
    <Stack vertical grow>
      <Stack.Item>
        <Section title="已选择装备">
          {selected_equipment.length === 0 ? (
            <Box color="bad">未选择装备.</Box>
          ) : (
            selected_equipment.map((equipment) => (
              <>
                <LabeledList key={equipment.ref}>
                  <LabeledList.Item
                    buttons={
                      <>
                        <NumberInput
                          animated
                          value={equipment.count}
                          minValue={1}
                          maxValue={5}
                          onChange={(e, value) =>
                            act('set_equipment_count', {
                              selected_equipment_ref: equipment.ref,
                              new_equipment_count: value,
                            })
                          }
                        />
                        <Button
                          icon="times"
                          color="bad"
                          content="移除"
                          onClick={() =>
                            act('remove_equipment', {
                              selected_equipment_ref: equipment.ref,
                            })
                          }
                        />
                      </>
                    }
                    label={equipment.name}
                  />
                  <LabeledList.Item label="状态">
                    {equipment.denied_reason
                      ? equipment.status + ' - 原因: ' + equipment.denied_reason
                      : equipment.status}
                  </LabeledList.Item>
                </LabeledList>
                <Input
                  mt={1}
                  mb={1}
                  disabled={!can_edit}
                  width="100%"
                  placeholder="物品理由"
                  value={equipment.reason}
                  onChange={(e, value) =>
                    act('set_equipment_reason', {
                      selected_equipment_ref: equipment.ref,
                      new_equipment_reason: value,
                    })
                  }
                />
              </>
            ))
          )}
        </Section>
        <Section title="可用装备">
          <Stack vertical fill>
            {equipment_list.map((equipment_category) => (
              <Stack.Item key={equipment_category.category}>
                <Collapsible
                  title={equipment_category.category}
                  key={equipment_category.category}
                >
                  <Section>
                    {equipment_category.items.map((item) => (
                      <Section
                        title={item.name}
                        key={item.ref}
                        buttons={
                          <Button
                            icon="check"
                            color="good"
                            content="选择"
                            disabled={!can_edit}
                            onClick={() =>
                              act('select_equipment', {
                                equipment_ref: item.ref,
                              })
                            }
                          />
                        }
                      >
                        <LabeledList>
                          <LabeledList.Item label="描述">
                            {item.description}
                          </LabeledList.Item>
                        </LabeledList>
                      </Section>
                    ))}
                  </Section>
                </Collapsible>
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

export const AdminChatTab = (props) => {
  const { act, data } = useBackend();
  const { messages = [] } = data;
  return (
    <Stack vertical fill>
      <Stack.Item grow={10}>
        <Section scrollable fill>
          {messages.map((message) => (
            <Box key={message.msg}>{message.msg}</Box>
          ))}
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Input
          height="22px"
          fluid
          selfClear
          placeholder="使用'/'发送消息或命令"
          mt={1}
          onEnter={(e, value) =>
            act('send_message', {
              message: value,
            })
          }
        />
      </Stack.Item>
    </Stack>
  );
};

export const AdminTab = (props) => {
  const { act, data } = useBackend();
  const {
    request_updates_muted,
    approved,
    denied,
    objectives = [],
    selected_equipment = [],
    backstory,
    blocked,
    equipment_issued,
    owner_mob,
    owner_role,
    raw_status,
  } = data;
  return (
    <Stack vertical grow>
      <Stack.Item>
        <Section title="用户信息">
          <LabeledList>
            <LabeledList.Item label="姓名">{owner_mob}</LabeledList.Item>
            <LabeledList.Item label="角色">{owner_role}</LabeledList.Item>
            <LabeledList.Item label="申请状态">{raw_status}</LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="管理员控制面板">
          <Stack mb={1}>
            <Stack.Item>
              <Button
                icon="check"
                color="good"
                tooltip="批准申请和任何已批准的目标."
                disabled={approved}
                content="批准"
                onClick={() => act('approve')}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="check-double"
                color="orange"
                tooltip="批准所有目标和装备以及申请，确保你已经进行了审查."
                disabled={approved}
                content="批准所有"
                onClick={() => act('approve_all')}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="universal-access"
                color="purple"
                disabled={!approved || equipment_issued}
                tooltip="发放所有批准装备给玩家"
                content="发放装备"
                onClick={() => act('issue_gear')}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="times"
                color="red"
                disabled={denied}
                content="否决"
                onClick={() => act('deny')}
              />
            </Stack.Item>
            <Stack.Item>
              {blocked ? (
                <Button
                  icon="check-circle"
                  color="green"
                  tooltip="解除用户申请封禁."
                  content="解除用户封禁"
                  onClick={() => act('toggle_block')}
                />
              ) : (
                <Button
                  icon="ban"
                  color="red"
                  tooltip="封禁用户申请提交."
                  content="封禁用户"
                  onClick={() => act('toggle_block')}
                />
              )}
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="suitcase"
                color="blue"
                tooltip="将自己指定为处理管理员."
                content="处理"
                onClick={() => act('handle')}
              />
            </Stack.Item>
          </Stack>
          <Stack>
            <Stack.Item>
              {request_updates_muted ? (
                <Button
                  icon="volume-up"
                  color="green"
                  content="解除求助禁言"
                  onClick={() => act('mute_request_updates')}
                />
              ) : (
                <Button
                  icon="volume-mute"
                  color="red"
                  content="求助禁言"
                  onClick={() => act('mute_request_updates')}
                />
              )}
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="compress-arrows-alt"
                color="teal"
                tooltip="跟随用户mob"
                content="跟随"
                onClick={() => act('flw_user')}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section title="背景故事">
          {backstory.length === 0 ? (
            <Box color="bad">未设置背景故事.</Box>
          ) : (
            <Box preserveWhitespace>{backstory}</Box>
          )}
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section title="目标">
          {objectives.length === 0 ? (
            <Box color="bad">未选择目标.</Box>
          ) : (
            objectives.map((objective, index) => (
              <Section
                title={index + 1 + '. ' + objective.title}
                key={objective.id}
                buttons={
                  <>
                    <Button
                      icon="check"
                      color="good"
                      disabled={
                        objective.approved &&
                        objective.status_text !== '暂未评估'
                      }
                      content="批准目标"
                      onClick={() =>
                        act('approve_objective', {
                          objective_ref: objective.ref,
                        })
                      }
                    />
                    <Button
                      icon="times"
                      color="bad"
                      disabled={
                        !objective.approved &&
                        objective.status_text !== '暂未评估'
                      }
                      content="否决目标"
                      onClick={() =>
                        act('deny_objective', {
                          objective_ref: objective.ref,
                        })
                      }
                    />
                  </>
                }
              >
                <LabeledList key={objective.id}>
                  <LabeledList.Item label="描述">
                    {objective.description}
                  </LabeledList.Item>
                  <LabeledList.Item label="缘由/义理">
                    {objective.justification}
                  </LabeledList.Item>
                  <LabeledList.Item label="强度">
                    {'(' +
                      objective.intensity +
                      ') ' +
                      objective.text_intensity}
                  </LabeledList.Item>
                  <LabeledList.Item label="状态">
                    {objective.status_text === '暂未评估'
                      ? '目标暂未评估'
                      : objective.approved
                        ? '目标被批准'
                        : objective.denied_text
                          ? '目标被否决 - 原因: ' + objective.denied_text
                          : '目标被否决'}
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            ))
          )}
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section title="装备">
          {selected_equipment.length === 0 ? (
            <Box color="bad">未选择装备.</Box>
          ) : (
            selected_equipment.map((equipment, index) => (
              <Section
                title={equipment.name}
                key={equipment.ref}
                buttons={
                  <>
                    <Button
                      icon="check"
                      color="good"
                      disabled={
                        equipment.approved && equipment.status !== '暂未评估'
                      }
                      content="批准装备"
                      onClick={() =>
                        act('approve_equipment', {
                          selected_equipment_ref: equipment.ref,
                        })
                      }
                    />
                    <Button
                      icon="times"
                      color="bad"
                      disabled={
                        !equipment.approved && equipment.status !== '暂未评估'
                      }
                      content="否决装备"
                      onClick={() =>
                        act('deny_equipment', {
                          selected_equipment_ref: equipment.ref,
                        })
                      }
                    />
                  </>
                }
              >
                <LabeledList key={equipment.ref}>
                  <LabeledList.Item label="描述">
                    {equipment.description}
                  </LabeledList.Item>
                  <LabeledList.Item label="原因">
                    {equipment.reason}
                  </LabeledList.Item>
                  <LabeledList.Item label="状态">
                    {equipment.denied_reason
                      ? equipment.status + ' - 原因: ' + equipment.denied_reason
                      : equipment.status}
                  </LabeledList.Item>
                  <LabeledList.Item label="数量">
                    {equipment.count}
                  </LabeledList.Item>
                  <LabeledList.Item label="装备注释">
                    {equipment.admin_note}
                  </LabeledList.Item>
                </LabeledList>
              </Section>
            ))
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
