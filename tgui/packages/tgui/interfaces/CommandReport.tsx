import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Dropdown,
  Input,
  Section,
  Stack,
  TextArea,
} from '../components';
import { Window } from '../layouts';

type Data = {
  announce_contents: string;
  announcer_sounds: string[];
  command_name: string;
  command_name_presets: string[];
  command_report_content: string;
  announcement_color: string;
  announcement_colors: string[];
  subheader: string;
  custom_name: string;
  played_sound: string;
  print_report: string;
};

export const CommandReport = () => {
  return (
    <Window title="创建命令报告" width={325} height={685} theme="admin">
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <CentComName />
            <AnnouncementColor />
            <AnnouncementSound />
          </Stack.Item>
          <Stack.Item>
            <SubHeader />
          </Stack.Item>
          <Stack.Item>
            <ReportText />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

/** Allows the user to set the "sender" of the message via dropdown */
const CentComName = (props) => {
  const { act, data } = useBackend<Data>();
  const { command_name, command_name_presets = [], custom_name } = data;

  const sendName = (value) => {
    act('update_command_name', {
      updated_name: value,
    });
  };

  return (
    <Section title="设定中央指挥名称" textAlign="center">
      <Dropdown
        width="100%"
        selected={command_name}
        options={command_name_presets}
        onSelected={(value) => sendName(value)}
      />
      {!!custom_name && (
        <Input
          width="100%"
          mt={1}
          value={command_name}
          placeholder={command_name}
          onChange={(_, value) => sendName(value)}
        />
      )}
    </Section>
  );
};

/** Allows the user to set the "sender" of the message via dropdown */
const SubHeader = (props) => {
  const { act, data } = useBackend<Data>();
  const { subheader } = data;

  return (
    <Section title="设定命令报告子标题" textAlign="center">
      <Box>Keep blank to not include a subheader</Box>
      <Input
        width="100%"
        mt={1}
        value={subheader}
        placeholder={subheader}
        onChange={(_, value) =>
          act('set_subheader', {
            new_subheader: value,
          })
        }
      />
    </Section>
  );
};

/** Features a section with dropdown for the announcement colour. */
const AnnouncementColor = (props) => {
  const { act, data } = useBackend<Data>();
  const { announcement_colors = [], announcement_color } = data;

  return (
    <Section title="设置公告颜色" textAlign="center">
      <Dropdown
        width="100%"
        selected={announcement_color}
        options={announcement_colors}
        onSelected={(value) =>
          act('update_announcement_color', {
            updated_announcement_color: value,
          })
        }
      />
    </Section>
  );
};

/** Features a section with dropdown for sounds. */
const AnnouncementSound = (props) => {
  const { act, data } = useBackend<Data>();
  const { announcer_sounds = [], played_sound } = data;

  return (
    <Section title="设定公告音效" textAlign="center">
      <Dropdown
        width="100%"
        selected={played_sound}
        options={announcer_sounds}
        onSelected={(value) =>
          act('set_report_sound', {
            picked_sound: value,
          })
        }
      />
    </Section>
  );
};

/** Creates the report textarea with a submit button. */
const ReportText = (props) => {
  const { act, data } = useBackend<Data>();
  const { announce_contents, print_report, command_report_content } = data;
  const [commandReport, setCommandReport] = useState(command_report_content);

  return (
    <Section title="设定公告文本" textAlign="center">
      <TextArea
        height="200px"
        mb={1}
        onChange={(_, value) => setCommandReport(value)}
        value={commandReport}
      />
      <Stack vertical>
        <Stack.Item>
          <Button.Checkbox
            fluid
            checked={!!announce_contents}
            onClick={() => act('toggle_announce')}
          >
            公告内容
          </Button.Checkbox>
          <Button.Checkbox
            fluid
            checked={!!print_report || !announce_contents}
            disabled={!announce_contents}
            onClick={() => act('toggle_printing')}
            tooltip={
              !announce_contents &&
              '由于我们不会公布报告内容，所以需要打印出来.'
            }
            tooltipPosition="top"
          >
            打印报告
          </Button.Checkbox>
        </Stack.Item>
        <Stack.Item>
          <Button.Confirm
            fluid
            icon="check"
            textAlign="center"
            content="提交报告"
            onClick={() => act('submit_report', { report: commandReport })}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
