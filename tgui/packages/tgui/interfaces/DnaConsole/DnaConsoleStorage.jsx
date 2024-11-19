import { uniqBy } from 'common/collections';

import { useBackend } from '../../backend';
import {
  Box,
  Button,
  Collapsible,
  LabeledList,
  Section,
  Stack,
  Tabs,
} from '../../components';
import {
  STORAGE_CONS_SUBMODE_CHROMOSOMES,
  STORAGE_CONS_SUBMODE_MUTATIONS,
  STORAGE_DISK_SUBMODE_ENZYMES,
  STORAGE_DISK_SUBMODE_MUTATIONS,
  STORAGE_MODE_ADVINJ,
  STORAGE_MODE_CONSOLE,
  STORAGE_MODE_DISK,
} from './constants';
import { GeneticMakeupInfo } from './GeneticMakeupInfo';
import { MutationInfo } from './MutationInfo';

export const DnaConsoleStorage = (props) => {
  const { data, act } = useBackend();
  const { storageMode, storageConsSubMode, storageDiskSubMode } = data.view;
  const { diskMakeupBuffer, diskHasMakeup } = data;
  const mutations = data.storage[storageMode];

  return (
    <Section fill title="存储" buttons={<StorageButtons />}>
      {storageMode === STORAGE_MODE_CONSOLE &&
        storageConsSubMode === STORAGE_CONS_SUBMODE_MUTATIONS && (
          <StorageMutations mutations={mutations} />
        )}
      {storageMode === STORAGE_MODE_CONSOLE &&
        storageConsSubMode === STORAGE_CONS_SUBMODE_CHROMOSOMES && (
          <StorageChromosomes />
        )}
      {storageMode === STORAGE_MODE_DISK &&
        storageDiskSubMode === STORAGE_DISK_SUBMODE_MUTATIONS && (
          <StorageMutations mutations={mutations} />
        )}
      {storageMode === STORAGE_MODE_DISK &&
        storageDiskSubMode === STORAGE_DISK_SUBMODE_ENZYMES && (
          <>
            <GeneticMakeupInfo makeup={diskMakeupBuffer} />
            <Button
              icon="times"
              color="red"
              disabled={!diskHasMakeup}
              content={'删除'}
              onClick={() => act('del_makeup_disk')}
            />
          </>
        )}
      {storageMode === STORAGE_MODE_ADVINJ && <DnaConsoleAdvancedInjectors />}
    </Section>
  );
};

const DnaConsoleAdvancedInjectors = (props) => {
  const { act, data } = useBackend();
  const { maxAdvInjectors, isInjectorReady } = data;
  const advInjectors = data.storage.injector ?? [];

  return (
    <Section fill title="高级注射器">
      {advInjectors.map((injector) => (
        <Collapsible
          key={injector.name}
          title={injector.name}
          buttons={
            <>
              <Button
                icon="syringe"
                disabled={!isInjectorReady}
                content="Print"
                onClick={() =>
                  act('print_adv_inj', {
                    name: injector.name,
                  })
                }
              />
              <Button
                ml={1}
                color="red"
                icon="times"
                onClick={() =>
                  act('del_adv_inj', {
                    name: injector.name,
                  })
                }
              />
            </>
          }
        >
          <StorageMutations
            mutations={injector.mutations}
            customMode={`advinj${advInjectors.findIndex(
              (e) => injector.name === e.name,
            )}`}
          />
        </Collapsible>
      ))}
      <Box mt={2}>
        <Button.Input
          minWidth="200px"
          content="生成新注射器"
          disabled={advInjectors.length >= maxAdvInjectors}
          onCommit={(e, value) =>
            act('new_adv_inj', {
              name: value,
            })
          }
        />
      </Box>
    </Section>
  );
};

const StorageButtons = (props) => {
  const { data, act } = useBackend();
  const { hasDisk } = data;
  const { storageMode, storageConsSubMode, storageDiskSubMode } = data.view;

  return (
    <>
      {storageMode === STORAGE_MODE_CONSOLE && (
        <>
          <Button
            selected={storageConsSubMode === STORAGE_CONS_SUBMODE_MUTATIONS}
            content="突变"
            onClick={() =>
              act('set_view', {
                storageConsSubMode: STORAGE_CONS_SUBMODE_MUTATIONS,
              })
            }
          />
          <Button
            selected={storageConsSubMode === STORAGE_CONS_SUBMODE_CHROMOSOMES}
            content="染色体"
            onClick={() =>
              act('set_view', {
                storageConsSubMode: STORAGE_CONS_SUBMODE_CHROMOSOMES,
              })
            }
          />
        </>
      )}
      {storageMode === STORAGE_MODE_DISK && (
        <>
          <Button
            selected={storageDiskSubMode === STORAGE_CONS_SUBMODE_MUTATIONS}
            content="突变"
            onClick={() =>
              act('set_view', {
                storageDiskSubMode: STORAGE_CONS_SUBMODE_MUTATIONS,
              })
            }
          />
          <Button
            selected={storageDiskSubMode === STORAGE_DISK_SUBMODE_ENZYMES}
            content="DNA酶"
            onClick={() =>
              act('set_view', {
                storageDiskSubMode: STORAGE_DISK_SUBMODE_ENZYMES,
              })
            }
          />
        </>
      )}
      <Box inline mr={1} />
      <Button
        content="终端"
        selected={storageMode === STORAGE_MODE_CONSOLE}
        onClick={() =>
          act('set_view', {
            storageMode: STORAGE_MODE_CONSOLE,
            storageConsSubMode:
              STORAGE_CONS_SUBMODE_MUTATIONS ?? storageConsSubMode,
          })
        }
      />
      <Button
        content="软盘"
        disabled={!hasDisk}
        selected={storageMode === STORAGE_MODE_DISK}
        onClick={() =>
          act('set_view', {
            storageMode: STORAGE_MODE_DISK,
            storageDiskSubMode:
              STORAGE_DISK_SUBMODE_MUTATIONS ?? storageDiskSubMode,
          })
        }
      />
      <Button
        content="高级注射器"
        selected={storageMode === STORAGE_MODE_ADVINJ}
        onClick={() =>
          act('set_view', {
            storageMode: STORAGE_MODE_ADVINJ,
          })
        }
      />
    </>
  );
};

const StorageChromosomes = (props) => {
  const { data, act } = useBackend();
  const chromos = data.chromoStorage ?? [];
  const uniqueChromos = uniqBy(chromos, (chromo) => chromo.Name);
  const chromoName = data.view.storageChromoName;
  const chromo = chromos.find((chromo) => chromo.Name === chromoName);

  return (
    <Stack fill>
      <Stack.Item width="140px">
        <Section fill scrollable>
          <Tabs vertical>
            {uniqueChromos.map((chromo) => (
              <Tabs.Tab
                className="candystripe"
                key={chromo.Index}
                selected={chromo.Name === chromoName}
                onClick={() =>
                  act('set_view', {
                    storageChromoName: chromo.Name,
                  })
                }
              >
                {chromo.Name}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Stack.Divider />
      </Stack.Item>
      <Stack.Item grow>
        <Section title="染色体信息">
          {(!chromo && <Box color="label">无可显示内容.</Box>) || (
            <>
              <LabeledList>
                <LabeledList.Item label="名称">{chromo.Name}</LabeledList.Item>
                <LabeledList.Item label="描述">
                  {chromo.Description}
                </LabeledList.Item>
                <LabeledList.Item label="数量">
                  {chromos.filter((x) => x.Name === chromo.Name).length}
                </LabeledList.Item>
              </LabeledList>
              <Button
                mt={2}
                icon="eject"
                content={'弹出染色体'}
                onClick={() =>
                  act('eject_chromo', {
                    chromo: chromo.Name,
                  })
                }
              />
            </>
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const StorageMutations = (props) => {
  const { customMode = '' } = props;
  const { data, act } = useBackend();
  const mutations = props.mutations || [];
  const mode = data.view.storageMode + customMode;
  let mutationRef = data.view[`storage${mode}MutationRef`];
  let mutation = mutations.find(
    (mutation) => mutation.ByondRef === mutationRef,
  );
  // If no mutation is selected but there are stored mutations, pick the first
  // mutation and set that as the currently showed one.
  if (!mutation && mutations.length > 0) {
    mutation = mutations[0];
    mutationRef = mutation.ByondRef;
  }

  return (
    <Stack fill>
      <Stack.Item width="140px">
        <Section fill scrollable>
          <Tabs vertical>
            {mutations.map((mutation) => (
              <Tabs.Tab
                className="candystripe"
                key={mutation.ByondRef}
                selected={mutation.ByondRef === mutationRef}
                onClick={() =>
                  act('set_view', {
                    [`storage${mode}MutationRef`]: mutation.ByondRef,
                  })
                }
              >
                {mutation.Name}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Stack.Divider />
      </Stack.Item>
      <Stack.Item grow>
        <Section title="突变信息">
          <MutationInfo mutation={mutation} />
        </Section>
      </Stack.Item>
    </Stack>
  );
};
