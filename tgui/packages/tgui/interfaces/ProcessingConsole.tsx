import { toTitleCase } from 'common/string';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Icon,
  Image,
  NoticeBox,
  Section,
  Stack,
  Table,
} from '../components';
import { formatSiUnit } from '../format';
import { Window } from '../layouts';
import { Material } from './Fabrication/Types';

type IconData = {
  id: string;
  icon: string;
};

type Alloy = {
  name: string;
  id: string;
};

type Data = {
  materials: Material[];
  materialIcons: IconData[];
  selectedMaterial: string | null;
  alloys: Alloy[];
  alloyIcons: IconData[];
  selectedAlloy: string | null;
  state: boolean;
  SHEET_MATERIAL_AMOUNT: number;
};

export const ProcessingConsole = (props: any) => {
  const { act, data } = useBackend<Data>();
  const { state } = data;

  return (
    <Window title="处理终端" width={580} height={500}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item grow basis={0}>
            <Stack fill>
              <Stack.Item grow={1.2} basis={0}>
                <Section fill textAlign="center" title="一般材料">
                  <MaterialSelection />
                </Section>
              </Stack.Item>
              <Stack.Item grow basis={0}>
                <Section fill title="合金材料" textAlign="center">
                  <AlloySelection />
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="arrows-spin"
              iconSpin={state}
              color={state ? 'bad' : 'good'}
              textAlign="center"
              fontSize={1.25}
              py={1}
              fluid
              bold
              onClick={() => act('toggle')}
            >
              {state ? '禁用' : '激活'}
            </Button>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const MaterialSelection = (props: any) => {
  const { act, data } = useBackend<Data>();
  const { materials, materialIcons, selectedMaterial, SHEET_MATERIAL_AMOUNT } =
    data;

  return materials.length > 0 ? (
    <Table>
      {materials.map((material) => (
        <DisplayRow
          key={material.name}
          name={material.name}
          icon={materialIcons.find((icon) => icon.id === material.ref)?.icon}
          amount={Math.floor(material.amount / SHEET_MATERIAL_AMOUNT)}
          selected={selectedMaterial === material.name}
          onSelect={() => act('setMaterial', { value: material.ref })}
        />
      ))}
    </Table>
  ) : (
    <NoticeBox danger>未找到材料配方!</NoticeBox>
  );
};

const AlloySelection = (props: any) => {
  const { act, data } = useBackend<Data>();
  const { alloys, alloyIcons, selectedAlloy } = data;

  return alloys.length > 0 ? (
    <Table>
      {alloys.map((alloy) => (
        <DisplayRow
          key={alloy.id}
          name={alloy.name}
          icon={alloyIcons.find((icon) => icon.id === alloy.id)?.icon}
          selected={selectedAlloy === alloy.id}
          onSelect={() => act('setAlloy', { value: alloy.id })}
        />
      ))}
    </Table>
  ) : (
    <NoticeBox danger>未找到合金配方!</NoticeBox>
  );
};

type DisplayRowProps = {
  name: string;
  icon?: string;
  amount?: number;
  selected: boolean;
  onSelect: () => void;
};

const DisplayRow = (props: DisplayRowProps) => {
  const { name, icon, amount, selected, onSelect } = props;

  return (
    <Table.Row className="candystripe">
      <Table.Cell collapsing pl={1}>
        {icon ? (
          <Image
            m={1}
            width="24px"
            height="24px"
            verticalAlign="middle"
            src={`data:image/jpeg;base64,${icon}`}
          />
        ) : (
          <Icon name="circle-question" verticalAlign="middle" />
        )}
      </Table.Cell>
      <Table.Cell collapsing textAlign="left">
        {toTitleCase(name)}
      </Table.Cell>
      {amount !== undefined ? (
        <Box color="label">
          {`${formatSiUnit(amount, 0)} ${amount === 1 ? '份板材' : '份板材'}`}
        </Box>
      ) : null}
      <Table.Cell collapsing pr={1} textAlign="right">
        <Button.Checkbox
          color="transparent"
          checked={selected}
          onClick={() => onSelect()}
        />
      </Table.Cell>
    </Table.Row>
  );
};
