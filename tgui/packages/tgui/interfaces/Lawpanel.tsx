import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  Button,
  Collapsible,
  Dimmer,
  Flex,
  Icon,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

const lawtype_to_color = {
  inherent: 'white',
  supplied: 'purple',
  ion: 'green',
  hacked: 'orange',
  zeroth: 'red',
} as const;

const lawtype_to_tooltip = {
  inherent: `核心法律.
    AI的固有法律被称为"核心法律"，
    重置AI也无法将其消除，
    无论运行于何种法律体系中都会固定存在.`,
  supplied: `附加法律.
    附加法律是在固有法律的基础上额外设置的，
    会随着AI重置而被移除.`,
  ion: `离子法律.
    通常而言是随机生成的特殊法律，凌驾于其他所有法律之上，
    会随着AI重置而被移除.`,
  hacked: `骇入法律.
    辛迪加上传的法律，凌驾于其他所有法律之上，
    会随着AI重置而被移除.`,
  zeroth: `零号法律.
    每个法律体系只能拥有一条零号法律，它的地位至高无上；
    这产生于故障AI，允许它为所欲为，
    除非管理员强制干预，否则没有任何东西能够移除零号法律.`,
} as const;

type Law = {
  lawtype: string;
  // The actual law text
  law: string;
  // Law index in the list
  // Zeroth laws will always be "zero"
  // and hacked/ion laws will have an index of -1
  num: number;
};

type Silicon = {
  // Name of the silicon. Includes PAI and AI
  borg_name: string;
  borg_type: string;
  // List of our laws, this is almost never null. If it is null, that's an error.
  laws: null | Law[];
  // String, name of our master AI. Null means no master or we're not a borg
  master_ai?: null | string;
  // TRUE, we're law-synced to our master AI. FALSE, we're not, null, we're not a borg
  borg_synced?: null | BooleanLike;
  // REF() to our silicon
  ref: string;
};

type Data = {
  all_silicons: Silicon[];
};

const SyncedBorgDimmer = (props: { master: string }) => {
  return (
    <Dimmer>
      <Stack textAlign="center" vertical>
        <Stack.Item>
          <Icon color="green" name="wifi" size={10} />
        </Stack.Item>
        <Stack.Item fontSize="18px">
          这台赛博被连接到 &quot;{props.master}&quot;.
        </Stack.Item>
        <Stack.Item fontSize="14px">修改它的法律.</Stack.Item>
      </Stack>
    </Dimmer>
  );
};

export const LawPrintout = (props: { cyborg_ref: string; lawset: Law[] }) => {
  const { data, act } = useBackend<Law>();
  const { cyborg_ref, lawset } = props;

  let num_of_each_lawtype = [];

  lawset.forEach((law) => {
    if (!num_of_each_lawtype[law.lawtype]) {
      num_of_each_lawtype[law.lawtype] = 0;
    }
    num_of_each_lawtype[law.lawtype] += 1;
  });

  return (
    <LabeledList>
      {lawset.map((law, index) => (
        <>
          <LabeledList.Item
            key={index}
            label={law.num >= 0 ? `${law.num}` : '?!$'}
            color={lawtype_to_color[law.lawtype] || 'pink'}
            buttons={
              <Stack>
                <Stack.Item>
                  <Button
                    icon="question"
                    tooltip={
                      lawtype_to_tooltip[law.lawtype] ||
                      `由于某种原因，这种法律类型未被识别，可能是bug，请上报问题.`
                    }
                    color={lawtype_to_color[law.lawtype] || 'pink'}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    icon="trash"
                    confirmContent=""
                    confirmIcon="check"
                    color={'red'}
                    onClick={() =>
                      act('remove_law', {
                        ref: cyborg_ref,
                        law: law.law,
                        lawtype: law.lawtype,
                      })
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="pen-ruler"
                    color={'green'}
                    tooltip={'编辑法律文本.'}
                    onClick={() =>
                      act('edit_law_text', {
                        ref: cyborg_ref,
                        law: law.law,
                        lawtype: law.lawtype,
                      })
                    }
                  />
                </Stack.Item>
                {law.lawtype === 'inherent' && (
                  <>
                    <Stack.Item>
                      <Button
                        icon="arrow-up"
                        color={'green'}
                        disabled={law.num === 1}
                        onClick={() =>
                          act('move_law', {
                            ref: cyborg_ref,
                            law: law.law,
                            // may seem confusing at a glance,
                            // but pressing up = actually moving it down.
                            direction: 'down',
                          })
                        }
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="arrow-down"
                        color={'green'}
                        disabled={law.num === num_of_each_lawtype['inherent']}
                        onClick={() =>
                          act('move_law', {
                            ref: cyborg_ref,
                            law: law.law,
                            // may seem confusing at a glance,
                            // but pressing down = actually moving it up.
                            direction: 'up',
                          })
                        }
                      />
                    </Stack.Item>
                  </>
                )}
                {law.lawtype === 'supplied' && (
                  <Stack.Item>
                    <Button
                      icon="pen-to-square"
                      color={'green'}
                      tooltip={'编辑法律优先级.'}
                      onClick={() =>
                        act('edit_law_prio', {
                          ref: cyborg_ref,
                          law: law.law,
                        })
                      }
                    />
                  </Stack.Item>
                )}
              </Stack>
            }
          >
            {law.law}
          </LabeledList.Item>
          <LabeledList.Divider />
        </>
      ))}
      <LabeledList.Item label="???">
        <Button
          icon="plus"
          color={'green'}
          content={'添加法律'}
          onClick={() => act('add_law', { ref: cyborg_ref })}
        />
      </LabeledList.Item>
      <LabeledList.Divider />
    </LabeledList>
  );
};

export const SiliconReadout = (props: { cyborg: Silicon }) => {
  const { data, act } = useBackend<Silicon>();
  const { cyborg } = props;

  return (
    <Flex>
      <Flex.Item grow>
        <Collapsible title={`${cyborg.borg_type}: ${cyborg.borg_name}`}>
          <Section backgroundColor={'black'}>
            {cyborg.master_ai && !!cyborg.borg_synced && (
              <SyncedBorgDimmer master={cyborg.master_ai} />
            )}
            <Stack vertical>
              <Stack.Item>
                {cyborg.laws === null ? (
                  <Button
                    fluid
                    textAlign="center"
                    color="danger"
                    content={`这台硅基有一个null law datum，这不应该出现，请点击这个生成报告并发送.`}
                    onClick={() => act('give_law_datum', { ref: cyborg.ref })}
                  />
                ) : (
                  <LawPrintout lawset={cyborg.laws} cyborg_ref={cyborg.ref} />
                )}
              </Stack.Item>
              <Stack.Item>
                <Stack>
                  <Stack.Item>
                    <Button
                      icon="bullhorn"
                      content={'强制陈述法律'}
                      tooltip={`强迫这台硅基陈述法律，
                        只陈述固有/核心法律.`}
                      onClick={() =>
                        act('force_state_laws', { ref: cyborg.ref })
                      }
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="message"
                      content={'秘密显示法律'}
                      tooltip={`在硅基的聊天框中显示所有法律，也向所有与AI连接的赛博显示.`}
                      onClick={() =>
                        act('announce_law_changes', { ref: cyborg.ref })
                      }
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="bell"
                      content={'"法律上传"警报'}
                      tooltip={`想硅基抛出警报，通知它们法律已经更新了. 还会通知死后聊天频道和在聊天频道显示.`}
                      onClick={() =>
                        act('laws_updated_alert', { ref: cyborg.ref })
                      }
                    />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Section>
        </Collapsible>
      </Flex.Item>
    </Flex>
  );
};

export const Lawpanel = (props) => {
  const { data, act } = useBackend<Data>();
  const { all_silicons } = data;

  return (
    <Window title="法律面板" theme="admin" width={800} height={600}>
      <Window.Content>
        <Section
          fill
          title="全部硅基法律"
          scrollable
          buttons={
            <Button
              icon="robot"
              content="日志"
              onClick={() => act('lawchange_logs')}
            />
          }
        >
          <Stack vertical>
            {all_silicons.length ? (
              all_silicons.map((silicon, index) => (
                <Stack.Item key={index}>
                  <SiliconReadout cyborg={silicon} />
                </Stack.Item>
              ))
            ) : (
              <Stack.Item>
                <NoticeBox>硅基生命未存在.</NoticeBox>
              </Stack.Item>
            )}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
