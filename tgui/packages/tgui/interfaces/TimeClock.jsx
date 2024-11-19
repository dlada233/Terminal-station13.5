// THIS IS A SKYRAT UI FILE
import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const TimeClock = (props) => {
  const { act, data } = useBackend();
  const {
    inserted_id,
    insert_id_cooldown,
    id_holder_name,
    id_job_title,
    station_alert_level,
    current_time,
    clock_status,
  } = data;

  return (
    <Window title={'Time Clock'} width={500} height={250} resizable>
      <Window.Content>
        <Section>
          <Box textAlign="center" fontSize="15px">
            空间站时间 : <b>{current_time}</b>
          </Box>
          <Box textAlign="center" fontSize="15px">
            当前警报等级 : <b>{station_alert_level}</b>
          </Box>
        </Section>
        {inserted_id ? (
          <>
            <Section title={false}>
              <LabeledList>
                <LabeledList.Item label="ID持有人">
                  {id_holder_name}
                </LabeledList.Item>
                <LabeledList.Item label="当前工作">
                  {id_job_title}
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <Box>
              <Button
                width="95%"
                disabled={insert_id_cooldown}
                onClick={() => act('clock_in_or_out')}
              >
                <center>{clock_status ? '打卡上班' : '打卡下班'} </center>
              </Button>
              <Button icon="eject" onClick={() => act('eject_id')} />
            </Box>
          </>
        ) : (
          <Section title={false}>
            {' '}
            <Box fontSize="18px">
              <center>
                <b> 插入ID以进行!</b>
              </center>
            </Box>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
