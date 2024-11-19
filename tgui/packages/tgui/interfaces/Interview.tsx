import { ReactNode, useState } from 'react';

import { useBackend } from '../backend';
import {
  BlockQuote,
  Box,
  Button,
  NoticeBox,
  Section,
  TextArea,
} from '../components';
import { Window } from '../layouts';

type Data = {
  connected: boolean;
  is_admin: boolean;
  questions: Question[];
  queue_pos: number;
  read_only: boolean;
  status: string;
  welcome_message: string;
};

type Question = {
  qidx: number;
  question: string;
  response: string | null;
};

enum STATUS {
  Approved = 'interview_approved',
  Denied = 'interview_denied',
}

// Matches a complete markdown-style link, capturing the whole [...](...)
const linkRegex = /(\[[^[]+\]\([^)]+\))/;
// Decomposes a markdown-style link into the link and display text
const linkDecomposeRegex = /\[([^[]+)\]\(([^)]+)\)/;

// Renders any markdown-style links within a provided body of text
const linkifyText = (text: string) => {
  let parts: ReactNode[] = text.split(linkRegex);
  for (let i = 1; i < parts.length; i += 2) {
    const match = linkDecomposeRegex.exec(parts[i] as string);
    if (!match) continue;

    parts[i] = (
      <a key={'link' + i} href={match[2]}>
        {match[1]}
      </a>
    );
  }
  return parts;
};

export const Interview = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    connected,
    is_admin,
    questions = [],
    queue_pos,
    read_only,
    status,
    welcome_message = '',
  } = data;

  const allAnswered = questions.every((q) => q.response);
  const numAnswered = questions.filter((q) => q.response)?.length;

  return (
    <Window
      width={500}
      height={600}
      canClose={is_admin || status === 'interview_approved'}
    >
      <Window.Content scrollable>
        {(!read_only && (
          <Section title="欢迎!">
            <p>{linkifyText(welcome_message)}</p>
          </Section>
        )) || <RenderedStatus status={status} queue_pos={queue_pos} />}
        <Section
          title="调查问卷"
          buttons={
            <span>
              <Button
                onClick={() => act('submit')}
                disabled={read_only || !allAnswered || !questions.length}
                icon="envelope"
                tooltip={
                  !allAnswered &&
                  `请回答所有问题.
                     ${numAnswered} / ${questions.length}`
                }
              >
                {read_only ? '已提交' : '提交'}
              </Button>
              {!!is_admin && status === 'interview_pending' && (
                <span>
                  <Button disabled={!connected} onClick={() => act('adminpm')}>
                    管理员PM
                  </Button>
                  <Button color="good" onClick={() => act('approve')}>
                    赞同
                  </Button>
                  <Button color="bad" onClick={() => act('deny')}>
                    否决
                  </Button>
                </span>
              )}
            </span>
          }
        >
          {!read_only && (
            <>
              <Box as="p" color="label">
                请回答以下问题.
                <ul>
                  <li>您可以按回车键或保存按钮保存回答.</li>
                  <li>您随时可以编辑您的答案，直到按下提交按钮为止.</li>
                  <li>当您完成后，就按下提交按钮.</li>
                </ul>
              </Box>
              <NoticeBox info align="center">
                提交后，您将无法再编辑您的答案.
              </NoticeBox>
            </>
          )}
          {questions.map((question) => (
            <QuestionArea key={question.qidx} {...question} />
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};

const RenderedStatus = (props: { status: string; queue_pos: number }) => {
  const { status, queue_pos } = props;

  switch (status) {
    case STATUS.Approved:
      return <NoticeBox success>这项调查被批准了.</NoticeBox>;
    case STATUS.Denied:
      return <NoticeBox danger>这项调查被否决了.</NoticeBox>;
    default:
      return (
        <NoticeBox info>
          您的答案已经提交. 您在队列中的位置为{queue_pos}.
        </NoticeBox>
      );
  }
};

const QuestionArea = (props: Question) => {
  const { qidx, question, response } = props;
  const { act, data } = useBackend<Data>();
  const { is_admin, read_only } = data;

  const [userInput, setUserInput] = useState(response);

  const saveResponse = () => {
    act('update_answer', {
      qidx,
      answer: userInput,
    });
  };

  const changedResponse = userInput !== response;

  const saveAvailable = !read_only && !!userInput && changedResponse;

  const isSaved = !!response && !changedResponse;

  return (
    <Section
      title={`问题 ${qidx}`}
      buttons={
        <Button
          disabled={!saveAvailable}
          onClick={saveResponse}
          icon={isSaved ? 'check' : 'save'}
        >
          {isSaved ? '已保存' : '保存'}
        </Button>
      }
    >
      <p>{linkifyText(question)}</p>
      {((read_only || is_admin) && (
        <BlockQuote>{response || '无回应.'}</BlockQuote>
      )) || (
        <TextArea
          fluid
          height={10}
          maxLength={500}
          onChange={(e, input) => setUserInput(input)}
          onEnter={saveResponse}
          placeholder="在这里写下您的回答，最多500字符，按回车键提交."
          value={response || undefined}
        />
      )}
    </Section>
  );
};
