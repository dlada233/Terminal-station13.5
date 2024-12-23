import { useState } from 'react';

import { useBackend } from '../../backend';
import {
  Button,
  ByondUi,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
} from '../../components';
import { formatSiUnit } from '../../format';
import { Window } from '../../layouts';
import { AccessConfig } from '../common/AccessConfig';
import { AlertPane } from './AlertPane';
import { MainData } from './data';
import { ModulesPane } from './ModulesPane';

export const Mecha = (props) => {
  const { data } = useBackend<MainData>();
  return (
    <Window theme={data.ui_theme} width={800} height={560}>
      <Window.Content>
        <Content />
      </Window.Content>
    </Window>
  );
};

export const Content = (props) => {
  const { act, data } = useBackend<MainData>();
  const [edit_access, editAccess] = useState(false);
  const {
    name,
    mecha_flags,
    mechflag_keys,
    mech_view,
    one_access,
    regions,
    accesses,
  } = data;
  const id_lock = mecha_flags & mechflag_keys['ID_LOCK_ON'];
  return (
    <Stack fill>
      <Stack.Item grow={1}>
        <Stack vertical fill>
          <Stack.Item grow overflow="hidden">
            <Section
              fill
              title={name}
              buttons={
                <Button
                  icon="edit"
                  tooltip="重命名"
                  tooltipPosition="left"
                  onClick={() => act('changename')}
                />
              }
            >
              <Stack fill vertical>
                <Stack.Item>
                  <ByondUi
                    height="170px"
                    params={{
                      id: mech_view,
                      zoom: 5,
                      type: 'map',
                    }}
                  />
                </Stack.Item>
                <Stack.Item>
                  <LabeledList>
                    <IntegrityBar />
                    <PowerBar />
                    <LightsBar />
                    <CabinSeal />
                    <DNALock />
                    <LabeledList.Item label="ID锁">
                      <Button
                        icon={id_lock ? 'lock' : 'lock-open'}
                        content={id_lock ? '开启' : '关闭'}
                        tooltipPosition="top"
                        onClick={() => {
                          editAccess(false);
                          act('toggle_id_lock');
                        }}
                        selected={id_lock}
                      />
                      {!!id_lock && (
                        <>
                          <Button
                            tooltip="编辑权限"
                            tooltipPosition="top"
                            icon="id-card-o"
                            onClick={() => editAccess(!edit_access)}
                            selected={edit_access}
                          />
                          <Button
                            tooltip={one_access ? '无需任何' : '需要所有'}
                            tooltipPosition="top"
                            icon={one_access ? 'check' : 'check-double'}
                            onClick={() => act('one_access')}
                          />
                        </>
                      )}
                    </LabeledList.Item>
                  </LabeledList>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <AlertPane />
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item grow={2}>
        {edit_access ? (
          <AccessConfig
            accesses={regions}
            selectedList={accesses}
            accessMod={(ref) =>
              act('set', {
                access: ref,
              })
            }
            grantAll={() => act('grant_all')}
            denyAll={() => act('clear_all')}
            grantDep={(ref) =>
              act('grant_region', {
                region: ref,
              })
            }
            denyDep={(ref) =>
              act('deny_region', {
                region: ref,
              })
            }
          />
        ) : (
          <ModulesPane />
        )}
      </Stack.Item>
    </Stack>
  );
};

const PowerBar = (props) => {
  const { act, data } = useBackend<MainData>();
  const { power_level, power_max } = data;
  return (
    <LabeledList.Item label="电源">
      <ProgressBar
        value={power_max ? power_level / power_max : 0}
        ranges={{
          good: [0.5, Infinity],
          average: [0.25, 0.5],
          bad: [-Infinity, 0.25],
        }}
        style={{
          textShadow: '1px 1px 0 black',
        }}
      >
        {power_max === null
          ? '电池缺失'
          : power_level === 1e31
            ? '无限'
            : `${formatSiUnit(power_level * 1000, 0, 'J')} of ${formatSiUnit(
                power_max * 1000,
                0,
                'J',
              )}`}
      </ProgressBar>
    </LabeledList.Item>
  );
};

const IntegrityBar = (props) => {
  const { act, data } = useBackend<MainData>();
  const { integrity, integrity_max, scanmod_rating } = data;
  return (
    <LabeledList.Item label="完整性">
      <ProgressBar
        value={scanmod_rating ? integrity / integrity_max : 0}
        ranges={{
          good: [0.5, Infinity],
          average: [0.25, 0.5],
          bad: [-Infinity, 0.25],
        }}
        style={{
          textShadow: '1px 1px 0 black',
        }}
      >
        {!scanmod_rating ? 'Unknown' : `${integrity} / ${integrity_max}`}
      </ProgressBar>
    </LabeledList.Item>
  );
};

const LightsBar = (props) => {
  const { act, data } = useBackend<MainData>();
  const { power_level, power_max, mecha_flags, mechflag_keys } = data;
  const has_lights = mecha_flags & mechflag_keys['HAS_LIGHTS'];
  const lights_on = mecha_flags & mechflag_keys['LIGHTS_ON'];
  return (
    <LabeledList.Item label="照明">
      <Button
        icon="lightbulb"
        content={lights_on ? '开' : '关'}
        selected={lights_on}
        disabled={!has_lights || !power_max || !power_level}
        onClick={() => act('toggle_lights')}
      />
    </LabeledList.Item>
  );
};

const CabinSeal = (props) => {
  const { act, data } = useBackend<MainData>();
  const {
    enclosed,
    cabin_sealed,
    cabin_temp,
    cabin_pressure,
    cabin_pressure_warning_min,
    cabin_pressure_hazard_min,
    cabin_pressure_warning_max,
    cabin_pressure_hazard_max,
    cabin_temp_warning_min,
    cabin_temp_hazard_min,
    cabin_temp_warning_max,
    cabin_temp_hazard_max,
  } = data;
  const temp_warning =
    cabin_temp < cabin_temp_warning_min || cabin_temp > cabin_temp_warning_max;
  const temp_hazard =
    cabin_temp < cabin_temp_hazard_min || cabin_temp > cabin_temp_hazard_max;
  const pressure_warning =
    cabin_pressure < cabin_pressure_warning_min ||
    cabin_pressure > cabin_pressure_warning_max;
  const pressure_hazard =
    cabin_pressure < cabin_pressure_hazard_min ||
    cabin_pressure > cabin_pressure_hazard_max;
  return (
    <LabeledList.Item
      label="驾驶舱空气"
      buttons={
        !!cabin_sealed && (
          <>
            <Button
              color={
                temp_hazard
                  ? 'danger'
                  : temp_warning
                    ? 'average'
                    : 'transparent'
              }
              icon="temperature-low"
              tooltipPosition="top"
              tooltip={`温度: ${cabin_temp}°C`}
            />
            <Button
              color={
                pressure_hazard
                  ? 'danger'
                  : pressure_warning
                    ? 'average'
                    : 'transparent'
              }
              icon="gauge-high"
              tooltipPosition="top"
              tooltip={`气压: ${cabin_pressure} kPa`}
            />
          </>
        )
      }
    >
      <Button
        icon={cabin_sealed ? 'mask-ventilator' : 'wind'}
        content={cabin_sealed ? '隔绝外部' : '接通外部'}
        disabled={!enclosed}
        onClick={() => act('toggle_cabin_seal')}
        selected={cabin_sealed}
      />
    </LabeledList.Item>
  );
};

const DNALock = (props) => {
  const { act, data } = useBackend<MainData>();
  const { dna_lock } = data;
  return (
    <LabeledList.Item label="DNA锁">
      <Button
        onClick={() => act('dna_lock')}
        icon="syringe"
        content={dna_lock ? '开启' : '未设置'}
        tooltip="设定新的DNA钥匙"
        selected={!!dna_lock}
        tooltipPosition="top"
      />
      {!!dna_lock && (
        <>
          <Button
            icon="key"
            tooltip={`钥匙酶: ${dna_lock}`}
            tooltipPosition="top"
            disabled={!dna_lock}
          />
          <Button
            onClick={() => act('reset_dna')}
            icon="ban"
            tooltip="重置DNA锁"
            tooltipPosition="top"
            disabled={!dna_lock}
          />
        </>
      )}
    </LabeledList.Item>
  );
};
