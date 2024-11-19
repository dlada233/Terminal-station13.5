import { Fragment } from 'react';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Box, Button, Icon, Image, Section } from '../components';
import { Window } from '../layouts';

export const Safe = (properties) => {
  const { act, data } = useBackend();
  const { dial, open } = data;
  return (
    <Window width={625} height={800} theme="ntos">
      <Window.Content>
        <Box className="Safe__engraving">
          <Dialer />
          <Box>
            <Box className="Safe__engraving-hinge" top="25%" />
            <Box className="Safe__engraving-hinge" top="75%" />
          </Box>
          <Icon
            className="Safe__engraving-arrow"
            name="long-arrow-alt-down"
            size="5"
          />
          <br />
          {open ? (
            <Contents />
          ) : (
            <Image
              className="Safe__dial"
              src={resolveAsset('safe_dial.png')}
              style={{
                transform: 'rotate(-' + 3.6 * dial + 'deg)',
              }}
            />
          )}
        </Box>
        {!open && <Help />}
      </Window.Content>
    </Window>
  );
};

const Dialer = (properties) => {
  const { act, data } = useBackend();
  const { dial, open, locked, broken } = data;
  const dialButton = (amount, right) => {
    return (
      <Button
        disabled={open || (right && !locked) || broken}
        icon={'arrow-' + (right ? 'right' : 'left')}
        content={(right ? '右' : '左') + ' ' + amount}
        iconPosition={right ? 'right' : 'left'}
        onClick={() =>
          act(!right ? 'turnright' : 'turnleft', {
            num: amount,
          })
        }
      />
    );
  };
  return (
    <Box className="Safe__dialer">
      <Button
        disabled={locked && !broken}
        icon={open ? 'lock' : 'lock-open'}
        content={open ? '关闭' : '打开'}
        mb="0.5rem"
        onClick={() => act('open')}
      />
      <br />
      <Box position="absolute">
        {[dialButton(50), dialButton(10), dialButton(1)]}
      </Box>
      <Box className="Safe__dialer-right" position="absolute" right="5px">
        {[dialButton(1, true), dialButton(10, true), dialButton(50, true)]}
      </Box>
      <Box className="Safe__dialer-number">{dial}</Box>
    </Box>
  );
};

const Contents = (properties) => {
  const { act, data } = useBackend();
  const { contents } = data;
  return (
    <Box className="Safe__contents" overflow="auto">
      {contents.map((item, index) => (
        <Fragment key={item}>
          <Button
            mb="0.5rem"
            onClick={() =>
              act('retrieve', {
                index: index + 1,
              })
            }
          >
            <Image
              src={item.sprite + '.png'}
              verticalAlign="middle"
              ml="-6px"
              mr="0.5rem"
            />
            {item.name}
          </Button>
          <br />
        </Fragment>
      ))}
    </Box>
  );
};

const Help = (properties) => {
  return (
    <Section className="Safe__help" title="保险箱解锁说明(因为你们总是忘记)">
      <Box>
        1. 向左转拨到第一个数字.
        <br />
        2. 向右转拨到第二个数字.
        <br />
        3. 对剩余的每个数字重复上述过程，每次左右交替进行.
        <br />
        4. 打开保险箱.
      </Box>
      <Box bold>关闭保险箱，请将表盘向左转动来再次上锁.</Box>
    </Section>
  );
};
