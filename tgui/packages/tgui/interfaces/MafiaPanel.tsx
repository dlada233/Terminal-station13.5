import { BooleanLike, classes } from 'common/react';
import { decodeHtmlEntities } from 'common/string';
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Collapsible,
  Flex,
  NoticeBox,
  Section,
  Stack,
  Tabs,
  TextArea,
} from '../components';
import { formatTime } from '../format';
import { Window } from '../layouts';

type RoleInfo = {
  role_theme: string;
  role: string;
  desc: string;
  hud_icon: string;
  revealed_icon: string;
};

type PlayerInfo = {
  name: string;
  role_revealed: string;
  is_you: BooleanLike;
  ref: string;
  alive: string;
  possible_actions: ActionInfo[];
  votes: number;
};

type ActionInfo = {
  name: string;
  ref: string;
};

type LobbyData = {
  name: string;
  status: string;
};

type MessageData = {
  msg: string;
};

type MafiaData = {
  players: PlayerInfo[];
  lobbydata: LobbyData[];
  messages: MessageData[];
  user_notes: string;
  roleinfo: RoleInfo;
  phase: string;
  turn: number;
  timeleft: number;
  is_observer: boolean;
  all_roles: string[];
  admin_controls: boolean;
  person_voted_up_ref: string;
  player_voted_up: BooleanLike;
};

export const MafiaPanelData = (props) => {
  const { act, data } = useBackend<MafiaData>();
  const { phase, roleinfo, admin_controls, messages, player_voted_up } = data;
  const [mafia_tab, setMafiaMode] = useState('Role list');

  if (phase === 'No Game') {
    return (
      <Stack fill vertical>
        <MafiaLobby />
        {!!admin_controls && <MafiaAdmin />}
      </Stack>
    );
  }

  return (
    <Stack fill>
      {!!roleinfo && (
        <Stack.Item grow>
          <MafiaChat />
        </Stack.Item>
      )}
      <Stack.Item grow>
        <Stack fill vertical>
          {!!roleinfo && (
            <>
              <Stack.Item>
                <MafiaRole />
              </Stack.Item>
              {phase === 'Judgment' && !player_voted_up && (
                <Stack.Item>
                  <MafiaJudgement />
                </Stack.Item>
              )}
            </>
          )}

          <Stack.Item>{!!admin_controls && <MafiaAdmin />}</Stack.Item>

          {phase !== 'No Game' && (
            <Stack.Item>
              <Stack fill>
                <>
                  <Stack.Item grow>
                    <MafiaPlayers />
                  </Stack.Item>
                  <Stack.Item grow>
                    <Stack.Item>
                      <Tabs fluid>
                        <Tabs.Tab
                          align="center"
                          selected={mafia_tab === 'Role list'}
                          onClick={() => setMafiaMode('Role list')}
                        >
                          角色列表
                          <Button
                            color="transparent"
                            icon="address-book"
                            tooltipPosition="bottom-start"
                            tooltip={`
                            这是游戏中的角色列表，你可以按下问好按钮来获得关于这个角色的简短介绍.`}
                          />
                        </Tabs.Tab>
                        <Tabs.Tab
                          align="center"
                          selected={mafia_tab === 'Notes'}
                          onClick={() => setMafiaMode('Notes')}
                        >
                          笔记
                          <Button
                            color="transparent"
                            icon="pencil"
                            tooltipPosition="bottom-start"
                            tooltip={`
                            这是你的笔记，你可以写下任何东西以备将来参考，你也可以按下按钮来把它
                            发送到聊天对话中.`}
                          />
                        </Tabs.Tab>
                      </Tabs>
                    </Stack.Item>
                    {mafia_tab === 'Role list' && <MafiaListOfRoles />}
                    {mafia_tab === 'Notes' && <MafiaNotesTab />}
                  </Stack.Item>
                </>
              </Stack>
            </Stack.Item>
          )}
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

export const MafiaPanel = (props) => {
  const { act, data } = useBackend<MafiaData>();
  const { roleinfo } = data;
  return (
    <Window
      title="狼人杀"
      theme={roleinfo && roleinfo.role_theme}
      width={900}
      height={600}
    >
      <Window.Content>
        <MafiaPanelData />
      </Window.Content>
    </Window>
  );
};

const MafiaChat = (props) => {
  const { act, data } = useBackend<MafiaData>();
  const { messages } = data;
  const [message_to_send, setMessagingBox] = useState('');
  return (
    <Stack vertical fill>
      {!!messages && (
        <>
          <Section fill scrollable title="聊天日志">
            {messages.map((message) => (
              <Box key={message.msg}>{decodeHtmlEntities(message.msg)}</Box>
            ))}
          </Section>
          <TextArea
            fluid
            height="10%"
            maxLength={300}
            className="Section__title candystripe"
            onChange={(e, value) => setMessagingBox(value)}
            placeholder="输入聊天内容"
            value={message_to_send}
          />
          <Button
            color="bad"
            fluid
            textAlign="center"
            tooltip="发送消息至聊天对话中."
            onClick={() => {
              setMessagingBox('');
              act('send_message_to_chat', { message: message_to_send });
            }}
          >
            发送
          </Button>
        </>
      )}
    </Stack>
  );
};

const MafiaLobby = (props) => {
  const { act, data } = useBackend<MafiaData>();
  const { lobbydata = [], is_observer } = data;
  const readyGhosts = lobbydata
    ? lobbydata.filter((player) => player.status === 'Ready')
    : null;
  return (
    <Section
      fill
      scrollable
      title="大厅"
      buttons={
        <>
          <Button
            icon="clipboard-check"
            tooltipPosition="bottom-start"
            tooltip={`
              报名参加游戏. 如果游戏已经在进行了，你将报名下一场游戏.
            `}
            content="报名"
            onClick={() => act('mf_signup')}
          />
          <Button
            icon="arrow-right"
            tooltipPosition="bottom-start"
            tooltip={`
              投票提议提前开始游戏.
              当有一半报名者投票后就会提前开始.
              至少需要有六名玩家.
            `}
            content="Start Now!"
            onClick={() => act('vote_to_start')}
          />
        </>
      }
    >
      <NoticeBox info textAlign="center">
        大厅当前有 {readyGhosts ? readyGhosts.length : '0'}/12 有效报名玩家.
      </NoticeBox>
      {!!is_observer && (
        <NoticeBox color="green" textAlign="center">
          在死亡情况下报名狼人杀的玩家将在游戏结束后返回自己的身体，允许你暂时离开游戏.
        </NoticeBox>
      )}
      {lobbydata.map((lobbyist) => (
        <Stack
          key={lobbyist.name}
          className="candystripe"
          p={1}
          align="baseline"
        >
          <Stack.Item grow>
            {!is_observer ? '未知玩家' : lobbyist.name}
          </Stack.Item>
          <Stack.Item>状态:</Stack.Item>
          <Stack.Item color={lobbyist.status === '准备' ? 'green' : 'red'}>
            {lobbyist.status}
          </Stack.Item>
        </Stack>
      ))}
    </Section>
  );
};

const MafiaRole = (props) => {
  const { act, data } = useBackend<MafiaData>();
  const { phase, turn, roleinfo, timeleft } = data;
  return (
    <Section
      fill
      title={phase + turn}
      minHeight="100px"
      maxHeight="50px"
      buttons={
        <Box
          lineHeight={1.5}
          fontFamily="Consolas, monospace"
          fontSize="14px"
          fontWeight="bold"
        >
          {formatTime(timeleft)}
        </Box>
      }
    >
      <Stack align="center">
        <Stack.Item grow>
          <Box bold>你的身份是 {roleinfo.role}</Box>
          <Box italic>{roleinfo.desc}</Box>
        </Stack.Item>
        <Stack.Item>
          <Box
            className={classes(['mafia32x32', roleinfo.revealed_icon])}
            style={{
              transform: 'scale(2) translate(0px, 10%)',
              verticalAlign: 'middle',
            }}
          />
          <Box
            className={classes(['mafia32x32', roleinfo.hud_icon])}
            style={{
              transform: 'scale(2) translate(-5px, -5px)',
              verticalAlign: 'middle',
            }}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const MafiaListOfRoles = (props) => {
  const { act, data } = useBackend<MafiaData>();
  const { all_roles } = data;
  return (
    <Section fill>
      <Flex direction="column">
        {all_roles?.map((r) => (
          <Flex.Item key={r} className="Section__title candystripe">
            <Flex align="center" justify="space-between">
              <Flex.Item>{r}</Flex.Item>
              <Flex.Item textAlign="right">
                <Button
                  color="transparent"
                  icon="question"
                  onClick={() =>
                    act('mf_lookup', {
                      role_name: r.slice(0, -3),
                    })
                  }
                />
              </Flex.Item>
            </Flex>
          </Flex.Item>
        ))}
      </Flex>
    </Section>
  );
};

const MafiaNotesTab = (props) => {
  const { act, data } = useBackend<MafiaData>();
  const { user_notes } = data;
  const [note_message, setNotesMessage] = useState(user_notes);
  return (
    <Section fill>
      <TextArea
        height="80%"
        maxLength={600}
        className="Section__title candystripe"
        onChange={(_, value) => setNotesMessage(value)}
        placeholder="添加笔记..."
        value={note_message}
      />

      <Button
        color="good"
        fluid
        textAlign="center"
        onClick={() => act('change_notes', { new_notes: note_message })}
        tooltip="保存任何笔记上的内容，当死亡时不可用."
      >
        保存
      </Button>
      <Button.Confirm
        color="bad"
        fluid
        content="发送至聊天"
        textAlign="center"
        onClick={() => act('send_notes_to_chat')}
      />
    </Section>
  );
};

const MafiaJudgement = (props) => {
  const { act, data } = useBackend();
  return (
    <Section title="审判">
      <Flex>
        <Button
          icon="smile-beam"
          color="good"
          onClick={() => act('vote_innocent')}
        >
          无辜
        </Button>
        <Box>现在是投票的时候，决定被告是有罪还是无辜的!</Box>
        <Button icon="angry" color="bad" onClick={() => act('vote_guilty')}>
          有罪
        </Button>
      </Flex>
      <Flex justify="center">
        <Button icon="meh" color="white" onClick={() => act('vote_abstain')}>
          弃权
        </Button>
      </Flex>
    </Section>
  );
};

const MafiaPlayers = (props) => {
  const { act, data } = useBackend<MafiaData>();
  const { players = [], person_voted_up_ref } = data;
  return (
    <Section fill scrollable title="玩家">
      <Flex direction="column" fill justify="space-around">
        {players?.map((player) => (
          <Flex.Item className="Section__title candystripe" key={player.ref}>
            <Stack align="center">
              <Stack.Item
                grow
                color={!player.alive && 'red'}
                backgroundColor={
                  player.ref === person_voted_up_ref ? 'yellow' : null
                }
              >
                {player.name}
                {(!!player.is_you && ' (你)') ||
                  (!!player.role_revealed && ' - ' + player.role_revealed)}
              </Stack.Item>
              <Stack.Item>
                {player.votes !== undefined &&
                  !!player.alive &&
                  `投票: ${player.votes}`}
              </Stack.Item>
              <Stack.Item minWidth="42px" textAlign="center">
                {player.possible_actions?.map((action) => (
                  <Button
                    key={action.name}
                    onClick={() =>
                      act('perform_action', {
                        action_ref: action.ref,
                        target: player.ref,
                      })
                    }
                  >
                    {action.name}
                  </Button>
                ))}
              </Stack.Item>
            </Stack>
          </Flex.Item>
        ))}
      </Flex>
    </Section>
  );
};

const MafiaAdmin = (props) => {
  const { act, data } = useBackend();
  return (
    <Collapsible title="管理控制面板" color="red">
      <Section>
        <Collapsible title="善意的告知" color="transparent">
          所有功能仅为帮助调试游戏 (一款12人的游戏!).
          因此它们非常基础，而且随时可能崩溃. 在启动某个功能前确保你知道自己在做
          什么. 因为是管理员设置：请不要随意 碎尸/删除/清除 任何人!
          这会让游戏运行 时崩溃.
        </Collapsible>
        <Button icon="arrow-right" onClick={() => act('next_phase')}>
          下一阶段
        </Button>
        <Button icon="home" onClick={() => act('players_home')}>
          让所有玩家返回
        </Button>
        <Button icon="sync-alt" onClick={() => act('new_game')}>
          新游戏
        </Button>
        <Button icon="skull" onClick={() => act('nuke')}>
          Nuke
        </Button>
        <br />
        <Button icon="paint-brush" onClick={() => act('debug_setup')}>
          创建自定义设置
        </Button>
        <Button icon="paint-roller" onClick={() => act('cancel_setup')}>
          重置自定义设置
        </Button>
        <Button icon="magic" onClick={() => act('start_now')}>
          立即开始!
        </Button>
      </Section>
    </Collapsible>
  );
};
