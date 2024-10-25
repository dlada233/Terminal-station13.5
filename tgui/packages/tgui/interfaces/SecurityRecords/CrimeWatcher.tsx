import { useState } from 'react';
import { useBackend, useLocalState } from 'tgui/backend';
import {
  BlockQuote,
  Box,
  Button,
  Collapsible,
  Icon,
  Input,
  LabeledList,
  NoticeBox,
  RestrictedInput,
  Section,
  Stack,
  Tabs,
  TextArea,
  Tooltip,
} from 'tgui/components';

import { getSecurityRecord } from './helpers';
import { Crime, SECURETAB, SecurityRecordsData } from './types';

/** Displays a list of crimes and allows to add new ones. */
export const CrimeWatcher = (props) => {
  const foundRecord = getSecurityRecord();
  if (!foundRecord) return <> </>;

  const { crimes, citations } = foundRecord;
  const [selectedTab, setSelectedTab] = useLocalState<SECURETAB>(
    'selectedTab',
    SECURETAB.Crimes,
  );

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Tabs fluid>
          <Tabs.Tab
            onClick={() => setSelectedTab(SECURETAB.Crimes)}
            selected={selectedTab === SECURETAB.Crimes}
          >
            罪名: {crimes.length}
          </Tabs.Tab>
          <Tabs.Tab
            onClick={() => setSelectedTab(SECURETAB.Citations)}
            selected={selectedTab === SECURETAB.Citations}
          >
            传讯: {citations.length}
          </Tabs.Tab>
          <Tooltip content="添加新的罪名或传讯" position="bottom">
            <Tabs.Tab
              onClick={() => setSelectedTab(SECURETAB.Add)}
              selected={selectedTab === SECURETAB.Add}
            >
              <Icon name="plus" />
            </Tabs.Tab>
          </Tooltip>
        </Tabs>
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
          {selectedTab < SECURETAB.Add ? (
            <CrimeList tab={selectedTab} />
          ) : (
            <CrimeAuthor />
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

/** Displays the crimes and citations of a record. */
const CrimeList = (props) => {
  const foundRecord = getSecurityRecord();
  if (!foundRecord) return <> </>;

  const { citations, crimes } = foundRecord;
  const { tab } = props;
  const toDisplay = tab === SECURETAB.Crimes ? crimes : citations;

  return (
    <Stack fill vertical>
      {!toDisplay.length ? (
        <Stack.Item>
          <NoticeBox>无{tab === SECURETAB.Crimes ? '罪名' : '传讯'}.</NoticeBox>
        </Stack.Item>
      ) : (
        toDisplay.map((item, index) => <CrimeDisplay key={index} item={item} />)
      )}
    </Stack>
  );
};

/** Displays an individual crime */
const CrimeDisplay = ({ item }: { item: Crime }) => {
  const foundRecord = getSecurityRecord();
  if (!foundRecord) return <> </>;

  const { crew_ref } = foundRecord;
  const { act, data } = useBackend<SecurityRecordsData>();
  const { current_user, higher_access } = data;
  const { author, crime_ref, details, fine, name, paid, time, valid } = item;
  const showFine = !!fine && fine > 0 ? `: ${fine} cr` : '';

  let collapsibleColor = '';
  if (!valid) {
    collapsibleColor = 'grey';
  } else if (fine && fine > 0) {
    collapsibleColor = 'average';
  }

  let displayTitle = name;
  if (fine && fine > 0) {
    displayTitle = name.slice(0, 18) + showFine;
  }

  const [editing, setEditing] = useLocalState(`editing_${crime_ref}`, false);

  return (
    <Stack.Item>
      <Collapsible color={collapsibleColor} open={editing} title={displayTitle}>
        <LabeledList>
          <LabeledList.Item label="时间">{time}</LabeledList.Item>
          <LabeledList.Item label="发起人">{author}</LabeledList.Item>
          <LabeledList.Item color={!valid ? 'bad' : 'good'} label="状态">
            {!valid ? '无效' : '生效'}
          </LabeledList.Item>
          {fine && (
            <>
              <LabeledList.Item color="bad" label="罚款">
                {fine}cr <Icon color="gold" name="coins" />
              </LabeledList.Item>
              <LabeledList.Item color="good" label="交纳">
                {paid}cr <Icon color="gold" name="coins" />
              </LabeledList.Item>
            </>
          )}
        </LabeledList>
        <Box color="label" mt={1} mb={1}>
          Details:
        </Box>
        <BlockQuote>{details}</BlockQuote>

        {!editing ? (
          <Box mt={2}>
            <Button
              disabled={!valid || (!higher_access && author !== current_user)}
              icon="pen"
              onClick={() => setEditing(true)}
            >
              Edit
            </Button>
            <Button.Confirm
              content="使之无效"
              disabled={!higher_access || !valid}
              icon="ban"
              onClick={() =>
                act('invalidate_crime', {
                  crew_ref: crew_ref,
                  crime_ref: crime_ref,
                })
              }
            />
          </Box>
        ) : (
          <>
            <Input
              fluid
              maxLength={25}
              onEscape={() => setEditing(false)}
              onEnter={(event, value) => {
                setEditing(false);
                act('edit_crime', {
                  crew_ref: crew_ref,
                  crime_ref: crime_ref,
                  name: value,
                });
              }}
              placeholder="输入新名称"
            />
            <Input
              fluid
              maxLength={1025}
              mt={1}
              onEscape={() => setEditing(false)}
              onEnter={(event, value) => {
                setEditing(false);
                act('edit_crime', {
                  crew_ref: crew_ref,
                  crime_ref: crime_ref,
                  description: value,
                });
              }}
              placeholder="输入新描述"
            />
          </>
        )}
      </Collapsible>
    </Stack.Item>
  );
};

/** Writes a new crime. Reducers don't seem to work here, so... */
const CrimeAuthor = (props) => {
  const foundRecord = getSecurityRecord();
  if (!foundRecord) return <> </>;

  const { crew_ref } = foundRecord;
  const { act } = useBackend<SecurityRecordsData>();

  const [crimeName, setCrimeName] = useState('');
  const [crimeDetails, setCrimeDetails] = useState('');
  const [crimeFine, setCrimeFine] = useState(0);
  const [selectedTab, setSelectedTab] = useLocalState<SECURETAB>(
    'selectedTab',
    SECURETAB.Crimes,
  );

  const nameMeetsReqs = crimeName?.length > 2;

  /** Sends form to backend */
  const createCrime = () => {
    if (!crimeName) return;
    act('add_crime', {
      crew_ref: crew_ref,
      details: crimeDetails,
      fine: crimeFine,
      name: crimeName,
    });
    reset();
  };

  /** Resets form data since it persists.. */
  const reset = () => {
    setCrimeDetails('');
    setCrimeFine(0);
    setCrimeName('');
    setSelectedTab(crimeFine ? SECURETAB.Citations : SECURETAB.Crimes);
  };

  return (
    <Stack fill vertical>
      <Stack.Item color="label">
        Name
        <Input
          fluid
          maxLength={25}
          onChange={(_, value) => setCrimeName(value)}
          placeholder="简要概述"
        />
      </Stack.Item>
      <Stack.Item color="label">
        Details
        <TextArea
          fluid
          height={4}
          maxLength={1025}
          onChange={(_, value) => setCrimeDetails(value)}
          placeholder="输入详细信息..."
        />
      </Stack.Item>
      <Stack.Item color="label">
        Fine (leave blank to arrest)
        <RestrictedInput
          onChange={(_, value) => setCrimeFine(value)}
          fluid
          maxValue={1000}
        />
      </Stack.Item>
      <Stack.Item>
        <Button.Confirm
          content="创建"
          disabled={!nameMeetsReqs}
          icon="plus"
          onClick={createCrime}
          tooltip={!nameMeetsReqs ? '名字至少需要3个字符.' : ''}
        />
      </Stack.Item>
    </Stack>
  );
};
