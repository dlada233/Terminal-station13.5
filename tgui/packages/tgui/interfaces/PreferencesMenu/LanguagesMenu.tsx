// THIS IS A SKYRAT UI FILE
import { useBackend } from '../../backend';
import { Box, Button, Section, Stack } from '../../components';
import { PreferencesMenuData } from './data';

export const KnownLanguage = (props) => {
  const { act } = useBackend<PreferencesMenuData>();
  return (
    <Stack.Item>
      <Section title={props.language.name}>
        {props.language.description}
        <br />
        <Button
          color="bad"
          onClick={() =>
            act('remove_language', { language_name: props.language.name })
          }
        >
          Forget <Box className={'languages16x16 ' + props.language.icon} />
        </Button>
      </Section>
    </Stack.Item>
  );
};

export const UnknownLanguage = (props) => {
  const { act } = useBackend<PreferencesMenuData>();
  return (
    <Stack.Item>
      <Section title={props.language.name}>
        {props.language.description}
        <br />
        <Button
          color="good"
          onClick={() =>
            act('give_language', { language_name: props.language.name })
          }
        >
          Learn <Box className={'languages16x16 ' + props.language.icon} />
        </Button>
      </Section>
    </Stack.Item>
  );
};

export const LanguagesPage = (props) => {
  const { data } = useBackend<PreferencesMenuData>();
  return (
    <Stack>
      <Stack.Item minWidth="33%">
        <Section title="可掌握语言">
          <Stack vertical>
            {data.unselected_languages.map((val) => (
              <UnknownLanguage key={val.icon} language={val} />
            ))}
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item minWidth="33%">
        <Section
          title={
            '语言点数: ' +
            data.selected_languages.length +
            '/' +
            data.total_language_points
          }
        >
          你可以在此处通过语言点来掌握不同语言系统.
          每种语言消耗1点
        </Section>
      </Stack.Item>
      <Stack.Item minWidth="33%">
        <Section title="已掌握语言">
          <Stack vertical>
            {data.selected_languages.map((val) => (
              <KnownLanguage key={val.icon} language={val} />
            ))}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
