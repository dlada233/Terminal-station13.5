import { useState } from 'react';

import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import {
  Box,
  Button,
  Icon,
  Input,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

type typePath = string;

type CellularEmporiumContext = {
  abilities: Ability[];
  can_readapt: BooleanLike;
  genetic_points_count: number;
  owned_abilities: typePath[];
  absorb_count: number;
  dna_count: number;
};

type Ability = {
  name: string;
  desc: string;
  helptext: string;
  path: typePath;
  genetic_point_required: number; // Checks against genetic_points_count
  absorbs_required: number; // Checks against absorb_count
  dna_required: number; // Checks against dna_count
};

export const CellularEmporium = (props) => {
  const { act, data } = useBackend<CellularEmporiumContext>();
  const [searchAbilities, setSearchAbilities] = useState('');

  const { can_readapt, genetic_points_count } = data;
  return (
    <Window width={900} height={480}>
      <Window.Content>
        <Section
          fill
          scrollable
          title={'基因点数'}
          buttons={
            <Stack>
              <Stack.Item fontSize="16px">
                {genetic_points_count} <Icon name="dna" color="#DD66DD" />
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="undo"
                  content="重启进化"
                  color="good"
                  disabled={!can_readapt}
                  tooltip={
                    can_readapt
                      ? '我们重启进化进程，退除所有已进化的能力，找回所有的基因点数.'
                      : '在我们吸收更多的DNA前，我们没法重启进化.'
                  }
                  onClick={() => act('readapt')}
                />
              </Stack.Item>
              <Stack.Item>
                <Input
                  width="200px"
                  onInput={(event, value) => setSearchAbilities(value)}
                  placeholder="搜索能力中..."
                  value={searchAbilities}
                />
              </Stack.Item>
            </Stack>
          }
        >
          <AbilityList searchAbilities={searchAbilities} />
        </Section>
      </Window.Content>
    </Window>
  );
};

const AbilityList = (props: { searchAbilities: string }) => {
  const { act, data } = useBackend<CellularEmporiumContext>();
  const { searchAbilities } = props;
  const {
    abilities,
    owned_abilities,
    genetic_points_count,
    absorb_count,
    dna_count,
  } = data;

  const filteredAbilities =
    searchAbilities.length <= 1
      ? abilities
      : abilities.filter((ability) => {
          return (
            ability.name
              .toLowerCase()
              .includes(searchAbilities.toLowerCase()) ||
            ability.desc
              .toLowerCase()
              .includes(searchAbilities.toLowerCase()) ||
            ability.helptext
              .toLowerCase()
              .includes(searchAbilities.toLowerCase())
          );
        });

  if (filteredAbilities.length === 0) {
    return (
      <NoticeBox>
        {abilities.length === 0
          ? '没有可购买的能力. \
        这是故障，现在联系你的蜂巢意志管理员.'
          : '找不到能力.'}
      </NoticeBox>
    );
  }

  return (
    <LabeledList>
      {filteredAbilities.map((ability) => (
        <LabeledList.Item
          key={ability.name}
          className="candystripe"
          label={ability.name}
          buttons={
            <Stack>
              <Stack.Item>{ability.genetic_point_required}</Stack.Item>
              <Stack.Item>
                <Icon
                  name="dna"
                  color={
                    owned_abilities.includes(ability.path) ? '#DD66DD' : 'gray'
                  }
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  content={'进化'}
                  disabled={
                    owned_abilities.includes(ability.path) ||
                    ability.genetic_point_required > genetic_points_count ||
                    ability.absorbs_required > absorb_count ||
                    ability.dna_required > dna_count
                  }
                  onClick={() =>
                    act('evolve', {
                      path: ability.path,
                    })
                  }
                />
              </Stack.Item>
            </Stack>
          }
        >
          {ability.desc}
          <Box color="good">{ability.helptext}</Box>
        </LabeledList.Item>
      ))}
    </LabeledList>
  );
};
