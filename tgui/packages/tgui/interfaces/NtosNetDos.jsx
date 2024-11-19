import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section } from '../components';
import { NtosWindow } from '../layouts';

export const NtosNetDos = (props) => {
  return (
    <NtosWindow width={400} height={250} theme="syndicate">
      <NtosWindow.Content>
        <NtosNetDosContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const NtosNetDosContent = (props) => {
  const { act, data } = useBackend();

  const { relays = [], focus, target, speed, overload, capacity, error } = data;

  if (error) {
    return (
      <>
        <NoticeBox>{error}</NoticeBox>
        <Button
          fluid
          content="重置"
          textAlign="center"
          onClick={() => act('PRG_reset')}
        />
      </>
    );
  }

  const generate10String = (length) => {
    let outString = '';
    const factor = overload / capacity;
    while (outString.length < length) {
      if (Math.random() > factor) {
        outString += '0';
      } else {
        outString += '1';
      }
    }
    return outString;
  };

  const lineLength = 45;

  if (target) {
    return (
      <Section fontFamily="monospace" textAlign="center">
        <Box>当前速度: {speed} GQ/s</Box>
        <Box>
          {/* I don't care anymore */}
          {generate10String(lineLength)}
        </Box>
        <Box>{generate10String(lineLength)}</Box>
        <Box>{generate10String(lineLength)}</Box>
        <Box>{generate10String(lineLength)}</Box>
        <Box>{generate10String(lineLength)}</Box>
      </Section>
    );
  }

  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="目标">
          {relays.map((relay) => (
            <Button
              key={relay.id}
              content={relay.id}
              selected={focus === relay.id}
              onClick={() =>
                act('PRG_target_relay', {
                  targid: relay.id,
                })
              }
            />
          ))}
        </LabeledList.Item>
      </LabeledList>
      <Button
        fluid
        bold
        content="执行"
        color="bad"
        textAlign="center"
        disabled={!focus}
        mt={1}
        onClick={() => act('PRG_execute')}
      />
    </Section>
  );
};
