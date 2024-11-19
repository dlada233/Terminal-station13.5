import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  name: string;
  currentSection: number;
};

const PREFIXES = [
  '黑暗',
  '地狱',
  '堕落',
  '恐惧',
  '罪孽',
  '血腥',
  '毛茸茸',
] as const;

const TITLES = ['之主', '教士', '伯爵', '子爵', '宰相', '老人', '家'] as const;

const NAMES = [
  'hal',
  've',
  'odr',
  'neit',
  'ci',
  'quon',
  'mya',
  'folth',
  'wren',
  'geyr',
  'hil',
  'niet',
  'twou',
  'phi',
  'coa',
] as const;

const SUFFIXES = ['很红', '无魂者', '大师', '万物之主', 'Jr.'] as const;

export const CodexGigas = (props) => {
  const { act, data } = useBackend<Data>();
  const { name, currentSection } = data;

  return (
    <Window width={450} height={450}>
      <Window.Content>
        <Section>
          {name}
          <LabeledList>
            <Prefixes />
            <Titles />
            <Names />
            <Suffixes />
            <LabeledList.Item label="提交">
              <Button
                content="搜索"
                disabled={currentSection < 4}
                onClick={() => act('search')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};

const Prefixes = (props) => {
  const { act, data } = useBackend<Data>();
  const { currentSection } = data;

  return (
    <LabeledList.Item label="前缀">
      {PREFIXES.map((prefix) => (
        <Button
          key={prefix.toLowerCase()}
          content={prefix}
          disabled={currentSection !== 1}
          onClick={() => act(prefix + ' ')}
        />
      ))}
    </LabeledList.Item>
  );
};

const Titles = (props) => {
  const { act, data } = useBackend<Data>();
  const { currentSection } = data;

  return (
    <LabeledList.Item label="头衔">
      {TITLES.map((title) => (
        <Button
          key={title.toLowerCase()}
          content={title}
          disabled={currentSection !== 2}
          onClick={() => act(title)}
        />
      ))}
    </LabeledList.Item>
  );
};

const Names = (props) => {
  const { act, data } = useBackend<Data>();
  const { currentSection } = data;

  return (
    <LabeledList.Item label="名字">
      {NAMES.map((name) => (
        <Button
          key={name.toLowerCase()}
          content={name}
          disabled={currentSection !== 3}
          onClick={() => act(name)}
        />
      ))}
    </LabeledList.Item>
  );
};

const Suffixes = (props) => {
  const { act, data } = useBackend<Data>();
  const { currentSection } = data;

  return (
    <LabeledList.Item label="后缀">
      {SUFFIXES.map((suffix) => (
        <Button
          key={suffix.toLowerCase()}
          content={suffix}
          disabled={currentSection !== 4}
          onClick={() => act(' ' + suffix)}
        />
      ))}
    </LabeledList.Item>
  );
};
