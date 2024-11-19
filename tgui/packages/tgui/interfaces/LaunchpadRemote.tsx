import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { NoticeBox } from '../components';
import { Window } from '../layouts';
import { LaunchpadControl } from './LaunchpadConsole';

type Data = {
  has_pad: BooleanLike;
  pad_closed: BooleanLike;
};

export const LaunchpadRemote = (props) => {
  const { data } = useBackend<Data>();
  const { has_pad, pad_closed } = data;

  return (
    <Window
      title="公文包发射台遥控器"
      width={300}
      height={240}
      theme="syndicate"
    >
      <Window.Content>
        {(!has_pad && <NoticeBox>未连接到发射平台</NoticeBox>) ||
          (pad_closed && <NoticeBox>发射平台已关闭</NoticeBox>) || (
            <LaunchpadControl topLevel />
          )}
      </Window.Content>
    </Window>
  );
};
