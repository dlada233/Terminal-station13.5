import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

type Data = {
  animals_max: number;
  animals: number;
  choiceA: string;
  choiceB: string;
  completed: BooleanLike;
  dna_max: number;
  dna: number;
  plants_max: number;
  plants: number;
  used: BooleanLike;
};

export function DnaVault(props) {
  const { act, data } = useBackend<Data>();
  const {
    animals_max,
    animals,
    choiceA,
    choiceB,
    completed,
    dna_max,
    dna,
    plants_max,
    plants,
    used,
  } = data;

  return (
    <Window width={350} height={400}>
      <Window.Content>
        <Section title="DNA数据库">
          <LabeledList>
            <LabeledList.Item label="人类DNA">
              <ProgressBar value={dna / dna_max}>
                {dna + ' / ' + dna_max + ' 份样本'}
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="植物DNA">
              <ProgressBar value={plants / plants_max}>
                {plants + ' / ' + plants_max + ' 份样本'}
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="动物DNA">
              <ProgressBar value={animals / animals_max}>
                {animals + ' / ' + animals_max + ' 份样本'}
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {!!(completed && !used) && (
          <Section title="个体基因治疗">
            <Box bold textAlign="center" mb={1}>
              适用的基因治疗措施
            </Box>
            <Stack>
              <Stack.Item grow>
                <Button
                  fluid
                  bold
                  textAlign="center"
                  onClick={() =>
                    act('gene', {
                      choice: choiceA,
                    })
                  }
                >
                  {choiceA}
                </Button>
              </Stack.Item>
              <Stack.Item grow>
                <Button
                  fluid
                  bold
                  textAlign="center"
                  onClick={() =>
                    act('gene', {
                      choice: choiceB,
                    })
                  }
                >
                  {choiceB}
                </Button>
              </Stack.Item>
            </Stack>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
}
