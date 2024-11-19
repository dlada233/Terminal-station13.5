import { BooleanLike, classes } from 'common/react';
import { capitalize } from 'common/string';
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  ColorBox,
  Divider,
  LabeledList,
  NumberInput,
  ProgressBar,
  Section,
  Stack,
  Table,
  Tooltip,
} from '../components';
import { Window } from '../layouts';
import { Beaker, BeakerReagent } from './common/BeakerDisplay';

type Container = {
  icon: string;
  ref: string;
  name: string;
  volume: number;
};

type Category = {
  name: string;
  containers: Container[];
};

type AnalyzableReagent = BeakerReagent & {
  ref: string;
  pH: number;
  color: string;
  description: string;
  purity: number;
  metaRate: number;
  overdose: number;
  addictionTypes: string[];
};

type AnalyzableBeaker = {
  contents: AnalyzableReagent[];
} & Beaker;

type Data = {
  categories: Category[];
  isPrinting: BooleanLike;
  printingProgress: number;
  printingTotal: number;
  maxPrintable: number;
  beaker: AnalyzableBeaker;
  buffer: AnalyzableBeaker;
  isTransfering: BooleanLike;
  suggestedContainerRef: string;
  selectedContainerRef: string;
  selectedContainerVolume: number;
};

export const ChemMaster = (props) => {
  const [analyzedReagent, setAnalyzedReagent] = useState<AnalyzableReagent>();

  return (
    <Window width={450} height={620}>
      <Window.Content scrollable>
        {analyzedReagent ? (
          <AnalysisResults
            analysisData={analyzedReagent}
            onExit={() => setAnalyzedReagent(undefined)}
          />
        ) : (
          <ChemMasterContent
            analyze={(chemical: AnalyzableReagent) =>
              setAnalyzedReagent(chemical)
            }
          />
        )}
      </Window.Content>
    </Window>
  );
};

const ChemMasterContent = (props: {
  analyze: (chemical: AnalyzableReagent) => void;
}) => {
  const { act, data } = useBackend<Data>();
  const {
    isPrinting,
    printingProgress,
    printingTotal,
    maxPrintable,
    isTransfering,
    beaker,
    buffer,
    categories,
    selectedContainerVolume,
  } = data;

  const [itemCount, setItemCount] = useState<number>(1);
  const [showPreferredContainer, setShowPreferredContainer] =
    useState<BooleanLike>(false);
  const buffer_contents = buffer.contents;

  return (
    <Box>
      <Section
        title="烧杯"
        buttons={
          beaker && (
            <Box>
              <Box inline color="label" mr={2}>
                <AnimatedNumber value={beaker.currentVolume} initial={0} />
                {` / ${beaker.maxVolume} units`}
              </Box>
              <Button icon="eject" onClick={() => act('eject')}>
                取出
              </Button>
            </Box>
          )
        }
      >
        {!beaker ? (
          <Box color="label" my={'4px'}>
            未装载烧杯.
          </Box>
        ) : beaker.currentVolume === 0 ? (
          <Box color="label" my={'4px'}>
            烧杯是空的.
          </Box>
        ) : (
          <Table>
            {beaker.contents.map((chemical) => (
              <ReagentEntry
                key={chemical.ref}
                chemical={chemical}
                transferTo="buffer"
                analyze={props.analyze}
              />
            ))}
          </Table>
        )}
      </Section>
      <Section
        title="缓存区"
        buttons={
          <>
            <Box inline color="label" mr={1}>
              <AnimatedNumber value={buffer.currentVolume} initial={0} />
              {` / ${buffer.maxVolume} 单位`}
            </Box>
            <Button
              color={isTransfering ? 'good' : 'bad'}
              icon={isTransfering ? 'exchange-alt' : 'trash'}
              onClick={() => act('toggleTransferMode')}
            >
              {isTransfering ? '转移试剂' : '销毁试剂'}
            </Button>
          </>
        }
      >
        {buffer_contents.length === 0 ? (
          <Box color="label" my={'4px'}>
            缓存区.
          </Box>
        ) : (
          <Table>
            {buffer_contents.map((chemical) => (
              <ReagentEntry
                key={chemical.ref}
                chemical={chemical}
                transferTo="beaker"
                analyze={props.analyze}
              />
            ))}
          </Table>
        )}
      </Section>
      {!isPrinting && (
        <Section
          title="包装"
          buttons={
            buffer_contents.length !== 0 && (
              <Box>
                <Button.Checkbox
                  checked={showPreferredContainer}
                  onClick={() =>
                    setShowPreferredContainer((currentValue) => !currentValue)
                  }
                >
                  建议
                </Button.Checkbox>
                <NumberInput
                  unit={'items'}
                  step={1}
                  value={itemCount}
                  minValue={1}
                  maxValue={maxPrintable}
                  onChange={(value) => {
                    setItemCount(value);
                  }}
                />
                <Box inline mx={1}>
                  {`${
                    Math.round(
                      Math.min(
                        selectedContainerVolume,
                        buffer.currentVolume / itemCount,
                      ) * 100,
                    ) / 100
                  } u. 每份`}
                </Box>
                <Button
                  icon="flask"
                  onClick={() =>
                    act('create', {
                      itemCount: itemCount,
                    })
                  }
                >
                  打印
                </Button>
              </Box>
            )
          }
        >
          {categories.map((category) => (
            <Box key={category.name}>
              <GroupTitle title={category.name} />
              {category.containers.map((container) => (
                <ContainerButton
                  key={container.ref}
                  category={category}
                  container={container}
                  showPreferredContainer={showPreferredContainer}
                />
              ))}
            </Box>
          ))}
        </Section>
      )}
      {!!isPrinting && (
        <Section
          title="打印中"
          buttons={
            <Button
              color="bad"
              icon="times"
              onClick={() => act('stopPrinting')}
            >
              停止
            </Button>
          }
        >
          <ProgressBar
            value={printingProgress}
            minValue={0}
            maxValue={printingTotal}
            color="good"
          >
            <Box
              lineHeight={1.9}
              style={{
                textShadow: '1px 1px 0 black',
              }}
            >
              {`打印 ${printingProgress} 用 ${printingTotal}`}
            </Box>
          </ProgressBar>
        </Section>
      )}
    </Box>
  );
};

type ReagentProps = {
  chemical: AnalyzableReagent;
  transferTo: string;
  analyze: (chemical: AnalyzableReagent) => void;
};

const ReagentEntry = (props: ReagentProps) => {
  const { data, act } = useBackend<Data>();
  const { chemical, transferTo, analyze } = props;
  const { isPrinting } = data;
  return (
    <Table.Row key={chemical.ref}>
      <Table.Cell color="label">
        {`${chemical.name} `}
        <AnimatedNumber value={chemical.volume} initial={0} />
        {`u`}
      </Table.Cell>
      <Table.Cell collapsing>
        <Button
          disabled={isPrinting}
          onClick={() => {
            act('transfer', {
              reagentRef: chemical.ref,
              amount: 1,
              target: transferTo,
            });
          }}
        >
          1
        </Button>
        <Button
          disabled={isPrinting}
          onClick={() =>
            act('transfer', {
              reagentRef: chemical.ref,
              amount: 5,
              target: transferTo,
            })
          }
        >
          5
        </Button>
        <Button
          disabled={isPrinting}
          onClick={() =>
            act('transfer', {
              reagentRef: chemical.ref,
              amount: 10,
              target: transferTo,
            })
          }
        >
          10
        </Button>
        <Button
          disabled={isPrinting}
          onClick={() =>
            act('transfer', {
              reagentRef: chemical.ref,
              amount: 1000,
              target: transferTo,
            })
          }
        >
          全部
        </Button>
        <Button
          icon="ellipsis-h"
          tooltip="自定义数量"
          disabled={isPrinting}
          onClick={() =>
            act('transfer', {
              reagentRef: chemical.ref,
              amount: -1,
              target: transferTo,
            })
          }
        />
        <Button
          icon="question"
          tooltip="进行分析"
          onClick={() => analyze(chemical)}
        />
      </Table.Cell>
    </Table.Row>
  );
};

type CategoryButtonProps = {
  category: Category;
  container: Container;
  showPreferredContainer: BooleanLike;
};

const ContainerButton = (props: CategoryButtonProps) => {
  const { act, data } = useBackend<Data>();
  const { isPrinting, selectedContainerRef, suggestedContainerRef } = data;
  const { category, container, showPreferredContainer } = props;
  const isPillPatch = ['pills', 'patches'].includes(category.name);

  return (
    <Tooltip
      key={container.ref}
      content={`${capitalize(container.name)}\xa0(${container.volume}u)`}
    >
      <Button
        overflow="hidden"
        color={'transparent'}
        backgroundColor={
          showPreferredContainer &&
          selectedContainerRef !== suggestedContainerRef && // if we selected the same container as the suggested then don't override color
          container.ref === suggestedContainerRef
            ? 'blue'
            : 'transparent'
        }
        width={isPillPatch ? '32px' : '48px'}
        height={isPillPatch ? '32px' : '48px'}
        selected={container.ref === selectedContainerRef}
        disabled={isPrinting}
        p={0}
        onClick={() => {
          act('selectContainer', {
            ref: container.ref,
          });
        }}
      >
        <Box
          m={isPillPatch ? '0' : '8px'}
          style={{
            transform: 'scale(2)',
          }}
          className={classes(['chemmaster32x32', container.icon])}
        />
      </Button>
    </Tooltip>
  ) as any;
};

const AnalysisResults = (props: {
  analysisData: AnalyzableReagent;
  onExit: () => void;
}) => {
  const {
    name,
    pH,
    color,
    description,
    purity,
    metaRate,
    overdose,
    addictionTypes,
  } = props.analysisData;

  const purityLevel =
    purity <= 0.5 ? 'bad' : purity <= 0.75 ? 'average' : 'good'; // Color names

  return (
    <Section
      title="分析结果"
      buttons={
        <Button icon="arrow-left" onClick={() => props.onExit()}>
          返回
        </Button>
      }
    >
      <LabeledList>
        <LabeledList.Item label="名称">{name}</LabeledList.Item>
        <LabeledList.Item label="纯度">
          <Box
            style={{
              textTransform: 'capitalize',
            }}
            color={purityLevel}
          >
            {purityLevel}
          </Box>
        </LabeledList.Item>
        <LabeledList.Item label="pH">{pH}</LabeledList.Item>
        <LabeledList.Item label="颜色">
          <ColorBox color={color} mr={1} />
          {color}
        </LabeledList.Item>
        <LabeledList.Item label="描述">{description}</LabeledList.Item>
        <LabeledList.Item label="代谢率">{metaRate} 单位/秒</LabeledList.Item>
        <LabeledList.Item label="过量阈值">
          {overdose > 0 ? `${overdose} 单位` : 'N/A'}
        </LabeledList.Item>
        <LabeledList.Item label="成瘾类型">
          {addictionTypes.length ? addictionTypes.toString() : 'N/A'}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const GroupTitle = ({ title }) => {
  return (
    <Stack my={1}>
      <Stack.Item grow>
        <Divider />
      </Stack.Item>
      <Stack.Item
        style={{
          textTransform: 'capitalize',
        }}
        color={'gray'}
      >
        {title}
      </Stack.Item>
      <Stack.Item grow>
        <Divider />
      </Stack.Item>
    </Stack>
  ) as any;
};
