import { useBackend } from '../backend';
import { Button, Dimmer, Section, Stack } from '../components';
import { Window } from '../layouts';

const STORY_VALUE_KEY = -1;
const STORY_VALUE_SHIT = 0;
const STORY_VALUE_NONE = 1;
const STORY_VALUE_MEH = 2;
const STORY_VALUE_OKAY = 3;
const STORY_VALUE_AMAZING = 4;
const STORY_VALUE_LEGENDARY = 5;

const MemoryQuality = (props) => {
  const { act } = useBackend();
  const { quality } = props;

  if (quality === STORY_VALUE_KEY) {
    return (
      <Button
        icon="key"
        color="transparent"
        tooltipPosition="right"
        tooltip={`
          这是关键的记忆，它包含了重要信息，你可能在将来会再次检查它.
        `}
      />
    );
  }
  if (quality === STORY_VALUE_SHIT) {
    return (
      <Button
        icon="poop"
        color="transparent"
        tooltipPosition="right"
        tooltip={`
          这段记忆一点也不有趣，它可能不会成为一段好故事，也无法代代流传下去.
        `}
      />
    );
  }
  if (quality === STORY_VALUE_NONE) {
    return (
      <Button
        icon="star"
        color="transparent"
        tooltipPosition="right"
        tooltip={`
          这段记忆平平淡淡，它将成为一段平庸的故事，不太可能代代流传下去.
  `}
      />
    );
  }
  if (quality === STORY_VALUE_MEH) {
    return (
      <Button
        icon="star"
        style={{
          background:
            'linear-gradient(to right, #964B30, #D68B60, #B66B30, #D68B60, #964B30);',
        }}
        tooltipPosition="right"
        tooltip={`
          这段记忆并不算特别有趣，它可能会变成一段不错的故事，但也别抱太大期待.
    `}
      />
    );
  }
  if (quality === STORY_VALUE_OKAY) {
    return (
      <Button
        icon="star"
        style={{
          background:
            'linear-gradient(to right, #636363, #a3a3a3, #6e6e6e, #a3a3a3, #636363);',
        }}
        tooltipPosition="right"
        tooltip={`
          这段记忆还不错! 从中可以讲出一段好故事，甚至可能流传于后世.
      `}
      />
    );
  }
  if (quality === STORY_VALUE_AMAZING) {
    return (
      <Button
        icon="star"
        style={{
          background:
            'linear-gradient(to right, #AA771C, #BCB68A, #B38728, #BCB68A, #AA771C);',
        }}
        tooltipPosition="right"
        tooltip={`
          这段记忆太棒了! 你可以用它讲述一个精彩的故事，将有大概率流传于后世.
      `}
      />
    );
  }
  if (quality === STORY_VALUE_LEGENDARY) {
    return (
      <Button
        icon="crown"
        style={{
          background:
            'linear-gradient(to right, #56A5B3, #75D4E2, #56A5B3, #75D4E2, #56A5B3)',
        }}
        tooltipPosition="right"
        tooltip={`
          这段记忆充满传奇色彩!它将塑造一个传说，并很可能在后世广为流传.
        `}
      />
    );
  }
  // Default return / error
  return (
    <Button
      icon="question"
      tooltipPosition="right"
      tooltip={`
        此记忆未分配有效质量，不知道它是好是坏，这是一个bug，请上报问题!
      `}
    />
  );
};

export const MemoryPanel = (props) => {
  const { act, data } = useBackend();
  const memories = data.memories || [];
  return (
    <Window title="记忆面板" width={400} height={500}>
      <Window.Content>
        <Section
          maxHeight="32px"
          title="记忆"
          buttons={
            <Button
              color="transparent"
              tooltip={`
                这些是你的记忆，你可以做值得铭记的事情来获得记忆，然后在艺术创作中你能添加这些记忆.
              `}
              tooltipPosition="bottom-start"
              icon="info"
            />
          }
        />
        {(!memories && (
          <Dimmer fontSize="28px" align="center">
            你没有记忆!
          </Dimmer>
        )) || (
          <Stack vertical>
            {memories.map((memory) => (
              <Stack.Item key={memory.name}>
                <Section>
                  <MemoryQuality quality={memory.quality} /> {memory.name}
                </Section>
              </Stack.Item>
            ))}
          </Stack>
        )}
      </Window.Content>
    </Window>
  );
};
