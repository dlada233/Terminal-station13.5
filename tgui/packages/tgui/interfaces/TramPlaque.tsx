import { useBackend } from '../backend';
import { LabeledList, NoticeBox, Section, Stack } from '../components';
import { Window } from '../layouts';

type Data = {
  currentTram: Tram[];
  previousTrams: Tram[];
};

type Tram = {
  serialNumber: string;
  mfgDate: string;
  distanceTravelled: number;
  tramCollisions: number;
};

export const TramPlaque = (props) => {
  const { data } = useBackend<Data>();
  const { currentTram = [], previousTrams = [] } = data;

  return (
    <Window title="电车信息牌" width={600} height={360} theme="dark">
      <Window.Content>
        <NoticeBox info>SkyyTram Mk VI by Nakamura Engineering</NoticeBox>
        <Section
          title={
            currentTram.map((serialNumber) => serialNumber.serialNumber) +
            ' - Constructed ' +
            currentTram.map((serialNumber) => serialNumber.mfgDate)
          }
        >
          <LabeledList>
            <LabeledList.Item label="行驶距离">
              {currentTram.map(
                (serialNumber) => serialNumber.distanceTravelled / 1000,
              )}{' '}
              km
            </LabeledList.Item>
            <LabeledList.Item label="碰撞事故">
              {currentTram.map((serialNumber) => serialNumber.tramCollisions)}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="电车记录">
          <Stack fill>
            <Stack.Item m={1} grow>
              <b>运行</b>
            </Stack.Item>
            <Stack.Item m={1} grow>
              <b>建造</b>
            </Stack.Item>
            <Stack.Item m={1} grow>
              <b>距离</b>
            </Stack.Item>
            <Stack.Item m={1} grow>
              <b>碰撞</b>
            </Stack.Item>
          </Stack>
          <Stack vertical fill>
            {previousTrams.map((tram_entry) => (
              <Stack.Item key={tram_entry.serialNumber}>
                <Stack fill>
                  <Stack.Item m={1} grow>
                    {tram_entry.serialNumber}
                  </Stack.Item>
                  <Stack.Item m={1} grow>
                    {tram_entry.mfgDate}
                  </Stack.Item>
                  <Stack.Item m={1} grow>
                    {tram_entry.distanceTravelled / 1000} km
                  </Stack.Item>
                  <Stack.Item m={1} grow>
                    {tram_entry.tramCollisions}
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
