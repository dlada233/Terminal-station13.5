import { decodeHtmlEntities } from 'common/string';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Dimmer,
  Icon,
  Image,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

export const Trophycase = (props) => {
  const { act, data } = useBackend();
  return (
    <Window width={300} height={380}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <ShowpieceName />
          </Stack.Item>
          <Stack.Item>
            <ShowpieceImage />
          </Stack.Item>
          <Stack.Item grow>
            <ShowpieceDescription />
          </Stack.Item>
          <Stack.Divider />
          <Stack.Item>
            <HistorianPanel />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const HistorianPanel = (props) => {
  const { act, data } = useBackend();
  const {
    has_showpiece,
    historian_mode,
    holographic_showpiece,
    showpiece_description,
  } = data;

  return (
    <Section align="left">
      {!historian_mode && (
        <Button
          icon="key"
          content="为历史记录模式插入key"
          onClick={() => act('insert_key')}
        />
      )}
      {!!historian_mode && (
        <div>
          <Button
            icon="times"
            content="锁定历史记录模式"
            onClick={() => act('lock')}
          />
          <Button
            icon="pencil"
            content="编辑描述"
            disabled={!has_showpiece || holographic_showpiece}
            onClick={() => act('change_message')}
          />
        </div>
      )}
      {!!historian_mode && !!holographic_showpiece && (
        <Box>
          已经有了一个全息奖杯，用一个新的奖杯替换它，以创建一个新的记录.
        </Box>
      )}
      {!!historian_mode && !has_showpiece && <Box>未找到奖杯.</Box>}
      {!!historian_mode &&
        !!has_showpiece &&
        !holographic_showpiece &&
        !!showpiece_description && (
          <Box>
            记录已经开始，只要奖杯处于完好的盒子内，奖杯数据将在夜间保存.
          </Box>
        )}
      {!!historian_mode &&
        !!has_showpiece &&
        !holographic_showpiece &&
        !showpiece_description && (
          <Box>检测到新的奖杯，请记录描述开始存档.</Box>
        )}
    </Section>
  );
};

const ShowpieceDescription = (props) => {
  const { act, data } = useBackend();
  const {
    has_showpiece,
    holographic_showpiece,
    historian_mode,
    max_length,
    showpiece_description,
  } = data;
  return (
    <Section fill align="center">
      {!has_showpiece && (
        <Box fill className="Trophycase-description">
          <b>展览栏是空的. 历史记录等着你的贡献!</b>
        </Box>
      )}
      {!!holographic_showpiece && <b>{showpiece_description}</b>}
      {!holographic_showpiece && !!has_showpiece && (
        <Box fill className="Trophycase-description">
          {showpiece_description
            ? decodeHtmlEntities(showpiece_description)
            : '展览栏正在建设中，拿到图书馆长的钥匙来完成你的贡献!'}
        </Box>
      )}
    </Section>
  );
};

const ShowpieceImage = (props) => {
  const { data } = useBackend();
  const { showpiece_icon } = data;
  return showpiece_icon ? (
    <Section align="center">
      <Image
        m={1}
        src={`data:image/jpeg;base64,${showpiece_icon}`}
        height="96px"
        width="96px"
      />
    </Section>
  ) : (
    <Section align="center">
      <Box height="96px" width="96px">
        <Dimmer fontSize="32px">
          <Icon name="landmark" />
        </Dimmer>
      </Box>
    </Section>
  );
};

const ShowpieceName = (props) => {
  const { data } = useBackend();
  const { showpiece_name } = data;
  return (
    <Section align="center">
      <b>{showpiece_name ? decodeHtmlEntities(showpiece_name) : '建设中.'}</b>
    </Section>
  );
};
