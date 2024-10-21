import { useBackend, useSharedState } from '../../backend';
import { Button, Flex, Input, Section } from '../../components';

type Data = {
  upperText: string;
  lowerText: string;
  maxStatusLineLength: number;
};

export const StatusDisplayControls = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    upperText: initialUpper,
    lowerText: initialLower,
    maxStatusLineLength,
  } = data;

  const [upperText, setUpperText] = useSharedState(
    'statusUpperText',
    initialUpper,
  );
  const [lowerText, setLowerText] = useSharedState(
    'statusLowerText',
    initialLower,
  );

  return (
    <>
      <Section>
        <Button
          icon="toggle-off"
          content="关闭"
          color="bad"
          onClick={() => act('setStatusPicture', { picture: 'blank' })}
        />
        <Button
          icon="space-shuttle"
          content="撤离飞船 ETA / Off"
          color=""
          onClick={() => act('setStatusPicture', { picture: 'shuttle' })}
        />
      </Section>

      <Section title="图像">
        <Button
          icon="flag"
          content="Logo"
          onClick={() => act('setStatusPicture', { picture: 'default' })}
        />

        <Button
          icon="exclamation"
          content="安全警报等级"
          onClick={() => act('setStatusPicture', { picture: 'currentalert' })}
        />

        <Button
          icon="exclamation-triangle"
          content="封锁"
          onClick={() => act('setStatusPicture', { picture: 'lockdown' })}
        />

        <Button
          icon="biohazard"
          content="生物危害"
          onClick={() => act('setStatusPicture', { picture: 'biohazard' })}
        />

        <Button
          icon="radiation"
          content="辐射"
          onClick={() => act('setStatusPicture', { picture: 'radiation' })}
        />
      </Section>

      <Section title="信息">
        <Flex direction="column" align="stretch">
          <Flex.Item mb={1}>
            <Input
              fluid
              maxLength={maxStatusLineLength}
              value={upperText}
              onChange={(_, value) => setUpperText(value)}
            />
          </Flex.Item>

          <Flex.Item mb={1}>
            <Input
              fluid
              maxLength={maxStatusLineLength}
              value={lowerText}
              onChange={(_, value) => setLowerText(value)}
            />
          </Flex.Item>

          <Flex.Item>
            <Button
              icon="comment-o"
              onClick={() => act('setStatusMessage', { upperText, lowerText })}
              content="Send"
            />
          </Flex.Item>
        </Flex>
      </Section>
    </>
  );
};
