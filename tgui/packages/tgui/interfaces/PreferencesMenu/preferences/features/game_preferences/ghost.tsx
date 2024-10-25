import { binaryInsertWith } from 'common/collections';
import { classes } from 'common/react';
import { ReactNode } from 'react';

import { useBackend } from '../../../../../backend';
import { Box, Dropdown, Flex } from '../../../../../components';
import { PreferencesMenuData } from '../../../data';
import {
  CheckboxInput,
  FeatureChoiced,
  FeatureChoicedServerData,
  FeatureToggle,
  FeatureValueProps,
} from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const ghost_accs: FeatureChoiced = {
  name: '幽灵附件',
  category: 'GHOST',
  description: '决定你的幽灵会有什么调整项目.',
  component: FeatureDropdownInput,
};

type GhostForm = {
  displayText: ReactNode;
  value: string;
};

const insertGhostForm = (collection: GhostForm[], value: GhostForm) =>
  binaryInsertWith(collection, value, ({ value }) => value);

const GhostFormInput = (
  props: FeatureValueProps<string, string, FeatureChoicedServerData>,
) => {
  const { data } = useBackend<PreferencesMenuData>();

  const serverData = props.serverData;
  if (!serverData) {
    return <> </>;
  }

  const displayNames = serverData.display_names;
  if (!displayNames) {
    return <Box color="red">No display names for ghost_form!</Box>;
  }

  const displayTexts = {};
  let options: {
    displayText: ReactNode;
    value: string;
  }[] = [];

  for (const [name, displayName] of Object.entries(displayNames)) {
    const displayText = (
      <Flex key={name}>
        <Flex.Item>
          <Box
            className={classes([`preferences32x32`, serverData.icons![name]])}
          />
        </Flex.Item>

        <Flex.Item grow={1}>{displayName}</Flex.Item>
      </Flex>
    );

    displayTexts[name] = displayText;

    const optionEntry = {
      displayText,
      value: name,
    };

    // Put the default ghost on top
    if (name === 'ghost') {
      options.unshift(optionEntry);
    } else {
      options = insertGhostForm(options, optionEntry);
    }
  }

  return (
    <Dropdown
      autoScroll={false}
      disabled={!data.content_unlocked}
      selected={props.value}
      placeholder={displayTexts[props.value]}
      onSelected={props.handleSetValue}
      width="100%"
      options={options}
    />
  );
};

export const ghost_form: FeatureChoiced = {
  name: '幽灵外表',
  category: 'GHOST',
  description: '幽灵的外表. 需要BYOND注册用户.',
  component: GhostFormInput,
};

export const ghost_hud: FeatureToggle = {
  name: '幽灵HUD',
  category: 'GHOST',
  description: '开启幽灵HUD.',
  component: CheckboxInput,
};

export const ghost_orbit: FeatureChoiced = {
  name: '幽灵运动',
  category: 'GHOST',
  description: `
    你的幽灵将以怎样形式环绕运动.
    需要BYOND注册用户.
  `,
  component: (
    props: FeatureValueProps<string, string, FeatureChoicedServerData>,
  ) => {
    const { data } = useBackend<PreferencesMenuData>();

    return (
      <FeatureDropdownInput {...props} disabled={!data.content_unlocked} />
    );
  },
};

export const ghost_others: FeatureChoiced = {
  name: '其他幽灵',
  category: 'GHOST',
  description: `
    是否希望能看到其他人为自己设置的幽灵外表，否则将全部显示默认白色幽灵.
  `,
  component: FeatureDropdownInput,
};

export const inquisitive_ghost: FeatureToggle = {
  name: '好奇幽灵',
  category: 'GHOST',
  description: '点击某物会检视它.',
  component: CheckboxInput,
};

export const ghost_roles: FeatureToggle = {
  name: '获取幽灵角色',
  category: 'GHOST',
  description: `
    如果你取消此项，那么当扮演幽灵时你不会得到任何弹出信息.
`,
  component: CheckboxInput,
};
