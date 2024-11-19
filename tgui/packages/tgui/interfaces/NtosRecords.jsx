import { createSearch } from 'common/string';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Icon, Input, Section } from '../components';
import { NtosWindow } from '../layouts';

export const NtosRecords = (props) => {
  const { act, data } = useBackend();
  const [searchTerm, setSearchTerm] = useState('');
  const { mode, records } = data;

  const isMatchingSearchTerms = createSearch(searchTerm);

  return (
    <NtosWindow width={600} height={800}>
      <NtosWindow.Content scrollable>
        <Section textAlign="center">纳米传讯人事档案 (机密)</Section>
        <Section>
          <Input
            placeholder={'筛选结果...'}
            value={searchTerm}
            fluid
            textAlign="center"
            onChange={(e, value) => setSearchTerm(value)}
          />
        </Section>
        {mode === 'security' &&
          records.map((record) => (
            <Section
              key={record.id}
              hidden={
                !(
                  searchTerm === '' ||
                  isMatchingSearchTerms(
                    record.name +
                      ' ' +
                      record.rank +
                      ' ' +
                      record.species +
                      ' ' +
                      record.gender +
                      ' ' +
                      record.age +
                      ' ' +
                      /* SKYRAT EDIT ADDITION BEGIN - Chronological age */
                      record.chrono_age +
                      ' ' +
                      /* SKYRAT EDIT ADDITION END */
                      record.fingerprint,
                  )
                )
              }
            >
              <Box bold>
                <Icon name="user" mr={1} />
                {record.name}
              </Box>
              <br />
              等级: {record.rank}
              <br />
              种族: {record.species}
              <br />
              性别: {record.gender}
              <br />
              {/* SKYRAT EDIT CHANGE - Chronological age, ORIGINAL: Age: {record.age} */}
              生理年龄: {record.age}
              {/* SKYRAT EDIT CHANGE END */}
              <br />
              {/* SKYRAT EDIT ADDITION BEGIN - Chronological age */}
              存在年龄: {record.chrono_age}
              <br />
              {/* SKYRAT EDIT ADDITION END */}
              指纹码: {record.fingerprint}
              <br />
              <br />
              犯罪情况: {record.wanted || '被删除'}
            </Section>
          ))}
        {mode === 'medical' &&
          records.map((record) => (
            <Section
              key={record.id}
              hidden={
                !(
                  searchTerm === '' ||
                  isMatchingSearchTerms(
                    record.name +
                      ' ' +
                      record.bloodtype +
                      ' ' +
                      record.mental_status +
                      ' ' +
                      record.physical_status,
                  )
                )
              }
            >
              <Box bold>
                <Icon name="user" mr={1} />
                {record.name}
              </Box>
              <br />
              {/* SKYRAT EDIT ADDITION BEGIN - Chronological age */}
              生理年龄: {record.age}
              <br />
              存在年龄: {record.chrono_age}
              <br />
              {/* SKYRAT EDIT ADDITION END */}
              血型: {record.bloodtype}
              <br />
              次要障碍: {record.mi_dis}
              <br />
              主要障碍: {record.ma_dis}
              <br />
              <br />
              病历注释: {record.notes}
              <br />
              病历注释续: {record.cnotes}
            </Section>
          ))}
      </NtosWindow.Content>
    </NtosWindow>
  );
};
