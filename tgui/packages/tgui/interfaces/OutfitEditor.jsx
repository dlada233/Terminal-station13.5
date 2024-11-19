import { useBackend } from '../backend';
import { Box, Button, Icon, Image, Section, Stack } from '../components';
import { Window } from '../layouts';

export const OutfitEditor = (props) => {
  const { act, data } = useBackend();
  const { outfit, saveable, dummy64 } = data;
  return (
    <Window width={380} height={600} theme="admin">
      <Window.Content>
        <Image
          fillPositionedParent
          width="100%"
          height="100%"
          opacity={0.5}
          py={3}
          src={`data:image/jpeg;base64,${dummy64}`}
        />
        <Section
          fill
          title={
            <Stack>
              <Stack.Item
                grow={1}
                style={{
                  overflow: 'hidden',
                  whiteSpace: 'nowrap',
                  textOverflow: 'ellipsis',
                }}
              >
                <Button
                  ml={0.5}
                  color="transparent"
                  icon="pencil-alt"
                  title="重名套装"
                  onClick={() => act('rename', {})}
                />
                {outfit.name}
              </Stack.Item>
              <Stack.Item align="end" shrink={0}>
                <Button
                  color="transparent"
                  icon="info"
                  tooltip="按住Ctrl键并单击按钮，可以选择任意物品，而不是只能选择可能适合该槽位的物品."
                  tooltipPosition="bottom-start"
                />
                <Button
                  icon="code"
                  tooltip="在VV窗口中编辑这套服装"
                  tooltipPosition="bottom-start"
                  onClick={() => act('vv')}
                />
                <Button
                  color={!saveable && 'bad'}
                  icon={saveable ? 'save' : 'trash-alt'}
                  tooltip={
                    saveable
                      ? '将这套装备保存到自定义装备列表中'
                      : '将这套装备从自定义装备列表中移除'
                  }
                  tooltipPosition="bottom-start"
                  onClick={() => act(saveable ? 'save' : 'delete')}
                />
              </Stack.Item>
            </Stack>
          }
        >
          <Box textAlign="center">
            <Stack mb={2}>
              <OutfitSlot name="头部" icon="hard-hat" slot="head" />
              <OutfitSlot name="眼镜" icon="glasses" slot="glasses" />
              <OutfitSlot name="耳部" icon="headphones-alt" slot="ears" />
            </Stack>
            <Stack mb={2}>
              <OutfitSlot name="脖颈" icon="stethoscope" slot="neck" />
              <OutfitSlot name="面部" icon="theater-masks" slot="mask" />
            </Stack>
            <Stack mb={2}>
              <OutfitSlot name="内服" icon="tshirt" slot="uniform" />
              <OutfitSlot name="外装" icon="user-tie" slot="suit" />
              <OutfitSlot name="手部" icon="mitten" slot="gloves" />
            </Stack>
            <Stack mb={2}>
              <OutfitSlot
                name="外装存储"
                icon="briefcase-medical"
                slot="suit_store"
              />
              <OutfitSlot name="背部" icon="shopping-bag" slot="back" />
              <OutfitSlot name="ID" icon="id-card-o" slot="id" />
            </Stack>
            <Stack mb={2}>
              <OutfitSlot name="腰部" icon="band-aid" slot="belt" />
              <OutfitSlot name="左手" icon="hand-paper" slot="l_hand" />
              <OutfitSlot name="右手" icon="hand-paper" slot="r_hand" />
            </Stack>
            <Stack mb={2}>
              <OutfitSlot name="脚部" icon="socks" slot="shoes" />
              <OutfitSlot
                name="左侧口袋"
                icon="envelope-open-o"
                iconRot={180}
                slot="l_pocket"
              />
              <OutfitSlot
                name="右侧口袋"
                icon="envelope-open-o"
                iconRot={180}
                slot="r_pocket"
              />
            </Stack>
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};

const OutfitSlot = (props) => {
  const { act, data } = useBackend();
  const { name, icon, iconRot, slot } = props;
  const { outfit } = data;
  const currItem = outfit[slot];
  return (
    <Stack.Item grow={1} basis={0}>
      <Button
        fluid
        height={2}
        bold
        // todo: intuitive way to clear items
        onClick={(e) => act(e.ctrlKey ? 'ctrlClick' : 'click', { slot })}
      >
        <Icon name={icon} rotation={iconRot} />
        {name}
      </Button>
      <Box height="32px">
        {currItem?.sprite && (
          <>
            <Image
              src={`data:image/jpeg;base64,${currItem?.sprite}`}
              title={currItem?.desc}
            />
            <Icon
              position="absolute"
              name="times"
              color="label"
              style={{ cursor: 'pointer' }}
              onClick={() => act('clear', { slot })}
            />
          </>
        )}
      </Box>
      <Box
        color="label"
        style={{
          overflow: 'hidden',
          whiteSpace: 'nowrap',
          textOverflow: 'ellipsis',
        }}
        title={currItem?.path}
      >
        {currItem?.name || '空'}
      </Box>
    </Stack.Item>
  );
};
