// THIS IS A SKYRAT UI FILE
import { useBackend, useLocalState } from '../backend';
import {
  Button,
  Collapsible,
  LabeledList,
  Section,
  TextArea,
} from '../components';
import { Window } from '../layouts';

type StoryManagerData = {
  current_stories: Story[];
  archived_stories: Story[];
  current_date: string;
};

type Story = {
  title: string;
  text: string;
  id: string;
  year: string;
  month: string;
  day: string;
};

export const StoryManager = (props) => {
  const { data, act } = useBackend<StoryManagerData>();
  const { current_stories, archived_stories, current_date } = data;

  const [title, setTitle] = useLocalState('title', '');
  const [text, setText] = useLocalState('text', '');
  const [id, setID] = useLocalState('id', '');

  return (
    <Window width={600} height={800} title="背景故事管理器">
      <Window.Content scrollable>
        <Section textAlign="center">
          背景故事管理器
          <br />
          <i>在这里发表的任何内容将在下一回合才会出现!</i>
          <br />
          <span style={{ color: 'red' }}>
            除非你知道自己在做什么，否则不要乱来.
          </span>
        </Section>
        <Section>
          <LabeledList>
            <LabeledList.Item label="标题">
              <TextArea
                height="20px"
                placeholder="简洁的文章标题或作者."
                onChange={(_e, value) => setTitle(value)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="正文">
              <TextArea
                height="100px"
                placeholder="文章本身."
                onChange={(_e, value) => setText(value)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="ID">
              <TextArea
                height="20px"
                placeholder="文章的唯一ID，如果设置的ID正在被使用，文章不会发表."
                onChange={(_e, value) => setID(value)}
              />
            </LabeledList.Item>
            <LabeledList.Item label="日期">
              <i>发表日期: {current_date}</i>
            </LabeledList.Item>
          </LabeledList>
          <Button
            icon="arrow-up"
            mr="9px"
            color="blue"
            onClick={() => {
              act('publish_article', {
                title: title,
                text: text,
                id: id,
              });
            }}
          >
            发表
          </Button>
        </Section>
        <Collapsible title="当前故事">
          {current_stories.map((story) => (
            <Collapsible
              bold
              key={story.id}
              title={
                story.title +
                ' | 已发表 ' +
                story.month +
                '/' +
                story.day +
                '/' +
                story.year
              }
            >
              <Section>
                {story.text}
                <br />
                <Button
                  icon="book"
                  mr="9px"
                  color="red"
                  onClick={() => {
                    act('archive_article', {
                      id: story.id,
                    });
                  }}
                >
                  存档
                </Button>
              </Section>
            </Collapsible>
          ))}
        </Collapsible>
        <Collapsible title="已存档故事">
          {archived_stories.map((story) => (
            <Collapsible
              bold
              key={story.id}
              title={
                story.title +
                ' | 已发表 ' +
                story.month +
                '/' +
                story.day +
                '/' +
                story.year
              }
            >
              <Section>
                {story.text}
                <br />
                <Button
                  icon="floppy-disk"
                  mr="9px"
                  color="green"
                  onClick={() => {
                    act('circulate_article', {
                      id: story.id,
                    });
                  }}
                >
                  传阅
                </Button>
              </Section>
            </Collapsible>
          ))}
        </Collapsible>
      </Window.Content>
    </Window>
  );
};
