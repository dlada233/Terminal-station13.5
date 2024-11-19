import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Box, Flex } from '../components';
import { Window } from '../layouts';
import { NukeKeypad } from './NuclearBomb';

type Data = {
  input_code: string;
  locked: BooleanLike;
  lock_set: BooleanLike;
  lock_code: BooleanLike;
};

export const LockedSafe = (props) => {
  const { act, data } = useBackend<Data>();
  const { input_code, locked, lock_code } = data;
  return (
    <Window width={300} height={400} theme="ntos">
      <Window.Content>
        <Box m="6px">
          <Box mb="6px" className="NuclearBomb__displayBox">
            {input_code}
          </Box>
          <Box className="NuclearBomb__displayBox">
            {!lock_code && '未设置密码.'}
            {!!lock_code && (!locked ? '已解锁' : '已上锁')}
          </Box>
          <Flex ml="3px">
            <Flex.Item>
              <NukeKeypad />
            </Flex.Item>
          </Flex>
        </Box>
      </Window.Content>
    </Window>
  );
};
