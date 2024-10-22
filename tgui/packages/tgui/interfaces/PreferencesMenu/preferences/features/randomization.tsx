import { useBackend } from '../../../../backend';
import { Button, Stack } from '../../../../components';
import { PreferencesMenuData, RandomSetting } from '../../data';
import { RandomizationButton } from '../../RandomizationButton';
import { useRandomToggleState } from '../../useRandomToggleState';
import { CheckboxInput, Feature, FeatureToggle } from './base';

export const random_body: Feature<RandomSetting> = {
  name: '随机身体',
  component: (props) => {
    const [randomToggle, setRandomToggle] = useRandomToggleState();

    return (
      <Stack>
        <Stack.Item>
          <RandomizationButton
            setValue={(newValue) => props.handleSetValue(newValue)}
            value={props.value}
          />
        </Stack.Item>

        {randomToggle ? (
          <>
            <Stack.Item>
              <Button
                color="green"
                onClick={() => {
                  props.act('randomize_character');
                  setRandomToggle(false);
                }}
              >
                随机化
              </Button>
            </Stack.Item>

            <Stack.Item>
              <Button color="red" onClick={() => setRandomToggle(false)}>
                取消
              </Button>
            </Stack.Item>
          </>
        ) : (
          <Stack.Item>
            <Button onClick={() => setRandomToggle(true)}>随机化</Button>
          </Stack.Item>
        )}
      </Stack>
    );
  },
};

export const random_hardcore: FeatureToggle = {
  name: '完全随机',
  component: CheckboxInput,
};

export const random_name: Feature<RandomSetting> = {
  name: '随机名字',
  component: (props) => {
    return (
      <RandomizationButton
        setValue={(value) => props.handleSetValue(value)}
        value={props.value}
      />
    );
  },
};

export const random_species: Feature<RandomSetting> = {
  name: '随机物种',
  component: (props) => {
    const { act, data } = useBackend<PreferencesMenuData>();

    const species = data.character_preferences.randomization['species'];

    return (
      <RandomizationButton
        setValue={(newValue) =>
          act('set_random_preference', {
            preference: 'species',
            value: newValue,
          })
        }
        value={species || RandomSetting.Disabled}
      />
    );
  },
};
