import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

const DISEASE_THEASHOLD_LIST = [
  '良性',
  '无害',
  '轻微',
  '较重',
  '有害',
  '危险',
  '生物危害',
];

const TARGET_SPECIES_LIST = [
  {
    name: '人类',
    value: 'human',
  },
  {
    name: '蜥蜴人',
    value: 'lizard',
  },
  {
    name: '苍蝇人',
    value: 'fly',
  },
  {
    name: '猫人',
    value: 'felinid',
  },
  {
    name: '等离子人',
    value: 'plasma',
  },
  {
    name: '蛾子人',
    value: 'moth',
  },
  {
    name: '凝胶人',
    value: 'jelly',
  },
  {
    name: '豆荚人',
    value: 'pod',
  },
  {
    name: '石人',
    value: 'golem',
  },
  {
    name: '僵尸',
    value: 'zombie',
  },
  //  SKYRAT EDIT START - MORE SCANNER GATE OPTIONS
  {
    name: 'Anthromorph',
    value: 'mammal',
  },
  {
    name: 'Vox',
    value: 'vox',
  },
  {
    name: '鲛人',
    value: 'aquatic',
  },
  {
    name: 'Anthromorphic Insect',
    value: 'insect',
  },
  {
    name: '异形',
    value: 'xeno',
  },
  {
    name: 'Unathi',
    value: 'unathi',
  },
  {
    name: 'Tajaran',
    value: 'tajaran',
  },
  {
    name: 'Vulpkanin',
    value: 'vulpkanin',
  },
  {
    name: '合成人',
    value: 'synth',
  },
  {
    name: 'Teshari',
    value: 'teshari',
  },
  {
    name: 'Hemophage',
    value: 'hemophage',
  },
  {
    name: '蜗牛人',
    value: 'snail',
  },
];

const TARGET_GENDER_LIST = [
  {
    name: '男性',
    value: 'male',
  },
  {
    name: '女性',
    value: 'female',
  },
  //  SKYRAT EDIT END - MORE SCANNER GATE OPTIONS
];

const TARGET_NUTRITION_LIST = [
  {
    name: '饥饿',
    value: 150,
  },
  {
    name: '肥胖',
    value: 600,
  },
];

export const ScannerGate = (props) => {
  const { act, data } = useBackend();
  return (
    <Window width={400} height={300}>
      <Window.Content scrollable>
        <InterfaceLockNoticeBox
          onLockedStatusChange={() => act('toggle_lock')}
        />
        {!data.locked && <ScannerGateControl />}
      </Window.Content>
    </Window>
  );
};

const SCANNER_GATE_ROUTES = {
  Off: {
    title: '扫描模式: 关',
    component: () => ScannerGateOff,
  },
  Wanted: {
    title: '扫描模式: 通缉犯',
    component: () => ScannerGateWanted,
  },
  Guns: {
    title: '扫描模式: 枪械',
    component: () => ScannerGateGuns,
  },
  Mindshield: {
    title: '扫描模式: 心盾',
    component: () => ScannerGateMindshield,
  },
  Disease: {
    title: '扫描模式: 疾病',
    component: () => ScannerGateDisease,
  },
  Species: {
    title: '扫描模式: 种族',
    component: () => ScannerGateSpecies,
  },
  Nutrition: {
    title: '扫描模式: 营养情况',
    component: () => ScannerGateNutrition,
  },
  //  SKYRAT EDIT START - MORE SCANNER GATE OPTIONS
  Gender: {
    title: '扫描模式: 性别',
    component: () => ScannerGateGender,
  },
  //  SKYRAT EDIT END - MORE SCANNER GATE OPTIONS
};

const ScannerGateControl = (props) => {
  const { act, data } = useBackend();
  const { scan_mode } = data;
  const route = SCANNER_GATE_ROUTES[scan_mode] || SCANNER_GATE_ROUTES.off;
  const Component = route.component();
  return (
    <Section
      title={route.title}
      buttons={
        scan_mode !== 'Off' && (
          <Button
            icon="arrow-left"
            content="返回"
            onClick={() => act('set_mode', { new_mode: 'Off' })}
          />
        )
      }
    >
      <Component />
    </Section>
  );
};

const ScannerGateOff = (props) => {
  const { act } = useBackend();
  return (
    <>
      <Box mb={2}>选择扫描模式.</Box>
      <Box>
        <Button
          content="通缉犯"
          onClick={() => act('set_mode', { new_mode: 'Wanted' })}
        />
        <Button
          content="枪械"
          onClick={() => act('set_mode', { new_mode: 'Guns' })}
        />
        <Button
          content="心盾"
          onClick={() => act('set_mode', { new_mode: 'Mindshield' })}
        />
        <Button
          content="疾病"
          onClick={() => act('set_mode', { new_mode: 'Disease' })}
        />
        <Button
          content="种族"
          onClick={() => act('set_mode', { new_mode: 'Species' })}
        />
        <Button //  SKYRAT EDIT START - MORE SCANNER GATE OPTIONS
          content="性别"
          onClick={() => act('set_mode', { new_mode: 'Gender' })} //  SKYRAT EDIT END - MORE SCANNER GATE OPTIONS
        />
        <Button
          content="营养情况"
          onClick={() => act('set_mode', { new_mode: 'Nutrition' })}
        />
      </Box>
    </>
  );
};

const ScannerGateWanted = (props) => {
  const { data } = useBackend();
  const { reverse } = data;
  return (
    <>
      <Box mb={2}>当扫描到{reverse ? '没有被通缉' : '被通缉'}的人时触发.</Box>
      <ScannerGateMode />
    </>
  );
};

const ScannerGateGuns = (props) => {
  const { data } = useBackend();
  const { reverse } = data;
  return (
    <>
      <Box mb={2}>当扫描到{reverse ? '没有携带' : '携带'}枪械的人时触发.</Box>
      <ScannerGateMode />
    </>
  );
};

const ScannerGateMindshield = (props) => {
  const { data } = useBackend();
  const { reverse } = data;
  return (
    <>
      <Box mb={2}>当扫描到{reverse ? '没有植入' : '植入'}心盾的人时触发.</Box>
      <ScannerGateMode />
    </>
  );
};

const ScannerGateDisease = (props) => {
  const { act, data } = useBackend();
  const { reverse, disease_threshold } = data;
  return (
    <>
      <Box mb={2}>
        当扫描到{reverse ? '未患有' : '患有'}
        {disease_threshold}以及更严重级别疾病 的人时触发.
      </Box>
      <Box mb={2}>
        {DISEASE_THEASHOLD_LIST.map((threshold) => (
          <Button.Checkbox
            key={threshold}
            checked={threshold === disease_threshold}
            content={threshold}
            onClick={() =>
              act('set_disease_threshold', {
                new_threshold: threshold,
              })
            }
          />
        ))}
      </Box>
      <ScannerGateMode />
    </>
  );
};

const ScannerGateSpecies = (props) => {
  const { act, data } = useBackend();
  const { reverse, target_species } = data;
  const species = TARGET_SPECIES_LIST.find((species) => {
    return species.value === target_species;
  });
  return (
    <>
      <Box mb={2}>
        当扫描到{reverse ? '非' : ''}
        {species.name}时触发.
        {target_species === 'zombie' &&
          ' 所有类型的僵尸都包括在内，包括病毒处于潜伏期的僵尸.'}
      </Box>
      <Box mb={2}>
        {TARGET_SPECIES_LIST.map((species) => (
          <Button.Checkbox
            key={species.value}
            checked={species.value === target_species}
            content={species.name}
            onClick={() =>
              act('set_target_species', {
                new_species: species.value,
              })
            }
          />
        ))}
      </Box>
      <ScannerGateMode />
    </>
  );
};

const ScannerGateNutrition = (props) => {
  const { act, data } = useBackend();
  const { reverse, target_nutrition } = data;
  const nutrition = TARGET_NUTRITION_LIST.find((nutrition) => {
    return nutrition.value === target_nutrition;
  });
  return (
    <>
      <Box mb={2}>
        当扫描到营养水平{reverse ? '未处于' : '处于'}
        {nutrition.name}状态的人时触发.
      </Box>
      <Box mb={2}>
        {TARGET_NUTRITION_LIST.map((nutrition) => (
          <Button.Checkbox
            key={nutrition.name}
            checked={nutrition.value === target_nutrition}
            content={nutrition.name}
            onClick={() =>
              act('set_target_nutrition', {
                new_nutrition: nutrition.name,
              })
            }
          />
        ))}
      </Box>
      <ScannerGateMode />
    </>
  );
};

//  SKYRAT EDIT START - MORE SCANNER GATE OPTIONS
const ScannerGateGender = (props) => {
  const { act, data } = useBackend();
  const { reverse, target_gender } = data;
  const gender = TARGET_GENDER_LIST.find((gender) => {
    return gender.value === target_gender;
  });
  return (
    <>
      <Box mb={2}>
        当扫描到{reverse ? '非' : ''}
        {gender.name}时触发.
      </Box>
      <Box mb={2}>
        {TARGET_GENDER_LIST.map((gender) => (
          <Button.Checkbox
            key={gender.name}
            checked={gender.value === target_gender}
            content={gender.name}
            onClick={() =>
              act('set_target_gender', {
                new_gender: gender.name,
              })
            }
          />
        ))}
      </Box>
      <ScannerGateMode />
    </>
  );
};
//  SKYRAT EDIT END - MORE SCANNER GATE OPTIONS

const ScannerGateMode = (props) => {
  const { act, data } = useBackend();
  const { reverse } = data;
  return (
    <LabeledList>
      <LabeledList.Item label="扫描模式">
        <Button
          content={reverse ? '反转' : '默认'}
          icon={reverse ? 'random' : 'long-arrow-alt-right'}
          onClick={() => act('toggle_reverse')}
          color={reverse ? 'bad' : 'good'}
        />
      </LabeledList.Item>
    </LabeledList>
  );
};
