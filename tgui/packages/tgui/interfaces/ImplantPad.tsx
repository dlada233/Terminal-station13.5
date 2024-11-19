import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, Divider, Flex } from '../components';
import { Window } from '../layouts';
import { sanitizeText } from '../sanitize';

type Data = {
  has_case: BooleanLike;
  has_implant: BooleanLike;
  case_information: string;
};

export const ImplantPad = (props) => {
  const { act, data } = useBackend<Data>();
  const { has_case, has_implant, case_information } = data;
  const textHtml = {
    __html: sanitizeText(case_information),
  };
  return (
    <Window width={300} height={case_information ? 300 : 200}>
      <Window.Content scrollable>
        <Flex bold>
          <Flex.Item grow color="good" align="center">
            植入微型计算机
          </Flex.Item>
          <Flex.Item>
            <Button
              icon="eject"
              disabled={!has_case}
              onClick={() => act('eject_implant')}
            >
              取出容器
            </Button>
          </Flex.Item>
        </Flex>
        <Divider />
        <Flex>
          <Flex.Item>
            {!has_case && '未检测到植入物容器，请插入一个查看其内容.'}
            {!!has_case &&
              !has_implant &&
              '植入物容器没有植入，请插入一个以继续.'}
            {!!has_case && !!has_implant && (
              <Box
                style={{ whiteSpace: 'pre-line' }}
                dangerouslySetInnerHTML={textHtml}
              />
            )}
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};
