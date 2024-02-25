import { useBackend } from '../../backend';
import {
  Box,
  Button,
  Dimmer,
  Icon,
  LabeledList,
  Section,
  Stack,
} from '../../components';
import { Window } from '../../layouts';
import {
  CONSOLE_MODE_ENZYMES,
  CONSOLE_MODE_FEATURES,
  CONSOLE_MODE_SEQUENCER,
  CONSOLE_MODE_STORAGE,
  STORAGE_MODE_CONSOLE,
} from './constants';
import { DnaConsoleEnzymes } from './DnaConsoleEnzymes';
import { DnaConsoleSequencer } from './DnaConsoleSequencer';
import { DnaConsoleStorage } from './DnaConsoleStorage';
import { DnaScanner } from './DnaScanner';

export const DnaConsole = (props) => {
  const { data } = useBackend();
  const { isPulsing, timeToPulse, subjectUNI, subjectUF } = data;
  const { consoleMode } = data.view;

  return (
    <Window title="DNA 控制器" width={539} height={710}>
      {!!isPulsing && (
        <Dimmer fontSize="14px" textAlign="center">
          <Icon mr={1} name="spinner" spin />
          正在脉冲...
          <Box mt={1} />
          {timeToPulse}s
        </Dimmer>
      )}
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <DnaScanner />
          </Stack.Item>
          <Stack.Item>
            <DnaConsoleCommands />
          </Stack.Item>
          <Stack.Item grow>
            {consoleMode === CONSOLE_MODE_STORAGE && <DnaConsoleStorage />}
            {consoleMode === CONSOLE_MODE_SEQUENCER && <DnaConsoleSequencer />}
            {consoleMode === CONSOLE_MODE_ENZYMES && (
              <DnaConsoleEnzymes
                subjectBlock={subjectUNI}
                type="ui"
                name="Enzymes"
              />
            )}
            {consoleMode === CONSOLE_MODE_FEATURES && (
              <DnaConsoleEnzymes
                subjectBlock={subjectUF}
                type="uf"
                name="Features"
              />
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const DnaConsoleCommands = (props) => {
  const { data, act } = useBackend();
  const { hasDisk, isInjectorReady, injectorSeconds } = data;
  const { consoleMode } = data.view;

  return (
    <Section
      title="DNA 控制台"
      buttons={
        !isInjectorReady && (
          <Box lineHeight="20px" color="label">
            Injector on cooldown ({injectorSeconds}s)
          </Box>
        )
      }
    >
      <LabeledList>
        <LabeledList.Item label="Mode">
          <Button
            content="存储"
            selected={consoleMode === CONSOLE_MODE_STORAGE}
            onClick={() =>
              act('set_view', {
                consoleMode: CONSOLE_MODE_STORAGE,
              })
            }
          />
          <Button
            content="序列"
            disabled={!data.isViableSubject}
            selected={consoleMode === CONSOLE_MODE_SEQUENCER}
            onClick={() =>
              act('set_view', {
                consoleMode: CONSOLE_MODE_SEQUENCER,
              })
            }
          />
          <Button
            content="酶"
            selected={consoleMode === CONSOLE_MODE_ENZYMES}
            onClick={() =>
              act('set_view', {
                consoleMode: CONSOLE_MODE_ENZYMES,
              })
            }
          />
          <Button
            content="特征"
            selected={consoleMode === CONSOLE_MODE_FEATURES}
            onClick={() =>
              act('set_view', {
                consoleMode: CONSOLE_MODE_FEATURES,
              })
            }
          />
        </LabeledList.Item>
        {!!hasDisk && (
          <LabeledList.Item label="磁盘">
            <Button
              icon="eject"
              content="弹出"
              onClick={() => {
                act('eject_disk');
                act('set_view', {
                  storageMode: STORAGE_MODE_CONSOLE,
                });
              }}
            />
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};
