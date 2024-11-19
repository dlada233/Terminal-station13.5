import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Box, Button, Image, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  server_connected: BooleanLike;
  loaded_item: string;
  item_icon: string;
  indestructible: BooleanLike;
  already_deconstructed: BooleanLike;
  recoverable_points: string;
  node_data: NodeData[];
  research_point_id: string;
};

type NodeData = {
  node_name: string;
  node_id: string;
  node_hidden: BooleanLike;
};

export const DestructiveAnalyzer = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    server_connected,
    indestructible,
    loaded_item,
    item_icon,
    already_deconstructed,
    recoverable_points,
    research_point_id,
    node_data = [],
  } = data;
  if (!server_connected) {
    return (
      <Window width={400} height={260} title="解构分析仪">
        <Window.Content>
          <NoticeBox textAlign="center" danger>
            未连接到服务器，请使用多功能工具同步.
          </NoticeBox>
        </Window.Content>
      </Window>
    );
  }
  if (!loaded_item) {
    return (
      <Window width={400} height={260} title="解构分析仪">
        <Window.Content>
          <NoticeBox textAlign="center" danger>
            未装载物品! <br />
            放置任何物品进去，看看有什么发现!
          </NoticeBox>
        </Window.Content>
      </Window>
    );
  }
  return (
    <Window width={400} height={260} title="解构分析仪">
      <Window.Content scrollable>
        <Section
          title={loaded_item}
          buttons={
            <Button
              icon="eject"
              tooltip="取出当前装载的物品."
              onClick={() => act('eject_item')}
            />
          }
        >
          <Image
            src={`data:image/jpeg;base64,${item_icon}`}
            height="64px"
            width="64px"
            verticalAlign="middle"
          />
        </Section>
        <Section title="解构措施">
          {!indestructible && (
            <NoticeBox textAlign="center" danger>
              该物品无法被解构!
            </NoticeBox>
          )}
          {!!indestructible && (
            <>
              {!!recoverable_points && (
                <>
                  <Box fontSize="14px">从解构中获取研究点数</Box>
                  <Box>{recoverable_points}</Box>
                </>
              )}
              <Button.Confirm
                content="解构"
                icon="hammer"
                tooltip={
                  already_deconstructed
                    ? '这件物品已经被解构过了，不会提供任何额外的信息.'
                    : '销毁当前装载在机器中的物品.'
                }
                onClick={() =>
                  act('deconstruct', { deconstruct_id: research_point_id })
                }
              />
            </>
          )}
          {node_data.map((node) => (
            <Button.Confirm
              icon="cash-register"
              mt={1}
              disabled={!node.node_hidden}
              key={node.node_id}
              tooltip={
                node.node_hidden
                  ? '将其解构以推进当前研究节点.'
                  : '该研究节点已经被研究过了.'
              }
              onClick={() =>
                act('deconstruct', { deconstruct_id: node.node_id })
              }
            >
              {node.node_name}
            </Button.Confirm>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
