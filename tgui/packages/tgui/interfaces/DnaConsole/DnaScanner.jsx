import { useBackend } from '../../backend';
import {
  Box,
  Button,
  Icon,
  LabeledList,
  ProgressBar,
  Section,
} from '../../components';
import {
  SUBJECT_CONCIOUS,
  SUBJECT_DEAD,
  SUBJECT_SOFT_CRIT,
  SUBJECT_TRANSFORMING,
  SUBJECT_UNCONSCIOUS,
} from './constants';

const DnaScannerButtons = (props) => {
  const { data, act } = useBackend();
  const {
    hasDelayedAction,
    isPulsing,
    isScannerConnected,
    isScrambleReady,
    isViableSubject,
    scannerLocked,
    scannerOpen,
    scrambleSeconds,
  } = data;
  if (!isScannerConnected) {
    return (
      <Button content="连接扫描仪" onClick={() => act('connect_scanner')} />
    );
  }
  return (
    <>
      {!!hasDelayedAction && (
        <Button content="取消稍后行动" onClick={() => act('cancel_delay')} />
      )}
      {!!isViableSubject && (
        <Button
          disabled={!isScrambleReady || isPulsing}
          onClick={() => act('scramble_dna')}
        >
          重排DNA
          {!isScrambleReady && ` (${scrambleSeconds}s)`}
        </Button>
      )}
      <Box inline mr={1} />
      <Button
        icon={scannerLocked ? 'lock' : 'lock-open'}
        color={scannerLocked && 'bad'}
        disabled={scannerOpen}
        content={scannerLocked ? '已锁定' : '未锁定'}
        onClick={() => act('toggle_lock')}
      />
      <Button
        disabled={scannerLocked}
        content={scannerOpen ? '关闭' : '开启'}
        onClick={() => act('toggle_door')}
      />
    </>
  );
};

/**
 * Displays subject status based on the value of the status prop.
 */
const SubjectStatus = (props) => {
  const { status } = props;
  if (status === SUBJECT_CONCIOUS) {
    return (
      <Box inline color="good">
        意识清醒
      </Box>
    );
  }
  if (status === SUBJECT_UNCONSCIOUS) {
    return (
      <Box inline color="average">
        无意识
      </Box>
    );
  }
  if (status === SUBJECT_SOFT_CRIT) {
    return (
      <Box inline color="average">
        濒死
      </Box>
    );
  }
  if (status === SUBJECT_DEAD) {
    return (
      <Box inline color="bad">
        死亡
      </Box>
    );
  }
  if (status === SUBJECT_TRANSFORMING) {
    return (
      <Box inline color="bad">
        Transforming
      </Box>
    );
  }
  return <Box inline>未知</Box>;
};

const DnaScannerContent = (props) => {
  const { data, act } = useBackend();
  const {
    subjectName,
    isScannerConnected,
    isViableSubject,
    subjectHealth,
    subjectDamage,
    subjectStatus,
  } = data;
  if (!isScannerConnected) {
    return <Box color="bad">DNA扫描仪未连接.</Box>;
  }
  if (!isViableSubject) {
    return <Box color="average">DNA扫描仪中未检测到存活对象.</Box>;
  }
  return (
    <LabeledList>
      <LabeledList.Item label="状况">
        {subjectName}
        <Icon mx={1} color="label" name="long-arrow-alt-right" />
        <SubjectStatus status={subjectStatus} />
      </LabeledList.Item>
      <LabeledList.Item label="健康">
        <ProgressBar
          value={subjectHealth}
          minValue={0}
          maxValue={100}
          ranges={{
            olive: [101, Infinity],
            good: [70, 101],
            average: [30, 70],
            bad: [-Infinity, 30],
          }}
        >
          {subjectHealth}%
        </ProgressBar>
      </LabeledList.Item>
      <LabeledList.Item label="基因损伤">
        <ProgressBar
          value={subjectDamage}
          minValue={0}
          maxValue={100}
          ranges={{
            bad: [71, Infinity],
            average: [30, 71],
            good: [0, 30],
            olive: [-Infinity, 0],
          }}
        >
          {subjectDamage}%
        </ProgressBar>
      </LabeledList.Item>
    </LabeledList>
  );
};

export const DnaScanner = (props) => {
  return (
    <Section title="DNA 扫描仪" buttons={<DnaScannerButtons />}>
      <DnaScannerContent />
    </Section>
  );
};
