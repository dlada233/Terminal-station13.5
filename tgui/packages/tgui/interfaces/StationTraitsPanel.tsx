import { filter, map } from 'common/collections';
import { exhaustiveCheck } from 'common/exhaustive';
import { BooleanLike } from 'common/react';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Divider, Dropdown, Stack, Tabs } from '../components';
import { Window } from '../layouts';

type CurrentStationTrait = {
  can_revert: BooleanLike;
  name: string;
  ref: string;
};

type ValidStationTrait = {
  name: string;
  path: string;
};

type StationTraitsData = {
  current_traits: CurrentStationTrait[];
  future_station_traits?: ValidStationTrait[];
  too_late_to_revert: BooleanLike;
  valid_station_traits: ValidStationTrait[];
};

enum Tab {
  SetupFutureStationTraits,
  ViewStationTraits,
}

const FutureStationTraitsPage = (props) => {
  const { act, data } = useBackend<StationTraitsData>();
  const { future_station_traits } = data;

  const [selectedTrait, setSelectedTrait] = useState<string>('');

  const traitsByName = Object.fromEntries(
    data.valid_station_traits.map((trait) => {
      return [trait.name, trait.path];
    }),
  );

  const traitNames = Object.keys(traitsByName);
  traitNames.sort();

  return (
    <Box>
      <Stack fill>
        <Stack.Item grow>
          <Dropdown
            onSelected={setSelectedTrait}
            options={traitNames}
            placeholder="选择要添加的特点..."
            selected={selectedTrait}
            width="100%"
          />
        </Stack.Item>

        <Stack.Item>
          <Button
            color="green"
            icon="plus"
            onClick={() => {
              if (!selectedTrait) {
                return;
              }

              const selectedPath = traitsByName[selectedTrait];

              let newStationTraits = [selectedPath];
              if (future_station_traits) {
                const selectedTraitPaths = future_station_traits.map(
                  (trait) => trait.path,
                );

                if (selectedTraitPaths.indexOf(selectedPath) !== -1) {
                  return;
                }

                newStationTraits = newStationTraits.concat(
                  ...selectedTraitPaths,
                );
              }

              act('setup_future_traits', {
                station_traits: newStationTraits,
              });
            }}
          >
            添加
          </Button>
        </Stack.Item>
      </Stack>

      <Divider />

      {Array.isArray(future_station_traits) ? (
        future_station_traits.length > 0 ? (
          <Stack vertical fill>
            {future_station_traits.map((trait) => (
              <Stack.Item key={trait.path}>
                <Stack fill>
                  <Stack.Item grow>{trait.name}</Stack.Item>

                  <Stack.Item>
                    <Button
                      color="red"
                      icon="times"
                      onClick={() => {
                        act('setup_future_traits', {
                          station_traits: filter(
                            map(future_station_traits, (t) => t.path),
                            (p) => p !== trait.path,
                          ),
                        });
                      }}
                    >
                      删除
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            ))}
          </Stack>
        ) : (
          <>
            <Box>下回合空间站将没有任何特点.</Box>

            <Box>
              <Button
                color="red"
                icon="times"
                tooltip="下回合空间中将随机运行特点，这是默认设置."
                onClick={() => act('clear_future_traits')}
              >
                默认随机站点特点
              </Button>
            </Box>
          </>
        )
      ) : (
        <>
          <Box>无已计划的未来站点特点.</Box>

          <Box>
            <Button
              color="red"
              icon="times"
              onClick={() =>
                act('setup_future_traits', {
                  station_traits: [],
                })
              }
            >
              阻止空间站特点在下一回合运行
            </Button>
          </Box>
        </>
      )}
    </Box>
  );
};

const ViewStationTraitsPage = (props) => {
  const { act, data } = useBackend<StationTraitsData>();

  return data.current_traits.length > 0 ? (
    <Stack vertical fill>
      {data.current_traits.map((stationTrait) => (
        <Stack.Item key={stationTrait.ref}>
          <Stack fill>
            <Stack.Item grow>{stationTrait.name}</Stack.Item>

            <Stack.Item>
              <Button.Confirm
                content="消除"
                color="red"
                disabled={data.too_late_to_revert || !stationTrait.can_revert}
                tooltip={
                  (!stationTrait.can_revert && '这个特点是无法消除的.') ||
                  (data.too_late_to_revert &&
                    '现在消除特点已经太晚了，回合已经开始.')
                }
                icon="times"
                onClick={() =>
                  act('revert', {
                    ref: stationTrait.ref,
                  })
                }
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
      ))}
    </Stack>
  ) : (
    <Box>没有已激活的空间站特点.</Box>
  );
};

export const StationTraitsPanel = (props) => {
  const [currentTab, setCurrentTab] = useState(Tab.ViewStationTraits);

  let currentPage;

  switch (currentTab) {
    case Tab.SetupFutureStationTraits:
      currentPage = <FutureStationTraitsPage />;
      break;
    case Tab.ViewStationTraits:
      currentPage = <ViewStationTraitsPage />;
      break;
    default:
      exhaustiveCheck(currentTab);
  }

  return (
    <Window title="修改空间站特点" height={500} width={500}>
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab
            icon="eye"
            selected={currentTab === Tab.ViewStationTraits}
            onClick={() => setCurrentTab(Tab.ViewStationTraits)}
          >
            浏览
          </Tabs.Tab>

          <Tabs.Tab
            icon="edit"
            selected={currentTab === Tab.SetupFutureStationTraits}
            onClick={() => setCurrentTab(Tab.SetupFutureStationTraits)}
          >
            编辑
          </Tabs.Tab>
        </Tabs>

        <Divider />

        {currentPage}
      </Window.Content>
    </Window>
  );
};
