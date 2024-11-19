import { useState } from 'react';

import { useBackend } from '../backend';
import { Button, DmIcon, NoticeBox, Section, Stack } from '../components';
import { NtosWindow } from '../layouts';

type Data = {
  dmi: {
    icon: string;
    icon_state: string;
  };
};

export const NtosCursor = () => {
  const { data } = useBackend<Data>();

  const { dmi } = data;

  const [numClicked, incrementClicked] = useState(0);

  const NoticeBoxText = () => {
    if (numClicked <= 2) {
      return `只有一个选项...那就是剑.`;
    } else if (numClicked === 3) {
      return `你点击了剑，它仍然是剑.`;
    } else if (numClicked === 4) {
      return `你又点击了剑，它还是剑.`;
    } else if (numClicked === 5) {
      return `又试着点了一次剑? 但它还是剑.`;
    }
    return `你点击了 ${numClicked} 次剑...它依然是剑.`;
  };

  return (
    <NtosWindow width={350} height={300}>
      <NtosWindow.Content scrollable>
        <Section title="选择光标">
          <Stack vertical>
            <Stack.Item align={'center'}>
              <Button
                height="100px"
                width="100px"
                color={numClicked >= 1 ? 'green' : null}
                onClick={() => incrementClicked(numClicked + 1)}
              >
                <DmIcon
                  icon={dmi.icon}
                  icon_state={dmi.icon_state}
                  style={{
                    transform: `scale(3) translateX(4px) translateY(8px)`,
                  }}
                />
              </Button>
            </Stack.Item>
            <Stack.Item>
              <NoticeBox>{NoticeBoxText()}</NoticeBox>
            </Stack.Item>
          </Stack>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
