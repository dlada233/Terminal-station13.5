import { classes } from 'common/react';

import { useBackend } from '../../backend';
import {
  BlockQuote,
  Box,
  Button,
  Divider,
  Icon,
  Section,
  Stack,
  Tooltip,
} from '../../components';
import { CharacterPreview } from '../common/CharacterPreview';
import {
  createSetPreference,
  Food,
  Perk,
  PreferencesMenuData,
  ServerData,
  Species,
} from './data';
import { ServerPreferencesFetcher } from './ServerPreferencesFetcher';

const FOOD_ICONS = {
  [Food.Bugs]: 'bug',
  [Food.Cloth]: 'tshirt',
  [Food.Dairy]: 'cheese',
  [Food.Fried]: 'bacon',
  [Food.Fruit]: 'apple-alt',
  [Food.Gore]: 'skull',
  [Food.Grain]: 'bread-slice',
  [Food.Gross]: 'trash',
  [Food.Junkfood]: 'pizza-slice',
  [Food.Meat]: 'hamburger',
  [Food.Nuts]: 'seedling',
  [Food.Raw]: 'drumstick-bite',
  [Food.Seafood]: 'fish',
  [Food.Stone]: 'gem',
  [Food.Sugar]: 'candy-cane',
  [Food.Toxic]: 'biohazard',
  [Food.Vegetables]: 'carrot',
};

const FOOD_NAMES: Record<keyof typeof FOOD_ICONS, string> = {
  [Food.Bugs]: '虫子',
  [Food.Cloth]: '衣物',
  [Food.Dairy]: '乳制品',
  [Food.Fried]: '油炸食品',
  [Food.Fruit]: '水果',
  [Food.Gore]: '血制品',
  [Food.Grain]: '谷物',
  [Food.Gross]: '恶心食品',
  [Food.Junkfood]: '垃圾食品',
  [Food.Meat]: '肉类',
  [Food.Nuts]: '坚果类',
  [Food.Raw]: '生食',
  [Food.Seafood]: '海鲜',
  [Food.Stone]: '岩石',
  [Food.Sugar]: '糖类',
  [Food.Toxic]: '有毒食品',
  [Food.Vegetables]: '蔬菜',
};

const IGNORE_UNLESS_LIKED: Set<Food> = new Set([
  Food.Bugs,
  Food.Cloth,
  Food.Gross,
  Food.Toxic,
]);

const notIn = function <T>(set: Set<T>) {
  return (value: T) => {
    return !set.has(value);
  };
};

const FoodList = (props: {
  food: Food[];
  icon: string;
  name: string;
  className: string;
}) => {
  if (props.food.length === 0) {
    return null;
  }

  return (
    <Tooltip
      position="bottom-end"
      content={
        <Box>
          <Icon name={props.icon} /> <b>{props.name}</b>
          <Divider />
          <Box>
            {props.food
              .reduce((names, food) => {
                const foodName = FOOD_NAMES[food];
                return foodName ? names.concat(foodName) : names;
              }, [])
              .join(', ')}
          </Box>
        </Box>
      }
    >
      <Stack ml={2}>
        {props.food.map((food) => {
          return (
            FOOD_ICONS[food] && (
              <Stack.Item>
                <Icon
                  className={props.className}
                  size={1.4}
                  key={food}
                  name={FOOD_ICONS[food]}
                />
              </Stack.Item>
            )
          );
        })}
      </Stack>
    </Tooltip>
  );
};

const Diet = (props: { diet: Species['diet'] }) => {
  if (!props.diet) {
    return null;
  }

  const { liked_food, disliked_food, toxic_food } = props.diet;

  return (
    <Stack>
      <Stack.Item>
        <FoodList
          food={liked_food}
          icon="heart"
          name="喜好食物"
          className="color-pink"
        />
      </Stack.Item>

      <Stack.Item>
        <FoodList
          food={disliked_food.filter(notIn(IGNORE_UNLESS_LIKED))}
          icon="thumbs-down"
          name="厌恶食物"
          className="color-red"
        />
      </Stack.Item>

      <Stack.Item>
        <FoodList
          food={toxic_food.filter(notIn(IGNORE_UNLESS_LIKED))}
          icon="biohazard"
          name="有毒食物"
          className="color-olive"
        />
      </Stack.Item>
    </Stack>
  );
};

const SpeciesPerk = (props: { className: string; perk: Perk }) => {
  const { className, perk } = props;

  return (
    <Tooltip
      position="bottom-end"
      content={
        <Box>
          <Box as="b">{perk.name}</Box>
          <Divider />
          <Box>{perk.description}</Box>
        </Box>
      }
    >
      <Box className={className} width="32px" height="32px">
        <Icon
          name={perk.ui_icon}
          size={1.5}
          ml={0}
          mt={1}
          style={{
            textAlign: 'center',
            height: '100%',
            width: '100%',
          }}
        />
      </Box>
    </Tooltip>
  );
};

const SpeciesPerks = (props: { perks: Species['perks'] }) => {
  const { positive, negative, neutral } = props.perks;

  return (
    <Stack fill justify="space-between">
      <Stack.Item>
        <Stack>
          {positive.map((perk) => {
            return (
              <Stack.Item key={perk.name}>
                <SpeciesPerk className="color-bg-green" perk={perk} />
              </Stack.Item>
            );
          })}
        </Stack>
      </Stack.Item>

      <Stack>
        {neutral.map((perk) => {
          return (
            <Stack.Item key={perk.name}>
              <SpeciesPerk className="color-bg-grey" perk={perk} />
            </Stack.Item>
          );
        })}
      </Stack>

      <Stack>
        {negative.map((perk) => {
          return (
            <Stack.Item key={perk.name}>
              <SpeciesPerk className="color-bg-red" perk={perk} />
            </Stack.Item>
          );
        })}
      </Stack>
    </Stack>
  );
};

const SpeciesPageInner = (props: {
  handleClose: () => void;
  species: ServerData['species'];
}) => {
  const { act, data } = useBackend<PreferencesMenuData>();
  const setSpecies = createSetPreference(act, 'species');

  let species: [string, Species][] = Object.entries(props.species).map(
    ([species, data]) => {
      return [species, data];
    },
  );

  // Humans are always the top of the list
  const humanIndex = species.findIndex(([species]) => species === 'human');
  const swapWith = species[0];
  species[0] = species[humanIndex];
  species[humanIndex] = swapWith;

  const currentSpecies = species.filter(([speciesKey]) => {
    return speciesKey === data.character_preferences.misc.species;
  })[0][1];

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Button icon="arrow-left" onClick={props.handleClose} content="返回" />
      </Stack.Item>

      <Stack.Item grow>
        <Stack fill>
          <Stack.Item>
            <Box height="calc(100vh - 170px)" overflowY="auto" pr={3}>
              {species.map(([speciesKey, species]) => {
                // SKYRAT EDIT START - Veteran-only species
                let speciesPage = (
                  <Button
                    key={speciesKey}
                    onClick={() => {
                      if (species.veteran_only && !data.is_veteran) {
                        return;
                      }
                      setSpecies(speciesKey);
                    }}
                    selected={
                      data.character_preferences.misc.species === speciesKey
                    }
                    tooltip={species.name}
                    style={{
                      display: 'block',
                      height: '64px',
                      width: '64px',
                    }}
                  >
                    <Box
                      className={classes(['species64x64', species.icon])}
                      ml={-1}
                    />
                  </Button>
                );
                if (species.veteran_only && !data.is_veteran) {
                  let tooltipContent =
                    species.name + ' - 这是有经验的老手限定种族，欢迎申请成为!';
                  speciesPage = (
                    <Tooltip content={tooltipContent}>{speciesPage}</Tooltip>
                  );
                }
                return speciesPage;
                // SKYRAT EDIT END
              })}
            </Box>
          </Stack.Item>

          <Stack.Item grow>
            <Box>
              <Box>
                <Stack fill>
                  <Stack.Item width="70%">
                    <Section
                      title={currentSpecies.name}
                      buttons={
                        // NOHUNGER species have no diet (diet = null),
                        // so we have nothing to show
                        currentSpecies.diet && (
                          <Diet diet={currentSpecies.diet} />
                        )
                      }
                    >
                      {/* SKYRAT EDIT CHANGE START - Adds maxHeight, scrollable*/}
                      <Section title="Description" maxHeight="14vh" scrollable>
                        {/* SKYRAT EDIT CHANGE END */}
                        {currentSpecies.desc}
                      </Section>

                      <Section title="Features">
                        <SpeciesPerks perks={currentSpecies.perks} />
                      </Section>
                    </Section>
                  </Stack.Item>

                  <Stack.Item width="30%">
                    <CharacterPreview
                      id={data.character_preview_view}
                      height="100%"
                    />
                  </Stack.Item>
                </Stack>
              </Box>

              <Box mt={1}>
                <Section title="Lore">
                  <BlockQuote /* SKYRAT EDIT START - scrollable lore */
                    overflowY="auto"
                    maxHeight="45vh"
                    mr={-1} /* SKYRAT EDIT END */
                  >
                    {currentSpecies.lore.map((text, index) => (
                      <Box key={index} maxWidth="100%">
                        {text}
                        {index !== currentSpecies.lore.length - 1 && (
                          <>
                            <br />
                            <br />
                          </>
                        )}
                      </Box>
                    ))}
                  </BlockQuote>
                </Section>
              </Box>
            </Box>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

export const SpeciesPage = (props: { closeSpecies: () => void }) => {
  return (
    <ServerPreferencesFetcher
      render={(serverData) => {
        if (serverData) {
          return (
            <SpeciesPageInner
              handleClose={props.closeSpecies}
              species={serverData.species}
            />
          );
        } else {
          return <Box>加载种族...</Box>;
        }
      }}
    />
  );
};
