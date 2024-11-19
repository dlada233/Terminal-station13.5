import { BooleanLike } from 'common/react';
import { toTitleCase } from 'common/string';
import { useState } from 'react';
import {
  Box,
  Button,
  Icon,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Beaker, BeakerDisplay } from './common/BeakerDisplay';

type DispensableReagent = {
  title: string;
  id: string;
  pH: number;
  pHCol: string;
};

type TransferableBeaker = Beaker & {
  transferAmounts: number[];
};

type Data = {
  showpH: BooleanLike;
  amount: number;
  energy: number;
  maxEnergy: number;
  displayedEnergy: string;
  displayedMaxEnergy: string;
  chemicals: DispensableReagent[];
  recipes: string[];
  recordingRecipe: string[];
  recipeReagents: string[];
  beaker: TransferableBeaker;
};

export const ChemDispenser = (props) => {
  const { act, data } = useBackend<Data>();
  const recording = !!data.recordingRecipe;
  const { recipeReagents = [], recipes = [], beaker } = data;
  const [hasCol, setHasCol] = useState(false);

  const beakerTransferAmounts = beaker ? beaker.transferAmounts : [];
  const recordedContents =
    recording &&
    Object.keys(data.recordingRecipe).map((id) => ({
      id,
      name: toTitleCase(id.replace(/_/, ' ')),
      volume: data.recordingRecipe[id],
    }));

  return (
    <Window width={565} height={620}>
      <Window.Content scrollable>
        <Section
          title="状态"
          buttons={
            <>
              {recording && (
                <Box inline mx={1} color="red">
                  <Icon name="circle" mr={1} />
                  记录中
                </Box>
              )}
              <Button
                icon="book"
                disabled={!beaker}
                tooltip={beaker ? '查找配方和试剂!' : '请插入烧杯!'}
                tooltipPosition="bottom-start"
                onClick={() => act('reaction_lookup')}
              >
                Reaction search
              </Button>
              <Button
                icon="cog"
                tooltip="按pH值对试剂进行颜色标记"
                tooltipPosition="bottom-start"
                selected={hasCol}
                onClick={() => setHasCol(!hasCol)}
              />
            </>
          }
        >
          <LabeledList>
            <LabeledList.Item label="能量">
              <ProgressBar value={data.energy / data.maxEnergy}>
                {data.displayedEnergy + ' / ' + data.displayedMaxEnergy}
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="配方"
          buttons={
            <>
              {!recording && (
                <Box inline mx={1}>
                  <Button
                    color="transparent"
                    onClick={() => act('clear_recipes')}
                  >
                    清除配方
                  </Button>
                </Box>
              )}
              {!recording && (
                <Button
                  icon="circle"
                  disabled={!beaker}
                  onClick={() => act('record_recipe')}
                >
                  记录
                </Button>
              )}
              {recording && (
                <Button
                  icon="ban"
                  color="transparent"
                  onClick={() => act('cancel_recording')}
                >
                  弃置
                </Button>
              )}
              {recording && (
                <Button
                  icon="save"
                  color="green"
                  onClick={() => act('save_recording')}
                >
                  保存
                </Button>
              )}
            </>
          }
        >
          <Box mr={-1}>
            {Object.keys(recipes).map((recipe) => (
              <Button
                key={recipe}
                icon="tint"
                width="129.5px"
                lineHeight={1.75}
                onClick={() =>
                  act('dispense_recipe', {
                    recipe: recipe,
                  })
                }
              >
                {recipe}
              </Button>
            ))}
            {recipes.length === 0 && <Box color="light-gray">No recipes.</Box>}
          </Box>
        </Section>
        <Button // SKYRAT EDIT ADDITION BEGIN - CHEMISTRY QOL
          icon="pen"
          content="自定义数量"
          onClick={() => act('custom_amount')}
        />
        <Section
          title="配药"
          buttons={beakerTransferAmounts.map((amount) => (
            <Button
              key={amount}
              icon="plus"
              selected={amount === data.amount}
              onClick={() =>
                act('amount', {
                  target: amount,
                })
              }
            >
              {amount}
            </Button>
          ))}
        >
          <Box mr={-1}>
            {data.chemicals.map((chemical) => (
              <Button
                key={chemical.id}
                icon="tint"
                width="129.5px"
                lineHeight={1.75}
                tooltip={'pH: ' + chemical.pH}
                backgroundColor={
                  recipeReagents.includes(chemical.id)
                    ? hasCol
                      ? 'black'
                      : 'green'
                    : hasCol
                      ? chemical.pHCol
                      : 'default'
                }
                onClick={() =>
                  act('dispense', {
                    reagent: chemical.id,
                  })
                }
              >
                {chemical.title}
              </Button>
            ))}
          </Box>
        </Section>
        <Section
          title="烧杯"
          buttons={beakerTransferAmounts.map((amount) => (
            <Button
              key={amount}
              icon="minus"
              disabled={recording}
              onClick={() => act('remove', { amount })}
            >
              {amount}
            </Button>
          ))}
        >
          <BeakerDisplay
            beaker={beaker}
            title_label={recording && '虚拟烧杯'}
            replace_contents={recordedContents}
            showpH={data.showpH}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
