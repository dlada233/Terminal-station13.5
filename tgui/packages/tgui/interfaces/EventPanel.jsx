// THIS IS A SKYRAT UI FILE
import { toFixed } from 'common/math';

import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Stack } from '../components';
import { Window } from '../layouts';

export const EventPanel = (props) => {
  const { act, data } = useBackend();
  const {
    event_list = [],
    end_time,
    vote_in_progress,
    previous_events,
    admin_mode,
    show_votes,
    next_vote_time,
    next_low_chaos_time,
  } = data;
  return (
    <Window title={'事件面板'} width={500} height={900} theme={'admin'}>
      <Window.Content>
        <Stack vertical fill>
          {!!admin_mode && (
            <Stack.Item>
              <Section title={'事件控制'}>
                <NoticeBox color="blue">
                  {'下次投票在 ' + toFixed(next_vote_time, 0) + ' 秒内.'}
                </NoticeBox>
                <NoticeBox color="blue">
                  {'低混乱事件发生在 ' +
                    toFixed(next_low_chaos_time, 0) +
                    ' 秒内.'}
                </NoticeBox>
                <Button
                  icon="plus"
                  content="开始管理员投票"
                  tooltip="为下个事件开启一次投票."
                  disabled={vote_in_progress}
                  onClick={() => act('start_vote_admin')}
                />
                <Button
                  icon="plus"
                  content="开始管理员混乱投票"
                  tooltip="为下个事件开启一次混乱投票."
                  disabled={vote_in_progress}
                  onClick={() => act('start_vote_admin_chaos')}
                />
                <Button
                  icon="user-plus"
                  content="开始玩家投票"
                  tooltip="这将开启一个公开可见的投票."
                  color="average"
                  disabled={vote_in_progress}
                  onClick={() => act('start_player_vote')}
                />
                <Button
                  icon="user-plus"
                  content="开始玩家混乱投票"
                  tooltip="这将开启一个公开可见的投票."
                  color="average"
                  disabled={vote_in_progress}
                  onClick={() => act('start_player_vote_chaos')}
                />
                <Button
                  icon="stopwatch"
                  content="结束投票"
                  tooltip="结束当前投票并执行获胜事件."
                  disabled={!vote_in_progress}
                  onClick={() => act('end_vote')}
                />
                <Button
                  icon="ban"
                  content="取消投票"
                  tooltip="取消当前投票并重置投票系统."
                  disabled={!vote_in_progress}
                  onClick={() => act('cancel_vote')}
                />
                <Button
                  icon="clock"
                  content="重新安排下次事件投票"
                  tooltip="重新安排下次定时的投票."
                  onClick={() => act('reschedule')}
                />
                <Button
                  icon="clock"
                  content="重新安排下次低混乱事件投票"
                  tooltip="重新安排下次定时的低混乱事件投票."
                  onClick={() => act('reschedule_low_chaos')}
                />
              </Section>
            </Stack.Item>
          )}
          <Stack.Item grow>
            <Section
              scrollable
              fill
              grow
              title={
                vote_in_progress
                  ? '可用事件 (' + toFixed(end_time) + ' 秒) '
                  : '可用事件'
              }
            >
              {vote_in_progress ? (
                <LabeledList>
                  {event_list.map((event) => (
                    <LabeledList.Item
                      label={event.name}
                      key={event.name}
                      buttons={
                        <Button
                          color={event.self_vote ? 'good' : 'blue'}
                          icon="vote-yea"
                          content="投票"
                          onClick={() =>
                            act('register_vote', {
                              event_ref: event.ref,
                            })
                          }
                        />
                      }
                    >
                      {!!show_votes || (!!admin_mode && event.votes)}
                    </LabeledList.Item>
                  ))}
                </LabeledList>
              ) : (
                <NoticeBox>没有投票进行中.</NoticeBox>
              )}
            </Section>
          </Stack.Item>
          {!!admin_mode && (
            <Stack.Item>
              <Section scrollable grow fill height="150px" title="过往事件">
                {previous_events.length > 0 ? (
                  <LabeledList>
                    {previous_events.map((event) => (
                      <LabeledList.Item label="事件" key={event}>
                        {event}
                      </LabeledList.Item>
                    ))}
                  </LabeledList>
                ) : (
                  <NoticeBox>无过往事件.</NoticeBox>
                )}
              </Section>
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};
