import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const LanguageMenu = (props) => {
  const { act, data } = useBackend();
  const {
    admin_mode,
    is_living,
    omnitongue,
    languages = [],
    unknown_languages = [],
  } = data;
  return (
    <Window title="语言菜单" width={700} height={600}>
      <Window.Content scrollable>
        <Section title="掌握语言">
          <LabeledList>
            {languages.map((language) => (
              <LabeledList.Item
                key={language.name}
                label={language.name}
                buttons={
                  <>
                    {!!is_living && (
                      <Button
                        content={language.is_default ? '默认语言' : '选为默认'}
                        disabled={!language.can_speak}
                        selected={language.is_default}
                        onClick={() =>
                          act('select_default', {
                            language_name: language.name,
                          })
                        }
                      />
                    )}
                    {!!admin_mode && (
                      <>
                        <Button
                          content="获得功能"
                          onClick={() =>
                            act('grant_language', {
                              language_name: language.name,
                            })
                          }
                        />
                        <Button
                          content="摒弃功能"
                          onClick={() =>
                            act('remove_language', {
                              language_name: language.name,
                            })
                          }
                        />
                      </>
                    )}
                  </>
                }
              >
                {language.desc} 键值: ,{language.key}{' '}
                {language.can_understand ? '可以理解.' : '无法理解.'}{' '}
                {language.can_speak ? '可以发言.' : '不会发言.'}
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
        {!!admin_mode && (
          <Section
            title="未掌握语言"
            buttons={
              <Button
                content={'万能舌 ' + (omnitongue ? '开启' : '关闭')}
                selected={omnitongue}
                onClick={() => act('toggle_omnitongue')}
              />
            }
          >
            <LabeledList>
              {unknown_languages.map((language) => (
                <LabeledList.Item
                  key={language.name}
                  label={language.name}
                  buttons={
                    <Button
                      content="获得"
                      onClick={() =>
                        act('grant_language', {
                          language_name: language.name,
                        })
                      }
                    />
                  }
                >
                  {language.desc} 键值: ,{language.key}{' '}
                  {!!language.shadow && '(从mob处获得)'}{' '}
                  {language.can_speak ? '可以发言.' : '无法发言.'}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
