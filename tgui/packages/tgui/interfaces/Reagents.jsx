import { useState } from 'react';

import { useBackend, useLocalState } from '../backend';
import {
  Button,
  Icon,
  LabeledList,
  NumberInput,
  Section,
  Stack,
  Table,
} from '../components';
import { Window } from '../layouts';
import { ReagentLookup } from './common/ReagentLookup';
import { RecipeLookup } from './common/RecipeLookup';

const bookmarkedReactions = new Set();

const matchBitflag = (a, b) => a & b && (a | b) === b;

export const Reagents = (props) => {
  const { act, data } = useBackend();
  const {
    beakerSync,
    reagent_mode_recipe,
    reagent_mode_reagent,
    bitflags = {},
  } = data;

  const flagIcons = [
    { flag: bitflags.BRUTE, icon: 'gavel' },
    { flag: bitflags.BURN, icon: 'burn' },
    { flag: bitflags.TOXIN, icon: 'biohazard' },
    { flag: bitflags.OXY, icon: 'wind' },
    { flag: bitflags.HEALING, icon: 'medkit' },
    { flag: bitflags.DAMAGING, icon: 'skull-crossbones' },
    { flag: bitflags.EXPLOSIVE, icon: 'bomb' },
    { flag: bitflags.OTHER, icon: 'question' },
    { flag: bitflags.DANGEROUS, icon: 'exclamation-triangle' },
    { flag: bitflags.EASY, icon: 'chess-pawn' },
    { flag: bitflags.MODERATE, icon: 'chess-knight' },
    { flag: bitflags.HARD, icon: 'chess-queen' },
    { flag: bitflags.ORGAN, icon: 'brain' },
    { flag: bitflags.DRINK, icon: 'cocktail' },
    { flag: bitflags.FOOD, icon: 'drumstick-bite' },
    { flag: bitflags.SLIME, icon: 'microscope' },
    { flag: bitflags.DRUG, icon: 'pills' },
    { flag: bitflags.UNIQUE, icon: 'puzzle-piece' },
    { flag: bitflags.CHEMICAL, icon: 'flask' },
    { flag: bitflags.PLANT, icon: 'seedling' },
    { flag: bitflags.COMPETITIVE, icon: 'recycle' },
  ];

  const [page, setPage] = useLocalState('page', 1);

  return (
    <Window width={720} height={850}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Stack fill>
              <Stack.Item grow basis={0}>
                <Section
                  title="配方查找"
                  minWidth="353px"
                  buttons={
                    <>
                      <Button
                        content="同步烧杯"
                        icon="atom"
                        color={beakerSync ? 'green' : 'red'}
                        tooltip="当启用时，将自动显示烧杯中正在进行的反应."
                        onClick={() => act('beaker_sync')}
                      />
                      <Button
                        content="搜索"
                        icon="search"
                        color="purple"
                        tooltip="按产物名称搜索配方"
                        onClick={() => act('search_recipe')}
                      />
                      <Button
                        icon="times"
                        color="red"
                        disabled={!reagent_mode_recipe}
                        onClick={() =>
                          act('recipe_click', {
                            id: null,
                          })
                        }
                      />
                    </>
                  }
                >
                  <RecipeLookup
                    recipe={reagent_mode_recipe}
                    bookmarkedReactions={bookmarkedReactions}
                  />
                </Section>
              </Stack.Item>
              <Stack.Item grow basis={0}>
                <Section
                  title="试剂查找"
                  minWidth="300px"
                  buttons={
                    <>
                      <Button
                        content="搜索"
                        icon="search"
                        tooltip="搜索试剂名称"
                        tooltipPosition="left"
                        onClick={() => act('search_reagents')}
                      />
                      <Button
                        icon="times"
                        color="red"
                        disabled={!reagent_mode_reagent}
                        onClick={() =>
                          act('reagent_click', {
                            id: null,
                          })
                        }
                      />
                    </>
                  }
                >
                  <ReagentLookup reagent={reagent_mode_reagent} />
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Section title="标签">
              <TagBox bitflags={bitflags} />
            </Section>
          </Stack.Item>
          <Stack.Item grow={2} basis={0}>
            <RecipeLibrary flagIcons={flagIcons} />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const TagBox = (props) => {
  const { act, data } = useBackend();
  const [page, setPage] = useLocalState('page', 1);
  const { bitflags } = props;
  const { selectedBitflags } = data;
  return (
    <LabeledList>
      <LabeledList.Item label="影响">
        <Button
          color={selectedBitflags & bitflags.BRUTE ? 'green' : 'red'}
          icon="gavel"
          onClick={() => {
            act('toggle_tag_brute');
            setPage(1);
          }}
        >
          创伤
        </Button>
        <Button
          color={selectedBitflags & bitflags.BURN ? 'green' : 'red'}
          icon="burn"
          onClick={() => {
            act('toggle_tag_burn');
            setPage(1);
          }}
        >
          烧伤
        </Button>
        <Button
          color={selectedBitflags & bitflags.TOXIN ? 'green' : 'red'}
          icon="biohazard"
          onClick={() => {
            act('toggle_tag_toxin');
            setPage(1);
          }}
        >
          毒素伤
        </Button>
        <Button
          color={selectedBitflags & bitflags.OXY ? 'green' : 'red'}
          icon="wind"
          onClick={() => {
            act('toggle_tag_oxy');
            setPage(1);
          }}
        >
          窒息伤
        </Button>
        <Button
          color={selectedBitflags & bitflags.ORGAN ? 'green' : 'red'}
          icon="brain"
          onClick={() => {
            act('toggle_tag_organ');
            setPage(1);
          }}
        >
          器官
        </Button>
        <Button
          icon="flask"
          color={selectedBitflags & bitflags.CHEMICAL ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_chemical');
            setPage(1);
          }}
        >
          化学物
        </Button>
        <Button
          icon="seedling"
          color={selectedBitflags & bitflags.PLANT ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_plant');
            setPage(1);
          }}
        >
          植物
        </Button>
        <Button
          icon="question"
          color={selectedBitflags & bitflags.OTHER ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_other');
            setPage(1);
          }}
        >
          其他
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="类型">
        <Button
          color={selectedBitflags & bitflags.DRINK ? 'green' : 'red'}
          icon="cocktail"
          onClick={() => {
            act('toggle_tag_drink');
            setPage(1);
          }}
        >
          饮品
        </Button>
        <Button
          color={selectedBitflags & bitflags.FOOD ? 'green' : 'red'}
          icon="drumstick-bite"
          onClick={() => {
            act('toggle_tag_food');
            setPage(1);
          }}
        >
          食物
        </Button>
        <Button
          color={selectedBitflags & bitflags.HEALING ? 'green' : 'red'}
          icon="medkit"
          onClick={() => {
            act('toggle_tag_healing');
            setPage(1);
          }}
        >
          疗剂
        </Button>
        <Button
          icon="skull-crossbones"
          color={selectedBitflags & bitflags.DAMAGING ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_damaging');
            setPage(1);
          }}
        >
          毒剂
        </Button>
        <Button
          icon="pills"
          color={selectedBitflags & bitflags.DRUG ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_drug');
            setPage(1);
          }}
        >
          毒品
        </Button>
        <Button
          icon="microscope"
          color={selectedBitflags & bitflags.SLIME ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_slime');
            setPage(1);
          }}
        >
          史莱姆
        </Button>
        <Button
          icon="bomb"
          color={selectedBitflags & bitflags.EXPLOSIVE ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_explosive');
            setPage(1);
          }}
        >
          爆炸
        </Button>
        <Button
          icon="puzzle-piece"
          color={selectedBitflags & bitflags.UNIQUE ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_unique');
            setPage(1);
          }}
        >
          独特
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="难度">
        <Button
          icon="chess-pawn"
          color={selectedBitflags & bitflags.EASY ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_easy');
            setPage(1);
          }}
        >
          简单
        </Button>
        <Button
          icon="chess-knight"
          color={selectedBitflags & bitflags.MODERATE ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_moderate');
            setPage(1);
          }}
        >
          中等
        </Button>
        <Button
          icon="chess-queen"
          color={selectedBitflags & bitflags.HARD ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_hard');
            setPage(1);
          }}
        >
          困难
        </Button>
        <Button
          icon="exclamation-triangle"
          color={selectedBitflags & bitflags.DANGEROUS ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_dangerous');
            setPage(1);
          }}
        >
          危险
        </Button>
        <Button
          icon="recycle"
          color={selectedBitflags & bitflags.COMPETITIVE ? 'green' : 'red'}
          onClick={() => {
            act('toggle_tag_competitive');
            setPage(1);
          }}
        >
          Competitive
        </Button>
      </LabeledList.Item>
    </LabeledList>
  );
};

const RecipeLibrary = (props) => {
  const { act, data } = useBackend();
  const [page, setPage] = useLocalState('page', 1);
  const { flagIcons } = props;
  const {
    selectedBitflags,
    currentReagents = [],
    master_reaction_list = [],
    linkedBeaker,
  } = data;

  const [reagentFilter, setReagentFilter] = useState(true);
  const [bookmarkMode, setBookmarkMode] = useState(false);

  const matchReagents = (reaction) => {
    if (!reagentFilter || currentReagents === null) {
      return true;
    }
    let matches = reaction.reactants.filter((reactant) =>
      currentReagents.includes(reactant.id),
    ).length;
    return matches === currentReagents.length;
  };

  const bookmarkArray = Array.from(bookmarkedReactions);

  const startIndex = 50 * (page - 1);

  const endIndex = 50 * page;

  const visibleReactions = bookmarkMode
    ? bookmarkArray
    : master_reaction_list.filter(
        (reaction) =>
          (selectedBitflags
            ? matchBitflag(selectedBitflags, reaction.bitflags)
            : true) && matchReagents(reaction),
      );

  const pageIndexMax = Math.ceil(visibleReactions.length / 50);

  const addBookmark = (bookmark) => {
    bookmarkedReactions.add(bookmark);
  };

  const removeBookmark = (bookmark) => {
    bookmarkedReactions.delete(bookmark);
  };

  return (
    <Section
      fill
      scrollable
      title={bookmarkMode ? '收藏配方' : '可能配方'}
      buttons={
        <>
          烧杯: {linkedBeaker + '  '}
          <Button
            content="根据烧杯内容显示"
            icon="search"
            disabled={bookmarkMode}
            color={reagentFilter ? 'green' : 'red'}
            onClick={() => {
              setReagentFilter(!reagentFilter);
              setPage(1);
            }}
          />
          <Button
            content="收藏夹"
            icon="book"
            color={bookmarkMode ? 'green' : 'red'}
            onClick={() => {
              setBookmarkMode(!bookmarkMode);
              setPage(1);
            }}
          />
          <Button
            icon="minus"
            disabled={page === 1}
            onClick={() => setPage(Math.max(page - 1, 1))}
          />
          <NumberInput
            width="25px"
            step={1}
            stepPixelSize={3}
            value={page}
            minValue={1}
            maxValue={pageIndexMax}
            onDrag={(value) => setPage(value)}
          />
          <Button
            icon="plus"
            disabled={page === pageIndexMax}
            onClick={() => setPage(Math.min(page + 1, pageIndexMax))}
          />
        </>
      }
    >
      <Table>
        <Table.Row>
          <Table.Cell bold color="label">
            反应
          </Table.Cell>
          <Table.Cell bold color="label">
            需要试剂
          </Table.Cell>
          <Table.Cell bold color="label">
            标签
          </Table.Cell>
          <Table.Cell bold color="label" width="20px">
            {!bookmarkMode ? '收藏' : '删除'}
          </Table.Cell>
        </Table.Row>
        {visibleReactions.slice(startIndex, endIndex).map((reaction) => (
          <Table.Row key={reaction.id} className="candystripe">
            <Table.Cell bold color="label">
              <Button
                mt={0.5}
                icon="flask"
                color="purple"
                content={reaction.name}
                onClick={() =>
                  act('recipe_click', {
                    id: reaction.id,
                  })
                }
              />
            </Table.Cell>
            <Table.Cell>
              {reaction.reactants.map((reactant) => (
                <Button
                  key={reactant.id}
                  mt={0.1}
                  icon="vial"
                  textColor="white"
                  color={currentReagents?.includes(reactant.id) && 'green'} // check here
                  content={reactant.name}
                  onClick={() =>
                    act('reagent_click', {
                      id: reactant.id,
                    })
                  }
                />
              ))}
            </Table.Cell>
            <Table.Cell width="60px">
              {flagIcons
                .filter((meta) => reaction.bitflags & meta.flag)
                .map((meta) => (
                  <Icon key={meta.flag} name={meta.icon} mr={1} />
                ))}
            </Table.Cell>
            <Table.Cell width="20px">
              {(!bookmarkMode && (
                <Button
                  icon="book"
                  color="green"
                  disabled={bookmarkedReactions.has(reaction)}
                  onClick={() => {
                    addBookmark(reaction);
                    act('update_ui');
                  }}
                />
              )) || (
                <Button
                  icon="trash"
                  color="red"
                  onClick={() => removeBookmark(reaction)}
                />
              )}
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
