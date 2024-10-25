import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  RestrictedInput,
  Section,
  Stack,
} from 'tgui/components';

import { useBackend } from '../../backend';
import { CharacterPreview } from '../common/CharacterPreview';
import { EditableText } from '../common/EditableText';
import {
  MENTALSTATUS2COLOR,
  MENTALSTATUS2DESC,
  MENTALSTATUS2ICON,
  PHYSICALSTATUS2COLOR,
  PHYSICALSTATUS2DESC,
  PHYSICALSTATUS2ICON,
} from './constants';
import { getMedicalRecord, getQuirkStrings } from './helpers';
import { NoteKeeper } from './NoteKeeper';
import { MedicalRecordData } from './types';

/** Views a selected record. */
export const MedicalRecordView = (props) => {
  const foundRecord = getMedicalRecord();
  if (!foundRecord) return <NoticeBox>未选择档案.</NoticeBox>;

  const { act, data } = useBackend<MedicalRecordData>();
  const { assigned_view, physical_statuses, mental_statuses, station_z } = data;

  // const { min_age, max_age } = data; // ORIGINAL
  const { min_age, max_age, max_chrono_age } = data; // SKYRAT EDIT CHANGE - Chronological age

  const {
    age,
    chrono_age, // SKYRAT EDIT ADDITION - Chronological age
    blood_type,
    crew_ref,
    dna,
    gender,
    major_disabilities,
    minor_disabilities,
    physical_status,
    mental_status,
    name,
    quirk_notes,
    rank,
    // SKYRAT EDIT START - RP Records
    past_general_records,
    past_medical_records,
    // SKYRAT EDIT END
    species,
  } = foundRecord;

  const minor_disabilities_array = getQuirkStrings(minor_disabilities);
  const major_disabilities_array = getQuirkStrings(major_disabilities);
  const quirk_notes_array = getQuirkStrings(quirk_notes);

  return (
    <Stack fill vertical>
      <Stack.Item grow>
        <Stack fill>
          <Stack.Item>
            <CharacterPreview height="100%" id={assigned_view} />
          </Stack.Item>
          <Stack.Item grow>
            <NoteKeeper />
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item grow>
        <Section
          buttons={
            <Button.Confirm
              content="删除"
              icon="trash"
              disabled={!station_z}
              onClick={() => act('expunge_record', { crew_ref: crew_ref })}
              tooltip="Expunge record data."
            />
          }
          fill
          scrollable
          title={name}
        >
          <LabeledList>
            <LabeledList.Item label="姓名">
              <EditableText field="name" target_ref={crew_ref} text={name} />
            </LabeledList.Item>
            <LabeledList.Item label="职业">
              <EditableText field="job" target_ref={crew_ref} text={rank} />
            </LabeledList.Item>
            {/* <LabeledList.Item label="Age"> // ORIGINAL */}
            {/* SKYRAT EDIT CHANGE BEGIN - Chronological age */}
            <LabeledList.Item label="生理年龄">
              {/* SKYRAT EDIT CHANGE END */}
              <RestrictedInput
                minValue={min_age}
                maxValue={max_age}
                onEnter={(event, value) =>
                  act('edit_field', {
                    field: 'age',
                    ref: crew_ref,
                    value: value,
                  })
                }
                value={age}
              />
            </LabeledList.Item>
            {/* SKYRAT EDIT ADDITION BEGIN - Chronological age */}
            <LabeledList.Item label="存在年龄">
              <RestrictedInput
                minValue={min_age}
                maxValue={max_chrono_age}
                onEnter={(event, value) =>
                  act('edit_field', {
                    field: 'chrono_age',
                    ref: crew_ref,
                    value: value,
                  })
                }
                value={chrono_age}
              />
            </LabeledList.Item>
            {/* SKYRAT EDIT ADDITION END */}
            <LabeledList.Item label="种族">
              <EditableText
                field="species"
                target_ref={crew_ref}
                text={species}
              />
            </LabeledList.Item>
            <LabeledList.Item label="性别">
              <EditableText
                field="gender"
                target_ref={crew_ref}
                text={gender}
              />
            </LabeledList.Item>
            <LabeledList.Item label="DNA">
              <EditableText
                color="good"
                field="dna"
                target_ref={crew_ref}
                text={dna}
              />
            </LabeledList.Item>
            <LabeledList.Item color="bad" label="血型">
              <EditableText
                field="blood_type"
                target_ref={crew_ref}
                text={blood_type}
              />
            </LabeledList.Item>
            <LabeledList.Item
              buttons={physical_statuses.map((button, index) => {
                const isSelected = button === physical_status;
                return (
                  <Button
                    color={isSelected ? PHYSICALSTATUS2COLOR[button] : 'grey'}
                    height={'1.75rem'}
                    icon={PHYSICALSTATUS2ICON[button]}
                    key={index}
                    onClick={() =>
                      act('set_physical_status', {
                        crew_ref: crew_ref,
                        physical_status: button,
                      })
                    }
                    textAlign="center"
                    tooltip={PHYSICALSTATUS2DESC[button] || ''}
                    tooltipPosition="bottom-start"
                    width={!isSelected ? '3.0rem' : 3.0}
                  >
                    {button[0]}
                  </Button>
                );
              })}
              label="身体状况"
            >
              <Box color={PHYSICALSTATUS2COLOR[physical_status]}>
                {physical_status}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item
              buttons={mental_statuses.map((button, index) => {
                const isSelected = button === mental_status;
                return (
                  <Button
                    color={isSelected ? MENTALSTATUS2COLOR[button] : 'grey'}
                    height={'1.75rem'}
                    icon={MENTALSTATUS2ICON[button]}
                    key={index}
                    onClick={() =>
                      act('set_mental_status', {
                        crew_ref: crew_ref,
                        mental_status: button,
                      })
                    }
                    textAlign="center"
                    tooltip={MENTALSTATUS2DESC[button] || ''}
                    tooltipPosition="bottom-start"
                    width={!isSelected ? '3.0rem' : 3.0}
                  >
                    {button[0]}
                  </Button>
                );
              })}
              label="精神状况"
            >
              <Box color={MENTALSTATUS2COLOR[mental_status]}>
                {mental_status}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="次要障碍">
              {minor_disabilities_array.map((disability, index) => (
                <Box key={index}>&#8226; {disability}</Box>
              ))}
            </LabeledList.Item>
            <LabeledList.Item label="主要障碍">
              {major_disabilities_array.map((disability, index) => (
                <Box key={index}>&#8226; {disability}</Box>
              ))}
            </LabeledList.Item>
            <LabeledList.Item label="特质">
              {quirk_notes_array.map((quirk, index) => (
                <Box key={index}>&#8226; {quirk}</Box>
              ))}
            </LabeledList.Item>
            {/* SKYRAT EDIT START - RP Records (Not pretty but it's there) */}
            <LabeledList.Item label="一般档案">
              <Box maxWidth="100%" preserveWhitespace>
                {past_general_records || 'N/A'}
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="过往医疗档案">
              <Box maxWidth="100%" preserveWhitespace>
                {past_medical_records || 'N/A'}
              </Box>
            </LabeledList.Item>
            {/* SKYRAT EDIT END */}
          </LabeledList>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
