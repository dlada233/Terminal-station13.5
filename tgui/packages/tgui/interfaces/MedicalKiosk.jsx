import { useBackend, useSharedState } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  Flex,
  Icon,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

export const MedicalKiosk = (props) => {
  const { act, data } = useBackend();
  const [scanIndex] = useSharedState('scanIndex');
  const { active_status_1, active_status_2, active_status_3, active_status_4 } =
    data;
  return (
    <Window width={575} height={420}>
      <Window.Content scrollable>
        <Flex mb={1}>
          <Flex.Item mr={1}>
            <Section minHeight="100%">
              <MedicalKioskScanButton
                index={1}
                icon="procedures"
                name="常规健康检查"
                description={`
                  显示你常规健康扫描下的准确数值.
                `}
              />
              <MedicalKioskScanButton
                index={2}
                icon="heartbeat"
                name="非显性病症检查"
                description={`
                  提供基于各种不明显的病症的信息，比如血含量或疾病感染.
                `}
              />
              <MedicalKioskScanButton
                index={3}
                icon="radiation-alt"
                name="神经/放射性检查"
                description={`
                  提供有关脑神经损伤和辐射的信息.
                `}
              />
              <MedicalKioskScanButton
                index={4}
                icon="mortar-pestle"
                name="体内化学检查"
                description={`
                  提供体内的化学物质列表以及潜在的副作用.
                `}
              />
            </Section>
          </Flex.Item>
          <Flex.Item grow={1} basis={0}>
            <MedicalKioskInstructions />
          </Flex.Item>
        </Flex>
        {!!active_status_1 && scanIndex === 1 && <MedicalKioskScanResults1 />}
        {!!active_status_2 && scanIndex === 2 && <MedicalKioskScanResults2 />}
        {!!active_status_3 && scanIndex === 3 && <MedicalKioskScanResults3 />}
        {!!active_status_4 && scanIndex === 4 && <MedicalKioskScanResults4 />}
      </Window.Content>
    </Window>
  );
};

const MedicalKioskScanButton = (props) => {
  const { index, name, description, icon } = props;
  const { act, data } = useBackend();
  const [scanIndex, setScanIndex] = useSharedState('scanIndex');
  const paid = data[`active_status_${index}`];
  return (
    <Stack align="baseline">
      <Stack.Item width="16px" textAlign="center">
        <Icon
          name={paid ? 'check' : 'dollar-sign'}
          color={paid ? 'green' : 'grey'}
        />
      </Stack.Item>
      <Stack.Item grow basis="content">
        <Button
          fluid
          icon={icon}
          selected={paid && scanIndex === index}
          tooltip={description}
          tooltipPosition="right"
          content={name}
          onClick={() => {
            if (!paid) {
              act(`beginScan_${index}`);
            }
            setScanIndex(index);
          }}
        />
      </Stack.Item>
    </Stack>
  );
};

const MedicalKioskInstructions = (props) => {
  const { act, data } = useBackend();
  const { kiosk_cost, patient_name } = data;
  return (
    <Section minHeight="100%">
      <Box italic>
        尊敬的员工您好! 请选择所需进行的自助体检项目. 每次诊断花费为{' '}
        <b>{kiosk_cost} 信用点.</b>
      </Box>
      <Box mt={1}>
        <Box inline color="label" mr={1}>
          患者:
        </Box>
        {patient_name}
      </Box>
      <Button
        mt={1}
        tooltip={`
          重置当前扫描目标，取消当前扫描.
        `}
        icon="sync"
        color="average"
        onClick={() => act('clearTarget')}
        content="重置扫描仪"
      />
    </Section>
  );
};

const MedicalKioskScanResults1 = (props) => {
  const { data } = useBackend();
  const {
    patient_health,
    brute_health,
    burn_health,
    suffocation_health,
    toxin_health,
  } = data;
  return (
    <Section title="患者健康">
      <LabeledList>
        <LabeledList.Item label="整体健康">
          <ProgressBar value={patient_health / 100}>
            <AnimatedNumber value={patient_health} />%
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Divider />
        <LabeledList.Item label="烧伤">
          <ProgressBar value={brute_health / 100} color="bad">
            <AnimatedNumber value={brute_health} />
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="创伤">
          <ProgressBar value={burn_health / 100} color="bad">
            <AnimatedNumber value={burn_health} />
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="窒息伤">
          <ProgressBar value={suffocation_health / 100} color="bad">
            <AnimatedNumber value={suffocation_health} />
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="毒素伤">
          <ProgressBar value={toxin_health / 100} color="bad">
            <AnimatedNumber value={toxin_health} />
          </ProgressBar>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const MedicalKioskScanResults2 = (props) => {
  const { data } = useBackend();
  const {
    patient_status,
    patient_illness,
    illness_info,
    bleed_status,
    blood_levels,
    blood_status,
  } = data;
  return (
    <Section title="非显性病症检查">
      <LabeledList>
        <LabeledList.Item label="患者状态" color="good">
          {patient_status}
        </LabeledList.Item>
        <LabeledList.Divider />
        <LabeledList.Item label="疾病状态">{patient_illness}</LabeledList.Item>
        <LabeledList.Item label="疾病信息">{illness_info}</LabeledList.Item>
        <LabeledList.Divider />
        <LabeledList.Item label="血含量水平">
          <ProgressBar value={blood_levels / 100} color="bad">
            <AnimatedNumber value={blood_levels} />
          </ProgressBar>
          <Box mt={1} color="label">
            {bleed_status}
          </Box>
        </LabeledList.Item>
        <LabeledList.Item label="血液信息">{blood_status}</LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const MedicalKioskScanResults3 = (props) => {
  const { data } = useBackend();
  const { brain_damage, brain_health, trauma_status } = data;
  return (
    <Section title="患者神经健康">
      <LabeledList>
        <LabeledList.Item label="脑损伤">
          <ProgressBar value={brain_damage / 100} color="good">
            <AnimatedNumber value={brain_damage} />
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="大脑状态" color="health-0">
          {brain_health}
        </LabeledList.Item>
        <LabeledList.Item label="脑神经损伤状态">
          {trauma_status}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const MedicalKioskScanResults4 = (props) => {
  const { data } = useBackend();
  const {
    chemical_list = [],
    overdose_list = [],
    addict_list = [],
    hallucinating_status,
    blood_alcohol,
  } = data;
  return (
    <Section title="体内化学物质分析">
      <LabeledList>
        <LabeledList.Item label="化学成分">
          {chemical_list.length === 0 && (
            <Box color="average">未检测到试剂.</Box>
          )}
          {chemical_list.map((chem) => (
            <Box key={chem.id} color="good">
              {chem.volume} 单位的 {chem.name}
            </Box>
          ))}
        </LabeledList.Item>
        <LabeledList.Item label="过量状况" color="bad">
          {overdose_list.length === 0 && (
            <Box color="good">患者未用药过量.</Box>
          )}
          {overdose_list.map((chem) => (
            <Box key={chem.id}>过量服用{chem.name}</Box>
          ))}
        </LabeledList.Item>
        <LabeledList.Item label="成瘾状况" color="bad">
          {addict_list.length === 0 && (
            <Box color="good">患者没有成瘾项目.</Box>
          )}
          {addict_list.map((chem) => (
            <Box key={chem.id}>{chem.name}成瘾</Box>
          ))}
        </LabeledList.Item>
        <LabeledList.Item label="精神活动状态">
          {hallucinating_status}
        </LabeledList.Item>
        <LabeledList.Item label="血液酒精含量">
          <ProgressBar
            value={blood_alcohol}
            minValue={0}
            maxValue={0.3}
            ranges={{
              blue: [-Infinity, 0.23],
              bad: [0.23, Infinity],
            }}
          >
            <AnimatedNumber value={blood_alcohol} />
          </ProgressBar>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
