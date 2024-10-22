import { useEffect, useState } from 'react';

import { useBackend } from '../../backend';
import { Box, Button, Modal, Stack } from '../../components';
import { PreferencesMenuData } from './data';

export const DeleteCharacterPopup = (props: { close: () => void }) => {
  const { data, act } = useBackend<PreferencesMenuData>();
  const [secondsLeft, setSecondsLeft] = useState(3);

  const { close } = props;

  useEffect(() => {
    const interval = setInterval(() => {
      setSecondsLeft((current) => current - 1);
    }, 1000);

    return () => clearInterval(interval);
  });

  return (
    <Modal>
      <Stack vertical textAlign="center" align="center">
        <Stack.Item>
          <Box fontSize="3em">等等!</Box>
        </Stack.Item>

        <Stack.Item maxWidth="300px">
          <Box>{`你将永久删除 ${data.character_preferences.names[data.name_to_use]} . 你确定这么做吗?`}</Box>
        </Stack.Item>

        <Stack.Item>
          <Stack fill>
            <Stack.Item>
              {/* Explicit width so that the layout doesn't shift */}
              <Button
                color="danger"
                disabled={secondsLeft > 0}
                width="80px"
                onClick={() => {
                  act('remove_current_slot');
                  close();
                }}
              >
                {secondsLeft <= 0 ? '删除' : `删除 (${secondsLeft})`}
              </Button>
            </Stack.Item>

            <Stack.Item>
              <Button onClick={close}>{'不，不要删除'}</Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Modal>
  );
};
