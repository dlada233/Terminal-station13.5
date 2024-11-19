import { sortBy } from 'common/collections';
import { classes } from 'common/react';
import { createSearch } from 'common/string';
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Icon,
  Input,
  NoticeBox,
  ProgressBar,
  Section,
  Table,
  Tooltip,
} from '../components';
import { Window } from '../layouts';

type TraitData = {
  path: string;
  name: string;
  icon: string;
  description: string;
};

type ReagentData = {
  name: string;
  rate: string;
};

type SeedData = {
  key: string;
  amount: number;
  name: string;
  lifespan: number;
  endurance: number;
  maturation: number;
  production: number;
  yield: number;
  potency: number;
  instability: number;
  icon: string;
  volume_mod: number;
  traits: string[];
  reagents: ReagentData[];
  mutatelist: string[];
  grind_results: string[];
  distill_reagent: string;
  juice_name: string;
};

type SeedExtractorData = {
  // Dynamic
  seeds: SeedData[];
  // Static
  trait_db: TraitData[];
  cycle_seconds: number;
};

export const SeedExtractor = (props) => {
  const { act, data } = useBackend<SeedExtractorData>();
  const [searchText, setSearchText] = useState('');
  const [sortField, setSortField] = useState('name');
  const [action, toggleAction] = useState(true);
  const search = createSearch(searchText, (item: SeedData) => item.name);
  const seeds_filtered =
    searchText.length > 0 ? data.seeds.filter(search) : data.seeds;
  const seeds = sortBy(
    seeds_filtered || [],
    (item: SeedData) => item[sortField as keyof SeedData],
  );
  sortField !== 'name' && seeds.reverse();

  return (
    <Window width={800} height={500}>
      <Window.Content scrollable>
        <Section>
          <Table>
            <Table.Row header>
              <Table.Cell colSpan={3} px={1} py={2}>
                <Input
                  autoFocus
                  placeholder={'搜索...'}
                  value={searchText}
                  onInput={(e, value) => setSearchText(value)}
                  fluid
                />
              </Table.Cell>
              <Table.Cell collapsing p={1}>
                <Tooltip content={'品质: 决定成品质量，试剂体积和效果强度.'}>
                  <Box
                    style={{ cursor: 'pointer' }}
                    onClick={(e) => setSortField('potency')}
                  >
                    品质
                  </Box>
                </Tooltip>
              </Table.Cell>
              <Table.Cell collapsing p={1}>
                <Tooltip content={'产量: 单次收获的成品数量.'}>
                  <Box
                    style={{ cursor: 'pointer' }}
                    onClick={(e) => setSortField('yield')}
                  >
                    产量
                  </Box>
                </Tooltip>
              </Table.Cell>
              <Table.Cell collapsing p={1}>
                <Tooltip
                  content={
                    '变异: 植物随机状态以及发生突变的可能性. 它会影响由此植物制作成的食品和饮品的品质.'
                  }
                >
                  <Box
                    style={{ cursor: 'pointer' }}
                    onClick={(e) => setSortField('instability')}
                  >
                    变异
                  </Box>
                </Tooltip>
              </Table.Cell>
              <Table.Cell collapsing p={1}>
                <Tooltip
                  content={
                    '耐力: 植物的血量，能延缓死亡的到来. 它会提高由此植物制成的食品和饮料的品质.'
                  }
                >
                  <Box
                    style={{ cursor: 'pointer' }}
                    onClick={(e) => setSortField('endurance')}
                  >
                    耐力
                  </Box>
                </Tooltip>
              </Table.Cell>
              <Table.Cell collapsing p={1}>
                <Tooltip
                  content={`寿命: 植物开始衰败时的年龄，以${data.cycle_seconds}秒为周期. 它能提高由此植物制成的食品和饮料的品质.`}
                >
                  <Box
                    style={{ cursor: 'pointer' }}
                    onClick={(e) => setSortField('lifespan')}
                  >
                    寿命
                  </Box>
                </Tooltip>
              </Table.Cell>
              <Table.Cell collapsing p={1}>
                <Tooltip
                  content={`成熟: 首次收获所需时间，以${data.cycle_seconds}秒为周期.`}
                >
                  <Box
                    style={{ cursor: 'pointer' }}
                    onClick={(e) => setSortField('maturation')}
                  >
                    成熟
                  </Box>
                </Tooltip>
              </Table.Cell>
              <Table.Cell collapsing p={1}>
                <Tooltip
                  content={`生长周期: 再次结果所需时间，以${data.cycle_seconds}秒为周期.`}
                >
                  <Box
                    style={{ cursor: 'pointer' }}
                    onClick={(e) => setSortField('production')}
                  >
                    生长
                  </Box>
                </Tooltip>
              </Table.Cell>
              <Table.Cell collapsing p={1} textAlign="right">
                {sortField !== 'name' && (
                  <Tooltip content="重新排序">
                    <Button
                      color="transparent"
                      icon="refresh"
                      onClick={(e) => setSortField('name')}
                    />
                  </Tooltip>
                )}
                <Box align="right" />
              </Table.Cell>
              <Table.Cell collapsing p={1} textAlign="right">
                <Tooltip content={action ? '丢弃种子' : '拿取种子'}>
                  <Button
                    icon={action ? 'trash' : 'eject'}
                    color={action ? 'bad' : ''}
                    onClick={(e) => toggleAction(!action)}
                  />
                </Tooltip>
              </Table.Cell>
            </Table.Row>
            {seeds.length > 0 &&
              seeds.map((item) => (
                <Table.Row
                  key={item.key}
                  style={{ borderTop: '2px solid #222' }}
                >
                  <Table.Cell collapsing>
                    <Box
                      mb={-2}
                      className={classes(['seeds32x32', item.icon])}
                    />
                  </Table.Cell>
                  <Table.Cell py={0.5} px={1}>
                    {`${item.amount}x ${item.name}`}
                  </Table.Cell>
                  <Table.Cell py={0.5} px={1} collapsing textAlign={'right'}>
                    {item.traits?.map((trait) => (
                      <TraitTooltip
                        key=""
                        path={trait}
                        trait_db={data.trait_db}
                      />
                    ))}
                    {!!item.mutatelist.length && (
                      <Tooltip
                        content={`突变成为: ${item.mutatelist.join(', ')}`}
                      >
                        <Icon name="dna" m={0.5} />
                      </Tooltip>
                    )}
                    {item.reagents.length > 0 && (
                      <Tooltip
                        content={
                          <ReagentTooltip
                            reagents={item.reagents}
                            grind_results={item.grind_results}
                            potency={item.potency}
                            volume_mod={item.volume_mod}
                          />
                        }
                      >
                        <Icon name="blender" m={0.5} />
                      </Tooltip>
                    )}
                    {!!item.juice_name && (
                      <Tooltip content={`榨汁结果: ${item.juice_name}`}>
                        <Icon name="glass-water" m={0.5} />
                      </Tooltip>
                    )}
                    {!!item.distill_reagent && (
                      <Tooltip content={`发酵结果: ${item.distill_reagent}`}>
                        <Icon name="wine-bottle" m={0.5} />
                      </Tooltip>
                    )}
                  </Table.Cell>
                  <Table.Cell px={1} collapsing>
                    <Level value={item.potency} max={100} />
                  </Table.Cell>
                  <Table.Cell py={0.5} px={1} collapsing>
                    <Level value={item.yield} max={10} />
                  </Table.Cell>
                  <Table.Cell py={0.5} px={1} collapsing>
                    <Level value={item.instability} max={100} reverse />
                  </Table.Cell>
                  <Table.Cell py={0.5} px={1} collapsing>
                    <Level value={item.endurance} max={100} />
                  </Table.Cell>
                  <Table.Cell py={0.5} px={1} collapsing>
                    <Level value={item.lifespan} max={100} />
                  </Table.Cell>
                  <Table.Cell py={0.5} px={1} collapsing>
                    <Box textAlign="center">{item.maturation}</Box>
                  </Table.Cell>
                  <Table.Cell py={0.5} px={1} collapsing>
                    <Box textAlign="center">{item.production}</Box>
                  </Table.Cell>
                  <Table.Cell
                    py={0.5}
                    px={1}
                    collapsing
                    colSpan={2}
                    textAlign="right"
                  >
                    {action ? (
                      <Button
                        icon="eject"
                        content="拿取"
                        onClick={() =>
                          act('take', {
                            item: item.key,
                          })
                        }
                      />
                    ) : (
                      <Button
                        icon="trash"
                        content="丢弃"
                        color="bad"
                        onClick={() =>
                          act('scrap', {
                            item: item.key,
                          })
                        }
                      />
                    )}
                  </Table.Cell>
                </Table.Row>
              ))}
          </Table>
          {seeds.length === 0 && (
            <NoticeBox m={1} p={1}>
              未找到种子.
            </NoticeBox>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

const Level = (props) => {
  return (
    <ProgressBar
      value={props.value}
      maxValue={props.max}
      ranges={
        props.reverse
          ? {
              good: [0, props.max * 0.2],
              average: [props.max * 0.2, props.max * 0.6],
              bad: [props.max * 0.6, props.max],
            }
          : {
              bad: [0, props.max * 0.2],
              good: [props.max * 0.8, props.max],
            }
      }
    >
      <span
        style={{
          textShadow: '1px 1px 0 black',
        }}
      >
        {props.value}
      </span>
    </ProgressBar>
  );
};

const ReagentTooltip = (props) => {
  return (
    <Table>
      <Table.Row header>
        <Table.Cell colSpan={2}>研磨试剂:</Table.Cell>
      </Table.Row>
      {props.reagents?.map((reagent, i) => (
        <Table.Row key={i}>
          <Table.Cell>{reagent.name}</Table.Cell>
          <Table.Cell py={0.5} pl={2} textAlign={'right'}>
            {Math.max(
              Math.round(reagent.rate * props.potency * props.volume_mod),
              1,
            )}
            u
          </Table.Cell>
        </Table.Row>
      ))}
      {!!props.grind_results.length && (
        <>
          <Table.Row header>
            <Table.Cell colSpan={2} pt={1}>
              营养转化:
            </Table.Cell>
          </Table.Row>
          {props.grind_results?.map((reagent, i) => (
            <Table.Row key={i}>
              <Table.Cell colSpan={2}>{reagent}</Table.Cell>
            </Table.Row>
          ))}
        </>
      )}
    </Table>
  );
};

const TraitTooltip = (props) => {
  const trait = props.trait_db.find((t) => {
    return t.path === props.path;
  });
  return (
    <Tooltip
      key=""
      content={
        <Table>
          <Table.Row header>
            <Table.Cell>
              <Icon name={trait.icon} mr={1} />
              {trait.name}
            </Table.Cell>
          </Table.Row>
          {!!trait.description && (
            <Table.Row>
              <Table.Cell>{trait.description}</Table.Cell>
            </Table.Row>
          )}
        </Table>
      }
    >
      <Icon name={trait.icon} m={0.5} />
    </Tooltip>
  );
};
