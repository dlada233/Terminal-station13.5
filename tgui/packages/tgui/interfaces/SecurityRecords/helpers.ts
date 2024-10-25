import { useBackend, useLocalState } from 'tgui/backend';

import { PRINTOUT, SecurityRecord, SecurityRecordsData } from './types';

/** We need an active reference and this a pain to rewrite */
export const getSecurityRecord = () => {
  const [selectedRecord] = useLocalState<SecurityRecord | undefined>(
    'securityRecord',
    undefined,
  );
  if (!selectedRecord) return;
  const { data } = useBackend<SecurityRecordsData>();
  const { records = [] } = data;
  const foundRecord = records.find(
    (record) => record.crew_ref === selectedRecord.crew_ref,
  );
  if (!foundRecord) return;

  return foundRecord;
};

// Lazy type union
type GenericRecord = {
  name: string;
  rank: string;
  fingerprint?: string;
  dna?: string;
};

/** Matches search by fingerprint, dna, job, or name */
export const isRecordMatch = (record: GenericRecord, search: string) => {
  if (!search) return true;
  const { name, rank, fingerprint, dna } = record;

  switch (true) {
    case name?.toLowerCase().includes(search?.toLowerCase()):
    case rank?.toLowerCase().includes(search?.toLowerCase()):
    case fingerprint?.toLowerCase().includes(search?.toLowerCase()):
    case dna?.toLowerCase().includes(search?.toLowerCase()):
      return true;

    default:
      return false;
  }
};

/** Returns a string header based on print type */
export const getDefaultPrintHeader = (printType: PRINTOUT) => {
  switch (printType) {
    case PRINTOUT.Rapsheet:
      return '记录在案';
    case PRINTOUT.Wanted:
      return '通缉';
    case PRINTOUT.Missing:
      return '失踪';
  }
};

/** Returns a string description based on print type */
export const getDefaultPrintDescription = (
  name: string,
  printType: PRINTOUT,
) => {
  switch (printType) {
    case PRINTOUT.Rapsheet:
      return `一份${name}的前科记录.`;
    case PRINTOUT.Wanted:
      return `一张针对${name}的纳米传讯通缉令, 由任何发现请立即向安保部门报告.`;
    case PRINTOUT.Missing:
      return `一张针对${name}的寻人令, 此人现已失踪，有任何发现请立即向安保部门报告.`;
  }
};
