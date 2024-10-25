import { filter, uniqBy } from 'common/collections';

import { useBackend } from '../../backend';
import {
  Box,
  Button,
  Divider,
  Dropdown,
  LabeledList,
  Stack,
} from '../../components';
import {
  CHROMOSOME_NEVER,
  CHROMOSOME_NONE,
  CHROMOSOME_USED,
  MUT_COLORS,
  MUT_EXTRA,
} from './constants';

/**
 * The following predicate tests if two mutations are functionally
 * the same on the basis of their metadata. Useful if your intent is
 * to prevent "true" duplicates - i.e. mutations with identical metadata.
 */
const isSameMutation = (a, b) => {
  return a.Alias === b.Alias && a.AppliedChromo === b.AppliedChromo;
};

const ChromosomeInfo = (props) => {
  const { mutation, disabled } = props;
  const { data, act } = useBackend();
  if (mutation.CanChromo === CHROMOSOME_NEVER) {
    return <Box color="label">无相容染色体</Box>;
  }
  if (mutation.CanChromo === CHROMOSOME_NONE) {
    if (disabled) {
      return <Box color="label">无以应用染色体.</Box>;
    }
    return (
      <>
        <Dropdown
          width="240px"
          options={mutation.ValidStoredChromos}
          disabled={mutation.ValidStoredChromos.length === 0}
          selected={
            mutation.ValidStoredChromos.length === 0
              ? '无适合染色体'
              : '选择染色体'
          }
          onSelected={(e) =>
            act('apply_chromo', {
              chromo: e,
              mutref: mutation.ByondRef,
            })
          }
        />
        <Box color="label" mt={1}>
          相容染色体: {mutation.ValidChromos}
        </Box>
      </>
    );
  }
  if (mutation.CanChromo === CHROMOSOME_USED) {
    return <Box color="label">已应用染色体: {mutation.AppliedChromo}</Box>;
  }
  return null;
};

const MutationCombiner = (props) => {
  const { mutations = [], source } = props;
  const { act, data } = useBackend();

  const brefFromName = (name) => {
    return mutations.find((mutation) => mutation.Name === name)?.ByondRef;
  };

  return (
    <Dropdown
      key={source.ByondRef}
      width="240px"
      options={mutations.map((mutation) => mutation.Name)}
      disabled={mutations.length === 0}
      selected="混合突变"
      onSelected={(value) =>
        act(`combine_${source.Source}`, {
          firstref: brefFromName(value),
          secondref: source.ByondRef,
        })
      }
    />
  );
};

export const MutationInfo = (props) => {
  const { mutation } = props;
  const { data, act } = useBackend();
  const {
    diskCapacity,
    diskReadOnly,
    hasDisk,
    isInjectorReady,
    isCrisprReady,
    crisprCharges,
  } = data;
  const diskMutations = data.storage.disk ?? [];
  const mutationStorage = data.storage.console ?? [];
  const advInjectors = data.storage.injector ?? [];
  if (!mutation) {
    return <Box color="label">无内容.</Box>;
  }
  if (mutation.Source === 'occupant' && !mutation.Discovered) {
    return (
      <LabeledList>
        <LabeledList.Item label="名称">{mutation.Alias}</LabeledList.Item>
      </LabeledList>
    );
  }
  const savedToConsole = mutationStorage.find((x) =>
    isSameMutation(x, mutation),
  );
  const savedToDisk = diskMutations.find((x) => isSameMutation(x, mutation));
  const combinedMutations = filter(
    uniqBy([...diskMutations, ...mutationStorage], (mutation) => mutation.Name),
    (x) => x.Name !== mutation.Name,
  );
  return (
    <>
      <LabeledList>
        <LabeledList.Item label="名称">
          <Box inline color={MUT_COLORS[mutation.Quality]}>
            {mutation.Name}
          </Box>
        </LabeledList.Item>
        <LabeledList.Item label="描述">{mutation.Description}</LabeledList.Item>
        <LabeledList.Item label="不稳定性">
          {mutation.Instability}
        </LabeledList.Item>
      </LabeledList>
      <Divider />
      <Stack vertical>
        <Stack.Item>
          {mutation.Source === 'disk' && (
            <MutationCombiner
              disabled={!hasDisk || diskCapacity <= 0 || diskReadOnly}
              mutations={combinedMutations}
              source={mutation}
            />
          )}
          {mutation.Source === 'console' && (
            <MutationCombiner mutations={combinedMutations} source={mutation} />
          )}
        </Stack.Item>
        <Stack.Item>
          {['occupant', 'disk', 'console'].includes(mutation.Source) && (
            <Stack vertical>
              <Stack.Item>
                <Dropdown
                  width="240px"
                  options={advInjectors.map((injector) => injector.name)}
                  disabled={advInjectors.length === 0 || !mutation.Active}
                  selected="添加至高级注射器"
                  onSelected={(value) =>
                    act('add_advinj_mut', {
                      mutref: mutation.ByondRef,
                      advinj: value,
                      source: mutation.Source,
                    })
                  }
                />
              </Stack.Item>
              <Stack.Item>
                <Stack>
                  <Stack.Item>
                    <Button
                      icon="syringe"
                      disabled={!isInjectorReady || !mutation.Active}
                      onClick={() =>
                        act('print_injector', {
                          mutref: mutation.ByondRef,
                          is_activator: 1,
                          source: mutation.Source,
                        })
                      }
                    >
                      打印活化器
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="syringe"
                      disabled={!isInjectorReady || !mutation.Active}
                      onClick={() =>
                        act('print_injector', {
                          mutref: mutation.ByondRef,
                          is_activator: 0,
                          source: mutation.Source,
                        })
                      }
                    >
                      打印突变子
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="syringe"
                      disabled={!mutation.Active || !isCrisprReady}
                      onClick={() =>
                        act('crispr', {
                          mutref: mutation.ByondRef,
                          source: mutation.Source,
                        })
                      }
                    >
                      CRISPR [{crisprCharges}]
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          )}
        </Stack.Item>
        <Stack.Item>
          <Stack>
            {['disk', 'occupant'].includes(mutation.Source) && (
              <Stack.Item>
                <Button
                  icon="save"
                  disabled={savedToConsole || !mutation.Active}
                  content="保存至终端"
                  onClick={() =>
                    act('save_console', {
                      mutref: mutation.ByondRef,
                      source: mutation.Source,
                    })
                  }
                />
              </Stack.Item>
            )}
            {['console', 'occupant'].includes(mutation.Source) && (
              <Stack.Item>
                <Button
                  icon="save"
                  disabled={
                    savedToDisk ||
                    !hasDisk ||
                    diskCapacity <= 0 ||
                    diskReadOnly ||
                    !mutation.Active
                  }
                  content="保存至磁盘"
                  onClick={() =>
                    act('save_disk', {
                      mutref: mutation.ByondRef,
                      source: mutation.Source,
                    })
                  }
                />
              </Stack.Item>
            )}
            {['console', 'disk', 'injector'].includes(mutation.Source) && (
              <Stack.Item>
                <Button
                  icon="times"
                  color="red"
                  content={`从${mutation.Source}中删除`}
                  onClick={() =>
                    act(`delete_${mutation.Source}_mut`, {
                      mutref: mutation.ByondRef,
                    })
                  }
                />
              </Stack.Item>
            )}
            {(mutation.Class === MUT_EXTRA ||
              (!!mutation.Scrambled && mutation.Source === 'occupant')) && (
              <Stack.Item>
                <Button
                  content="取消"
                  onClick={() =>
                    act('nullify', {
                      mutref: mutation.ByondRef,
                    })
                  }
                />
              </Stack.Item>
            )}
          </Stack>
          <Divider />
          <ChromosomeInfo
            disabled={mutation.Source !== 'occupant'}
            mutation={mutation}
          />
        </Stack.Item>
      </Stack>
    </>
  );
};
