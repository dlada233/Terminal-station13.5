import { useBackend } from '../backend';
import { Box, Section } from '../components';
import { NtosWindow } from '../layouts';
import { sanitizeText } from '../sanitize';

export const NtosPhysScanner = (props) => {
  const { act, data } = useBackend();
  const { last_record } = data;
  const textHtml = {
    __html: sanitizeText(last_record),
  };
  return (
    <NtosWindow width={600} height={350}>
      <NtosWindow.Content scrollable>
        <Section>用你的平板设备右键即可扫描.</Section>
        <Section>
          <Box bold>
            上次存储结果
            <br />
            <br />
          </Box>
          <Box
            style={{ whiteSpace: 'pre-line' }}
            dangerouslySetInnerHTML={textHtml}
          />
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
