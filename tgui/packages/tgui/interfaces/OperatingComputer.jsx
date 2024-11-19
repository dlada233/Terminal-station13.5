import { useBackend, useSharedState } from '../backend';
import {
  AnimatedNumber,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Tabs,
} from '../components';
import { Window } from '../layouts';

const damageTypes = [
  {
    label: '创伤',
    type: 'bruteLoss',
  },
  {
    label: '烧伤',
    type: 'fireLoss',
  },
  {
    label: '毒素伤',
    type: 'toxLoss',
  },
  {
    label: '窒息伤',
    type: 'oxyLoss',
  },
];

export const OperatingComputer = (props) => {
  const { act } = useBackend();
  const [tab, setTab] = useSharedState('tab', 1);

  return (
    <Window width={350} height={470}>
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab selected={tab === 1} onClick={() => setTab(1)}>
            病患状况
          </Tabs.Tab>
          <Tabs.Tab selected={tab === 2} onClick={() => setTab(2)}>
            手术程序
          </Tabs.Tab>
          <Tabs.Tab onClick={() => act('open_experiments')}>实验</Tabs.Tab>
        </Tabs>
        {tab === 1 && <PatientStateView />}
        {tab === 2 && <SurgeryProceduresView />}
      </Window.Content>
    </Window>
  );
};

const PatientStateView = (props) => {
  const { act, data } = useBackend();
  const { table, procedures = [], patient = {} } = data;
  if (!table) {
    return <NoticeBox>未检测到手术平台</NoticeBox>;
  }

  return (
    <>
      <Section title="病患状态">
        {Object.keys(patient).length ? (
          <LabeledList>
            <LabeledList.Item label="状态" color={patient.statstate}>
              {patient.stat}
            </LabeledList.Item>
            <LabeledList.Item label="血型">
              {patient.blood_type || '无法判断血型'}
            </LabeledList.Item>
            <LabeledList.Item label="健康">
              <ProgressBar
                value={patient.health}
                minValue={patient.minHealth}
                maxValue={patient.maxHealth}
                color={patient.health >= 0 ? 'good' : 'average'}
              >
                <AnimatedNumber value={patient.health} />
              </ProgressBar>
            </LabeledList.Item>
            {damageTypes.map((type) => (
              <LabeledList.Item key={type.type} label={type.label}>
                <ProgressBar
                  value={patient[type.type] / patient.maxHealth}
                  color="bad"
                >
                  <AnimatedNumber value={patient[type.type]} />
                </ProgressBar>
              </LabeledList.Item>
            ))}
          </LabeledList>
        ) : (
          '未检测到病患'
        )}
      </Section>
      {procedures.length === 0 && <Section>无手术程序</Section>}
      {procedures.map((procedure) => (
        <Section key={procedure.name} title={procedure.name}>
          <LabeledList>
            <LabeledList.Item label="下一步骤">
              {procedure.next_step}
              {procedure.chems_needed && (
                <>
                  <br />
                  <br />
                  <b>所需化学物:</b>
                  <br />
                  {procedure.chems_needed}
                </>
              )}
            </LabeledList.Item>
            {procedure.alternative_step && (
              <LabeledList.Item label="替代步骤">
                {procedure.alternative_step}
                {procedure.alt_chems_needed && (
                  <>
                    <br />
                    <br />
                    <b>所需化学物:</b>
                    <br />
                    {procedure.alt_chems_needed}
                  </>
                )}
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>
      ))}
    </>
  );
};

const SurgeryProceduresView = (props) => {
  const { act, data } = useBackend();
  const { surgeries = [] } = data;
  return (
    <Section title="高级手术程序">
      <Button
        icon="download"
        content="同步研究数据库"
        onClick={() => act('sync')}
      />
      {surgeries.map((surgery) => (
        <Section title={surgery.name} key={surgery.name} level={2}>
          {surgery.desc}
        </Section>
      ))}
    </Section>
  );
};
